/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controlador;

import Modelo.ItemCarrito;
import Modelo.Producto;
import ModeloDao.ProductoDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
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
    ProductoDAO dao = new ProductoDAO();

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
                        boolean todosActualizados = true;
                        
                        for (ItemCarrito item : carrito) {
                            boolean actualizado = dao.actualizarStock(item.getIdProducto(), item.getCantidad());
                            if (!actualizado) {
                                todosActualizados = false;
                                break;
                            }
                        }
                        
                        if (todosActualizados) {
                            session.setAttribute("ultimaCompra", new ArrayList<>(carrito));
                            session.setAttribute("metodoPagoUsado", metodoPago);
                            carrito.clear();
                            acceso = confirmarCompra;
                        } else {
                            request.setAttribute("error", "No hay suficiente stock para algunos productos");
                            acceso = verCarrito;
                        }
                    } else {
                        response.sendRedirect("CarritoControlador?action=pagar");
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
        return "Controlador de Carrito";
    }
}