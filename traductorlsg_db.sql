-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 07-11-2024 a las 23:12:12
-- Versión del servidor: 10.4.25-MariaDB
-- Versión de PHP: 7.4.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

--
-- Base de datos: `traductorlsp_db`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `modeloai`
--

CREATE TABLE `modeloai` (
  `id_modelo` int(11) NOT NULL,
  `version` varchar(100) DEFAULT NULL,
  `contenido` varchar(150) DEFAULT NULL,
  `fecha_entrenamiento` date DEFAULT NULL,
  `rol` varchar(100) DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT current_timestamp(),
  `fecha_modificacion` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (id_modelo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `modeloai`
--

INSERT INTO `modeloai` (`id_modelo`, `version`, `contenido`, `fecha_entrenamiento`, `rol`, `fecha_creacion`, `fecha_modificacion`) VALUES
(1, '1.0', 'Modelo de Lengua de Señas Peruano Con Precisión del 85.4%', '2025-04-10', 'online', '2025-5-10 05:47:18', '2025-5-10 05:47:18'),
(2, '2.0', 'Modelo de Lengua de Señas Peruano Con Precisión del 85.4%', '2025-04-10', 'online', '2025-5-11 05:47:18', '2025-5-11 05:47:18');
-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE `usuario` (
  `id_usuario` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `apellido` varchar(100) DEFAULT NULL,
  `correo` varchar(150) DEFAULT NULL,
  `contrasenia` varchar(100) DEFAULT NULL,
  `rol` varchar(100) DEFAULT NULL,
  `imagen` varchar(500) DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT current_timestamp(),
  `fecha_modificacion` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id_usuario`, `nombre`, `apellido`, `correo`, `contrasenia`, `rol`, `imagen`, `fecha_creacion`, `fecha_modificacion`) VALUES
(1, 'admin', 'admin', 'admin@admin.com', 'admin', 'admin', '', '2025-5-7 19:55:43', '2025-5-7 16:28:14'),
(8, 'user ', 'user ', 'user@gmail.com', 'user', 'user', '', '2024-5-7 04:45:38', '2025-5-7 04:14:19');

-- --------------------------------------------------------
--
-- Estructura de tabla para la tabla `traduccion`
--

CREATE TABLE `traduccion` (
  `id_traduccion` int(11) NOT NULL,
  `texto_traducido` varchar(1000) DEFAULT NULL,
  `gesto_capturado` varchar(1000) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `precision` varchar(1000) DEFAULT NULL,
  `id_usuario` int(11) DEFAULT NULL,
  `id_modelo` int(11) DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT current_timestamp(),
  `fecha_modificacion` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (id_traduccion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Volcado de datos para la tabla `traduccion`
--

INSERT INTO `traduccion` (`id_traduccion`, `texto_traducido`, `gesto_capturado`, `fecha`, `precision`, `id_usuario`, `id_modelo`, `fecha_creacion`, `fecha_modificacion`) VALUES
(1, 'S', '', '2025-5-5', '82.7275872230529897', 1, 2, '2025-5-5 18:18:18', '2025-5-5 18:18:18');

ALTER TABLE traduccion
  ADD CONSTRAINT fk_traduccion_modelo FOREIGN KEY (id_modelo) REFERENCES modeloai(id_modelo),
  ADD CONSTRAINT fk_traduccion_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario);


--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `modeloai`
--
ALTER TABLE `modeloai`
  MODIFY `id_modelo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT de la tabla `traduccion`
--
ALTER TABLE `traduccion`
  MODIFY `id_traduccion` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT de la tabla `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

