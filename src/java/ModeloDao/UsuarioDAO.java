package ModeloDao;

import Config.ConnectionConfig;
import Interfaces.CrudUsuario;
import Modelo.Usuario;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class UsuarioDAO implements CrudUsuario {
    ConnectionConfig cn = new ConnectionConfig();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;

    @Override
    public Usuario validar(String usuario, String clave) {
        Usuario usr = null;
        String sql = "SELECT u.idusuario, u.usuario, u.nombre, u.apellido, u.email, "
                   + "u.idcargo, c.nombre as cargo_nombre, u.estado, u.email_verificado "
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
                usr.setEmailVerificado(rs.getBoolean("email_verificado"));
            }
        } catch (SQLException e) {
            System.out.println("Error al validar usuario: " + e.getMessage());
        }
        return usr;
    }
    
    /**
     * Registra un nuevo usuario con token de verificación
     */
    public boolean registrarUsuario(Usuario usr) {
        String sql = "INSERT INTO tbusuario (usuario, clave, nombre, apellido, email, idcargo, estado, token_verificacion, email_verificado) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, usr.getUsuario());
            ps.setString(2, usr.getClave());
            ps.setString(3, usr.getNombre());
            ps.setString(4, usr.getApellido());
            ps.setString(5, usr.getEmail());
            ps.setInt(6, usr.getIdCargo());
            ps.setInt(7, 0); // Estado inactivo hasta verificar email
            ps.setString(8, usr.getTokenVerificacion());
            ps.setBoolean(9, false); // Email no verificado
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error al registrar usuario: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Verifica si un usuario ya existe
     */
    public boolean existeUsuario(String usuario) {
        String sql = "SELECT COUNT(*) FROM tbusuario WHERE usuario = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, usuario);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error al verificar existencia de usuario: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Verifica si un email ya existe
     */
    public boolean existeEmail(String email) {
        String sql = "SELECT COUNT(*) FROM tbusuario WHERE email = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error al verificar existencia de email: " + e.getMessage());
        }
        return false;
    }
    
    /**
     * Verifica el token y activa la cuenta
     */
    public boolean verificarToken(String token) {
        String sql = "UPDATE tbusuario SET email_verificado = 1, estado = 1, token_verificacion = NULL "
                   + "WHERE token_verificacion = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, token);
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error al verificar token: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Obtiene el email de un usuario por su token
     */
    public String obtenerEmailPorToken(String token) {
        String sql = "SELECT email, nombre, apellido FROM tbusuario WHERE token_verificacion = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, token);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("email");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener email por token: " + e.getMessage());
        }
        return null;
    }
    
    /**
     * Obtiene nombre completo por token
     */
    public String obtenerNombrePorToken(String token) {
        String sql = "SELECT nombre, apellido FROM tbusuario WHERE token_verificacion = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, token);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("nombre") + " " + rs.getString("apellido");
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener nombre por token: " + e.getMessage());
        }
        return null;
    }
    
    /**
     * Genera un token único para verificación
     */
    public static String generarToken() {
        return UUID.randomUUID().toString();
    }

    @Override
    public List<Usuario> listar() {
        List<Usuario> list = new ArrayList<>();
        String sql = "SELECT u.idusuario, u.usuario, u.nombre, u.apellido, u.email, "
                   + "u.idcargo, c.nombre as cargo_nombre, u.estado, u.email_verificado "
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
                usr.setEmailVerificado(rs.getBoolean("email_verificado"));
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
                   + "u.idcargo, c.nombre as cargo_nombre, u.estado, u.email_verificado "
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
                usr.setEmailVerificado(rs.getBoolean("email_verificado"));
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