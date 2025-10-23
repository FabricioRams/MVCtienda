/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package ModeloDao;

import Config.ConnectionConfig;
import Interfaces.CrudCargo;
import Modelo.Cargo;
import java.util.List;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 *
 * @author HP
 */
public class CargoDao implements CrudCargo{
    ConnectionConfig cn = new ConnectionConfig();
    Connection con;
    PreparedStatement ps;
    ResultSet rs;
    
    @Override
    public List<Cargo> listar() {
        List<Cargo> list = new ArrayList<>();
        String sql = "SELECT * FROM tbcargo";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                Cargo car = new Cargo();
                car.setIdCargo(rs.getInt("idcargo"));
                car.setNombre(rs.getString("nombre"));
                car.setEstado(rs.getInt("estado"));
                list.add(car);
            }
        } catch (SQLException e) {
            System.out.println("Error al listar cargos: " + e.getMessage());
        }
        return list;
    }

    @Override
    public Cargo list(int idcar) {
        Cargo car = new Cargo();
        String sql = "SELECT * FROM tbcargo WHERE idcargo = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, idcar);
            rs = ps.executeQuery();
            if (rs.next()) {
                car.setIdCargo(rs.getInt("idcargo"));
                car.setNombre(rs.getString("nombre"));
                car.setEstado(rs.getInt("estado"));
            }
        } catch (SQLException e) {
            System.out.println("Error al obtener cargo: " + e.getMessage());
        }
        return car;
    }

    @Override
    public boolean add(Cargo car) {
        String sql = "INSERT INTO tbcargo (idcargo, nombre, estado) VALUES (?, ?, ?)";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, car.getIdCargo());
            ps.setString(2, car.getNombre());
            ps.setInt(3, car.getEstado());
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error al agregar cargo: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean edit(Cargo car) {
        String sql = "UPDATE tbcargo SET nombre = ?, estado = ? WHERE idcargo = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, car.getNombre());
            ps.setInt(2, car.getEstado());
            ps.setInt(3, car.getIdCargo());
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error al editar cargo: " + e.getMessage());
            return false;
        }
    }

    @Override
    public boolean eliminar(Cargo car) {
        String sql = "DELETE FROM tbcargo WHERE idcargo = ?";
        try {
            con = cn.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, car.getIdCargo());
            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            System.out.println("Error al eliminar cargo: " + e.getMessage());
            return false;
        }
    }
}
