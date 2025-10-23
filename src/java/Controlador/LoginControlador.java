package Controlador;

import Modelo.Usuario;
import ModeloDao.UsuarioDAO;
import Util.EmailService;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "LoginControlador", urlPatterns = {"/LoginControlador"})
public class LoginControlador extends HttpServlet {

    UsuarioDAO dao = new UsuarioDAO();

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        
        if (action != null) {
            switch (action) {
                case "logout":
                    HttpSession session = request.getSession();
                    session.invalidate();
                    response.sendRedirect("login.jsp");
                    break;
                    
                case "verificar":
                    verificarCuenta(request, response);
                    break;
                    
                case "registro":
                    response.sendRedirect("registro.jsp");
                    break;
                    
                default:
                    response.sendRedirect("login.jsp");
                    break;
            }
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        
        if (accion != null) {
            switch (accion) {
                case "Ingresar":
                    loginUsuario(request, response);
                    break;
                    
                case "Registrar":
                    registrarUsuario(request, response);
                    break;
                    
                default:
                    response.sendRedirect("login.jsp");
                    break;
            }
        } else {
            response.sendRedirect("login.jsp");
        }
    }
    
    /**
     * Maneja el login de usuarios
     */
    private void loginUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String usuario = request.getParameter("txtusuario");
        String clave = request.getParameter("txtclave");
        
        Usuario usr = dao.validar(usuario, clave);
        
        if (usr != null && usr.getUsuario() != null) {
            // Verificar si el email está verificado
            if (!usr.isEmailVerificado() && usr.getEmail() != null && !usr.getEmail().isEmpty()) {
                request.setAttribute("error", "Debes verificar tu correo electrónico antes de iniciar sesión. Revisa tu bandeja de entrada.");
                request.setAttribute("tipo", "warning");
                RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
                rd.forward(request, response);
                return;
            }
            
            HttpSession session = request.getSession();
            session.setAttribute("usuario", usr);
            session.setAttribute("idUsuario", usr.getIdUsuario());
            session.setAttribute("nombreUsuario", usr.getNombre() + " " + usr.getApellido());
            session.setAttribute("cargo", usr.getCargoNombre());
            session.setAttribute("idCargo", usr.getIdCargo());
            
            response.sendRedirect("home.jsp");
        } else {
            request.setAttribute("error", "Usuario o contraseña incorrectos");
            request.setAttribute("tipo", "error");
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.forward(request, response);
        }
    }
    
    /**
     * Registra un nuevo usuario y envía correo de verificación
     */
    private void registrarUsuario(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String usuario = request.getParameter("txtusuario");
        String clave = request.getParameter("txtclave");
        String claveConfirm = request.getParameter("txtclaveconfirm");
        String nombre = request.getParameter("txtnombre");
        String apellido = request.getParameter("txtapellido");
        String email = request.getParameter("txtemail");
        
        // Validaciones
        if (!clave.equals(claveConfirm)) {
            request.setAttribute("error", "Las contraseñas no coinciden");
            request.setAttribute("tipo", "error");
            RequestDispatcher rd = request.getRequestDispatcher("registro.jsp");
            rd.forward(request, response);
            return;
        }
        
        if (dao.existeUsuario(usuario)) {
            request.setAttribute("error", "El nombre de usuario ya existe");
            request.setAttribute("tipo", "error");
            RequestDispatcher rd = request.getRequestDispatcher("registro.jsp");
            rd.forward(request, response);
            return;
        }
        
        if (dao.existeEmail(email)) {
            request.setAttribute("error", "El correo electrónico ya está registrado");
            request.setAttribute("tipo", "error");
            RequestDispatcher rd = request.getRequestDispatcher("registro.jsp");
            rd.forward(request, response);
            return;
        }
        
        // Crear usuario
        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setUsuario(usuario);
        nuevoUsuario.setClave(clave);
        nuevoUsuario.setNombre(nombre);
        nuevoUsuario.setApellido(apellido);
        nuevoUsuario.setEmail(email);
        nuevoUsuario.setIdCargo(4); // Cargo de Cliente por defecto
        nuevoUsuario.setEstado(0); // Inactivo hasta verificar email
        
        // Generar token de verificación
        String token = UsuarioDAO.generarToken();
        nuevoUsuario.setTokenVerificacion(token);
        
        // Registrar en base de datos
        if (dao.registrarUsuario(nuevoUsuario)) {
            // Obtener URL base para el enlace de verificación
            String urlBase = request.getScheme() + "://" + 
                           request.getServerName() + ":" + 
                           request.getServerPort() + 
                           request.getContextPath();
            
            // Enviar correo de verificación
            boolean emailEnviado = EmailService.enviarCorreoVerificacion(
                email, 
                nombre + " " + apellido, 
                token, 
                urlBase
            );
            
            if (emailEnviado) {
                request.setAttribute("success", "¡Registro exitoso! Hemos enviado un correo de verificación a " + email + ". Por favor, revisa tu bandeja de entrada.");
                request.setAttribute("tipo", "success");
            } else {
                request.setAttribute("success", "Usuario registrado, pero hubo un problema al enviar el correo. Contacta al administrador.");
                request.setAttribute("tipo", "warning");
            }
            
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.forward(request, response);
        } else {
            request.setAttribute("error", "Error al registrar el usuario. Intenta nuevamente.");
            request.setAttribute("tipo", "error");
            RequestDispatcher rd = request.getRequestDispatcher("registro.jsp");
            rd.forward(request, response);
        }
    }
    
    /**
     * Verifica la cuenta del usuario mediante el token
     */
    private void verificarCuenta(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String token = request.getParameter("token");
        
        if (token == null || token.isEmpty()) {
            request.setAttribute("error", "Token de verificación inválido");
            request.setAttribute("tipo", "error");
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.forward(request, response);
            return;
        }
        
        // Obtener datos del usuario antes de verificar
        String email = dao.obtenerEmailPorToken(token);
        String nombreCompleto = dao.obtenerNombrePorToken(token);
        
        // Verificar el token
        if (dao.verificarToken(token)) {
            // Enviar correo de bienvenida
            if (email != null) {
                EmailService.enviarCorreoBienvenida(email, nombreCompleto);
            }
            
            request.setAttribute("success", "¡Cuenta verificada exitosamente! Ya puedes iniciar sesión.");
            request.setAttribute("tipo", "success");
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.forward(request, response);
        } else {
            request.setAttribute("error", "Token de verificación inválido o expirado");
            request.setAttribute("tipo", "error");
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
            rd.forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Controlador de Login con registro y verificación";
    }
}