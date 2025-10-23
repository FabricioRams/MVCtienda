<%-- 
    Document   : editar
    Created on : 19 oct 2025, 5:46:00 p.m.
    Author     : Mi Equipo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.Usuario"%>
<%@page import="Modelo.Cargo"%>
<%@page import="ModeloDao.UsuarioDAO"%>
<%@page import="ModeloDao.CargoDao"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Editar Usuario</title>
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
            input[type="number"],
            select {
                width: 100%;
                padding: 10px;
                border: 2px solid #ddd;
                border-radius: 5px;
                box-sizing: border-box;
                font-size: 14px;
            }
            input[readonly] {
                background-color: #f0f0f0;
            }
            input:focus, select:focus {
                outline: none;
                border-color: #667eea;
            }
            .btn-submit {
                background: linear-gradient(135deg, #2196F3 0%, #1976D2 100%);
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
                box-shadow: 0 5px 15px rgba(33, 150, 243, 0.4);
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
        <%
            UsuarioDAO dao = new UsuarioDAO();
            int id = Integer.parseInt(request.getAttribute("idUsuario").toString());
            Usuario u = dao.list(id);
        %>
        <div class="container">
            <h1>✏️ Editar Usuario</h1>
            <form action="UsuarioControlador" method="GET">
                <div class="form-group">
                    <label for="txtidusuario">ID Usuario:</label>
                    <input type="number" id="txtidusuario" name="txtidusuario" value="<%= u.getIdUsuario()%>" readonly>
                </div>
                
                <div class="form-group">
                    <label for="txtusuario">Usuario:</label>
                    <input type="text" id="txtusuario" name="txtusuario" value="<%= u.getUsuario()%>" required>
                </div>
                
                <div class="form-group">
                    <label for="txtclave">Contraseña:</label>
                    <input type="password" id="txtclave" name="txtclave" value="<%= u.getClave()%>" required>
                </div>
                
                <div class="form-group">
                    <label for="txtnombre">Nombre:</label>
                    <input type="text" id="txtnombre" name="txtnombre" value="<%= u.getNombre()%>" required>
                </div>
                
                <div class="form-group">
                    <label for="txtapellido">Apellido:</label>
                    <input type="text" id="txtapellido" name="txtapellido" value="<%= u.getApellido()%>" required>
                </div>
                
                <div class="form-group">
                    <label for="txtemail">📧 Email:</label>
                    <input type="email" id="txtemail" name="txtemail" value="<%= u.getEmail()%>">
                </div>
                
                <div class="form-group">
                    <label for="txtcargo">Cargo:</label>
                    <select id="txtcargo" name="txtcargo" required>
                        <%
                            CargoDao daoC = new CargoDao();
                            List<Cargo> listCargos = daoC.listar();
                            for (Cargo c : listCargos) {
                                if (c.getEstado() == 1) {
                        %>
                            <option value="<%= c.getIdCargo()%>" 
                                    <%= c.getIdCargo() == u.getIdCargo() ? "selected" : "" %>>
                                <%= c.getNombre()%>
                            </option>
                        <%
                                }
                            }
                        %>
                    </select>
                </div>
                
                <div class="form-group">
                    <label for="txtestado">Estado:</label>
                    <select id="txtestado" name="txtestado" required>
                        <option value="1" <%= u.getEstado() == 1 ? "selected" : "" %>>Activo</option>
                        <option value="0" <%= u.getEstado() == 0 ? "selected" : "" %>>Inactivo</option>
                    </select>
                </div>
                
                <input type="hidden" name="action" value="actualizar">
                <button type="submit" class="btn-submit">Actualizar</button>
                <a href="UsuarioControlador?action=listar" class="btn-cancel">Cancelar</a>
            </form>
        </div>
    </body>
</html>
