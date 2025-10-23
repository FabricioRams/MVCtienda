<%-- 
    Document   : pagar
    Created on : 19 oct 2025, 6:19:46 p.m.
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
    <title>Método de Pago</title>
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
            max-width: 800px;
            margin: 30px auto;
            padding: 0 20px;
        }
        
        .pago-contenedor {
            display: grid;
            grid-template-columns: 1fr 350px;
            gap: 20px;
        }
        
        .metodos-pago {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .metodos-pago h2 {
            color: #333;
            margin-bottom: 25px;
        }
        
        .metodo-opcion {
            border: 2px solid #ddd;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 15px;
        }
        
        .metodo-opcion:hover {
            border-color: #667eea;
            background: #f8f9ff;
        }
        
        .metodo-opcion input[type="radio"] {
            width: 20px;
            height: 20px;
            cursor: pointer;
        }
        
        .metodo-info {
            flex: 1;
        }
        
        .metodo-info h3 {
            color: #333;
            margin-bottom: 5px;
        }
        
        .metodo-info p {
            color: #666;
            font-size: 14px;
        }
        
        .metodo-icono {
            font-size: 40px;
        }
        
        .resumen-compra {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            height: fit-content;
        }
        
        .resumen-compra h3 {
            color: #333;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #eee;
        }
        
        .producto-resumen {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
            font-size: 14px;
            color: #666;
        }
        
        .resumen-linea {
            display: flex;
            justify-content: space-between;
            margin: 15px 0;
            padding: 15px 0;
            border-top: 1px solid #eee;
        }
        
        .resumen-total {
            display: flex;
            justify-content: space-between;
            font-size: 20px;
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
            flex-direction: column;
            gap: 10px;
            margin-top: 30px;
        }
        
        .btn-confirmar {
            width: 100%;
            background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%);
            color: white;
            padding: 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
        }
        
        .btn-confirmar:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(76, 175, 80, 0.4);
        }
        
        .btn-confirmar:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }
        
        .btn-volver {
            width: 100%;
            background: #757575;
            color: white;
            padding: 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            text-align: center;
            display: block;
        }
        
        .aviso-seguridad {
            background: #e3f2fd;
            border: 1px solid #2196F3;
            border-radius: 5px;
            padding: 15px;
            margin-top: 20px;
            font-size: 14px;
            color: #1976D2;
        }
        
        @media (max-width: 768px) {
            .pago-contenedor {
                grid-template-columns: 1fr;
            }
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
    %>
    
    <div class="navbar">
        <h2>Método de Pago</h2>
    </div>
    
    <div class="container">
        <div class="pago-contenedor">
            <div class="metodos-pago">
                <h2>Selecciona tu método de pago</h2>
                
                <form id="formPago" action="CarritoControlador" method="GET">
                    <input type="hidden" name="action" value="confirmar">
                    
                    <label class="metodo-opcion">
                        <input type="radio" name="metodoPago" value="Tarjeta de Crédito" required>
                        <div class="metodo-icono">💳</div>
                        <div class="metodo-info">
                            <h3>Tarjeta de Crédito</h3>
                            <p>Visa, Mastercard, American Express</p>
                        </div>
                    </label>
                    
                    <label class="metodo-opcion">
                        <input type="radio" name="metodoPago" value="Tarjeta de Débito" required>
                        <div class="metodo-icono">💰</div>
                        <div class="metodo-info">
                            <h3>Tarjeta de Débito</h3>
                            <p>Pago directo desde tu cuenta bancaria</p>
                        </div>
                    </label>
                    
                    <label class="metodo-opcion">
                        <input type="radio" name="metodoPago" value="Yape/Plin" required>
                        <div class="metodo-icono">📱</div>
                        <div class="metodo-info">
                            <h3>Yape / Plin</h3>
                            <p>Pago móvil instantáneo</p>
                        </div>
                    </label>
                    
                    <label class="metodo-opcion">
                        <input type="radio" name="metodoPago" value="Contra Entrega" required>
                        <div class="metodo-icono">🚚</div>
                        <div class="metodo-info">
                            <h3>Pago Contra Entrega</h3>
                            <p>Paga en efectivo al recibir tu pedido</p>
                        </div>
                    </label>
                    
                    <div class="aviso-seguridad">
                        🔒 <strong>Compra 100% Segura</strong><br>
                        Esta es una simulación de pago. No se procesará ningún cargo real.
                    </div>
                </form>
            </div>
            
            <div class="resumen-compra">
                <h3>Resumen del Pedido</h3>
                
                <% if (carrito != null) {
                    for (ItemCarrito item : carrito) { %>
                    <div class="producto-resumen">
                        <span><%= item.getCantidad() %>x <%= item.getNombre() %></span>
                        <span>S/ <%= df.format(item.getSubtotal()) %></span>
                    </div>
                <% }
                } %>
                
                <div class="resumen-linea">
                    <span>Subtotal:</span>
                    <span>S/ <%= df.format(total) %></span>
                </div>
                
                <div class="resumen-linea" style="border-top: none; margin-top: 0; padding-top: 0;">
                    <span>Envío:</span>
                    <span style="color: #4CAF50;">GRATIS</span>
                </div>
                
                <div class="resumen-total">
                    <span>Total a pagar:</span>
                    <span class="monto">S/ <%= df.format(total) %></span>
                </div>
                
                <div class="botones-accion">
                    <button type="submit" form="formPago" class="btn-confirmar">
                        ✓ Confirmar Compra
                    </button>
                    <a href="CarritoControlador?action=ver" class="btn-volver">
                        ← Volver al Carrito
                    </a>
                </div>
            </div>
        </div>
    </div>
    
    <script>
        const radios = document.querySelectorAll('input[name="metodoPago"]');
        const opciones = document.querySelectorAll('.metodo-opcion');
        
        radios.forEach((radio, index) => {
            radio.addEventListener('change', () => {
                opciones.forEach(op => op.style.borderColor = '#ddd');
                opciones.forEach(op => op.style.background = 'white');
                if (radio.checked) {
                    opciones[index].style.borderColor = '#667eea';
                    opciones[index].style.background = '#f8f9ff';
                }
            });
        });
    </script>
</body>
</html>