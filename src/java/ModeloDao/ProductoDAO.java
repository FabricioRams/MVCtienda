/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloDao;

import Config.ConnectionConfig;
import Interfaces.CrudProducto;
import Modelo.Producto;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductoDAO implements CrudProducto {
    ConnectionConfig cn = new ConnectionConfig();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    @Override
    public List<Producto> listar() {
        List<Producto> lista = new ArrayList<>();
        String sql = "SELECT p.idproducto, p.nombre, p.descripcion, p.precio, p.stock, " +
                     "p.idmodelo, p.idcolor, p.idtalla, p.imagen, p.activo, " +
                     "mo.nombre as nombreModelo, ma.nombre as nombreMarca, " +
                     "c.nombre as nombreColor, c.codigo_hex as codigoHexColor, " +
                     "t.valor as valorTalla " +
                     "FROM tbproducto p " +
                     "INNER JOIN tbmodelo mo ON p.idmodelo = mo.idmodelo " +
                     "INNER JOIN tbmarca ma ON mo.idmarca = ma.idmarca " +
                     "INNER JOIN tbcolor c ON p.idcolor = c.idcolor " +
                     "INNER JOIN tbtalla t ON p.idtalla = t.idtalla " +
                     "WHERE p.activo = 1 AND p.stock > 0";
        
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                Producto p = new Producto();
                p.setIdProducto(rs.getInt("idproducto"));
                p.setNombre(rs.getString("nombre"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setPrecio(rs.getDouble("precio"));
                p.setStock(rs.getInt("stock"));
                p.setIdModelo(rs.getInt("idmodelo"));
                p.setIdColor(rs.getInt("idcolor"));
                p.setIdTalla(rs.getInt("idtalla"));
                p.setImagen(rs.getString("imagen"));
                p.setActivo(rs.getInt("activo"));
                p.setNombreModelo(rs.getString("nombreModelo"));
                p.setNombreMarca(rs.getString("nombreMarca"));
                p.setNombreColor(rs.getString("nombreColor"));
                p.setCodigoHexColor(rs.getString("codigoHexColor"));
                p.setValorTalla(rs.getString("valorTalla"));
                lista.add(p);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar productos: " + e.getMessage());
        }
        return lista;
    }

    @Override
    public Producto obtenerPorId(int id) {
        Producto p = null;
        String sql = "SELECT p.idproducto, p.nombre, p.descripcion, p.precio, p.stock, " +
                     "p.idmodelo, p.idcolor, p.idtalla, p.imagen, p.activo, " +
                     "mo.nombre as nombreModelo, ma.nombre as nombreMarca, " +
                     "c.nombre as nombreColor, c.codigo_hex as codigoHexColor, " +
                     "t.valor as valorTalla " +
                     "FROM tbproducto p " +
                     "INNER JOIN tbmodelo mo ON p.idmodelo = mo.idmodelo " +
                     "INNER JOIN tbmarca ma ON mo.idmarca = ma.idmarca " +
                     "INNER JOIN tbcolor c ON p.idcolor = c.idcolor " +
                     "INNER JOIN tbtalla t ON p.idtalla = t.idtalla " +
                     "WHERE p.idproducto = ?";
        
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                p = new Producto();
                p.setIdProducto(rs.getInt("idproducto"));
                p.setNombre(rs.getString("nombre"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setPrecio(rs.getDouble("precio"));
                p.setStock(rs.getInt("stock"));
                p.setIdModelo(rs.getInt("idmodelo"));
                p.setIdColor(rs.getInt("idcolor"));
                p.setIdTalla(rs.getInt("idtalla"));
                p.setImagen(rs.getString("imagen"));
                p.setActivo(rs.getInt("activo"));
                p.setNombreModelo(rs.getString("nombreModelo"));
                p.setNombreMarca(rs.getString("nombreMarca"));
                p.setNombreColor(rs.getString("nombreColor"));
                p.setCodigoHexColor(rs.getString("codigoHexColor"));
                p.setValorTalla(rs.getString("valorTalla"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener producto: " + e.getMessage());
        }
        return p;
    }

    @Override
    public boolean actualizarStock(int idProducto, int cantidad) {
        String sql = "UPDATE tbproducto SET stock = stock - ? WHERE idproducto = ? AND stock >= ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, cantidad);
            ps.setInt(2, idProducto);
            ps.setInt(3, cantidad);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error al actualizar stock: " + e.getMessage());
            return false;
        }
    }
}