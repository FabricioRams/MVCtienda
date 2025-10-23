package Util;

import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import Modelo.ItemCarrito;
import java.io.ByteArrayOutputStream;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Properties;
import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.mail.*;
import javax.mail.internet.*;
import javax.mail.util.ByteArrayDataSource;

public class EmailService {
    
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String EMAIL_FROM = "rojomelodespojo@gmail.com";
    private static final String EMAIL_PASSWORD = "qmfj akpl ygzd vxwd";
    
    /**
     * Envía un correo de verificación al usuario
     */
    public static boolean enviarCorreoVerificacion(String destinatario, String nombreUsuario, String token, String urlBase) {
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
            message.setSubject("Verificación de cuenta - MVC Tienda");
            
            String urlVerificacion = urlBase + "/LoginControlador?action=verificar&token=" + token;
            String htmlContent = construirHTMLVerificacion(nombreUsuario, urlVerificacion);
            message.setContent(htmlContent, "text/html; charset=utf-8");
            
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
     * Envía correo de confirmación de compra con token
     */
    public static boolean enviarCorreoConfirmacionCompra(String destinatario, String nombreUsuario, 
                                                         List<ItemCarrito> carrito, double total, 
                                                         String metodoPago, String tokenCompra, String urlBase) {
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
            message.setSubject("Confirma tu compra - MVC Tienda");
            
            String urlConfirmacion = urlBase + "/CarritoControlador?action=confirmarCompra&token=" + tokenCompra;
            String htmlContent = construirHTMLConfirmacionCompra(nombreUsuario, carrito, total, metodoPago, urlConfirmacion);
            message.setContent(htmlContent, "text/html; charset=utf-8");
            
            Transport.send(message);
            
            System.out.println("Correo de confirmación de compra enviado a: " + destinatario);
            return true;
            
        } catch (Exception e) {
            System.err.println("Error al enviar correo de confirmación: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Envía correo con PDF de compra adjunto
     */
    public static boolean enviarCorreoConPDFCompra(String destinatario, String nombreUsuario, 
                                                   List<ItemCarrito> productos, double total, 
                                                   String metodoPago, int numeroPedido) {
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
            message.setSubject("¡Compra Confirmada! - Pedido #" + numeroPedido);
            
            // Crear multipart para el correo
            Multipart multipart = new MimeMultipart();
            
            // Parte HTML del correo
            MimeBodyPart htmlPart = new MimeBodyPart();
            String htmlContent = construirHTMLCompraExitosa(nombreUsuario, numeroPedido, total, metodoPago);
            htmlPart.setContent(htmlContent, "text/html; charset=utf-8");
            multipart.addBodyPart(htmlPart);
            
            // Generar y adjuntar PDF
            ByteArrayOutputStream pdfBytes = generarPDFCompra(productos, total, metodoPago, numeroPedido, nombreUsuario);
            MimeBodyPart pdfPart = new MimeBodyPart();
            DataSource source = new ByteArrayDataSource(pdfBytes.toByteArray(), "application/pdf");
            pdfPart.setDataHandler(new DataHandler(source));
            pdfPart.setFileName("Comprobante_Pedido_" + numeroPedido + ".pdf");
            multipart.addBodyPart(pdfPart);
            
            message.setContent(multipart);
            
            Transport.send(message);
            
            System.out.println("Correo con PDF enviado a: " + destinatario);
            return true;
            
        } catch (Exception e) {
            System.err.println("Error al enviar correo con PDF: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Genera PDF del comprobante de compra
     */
    private static ByteArrayOutputStream generarPDFCompra(List<ItemCarrito> productos, double total, 
                                                          String metodoPago, int numeroPedido, String nombreCliente) throws Exception {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document document = new Document(PageSize.A4);
        
        try {
            PdfWriter.getInstance(document, baos);
            document.open();
            
            // Encabezado
            Font titleFont = new Font(Font.HELVETICA, 20, Font.BOLD, new java.awt.Color(102, 126, 234));
            Paragraph title = new Paragraph("COMPROBANTE DE COMPRA", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(10);
            document.add(title);
            
            Font subtitleFont = new Font(Font.HELVETICA, 14, Font.BOLD);
            Paragraph subtitle = new Paragraph("MVC Tienda", subtitleFont);
            subtitle.setAlignment(Element.ALIGN_CENTER);
            subtitle.setSpacingAfter(20);
            document.add(subtitle);
            
            // Información del pedido
            Font infoFont = new Font(Font.HELVETICA, 10);
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
            
            PdfPTable infoTable = new PdfPTable(2);
            infoTable.setWidthPercentage(100);
            infoTable.setSpacingAfter(20);
            
            addCellToTable(infoTable, "Número de Pedido:", "#" + numeroPedido, infoFont);
            addCellToTable(infoTable, "Fecha:", sdf.format(new Date()), infoFont);
            addCellToTable(infoTable, "Cliente:", nombreCliente, infoFont);
            addCellToTable(infoTable, "Método de Pago:", metodoPago, infoFont);
            
            document.add(infoTable);
            
            // Tabla de productos
            Font headerFont = new Font(Font.HELVETICA, 10, Font.BOLD, java.awt.Color.WHITE);
            PdfPTable productTable = new PdfPTable(5);
            productTable.setWidthPercentage(100);
            productTable.setWidths(new float[]{3f, 1f, 1.5f, 1.5f, 2f});
            
            java.awt.Color headerColor = new java.awt.Color(102, 126, 234);
            
            PdfPCell cell;
            String[] headers = {"PRODUCTO", "CANT.", "PRECIO", "SUBTOTAL", "DETALLES"};
            for (String header : headers) {
                cell = new PdfPCell(new Phrase(header, headerFont));
                cell.setBackgroundColor(headerColor);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setPadding(8);
                productTable.addCell(cell);
            }
            
            // Productos
            Font dataFont = new Font(Font.HELVETICA, 9);
            DecimalFormat df = new DecimalFormat("#,##0.00");
            
            for (ItemCarrito item : productos) {
                productTable.addCell(new Phrase(item.getNombre(), dataFont));
                
                cell = new PdfPCell(new Phrase(String.valueOf(item.getCantidad()), dataFont));
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                productTable.addCell(cell);
                
                cell = new PdfPCell(new Phrase("S/ " + df.format(item.getPrecio()), dataFont));
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
                productTable.addCell(cell);
                
                cell = new PdfPCell(new Phrase("S/ " + df.format(item.getSubtotal()), dataFont));
                cell.setHorizontalAlignment(Element.ALIGN_RIGHT);
                productTable.addCell(cell);
                
                String detalles = item.getNombreMarca() + " - " + item.getNombreModelo() + "\n" +
                                 "Color: " + item.getNombreColor() + " | Talla: " + item.getValorTalla();
                productTable.addCell(new Phrase(detalles, new Font(Font.HELVETICA, 8)));
            }
            
            document.add(productTable);
            
            // Total
            Paragraph totalPara = new Paragraph();
            totalPara.setSpacingBefore(20);
            totalPara.setAlignment(Element.ALIGN_RIGHT);
            
            Font totalFont = new Font(Font.HELVETICA, 16, Font.BOLD);
            totalPara.add(new Phrase("TOTAL: S/ " + df.format(total), totalFont));
            document.add(totalPara);
            
            // Pie de página
            Paragraph footer = new Paragraph();
            footer.setSpacingBefore(30);
            footer.setAlignment(Element.ALIGN_CENTER);
            Font footerFont = new Font(Font.HELVETICA, 9, Font.ITALIC, java.awt.Color.GRAY);
            footer.add(new Phrase("Gracias por su compra\n", footerFont));
            footer.add(new Phrase("MVC Tienda - Tu tienda de confianza", footerFont));
            document.add(footer);
            
        } finally {
            document.close();
        }
        
        return baos;
    }
    
    private static void addCellToTable(PdfPTable table, String label, String value, Font font) {
        Font boldFont = new Font(font.getFamily(), font.getSize(), Font.BOLD);
        table.addCell(new Phrase(label, boldFont));
        table.addCell(new Phrase(value, font));
    }
    
    /**
     * Construye el HTML del correo de verificación
     */
    private static String construirHTMLVerificacion(String nombreUsuario, String urlVerificacion) {
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<style>" +
                "body { font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0; }" +
                ".container { max-width: 600px; margin: 40px auto; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }" +
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
     * Construye el HTML del correo de confirmación de compra
     */
    private static String construirHTMLConfirmacionCompra(String nombreUsuario, List<ItemCarrito> carrito, 
                                                          double total, String metodoPago, String urlConfirmacion) {
        DecimalFormat df = new DecimalFormat("#,##0.00");
        int totalItems = 0;
        for (ItemCarrito item : carrito) {
            totalItems += item.getCantidad();
        }
        
        StringBuilder productosHTML = new StringBuilder();
        for (ItemCarrito item : carrito) {
            productosHTML.append("<tr>")
                    .append("<td style='padding: 10px; border-bottom: 1px solid #eee;'>")
                    .append(item.getNombre())
                    .append("<br><small style='color: #666;'>")
                    .append(item.getNombreMarca()).append(" - ").append(item.getNombreModelo())
                    .append(" | Color: ").append(item.getNombreColor())
                    .append(" | Talla: ").append(item.getValorTalla())
                    .append("</small></td>")
                    .append("<td style='padding: 10px; border-bottom: 1px solid #eee; text-align: center;'>")
                    .append(item.getCantidad())
                    .append("</td>")
                    .append("<td style='padding: 10px; border-bottom: 1px solid #eee; text-align: right;'>")
                    .append("S/ ").append(df.format(item.getSubtotal()))
                    .append("</td>")
                    .append("</tr>");
        }
        
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head><meta charset='UTF-8'></head>" +
                "<body style='font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0;'>" +
                "<div style='max-width: 600px; margin: 40px auto; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1);'>" +
                "<div style='background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 40px 20px; text-align: center;'>" +
                "<h1 style='margin: 0; font-size: 28px;'>🛒 Confirmación de Compra</h1>" +
                "</div>" +
                "<div style='padding: 40px 30px;'>" +
                "<h2 style='color: #333;'>Hola " + nombreUsuario + ",</h2>" +
                "<p style='color: #666; line-height: 1.6;'>Has solicitado realizar una compra en MVC Tienda. Por favor, revisa los detalles y confirma tu pedido.</p>" +
                "<div style='background: #f8f9fa; border-radius: 10px; padding: 20px; margin: 20px 0;'>" +
                "<h3 style='margin-top: 0;'>Resumen de tu pedido:</h3>" +
                "<table style='width: 100%; border-collapse: collapse;'>" +
                "<thead>" +
                "<tr style='background: #667eea; color: white;'>" +
                "<th style='padding: 10px; text-align: left;'>Producto</th>" +
                "<th style='padding: 10px; text-align: center;'>Cant.</th>" +
                "<th style='padding: 10px; text-align: right;'>Subtotal</th>" +
                "</tr>" +
                "</thead>" +
                "<tbody>" +
                productosHTML.toString() +
                "</tbody>" +
                "</table>" +
                "<div style='margin-top: 20px; padding-top: 20px; border-top: 2px solid #eee;'>" +
                "<p><strong>Total de productos:</strong> " + totalItems + " items</p>" +
                "<p><strong>Método de pago:</strong> " + metodoPago + "</p>" +
                "<p style='font-size: 20px; color: #4CAF50;'><strong>TOTAL: S/ " + df.format(total) + "</strong></p>" +
                "</div>" +
                "</div>" +
                "<div style='background: #fff3cd; border-left: 4px solid #ffc107; padding: 15px; margin: 20px 0;'>" +
                "<strong>⚠️ Importante:</strong> Para completar tu compra, debes confirmar tu pedido haciendo clic en el botón de abajo. Si no confirmas, el pedido será cancelado automáticamente." +
                "</div>" +
                "<div style='text-align: center; margin: 30px 0;'>" +
                "<a href='" + urlConfirmacion + "' style='display: inline-block; padding: 15px 40px; background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%); color: white; text-decoration: none; border-radius: 5px; font-weight: bold; font-size: 16px;'>✓ CONFIRMAR COMPRA</a>" +
                "</div>" +
                "<p style='color: #666; font-size: 12px; text-align: center;'>Este enlace expirará en 30 minutos por seguridad.</p>" +
                "</div>" +
                "<div style='background: #f8f9fa; padding: 20px; text-align: center; color: #666; font-size: 12px;'>" +
                "<p>Si no realizaste esta solicitud, ignora este correo.</p>" +
                "<p>&copy; 2025 MVC Tienda. Todos los derechos reservados.</p>" +
                "</div>" +
                "</div>" +
                "</body>" +
                "</html>";
    }
    
    /**
     * Construye el HTML del correo de compra exitosa
     */
    private static String construirHTMLCompraExitosa(String nombreUsuario, int numeroPedido, 
                                                     double total, String metodoPago) {
        DecimalFormat df = new DecimalFormat("#,##0.00");
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        
        return "<!DOCTYPE html>" +
                "<html>" +
                "<head><meta charset='UTF-8'></head>" +
                "<body style='font-family: Arial, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0;'>" +
                "<div style='max-width: 600px; margin: 40px auto; background: white; border-radius: 10px; overflow: hidden; box-shadow: 0 2px 10px rgba(0,0,0,0.1);'>" +
                "<div style='background: linear-gradient(135deg, #4CAF50 0%, #45a049 100%); color: white; padding: 40px 20px; text-align: center;'>" +
                "<div style='font-size: 60px; margin-bottom: 10px;'>✓</div>" +
                "<h1 style='margin: 0; font-size: 28px;'>¡Compra Confirmada!</h1>" +
                "</div>" +
                "<div style='padding: 40px 30px;'>" +
                "<h2 style='color: #333;'>Gracias " + nombreUsuario + ",</h2>" +
                "<p style='color: #666; line-height: 1.6;'>Tu compra ha sido procesada exitosamente. Adjuntamos el comprobante de tu pedido en formato PDF.</p>" +
                "<div style='background: #f8f9fa; border-radius: 10px; padding: 20px; margin: 20px 0;'>" +
                "<h3 style='margin-top: 0; color: #333;'>Detalles del Pedido:</h3>" +
                "<p><strong>Número de Pedido:</strong> #" + numeroPedido + "</p>" +
                "<p><strong>Fecha:</strong> " + sdf.format(new Date()) + "</p>" +
                "<p><strong>Método de Pago:</strong> " + metodoPago + "</p>" +
                "<p style='font-size: 24px; color: #4CAF50; margin-top: 15px;'><strong>Total: S/ " + df.format(total) + "</strong></p>" +
                "</div>" +
                "<div style='background: #e3f2fd; border-left: 4px solid #2196F3; padding: 15px; margin: 20px 0;'>" +
                "<p style='margin: 0; color: #1976D2;'>📦 Tu pedido será enviado en las próximas 24-48 horas. Te notificaremos cuando esté en camino.</p>" +
                "</div>" +
                "<p style='color: #666;'>Si tienes alguna pregunta sobre tu pedido, no dudes en contactarnos.</p>" +
                "</div>" +
                "<div style='background: #f8f9fa; padding: 20px; text-align: center; color: #666; font-size: 12px;'>" +
                "<p>Gracias por confiar en MVC Tienda</p>" +
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