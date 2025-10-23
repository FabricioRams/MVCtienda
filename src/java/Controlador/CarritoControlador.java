package Controlador;

import Modelo.ItemCarrito;
import Modelo.Producto;
import Modelo.Usuario;
import ModeloDao.ProductoDAO;
import Util.EmailService;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.UUID;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "CarritoControlador", urlPatterns = {"/CarritoControlador"})
public class CarritoControlador extends HttpServlet {

    String verCarrito = "VistaCarrito/carrito.jsp";
    String pagarCarrito = "VistaCarrito/pagar.jsp";
    String confirmarCompra = "VistaCarrito/confirmacion.jsp";
    String esperandoConfirmacion = "VistaCarrito/esperando.jsp";
    ProductoDAO dao = new ProductoDAO();
    
    // Almacenamiento temporal de tokens de confirmación (en producción usar base de datos)
    private static Map<String, DatosCompra> comprasPendientes = new HashMap<>();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String acceso = "";
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        List<ItemCarrito> carrito = (List<ItemCarrito>) session.getAttribute("carrito");
        if (carrito == null) {
            carrito = new ArrayList<>();
            session.setAttribute("carrito", carrito);
        }
        
        if (action != null) {
            switch (action) {
                case "agregar":
                    int idProducto = Integer.parseInt(request.getParameter("id"));
                    Producto p = dao.obtenerPorId(idProducto);
                    
                    if (p != null && p.getStock() > 0) {
                        boolean existe = false;
                        for (ItemCarrito item : carrito) {
                            if (item.getIdProducto() == idProducto) {
                                if (item.getCantidad() < p.getStock()) {
                                    item.setCantidad(item.getCantidad() + 1);
                                }
                                existe = true;
                                break;
                            }
                        }
                        
                        if (!existe) {
                            ItemCarrito nuevoItem = new ItemCarrito();
                            nuevoItem.setIdProducto(p.getIdProducto());
                            nuevoItem.setNombre(p.getNombre());
                            nuevoItem.setPrecio(p.getPrecio());
                            nuevoItem.setCantidad(1);
                            nuevoItem.setNombreColor(p.getNombreColor());
                            nuevoItem.setValorTalla(p.getValorTalla());
                            nuevoItem.setNombreModelo(p.getNombreModelo());
                            nuevoItem.setNombreMarca(p.getNombreMarca());
                            carrito.add(nuevoItem);
                        }
                        session.setAttribute("mensaje", "Producto agregado al carrito");
                    }
                    response.sendRedirect("ProductoControlador?action=catalogo");
                    return;
                    
                case "ver":
                    acceso = verCarrito;
                    break;
                    
                case "actualizar":
                    int idActualizar = Integer.parseInt(request.getParameter("id"));
                    int nuevaCantidad = Integer.parseInt(request.getParameter("cantidad"));
                    
                    for (ItemCarrito item : carrito) {
                        if (item.getIdProducto() == idActualizar) {
                            Producto prod = dao.obtenerPorId(idActualizar);
                            if (prod != null && nuevaCantidad <= prod.getStock() && nuevaCantidad > 0) {
                                item.setCantidad(nuevaCantidad);
                            }
                            break;
                        }
                    }
                    acceso = verCarrito;
                    break;
                    
                case "eliminar":
                    int idEliminar = Integer.parseInt(request.getParameter("id"));
                    carrito.removeIf(item -> item.getIdProducto() == idEliminar);
                    acceso = verCarrito;
                    break;
                    
                case "pagar":
                    if (carrito.isEmpty()) {
                        response.sendRedirect("CarritoControlador?action=ver");
                        return;
                    }
                    acceso = pagarCarrito;
                    break;
                    
                case "confirmar":
                    String metodoPago = request.getParameter("metodoPago");
                    
                    if (metodoPago != null && !carrito.isEmpty()) {
                        // Obtener datos del usuario
                        Usuario usuario = (Usuario) session.getAttribute("usuario");
                        if (usuario == null || usuario.getEmail() == null || usuario.getEmail().isEmpty()) {
                            request.setAttribute("error", "Necesitas tener un correo registrado para realizar compras");
                            acceso = verCarrito;
                            break;
                        }
                        
                        // Generar token único
                        String tokenCompra = UUID.randomUUID().toString();
                        
                        // Calcular total
                        double total = 0;
                        for (ItemCarrito item : carrito) {
                            total += item.getSubtotal();
                        }
                        
                        // Guardar datos de la compra pendiente
                        DatosCompra datosCompra = new DatosCompra();
                        datosCompra.carrito = new ArrayList<>(carrito);
                        datosCompra.total = total;
                        datosCompra.metodoPago = metodoPago;
                        datosCompra.emailUsuario = usuario.getEmail();
                        datosCompra.nombreUsuario = usuario.getNombre() + " " + usuario.getApellido();
                        datosCompra.timestamp = System.currentTimeMillis();
                        
                        comprasPendientes.put(tokenCompra, datosCompra);
                        
                        // Obtener URL base
                        String urlBase = request.getScheme() + "://" + 
                                       request.getServerName() + ":" + 
                                       request.getServerPort() + 
                                       request.getContextPath();
                        
                        // Enviar correo de confirmación
                        boolean emailEnviado = EmailService.enviarCorreoConfirmacionCompra(
                            usuario.getEmail(),
                            datosCompra.nombreUsuario,
                            carrito,
                            total,
                            metodoPago,
                            tokenCompra,
                            urlBase
                        );
                        
                        if (emailEnviado) {
                            session.setAttribute("mensajeConfirmacion", 
                                "Hemos enviado un correo de confirmación a " + usuario.getEmail() + 
                                ". Por favor, revisa tu bandeja de entrada y confirma tu compra.");
                            acceso = esperandoConfirmacion;
                        } else {
                            request.setAttribute("error", "Error al enviar correo de confirmación");
                            acceso = pagarCarrito;
                        }
                    } else {
                        response.sendRedirect("CarritoControlador?action=pagar");
                        return;
                    }
                    break;
                    
                case "confirmarCompra":
                    String token = request.getParameter("token");
                    
                    if (token != null && comprasPendientes.containsKey(token)) {
                        DatosCompra datos = comprasPendientes.get(token);
                        
                        // Verificar que no haya expirado (30 minutos)
                        long tiempoTranscurrido = System.currentTimeMillis() - datos.timestamp;
                        if (tiempoTranscurrido > 30 * 60 * 1000) {
                            comprasPendientes.remove(token);
                            request.setAttribute("error", "El enlace de confirmación ha expirado. Por favor, intenta realizar la compra nuevamente.");
                            response.sendRedirect("CarritoControlador?action=ver");
                            return;
                        }
                        
                        // Actualizar stock
                        boolean todosActualizados = true;
                        for (ItemCarrito item : datos.carrito) {
                            boolean actualizado = dao.actualizarStock(item.getIdProducto(), item.getCantidad());
                            if (!actualizado) {
                                todosActualizados = false;
                                break;
                            }
                        }
                        
                        if (todosActualizados) {
                            // Generar número de pedido
                            Random random = new Random();
                            int numeroPedido = 10000 + random.nextInt(90000);
                            
                            // Enviar correo con PDF
                            boolean pdfEnviado = EmailService.enviarCorreoConPDFCompra(
                                datos.emailUsuario,
                                datos.nombreUsuario,
                                datos.carrito,
                                datos.total,
                                datos.metodoPago,
                                numeroPedido
                            );
                            
                            // Guardar para mostrar confirmación
                            session.setAttribute("ultimaCompra", datos.carrito);
                            session.setAttribute("metodoPagoUsado", datos.metodoPago);
                            session.setAttribute("numeroPedidoGenerado", numeroPedido);
                            
                            // Limpiar carrito y token
                            List<ItemCarrito> carritoActual = (List<ItemCarrito>) session.getAttribute("carrito");
                            if (carritoActual != null) {
                                carritoActual.clear();
                            }
                            comprasPendientes.remove(token);
                            
                            if (pdfEnviado) {
                                session.setAttribute("mensajePDF", 
                                    "Se ha enviado el comprobante de compra a tu correo electrónico.");
                            }
                            
                            acceso = confirmarCompra;
                        } else {
                            request.setAttribute("error", "No hay suficiente stock para algunos productos");
                            acceso = verCarrito;
                        }
                    } else {
                        request.setAttribute("error", "Token de confirmación inválido o expirado");
                        response.sendRedirect("CarritoControlador?action=ver");
                        return;
                    }
                    break;
                    
                case "limpiar":
                    carrito.clear();
                    response.sendRedirect("ProductoControlador?action=catalogo");
                    return;
                    
                default:
                    acceso = verCarrito;
                    break;
            }
        } else {
            acceso = verCarrito;
        }

        RequestDispatcher vista = request.getRequestDispatcher(acceso);
        vista.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Controlador de Carrito con confirmación por email";
    }
    
    // Clase interna para almacenar datos de compras pendientes
    private static class DatosCompra {
        List<ItemCarrito> carrito;
        double total;
        String metodoPago;
        String emailUsuario;
        String nombreUsuario;
        long timestamp;
    }
}