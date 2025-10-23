package Controlador;

import Modelo.Cliente;
import ModeloDao.ClienteDAO;
import Util.ExcelUtil;
import Util.PDFUtil;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

@WebServlet(name = "ClienteControlador", urlPatterns = {"/ClienteControlador"})
@MultipartConfig
public class ClienteControlador extends HttpServlet {

    String listar = "VistaCliente/listar.jsp";
    String add = "VistaCliente/agregar.jsp";
    String edit = "VistaCliente/editar.jsp";
    Cliente cli = new Cliente();
    ClienteDAO dao = new ClienteDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String acceso = "";
        String action = request.getParameter("action");
        
        if (action != null) {
            switch (action) {
                case "listar":
                    acceso = listar;
                    break;
                case "add":
                    acceso = add;
                    break;
                case "agregar":
                    String dni = request.getParameter("txtdni");
                    String nom = request.getParameter("txtnombres");
                    String ape = request.getParameter("txtapellidos");
                    String dir = request.getParameter("txtdireccion");
                    String em = request.getParameter("txtemail");
                    String cla = request.getParameter("txtclave");
                    cli.setDni(dni);
                    cli.setNombres(nom);
                    cli.setApellidos(ape);
                    cli.setDireccion(dir);
                    cli.setEmail(em);
                    cli.setClave(cla);
                    dao.add(cli);
                    acceso = listar;
                    break;
                case "editar":
                    String vdni = request.getParameter("vdni");
                    request.setAttribute("vdni", vdni);
                    acceso = edit;
                    break;
                case "actualizar":
                    String dni2 = request.getParameter("txtdni");
                    String nom2 = request.getParameter("txtnombres");
                    String ape2 = request.getParameter("txtapellidos");
                    String dir2 = request.getParameter("txtdireccion");
                    String em2 = request.getParameter("txtemail");
                    String cla2 = request.getParameter("txtclave");
                    cli.setDni(dni2);
                    cli.setNombres(nom2);
                    cli.setApellidos(ape2);
                    cli.setDireccion(dir2);
                    cli.setEmail(em2);
                    cli.setClave(cla2);
                    dao.edit(cli);
                    acceso = listar;
                    break;
                case "eliminar":
                    String vdni2 = request.getParameter("vdni");
                    dao.eliminar(vdni2);
                    acceso = listar;
                    break;
                case "exportarPDF":
                    exportarClientesPDF(request, response);
                    return;
                default:
                    acceso = listar;
                    break;
            }
        } else {
            acceso = listar;
        }

        RequestDispatcher vista = request.getRequestDispatcher(acceso);
        vista.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("importarExcel".equals(action)) {
            importarClientesExcel(request, response);
        } else {
            doGet(request, response);
        }
    }
    
    /**
     * Importar clientes desde un archivo Excel
     */
    private void importarClientesExcel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            Part filePart = request.getPart("archivoExcel");
            
            if (filePart == null || filePart.getSize() == 0) {
                request.setAttribute("mensaje", "Por favor seleccione un archivo");
                request.setAttribute("tipoMensaje", "error");
                RequestDispatcher vista = request.getRequestDispatcher(listar);
                vista.forward(request, response);
                return;
            }
            
            InputStream fileContent = filePart.getInputStream();
            List<String[]> datos = ExcelUtil.leerExcel(fileContent);
            
            if (!ExcelUtil.validarFormatoCliente(datos)) {
                request.setAttribute("mensaje", "Formato de archivo incorrecto. Verifique las columnas.");
                request.setAttribute("tipoMensaje", "error");
                RequestDispatcher vista = request.getRequestDispatcher(listar);
                vista.forward(request, response);
                return;
            }
            
            int importados = 0;
            int errores = 0;
            
            for (String[] fila : datos) {
                try {
                    Cliente cliente = new Cliente();
                    cliente.setDni(fila[0]);
                    cliente.setNombres(fila[1]);
                    cliente.setApellidos(fila[2]);
                    cliente.setDireccion(fila[3]);
                    cliente.setEmail(fila[4]);
                    cliente.setClave(fila[5]);
                    
                    if (dao.add(cliente)) {
                        importados++;
                    } else {
                        errores++;
                    }
                } catch (Exception e) {
                    errores++;
                    System.err.println("Error al importar cliente: " + e.getMessage());
                }
            }
            
            String mensaje = String.format("Importación completada: %d clientes importados, %d errores", 
                importados, errores);
            request.setAttribute("mensaje", mensaje);
            request.setAttribute("tipoMensaje", importados > 0 ? "success" : "warning");
            
        } catch (Exception e) {
            request.setAttribute("mensaje", "Error al procesar el archivo: " + e.getMessage());
            request.setAttribute("tipoMensaje", "error");
            e.printStackTrace();
        }
        
        RequestDispatcher vista = request.getRequestDispatcher(listar);
        vista.forward(request, response);
    }
    
    /**
     * Exportar clientes a PDF
     */
    private void exportarClientesPDF(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            List<Cliente> clientes = dao.listar();
            ByteArrayOutputStream baos = PDFUtil.generarPDFClientes(clientes);
            
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", 
                "attachment; filename=clientes_" + System.currentTimeMillis() + ".pdf");
            response.setContentLength(baos.size());
            
            baos.writeTo(response.getOutputStream());
            response.getOutputStream().flush();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "Error al generar el PDF: " + e.getMessage());
        }
    }

    @Override
    public String getServletInfo() {
        return "Controlador de Cliente con importar/exportar";
    }
}