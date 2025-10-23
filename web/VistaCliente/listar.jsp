<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<%@page import="Modelo.Cliente"%>
<%@page import="ModeloDao.ClienteDAO"%>
<%@page import="java.util.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Clientes</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 20px;
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
            }
            th, td {
                border: 1px solid #ddd;
                padding: 10px;
                text-align: left;
            }
            th {
                background-color: #2196F3;
                color: white;
            }
            tr:hover {
                background-color: #f5f5f5;
            }
            a, button {
                text-decoration: none;
                padding: 10px 20px;
                margin: 2px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-size: 14px;
                display: inline-block;
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
                padding: 5px 10px;
            }
            .btn-eliminar {
                background-color: #f44336;
                color: white;
                padding: 5px 10px;
            }
            .btn-volver {
                background-color: #757575;
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
                margin: 10% auto;
                padding: 30px;
                border-radius: 10px;
                width: 90%;
                max-width: 500px;
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
        <h1>Mantenimiento de Clientes</h1>
        
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
                <a href="ClienteControlador?action=add" class="btn-agregar">Agregar Cliente</a>
                <button onclick="abrirModal()" class="btn-importar">Importar Excel</button>
            </div>
            <div class="buttons-right">
                <a href="ClienteControlador?action=exportarPDF" class="btn-exportar">Exportar PDF</a>
                <a href="home.jsp" class="btn-volver">← Volver</a>
            </div>
        </div>
        
        <table>
            <thead>
                <tr>
                    <th>DNI</th>
                    <th>NOMBRES</th>
                    <th>APELLIDOS</th>
                    <th>DIRECCIÓN</th>
                    <th>EMAIL</th>
                    <th>ACCIONES</th>
                </tr>
            </thead>
            <tbody>
                <%
                    ClienteDAO dao = new ClienteDAO();
                    List<Cliente> list = dao.listar();
                    Iterator<Cliente> iter = list.iterator();
                    Cliente cli = null;
                    while (iter.hasNext()) {
                        cli = iter.next();
                %>
                <tr>
                    <td><%= cli.getDni()%></td>
                    <td><%= cli.getNombres()%></td>
                    <td><%= cli.getApellidos()%></td>
                    <td><%= cli.getDireccion()%></td>
                    <td><%= cli.getEmail()%></td>
                    <td>
                        <a href="ClienteControlador?action=editar&vdni=<%= cli.getDni()%>" class="btn-editar">✏️ Editar</a>
                        <a href="ClienteControlador?action=eliminar&vdni=<%= cli.getDni()%>" class="btn-eliminar" onclick="return confirm('¿Está seguro de eliminar este cliente?')">🗑️ Eliminar</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
        
        <!-- Modal para importar Excel -->
        <div id="modalImportar" class="modal">
            <div class="modal-content">
                <span class="close" onclick="cerrarModal()">&times;</span>
                <div class="modal-header">Importar Clientes desde Excel</div>
                
                <form action="ClienteControlador" method="POST" enctype="multipart/form-data" id="formImportar">
                    <input type="hidden" name="action" value="importarExcel">
                    
                    <div class="formato-ejemplo">
                        <strong>Formato requerido (Excel .xlsx):</strong><br><br>
                        <strong>Columnas en orden:</strong><br>
                        1. DNI (8 dígitos)<br>
                        2. Nombres<br>
                        3. Apellidos<br>
                        4. Dirección (opcional)<br>
                        5. Email (opcional)<br>
                        6. Clave<br><br>
                        <em>⚠️ La primera fila debe contener encabezados</em>
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