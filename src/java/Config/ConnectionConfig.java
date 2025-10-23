/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author HP
 */
public class ConnectionConfig {
    
    private final Connection connection;
    
    public Connection getConnection(){
        return connection;
    }

    public ConnectionConfig() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection("jdbc:mysql://localhost:3306/mvc_tienda", "root", "");
        } catch (ClassNotFoundException e) {
            System.err.println("No se encontró el driver MySQL: " + e.getMessage());
            throw new RuntimeException("No se encontró el driver MySQL", e);
        } catch (SQLException e) {
            System.err.println("Error al conectar a la base de datos: " + e.getMessage());
            throw new RuntimeException("Error al conectar a la base de datos", e);
        }
        if (connection == null) {
            throw new RuntimeException("La conexión a la base de datos es nula. Verifica la configuración.");
        }
    }
}