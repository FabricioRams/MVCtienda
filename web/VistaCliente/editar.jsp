<%-- 
    Document   : editar
    Created on : 19 oct 2025, 5:23:44 p.m.
    Author     : Mi Equipo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.Cliente"%>
<%@page import="ModeloDao.ClienteDAO"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Editar Cliente</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
                max-width: 600px;
            }
            .form-group {
                margin-bottom: 15px;
            }
            label {
                display: block;
                margin-bottom: 5px;
                font-weight: bold;
            }
            input[type="text"],
            input[type="email"],
            input[type="password"] {
                width: 100%;
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 4px;
                box-sizing: border-box;
            }
            input[readonly] {
                background-color: #f0f0f0;
            }
            .btn-submit {
                background-color: #2196F3;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                margin-right: 10px;
            }
            .btn-submit:hover {
                background-color: #0b7dda;
            }
            .btn-cancel {
                background-color: #f44336;
                color: white;
                padding: 10px 20px;
                text-decoration: none;
                border-radius: 4px;
                display: inline-block;
            }
        </style>
    </head>
    <body>
        <%
            ClienteDAO dao = new ClienteDAO();
            String vdni = (String) request.getAttribute("vdni");
            Cliente c = dao.list(vdni);
        %>
        <h1>Editar Cliente</h1>
        <form action="ClienteControlador" method="GET">
            <div class="form-group">
                <label for="txtdni">DNI:</label>
                <input type="text" id="txtdni" name="txtdni" value="<%= c.getDni()%>" readonly>
            </div>
            
            <div class="form-group">
                <label for="txtnombres">Nombres:</label>
                <input type="text" id="txtnombres" name="txtnombres" value="<%= c.getNombres()%>" required>
            </div>
            
            <div class="form-group">
                <label for="txtapellidos">Apellidos:</label>
                <input type="text" id="txtapellidos" name="txtapellidos" value="<%= c.getApellidos()%>" required>
            </div>
            
            <div class="form-group">
                <label for="txtdireccion">Dirección:</label>
                <input type="text" id="txtdireccion" name="txtdireccion" value="<%= c.getDireccion()%>">
            </div>
            
            <div class="form-group">
                <label for="txtemail">Email:</label>
                <input type="email" id="txtemail" name="txtemail" value="<%= c.getEmail()%>">
            </div>
            
            <div class="form-group">
                <label for="txtclave">Clave:</label>
                <input type="password" id="txtclave" name="txtclave" value="<%= c.getClave()%>" required>
            </div>
            
            <input type="hidden" name="action" value="actualizar">
            <button type="submit" class="btn-submit">Actualizar</button>
            <a href="ClienteControlador?action=listar" class="btn-cancel">Cancelar</a>
        </form>
    </body>
</html>