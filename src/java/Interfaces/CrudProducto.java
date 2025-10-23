/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package Interfaces;

import Modelo.Producto;
import java.util.List;

public interface CrudProducto {
    public List<Producto> listar();
    public Producto obtenerPorId(int id);
    public boolean actualizarStock(int idProducto, int cantidad);
}