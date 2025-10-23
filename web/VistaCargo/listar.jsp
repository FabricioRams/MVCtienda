<%-- 
    Document   : listar
    Created on : 15 oct 2025, 19:04:11
    Author     : HP
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="Modelo.Cargo"%>
<%@page import="ModeloDao.CargoDao"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cargo</title>
    </head>
    <body>
        <h1>Mantenimiento de Cargo</h1>
        <a href="CargoControlador?action=add"> AgregarCargo <a/>
            <table border="1">
                <thead>
                    <tr>
                        <th>IDCARGO</th>
                        <th>NOMBRE</th>
                        <th>NOMBRE</th>
                        <th>ACCIONES</th>
                    </tr>
                </thead>
                <%
                    CargoDao dao = new CargoDao();
                    List<Cargo> list = dao.listar();
                    Iterator<Cargo> iter = list.iterator();
                    Cargo car = null;
                    while (iter.hasNext()){
                    car = iter.next();
                    
                %>
                <tbody>
                    <tr>
                        <td><%= car.getIdCargo()%></td>
                        <td><%= car.getNombre()%></td>
                        <td><%= car.getEstado()%></td>
                        
                        <td>
                            <a href="CargoControlador?action=editar&vidcar="<%= car.getIdCargo()%>>Editar</a>
                            <a href="CargoControlador?action=eliminar&vidcar="<%= car.getIdCargo()%>>Eliminar</a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
                <a href="index.jsp">Regresar</a>
    </body>
</html>
