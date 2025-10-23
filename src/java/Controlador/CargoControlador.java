/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controlador;

import Modelo.Cargo;
import ModeloDao.CargoDao;
import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "CargoControlador", urlPatterns = {"/CargoControlador"})
public class CargoControlador extends HttpServlet {

    String listar = "VistaCargo/listar.jsp";
    String add = "VistaCargo/agregar.jsp";
    String edit = "VistaCargo/editar.jsp";
    Cargo car = new Cargo();
    CargoDao dao = new CargoDao();

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
                    int id = Integer.parseInt(request.getParameter("txtid"));
                    String nom = request.getParameter("txtnombre");
                    int est = Integer.parseInt(request.getParameter("txtestado"));
                    car.setIdCargo(id);
                    car.setNombre(nom);
                    car.setEstado(est);
                    dao.add(car);
                    acceso = listar;
                    break;
                case "editar":
                    int vidcar = Integer.parseInt(request.getParameter("vidcar"));
                    request.setAttribute("vidcar", vidcar);
                    acceso = edit;
                    break;
                case "actualizar":
                    int id2 = Integer.parseInt(request.getParameter("txtid"));
                    String nom2 = request.getParameter("txtnombre");
                    int est2 = Integer.parseInt(request.getParameter("txtestado"));
                    car.setIdCargo(id2);
                    car.setNombre(nom2);
                    car.setEstado(est2);
                    dao.edit(car);
                    acceso = listar;
                    break;
                case "eliminar":
                    int vidcar2 = Integer.parseInt(request.getParameter("vidcar"));
                    car.setIdCargo(vidcar2);
                    dao.eliminar(car);
                    acceso = listar;
                    break;
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
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Controlador de Cargo";
    }
}