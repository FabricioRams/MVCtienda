package Util;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

public class EmailService {
    
    // Configuración del servidor de correo (Gmail como ejemplo)
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_FROM = ""; //  email
    private static final String EMAIL_PASSWORD = ""; // Contraseña
    
    /**
     * Envía un correo de verificación al usuario
     */
    public static boolean enviarCorreoVerificacion(String destinatario, String nombreUsuario, String token, String urlBase) {
        try {
            // Configuración de propiedades
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            
            // Crear sesión con autenticación
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
                }
            });
            
            // Crear mensaje
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_FROM, "MVC Tienda"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
            message.setSubject("Verificación de cuenta - MVC Tienda");
            
            // URL de verificación
            String urlVerificacion = urlBase + "/LoginControlador?action=verificar&token=" + token;
            
            // Contenido HTML del correo
            String htmlContent = construirHTMLVerificacion(nombreUsuario, urlVerificacion);
            message.setContent(htmlContent, "text/html; charset=utf-8");
            
            // Enviar correo
            Transport.send(message);
            
            System.out.println("Correo de verificación enviado a: " + destinatario);
            return true;
            
        } catch (Exception e) {
            System.err.println("Error al enviar correo: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Construye el contenido HTML del correo de verificación
     */
    private static String construirHTMLVerificacion(String nombreUsuario, String urlVerificacion) {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<style>" +
                "body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0; }" +
                ".container { max-width: 600px; margin: 40px auto; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 4px 20px rgba(0,0,0,0.1); }" +
                ".header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 40px 20px; text-align: center; }" +
                ".header h1 { margin: 0; font-size: 28px; }" +
                ".content { padding: 40px 30px; }" +
                ".content h2 { color: #333; margin-top: 0; }" +
                ".content p { color: #666; line-height: 1.6; }" +
                ".btn { display: inline-block; padding: 15px 40px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; text-decoration: none; border-radius: 5px; margin: 20px 0; font-weight: bold; }" +
                ".footer { background: #f8f9fa; padding: 20px; text-align: center; color: #666; font-size: 12px; }" +
                ".warning { background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0; color: #856404; }" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='container'>" +
                "<div class='header'>" +
                "<h1>🛒 MVC Tienda</h1>" +
                "</div>" +
                "<div class='content'>" +
                "<h2>¡Bienvenido " + nombreUsuario + "!</h2>" +
                "<p>Gracias por registrarte en MVC Tienda. Para activar tu cuenta, necesitamos verificar tu dirección de correo electrónico.</p>" +
                "<p>Haz clic en el siguiente botón para confirmar tu cuenta:</p>" +
                "<div style='text-align: center;'>" +
                "<a href='" + urlVerificacion + "' class='btn'>Verificar mi cuenta</a>" +
                "</div>" +
                "<div class='warning'>" +
                "<strong>⚠️ Importante:</strong> Este enlace expirará en 24 horas. Si no solicitaste este registro, puedes ignorar este correo." +
                "</div>" +
                "<p>Si el botón no funciona, copia y pega el siguiente enlace en tu navegador:</p>" +
                "<p style='word-break: break-all; color: #667eea;'>" + urlVerificacion + "</p>" +
                "</div>" +
                "<div class='footer'>" +
                "<p>Este es un correo automático, por favor no respondas a este mensaje.</p>" +
                "<p>&copy; 2025 MVC Tienda. Todos los derechos reservados.</p>" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
    }
    
    /**
     * Envía un correo de bienvenida después de verificar la cuenta
     */
    public static boolean enviarCorreoBienvenida(String destinatario, String nombreUsuario) {
        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);
            props.put("mail.smtp.ssl.protocols", "TLSv1.2");
            
            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(EMAIL_FROM, EMAIL_PASSWORD);
                }
            });
            
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(EMAIL_FROM, "MVC Tienda"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
            message.setSubject("¡Cuenta verificada exitosamente! - MVC Tienda");
            
            String htmlContent = "<!DOCTYPE html>" +
                    "<html>" +
                    "<body style='font-family: Arial, sans-serif;'>" +
                    "<div style='max-width: 600px; margin: 0 auto; padding: 20px;'>" +
                    "<h2 style='color: #667eea;'>¡Tu cuenta ha sido verificada! ✓</h2>" +
                    "<p>Hola " + nombreUsuario + ",</p>" +
                    "<p>Tu cuenta en MVC Tienda ha sido verificada exitosamente. Ya puedes iniciar sesión y comenzar a comprar.</p>" +
                    "<p>¡Gracias por unirte a nosotros!</p>" +
                    "<hr style='border: 1px solid #eee; margin: 20px 0;'>" +
                    "<p style='color: #666; font-size: 12px;'>MVC Tienda - Tu tienda de confianza</p>" +
                    "</div>" +
                    "</body>" +
                    "</html>";
            
            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
            
            return true;
        } catch (Exception e) {
            System.err.println("Error al enviar correo de bienvenida: " + e.getMessage());
            return false;
        }
    }
}