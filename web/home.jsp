<%-- 
    Document   : home
    Created on : 19 oct 2025, 5:45:28 p.m.
    Author     : Mi Equipo
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Modelo.Usuario"%>
<%@page import="Modelo.ItemCarrito"%>
<%@page import="java.util.*"%>
<%
    Usuario usuario = (Usuario) session.getAttribute("usuario");
    if (usuario == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    String nombreUsuario = (String) session.getAttribute("nombreUsuario");
    String cargo = (String) session.getAttribute("cargo");
    int idCargo = (Integer) session.getAttribute("idCargo");
    
    // Contar items en el carrito
    List<ItemCarrito> carrito = (List<ItemCarrito>) session.getAttribute("carrito");
    int cantidadCarrito = 0;
    if (carrito != null) {
        for (ItemCarrito item : carrito) {
            cantidadCarrito += item.getCantidad();
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Home - MVC Tienda</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
        }
        
        .navbar {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .navbar-left {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .navbar-left h2 {
            font-size: 24px;
        }
        
        .navbar-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }
        
        .user-info {
            text-align: right;
        }
        
        .user-info .name {
            font-weight: bold;
            font-size: 16px;
        }
        
        .user-info .role {
            font-size: 12px;
            opacity: 0.9;
        }
        
        .btn-carrito {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 8px 20px;
            border: 2px solid white;
            border-radius: 5px;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 8px;
            position: relative;
        }
        
        .btn-carrito:hover {
            background: white;
            color: #667eea;
        }
        
        .badge-carrito {
            background: #f44336;
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 12px;
            font-weight: bold;
        }
        
        .btn-logout {
            background: rgba(255,255,255,0.2);
            color: white;
            padding: 8px 20px;
            border: 2px solid white;
            border-radius: 5px;
            text-decoration: none;
            transition: all 0.3s;
        }
        
        .btn-logout:hover {
            background: white;
            color: #667eea;
        }
        
        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .welcome-box {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            text-align: center;
        }
        
        .welcome-box h1 {
            color: #333;
            margin-bottom: 10px;
        }
        
        .welcome-box p {
            color: #666;
            font-size: 18px;
        }
        
        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 20px;
            margin-top: 30px;
        }
        
        .menu-card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
            transition: transform 0.3s, box-shadow 0.3s;
            cursor: pointer;
        }
        
        .menu-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
        }
        
        .menu-card.disabled {
            opacity: 0.5;
            cursor: not-allowed;
            background: #f9f9f9;
        }
        
        .menu-card.disabled:hover {
            transform: none;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .menu-card .icon {
            font-size: 60px;
            margin-bottom: 15px;
        }
        
        .menu-card h3 {
            color: #333;
            margin-bottom: 10px;
            font-size: 22px;
        }
        
        .menu-card p {
            color: #666;
            font-size: 14px;
            margin-bottom: 20px;
        }
        
        .menu-card .btn {
            display: inline-block;
            padding: 10px 25px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: all 0.3s;
        }
        
        .menu-card .btn:hover {
            transform: scale(1.05);
        }
        
        .menu-card.disabled .btn {
            background: #ccc;
            cursor: not-allowed;
            pointer-events: none;
        }
        
        .badge {
            display: inline-block;
            padding: 4px 12px;
            background: #4CAF50;
            color: white;
            border-radius: 20px;
            font-size: 12px;
            margin-left: 10px;
        }
        
        .badge.restricted {
            background: #f44336;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="navbar-left">
            <h2>🛒 MVC Tienda</h2>
        </div>
        <div class="navbar-right">
            <a href="CarritoControlador?action=ver" class="btn-carrito">
                🛒 Carrito
                <% if (cantidadCarrito > 0) { %>
                    <span class="badge-carrito"><%= cantidadCarrito %></span>
                <% } %>
            </a>
            <div class="user-info">
                <div class="name">👤 <%= nombreUsuario %></div>
                <div class="role">📋 <%= cargo %></div>
            </div>
            <a href="LoginControlador?action=logout" class="btn-logout">Cerrar Sesión</a>
        </div>
    </div>
    
    <div class="container">
        <div class="welcome-box">
            <h1>Bienvenido al Sistema</h1>
            <p>Selecciona un módulo según tus permisos</p>
        </div>
        
        <div class="menu-grid">
            <!-- CATÁLOGO DE PRODUCTOS - Todos -->
            <div class="menu-card">
                <div class="icon">📦</div>
                <h3>Catálogo de Productos <span class="badge">Disponible</span></h3>
                <p>Explora nuestro catálogo de productos y realiza compras</p>
                <a href="ProductoControlador?action=catalogo" class="btn">Ver Catálogo</a>
            </div>
            
            <!-- CARRITO DE COMPRAS - Todos -->
            <div class="menu-card">
                <div class="icon">🛒</div>
                <h3>Mi Carrito <span class="badge">Disponible</span></h3>
                <p>Revisa y gestiona tus productos en el carrito</p>
                <a href="CarritoControlador?action=ver" class="btn">Ver Carrito</a>
            </div>
            
            <!-- GESTIÓN DE USUARIOS - Solo Administrador -->
            <% if (idCargo == 1) { %>
                <div class="menu-card">
                    <div class="icon">👥</div>
                    <h3>Gestión de Usuarios <span class="badge">Admin</span></h3>
                    <p>Administrar usuarios del sistema y asignar roles</p>
                    <a href="UsuarioControlador?action=listar" class="btn">Acceder</a>
                </div>
            <% } else { %>
                <div class="menu-card disabled">
                    <div class="icon">👥</div>
                    <h3>Gestión de Usuarios <span class="badge restricted">Restringido</span></h3>
                    <p>Solo disponible para Administradores</p>
                    <a href="#" class="btn">Acceso Denegado</a>
                </div>
            <% } %>
            
            <!-- GESTIÓN DE CARGOS - Admin y Gerente -->
            <% if (idCargo == 1 || idCargo == 2) { %>
                <div class="menu-card">
                    <div class="icon">📋</div>
                    <h3>Gestión de Cargos 
                        <% if (idCargo == 1) { %>
                            <span class="badge">Admin</span>
                        <% } else { %>
                            <span class="badge">Gerente</span>
                        <% } %>
                    </h3>
                    <p>Administrar cargos y puestos de trabajo</p>
                    <a href="CargoControlador?action=listar" class="btn">Acceder</a>
                </div>
            <% } else { %>
                <div class="menu-card disabled">
                    <div class="icon">📋</div>
                    <h3>Gestión de Cargos <span class="badge restricted">Restringido</span></h3>
                    <p>Requiere rol de Gerente o superior</p>
                    <a href="#" class="btn">Acceso Denegado</a>
                </div>
            <% } %>
            
            <!-- GESTIÓN DE CLIENTES - Admin, Gerente y Vendedor -->
            <% if (idCargo == 1 || idCargo == 2 || idCargo == 3) { %>
                <div class="menu-card">
                    <div class="icon">🛍️</div>
                    <h3>Gestión de Clientes <span class="badge">Acceso</span></h3>
                    <p>Administrar información de clientes</p>
                    <a href="ClienteControlador?action=listar" class="btn">Acceder</a>
                </div>
            <% } else { %>
                <div class="menu-card disabled">
                    <div class="icon">🛍️</div>
                    <h3>Gestión de Clientes <span class="badge restricted">Restringido</span></h3>
                    <p>No tienes permisos para este módulo</p>
                    <a href="#" class="btn">Acceso Denegado</a>
                </div>
            <% } %>
        </div>
    </div>
</body>
</html>