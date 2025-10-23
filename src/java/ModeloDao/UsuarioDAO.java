/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloDao;

import Config.ConnectionConfig;
import Interfaces.CrudUsuario;
import Modelo.Usuario;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UsuarioDAO implements CrudUsuario {
    ConnectionConfig cn = new ConnectionConfig();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    @Override
    public Usuario validar(String usuario, String clave) {
        Usuario usr = null;
        String sql = "SELECT u.idusuario, u.usuario, u.nombre, u.apellido, u.email, "
                   + "u.idcargo, c.nombre as cargo_nombre, u.estado "
                   + "FROM tbusuario u "
                   + "INNER JOIN tbcargo c ON u.idcargo = c.idcargo "
                   + "WHERE u.usuario = ? AND u.clave = ? AND u.estado = 1";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, usuario);
            ps.setString(2, clave);
            rs = ps.executeQuery();
            if (rs.next()) {
                usr = new Usuario();
                usr.setIdUsuario(rs.getInt("idusuario"));
                usr.setUsuario(rs.getString("usuario"));
                usr.setNombre(rs.getString("nombre"));
                usr.setApellido(rs.getString("apellido"));
                usr.setEmail(rs.getString("email"));
                usr.setIdCargo(rs.getInt("idcargo"));
                usr.setCargoNombre(rs.getString("cargo_nombre"));
                usr.setEstado(rs.getInt("estado"));
            }
        } catch (SQLException e) {
            System.out.println("Error al validar usuario: " + e.getMessage());
        }
        return usr;
    }

    @Override
    public List<Usuario> listar() {
        List<Usuario> list = new ArrayList<>();
        String sql = "SELECT u.idusuario, u.usuario, u.nombre, u.apellido, u.email, "
                   + "u.idcargo, c.nombre as cargo_nombre, u.estado "
                   + "FROM tbusuario u "
                   + "INNER JOIN tbcargo c ON u.idcargo = c.idcargo";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Usuario usr = new Usuario();
                usr.setIdUsuario(rs.getInt("idusuario"));
                usr.setUsuario(rs.getString("usuario"));
                usr.setNombre(rs.getString("nombre"));
                usr.setApellido(rs.getString("apellido"));
                usr.setEmail(rs.getString("email"));
                usr.setIdCargo(rs.getInt("idcargo"));
                usr.setCargoNombre(rs.getString("cargo_nombre"));
                usr.setEstado(rs.getInt("estado"));
                list.add(usr);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar usuarios: " + e.getMessage());
        }
        return list;
    }

    @Override
    public Usuario list(int id) {
        Usuario usr = new Usuario();
        String sql = "SELECT u.idusuario, u.usuario, u.clave, u.nombre, u.apellido, u.email, "
                   + "u.idcargo, c.nombre as cargo_nombre, u.estado "
                   + "FROM tbusuario u "
                   + "INNER JOIN tbcargo c ON u.idcargo = c.idcargo "
                   + "WHERE u.idusuario = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                usr.setIdUsuario(rs.getInt("idusuario"));
                usr.setUsuario(rs.getString("usuario"));
                usr.setClave(rs.getString("clave"));
                usr.setNombre(rs.getString("nombre"));
                usr.setApellido(rs.getString("apellido"));
                usr.setEmail(rs.getString("email"));
                usr.setIdCargo(rs.getInt("idcargo"));
                usr.setCargoNombre(rs.getString("cargo_nombre"));
                usr.setEstado(rs.getInt("estado"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener usuario: " + e.getMessage());
        }
        return usr;
    }

    @Override
    public boolean add(Usuario usr) {
        String sql = "INSERT INTO tbusuario (usuario, clave, nombre, apellido, email, idcargo, estado) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, usr.getUsuario());
            ps.setString(2, usr.getClave());
            ps.setString(3, usr.getNombre());
            ps.setString(4, usr.getApellido());
            ps.setString(5, usr.getEmail());
            ps.setInt(6, usr.getIdCargo());
            ps.setInt(7, usr.getEstado());
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error al agregar usuario: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean edit(Usuario usr) {
        String sql = "UPDATE tbusuario SET usuario = ?, clave = ?, nombre = ?, apellido = ?, "
                   + "email = ?, idcargo = ?, estado = ? WHERE idusuario = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, usr.getUsuario());
            ps.setString(2, usr.getClave());
            ps.setString(3, usr.getNombre());
            ps.setString(4, usr.getApellido());
            ps.setString(5, usr.getEmail());
            ps.setInt(6, usr.getIdCargo());
            ps.setInt(7, usr.getEstado());
            ps.setInt(8, usr.getIdUsuario());
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error al editar usuario: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean eliminar(int id) {
        String sql = "DELETE FROM tbusuario WHERE idusuario = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error al eliminar usuario: " + e.getMessage());
            return false;
        }
    }
}
