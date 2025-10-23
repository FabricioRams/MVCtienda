<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Confirmación Pendiente</title>
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
        
        .container {
            background: white;
            max-width: 600px;
            width: 100%;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            overflow: hidden;
        }
        
        .header {
            background: linear-gradient(135deg, #FF9800 0%, #F57C00 100%);
            color: white;
            padding: 40px 30px;
            text-align: center;
        }
        
        .icono-correo {
            font-size: 80px;
            margin-bottom: 20px;
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0%, 100% {
                transform: scale(1);
            }
            50% {
                transform: scale(1.1);
            }
        }
        
        .header h1 {
            font-size: 28px;
            margin-bottom: 10px;
        }
        
        .header p {
            font-size: 16px;
            opacity: 0.9;
        }
        
        .contenido {
            padding: 40px 30px;
        }
        
        .mensaje-principal {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 25px;
        }
        
        .mensaje-principal p {
            color: #856404;
            line-height: 1.6;
            margin: 0;
        }
        
        .pasos {
            margin: 30px 0;
        }
        
        .pasos h3 {
            color: #333;
            margin-bottom: 20px;
        }
        
        .paso {
            display: flex;
            align-items: flex-start;
            margin-bottom: 20px;
        }
        
        .paso-numero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 15px;
            flex-shrink: 0;
        }
        
        .paso-texto {
            color: #666;
            line-height: 1.6;
        }
        
        .info-box {
            background: #e3f2fd;
            border: 1px solid #2196F3;
            border-radius: 5px;
            padding: 20px;
            margin: 25px 0;
        }
        
        .info-box h4 {
            color: #1976D2;
            margin-bottom: 10px;
            font-size: 16px;
        }
        
        .info-box p {
            color: #1976D2;
            margin: 0;
            font-size: 14px;
            line-height: 1.6;
        }
        
        .botones {
            display: flex;
            gap: 10px;
            margin-top: 30px;
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
        
        .footer {
            background: #f8f9fa;
            padding: 20px;
            text-align: center;
            color: #666;
            font-size: 12px;
        }
    </style>
</head>
<body>
    <%
        String mensajeConfirmacion = (String) session.getAttribute("mensajeConfirmacion");
        if (mensajeConfirmacion != null) {
            session.removeAttribute("mensajeConfirmacion");
        }
    %>
    
    <div class="container">
        <div class="header">
            <div class="icono-correo">📧</div>
            <h1>Confirmación Pendiente</h1>
            <p>Revisa tu correo electrónico</p>
        </div>
        
        <div class="contenido">
            <div class="mensaje-principal">
                <p><strong>⚠️ <%= mensajeConfirmacion != null ? mensajeConfirmacion : "Hemos enviado un correo de confirmación" %></strong></p>
            </div>
            
            <div class="pasos">
                <h3>Para completar tu compra:</h3>
                
                <div class="paso">
                    <div class="paso-numero">1</div>
                    <div class="paso-texto">
                        <strong>Revisa tu bandeja de entrada</strong><br>
                        Busca el correo de "MVC Tienda" con el asunto "Confirma tu compra"
                    </div>
                </div>
                
                <div class="paso">
                    <div class="paso-numero">2</div>
                    <div class="paso-texto">
                        <strong>Revisa los detalles de tu pedido</strong><br>
                        Verifica que todos los productos y el total sean correctos
                    </div>
                </div>
                
                <div class="paso">
                    <div class="paso-numero">3</div>
                    <div class="paso-texto">
                        <strong>Haz clic en "CONFIRMAR COMPRA"</strong><br>
                        Al confirmar, se procesará tu pedido y recibirás un comprobante en PDF
                    </div>
                </div>
            </div>
            
            <div class="info-box">
                <h4>📱 ¿No recibiste el correo?</h4>
                <p>
                    • Revisa tu carpeta de SPAM o correo no deseado<br>
                    • Asegúrate de que tu correo electrónico esté correctamente registrado<br>
                    • El enlace de confirmación expirará en 30 minutos por seguridad<br>
                    • Si el enlace expira, deberás realizar la compra nuevamente
                </p>
            </div>
            
            <div style="background: #d4edda; border-left: 4px solid #28a745; padding: 15px; border-radius: 5px; margin: 20px 0;">
                <p style="color: #155724; margin: 0;">
                    ✓ <strong>Después de confirmar</strong><br>
                    Recibirás un comprobante de compra en formato PDF en tu correo electrónico con todos los detalles de tu pedido.
                </p>
            </div>
            
            <div class="botones">
                <a href="ProductoControlador?action=catalogo" class="btn btn-catalogo">
                    Ver Más Productos
                </a>
                <a href="home.jsp" class="btn btn-inicio">
                    Ir al Inicio
                </a>
            </div>
        </div>
        
        <div class="footer">
            <p>Si tienes problemas, contacta a nuestro soporte técnico</p>
            <p>&copy; 2025 MVC Tienda. Todos los derechos reservados.</p>
        </div>
    </div>
</body>
</html>