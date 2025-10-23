/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Util;

import com.lowagie.text.*;
import com.lowagie.text.pdf.*;
import Modelo.Cliente;
import Modelo.Usuario;
import java.io.ByteArrayOutputStream;
import java.util.List;
import java.awt.Color;

public class PDFUtil {
    
    /**
     * Genera un PDF con la lista de clientes
     */
    public static ByteArrayOutputStream generarPDFClientes(List<Cliente> clientes) throws Exception {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document document = new Document(PageSize.A4.rotate()); // Horizontal
        
        try {
            PdfWriter.getInstance(document, baos);
            document.open();
            
            // Título
            Font titleFont = new Font(Font.HELVETICA, 18, Font.BOLD, new Color(102, 126, 234));
            Paragraph title = new Paragraph("LISTADO DE CLIENTES", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            document.add(title);
            
            // Fecha de generación
            Font dateFont = new Font(Font.HELVETICA, 10, Font.NORMAL, Color.GRAY);
            Paragraph date = new Paragraph("Generado: " + new java.util.Date().toString(), dateFont);
            date.setAlignment(Element.ALIGN_RIGHT);
            date.setSpacingAfter(20);
            document.add(date);
            
            // Tabla
            PdfPTable table = new PdfPTable(6); // 6 columnas
            table.setWidthPercentage(100);
            table.setWidths(new float[]{1f, 2f, 2f, 3f, 3f, 2f});
            
            // Encabezados
            Font headerFont = new Font(Font.HELVETICA, 10, Font.BOLD, Color.WHITE);
            Color headerColor = new Color(102, 126, 234);
            
            String[] headers = {"DNI", "NOMBRES", "APELLIDOS", "DIRECCIÓN", "EMAIL", "ESTADO"};
            for (String header : headers) {
                PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
                cell.setBackgroundColor(headerColor);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setPadding(8);
                table.addCell(cell);
            }
            
            // Datos
            Font dataFont = new Font(Font.HELVETICA, 9, Font.NORMAL);
            for (Cliente cliente : clientes) {
                table.addCell(new Phrase(cliente.getDni(), dataFont));
                table.addCell(new Phrase(cliente.getNombres(), dataFont));
                table.addCell(new Phrase(cliente.getApellidos(), dataFont));
                table.addCell(new Phrase(cliente.getDireccion() != null ? cliente.getDireccion() : "", dataFont));
                table.addCell(new Phrase(cliente.getEmail() != null ? cliente.getEmail() : "", dataFont));
                
                PdfPCell estadoCell = new PdfPCell(new Phrase("Activo", dataFont));
                estadoCell.setBackgroundColor(new Color(200, 255, 200));
                estadoCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                table.addCell(estadoCell);
            }
            
            document.add(table);
            
            // Pie de página
            Paragraph footer = new Paragraph("\nTotal de clientes: " + clientes.size(), 
                new Font(Font.HELVETICA, 10, Font.BOLD));
            footer.setSpacingBefore(20);
            document.add(footer);
            
        } finally {
            document.close();
        }
        
        return baos;
    }
    
    /**
     * Genera un PDF con la lista de usuarios
     */
    public static ByteArrayOutputStream generarPDFUsuarios(List<Usuario> usuarios) throws Exception {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        Document document = new Document(PageSize.A4.rotate()); // Horizontal
        
        try {
            PdfWriter.getInstance(document, baos);
            document.open();
            
            // Título
            Font titleFont = new Font(Font.HELVETICA, 18, Font.BOLD, new Color(102, 126, 234));
            Paragraph title = new Paragraph("LISTADO DE USUARIOS DEL SISTEMA", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            document.add(title);
            
            // Fecha de generación
            Font dateFont = new Font(Font.HELVETICA, 10, Font.NORMAL, Color.GRAY);
            Paragraph date = new Paragraph("Generado: " + new java.util.Date().toString(), dateFont);
            date.setAlignment(Element.ALIGN_RIGHT);
            date.setSpacingAfter(20);
            document.add(date);
            
            // Tabla
            PdfPTable table = new PdfPTable(7); // 7 columnas
            table.setWidthPercentage(100);
            table.setWidths(new float[]{0.8f, 1.5f, 1.8f, 1.8f, 2.5f, 1.5f, 1f});
            
            // Encabezados
            Font headerFont = new Font(Font.HELVETICA, 10, Font.BOLD, Color.WHITE);
            Color headerColor = new Color(102, 126, 234);
            
            String[] headers = {"ID", "USUARIO", "NOMBRE", "APELLIDO", "EMAIL", "CARGO", "ESTADO"};
            for (String header : headers) {
                PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
                cell.setBackgroundColor(headerColor);
                cell.setHorizontalAlignment(Element.ALIGN_CENTER);
                cell.setPadding(8);
                table.addCell(cell);
            }
            
            // Datos
            Font dataFont = new Font(Font.HELVETICA, 9, Font.NORMAL);
            for (Usuario usuario : usuarios) {
                table.addCell(new Phrase(String.valueOf(usuario.getIdUsuario()), dataFont));
                table.addCell(new Phrase(usuario.getUsuario(), dataFont));
                table.addCell(new Phrase(usuario.getNombre(), dataFont));
                table.addCell(new Phrase(usuario.getApellido(), dataFont));
                table.addCell(new Phrase(usuario.getEmail() != null ? usuario.getEmail() : "", dataFont));
                table.addCell(new Phrase(usuario.getCargoNombre(), dataFont));
                
                String estadoText = usuario.getEstado() == 1 ? "Activo" : "Inactivo";
                Color estadoColor = usuario.getEstado() == 1 ? 
                    new Color(200, 255, 200) : new Color(255, 200, 200);
                    
                PdfPCell estadoCell = new PdfPCell(new Phrase(estadoText, dataFont));
                estadoCell.setBackgroundColor(estadoColor);
                estadoCell.setHorizontalAlignment(Element.ALIGN_CENTER);
                table.addCell(estadoCell);
            }
            
            document.add(table);
            
            // Pie de página
            Paragraph footer = new Paragraph("\nTotal de usuarios: " + usuarios.size(), 
                new Font(Font.HELVETICA, 10, Font.BOLD));
            footer.setSpacingBefore(20);
            document.add(footer);
            
        } finally {
            document.close();
        }
        
        return baos;
    }
}