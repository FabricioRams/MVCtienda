/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Interface.java to edit this template
 */
package Interfaces;
import Modelo.Cliente;
import java.util.List;
/**
 *
 * @author HP
 */
public interface CrudCliente {
    public List listar();
    public Cliente list(String dni);
    public boolean add (Cliente cli);
    public boolean edit (Cliente cli);
    public boolean eliminar (String dni);
}
