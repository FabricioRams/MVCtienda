/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloDao;
import Config.ConnectionConfig;
import Interfaces.CrudCliente;
import Modelo.Cliente;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
/**
 *
 * @author HP
 */
public class ClienteDAO implements CrudCliente{
    ConnectionConfig cn = new ConnectionConfig();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    @Override
    public List<Cliente> listar() {
        List<Cliente> list = new ArrayList<>();
        String sql = "SELECT * FROM tbcliente";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Cliente c = new Cliente();
                c.setDni(rs.getString("dni"));
                c.setNombres(rs.getString("nombres"));
                c.setApellidos(rs.getString("apellidos"));
                c.setDireccion(rs.getString("direccion"));
                c.setEmail(rs.getString("email"));
                c.setClave(rs.getString("clave"));
                list.add(c);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar clientes: " + e.getMessage());
        }
        return list;
    }

    @Override
    public Cliente list(String dni) {
        Cliente c = new Cliente();
        String sql = "SELECT * FROM tbcliente WHERE dni = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, dni);
            rs = ps.executeQuery();
            if (rs.next()) {
                c.setDni(rs.getString("dni"));
                c.setNombres(rs.getString("nombres"));
                c.setApellidos(rs.getString("apellidos"));
                c.setDireccion(rs.getString("direccion"));
                c.setEmail(rs.getString("email"));
                c.setClave(rs.getString("clave"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener cliente: " + e.getMessage());
        }
        return c;
    }

    @Override
    public boolean add(Cliente cli) {
        String sql = "INSERT INTO tbcliente (dni, nombres, apellidos, direccion, email, clave) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, cli.getDni());
            ps.setString(2, cli.getNombres());
            ps.setString(3, cli.getApellidos());
            ps.setString(4, cli.getDireccion());
            ps.setString(5, cli.getEmail());
            ps.setString(6, cli.getClave());
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error al agregar cliente: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean edit(Cliente cli) {
        String sql = "UPDATE tbcliente SET nombres = ?, apellidos = ?, direccion = ?, email = ?, clave = ? WHERE dni = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, cli.getNombres());
            ps.setString(2, cli.getApellidos());
            ps.setString(3, cli.getDireccion());
            ps.setString(4, cli.getEmail());
            ps.setString(5, cli.getClave());
            ps.setString(6, cli.getDni());
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error al editar cliente: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean eliminar(String dni) {
        String sql = "DELETE FROM tbcliente WHERE dni = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, dni);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error al eliminar cliente: " + e.getMessage());
            return false;
        }
    }
}
