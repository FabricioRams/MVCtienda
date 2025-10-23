<%-- 
    Document   : confirmacion
    Created on : 19 oct 2025, 6:19:51 p.m.
    Author     : Mi Equipo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.ItemCarrito"%>
<%@page import="java.util.*"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Compra Confirmada</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .confirmacion-contenedor {
            background: white;
            max-width: 600px;
            width: 100%;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        
        .confirmacion-header {
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
        }
        
        .check-icono {
            font-size: 80px;
            margin-bottom: 20px;
            animation: checkAnimation 0.5s ease-in-out;
        }
        
        @keyframes checkAnimation {
            0% {
                transform: scale(0);
                opacity: 0;
            }
            50% {
                transform: scale(1.2);
            }
            100% {
                transform: scale(1);
                opacity: 1;
            }
        }
        
        .confirmacion-header h1 {
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .confirmacion-header p {
            font-size: 16px;
            opacity: 0.9;
        }
        
        .confirmacion-contenido {
            padding: 30px;
        }
        
        .info-pedido {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 25px;
        }
        
        .info-linea {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            color: #666;
        }
        
        .info-linea strong {
            color: #333;
        }
        
        .productos-lista {
            margin: 25px 0;
        }
        
        .productos-lista h3 {
            color: #333;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #eee;
        }
        
        .producto-item {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        
        .producto-item:last-child {
            border-bottom: none;
        }
        
        .producto-item .nombre {
            color: #333;
            font-weight: 500;
        }
        
        .producto-item .cantidad {
            color: #666;
            font-size: 14px;
        }
        
        .producto-item .precio {
            color: #4CAF50;
            font-weight: bold;
        }
        
        .total-final {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 10px;
            margin: 25px 0;
            text-align: center;
        }
        
        .total-final h3 {
            font-size: 16px;
            margin-bottom: 10px;
            opacity: 0.9;
        }
        
        .total-final .monto {
            font-size: 36px;
            font-weight: bold;
        }
        
        .mensaje-entrega {
            background: #e3f2fd;
            border-left: 4px solid #2196F3;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 25px;
        }
        
        .mensaje-entrega p {
            color: #1976D2;
            margin: 0;
            font-size: 14px;
        }
        
        .botones-accion {
            display: flex;
            gap: 10px;
        }
        
        .btn {
            flex: 1;
            padding: 15px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 15px;
            font-weight: bold;
            text-decoration: none;
            text-align: center;
            display: block;
            transition: all 0.3s;
        }
        
        .btn-catalogo {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .btn-catalogo:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        
        .btn-inicio {
            background: #757575;
            color: white;
        }
        
        .btn-inicio:hover {
            background: #616161;
        }
    </style>
</head>
<body>
    <%
        List<ItemCarrito> ultimaCompra = (List<ItemCarrito>) session.getAttribute("ultimaCompra");
        String metodoPago = (String) session.getAttribute("metodoPagoUsado");
        
        DecimalFormat df = new DecimalFormat("#,##0.00");
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        Date fechaActual = new Date();
        
        double total = 0;
        int totalItems = 0;
        
        if (ultimaCompra != null) {
            for (ItemCarrito item : ultimaCompra) {
                total += item.getSubtotal();
                totalItems += item.getCantidad();
            }
        }
        
        // Generar número de pedido aleatorio
        Random random = new Random();
        int numeroPedido = 10000 + random.nextInt(90000);
    %>
    
    <div class="confirmacion-contenedor">
        <div class="confirmacion-header">
            <div class="check-icono">✓</div>
            <h1>¡Compra Exitosa!</h1>
            <p>Tu pedido ha sido procesado correctamente</p>
        </div>
        
        <div class="confirmacion-contenido">
            <div class="info-pedido">
                <div class="info-linea">
                    <span>Número de Pedido:</span>
                    <strong>#<%= numeroPedido %></strong>
                </div>
                <div class="info-linea">
                    <span>Fecha:</span>
                    <strong><%= sdf.format(fechaActual) %></strong>
                </div>
                <div class="info-linea">
                    <span>Método de Pago:</span>
                    <strong><%= metodoPago %></strong>
                </div>
                <div class="info-linea">
                    <span>Total de Productos:</span>
                    <strong><%= totalItems %> items</strong>
                </div>
            </div>
            
            <div class="mensaje-entrega">
                <p>Tu pedido será enviado en las próximas 24-48 horas. Recibirás un correo de confirmación con los detalles del envío.</p>
            </div>
            
            <div class="productos-lista">
                <h3>Productos Comprados</h3>
                <% if (ultimaCompra != null) {
                    for (ItemCarrito item : ultimaCompra) { %>
                    <div class="producto-item">
                        <div>
                            <div class="nombre"><%= item.getNombre() %></div>
                            <div class="cantidad">
                                <%= item.getNombreMarca() %> - <%= item.getNombreModelo() %><br>
                                Color: <%= item.getNombreColor() %> | Talla: <%= item.getValorTalla() %><br>
                                Cantidad: <%= item.getCantidad() %>
                            </div>
                        </div>
                        <div class="precio">S/ <%= df.format(item.getSubtotal()) %></div>
                    </div>
                <% }
                } %>
            </div>
            
            <div class="total-final">
                <h3>Total Pagado</h3>
                <div class="monto">S/ <%= df.format(total) %></div>
            </div>
            
            <div class="botones-accion">
                <a href="ProductoControlador?action=catalogo" class="btn btn-catalogo">
                    Seguir Comprando
                </a>
                <a href="home.jsp" class="btn btn-inicio">
                    Ir al Inicio
                </a>
            </div>
        </div>
    </div>
    
    <%
        // Limpiar las variables de sesión después de mostrar
        session.removeAttribute("ultimaCompra");
        session.removeAttribute("metodoPagoUsado");
    %>
</body>
</html>