<%-- 
    Document   : agregar
    Created on : 19 oct 2025, 5:45:57 p.m.
    Author     : Mi Equipo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.Cargo"%>
<%@page import="ModeloDao.CargoDao"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Agregar Usuario</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
                background-color: #f4f4f4;
            }
            .container {
                max-width: 600px;
                margin: 0 auto;
                background: white;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            h1 {
                color: #333;
                margin-bottom: 30px;
            }
            .form-group {
                margin-bottom: 20px;
            }
            label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
                color: #333;
            }
            input[type="text"],
            input[type="email"],
            input[type="password"],
            select {
                width: 100%;
                padding: 10px;
                border: 2px solid #ddd;
                border-radius: 5px;
                box-sizing: border-box;
                font-size: 14px;
            }
            input:focus, select:focus {
                outline: none;
                border-color: #667eea;
            }
            .btn-submit {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 12px 30px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
                margin-right: 10px;
            }
            .btn-submit:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            }
            .btn-cancel {
                background-color: #757575;
                color: white;
                padding: 12px 30px;
                text-decoration: none;
                border-radius: 5px;
                display: inline-block;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>+ Agregar Nuevo Usuario</h1>
            <form action="UsuarioControlador" method="GET">
                <div class="form-group">
                    <label for="txtusuario">Usuario:</label>
                    <input type="text" id="txtusuario" name="txtusuario" required>
                </div>
                
                <div class="form-group">
                    <label for="txtclave">Contraseña:</label>
                    <input type="password" id="txtclave" name="txtclave" required>
                </div>
                
                <div class="form-group">
                    <label for="txtnombre">Nombre:</label>
                    <input type="text" id="txtnombre" name="txtnombre" required>
                </div>
                
                <div class="form-group">
                    <label for="txtapellido">Apellido:</label>
                    <input type="text" id="txtapellido" name="txtapellido" required>
                </div>
                
                <div class="form-group">
                    <label for="txtemail">Email:</label>
                    <input type="email" id="txtemail" name="txtemail">
                </div>
                
                <div class="form-group">
                    <label for="txtcargo">Cargo:</label>
                    <select id="txtcargo" name="txtcargo" required>
                        <option value="">Seleccione un cargo</option>
                        <%
                            CargoDao daoC = new CargoDao();
                            List<Cargo> listCargos = daoC.listar();
                            for (Cargo c : listCargos) {
                                if (c.getEstado() == 1) {
                        %>
                            <option value="<%= c.getIdCargo()%>"><%= c.getNombre()%></option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="txtestado">Estado:</label>
                    <select id="txtestado" name="txtestado" required>
                        <option value="1">Activo</option>
                        <option value="0">Inactivo</option>
                    </select>
                </div>
                
                <input type="hidden" name="action" value="agregar">
                <button type="submit" class="btn-submit">Guardar</button>
                <a href="UsuarioControlador?action=listar" class="btn-cancel">Cancelar</a>
            </form>
        </div>
    </body>
</html>
