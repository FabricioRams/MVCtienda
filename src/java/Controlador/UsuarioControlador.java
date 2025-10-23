package Controlador;
import Modelo.Usuario;
import ModeloDao.UsuarioDAO;
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
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

@WebServlet(name = "UsuarioControlador", urlPatterns = {"/UsuarioControlador"})
@MultipartConfig
public class UsuarioControlador extends HttpServlet {

    String listar = "VistaUsuario/listar.jsp";
    String add = "VistaUsuario/agregar.jsp";
    String edit = "VistaUsuario/editar.jsp";
    Usuario usr = new Usuario();
    UsuarioDAO dao = new UsuarioDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Verificar permisos (solo Administrador)
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("idCargo") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        int idCargo = (Integer) session.getAttribute("idCargo");
        if (idCargo != 1) {
            response.sendRedirect("home.jsp?error=no_permission");
            return;
        }
        
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
                    String usuario = request.getParameter("txtusuario");
                    String clave = request.getParameter("txtclave");
                    String nombre = request.getParameter("txtnombre");
                    String apellido = request.getParameter("txtapellido");
                    String email = request.getParameter("txtemail");
                    int cargo = Integer.parseInt(request.getParameter("txtcargo"));
                    int estado = Integer.parseInt(request.getParameter("txtestado"));
                    
                    usr.setUsuario(usuario);
                    usr.setClave(clave);
                    usr.setNombre(nombre);
                    usr.setApellido(apellido);
                    usr.setEmail(email);
                    usr.setIdCargo(cargo);
                    usr.setEstado(estado);
                    dao.add(usr);
                    acceso = listar;
                    break;
                case "editar":
                    int id = Integer.parseInt(request.getParameter("id"));
                    request.setAttribute("idUsuario", id);
                    acceso = edit;
                    break;
                case "actualizar":
                    int id2 = Integer.parseInt(request.getParameter("txtidusuario"));
                    String usuario2 = request.getParameter("txtusuario");
                    String clave2 = request.getParameter("txtclave");
                    String nombre2 = request.getParameter("txtnombre");
                    String apellido2 = request.getParameter("txtapellido");
                    String email2 = request.getParameter("txtemail");
                    int cargo2 = Integer.parseInt(request.getParameter("txtcargo"));
                    int estado2 = Integer.parseInt(request.getParameter("txtestado"));
                    
                    usr.setIdUsuario(id2);
                    usr.setUsuario(usuario2);
                    usr.setClave(clave2);
                    usr.setNombre(nombre2);
                    usr.setApellido(apellido2);
                    usr.setEmail(email2);
                    usr.setIdCargo(cargo2);
                    usr.setEstado(estado2);
                    dao.edit(usr);
                    acceso = listar;
                    break;
                case "eliminar":
                    int id3 = Integer.parseInt(request.getParameter("id"));
                    dao.eliminar(id3);
                    acceso = listar;
                    break;
                case "exportarPDF":
                    exportarUsuariosPDF(request, response);
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
            importarUsuariosExcel(request, response);
        } else {
            doGet(request, response);
        }
    }
    
    /**
     * Importar usuarios desde un archivo Excel
     */
    private void importarUsuariosExcel(HttpServletRequest request, HttpServletResponse response)
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
            
            if (!ExcelUtil.validarFormatoUsuario(datos)) {
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
                    Usuario usuario = new Usuario();
                    usuario.setUsuario(fila[0]);
                    usuario.setClave(fila[1]);
                    usuario.setNombre(fila[2]);
                    usuario.setApellido(fila[3]);
                    usuario.setEmail(fila[4]);
                    usuario.setIdCargo(Integer.parseInt(fila[5]));
                    usuario.setEstado(Integer.parseInt(fila[6]));
                    
                    if (dao.add(usuario)) {
                        importados++;
                    } else {
                        errores++;
                    }
                } catch (Exception e) {
                    errores++;
                    System.err.println("Error al importar usuario: " + e.getMessage());
                }
            }
            
            String mensaje = String.format("Importación completada: %d usuarios importados, %d errores", 
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
     * Exportar usuarios a PDF
     */
    private void exportarUsuariosPDF(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            List<Usuario> usuarios = dao.listar();
            ByteArrayOutputStream baos = PDFUtil.generarPDFUsuarios(usuarios);
            
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", 
                "attachment; filename=usuarios_" + System.currentTimeMillis() + ".pdf");
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
        return "Controlador de Usuario con importar/exportar";
    }
}