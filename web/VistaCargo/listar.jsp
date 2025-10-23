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
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
            }
            table {
                border-collapse: collapse;
                width: 80%;
                margin-top: 20px;
            }
            th, td {
                border: 1px solid #ddd;
                padding: 10px;
                text-align: left;
            }
            th {
                background-color: #4CAF50;
                color: white;
            }
            tr:hover {
                background-color: #f5f5f5;
            }
            a {
                text-decoration: none;
                padding: 5px 10px;
                margin: 2px;
            }
            .btn-agregar {
                background-color: #4CAF50;
                color: white;
                padding: 10px 20px;
                display: inline-block;
                margin-bottom: 20px;
                border-radius: 4px;
            }
            .btn-editar {
                background-color: #2196F3;
                color: white;
                border-radius: 4px;
            }
            .btn-eliminar {
                background-color: #f44336;
                color: white;
                border-radius: 4px;
            }
            .btn-volver {
                background-color: #757575;
                color: white;
                padding: 10px 20px;
                display: inline-block;
                border-radius: 4px;
            }
        </style>
    </head>
    <body>
        <h1>Mantenimiento de Cargo</h1>
        <a href="CargoControlador?action=add" class="btn-agregar">Agregar Cargo</a>
        <table>
            <thead>
                <tr>
                    <th>ID CARGO</th>
                    <th>NOMBRE</th>
                    <th>ESTADO</th>
                    <th>ACCIONES</th>
                </tr>
            </thead>
            <tbody>
                <%
                    CargoDao dao = new CargoDao();
                    List<Cargo> list = dao.listar();
                    Iterator<Cargo> iter = list.iterator();
                    Cargo car = null;
                    while (iter.hasNext()) {
                        car = iter.next();
                %>
                <tr>
                    <td><%= car.getIdCargo()%></td>
                    <td><%= car.getNombre()%></td>
                    <td><%= car.getEstado() == 1 ? "Activo" : "Inactivo"%></td>
                    <td>
                        <a href="CargoControlador?action=editar&vidcar=<%= car.getIdCargo()%>" class="btn-editar">Editar</a>
                        <a href="CargoControlador?action=eliminar&vidcar=<%= car.getIdCargo()%>" class="btn-eliminar" onclick="return confirm('¿Está seguro de eliminar este cargo?')">Eliminar</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <br>
        <a href="home.jsp" class="btn-volver">← Regresar al Inicio</a>
    </body>
</html>