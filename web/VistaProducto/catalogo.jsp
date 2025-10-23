<%-- 
    Document   : catalogo
    Created on : 19 oct 2025, 6:19:30 p.m.
    Author     : Mi Equipo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.Producto"%>
<%@page import="Modelo.ItemCarrito"%>
<%@page import="ModeloDao.ProductoDAO"%>
<%@page import="java.util.*"%>
<%@page import="java.text.DecimalFormat"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Catálogo de Productos</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
        }
        
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .navbar h2 {
            font-size: 24px;
        }
        
        .navbar-right {
            display: flex;
            gap: 15px;
            align-items: center;
        }
        
        .btn-carrito {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 8px 20px;
            border: 2px solid white;
            border-radius: 5px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-carrito:hover {
            background: white;
            color: #667eea;
        }
        
        .badge-carrito {
            background: #f44336;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .container {
            max-width: 1200px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .mensaje {
            background: #4CAF50;
            color: white;
            padding: 12px 20px;
            border-radius: 5px;
            margin-bottom: 20px;
            text-align: center;
        }
        
        .productos-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 25px;
            margin-top: 20px;
        }
        
        .producto-card {
            background: white;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        
        .producto-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }
        
        .producto-imagen {
            width: 100%;
            height: 200px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 80px;
        }
        
        .producto-info {
            padding: 20px;
        }
        
        .producto-marca {
            color: #667eea;
            font-size: 12px;
            font-weight: bold;
            text-transform: uppercase;
            margin-bottom: 5px;
        }
        
        .producto-nombre {
            font-size: 18px;
            font-weight: bold;
            color: #333;
            margin-bottom: 8px;
        }
        
        .producto-descripcion {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
            height: 40px;
            overflow: hidden;
        }
        
        .producto-detalles {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
            flex-wrap: wrap;
        }
        
        .detalle-item {
            display: flex;
            align-items: center;
            gap: 5px;
            font-size: 12px;
            color: #666;
        }
        
        .color-muestra {
            width: 15px;
            height: 15px;
            border-radius: 50%;
            border: 2px solid #ddd;
        }
        
        .producto-precio {
            font-size: 24px;
            font-weight: bold;
            color: #4CAF50;
            margin-bottom: 10px;
        }
        
        .producto-stock {
            font-size: 12px;
            color: #666;
            margin-bottom: 15px;
        }
        
        .btn-agregar {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: bold;
            transition: transform 0.2s;
        }
        
        .btn-agregar:hover {
            transform: scale(1.05);
        }
        
        .btn-volver {
            background: #757575;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
        }
        
        .sin-productos {
            text-align: center;
            padding: 60px 20px;
            background: white;
            border-radius: 10px;
            margin-top: 20px;
        }
        
        .sin-productos h2 {
            color: #666;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <%
        List<ItemCarrito> carrito = (List<ItemCarrito>) session.getAttribute("carrito");
        int cantidadItems = 0;
        if (carrito != null) {
            for (ItemCarrito item : carrito) {
                cantidadItems += item.getCantidad();
            }
        }
        String mensaje = (String) session.getAttribute("mensaje");
        if (mensaje != null) {
            session.removeAttribute("mensaje");
        }
        
        DecimalFormat df = new DecimalFormat("#,##0.00");
    %>
    
    <div class="navbar">
        <h2> Catálogo de Productos</h2>
        <div class="navbar-right">
            <a href="CarritoControlador?action=ver" class="btn-carrito">
                🛒 Carrito 
                <% if (cantidadItems > 0) { %>
                    <span class="badge-carrito"><%= cantidadItems %></span>
                <% } %>
            </a>
            <a href="home.jsp" class="btn-volver">← Volver</a>
        </div>
    </div>
    
    <div class="container">
        <% if (mensaje != null) { %>
            <div class="mensaje">✓ <%= mensaje %></div>
        <% } %>
        
        <%
            ProductoDAO dao = new ProductoDAO();
            List<Producto> productos = dao.listar();
            
            if (productos.isEmpty()) {
        %>
            <div class="sin-productos">
                <h2>No hay productos disponibles</h2>
                <p>En este momento no tenemos productos en stock</p>
            </div>
        <% } else { %>
            <div class="productos-grid">
                <%
                    for (Producto p : productos) {
                %>
                <div class="producto-card">
                    <div class="producto-imagen">
                        👕
                    </div>
                    <div class="producto-info">
                        <div class="producto-marca"><%= p.getNombreMarca() %></div>
                        <div class="producto-nombre"><%= p.getNombre() %></div>
                        <div class="producto-descripcion"><%= p.getDescripcion() %></div>
                        
                        <div class="producto-detalles">
                            <div class="detalle-item">
                                <span class="color-muestra" style="background-color: <%= p.getCodigoHexColor() %>"></span>
                                <%= p.getNombreColor() %>
                            </div>
                            <div class="detalle-item">
                                 Talla <%= p.getValorTalla() %>
                            </div>
                        </div>
                        
                        <div class="producto-precio">S/ <%= df.format(p.getPrecio()) %></div>
                        <div class="producto-stock">
                            <% if (p.getStock() > 10) { %>
                                ✓ En stock (<%= p.getStock() %> disponibles)
                            <% } else { %>
                               ️ Últimas unidades (<%= p.getStock() %> disponibles)
                            <% } %>
                        </div>
                        
                        <form action="CarritoControlador" method="GET" style="margin: 0;">
                            <input type="hidden" name="action" value="agregar">
                            <input type="hidden" name="id" value="<%= p.getIdProducto() %>">
                            <button type="submit" class="btn-agregar">Agregar al Carrito</button>
                        </form>
                    </div>
                </div>
                <% } %>
            </div>
        <% } %>
    </div>
</body>
</html>