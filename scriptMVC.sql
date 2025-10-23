-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versión del servidor:         10.4.32-MariaDB - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             12.11.0.7065
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Volcando estructura de base de datos para mvc_tienda
CREATE DATABASE IF NOT EXISTS `mvc_tienda` /*!40100 DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci */;
USE `mvc_tienda`;

-- Volcando estructura para tabla mvc_tienda.tbcargo
CREATE TABLE IF NOT EXISTS `tbcargo` (
  `idcargo` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `estado` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (`idcargo`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Volcando datos para la tabla mvc_tienda.tbcargo: ~4 rows (aproximadamente)
INSERT INTO `tbcargo` (`idcargo`, `nombre`, `estado`) VALUES
	(1, 'Administrador', 1),
	(2, 'Gerente', 1),
	(3, 'Vendedor', 1),
	(4, 'Cliente', 1);

-- Volcando estructura para tabla mvc_tienda.tbcliente
CREATE TABLE IF NOT EXISTS `tbcliente` (
  `dni` varchar(8) NOT NULL,
  `nombres` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `direccion` varchar(200) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `clave` varchar(100) NOT NULL,
  `estado` int(11) NOT NULL DEFAULT 1,
  `fecha_registro` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`dni`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Volcando datos para la tabla mvc_tienda.tbcliente: ~2 rows (aproximadamente)
INSERT INTO `tbcliente` (`dni`, `nombres`, `apellidos`, `direccion`, `email`, `clave`, `estado`, `fecha_registro`) VALUES
	('12345678', 'Pedro', 'Sánchez', 'Av. Principal 123', 'pedro@email.com', '123456', 1, '2025-10-19 17:37:26'),
	('87654321', 'Lucía', 'Fernández', 'Calle Secundaria 456', 'lucia@email.com', '123456', 1, '2025-10-19 17:37:26');

-- Volcando estructura para tabla mvc_tienda.tbcolor
CREATE TABLE IF NOT EXISTS `tbcolor` (
  `idcolor` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) NOT NULL,
  `codigo_hex` varchar(7) DEFAULT NULL,
  PRIMARY KEY (`idcolor`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla mvc_tienda.tbcolor: ~8 rows (aproximadamente)
INSERT INTO `tbcolor` (`idcolor`, `nombre`, `codigo_hex`) VALUES
	(1, 'Negro', '#000000'),
	(2, 'Blanco', '#FFFFFF'),
	(3, 'Rojo', '#FF0000'),
	(4, 'Azul Marino', '#000080'),
	(5, 'Verde Oliva', '#808000'),
	(6, 'Gris', '#808080'),
	(7, 'Azul', '#0000FF'),
	(8, 'Verde', '#008000');

-- Volcando estructura para tabla mvc_tienda.tbmarca
CREATE TABLE IF NOT EXISTS `tbmarca` (
  `idmarca` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  `descripcion` text DEFAULT NULL,
  PRIMARY KEY (`idmarca`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla mvc_tienda.tbmarca: ~5 rows (aproximadamente)
INSERT INTO `tbmarca` (`idmarca`, `nombre`, `descripcion`) VALUES
	(1, 'Nike', 'Marca deportiva internacional'),
	(2, 'Adidas', 'Marca deportiva alemana'),
	(3, 'Zara', 'Marca de moda española'),
	(4, 'Puma', 'Marca deportiva alemana'),
	(5, 'H&M', 'Marca de moda sueca');

-- Volcando estructura para tabla mvc_tienda.tbmodelo
CREATE TABLE IF NOT EXISTS `tbmodelo` (
  `idmodelo` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `idmarca` int(11) NOT NULL,
  PRIMARY KEY (`idmodelo`),
  KEY `idmarca` (`idmarca`),
  CONSTRAINT `tbmodelo_ibfk_1` FOREIGN KEY (`idmarca`) REFERENCES `tbmarca` (`idmarca`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla mvc_tienda.tbmodelo: ~8 rows (aproximadamente)
INSERT INTO `tbmodelo` (`idmodelo`, `nombre`, `descripcion`, `idmarca`) VALUES
	(1, 'Air Force 1', 'Zapatillas deportivas clásicas', 1),
	(2, 'Dri-FIT Legend', 'Camiseta de entrenamiento', 1),
	(3, 'Ultraboost', 'Zapatillas running', 2),
	(4, 'Tiro 21', 'Pantalones de entrenamiento', 2),
	(5, 'Pantalón Tapered', 'Pantalón de vestir ajustado', 3),
	(6, 'Blusa Basic', 'Blusa básica femenina', 3),
	(7, 'RS-X', 'Zapatillas urbanas', 4),
	(8, 'Training Top', 'Top de entrenamiento', 4);

-- Volcando estructura para tabla mvc_tienda.tbproducto
CREATE TABLE IF NOT EXISTS `tbproducto` (
  `idproducto` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(150) NOT NULL,
  `descripcion` text DEFAULT NULL,
  `precio` decimal(10,2) NOT NULL,
  `stock` int(11) NOT NULL DEFAULT 0,
  `idmodelo` int(11) NOT NULL,
  `idcolor` int(11) NOT NULL,
  `idtalla` int(11) NOT NULL,
  `imagen` varchar(255) DEFAULT NULL,
  `fecha_creacion` timestamp NOT NULL DEFAULT current_timestamp(),
  `activo` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`idproducto`),
  KEY `idmodelo` (`idmodelo`),
  KEY `idcolor` (`idcolor`),
  KEY `idtalla` (`idtalla`),
  CONSTRAINT `tbproducto_ibfk_1` FOREIGN KEY (`idmodelo`) REFERENCES `tbmodelo` (`idmodelo`),
  CONSTRAINT `tbproducto_ibfk_2` FOREIGN KEY (`idcolor`) REFERENCES `tbcolor` (`idcolor`),
  CONSTRAINT `tbproducto_ibfk_3` FOREIGN KEY (`idtalla`) REFERENCES `tbtalla` (`idtalla`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla mvc_tienda.tbproducto: ~20 rows (aproximadamente)
INSERT INTO `tbproducto` (`idproducto`, `nombre`, `descripcion`, `precio`, `stock`, `idmodelo`, `idcolor`, `idtalla`, `imagen`, `fecha_creacion`, `activo`) VALUES
	(1, 'Zapatillas Nike Air Force 1 Blancas', 'Zapatillas deportivas clásicas de cuero blanco', 299.90, 22, 1, 2, 13, NULL, '2025-10-20 04:09:20', 1),
	(2, 'Camiseta Nike Dri-FIT Legend Negra', 'Camiseta de entrenamiento con tecnología Dri-FIT', 89.90, 48, 2, 1, 2, NULL, '2025-10-20 04:09:20', 1),
	(3, 'Zapatillas Adidas Ultraboost Azul Marino', 'Zapatillas running con tecnología Boost', 399.90, 10, 3, 4, 13, NULL, '2025-10-20 04:09:20', 1),
	(4, 'Pantalón Zara Tapered Negro', 'Pantalón de vestir ajustado color negro', 129.90, 29, 5, 1, 7, NULL, '2025-10-20 04:09:20', 1),
	(5, 'Blusa Zara Basic Blanca', 'Blusa básica femenina color blanco', 79.90, 39, 6, 2, 1, NULL, '2025-10-20 04:09:20', 1),
	(6, 'Zapatillas Nike Air Force 1 Negras', 'Zapatillas deportivas clásicas de cuero negro', 299.90, 17, 1, 1, 12, NULL, '2025-10-20 04:09:20', 1),
	(7, 'Camiseta Nike Dri-FIT Legend Blanca', 'Camiseta de entrenamiento blanca', 89.90, 35, 2, 2, 3, NULL, '2025-10-20 04:09:20', 1),
	(8, 'Zapatillas Adidas Ultraboost Negras', 'Zapatillas running negras', 399.90, 15, 3, 1, 14, NULL, '2025-10-20 04:09:20', 1),
	(9, 'Pantalón Adidas Tiro 21 Negro', 'Pantalones de entrenamiento deportivos', 149.90, 25, 4, 1, 2, NULL, '2025-10-20 04:09:20', 1),
	(10, 'Pantalón Zara Tapered Gris', 'Pantalón de vestir gris', 129.90, 20, 5, 6, 8, NULL, '2025-10-20 04:09:20', 1),
	(11, 'Blusa Zara Basic Roja', 'Blusa básica femenina roja', 79.90, 29, 6, 3, 2, NULL, '2025-10-20 04:09:20', 1),
	(12, 'Zapatillas Puma RS-X Blancas', 'Zapatillas urbanas retro', 279.90, 12, 7, 2, 13, NULL, '2025-10-20 04:09:20', 1),
	(13, 'Zapatillas Puma RS-X Negras', 'Zapatillas urbanas negras', 279.90, 16, 7, 1, 14, NULL, '2025-10-20 04:09:20', 1),
	(14, 'Top Puma Training Negro', 'Top de entrenamiento para mujer', 69.90, 40, 8, 1, 1, NULL, '2025-10-20 04:09:20', 1),
	(15, 'Top Puma Training Blanco', 'Top de entrenamiento blanco', 69.90, 35, 8, 2, 2, NULL, '2025-10-20 04:09:20', 1),
	(16, 'Camiseta Nike Dri-FIT Legend Azul', 'Camiseta de entrenamiento azul', 89.90, 28, 2, 7, 3, NULL, '2025-10-20 04:09:20', 1),
	(17, 'Pantalón Adidas Tiro 21 Azul Marino', 'Pantalones deportivos azul marino', 149.90, 22, 4, 4, 3, NULL, '2025-10-20 04:09:20', 1),
	(18, 'Zapatillas Adidas Ultraboost Rojas', 'Zapatillas running rojas', 399.90, 8, 3, 3, 12, NULL, '2025-10-20 04:09:20', 1),
	(19, 'Blusa Zara Basic Azul', 'Blusa básica azul', 79.90, 25, 6, 7, 1, NULL, '2025-10-20 04:09:20', 1),
	(20, 'Zapatillas Nike Air Force 1 Rojas', 'Zapatillas deportivas rojas', 299.90, 14, 1, 3, 14, NULL, '2025-10-20 04:09:20', 1);

-- Volcando estructura para tabla mvc_tienda.tbtalla
CREATE TABLE IF NOT EXISTS `tbtalla` (
  `idtalla` int(11) NOT NULL AUTO_INCREMENT,
  `valor` varchar(10) NOT NULL,
  `idtipotalla` int(11) NOT NULL,
  PRIMARY KEY (`idtalla`),
  KEY `idtipotalla` (`idtipotalla`),
  CONSTRAINT `tbtalla_ibfk_1` FOREIGN KEY (`idtipotalla`) REFERENCES `tbtipotalla` (`idtipotalla`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla mvc_tienda.tbtalla: ~15 rows (aproximadamente)
INSERT INTO `tbtalla` (`idtalla`, `valor`, `idtipotalla`) VALUES
	(1, 'S', 1),
	(2, 'M', 1),
	(3, 'L', 1),
	(4, 'XL', 1),
	(5, 'XXL', 1),
	(6, '28', 2),
	(7, '30', 2),
	(8, '32', 2),
	(9, '34', 2),
	(10, '36', 2),
	(11, '6', 3),
	(12, '7', 3),
	(13, '8', 3),
	(14, '9', 3),
	(15, '10', 3);

-- Volcando estructura para tabla mvc_tienda.tbtipotalla
CREATE TABLE IF NOT EXISTS `tbtipotalla` (
  `idtipotalla` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(20) NOT NULL,
  `descripcion` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`idtipotalla`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Volcando datos para la tabla mvc_tienda.tbtipotalla: ~3 rows (aproximadamente)
INSERT INTO `tbtipotalla` (`idtipotalla`, `nombre`, `descripcion`) VALUES
	(1, 'INTERNACIONAL', 'Tallas S, M, L, XL'),
	(2, 'NUMERICA_USA', 'Tallas numéricas 28, 30, 32'),
	(3, 'CALZADO_USA', 'Tallas de calzado 6, 7, 8, 9');

-- Volcando estructura para tabla mvc_tienda.tbusuario
CREATE TABLE IF NOT EXISTS `tbusuario` (
  `idusuario` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(50) NOT NULL,
  `clave` varchar(100) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellido` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `idcargo` int(11) NOT NULL,
  `estado` int(11) NOT NULL DEFAULT 1,
  `fecha_registro` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`idusuario`),
  UNIQUE KEY `usuario` (`usuario`),
  KEY `fk_cargo` (`idcargo`),
  CONSTRAINT `fk_cargo` FOREIGN KEY (`idcargo`) REFERENCES `tbcargo` (`idcargo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- Volcando datos para la tabla mvc_tienda.tbusuario: ~5 rows (aproximadamente)
INSERT INTO `tbusuario` (`idusuario`, `usuario`, `clave`, `nombre`, `apellido`, `email`, `idcargo`, `estado`, `fecha_registro`) VALUES
	(1, 'admin', '123456', 'Juan', 'Pérez', 'admin@tienda.com', 1, 1, '2025-10-19 17:37:26'),
	(2, 'gerente1', '123456', 'María', 'García', 'gerente@tienda.com', 2, 1, '2025-10-19 17:37:26'),
	(3, 'vendedor1', '123456', 'Carlos', 'López', 'vendedor@tienda.com', 3, 1, '2025-10-19 17:37:26'),
	(4, 'vendedor2', '123456', 'Ana', 'Martínez', 'ana@tienda.com', 3, 1, '2025-10-19 17:37:26'),
	(5, 'cliente', '123456', 'Cliente', '2', 'ola@gmail.com', 4, 1, '2025-10-19 18:36:22');

-- Volcando estructura para vista mvc_tienda.vw_usuarios
-- Creando tabla temporal para superar errores de dependencia de VIEW
CREATE TABLE `vw_usuarios` (
	`idusuario` INT(11) NOT NULL,
	`usuario` VARCHAR(1) NOT NULL COLLATE 'latin1_swedish_ci',
	`nombre` VARCHAR(1) NOT NULL COLLATE 'latin1_swedish_ci',
	`apellido` VARCHAR(1) NOT NULL COLLATE 'latin1_swedish_ci',
	`email` VARCHAR(1) NULL COLLATE 'latin1_swedish_ci',
	`idcargo` INT(11) NOT NULL,
	`cargo_nombre` VARCHAR(1) NOT NULL COLLATE 'latin1_swedish_ci',
	`estado` INT(11) NOT NULL,
	`fecha_registro` DATETIME NULL
);

-- Eliminando tabla temporal y crear estructura final de VIEW
DROP TABLE IF EXISTS `vw_usuarios`;
CREATE ALGORITHM=UNDEFINED SQL SECURITY DEFINER VIEW `vw_usuarios` AS SELECT 
    u.idusuario,
    u.usuario,
    u.nombre,
    u.apellido,
    u.email,
    u.idcargo,
    c.nombre as cargo_nombre,
    u.estado,
    u.fecha_registro
FROM tbusuario u
INNER JOIN tbcargo c ON u.idcargo = c.idcargo 
;

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
