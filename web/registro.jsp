<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Registro - MVC Tienda</title>
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
            
            .registro-container {
                background: white;
                padding: 40px;
                border-radius: 10px;
                box-shadow: 0 10px 40px rgba(0,0,0,0.2);
                width: 100%;
                max-width: 500px;
            }
            
            .registro-header {
                text-align: center;
                margin-bottom: 30px;
            }
            
            .registro-header h1 {
                color: #333;
                font-size: 28px;
                margin-bottom: 10px;
            }
            
            .registro-header p {
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
            
            .form-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 15px;
            }
            
            .btn-registrar {
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
            
            .btn-registrar:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            }
            
            .btn-volver {
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
            
            .btn-volver:hover {
                background: #f8f9ff;
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
                background: #e3f2fd;
                border: 1px solid #90caf9;
                padding: 15px;
                border-radius: 5px;
                margin-bottom: 20px;
            }
            
            .info-box p {
                color: #1565c0;
                font-size: 13px;
                margin: 5px 0;
            }
            
            .password-strength {
                height: 4px;
                background: #e0e0e0;
                border-radius: 2px;
                margin-top: 5px;
                overflow: hidden;
            }
            
            .password-strength-bar {
                height: 100%;
                transition: all 0.3s;
                width: 0%;
            }
            
            .password-strength-bar.weak {
                background: #f44336;
                width: 33%;
            }
            
            .password-strength-bar.medium {
                background: #ff9800;
                width: 66%;
            }
            
            .password-strength-bar.strong {
                background: #4caf50;
                width: 100%;
            }
            
            .password-hint {
                font-size: 12px;
                color: #666;
                margin-top: 5px;
            }
            
            .icon {
                font-size: 60px;
                text-align: center;
                margin-bottom: 20px;
            }
            
            .required {
                color: #f44336;
            }
        </style>
    </head>
    <body>
        <div class="registro-container">
            <div class="icon">📝</div>
            <div class="registro-header">
                <h1>Crear Cuenta</h1>
                <p>Únete a MVC Tienda</p>
            </div>
            
            <% 
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
                <div class="error-message">❌ <%= error %></div>
            <% } %>
            
            <div class="info-box">
                <p>📧 <strong>Importante:</strong> Recibirás un correo de verificación para activar tu cuenta.</p>
            </div>
            
            <form action="LoginControlador" method="POST" id="formRegistro">
                <div class="form-group">
                    <label for="txtusuario">👤 Usuario <span class="required">*</span></label>
                    <input type="text" id="txtusuario" name="txtusuario" 
                           placeholder="Elige un nombre de usuario" required 
                           pattern="[a-zA-Z0-9_]{4,20}"
                           title="4-20 caracteres, solo letras, números y guión bajo">
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="txtnombre">Nombre <span class="required">*</span></label>
                        <input type="text" id="txtnombre" name="txtnombre" 
                               placeholder="Tu nombre" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="txtapellido">Apellido <span class="required">*</span></label>
                        <input type="text" id="txtapellido" name="txtapellido" 
                               placeholder="Tu apellido" required>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="txtemail">📧 Correo Electrónico <span class="required">*</span></label>
                    <input type="email" id="txtemail" name="txtemail" 
                           placeholder="tu-email@ejemplo.com" required>
                </div>
                
                <div class="form-group">
                    <label for="txtclave">🔒 Contraseña <span class="required">*</span></label>
                    <input type="password" id="txtclave" name="txtclave" 
                           placeholder="Mínimo 6 caracteres" required minlength="6">
                    <div class="password-strength">
                        <div class="password-strength-bar" id="strengthBar"></div>
                    </div>
                    <div class="password-hint" id="strengthText"></div>
                </div>
                
                <div class="form-group">
                    <label for="txtclaveconfirm">🔒 Confirmar Contraseña <span class="required">*</span></label>
                    <input type="password" id="txtclaveconfirm" name="txtclaveconfirm" 
                           placeholder="Repite tu contraseña" required minlength="6">
                </div>
                
                <input type="hidden" name="accion" value="Registrar">
                <button type="submit" class="btn-registrar">Crear Cuenta</button>
            </form>
            
            <a href="login.jsp" class="btn-volver">← Volver al Login</a>
        </div>
        
        <script>
            // Validar que las contraseñas coincidan
            const form = document.getElementById('formRegistro');
            const password = document.getElementById('txtclave');
            const confirmPassword = document.getElementById('txtclaveconfirm');
            const strengthBar = document.getElementById('strengthBar');
            const strengthText = document.getElementById('strengthText');
            
            // Medidor de fortaleza de contraseña
            password.addEventListener('input', function() {
                const value = this.value;
                let strength = 0;
                
                if (value.length >= 6) strength++;
                if (value.length >= 10) strength++;
                if (/[a-z]/.test(value) && /[A-Z]/.test(value)) strength++;
                if (/\d/.test(value)) strength++;
                if (/[^a-zA-Z\d]/.test(value)) strength++;
                
                strengthBar.className = 'password-strength-bar';
                
                if (strength <= 2) {
                    strengthBar.classList.add('weak');
                    strengthText.textContent = 'Contraseña débil';
                    strengthText.style.color = '#f44336';
                } else if (strength <= 3) {
                    strengthBar.classList.add('medium');
                    strengthText.textContent = 'Contraseña media';
                    strengthText.style.color = '#ff9800';
                } else {
                    strengthBar.classList.add('strong');
                    strengthText.textContent = 'Contraseña fuerte';
                    strengthText.style.color = '#4caf50';
                }
            });
            
            // Validar coincidencia de contraseñas al enviar
            form.addEventListener('submit', function(e) {
                if (password.value !== confirmPassword.value) {
                    e.preventDefault();
                    alert('Las contraseñas no coinciden');
                    confirmPassword.focus();
                    return false;
                }
            });
            
            // Validar en tiempo real
            confirmPassword.addEventListener('input', function() {
                if (this.value && password.value !== this.value) {
                    this.style.borderColor = '#f44336';
                } else if (this.value && password.value === this.value) {
                    this.style.borderColor = '#4caf50';
                } else {
                    this.style.borderColor = '#e0e0e0';
                }
            });
        </script>
    </body>
</html>