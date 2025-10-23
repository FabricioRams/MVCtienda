<%-- 
    Document   : listar
    Created on : 19 oct 2025, 5:45:51 p.m.
    Author     : Mi Equipo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.Usuario"%>
<%@page import="ModeloDao.UsuarioDAO"%>
<%@page import="java.util.*"%>
<%
    // Verificar permisos
    Usuario usuarioSesion = (Usuario) session.getAttribute("usuario");
    if (usuarioSesion == null || usuarioSesion.getIdCargo() != 1) {
        response.sendRedirect("../home.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Gestión de Usuarios</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 20px;
                background-color: #f4f4f4;
            }
            .header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 20px;
            }
            .header-section {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                flex-wrap: wrap;
                gap: 10px;
            }
            .buttons-left {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
            }
            .buttons-right {
                display: flex;
                gap: 10px;
                flex-wrap: wrap;
            }
            table {
                border-collapse: collapse;
                width: 100%;
                margin-top: 20px;
                background: white;
                border-radius: 10px;
                overflow: hidden;
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }
            th, td {
                border: 1px solid #ddd;
                padding: 12px;
                text-align: left;
            }
            th {
                background-color: #667eea;
                color: white;
            }
            tr:hover {
                background-color: #f5f5f5;
            }
            a, button {
                text-decoration: none;
                padding: 10px 20px;
                margin: 2px;
                border-radius: 4px;
                display: inline-block;
                border: none;
                cursor: pointer;
                font-size: 14px;
            }
            .btn-agregar {
                background-color: #4CAF50;
                color: white;
            }
            .btn-importar {
                background-color: #FF9800;
                color: white;
            }
            .btn-exportar {
                background-color: #9C27B0;
                color: white;
            }
            .btn-editar {
                background-color: #2196F3;
                color: white;
                padding: 6px 12px;
            }
            .btn-eliminar {
                background-color: #f44336;
                color: white;
                padding: 6px 12px;
            }
            .btn-volver {
                background-color: #757575;
                color: white;
            }
            .badge {
                padding: 4px 8px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: bold;
            }
            .badge-activo {
                background-color: #4CAF50;
                color: white;
            }
            .badge-inactivo {
                background-color: #f44336;
                color: white;
            }
            .mensaje {
                padding: 15px;
                margin-bottom: 20px;
                border-radius: 4px;
                font-weight: bold;
            }
            .mensaje.success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            .mensaje.error {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }
            .mensaje.warning {
                background-color: #fff3cd;
                color: #856404;
                border: 1px solid #ffeaa7;
            }
            /* Modal para importar */
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.4);
            }
            .modal-content {
                background-color: white;
                margin: 5% auto;
                padding: 30px;
                border-radius: 10px;
                width: 90%;
                max-width: 600px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.3);
            }
            .modal-header {
                font-size: 24px;
                font-weight: bold;
                margin-bottom: 20px;
                color: #333;
            }
            .close {
                color: #aaa;
                float: right;
                font-size: 28px;
                font-weight: bold;
                cursor: pointer;
            }
            .close:hover {
                color: #000;
            }
            .file-input-wrapper {
                margin: 20px 0;
                padding: 20px;
                border: 2px dashed #ddd;
                border-radius: 8px;
                text-align: center;
                background-color: #f9f9f9;
            }
            input[type="file"] {
                margin: 10px 0;
            }
            .formato-ejemplo {
                background-color: #e3f2fd;
                padding: 15px;
                border-radius: 5px;
                margin: 15px 0;
                font-size: 13px;
            }
            .formato-ejemplo strong {
                color: #1976D2;
            }
            .modal-buttons {
                display: flex;
                gap: 10px;
                margin-top: 20px;
            }
            .btn-modal-submit {
                flex: 1;
                background-color: #4CAF50;
                color: white;
                padding: 12px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
            }
            .btn-modal-cancel {
                flex: 1;
                background-color: #757575;
                color: white;
                padding: 12px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 16px;
            }
        </style>
    </head>
    <body>
        <div class="header">
            <h1>Gestión de Usuarios</h1>
            <p>Administración de usuarios del sistema</p>
        </div>
        
        <%
            String mensaje = (String) request.getAttribute("mensaje");
            String tipoMensaje = (String) request.getAttribute("tipoMensaje");
            if (mensaje != null) {
        %>
            <div class="mensaje <%= tipoMensaje != null ? tipoMensaje : "success" %>">
                <%= mensaje %>
            </div>
        <% } %>
        
        <div class="header-section">
            <div class="buttons-left">
                <a href="UsuarioControlador?action=add" class="btn-agregar">Agregar Usuario</a>
                <button onclick="abrirModal()" class="btn-importar">Importar Excel</button>
            </div>
            <div class="buttons-right">
                <a href="UsuarioControlador?action=exportarPDF" class="btn-exportar">Exportar PDF</a>
                <a href="home.jsp" class="btn-volver">← Volver</a>
            </div>
        </div>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Usuario</th>
                    <th>Nombre Completo</th>
                    <th>Email</th>
                    <th>Cargo</th>
                    <th>Estado</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <%
                    UsuarioDAO dao = new UsuarioDAO();
                    List<Usuario> list = dao.listar();
                    for (Usuario u : list) {
                %>
                <tr>
                    <td><%= u.getIdUsuario()%></td>
                    <td><strong><%= u.getUsuario()%></strong></td>
                    <td><%= u.getNombre() + " " + u.getApellido()%></td>
                    <td><%= u.getEmail()%></td>
                    <td><%= u.getCargoNombre()%></td>
                    <td>
                        <% if (u.getEstado() == 1) { %>
                            <span class="badge badge-activo">✓ Activo</span>
                        <% } else { %>
                            <span class="badge badge-inactivo">✗ Inactivo</span>
                        <% } %>
                    </td>
                    <td>
                        <a href="UsuarioControlador?action=editar&id=<%= u.getIdUsuario()%>" class="btn-editar">️Editar</a>
                        <a href="UsuarioControlador?action=eliminar&id=<%= u.getIdUsuario()%>" 
                           class="btn-eliminar" 
                           onclick="return confirm('¿Está seguro de eliminar este usuario?')">
                            Eliminar
                        </a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        
        <!-- Modal para importar Excel -->
        <div id="modalImportar" class="modal">
            <div class="modal-content">
                <span class="close" onclick="cerrarModal()">&times;</span>
                <div class="modal-header">Importar Usuarios desde Excel</div>
                
                <form action="UsuarioControlador" method="POST" enctype="multipart/form-data" id="formImportar">
                    <input type="hidden" name="action" value="importarExcel">
                    
                    <div class="formato-ejemplo">
                        <strong>Formato requerido (Excel .xlsx):</strong><br><br>
                        <strong>Columnas en orden:</strong><br>
                        1. Usuario (único)<br>
                        2. Clave<br>
                        3. Nombre<br>
                        4. Apellido<br>
                        5. Email (opcional)<br>
                        6. IdCargo (1=Admin, 2=Gerente, 3=Vendedor, 4=Cliente)<br>
                        7. Estado (1=Activo, 0=Inactivo)<br><br>
                        <em>La primera fila debe contener encabezados</em>
                    </div>
                    
                    <div class="file-input-wrapper">
                        <label for="archivoExcel">Seleccione el archivo Excel:</label><br>
                        <input type="file" id="archivoExcel" name="archivoExcel" accept=".xlsx" required>
                    </div>
                    
                    <div class="modal-buttons">
                        <button type="submit" class="btn-modal-submit">Importar</button>
                        <button type="button" class="btn-modal-cancel" onclick="cerrarModal()">Cancelar</button>
                    </div>
                </form>
            </div>
        </div>
        
        <script>
            function abrirModal() {
                document.getElementById('modalImportar').style.display = 'block';
            }
            
            function cerrarModal() {
                document.getElementById('modalImportar').style.display = 'none';
                document.getElementById('formImportar').reset();
            }
            
            // Cerrar modal al hacer clic fuera de él
            window.onclick = function(event) {
                var modal = document.getElementById('modalImportar');
                if (event.target == modal) {
                    cerrarModal();
                }
            }
        </script>
    </body>
</html>