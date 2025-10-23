package Interfaces;

import Modelo.Usuario;
import java.util.List;

public interface CrudUsuario {
    public Usuario validar(String usuario, String clave);
    public List<Usuario> listar();
    public Usuario list(int id);
    public boolean add(Usuario usr);
    public boolean edit(Usuario usr);
    public boolean eliminar(int id);
}