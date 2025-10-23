/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controlador;

import Modelo.Usuario;
import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter(filterName = "FiltroAutenticacion", urlPatterns = {
    "/home.jsp",
    "/CargoControlador",
    "/ClienteControlador",
    "/UsuarioControlador",
    "/VistaCargo/*",
    "/VistaCliente/*",
    "/VistaUsuario/*"
})
public class FiltroAutenticacion implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Inicialización del filtro
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Verificar si hay una sesión activa
        boolean loggedIn = (session != null && session.getAttribute("usuario") != null);
        
        if (loggedIn) {
            // Usuario autenticado, continuar con la petición
            chain.doFilter(request, response);
        } else {
            // No autenticado, redirigir al login
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
        }
    }

    @Override
    public void destroy() {
        // Limpieza del filtro
    }
}