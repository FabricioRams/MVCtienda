<%-- 
    Document   : agregar
    Created on : 19 oct 2025, 5:24:49 p.m.
    Author     : Mi Equipo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Agregar Cargo</title>
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
            input[type="number"],
            select {
                width: 100%;
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 4px;
                box-sizing: border-box;
            }
            .btn-submit {
                background-color: #4CAF50;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                margin-right: 10px;
            }
            .btn-submit:hover {
                background-color: #45a049;
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
        <h1>Agregar Nuevo Cargo</h1>
        <form action="CargoControlador" method="GET">
            <div class="form-group">
                <label for="txtid">ID Cargo:</label>
                <input type="number" id="txtid" name="txtid" required>
            </div>
            
            <div class="form-group">
                <label for="txtnombre">Nombre:</label>
                <input type="text" id="txtnombre" name="txtnombre" required>
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
            <a href="CargoControlador?action=listar" class="btn-cancel">Cancelar</a>
        </form>
    </body>
</html>
