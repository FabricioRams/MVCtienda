<%-- 
    Document   : login
    Created on : 19 oct 2025, 5:45:21 p.m.
    Author     : Mi Equipo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login - MVC Tienda</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }
            
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
            }
            
            .login-container {
                background: white;
                padding: 40px;
                border-radius: 10px;
                box-shadow: 0 10px 40px rgba(0,0,0,0.2);
                width: 100%;
                max-width: 400px;
            }
            
            .login-header {
                text-align: center;
                margin-bottom: 30px;
            }
            
            .login-header h1 {
                color: #333;
                font-size: 28px;
                margin-bottom: 10px;
            }
            
            .login-header p {
                color: #666;
                font-size: 14px;
            }
            
            .form-group {
                margin-bottom: 20px;
            }
            
            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #333;
                font-weight: 500;
            }
            
            .form-group input {
                width: 100%;
                padding: 12px;
                border: 2px solid #e0e0e0;
                border-radius: 5px;
                font-size: 14px;
                transition: border-color 0.3s;
            }
            
            .form-group input:focus {
                outline: none;
                border-color: #667eea;
            }
            
            .btn-login {
                width: 100%;
                padding: 12px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                border-radius: 5px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: transform 0.2s;
            }
            
            .btn-login:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            }
            
            .error-message {
                background: #fee;
                color: #c33;
                padding: 12px;
                border-radius: 5px;
                margin-bottom: 20px;
                text-align: center;
                border: 1px solid #fcc;
            }
            
            .info-box {
                background: #f0f8ff;
                border: 1px solid #b3d9ff;
                padding: 15px;
                border-radius: 5px;
                margin-top: 20px;
            }
            
            .info-box h3 {
                color: #0066cc;
                font-size: 14px;
                margin-bottom: 10px;
            }
            
            .info-box p {
                color: #333;
                font-size: 12px;
                margin: 5px 0;
            }
            
            .icon {
                font-size: 60px;
                text-align: center;
                margin-bottom: 20px;
            }
        </style>
    </head>
    <body>
        <div class="login-container">
            <div class="icon">🛒</div>
            <div class="login-header">
                <h1>MVC Tienda</h1>
                <p>Inicia sesión para continuar</p>
            </div>
            
            <% 
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="error-message">
                     <%= error %>
                </div>
            <% } %>
            
            <form action="LoginControlador" method="POST">
                <div class="form-group">
                    <label for="txtusuario">Usuario</label>
                    <input type="text" id="txtusuario" name="txtusuario" 
                           placeholder="Ingresa tu usuario" required autofocus>
                </div>
                
                <div class="form-group">
                    <label for="txtclave">Contraseña</label>
                    <input type="password" id="txtclave" name="txtclave" 
                           placeholder="Ingresa tu contraseña" required>
                </div>
                
                <input type="hidden" name="accion" value="Ingresar">
                <button type="submit" class="btn-login">Iniciar Sesión</button>
            </form>
            
            <div class="info-box">
                <h3>Usuarios de Prueba:</h3>
                <p><strong>Administrador:</strong> admin / 123456</p>
                <p><strong>Gerente:</strong> gerente1 / 123456</p>
                <p><strong>Vendedor:</strong> vendedor1 / 123456</p>
                <p><strong>Cliente:</strong> cliente / 123456</p>
            </div>
        </div>
    </body>
</html>
