/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controlador;

import Modelo.Usuario;
import ModeloDao.UsuarioDAO;
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
        
        if (action != null && action.equals("logout")) {
            HttpSession session = request.getSession();
            session.invalidate();
            response.sendRedirect("login.jsp");
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = request.getParameter("accion");
        
        if (accion != null && accion.equals("Ingresar")) {
            String usuario = request.getParameter("txtusuario");
            String clave = request.getParameter("txtclave");
            
            Usuario usr = dao.validar(usuario, clave);
            
            if (usr != null && usr.getUsuario() != null) {
                HttpSession session = request.getSession();
                session.setAttribute("usuario", usr);
                session.setAttribute("idUsuario", usr.getIdUsuario());
                session.setAttribute("nombreUsuario", usr.getNombre() + " " + usr.getApellido());
                session.setAttribute("cargo", usr.getCargoNombre());
                session.setAttribute("idCargo", usr.getIdCargo());
                
                response.sendRedirect("home.jsp");
            } else {
                request.setAttribute("error", "Usuario o contraseña incorrectos");
                RequestDispatcher rd = request.getRequestDispatcher("login.jsp");
                rd.forward(request, response);
            }
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    @Override
    public String getServletInfo() {
        return "Controlador de Login";
    }
}