/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Util;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

public class ExcelUtil {
    
    /**
     * Lee un archivo Excel y devuelve una lista de arrays de String
     * cada array representa una fila del Excel
     */
    public static List<String[]> leerExcel(InputStream inputStream) throws Exception {
        List<String[]> datos = new ArrayList<>();
        
        try (Workbook workbook = new XSSFWorkbook(inputStream)) {
            Sheet sheet = workbook.getSheetAt(0); // Primera hoja
            
            // Iterar sobre las filas (empezamos en 1 para saltar encabezados)
            for (int i = 1; i <= sheet.getLastRowNum(); i++) {
                Row row = sheet.getRow(i);
                if (row == null) continue;
                
                List<String> fila = new ArrayList<>();
                
                // Leer todas las celdas de la fila
                for (int j = 0; j < row.getLastCellNum(); j++) {
                    Cell cell = row.getCell(j);
                    fila.add(getCellValueAsString(cell));
                }
                
                datos.add(fila.toArray(new String[0]));
            }
        }
        
        return datos;
    }
    
    /**
     * Convierte el valor de una celda a String
     */
    private static String getCellValueAsString(Cell cell) {
        if (cell == null) return "";
        
        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue().trim();
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) {
                    return cell.getDateCellValue().toString();
                } else {
                    // Convertir número a String sin notación científica
                    double numValue = cell.getNumericCellValue();
                    if (numValue == (long) numValue) {
                        return String.valueOf((long) numValue);
                    }
                    return String.valueOf(numValue);
                }
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            case FORMULA:
                return cell.getCellFormula();
            case BLANK:
                return "";
            default:
                return "";
        }
    }
    
    /**
     * Valida el formato del archivo Excel para clientes
     * Retorna true si el formato es correcto
     */
    public static boolean validarFormatoCliente(List<String[]> datos) {
        if (datos.isEmpty()) return false;
        
        // Validar que cada fila tenga al menos 6 columnas
        // DNI, Nombres, Apellidos, Dirección, Email, Clave
        for (String[] fila : datos) {
            if (fila.length < 6) return false;
            if (fila[0].isEmpty() || fila[1].isEmpty() || 
                fila[2].isEmpty() || fila[5].isEmpty()) {
                return false; // DNI, Nombres, Apellidos y Clave son obligatorios
            }
        }
        return true;
    }
    
    /**
     * Valida el formato del archivo Excel para usuarios
     * Retorna true si el formato es correcto
     */
    public static boolean validarFormatoUsuario(List<String[]> datos) {
        if (datos.isEmpty()) return false;
        
        // Validar que cada fila tenga al menos 7 columnas
        // Usuario, Clave, Nombre, Apellido, Email, IdCargo, Estado
        for (String[] fila : datos) {
            if (fila.length < 7) return false;
            if (fila[0].isEmpty() || fila[1].isEmpty() || 
                fila[2].isEmpty() || fila[3].isEmpty() || fila[5].isEmpty()) {
                return false; // Usuario, Clave, Nombre, Apellido e IdCargo son obligatorios
            }
        }
        return true;
    }
}