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
                min-height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
                padding: 20px;
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
                margin-bottom: 15px;
            }
            
            .btn-login:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            }
            
            .error-message, .success-message, .warning-message {
                padding: 12px;
                border-radius: 5px;
                margin-bottom: 20px;
                text-align: center;
                border: 1px solid;
            }
            
            .error-message {
                background: #fee;
                color: #c33;
                border-color: #fcc;
            }
            
            .success-message {
                background: #d4edda;
                color: #155724;
                border-color: #c3e6cb;
            }
            
            .warning-message {
                background: #fff3cd;
                color: #856404;
                border-color: #ffeeba;
            }
            
            .divider {
                text-align: center;
                margin: 20px 0;
                position: relative;
            }
            
            .divider::before {
                content: '';
                position: absolute;
                top: 50%;
                left: 0;
                right: 0;
                height: 1px;
                background: #ddd;
            }
            
            .divider span {
                background: white;
                padding: 0 10px;
                position: relative;
                color: #666;
                font-size: 14px;
            }
            
            .btn-registro {
                width: 100%;
                padding: 12px;
                background: white;
                color: #667eea;
                border: 2px solid #667eea;
                border-radius: 5px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s;
                text-decoration: none;
                display: block;
                text-align: center;
            }
            
            .btn-registro:hover {
                background: #667eea;
                color: white;
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
                String success = (String) request.getAttribute("success");
                String tipo = (String) request.getAttribute("tipo");
                
                if (error != null) {
                    if ("warning".equals(tipo)) {
            %>
                        <div class="warning-message">⚠️ <%= error %></div>
            <%      } else { %>
                        <div class="error-message">❌ <%= error %></div>
            <%      }
                }
                
                if (success != null) {
            %>
                    <div class="success-message">✅ <%= success %></div>
            <% } %>
            
            <form action="LoginControlador" method="POST">
                <div class="form-group">
                    <label for="txtusuario">👤 Usuario</label>
                    <input type="text" id="txtusuario" name="txtusuario" 
                           placeholder="Ingresa tu usuario" required autofocus>
                </div>
                
                <div class="form-group">
                    <label for="txtclave">🔒 Contraseña</label>
                    <input type="password" id="txtclave" name="txtclave" 
                           placeholder="Ingresa tu contraseña" required>
                </div>
                
                <input type="hidden" name="accion" value="Ingresar">
                <button type="submit" class="btn-login">Iniciar Sesión</button>
            </form>
            
            <div class="divider">
                <span>¿No tienes cuenta?</span>
            </div>
            
            <a href="registro.jsp" class="btn-registro">Crear cuenta nueva</a>
            
            <div class="info-box">
                <h3>ℹ️ Usuarios de Prueba:</h3>
                <p><strong>Administrador:</strong> admin / 123456</p>
                <p><strong>Gerente:</strong> gerente1 / 123456</p>
                <p><strong>Vendedor:</strong> vendedor1 / 123456</p>
                <p><strong>Cliente:</strong> cliente / 123456</p>
            </div>
        </div>
    </body>
</html>