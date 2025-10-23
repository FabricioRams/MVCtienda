/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Interfaces;

import Modelo.Cargo;
import java.util.List;

/**
 *
 * @author HP
 */
public interface CrudCargo {
    public List listar();
    public Cargo list(int idcar);
    public boolean add(Cargo car);
    public boolean edit(Cargo car);
    public boolean eliminar(Cargo car);
}
