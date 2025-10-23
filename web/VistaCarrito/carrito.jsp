<%-- 
    Document   : carrito
    Created on : 19 oct 2025, 6:19:41 p.m.
    Author     : Mi Equipo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.ItemCarrito"%>
<%@page import="java.util.*"%>
<%@page import="java.text.DecimalFormat"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Mi Carrito</title>
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
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .navbar h2 {
            font-size: 24px;
        }
        
        .container {
            max-width: 1000px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .carrito-vacio {
            background: white;
            padding: 60px 20px;
            border-radius: 10px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .carrito-vacio h2 {
            color: #666;
            margin-bottom: 20px;
        }
        
        .btn-continuar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 12px 30px;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
            margin-top: 20px;
        }
        
        .carrito-contenido {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        
        .item-carrito {
            display: grid;
            grid-template-columns: 80px 1fr auto;
            gap: 20px;
            padding: 20px;
            border-bottom: 1px solid #eee;
            align-items: center;
        }
        
        .item-carrito:last-child {
            border-bottom: none;
        }
        
        .item-imagen {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 40px;
        }
        
        .item-info h3 {
            color: #333;
            margin-bottom: 5px;
        }
        
        .item-detalles {
            color: #666;
            font-size: 14px;
            margin-bottom: 8px;
        }
        
        .item-precio {
            color: #4CAF50;
            font-weight: bold;
            font-size: 18px;
        }
        
        .item-acciones {
            display: flex;
            flex-direction: column;
            gap: 10px;
            align-items: flex-end;
        }
        
        .cantidad-control {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .cantidad-control input {
            width: 60px;
            padding: 8px;
            text-align: center;
            border: 2px solid #ddd;
            border-radius: 5px;
            font-size: 14px;
        }
        
        .btn-actualizar {
            background: #2196F3;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 12px;
        }
        
        .btn-eliminar {
            background: #f44336;
            color: white;
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 12px;
            text-decoration: none;
            display: inline-block;
        }
        
        .resumen-carrito {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .resumen-carrito h3 {
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #eee;
        }
        
        .resumen-linea {
            display: flex;
            justify-content: space-between;
            margin-bottom: 15px;
            color: #666;
        }
        
        .resumen-total {
            display: flex;
            justify-content: space-between;
            font-size: 24px;
            font-weight: bold;
            color: #333;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 2px solid #eee;
        }
        
        .resumen-total .monto {
            color: #4CAF50;
        }
        
        .botones-accion {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }
        
        .btn-pagar {
            flex: 1;
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            color: white;
            padding: 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            text-decoration: none;
            text-align: center;
        }
        
        .btn-limpiar {
            background: #757575;
            color: white;
            padding: 15px 30px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            text-decoration: none;
        }
        
        .btn-volver {
            background: #2196F3;
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 5px;
            display: inline-block;
            margin-bottom: 20px;
        }
        
        .error-mensaje {
            background: #fee;
            color: #c33;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            border: 1px solid #fcc;
        }
    </style>
</head>
<body>
    <%
        List<ItemCarrito> carrito = (List<ItemCarrito>) session.getAttribute("carrito");
        DecimalFormat df = new DecimalFormat("#,##0.00");
        double total = 0;
        int totalItems = 0;
        
        if (carrito != null) {
            for (ItemCarrito item : carrito) {
                total += item.getSubtotal();
                totalItems += item.getCantidad();
            }
        }
        
        String error = (String) request.getAttribute("error");
    %>
    
    <div class="navbar">
        <h2>Mi Carrito de Compras</h2>
    </div>
    
    <div class="container">
        <a href="ProductoControlador?action=catalogo" class="btn-volver">← Seguir Comprando</a>
        
        <% if (error != null) { %>
            <div class="error-mensaje">⚠️ <%= error %></div>
        <% } %>
        
        <% if (carrito == null || carrito.isEmpty()) { %>
            <div class="carrito-vacio">
                <h2>Tu carrito está vacío</h2>
                <p>¡Explora nuestro catálogo y encuentra productos increíbles!</p>
                <a href="ProductoControlador?action=catalogo" class="btn-continuar">Ver Catálogo</a>
            </div>
        <% } else { %>
            <div class="carrito-contenido">
                <h2 style="margin-bottom: 20px;">Productos en tu carrito (<%= totalItems %> items)</h2>
                
                <% for (ItemCarrito item : carrito) { %>
                <div class="item-carrito">
                    <div class="item-imagen">👕</div>
                    
                    <div class="item-info">
                        <h3><%= item.getNombre() %></h3>
                        <div class="item-detalles">
                            <%= item.getNombreMarca() %> - <%= item.getNombreModelo() %><br>
                            Color: <%= item.getNombreColor() %> | Talla: <%= item.getValorTalla() %>
                        </div>
                        <div class="item-precio">S/ <%= df.format(item.getPrecio()) %> x <%= item.getCantidad() %> = S/ <%= df.format(item.getSubtotal()) %></div>
                    </div>
                    
                    <div class="item-acciones">
                        <form action="CarritoControlador" method="GET" style="margin: 0;">
                            <div class="cantidad-control">
                                <input type="hidden" name="action" value="actualizar">
                                <input type="hidden" name="id" value="<%= item.getIdProducto() %>">
                                <input type="number" name="cantidad" value="<%= item.getCantidad() %>" min="1">
                                <button type="submit" class="btn-actualizar">↻</button>
                            </div>
                        </form>
                        <a href="CarritoControlador?action=eliminar&id=<%= item.getIdProducto() %>" 
                           class="btn-eliminar" 
                           onclick="return confirm('¿Eliminar este producto del carrito?')">Eliminar</a>
                    </div>
                </div>
                <% } %>
            </div>
            
            <div class="resumen-carrito">
                <h3>Resumen de Compra</h3>
                
                <div class="resumen-linea">
                    <span>Subtotal (<%= totalItems %> productos):</span>
                    <span>S/ <%= df.format(total) %></span>
                </div>
                
                <div class="resumen-linea">
                    <span>Envío:</span>
                    <span style="color: #4CAF50;">GRATIS</span>
                </div>
                
                <div class="resumen-total">
                    <span>Total:</span>
                    <span class="monto">S/ <%= df.format(total) %></span>
                </div>
                
                <div class="botones-accion">
                    <a href="CarritoControlador?action=pagar" class="btn-pagar">Proceder al Pago</a>
                    <a href="CarritoControlador?action=limpiar" 
                       class="btn-limpiar" 
                       onclick="return confirm('¿Vaciar todo el carrito?')">️Vaciar Carrito</a>
                </div>
            </div>
        <% } %>
    </div>
</body>
</html>