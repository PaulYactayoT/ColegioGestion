-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: escuelagestion
-- ------------------------------------------------------
-- Server version	9.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Eliminar tablas existentes (en orden inverso por dependencias)
--

DROP TABLE IF EXISTS `configuracion_limite_edicion_asistencia`;
DROP TABLE IF EXISTS `disponibilidad_profesor`;
DROP TABLE IF EXISTS `curso_profesor`;
DROP TABLE IF EXISTS `justificacion`;
DROP TABLE IF EXISTS `nota`;
DROP TABLE IF EXISTS `observacion`;
DROP TABLE IF EXISTS `asistencia`;
DROP TABLE IF EXISTS `imagen`;
DROP TABLE IF EXISTS `tarea`;
DROP TABLE IF EXISTS `horario_clase`;
DROP TABLE IF EXISTS `curso_materia`;
DROP TABLE IF EXISTS `curso`;
DROP TABLE IF EXISTS `relacion_familiar`;
DROP TABLE IF EXISTS `alumno`;
DROP TABLE IF EXISTS `profesor`;
DROP TABLE IF EXISTS `administrativo`;
DROP TABLE IF EXISTS `usuario`;
DROP TABLE IF EXISTS `persona`;
DROP TABLE IF EXISTS `parametro_sistema`;
DROP TABLE IF EXISTS `materia`;
DROP TABLE IF EXISTS `aula`;
DROP TABLE IF EXISTS `sede`;
DROP TABLE IF EXISTS `turno`;
DROP TABLE IF EXISTS `grado`;

--
-- Table structure for table `persona`
--

CREATE TABLE `persona` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tipo` enum('ALUMNO','PROFESOR','ADMINISTRATIVO','PADRE','ADMIN') COLLATE utf8mb4_unicode_ci NOT NULL,
  `nombres` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `apellidos` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `correo` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `dni` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_nacimiento` date DEFAULT NULL,
  `direccion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `correo_UNIQUE` (`correo`),
  UNIQUE KEY `dni_UNIQUE` (`dni`),
  KEY `idx_persona_tipo` (`tipo`),
  KEY `idx_persona_activo` (`activo`),
  KEY `idx_persona_eliminado` (`eliminado`)
) ENGINE=InnoDB AUTO_INCREMENT=300 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `usuario`
--

CREATE TABLE `usuario` (
  `id` int NOT NULL AUTO_INCREMENT,
  `persona_id` int NOT NULL,
  `username` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'SHA-256 hash',
  `rol` enum('admin','docente','padre','administrativo') COLLATE utf8mb4_unicode_ci NOT NULL,
  `intentos_fallidos` int NOT NULL DEFAULT '0',
  `fecha_bloqueo` datetime DEFAULT NULL,
  `ultima_conexion` datetime DEFAULT NULL,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  UNIQUE KEY `persona_id_UNIQUE` (`persona_id`),
  KEY `idx_usuario_activo` (`activo`),
  KEY `idx_usuario_rol` (`rol`),
  KEY `fk_usuario_persona` (`persona_id`),
  CONSTRAINT `fk_usuario_persona` FOREIGN KEY (`persona_id`) REFERENCES `persona` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=300 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `grado`
--

CREATE TABLE `grado` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nivel` enum('INICIAL','PRIMARIA','SECUNDARIA') COLLATE utf8mb4_unicode_ci NOT NULL,
  `orden` int DEFAULT NULL COMMENT 'Orden para visualización',
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_grado_nivel` (`nivel`),
  KEY `idx_grado_activo` (`activo`),
  KEY `idx_grado_eliminado` (`eliminado`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `alumno`
--

CREATE TABLE `alumno` (
  `id` int NOT NULL AUTO_INCREMENT,
  `persona_id` int NOT NULL,
  `grado_id` int DEFAULT NULL,
  `codigo_alumno` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_ingreso` date DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO','EGRESADO','RETIRADO') COLLATE utf8mb4_unicode_ci DEFAULT 'ACTIVO',
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `persona_id_UNIQUE` (`persona_id`),
  UNIQUE KEY `codigo_alumno_UNIQUE` (`codigo_alumno`),
  KEY `fk_alumno_grado` (`grado_id`),
  KEY `idx_alumno_estado` (`estado`),
  KEY `idx_alumno_activo` (`activo`),
  KEY `idx_alumno_eliminado` (`eliminado`),
  CONSTRAINT `fk_alumno_grado` FOREIGN KEY (`grado_id`) REFERENCES `grado` (`id`),
  CONSTRAINT `fk_alumno_persona` FOREIGN KEY (`persona_id`) REFERENCES `persona` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=370 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `profesor`
--

CREATE TABLE `profesor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `persona_id` int NOT NULL,
  `especialidad` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `codigo_profesor` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_contratacion` date DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO','LICENCIA','JUBILADO') COLLATE utf8mb4_unicode_ci DEFAULT 'ACTIVO',
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `persona_id_UNIQUE` (`persona_id`),
  UNIQUE KEY `codigo_profesor_UNIQUE` (`codigo_profesor`),
  KEY `idx_profesor_activo` (`activo`),
  KEY `idx_profesor_eliminado` (`eliminado`),
  CONSTRAINT `fk_profesor_persona` FOREIGN KEY (`persona_id`) REFERENCES `persona` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `administrativo`
--

CREATE TABLE `administrativo` (
  `id` int NOT NULL AUTO_INCREMENT,
  `persona_id` int NOT NULL,
  `cargo` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `codigo_administrativo` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_ingreso` date DEFAULT NULL,
  `departamento` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `estado` enum('ACTIVO','INACTIVO','LICENCIA','JUBILADO') COLLATE utf8mb4_unicode_ci DEFAULT 'ACTIVO',
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `persona_id_UNIQUE` (`persona_id`),
  UNIQUE KEY `codigo_administrativo_UNIQUE` (`codigo_administrativo`),
  KEY `idx_administrativo_activo` (`activo`),
  KEY `idx_administrativo_eliminado` (`eliminado`),
  CONSTRAINT `fk_administrativo_persona` FOREIGN KEY (`persona_id`) REFERENCES `persona` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `relacion_familiar`
--

CREATE TABLE `relacion_familiar` (
  `id` int NOT NULL AUTO_INCREMENT,
  `alumno_id` int NOT NULL,
  `persona_id` int NOT NULL COMMENT 'Padre/madre/tutor',
  `parentesco` enum('PADRE','MADRE','TUTOR','HERMANO','OTRO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `es_contacto_principal` tinyint(1) DEFAULT '0',
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_relacion_alumno` (`alumno_id`),
  KEY `fk_relacion_persona` (`persona_id`),
  KEY `idx_relacion_activo` (`activo`),
  KEY `idx_relacion_eliminado` (`eliminado`),
  CONSTRAINT `fk_relacion_alumno` FOREIGN KEY (`alumno_id`) REFERENCES `alumno` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_relacion_persona` FOREIGN KEY (`persona_id`) REFERENCES `persona` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=100 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `materia`
--

CREATE TABLE `materia` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `area` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre_UNIQUE` (`nombre`),
  KEY `idx_materia_activo` (`activo`),
  KEY `idx_materia_eliminado` (`eliminado`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `curso`
--

CREATE TABLE `curso` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `grado_id` int DEFAULT NULL,
  `profesor_id` int DEFAULT NULL COMMENT 'Profesor principal',
  `creditos` int NOT NULL DEFAULT 0,
  `horas_semanales` int DEFAULT NULL,
  `area` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Área curricular',
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `ciclo` enum('I','II','III','IV','V','VI','VII','VIII','IX','X') COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_curso_grado` (`grado_id`),
  KEY `fk_curso_profesor` (`profesor_id`),
  KEY `idx_curso_activo` (`activo`),
  KEY `idx_curso_eliminado` (`eliminado`),
  CONSTRAINT `fk_curso_grado` FOREIGN KEY (`grado_id`) REFERENCES `grado` (`id`),
  CONSTRAINT `fk_curso_profesor` FOREIGN KEY (`profesor_id`) REFERENCES `profesor` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=148 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `curso_profesor`
--

CREATE TABLE `curso_profesor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `curso_id` int NOT NULL,
  `profesor_id` int NOT NULL,
  `fecha_asignacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_curso_profesor` (`curso_id`,`profesor_id`),
  KEY `fk_curso_profesor_curso` (`curso_id`),
  KEY `fk_curso_profesor_profesor` (`profesor_id`),
  KEY `idx_curso_profesor_activo` (`activo`),
  KEY `idx_curso_profesor_eliminado` (`eliminado`),
  CONSTRAINT `fk_curso_profesor_curso` FOREIGN KEY (`curso_id`) REFERENCES `curso` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_curso_profesor_profesor` FOREIGN KEY (`profesor_id`) REFERENCES `profesor` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `curso_materia`
--

CREATE TABLE `curso_materia` (
  `curso_id` int NOT NULL,
  `materia_id` int NOT NULL,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`curso_id`,`materia_id`),
  KEY `fk_curso_materia_materia` (`materia_id`),
  KEY `idx_curso_materia_activo` (`activo`),
  KEY `idx_curso_materia_eliminado` (`eliminado`),
  CONSTRAINT `fk_curso_materia_curso` FOREIGN KEY (`curso_id`) REFERENCES `curso` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_curso_materia_materia` FOREIGN KEY (`materia_id`) REFERENCES `materia` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `turno`
--

CREATE TABLE `turno` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `descripcion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_turno_activo` (`activo`),
  KEY `idx_turno_eliminado` (`eliminado`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `sede`
--

CREATE TABLE `sede` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `direccion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `director` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_sede_activo` (`activo`),
  KEY `idx_sede_eliminado` (`eliminado`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `aula`
--

CREATE TABLE `aula` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `capacidad` int DEFAULT NULL,
  `sede_id` int NOT NULL,
  `piso` int DEFAULT NULL,
  `tipo` enum('REGULAR','LABORATORIO','AUDITORIO','BIBLIOTECA','OTRO') COLLATE utf8mb4_unicode_ci DEFAULT 'REGULAR',
  `equipamiento` text COLLATE utf8mb4_unicode_ci,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_aula_sede` (`sede_id`),
  KEY `idx_aula_activo` (`activo`),
  KEY `idx_aula_eliminado` (`eliminado`),
  CONSTRAINT `fk_aula_sede` FOREIGN KEY (`sede_id`) REFERENCES `sede` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `horario_clase`
--

CREATE TABLE `horario_clase` (
  `id` int NOT NULL AUTO_INCREMENT,
  `curso_id` int NOT NULL,
  `turno_id` int NOT NULL,
  `dia_semana` enum('LUNES','MARTES','MIERCOLES','JUEVES','VIERNES','SABADO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `aula_id` int NOT NULL,
  `profesor_id` int NOT NULL,
  `fecha_inicio` date DEFAULT NULL,
  `fecha_fin` date DEFAULT NULL,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_horario_curso` (`curso_id`),
  KEY `fk_horario_turno` (`turno_id`),
  KEY `fk_horario_aula` (`aula_id`),
  KEY `fk_horario_profesor` (`profesor_id`),
  KEY `idx_horario_activo` (`activo`),
  KEY `idx_horario_eliminado` (`eliminado`),
  CONSTRAINT `fk_horario_aula` FOREIGN KEY (`aula_id`) REFERENCES `aula` (`id`),
  CONSTRAINT `fk_horario_curso` FOREIGN KEY (`curso_id`) REFERENCES `curso` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_horario_profesor` FOREIGN KEY (`profesor_id`) REFERENCES `profesor` (`id`),
  CONSTRAINT `fk_horario_turno` FOREIGN KEY (`turno_id`) REFERENCES `turno` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `disponibilidad_profesor`
--

CREATE TABLE `disponibilidad_profesor` (
  `id` int NOT NULL AUTO_INCREMENT,
  `profesor_id` int NOT NULL,
  `turno_id` int NOT NULL,
  `dia_semana` enum('LUNES','MARTES','MIERCOLES','JUEVES','VIERNES','SABADO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fin` time NOT NULL,
  `disponible` tinyint(1) NOT NULL DEFAULT '1',
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_disponibilidad_profesor` (`profesor_id`,`turno_id`,`dia_semana`,`hora_inicio`),
  KEY `fk_disponibilidad_profesor` (`profesor_id`),
  KEY `fk_disponibilidad_turno` (`turno_id`),
  KEY `idx_disponibilidad_activo` (`activo`),
  KEY `idx_disponibilidad_eliminado` (`eliminado`),
  CONSTRAINT `fk_disponibilidad_profesor` FOREIGN KEY (`profesor_id`) REFERENCES `profesor` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_disponibilidad_turno` FOREIGN KEY (`turno_id`) REFERENCES `turno` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `tarea`
--

CREATE TABLE `tarea` (
  `id` int NOT NULL AUTO_INCREMENT,
  `curso_id` int NOT NULL,
  `nombre` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `fecha_entrega` date DEFAULT NULL,
  `tipo` enum('TAREA','EXAMEN','PROYECTO','TRABAJO') COLLATE utf8mb4_unicode_ci DEFAULT 'TAREA',
  `peso` decimal(5,2) DEFAULT '1.00' COMMENT 'Peso en la nota final',
  `instrucciones` text COLLATE utf8mb4_unicode_ci,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_tarea_curso` (`curso_id`),
  KEY `idx_tarea_activo` (`activo`),
  KEY `idx_tarea_eliminado` (`eliminado`),
  CONSTRAINT `fk_tarea_curso` FOREIGN KEY (`curso_id`) REFERENCES `curso` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `asistencia`
--

CREATE TABLE `asistencia` (
  `id` int NOT NULL AUTO_INCREMENT,
  `alumno_id` int NOT NULL,
  `curso_id` int NOT NULL,
  `turno_id` int NOT NULL,
  `fecha` date NOT NULL,
  `hora_clase` time NOT NULL,
  `estado` enum('PRESENTE','TARDANZA','AUSENTE','JUSTIFICADO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `registrado_por` int DEFAULT NULL COMMENT 'ID del profesor que registró',
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `fecha_actualizacion` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_asistencia_diaria` (`alumno_id`,`curso_id`,`turno_id`,`fecha`,`hora_clase`),
  KEY `fk_asistencia_alumno` (`alumno_id`),
  KEY `fk_asistencia_curso` (`curso_id`),
  KEY `fk_asistencia_turno` (`turno_id`),
  KEY `idx_fecha` (`fecha`),
  KEY `idx_estado` (`estado`),
  KEY `idx_activo` (`activo`),
  KEY `idx_eliminado` (`eliminado`),
  CONSTRAINT `fk_asistencia_alumno` FOREIGN KEY (`alumno_id`) REFERENCES `alumno` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_asistencia_curso` FOREIGN KEY (`curso_id`) REFERENCES `curso` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_asistencia_turno` FOREIGN KEY (`turno_id`) REFERENCES `turno` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=300 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `justificacion`
--

CREATE TABLE `justificacion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `asistencia_id` int NOT NULL,
  `tipo_justificacion` enum('ENFERMEDAD','EMERGENCIA_FAMILIAR','CITA_MEDICA','OTRO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `documento_adjunto` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `justificado_por` int DEFAULT NULL COMMENT 'ID del padre que justifica',
  `fecha_justificacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `estado` enum('PENDIENTE','APROBADO','RECHAZADO') COLLATE utf8mb4_unicode_ci DEFAULT 'PENDIENTE',
  `aprobado_por` int DEFAULT NULL COMMENT 'ID del admin/profesor que aprueba',
  `fecha_aprobacion` datetime DEFAULT NULL,
  `observaciones_aprobacion` text COLLATE utf8mb4_unicode_ci,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_justificacion_asistencia` (`asistencia_id`),
  KEY `idx_estado` (`estado`),
  KEY `idx_activo` (`activo`),
  KEY `idx_eliminado` (`eliminado`),
  CONSTRAINT `fk_justificacion_asistencia` FOREIGN KEY (`asistencia_id`) REFERENCES `asistencia` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `nota`
--

CREATE TABLE `nota` (
  `id` int NOT NULL AUTO_INCREMENT,
  `alumno_id` int NOT NULL,
  `tarea_id` int NOT NULL,
  `nota` decimal(5,2) DEFAULT NULL,
  `observaciones` text COLLATE utf8mb4_unicode_ci,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `registrado_por` int DEFAULT NULL,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_alumno_tarea` (`alumno_id`,`tarea_id`),
  KEY `fk_nota_alumno` (`alumno_id`),
  KEY `fk_nota_tarea` (`tarea_id`),
  KEY `idx_nota_activo` (`activo`),
  KEY `idx_nota_eliminado` (`eliminado`),
  CONSTRAINT `fk_nota_alumno` FOREIGN KEY (`alumno_id`) REFERENCES `alumno` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_nota_tarea` FOREIGN KEY (`tarea_id`) REFERENCES `tarea` (`id`) ON DELETE CASCADE,
  CONSTRAINT `nota_chk_1` CHECK ((`nota` between 0 and 20))
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `observacion`
--

CREATE TABLE `observacion` (
  `id` int NOT NULL AUTO_INCREMENT,
  `alumno_id` int NOT NULL,
  `curso_id` int NOT NULL,
  `tipo` enum('POSITIVA','NEUTRAL','NEGATIVA') COLLATE utf8mb4_unicode_ci DEFAULT 'NEUTRAL',
  `texto` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `registrado_por` int DEFAULT NULL,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `fk_observacion_alumno` (`alumno_id`),
  KEY `fk_observacion_curso` (`curso_id`),
  KEY `idx_observacion_activo` (`activo`),
  KEY `idx_observacion_eliminado` (`eliminado`),
  CONSTRAINT `fk_observacion_alumno` FOREIGN KEY (`alumno_id`) REFERENCES `alumno` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_observacion_curso` FOREIGN KEY (`curso_id`) REFERENCES `curso` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `imagen`
--

CREATE TABLE `imagen` (
  `id` int NOT NULL AUTO_INCREMENT,
  `alumno_id` int NOT NULL,
  `ruta` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tipo` enum('FOTO_PERFIL','DOCUMENTO','OTRO') COLLATE utf8mb4_unicode_ci DEFAULT 'FOTO_PERFIL',
  `descripcion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_subida` datetime DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `alumno_id` (`alumno_id`),
  KEY `idx_imagen_activo` (`activo`),
  KEY `idx_imagen_eliminado` (`eliminado`),
  CONSTRAINT `imagen_ibfk_1` FOREIGN KEY (`alumno_id`) REFERENCES `alumno` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `parametro_sistema`
--

CREATE TABLE `parametro_sistema` (
  `id` int NOT NULL AUTO_INCREMENT,
  `categoria` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `clave` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `valor` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `descripcion` text COLLATE utf8mb4_unicode_ci,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_clave_categoria` (`categoria`,`clave`),
  KEY `idx_parametro_activo` (`activo`),
  KEY `idx_parametro_eliminado` (`eliminado`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Table structure for table `configuracion_limite_edicion_asistencia`
--

CREATE TABLE `configuracion_limite_edicion_asistencia` (
  `id` int NOT NULL AUTO_INCREMENT,
  `curso_id` int NOT NULL,
  `turno_id` int NOT NULL,
  `dia_semana` enum('LUNES','MARTES','MIERCOLES','JUEVES','VIERNES','SABADO') COLLATE utf8mb4_unicode_ci NOT NULL,
  `hora_inicio_clase` time NOT NULL,
  `limite_edicion_minutos` int NOT NULL DEFAULT 120 COMMENT 'Minutos después del inicio de la clase para editar',
  `aplica_todos_cursos` tinyint(1) DEFAULT '0' COMMENT 'Si aplica a todos los cursos',
  `descripcion` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fecha_registro` datetime DEFAULT CURRENT_TIMESTAMP,
  `activo` tinyint(1) NOT NULL DEFAULT '1',
  `eliminado` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_config_curso_turno_dia_hora` (`curso_id`,`turno_id`,`dia_semana`,`hora_inicio_clase`),
  KEY `fk_config_limite_curso` (`curso_id`),
  KEY `fk_config_limite_turno` (`turno_id`),
  KEY `idx_config_limite_activo` (`activo`),
  KEY `idx_config_limite_eliminado` (`eliminado`),
  CONSTRAINT `fk_config_limite_curso` FOREIGN KEY (`curso_id`) REFERENCES `curso` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_config_limite_turno` FOREIGN KEY (`turno_id`) REFERENCES `turno` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ------------------------------------------------------
-- DATOS DE EJEMPLO
-- ------------------------------------------------------

--
-- Insertar grados
--

INSERT INTO `grado` (`id`, `nombre`, `nivel`, `orden`, `activo`) VALUES
(12,'3','INICIAL',1,1),
(13,'4','INICIAL',2,1),
(14,'5','INICIAL',3,1),
(15,'1ero','PRIMARIA',4,1),
(16,'2do','PRIMARIA',5,1),
(17,'3ero','PRIMARIA',6,1),
(18,'4to','PRIMARIA',7,1),
(19,'5to','PRIMARIA',8,1),
(20,'6to','PRIMARIA',9,1),
(21,'1ero','SECUNDARIA',10,1),
(22,'2do','SECUNDARIA',11,1),
(23,'3ero','SECUNDARIA',12,1),
(24,'4to','SECUNDARIA',13,1),
(25,'5to','SECUNDARIA',14,1);

--
-- Insertar turnos
--

INSERT INTO `turno` (`id`, `nombre`, `hora_inicio`, `hora_fin`, `activo`) VALUES
(1,'MAÑANA','08:00:00','13:00:00',1),
(2,'TARDE','13:00:00','18:00:00',1);

--
-- Insertar sedes
--

INSERT INTO `sede` (`id`, `nombre`, `direccion`, `telefono`, `activo`) VALUES
(1,'Sede Principal','Av. Principal 123, Lima','+51 1 2345678',1),
(2,'Sede Norte','Av. Norte 456, Los Olivos','+51 1 2345679',1),
(3,'Sede Sur','Av. Sur 789, Villa El Salvador','+51 1 2345680',1);

--
-- Insertar aulas
--

INSERT INTO `aula` (`id`, `nombre`, `capacidad`, `sede_id`, `activo`) VALUES
(1,'A-101',30,1,1),
(2,'A-102',30,1,1),
(3,'A-201',30,1,1),
(4,'A-202',30,1,1),
(5,'B-101',25,1,1),
(6,'B-102',25,1,1),
(7,'Laboratorio Cómputo',20,1,1),
(8,'N-101',30,2,1),
(9,'N-102',30,2,1),
(10,'N-201',30,2,1),
(11,'S-101',30,3,1),
(12,'S-102',30,3,1),
(13,'S-103',30,3,1);

--
-- Insertar materias
--

INSERT INTO `materia` (`id`, `nombre`, `descripcion`, `area`, `activo`) VALUES
(1,'Matemáticas','Matemáticas básicas y avanzadas','Ciencia',1),
(2,'Comunicación','Lenguaje y comunicación','Humanidades',1),
(3,'Historia','Historia universal y del Perú','Humanidades',1),
(4,'Ciencias Naturales','Biología, química, física','Ciencia',1),
(5,'Educación Física','Actividad física y deportes','Educación',1),
(6,'Arte','Arte y cultura','Educación',1),
(7,'Inglés','Idioma extranjero','Idiomas',1),
(8,'Computación','Informática y tecnología','Tecnología',1),
(9,'Religión','Educación religiosa','Valores',1),
(10,'Geografía','Geografía física y política','Humanidades',1),
(11,'Formación Ciudadana','Educación cívica y ciudadana','Valores',1),
(12,'Psicomotricidad','Desarrollo psicomotriz','Inicial',1),
(13,'Lenguaje Oral','Desarrollo del lenguaje oral','Inicial',1),
(14,'Numeros Basicos','Introducción a los números','Inicial',1),
(15,'Cuentos y Relatos','Lectura de cuentos','Inicial',1),
(16,'Expresion Artistica','Arte para inicial','Inicial',1);

--
-- Insertar parámetros del sistema
--

INSERT INTO `parametro_sistema` (`categoria`, `clave`, `valor`, `descripcion`, `activo`) VALUES
('ASISTENCIA','HORA_INICIO_TARDANZA','08:15','Hora límite para considerar tardanza en turno mañana',1),
('ASISTENCIA','HORA_INICIO_TARDANZA_TARDE','13:15','Hora límite para considerar tardanza en turno tarde',1),
('ASISTENCIA','MAXIMO_TARDANZAS','3','Número máximo de tardanzas permitidas por mes',1),
('ASISTENCIA','PORCENTAJE_ASISTENCIA_MINIMO','75','Porcentaje mínimo de asistencia requerido según normas peruanas',1),
('ASISTENCIA','DIAS_JUSTIFICACION','3','Días máximos para justificar una ausencia',1),
('ASISTENCIA','HORAS_CLASE_DIARIAS','6','Horas de clase por día en el colegio',1),
('ASISTENCIA','TOLERANCIA_TARDANZA','15','Minutos de tolerancia para tardanzas',1),
('ASISTENCIA','LIMITE_EDICION_DEFAULT','120','Minutos por defecto para editar asistencia después del inicio de clase',1),
('NOTAS','ESCALA_MAXIMA','20','Escala máxima de calificación',1),
('NOTAS','PROMEDIO_APROBATORIO','11','Promedio mínimo aprobatorio',1),
('CURSOS','CREDITOS_MINIMOS','1','Créditos mínimos por curso',1),
('CURSOS','CREDITOS_MAXIMOS','5','Créditos máximos por curso',1),
('HORARIOS','HORAS_MINIMAS_SEMANALES','2','Horas mínimas semanales por curso',1),
('HORARIOS','HORAS_MAXIMAS_SEMANALES','6','Horas máximas semanales por curso',1);

--
-- Insertar configuración límite edición asistencia (ejemplos)
--

INSERT INTO `configuracion_limite_edicion_asistencia` (`curso_id`, `turno_id`, `dia_semana`, `hora_inicio_clase`, `limite_edicion_minutos`) VALUES
(136, 1, 'LUNES', '08:00:00', 120),
(136, 1, 'MIERCOLES', '08:00:00', 120),
(136, 1, 'VIERNES', '08:00:00', 120),
(140, 1, 'LUNES', '10:00:00', 90),
(140, 1, 'JUEVES', '10:00:00', 90),
(22, 2, 'LUNES', '13:00:00', 180),
(22, 2, 'MARTES', '13:00:00', 180),
(22, 2, 'MIERCOLES', '13:00:00', 180),
(22, 2, 'JUEVES', '13:00:00', 180),
(22, 2, 'VIERNES', '13:00:00', 180);

--
-- Insertar personas (alumnos, profesores, padres, administradores)
--

-- Alumnos (70 alumnos - 5 por cada grado)
INSERT INTO `persona` (`id`, `tipo`, `nombres`, `apellidos`, `correo`, `fecha_nacimiento`, `dni`) VALUES
-- Grado 12 (INICIAL 3) - 5 alumnos
(51,'ALUMNO','Carlos','Gutiérrez','carlos.gutierrez@email.com','2020-03-15','12345678'),
(52,'ALUMNO','Ana','Mendoza','ana.mendoza@email.com','2020-05-22','12345679'),
(53,'ALUMNO','Luis','Paredes','luis.paredes@email.com','2020-07-10','12345680'),
(54,'ALUMNO','María','Salazar','maria.salazar@email.com','2020-09-05','12345681'),
(55,'ALUMNO','Jorge','Cruz','jorge.cruz@email.com','2020-11-18','12345682'),

-- Grado 13 (INICIAL 4) - 5 alumnos
(56,'ALUMNO','Sofía','Reyes','sofia.reyes@email.com','2019-02-14','12345683'),
(57,'ALUMNO','Diego','Acosta','diego.acosta@email.com','2019-04-20','12345684'),
(58,'ALUMNO','Lucía','Peña','lucia.pena@email.com','2019-06-12','12345685'),
(59,'ALUMNO','Miguel','Luna','miguel.luna@email.com','2019-08-30','12345686'),
(60,'ALUMNO','Elena','Fuentes','elena.fuentes@email.com','2019-10-05','12345687'),

-- Grado 14 (INICIAL 5) - 5 alumnos
(61,'ALUMNO','Andrés','Herrera','andres.herrera@email.com','2018-02-10','12345688'),
(62,'ALUMNO','Carmen','Ríos','carmen.rios@email.com','2018-06-18','12345689'),
(63,'ALUMNO','Roberto','Benitez','roberto.benitez@email.com','2018-01-25','12345690'),
(64,'ALUMNO','Patricia','Molina','patricia.molina@email.com','2018-09-03','12345691'),
(65,'ALUMNO','Fernando','Suarez','fernando.suarez@email.com','2018-03-14','12345692'),

-- Grado 15 (1ero PRIMARIA) - 5 alumnos
(66,'ALUMNO','Gabriela','Cordova','gabriela.cordova@email.com','2017-11-22','12345693'),
(67,'ALUMNO','Raúl','Vega','raul.vega@email.com','2017-05-09','12345694'),
(68,'ALUMNO','Silvia','Rojas','silvia.rojas@email.com','2017-08-17','12345695'),
(69,'ALUMNO','Alberto','Castillo','alberto.castillo@email.com','2017-02-28','12345696'),
(70,'ALUMNO','Rosa','Navarro','rosa.navarro@email.com','2017-10-06','12345697'),

-- Grado 16 (2do PRIMARIA) - 5 alumnos
(71,'ALUMNO','Ricardo','Miranda','ricardo.miranda@email.com','2016-04-12','12345698'),
(72,'ALUMNO','Verónica','Cortez','veronica.cortez@email.com','2016-12-19','12345699'),
(73,'ALUMNO','Oscar','Santos','oscar.santos@email.com','2016-06-01','12345700'),
(74,'ALUMNO','Teresa','Cáceres','teresa.caceres@email.com','2016-09-27','12345701'),
(75,'ALUMNO','Héctor','Pacheco','hector.pacheco@email.com','2016-01-08','12345702'),

-- Grado 17 (3ero PRIMARIA) - 5 alumnos
(76,'ALUMNO','Natalia','Lozano','natalia.lozano@email.com','2015-07-15','12345703'),
(77,'ALUMNO','Guillermo','Méndez','guillermo.mendez@email.com','2015-03-30','12345704'),
(78,'ALUMNO','Claudia','Carrasco','claudia.carrasco@email.com','2015-11-05','12345705'),
(79,'ALUMNO','Francisco','Guerrero','francisco.guerrero@email.com','2015-08-21','12345706'),
(80,'ALUMNO','Mónica','Rivas','monica.rivas@email.com','2015-04-09','12345707'),

-- Grado 18 (4to PRIMARIA) - 5 alumnos
(81,'ALUMNO','Sergio','Vera','sergio.vera@email.com','2014-02-15','12345708'),
(82,'ALUMNO','Alicia','Soto','alicia.soto@email.com','2014-05-22','12345709'),
(83,'ALUMNO','Javier','Cárdenas','javier.cardenas@email.com','2014-07-10','12345710'),
(84,'ALUMNO','Beatriz','Sepúlveda','beatriz.sepulveda@email.com','2014-09-05','12345711'),
(85,'ALUMNO','Martín','Contreras','martin.contreras@email.com','2014-11-18','12345712'),

-- Grado 19 (5to PRIMARIA) - 5 alumnos
(86,'ALUMNO','Cecilia','Valenzuela','cecilia.valenzuela@email.com','2013-02-14','12345713'),
(87,'ALUMNO','Gustavo','Araya','gustavo.araya@email.com','2013-04-20','12345714'),
(88,'ALUMNO','Daniela','Tapia','daniela.tapia@email.com','2013-06-12','12345715'),
(89,'ALUMNO','Pablo','Parra','pablo.parra@email.com','2013-08-30','12345716'),
(90,'ALUMNO','Valeria','Espinoza','valeria.espinoza@email.com','2013-10-05','12345717'),

-- Grado 20 (6to PRIMARIA) - 5 alumnos
(91,'ALUMNO','Felipe','Gallegos','felipe.gallegos@email.com','2012-02-10','12345718'),
(92,'ALUMNO','Carolina','Henríquez','carolina.henriquez@email.com','2012-06-18','12345719'),
(93,'ALUMNO','José','Bustos','jose.bustos@email.com','2012-01-25','12345720'),
(94,'ALUMNO','Adriana','Maldonado','adriana.maldonado@email.com','2012-09-03','12345721'),
(95,'ALUMNO','Rodrigo','Carvajal','rodrigo.carvajal@email.com','2012-03-14','12345722'),

-- Grado 21 (1ero SECUNDARIA) - 5 alumnos
(96,'ALUMNO','Marcela','Zúñiga','marcela.zuniga@email.com','2011-11-22','12345723'),
(97,'ALUMNO','Alejandro','Jara','alejandro.jara@email.com','2011-05-09','12345724'),
(98,'ALUMNO','Paola','Mora','paola.mora@email.com','2011-08-17','12345725'),
(99,'ALUMNO','Cristian','Vidal','cristian.vidal@email.com','2011-02-28','12345726'),
(100,'ALUMNO','Lorena','Cisternas','lorena.cisternas@email.com','2011-10-06','12345727'),

-- Grado 22 (2do SECUNDARIA) - 5 alumnos
(101,'ALUMNO','Ignacio','Olivares','ignacio.olivares@email.com','2010-04-12','12345728'),
(102,'ALUMNO','Constanza','Godoy','constanza.godoy@email.com','2010-12-19','12345729'),
(103,'ALUMNO','Víctor','Saavedra','victor.saavedra@email.com','2010-06-01','12345730'),
(104,'ALUMNO','Francisca','Pinto','francisca.pinto@email.com','2010-09-27','12345731'),
(105,'ALUMNO','Tomás','Venegas','tomas.venegas@email.com','2010-01-08','12345732'),

-- Grado 23 (3ero SECUNDARIA) - 5 alumnos
(106,'ALUMNO','Antonia','Cáceres','antonia.caceres@email.com','2009-07-15','12345733'),
(107,'ALUMNO','Renato','Aguilera','renato.aguilera@email.com','2009-03-30','12345734'),
(108,'ALUMNO','Javiera','Poblete','javiera.poblete@email.com','2009-11-05','12345735'),
(109,'ALUMNO','Fabián','Barrientos','fabian.barrientos@email.com','2009-08-21','12345736'),
(110,'ALUMNO','Daniela','Guzmán','daniela.guzman@email.com','2009-04-09','12345737'),

-- Grado 24 (4to SECUNDARIA) - 5 alumnos
(111,'ALUMNO','Matías','Escobar','matias.escobar@email.com','2008-02-15','12345738'),
(112,'ALUMNO','Camila','Álvarez','camila.alvarez@email.com','2008-05-22','12345739'),
(113,'ALUMNO','Sebastián','Ruiz','sebastian.ruiz@email.com','2008-07-10','12345740'),
(114,'ALUMNO','Florencia','Torres','florencia.torres@email.com','2008-09-05','12345741'),
(115,'ALUMNO','Bastián','Silva','bastian.silva@email.com','2008-11-18','12345742'),

-- Grado 25 (5to SECUNDARIA) - 5 alumnos
(116,'ALUMNO','Isidora','Vergara','isidora.vergara@email.com','2007-02-14','12345743'),
(117,'ALUMNO','Maximiliano','Castro','maximiliano.castro@email.com','2007-04-20','12345744'),
(118,'ALUMNO','Trinidad','Morales','trinidad.morales@email.com','2007-06-12','12345745'),
(119,'ALUMNO','Benjamín','Fernández','benjamin.fernandez@email.com','2007-08-30','12345746'),
(120,'ALUMNO','Emilia','Ramos','emilia.ramos@email.com','2007-10-05','12345747'),

-- Alumnos existentes del script original (manteniéndolos)
(20,'ALUMNO','Milagros','Candela','milagroscandela@gmail.com','2000-03-01','12345601'),
(21,'ALUMNO','Alejandro','Gomez','alejandrogomez@gmail.com','2023-01-15','12345602'),
(22,'ALUMNO','Sofia','Rodriguez','sofiarodriguez@gmail.com','2023-03-22','12345603'),
(23,'ALUMNO','Mateo','Hernandez','mateohernandez@gmail.com','2023-05-10','12345604'),
(24,'ALUMNO','Valentina','Martinez','valentinamartinez@gmail.com','2023-07-05','12345605'),
(25,'ALUMNO','Santiago','Perez','santiagoperez@gmail.com','2023-09-18','12345606'),
(26,'ALUMNO','Lucia','Lopez','lucialopez@gmail.com','2022-02-14','12345607'),
(27,'ALUMNO','Sebastian','Gonzalez','sebastiangonzalez@gmail.com','2022-04-20','12345608'),
(28,'ALUMNO','Camila','Sanchez','camilasanchez@gmail.com','2022-06-12','12345609'),
(29,'ALUMNO','Nicolas','Ramirez','nicolasramirez@gmail.com','2022-08-30','12345610'),
(30,'ALUMNO','Maria','Argomedo','mariaargomedo@gmail.com','2022-10-05','12345611'),
(31,'ALUMNO','Juan','Flores','juanflores@gmail.com','2014-02-10','12345612'),
(32,'ALUMNO','Maria','Rojas','mariarojas@gmail.com','2014-06-18','12345613'),
(33,'ALUMNO','Luis','Vargas','luisvargas@gmail.com','2015-01-25','12345614'),
(34,'ALUMNO','Daniela','Castro','danielacastro@gmail.com','2015-09-03','12345615'),
(35,'ALUMNO','Pedro','Silva','pedrosilva@gmail.com','2016-03-14','12345616'),
(36,'ALUMNO','Renata','Mendoza','renatamendoza@gmail.com','2016-11-22','12345617'),
(37,'ALUMNO','Diego','Navarro','diegonavarro@gmail.com','2017-05-09','12345618'),
(38,'ALUMNO','Paula','Ortega','paulaortega@gmail.com','2017-08-17','12345619'),
(39,'ALUMNO','Javier','Campos','javiercampos@gmail.com','2018-02-28','12345620'),
(40,'ALUMNO','Fernanda','Paredes','fernandaparedes@gmail.com','2018-10-06','12345621'),
(41,'ALUMNO','Bruno','Salazar','brunosalazar@gmail.com','2019-04-12','12345622'),
(42,'ALUMNO','Antonia','Cruz','antoniacruz@gmail.com','2019-12-19','12345623'),
(43,'ALUMNO','Emilio','Reyes','emilioreyes@gmail.com','2020-06-01','12345624'),
(44,'ALUMNO','Isabella','Acosta','isabellaacosta@gmail.com','2020-09-27','12345625'),
(45,'ALUMNO','Thiago','Peña','thiagopeña@gmail.com','2021-01-08','12345626'),
(46,'ALUMNO','Catalina','Luna','catalinaluna@gmail.com','2021-07-15','12345627'),
(47,'ALUMNO','Leonardo','Fuentes','leonardofuentes@gmail.com','2022-03-30','12345628'),
(48,'ALUMNO','Abril','Herrera','abrilherrera@gmail.com','2022-11-05','12345629'),
(49,'ALUMNO','Maximo','Rios','maximorios@gmail.com','2023-08-21','12345630'),
(50,'ALUMNO','Valeria','Benitez','valeriabenitez@gmail.com','2024-04-09','12345631');

-- Profesores
INSERT INTO `persona` (`id`, `tipo`, `nombres`, `apellidos`, `correo`, `fecha_nacimiento`, `dni`) VALUES
(200,'PROFESOR','Nick','Flores','nickflores@gmail.com','1980-05-15','87654321'),
(201,'PROFESOR','Juan','Tapia','juantapia@gmail.com','1975-08-20','87654322'),
(202,'PROFESOR','Sofia','Quiroz','sofiaquiroz@gmail.com','1982-11-30','87654323'),
(203,'PROFESOR','Luis','Garcia','luisgarcia@gmail.com','1978-03-10','87654324'),
(204,'PROFESOR','Ana','Lopez','analopez@gmail.com','1985-07-22','87654325'),
(205,'PROFESOR','Pedro','Torres','pedrotorres@gmail.com','1979-12-05','87654326'),
(206,'PROFESOR','Laura','Diaz','lauradiaz@gmail.com','1983-04-18','87654327'),
(207,'PROFESOR','Carlos','Martinez','carlosmartinez@gmail.com','1981-09-25','87654328'),
(208,'PROFESOR','Andrea','Santos','andreasantos@gmail.com','1987-01-30','87654329'),
(209,'PROFESOR','Jorge','Perez','jorgeperez@gmail.com','1976-06-15','87654330'),
(210,'PROFESOR','Valeria','Ruiz','valeriaruiz@gmail.com','1984-08-20','87654331'),
(211,'PROFESOR','Fernando','Ramos','fernandoramos@gmail.com','1980-11-12','87654332'),
(212,'PROFESOR','Isabel','Castro','isabelcastro@gmail.com','1986-02-28','87654333');

-- Administradores
INSERT INTO `persona` (`id`, `tipo`, `nombres`, `apellidos`, `correo`, `fecha_nacimiento`, `dni`) VALUES
(1,'ADMIN','Paul','Martin','Paulmartin@gmail.com','1990-05-15','11111111'),
(300,'ADMIN','Admin','Principal','admin@escuela.edu.pe','1985-10-10','22222222'),
(301,'ADMINISTRATIVO','Carlos','Administrador','carlos.admin@escuela.edu.pe','1988-03-25','33333333');

-- Padres (algunos ejemplos)
INSERT INTO `persona` (`id`, `tipo`, `nombres`, `apellidos`, `correo`, `fecha_nacimiento`, `dni`) VALUES
(302,'PADRE','Padre','Gomez','padregomez@gmail.com','1990-01-01','44444444'),
(303,'PADRE','Padre','Rodriguez','padrerodriguez@gmail.com','1991-02-02','44444445'),
(304,'PADRE','Padre','Hernandez','padrehernandez@gmail.com','1992-03-03','44444446');

--
-- Insertar usuarios
-- Contraseña SHA-256 de "123456": 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
--

-- Usuarios para alumnos (padres)
INSERT INTO `usuario` (`persona_id`, `username`, `password`, `rol`) VALUES
(20,'milagroscandela','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','padre'),
(21,'alejandrogomez','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','padre'),
(22,'sofiarodriguez','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','padre'),
(23,'mateohernandez','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','padre'),
(24,'valentinamartinez','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','padre'),
(25,'santiagoperez','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','padre');

-- Usuarios para profesores
INSERT INTO `usuario` (`persona_id`, `username`, `password`, `rol`) VALUES
(200,'nickflores','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','docente'),
(201,'juantapia','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','docente'),
(202,'sofiaquiroz','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','docente'),
(203,'luisgarcia','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','docente'),
(204,'analopez','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','docente'),
(205,'pedrotorres','8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92','docente');

-- Usuario admin
INSERT INTO `usuario` (`id`, `persona_id`, `username`, `password`, `rol`) VALUES
(1, 1, 'admin', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'admin'),
(2, 300, 'admin_principal', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'admin'),
(3, 301, 'carlos_admin', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'administrativo');

--
-- Insertar administrativos
--

INSERT INTO `administrativo` (`persona_id`, `cargo`, `codigo_administrativo`, `fecha_ingreso`, `departamento`, `estado`) VALUES
(301, 'Director Académico', 'ADM-001', '2020-01-15', 'Dirección', 'ACTIVO');

--
-- Insertar alumnos (relacionados con personas)
-- 70 nuevos alumnos + los existentes
--

-- Grado 12 (INICIAL 3) - 5 alumnos
INSERT INTO `alumno` (`id`, `persona_id`, `grado_id`, `codigo_alumno`, `fecha_ingreso`, `estado`) VALUES
(51, 51, 12, 'ALU-2025-051', '2025-01-01', 'ACTIVO'),
(52, 52, 12, 'ALU-2025-052', '2025-01-01', 'ACTIVO'),
(53, 53, 12, 'ALU-2025-053', '2025-01-01', 'ACTIVO'),
(54, 54, 12, 'ALU-2025-054', '2025-01-01', 'ACTIVO'),
(55, 55, 12, 'ALU-2025-055', '2025-01-01', 'ACTIVO'),

-- Grado 13 (INICIAL 4) - 5 alumnos
(56, 56, 13, 'ALU-2025-056', '2025-01-01', 'ACTIVO'),
(57, 57, 13, 'ALU-2025-057', '2025-01-01', 'ACTIVO'),
(58, 58, 13, 'ALU-2025-058', '2025-01-01', 'ACTIVO'),
(59, 59, 13, 'ALU-2025-059', '2025-01-01', 'ACTIVO'),
(60, 60, 13, 'ALU-2025-060', '2025-01-01', 'ACTIVO'),

-- Grado 14 (INICIAL 5) - 5 alumnos
(61, 61, 14, 'ALU-2025-061', '2025-01-01', 'ACTIVO'),
(62, 62, 14, 'ALU-2025-062', '2025-01-01', 'ACTIVO'),
(63, 63, 14, 'ALU-2025-063', '2025-01-01', 'ACTIVO'),
(64, 64, 14, 'ALU-2025-064', '2025-01-01', 'ACTIVO'),
(65, 65, 14, 'ALU-2025-065', '2025-01-01', 'ACTIVO'),

-- Grado 15 (1ero PRIMARIA) - 5 alumnos
(66, 66, 15, 'ALU-2025-066', '2025-01-01', 'ACTIVO'),
(67, 67, 15, 'ALU-2025-067', '2025-01-01', 'ACTIVO'),
(68, 68, 15, 'ALU-2025-068', '2025-01-01', 'ACTIVO'),
(69, 69, 15, 'ALU-2025-069', '2025-01-01', 'ACTIVO'),
(70, 70, 15, 'ALU-2025-070', '2025-01-01', 'ACTIVO'),

-- Grado 16 (2do PRIMARIA) - 5 alumnos
(71, 71, 16, 'ALU-2025-071', '2025-01-01', 'ACTIVO'),
(72, 72, 16, 'ALU-2025-072', '2025-01-01', 'ACTIVO'),
(73, 73, 16, 'ALU-2025-073', '2025-01-01', 'ACTIVO'),
(74, 74, 16, 'ALU-2025-074', '2025-01-01', 'ACTIVO'),
(75, 75, 16, 'ALU-2025-075', '2025-01-01', 'ACTIVO'),

-- Grado 17 (3ero PRIMARIA) - 5 alumnos
(76, 76, 17, 'ALU-2025-076', '2025-01-01', 'ACTIVO'),
(77, 77, 17, 'ALU-2025-077', '2025-01-01', 'ACTIVO'),
(78, 78, 17, 'ALU-2025-078', '2025-01-01', 'ACTIVO'),
(79, 79, 17, 'ALU-2025-079', '2025-01-01', 'ACTIVO'),
(80, 80, 17, 'ALU-2025-080', '2025-01-01', 'ACTIVO'),

-- Grado 18 (4to PRIMARIA) - 5 alumnos
(81, 81, 18, 'ALU-2025-081', '2025-01-01', 'ACTIVO'),
(82, 82, 18, 'ALU-2025-082', '2025-01-01', 'ACTIVO'),
(83, 83, 18, 'ALU-2025-083', '2025-01-01', 'ACTIVO'),
(84, 84, 18, 'ALU-2025-084', '2025-01-01', 'ACTIVO'),
(85, 85, 18, 'ALU-2025-085', '2025-01-01', 'ACTIVO'),

-- Grado 19 (5to PRIMARIA) - 5 alumnos
(86, 86, 19, 'ALU-2025-086', '2025-01-01', 'ACTIVO'),
(87, 87, 19, 'ALU-2025-087', '2025-01-01', 'ACTIVO'),
(88, 88, 19, 'ALU-2025-088', '2025-01-01', 'ACTIVO'),
(89, 89, 19, 'ALU-2025-089', '2025-01-01', 'ACTIVO'),
(90, 90, 19, 'ALU-2025-090', '2025-01-01', 'ACTIVO'),

-- Grado 20 (6to PRIMARIA) - 5 alumnos
(91, 91, 20, 'ALU-2025-091', '2025-01-01', 'ACTIVO'),
(92, 92, 20, 'ALU-2025-092', '2025-01-01', 'ACTIVO'),
(93, 93, 20, 'ALU-2025-093', '2025-01-01', 'ACTIVO'),
(94, 94, 20, 'ALU-2025-094', '2025-01-01', 'ACTIVO'),
(95, 95, 20, 'ALU-2025-095', '2025-01-01', 'ACTIVO'),

-- Grado 21 (1ero SECUNDARIA) - 5 alumnos
(96, 96, 21, 'ALU-2025-096', '2025-01-01', 'ACTIVO'),
(97, 97, 21, 'ALU-2025-097', '2025-01-01', 'ACTIVO'),
(98, 98, 21, 'ALU-2025-098', '2025-01-01', 'ACTIVO'),
(99, 99, 21, 'ALU-2025-099', '2025-01-01', 'ACTIVO'),
(100, 100, 21, 'ALU-2025-100', '2025-01-01', 'ACTIVO'),

-- Grado 22 (2do SECUNDARIA) - 5 alumnos
(101, 101, 22, 'ALU-2025-101', '2025-01-01', 'ACTIVO'),
(102, 102, 22, 'ALU-2025-102', '2025-01-01', 'ACTIVO'),
(103, 103, 22, 'ALU-2025-103', '2025-01-01', 'ACTIVO'),
(104, 104, 22, 'ALU-2025-104', '2025-01-01', 'ACTIVO'),
(105, 105, 22, 'ALU-2025-105', '2025-01-01', 'ACTIVO'),

-- Grado 23 (3ero SECUNDARIA) - 5 alumnos
(106, 106, 23, 'ALU-2025-106', '2025-01-01', 'ACTIVO'),
(107, 107, 23, 'ALU-2025-107', '2025-01-01', 'ACTIVO'),
(108, 108, 23, 'ALU-2025-108', '2025-01-01', 'ACTIVO'),
(109, 109, 23, 'ALU-2025-109', '2025-01-01', 'ACTIVO'),
(110, 110, 23, 'ALU-2025-110', '2025-01-01', 'ACTIVO'),

-- Grado 24 (4to SECUNDARIA) - 5 alumnos
(111, 111, 24, 'ALU-2025-111', '2025-01-01', 'ACTIVO'),
(112, 112, 24, 'ALU-2025-112', '2025-01-01', 'ACTIVO'),
(113, 113, 24, 'ALU-2025-113', '2025-01-01', 'ACTIVO'),
(114, 114, 24, 'ALU-2025-114', '2025-01-01', 'ACTIVO'),
(115, 115, 24, 'ALU-2025-115', '2025-01-01', 'ACTIVO'),

-- Grado 25 (5to SECUNDARIA) - 5 alumnos
(116, 116, 25, 'ALU-2025-116', '2025-01-01', 'ACTIVO'),
(117, 117, 25, 'ALU-2025-117', '2025-01-01', 'ACTIVO'),
(118, 118, 25, 'ALU-2025-118', '2025-01-01', 'ACTIVO'),
(119, 119, 25, 'ALU-2025-119', '2025-01-01', 'ACTIVO'),
(120, 120, 25, 'ALU-2025-120', '2025-01-01', 'ACTIVO'),

-- Alumnos existentes del script original
(20,20,25,'ALU-2025-001','2025-01-01','ACTIVO'),
(21,21,12,'ALU-2025-002','2025-01-01','ACTIVO'),
(22,22,12,'ALU-2025-003','2025-01-01','ACTIVO'),
(23,23,12,'ALU-2025-004','2025-01-01','ACTIVO'),
(24,24,12,'ALU-2025-005','2025-01-01','ACTIVO'),
(25,25,12,'ALU-2025-006','2025-01-01','ACTIVO'),
(26,26,13,'ALU-2025-007','2025-01-01','ACTIVO'),
(27,27,13,'ALU-2025-008','2025-01-01','ACTIVO'),
(28,28,13,'ALU-2025-009','2025-01-01','ACTIVO'),
(29,29,13,'ALU-2025-010','2025-01-01','ACTIVO'),
(30,30,13,'ALU-2025-011','2025-01-01','ACTIVO'),
(31,31,15,'ALU-2025-012','2025-01-01','ACTIVO'),
(32,32,15,'ALU-2025-013','2025-01-01','ACTIVO'),
(33,33,16,'ALU-2025-014','2025-01-01','ACTIVO'),
(34,34,16,'ALU-2025-015','2025-01-01','ACTIVO'),
(35,35,17,'ALU-2025-016','2025-01-01','ACTIVO'),
(36,36,17,'ALU-2025-017','2025-01-01','ACTIVO'),
(37,37,18,'ALU-2025-018','2025-01-01','ACTIVO'),
(38,38,18,'ALU-2025-019','2025-01-01','ACTIVO'),
(39,39,19,'ALU-2025-020','2025-01-01','ACTIVO'),
(40,40,19,'ALU-2025-021','2025-01-01','ACTIVO'),
(41,41,20,'ALU-2025-022','2025-01-01','ACTIVO'),
(42,42,20,'ALU-2025-023','2025-01-01','ACTIVO'),
(43,43,21,'ALU-2025-024','2025-01-01','ACTIVO'),
(44,44,21,'ALU-2025-025','2025-01-01','ACTIVO'),
(45,45,22,'ALU-2025-026','2025-01-01','ACTIVO'),
(46,46,22,'ALU-2025-027','2025-01-01','ACTIVO'),
(47,47,23,'ALU-2025-028','2025-01-01','ACTIVO'),
(48,48,23,'ALU-2025-029','2025-01-01','ACTIVO'),
(49,49,24,'ALU-2025-030','2025-01-01','ACTIVO'),
(50,50,24,'ALU-2025-031','2025-01-01','ACTIVO');

--
-- Insertar profesores (relacionados con personas)
--

INSERT INTO `profesor` (`id`, `persona_id`, `especialidad`, `codigo_profesor`, `fecha_contratacion`, `estado`) VALUES
(5,200,'Biología','PROF-001','2020-01-15','ACTIVO'),
(6,201,'Historia','PROF-002','2019-03-20','ACTIVO'),
(7,202,'Matemática','PROF-003','2021-05-10','ACTIVO'),
(8,203,'Matemática','PROF-004','2018-08-12','ACTIVO'),
(9,204,'Comunicación','PROF-005','2022-02-28','ACTIVO'),
(10,205,'Geografia','PROF-006','2017-11-05','ACTIVO'),
(11,206,'Historia','PROF-007','2023-04-18','ACTIVO'),
(12,207,'Educación Física','PROF-008','2019-07-22','ACTIVO'),
(13,208,'Arte y Cultura','PROF-009','2020-09-30','ACTIVO'),
(14,209,'Matemática','PROF-010','2016-12-15','ACTIVO'),
(15,210,'Química','PROF-011','2021-10-25','ACTIVO'),
(16,211,'Educación Religiosa','PROF-012','2018-06-08','ACTIVO'),
(17,212,'Computación','PROF-013','2022-03-14','ACTIVO');

--
-- Insertar relaciones familiares
--

INSERT INTO `relacion_familiar` (`alumno_id`, `persona_id`, `parentesco`, `es_contacto_principal`, `activo`) VALUES
(21,302,'PADRE',1,1),
(22,303,'PADRE',1,1),
(23,304,'PADRE',1,1);

--
-- Insertar cursos
--

INSERT INTO `curso` (`id`, `nombre`, `grado_id`, `profesor_id`, `creditos`, `area`, `activo`) VALUES
(14,'Historia',19,5,1,'Humanidades',1),
(17,'Religion',22,5,1,'Valores',1),
(19,'Psicomotricidad',12,12,1,'Inicial',1),
(20,'Lenguaje Oral',12,9,1,'Inicial',1),
(21,'Numeros Basicos',12,7,1,'Inicial',1),
(22,'Cuentos y Relatos',12,6,1,'Inicial',1),
(23,'Expresion Artistica',12,13,1,'Inicial',1),
(136,'Algebra',25,8,1,'Ciencia',1),
(137,'Geometria y Trigonometria',25,7,1,'Ciencia',1),
(138,'Comunicacion',25,9,1,'Humanidades',1),
(139,'Analisis de Textos',25,9,1,'Humanidades',1),
(140,'Historia del Peru',25,6,1,'Humanidades',1),
(141,'Geografia',25,10,1,'Humanidades',1),
(142,'Ciencia y Tecnologia',25,5,1,'Ciencia',1),
(143,'Fisica y Quimica',25,15,1,'Ciencia',1),
(144,'Educacion Fisica',25,12,1,'Educación',1),
(145,'Arte y Cultura',25,13,1,'Educación',1),
(146,'Computacion',25,17,1,'Tecnología',1),
(147,'Formacion Ciudadana',25,16,1,'Valores',1);

--
-- Insertar disponibilidad de profesores
--

INSERT INTO `disponibilidad_profesor` (`profesor_id`, `turno_id`, `dia_semana`, `hora_inicio`, `hora_fin`, `disponible`) VALUES
(5, 1, 'LUNES', '08:00:00', '12:00:00', 1),
(5, 1, 'MIERCOLES', '08:00:00', '12:00:00', 1),
(5, 1, 'VIERNES', '08:00:00', '12:00:00', 1),
(6, 1, 'LUNES', '10:00:00', '14:00:00', 1),
(6, 1, 'JUEVES', '10:00:00', '14:00:00', 1),
(7, 1, 'LUNES', '08:00:00', '11:00:00', 1),
(7, 1, 'MIERCOLES', '08:00:00', '11:00:00', 1),
(7, 1, 'VIERNES', '08:00:00', '11:00:00', 1),
(8, 1, 'LUNES', '09:00:00', '13:00:00', 1),
(8, 1, 'MARTES', '09:00:00', '13:00:00', 1),
(9, 1, 'LUNES', '08:00:00', '12:00:00', 1),
(9, 1, 'JUEVES', '08:00:00', '12:00:00', 1);

--
-- Insertar curso_profesor (asignaciones según especialidad)
--

INSERT INTO `curso_profesor` (`curso_id`, `profesor_id`, `activo`) VALUES
-- Cursos de Matemáticas: Álgebra (136) - Profesores de Matemática
(136, 7, 1),  -- Sofia Quiroz (Matemática)
(136, 8, 1),  -- Luis Garcia (Matemática)
(136, 14, 1), -- Jorge Perez (Matemática)

-- Cursos de Matemáticas: Geometría (137)
(137, 7, 1),  -- Sofia Quiroz
(137, 8, 1),  -- Luis Garcia
(137, 14, 1), -- Jorge Perez

-- Cursos de Comunicación: Comunicación (138) y Análisis de Textos (139)
(138, 9, 1),  -- Ana Lopez (Comunicación)
(139, 9, 1),  -- Ana Lopez (Comunicación)

-- Cursos de Historia: Historia (14) e Historia del Perú (140)
(14, 6, 1),   -- Juan Tapia (Historia)
(14, 11, 1),  -- Laura Diaz (Historia)
(140, 6, 1),  -- Juan Tapia (Historia)
(140, 11, 1), -- Laura Diaz (Historia)

-- Cursos de Geografía: Geografía (141)
(141, 10, 1), -- Pedro Torres (Geografia)

-- Cursos de Ciencias: Ciencia y Tecnología (142)
(142, 5, 1),  -- Nick Flores (Biología)
(142, 15, 1), -- Valeria Ruiz (Química)

-- Cursos de Ciencias: Física y Química (143)
(143, 5, 1),  -- Nick Flores (Biología)
(143, 15, 1), -- Valeria Ruiz (Química)

-- Cursos de Educación Física (144)
(144, 12, 1), -- Carlos Martinez (Educación Física)

-- Cursos de Arte (145)
(145, 13, 1), -- Andrea Santos (Arte y Cultura)

-- Cursos de Computación (146)
(146, 17, 1), -- Isabel Castro (Computación)

-- Cursos de Valores: Religión (17) y Formación Ciudadana (147)
(17, 16, 1),  -- Fernando Ramos (Educación Religiosa)
(147, 16, 1), -- Fernando Ramos (Educación Religiosa)

-- Cursos de Inicial (asignar múltiples profesores)
-- Psicomotricidad (19)
(19, 12, 1),  -- Carlos Martinez (Educación Física)

-- Lenguaje Oral (20)
(20, 9, 1),   -- Ana Lopez (Comunicación)

-- Números Básicos (21)
(21, 7, 1),   -- Sofia Quiroz (Matemática)
(21, 8, 1),   -- Luis Garcia (Matemática)

-- Cuentos y Relatos (22)
(22, 6, 1),   -- Juan Tapia (Historia)
(22, 9, 1),   -- Ana Lopez (Comunicación)

-- Expresión Artística (23)
(23, 13, 1);  -- Andrea Santos (Arte y Cultura)

--
-- Insertar relación cursos-materias
--

INSERT INTO `curso_materia` (`curso_id`, `materia_id`) VALUES
(14,3),(17,9),(19,12),(20,13),(21,14),(22,15),(23,16),
(136,1),(137,1),(138,2),(139,2),(140,3),(141,10),(142,4),
(143,4),(144,5),(145,6),(146,8),(147,11);

--
-- Insertar horarios de clase
--

INSERT INTO `horario_clase` (`id`, `curso_id`, `turno_id`, `dia_semana`, `hora_inicio`, `hora_fin`, `aula_id`, `profesor_id`, `activo`) VALUES
(1,136,1,'LUNES','08:00:00','09:30:00',1,7,1),
(2,136,1,'MIERCOLES','08:00:00','09:30:00',1,7,1),
(3,136,1,'VIERNES','08:00:00','09:30:00',1,7,1),
(4,140,1,'LUNES','10:00:00','11:30:00',1,6,1),
(5,140,1,'JUEVES','10:00:00','11:30:00',1,6,1),
(6,22,2,'LUNES','13:00:00','14:00:00',5,6,1),
(7,22,2,'MARTES','13:00:00','14:00:00',5,6,1),
(8,22,2,'MIERCOLES','13:00:00','14:00:00',5,6,1),
(9,22,2,'JUEVES','13:00:00','14:00:00',5,6,1),
(10,22,2,'VIERNES','13:00:00','14:00:00',5,6,1),
(11,19,1,'LUNES','08:00:00','09:00:00',6,12,1),
(12,19,1,'MIERCOLES','08:00:00','09:00:00',6,12,1),
(13,19,1,'VIERNES','08:00:00','09:00:00',6,12,1);

--
-- Insertar tareas
--

INSERT INTO `tarea` (`id`, `curso_id`, `nombre`, `descripcion`, `fecha_entrega`, `tipo`, `peso`, `activo`) VALUES
(4,22,'Tarea semana 1','Hacer una lamina','2025-06-08','TAREA',1.00,1),
(5,136,'Tarea semana 1','dibujar','2025-06-04','TAREA',1.00,0),
(6,140,'Semana 2','Realizar un cuadro','2025-06-23','TAREA',1.00,1),
(11,137,'Semana 1','Resolver ejercicios pagina 50','2025-06-22','TAREA',1.00,1),
(12,140,'Semana 3','Hola:D','2025-06-23','TAREA',1.00,1),
(13,140,'semana 13','evaluaciont3','2025-06-28','EXAMEN',2.00,0),
(14,22,'CUENTO','TAREA ENTREGAR PLAZO A UNA SEMANA','2025-10-27','TAREA',1.00,1);

--
-- Insertar asistencias (ejemplos)
--

INSERT INTO `asistencia` (`id`, `alumno_id`, `curso_id`, `turno_id`, `fecha`, `hora_clase`, `estado`, `observaciones`, `registrado_por`, `fecha_registro`, `fecha_actualizacion`, `activo`) VALUES
(1,21,136,1,'2025-10-14','08:00:00','PRESENTE','Asistió puntual',8,'2025-10-16 18:21:41','2025-10-16 18:21:41',1),
(2,21,136,1,'2025-10-12','08:00:00','TARDANZA','Llegó 10 minutos tarde',8,'2025-10-16 18:21:41','2025-10-16 18:21:41',1),
(3,21,136,1,'2025-10-16','08:00:00','PRESENTE',NULL,8,'2025-10-16 18:21:41','2025-10-16 18:21:41',1),
(4,21,140,1,'2025-10-13','10:00:00','PRESENTE',NULL,6,'2025-10-16 18:21:41','2025-10-16 18:21:41',1),
(8,24,22,2,'2025-10-16','13:00:00','JUSTIFICADO',NULL,8,'2025-10-16 18:21:41','2025-10-18 02:38:04',1),
(9,25,22,2,'2025-10-16','13:00:00','PRESENTE',NULL,8,'2025-10-16 18:21:41','2025-10-16 18:21:41',1);

--
-- Insertar justificaciones
--

INSERT INTO `justificacion` (`id`, `asistencia_id`, `tipo_justificacion`, `descripcion`, `documento_adjunto`, `justificado_por`, `fecha_justificacion`, `estado`, `aprobado_por`, `fecha_aprobacion`, `observaciones_aprobacion`, `activo`) VALUES
(2,8,'ENFERMEDAD','El alumno estaba enfermo',NULL,6,'2025-10-18 02:38:04','PENDIENTE',NULL,NULL,NULL,1);

--
-- Insertar notas
--

INSERT INTO `nota` (`id`, `alumno_id`, `tarea_id`, `nota`, `fecha_registro`, `registrado_por`) VALUES
(2,26,4,18.00,'2025-06-05 10:00:00',6),
(3,21,6,15.00,'2025-06-20 10:00:00',6),
(6,33,5,15.00,'2025-06-03 10:00:00',6),
(7,31,4,13.00,'2025-06-05 10:00:00',6),
(10,137,11,18.00,'2025-06-20 10:00:00',8),
(11,140,12,8.00,'2025-06-20 10:00:00',6),
(12,214,13,13.00,'2025-06-25 10:00:00',6),
(13,140,13,18.00,'2025-06-25 10:00:00',6),
(14,30,14,3.00,'2025-10-20 10:00:00',6);

--
-- Insertar observaciones
--

INSERT INTO `observacion` (`id`, `alumno_id`, `curso_id`, `tipo`, `texto`, `registrado_por`, `fecha_registro`) VALUES
(2,47,136,'NEGATIVA','el alumno no trabaja en clase',6,'2025-06-10 10:00:00'),
(3,31,22,'POSITIVA','El alumno trabaja de manera activa en clase',6,'2025-06-10 10:00:00'),
(4,25,22,'POSITIVA','La alumna se gano un punto para su examen mensual',6,'2025-06-10 10:00:00'),
(5,23,22,'POSITIVA','Felicitar a la alumna por la tarea bien hecha',6,'2025-06-10 10:00:00'),
(6,21,140,'POSITIVA','La alumna cumplio muy bien su tarea',6,'2025-06-20 10:00:00'),
(11,21,137,'POSITIVA','Buen trabajo',8,'2025-06-20 10:00:00'),
(12,21,140,'NEUTRAL','ashgdjdsagfjgsjdfghsjdgfhjsd',6,'2025-06-20 10:00:00'),
(13,21,140,'POSITIVA','hizo una buena evaluacion t3',6,'2025-06-25 10:00:00'),
(14,21,137,'NEGATIVA','No cumplio la tarea de la Semana 12',8,'2025-06-25 10:00:00'),
(15,30,22,'POSITIVA','TRABAJO PERFECTO',6,'2025-10-20 10:00:00');

--
-- Insertar imágenes
--

INSERT INTO `imagen` (`id`, `alumno_id`, `ruta`, `fecha_subida`) VALUES
(17,31,'uploads/1752219686243_fotoeperfil.jpg','2025-07-11 02:41:26'),
(24,21,'uploads/1752221160126_fotoeperfil.jpg','2025-07-11 03:06:00'),
(25,21,'uploads/1758501078073_11569877522.png','2025-09-21 19:31:18'),
(26,21,'uploads/1761517769984_15691221895.png','2025-10-26 17:29:30');

-- ------------------------------------------------------
-- STORED PROCEDURES (Actualizados para usar eliminación lógica)
-- ------------------------------------------------------

DELIMITER $$

--
-- Procedure: `actualizar_alumno`
--

DROP PROCEDURE IF EXISTS `actualizar_alumno`$$
CREATE PROCEDURE `actualizar_alumno`(
    IN p_id INT,
    IN p_nombres VARCHAR(100),
    IN p_apellidos VARCHAR(100),
    IN p_correo VARCHAR(100),
    IN p_fecha_nacimiento DATE,
    IN p_grado_id INT,
    IN p_telefono VARCHAR(20),
    IN p_dni VARCHAR(20),
    IN p_direccion VARCHAR(255)
)
BEGIN
    DECLARE v_persona_id INT;
    
    -- Obtener el persona_id del alumno
    SELECT persona_id INTO v_persona_id FROM alumno WHERE id = p_id AND eliminado = 0;
    
    IF v_persona_id IS NOT NULL THEN
        -- Actualizar la persona
        UPDATE persona 
        SET nombres = p_nombres,
            apellidos = p_apellidos,
            correo = p_correo,
            fecha_nacimiento = p_fecha_nacimiento,
            telefono = p_telefono,
            dni = p_dni,
            direccion = p_direccion
        WHERE id = v_persona_id AND eliminado = 0;
        
        -- Actualizar el alumno
        UPDATE alumno 
        SET grado_id = p_grado_id
        WHERE id = p_id AND eliminado = 0;
        
        SELECT 1 as resultado, 'Alumno actualizado correctamente' as mensaje;
    ELSE
        SELECT 0 as resultado, 'Alumno no encontrado' as mensaje;
    END IF;
END$$

--
-- Procedure: `actualizar_curso`
--

DROP PROCEDURE IF EXISTS `actualizar_curso`$$
CREATE PROCEDURE `actualizar_curso`(
    IN p_id INT,
    IN p_nombre VARCHAR(100),
    IN p_grado_id INT,
    IN p_profesor_id INT,
    IN p_creditos INT,
    IN p_horas_semanales INT,
    IN p_area VARCHAR(50),
    IN p_descripcion TEXT,
    IN p_ciclo VARCHAR(10),
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE
)
BEGIN
    UPDATE curso 
    SET nombre = p_nombre,
        grado_id = p_grado_id,
        profesor_id = p_profesor_id,
        creditos = p_creditos,
        horas_semanales = p_horas_semanales,
        area = p_area,
        descripcion = p_descripcion,
        ciclo = p_ciclo,
        fecha_inicio = p_fecha_inicio,
        fecha_fin = p_fecha_fin
    WHERE id = p_id AND eliminado = 0;
    
    SELECT 1 as resultado, 'Curso actualizado correctamente' as mensaje;
END$$

--
-- Procedure: `eliminar_logico_alumno`
--

DROP PROCEDURE IF EXISTS `eliminar_logico_alumno`$$
CREATE PROCEDURE `eliminar_logico_alumno`(
    IN p_id INT
)
BEGIN
    DECLARE v_persona_id INT;
    
    -- Obtener el persona_id del alumno
    SELECT persona_id INTO v_persona_id FROM alumno WHERE id = p_id AND eliminado = 0;
    
    IF v_persona_id IS NOT NULL THEN
        -- Eliminar lógicamente el alumno
        UPDATE alumno 
        SET eliminado = 1,
            activo = 0
        WHERE id = p_id;
        
        -- Eliminar lógicamente la persona
        UPDATE persona 
        SET eliminado = 1,
            activo = 0
        WHERE id = v_persona_id;
        
        SELECT 1 as resultado, 'Alumno eliminado lógicamente correctamente' as mensaje;
    ELSE
        SELECT 0 as resultado, 'Alumno no encontrado' as mensaje;
    END IF;
END$$

--
-- Procedure: `eliminar_logico_curso`
--

DROP PROCEDURE IF EXISTS `eliminar_logico_curso`$$
CREATE PROCEDURE `eliminar_logico_curso`(
    IN p_id INT
)
BEGIN
    UPDATE curso 
    SET eliminado = 1,
        activo = 0
    WHERE id = p_id AND eliminado = 0;
    
    SELECT 1 as resultado, 'Curso eliminado lógicamente correctamente' as mensaje;
END$$

--
-- Procedure: `crear_curso_completo`
--

DROP PROCEDURE IF EXISTS `crear_curso_completo`$$
CREATE PROCEDURE `crear_curso_completo`(
    IN p_nombre VARCHAR(100),
    IN p_grado_id INT,
    IN p_profesor_id INT,
    IN p_creditos INT,
    IN p_horas_semanales INT,
    IN p_area VARCHAR(50),
    IN p_descripcion TEXT,
    IN p_ciclo VARCHAR(10),
    IN p_fecha_inicio DATE,
    IN p_fecha_fin DATE,
    IN p_profesores_json TEXT,
    IN p_materias_json TEXT,
    IN p_horarios_json TEXT
)
BEGIN
    DECLARE v_curso_id INT;
    DECLARE i INT DEFAULT 0;
    DECLARE j INT DEFAULT 0;
    DECLARE k INT DEFAULT 0;
    DECLARE v_profesor_id INT;
    DECLARE v_materia_id INT;
    DECLARE v_dia_semana VARCHAR(20);
    DECLARE v_hora_inicio TIME;
    DECLARE v_hora_fin TIME;
    DECLARE v_aula_id INT;
    DECLARE v_turno_id INT;
    DECLARE v_profesores_count INT;
    DECLARE v_materias_count INT;
    DECLARE v_horarios_count INT;
    
    -- Crear el curso
    INSERT INTO curso (
        nombre, grado_id, profesor_id, creditos, horas_semanales,
        area, descripcion, ciclo, fecha_inicio, fecha_fin
    ) VALUES (
        p_nombre, p_grado_id, p_profesor_id, p_creditos, p_horas_semanales,
        p_area, p_descripcion, p_ciclo, p_fecha_inicio, p_fecha_fin
    );
    
    SET v_curso_id = LAST_INSERT_ID();
    
    -- Asignar profesores adicionales
    IF p_profesores_json IS NOT NULL AND p_profesores_json != '' THEN
        SET v_profesores_count = JSON_LENGTH(p_profesores_json);
        WHILE i < v_profesores_count DO
            SET v_profesor_id = JSON_EXTRACT(p_profesores_json, CONCAT('$[', i, ']'));
            
            INSERT INTO curso_profesor (curso_id, profesor_id)
            VALUES (v_curso_id, v_profesor_id)
            ON DUPLICATE KEY UPDATE activo = 1, eliminado = 0;
            
            SET i = i + 1;
        END WHILE;
    END IF;
    
    -- Asignar materias
    IF p_materias_json IS NOT NULL AND p_materias_json != '' THEN
        SET v_materias_count = JSON_LENGTH(p_materias_json);
        SET j = 0;
        WHILE j < v_materias_count DO
            SET v_materia_id = JSON_EXTRACT(p_materias_json, CONCAT('$[', j, ']'));
            
            INSERT INTO curso_materia (curso_id, materia_id)
            VALUES (v_curso_id, v_materia_id)
            ON DUPLICATE KEY UPDATE activo = 1, eliminado = 0;
            
            SET j = j + 1;
        END WHILE;
    END IF;
    
    -- Crear horarios
    IF p_horarios_json IS NOT NULL AND p_horarios_json != '' THEN
        SET v_horarios_count = JSON_LENGTH(p_horarios_json);
        SET k = 0;
        WHILE k < v_horarios_count DO
            SET v_dia_semana = JSON_UNQUOTE(JSON_EXTRACT(p_horarios_json, CONCAT('$[', k, '].dia_semana')));
            SET v_hora_inicio = JSON_UNQUOTE(JSON_EXTRACT(p_horarios_json, CONCAT('$[', k, '].hora_inicio')));
            SET v_hora_fin = JSON_UNQUOTE(JSON_EXTRACT(p_horarios_json, CONCAT('$[', k, '].hora_fin')));
            SET v_aula_id = JSON_EXTRACT(p_horarios_json, CONCAT('$[', k, '].aula_id'));
            SET v_turno_id = JSON_EXTRACT(p_horarios_json, CONCAT('$[', k, '].turno_id'));
            
            INSERT INTO horario_clase (
                curso_id, turno_id, dia_semana, hora_inicio, hora_fin,
                aula_id, profesor_id
            ) VALUES (
                v_curso_id, v_turno_id, v_dia_semana, v_hora_inicio, v_hora_fin,
                v_aula_id, p_profesor_id
            );
            
            SET k = k + 1;
        END WHILE;
    END IF;
    
    SELECT v_curso_id as id, 'Curso creado correctamente' as mensaje;
END$$

--
-- Procedure: `registrar_disponibilidad_profesor`
--

DROP PROCEDURE IF EXISTS `registrar_disponibilidad_profesor`$$
CREATE PROCEDURE `registrar_disponibilidad_profesor`(
    IN p_profesor_id INT,
    IN p_turno_id INT,
    IN p_dia_semana VARCHAR(20),
    IN p_hora_inicio TIME,
    IN p_hora_fin TIME,
    IN p_disponible TINYINT,
    IN p_observaciones TEXT
)
BEGIN
    INSERT INTO disponibilidad_profesor (
        profesor_id, turno_id, dia_semana, hora_inicio, hora_fin,
        disponible, observaciones
    ) VALUES (
        p_profesor_id, p_turno_id, p_dia_semana, p_hora_inicio, p_hora_fin,
        p_disponible, p_observaciones
    )
    ON DUPLICATE KEY UPDATE
        disponible = p_disponible,
        observaciones = p_observaciones,
        activo = 1,
        eliminado = 0;
    
    SELECT LAST_INSERT_ID() as id;
END$$

--
-- Procedure: `obtener_disponibilidad_profesor`
--

DROP PROCEDURE IF EXISTS `obtener_disponibilidad_profesor`$$
CREATE PROCEDURE `obtener_disponibilidad_profesor`(
    IN p_profesor_id INT
)
BEGIN
    SELECT 
        d.id,
        d.profesor_id,
        d.turno_id,
        d.dia_semana,
        d.hora_inicio,
        d.hora_fin,
        d.disponible,
        d.observaciones,
        t.nombre as turno_nombre,
        CONCAT(p.nombres, ' ', p.apellidos) as profesor_nombre
    FROM disponibilidad_profesor d
    JOIN turno t ON d.turno_id = t.id
    JOIN profesor prof ON d.profesor_id = prof.id
    JOIN persona p ON prof.persona_id = p.id
    WHERE d.profesor_id = p_profesor_id
    AND d.eliminado = 0
    AND d.activo = 1
    ORDER BY 
        FIELD(d.dia_semana, 'LUNES', 'MARTES', 'MIERCOLES', 'JUEVES', 'VIERNES', 'SABADO'),
        d.hora_inicio;
END$$

--
-- Procedure: `obtener_cursos_disponibles_para_profesor`
--

DROP PROCEDURE IF EXISTS `obtener_cursos_disponibles_para_profesor`$$
CREATE PROCEDURE `obtener_cursos_disponibles_para_profesor`(
    IN p_profesor_id INT
)
BEGIN
    SELECT 
        c.id,
        c.nombre,
        c.creditos,
        c.horas_semanales,
        c.area,
        g.nombre as grado_nombre,
        g.nivel,
        COUNT(DISTINCT h.id) as horarios_asignados,
        GROUP_CONCAT(DISTINCT 
            CONCAT(h.dia_semana, ' ', TIME_FORMAT(h.hora_inicio, '%H:%i'), '-', TIME_FORMAT(h.hora_fin, '%H:%i'))
            ORDER BY h.dia_semana, h.hora_inicio SEPARATOR '; '
        ) as horarios
    FROM curso c
    JOIN grado g ON c.grado_id = g.id
    LEFT JOIN horario_clase h ON c.id = h.curso_id AND h.eliminado = 0
    WHERE c.eliminado = 0
    AND c.activo = 1
    AND c.id NOT IN (
        SELECT curso_id 
        FROM curso_profesor 
        WHERE profesor_id = p_profesor_id 
        AND eliminado = 0
        AND activo = 1
    )
    GROUP BY c.id, c.nombre, c.creditos, c.horas_semanales, c.area, g.nombre, g.nivel
    ORDER BY g.nivel, g.nombre, c.nombre;
END$$

--
-- Procedure: `obtener_profesores_disponibles_para_curso`
--

DROP PROCEDURE IF EXISTS `obtener_profesores_disponibles_para_curso`$$
CREATE PROCEDURE `obtener_profesores_disponibles_para_curso`(
    IN p_curso_id INT
)
BEGIN
    SELECT 
        prof.id,
        CONCAT(p.nombres, ' ', p.apellidos) as nombre_completo,
        prof.especialidad,
        COUNT(DISTINCT d.id) as disponibilidad_count,
        GROUP_CONCAT(DISTINCT 
            CONCAT(d.dia_semana, ' ', TIME_FORMAT(d.hora_inicio, '%H:%i'), '-', TIME_FORMAT(d.hora_fin, '%H:%i'))
            ORDER BY d.dia_semana, d.hora_inicio SEPARATOR '; '
        ) as disponibilidad_horarios
    FROM profesor prof
    JOIN persona p ON prof.persona_id = p.id
    LEFT JOIN disponibilidad_profesor d ON prof.id = d.profesor_id AND d.disponible = 1 AND d.eliminado = 0
    WHERE prof.eliminado = 0
    AND prof.activo = 1
    AND prof.estado = 'ACTIVO'
    AND prof.id NOT IN (
        SELECT profesor_id 
        FROM curso_profesor 
        WHERE curso_id = p_curso_id 
        AND eliminado = 0
        AND activo = 1
    )
    GROUP BY prof.id, nombre_completo, prof.especialidad
    ORDER BY p.apellidos, p.nombres;
END$$

--
-- Procedure: `configurar_limite_edicion_asistencia`
--

DROP PROCEDURE IF EXISTS `configurar_limite_edicion_asistencia`$$
CREATE PROCEDURE `configurar_limite_edicion_asistencia`(
    IN p_curso_id INT,
    IN p_turno_id INT,
    IN p_dia_semana VARCHAR(20),
    IN p_hora_inicio_clase TIME,
    IN p_limite_edicion_minutos INT,
    IN p_aplica_todos_cursos TINYINT,
    IN p_descripcion VARCHAR(255)
)
BEGIN
    INSERT INTO configuracion_limite_edicion_asistencia (
        curso_id, turno_id, dia_semana, hora_inicio_clase,
        limite_edicion_minutos, aplica_todos_cursos, descripcion
    ) VALUES (
        p_curso_id, p_turno_id, p_dia_semana, p_hora_inicio_clase,
        p_limite_edicion_minutos, p_aplica_todos_cursos, p_descripcion
    )
    ON DUPLICATE KEY UPDATE
        limite_edicion_minutos = p_limite_edicion_minutos,
        aplica_todos_cursos = p_aplica_todos_cursos,
        descripcion = p_descripcion,
        activo = 1,
        eliminado = 0;
    
    SELECT LAST_INSERT_ID() as id;
END$$

--
-- Procedure: `verificar_limite_edicion_asistencia`
--

DROP PROCEDURE IF EXISTS `verificar_limite_edicion_asistencia`$$
CREATE PROCEDURE `verificar_limite_edicion_asistencia`(
    IN p_curso_id INT,
    IN p_turno_id INT,
    IN p_dia_semana VARCHAR(20),
    IN p_hora_clase TIME,
    IN p_fecha DATE
)
BEGIN
    DECLARE v_limite_minutos INT;
    DECLARE v_fecha_hora_clase DATETIME;
    DECLARE v_fecha_limite DATETIME;
    DECLARE v_puede_editar BOOLEAN;
    DECLARE v_config_id INT;
    
    -- Buscar configuración específica
    SELECT id, limite_edicion_minutos INTO v_config_id, v_limite_minutos
    FROM configuracion_limite_edicion_asistencia
    WHERE curso_id = p_curso_id
    AND turno_id = p_turno_id
    AND dia_semana = p_dia_semana
    AND hora_inicio_clase = p_hora_clase
    AND eliminado = 0
    AND activo = 1;
    
    -- Si no hay configuración específica, buscar configuración general
    IF v_config_id IS NULL THEN
        SELECT id, limite_edicion_minutos INTO v_config_id, v_limite_minutos
        FROM configuracion_limite_edicion_asistencia
        WHERE aplica_todos_cursos = 1
        AND turno_id = p_turno_id
        AND dia_semana = p_dia_semana
        AND hora_inicio_clase = p_hora_clase
        AND eliminado = 0
        AND activo = 1;
    END IF;
    
    -- Si no hay configuración, usar el valor por defecto
    IF v_limite_minutos IS NULL THEN
        SELECT valor INTO v_limite_minutos
        FROM parametro_sistema
        WHERE categoria = 'ASISTENCIA' AND clave = 'LIMITE_EDICION_DEFAULT'
        AND eliminado = 0 AND activo = 1;
        
        -- Si no hay valor por defecto, usar 120 minutos (2 horas)
        IF v_limite_minutos IS NULL THEN
            SET v_limite_minutos = 120;
        ELSE
            SET v_limite_minutos = CAST(v_limite_minutos AS UNSIGNED);
        END IF;
    END IF;
    
    -- Calcular la fecha y hora de la clase
    SET v_fecha_hora_clase = CONCAT(p_fecha, ' ', p_hora_clase);
    
    -- Calcular la fecha límite para editar
    SET v_fecha_limite = DATE_ADD(v_fecha_hora_clase, INTERVAL v_limite_minutos MINUTE);
    
    -- Verificar si la fecha actual es menor que la fecha límite
    IF NOW() <= v_fecha_limite THEN
        SET v_puede_editar = TRUE;
    ELSE
        SET v_puede_editar = FALSE;
    END IF;
    
    -- Retornar los resultados
    SELECT 
        v_puede_editar as puede_editar,
        v_fecha_limite as fecha_limite,
        v_limite_minutos as limite_minutos,
        NOW() as fecha_actual,
        CASE 
            WHEN v_config_id IS NOT NULL THEN 'Configuración específica'
            ELSE 'Configuración por defecto'
        END as tipo_configuracion;
END$$

--
-- Procedure: `obtener_configuraciones_limite_edicion`
--

DROP PROCEDURE IF EXISTS `obtener_configuraciones_limite_edicion`$$
CREATE PROCEDURE `obtener_configuraciones_limite_edicion`()
BEGIN
    SELECT 
        c.id,
        c.curso_id,
        c.turno_id,
        c.dia_semana,
        c.hora_inicio_clase,
        c.limite_edicion_minutos,
        c.aplica_todos_cursos,
        c.descripcion,
        cu.nombre as curso_nombre,
        t.nombre as turno_nombre,
        CONCAT(g.nombre, ' - ', g.nivel) as grado_nombre
    FROM configuracion_limite_edicion_asistencia c
    LEFT JOIN curso cu ON c.curso_id = cu.id
    JOIN turno t ON c.turno_id = t.id
    LEFT JOIN grado g ON cu.grado_id = g.id
    WHERE c.eliminado = 0
    AND c.activo = 1
    ORDER BY c.aplica_todos_cursos DESC, cu.nombre, c.dia_semana, c.hora_inicio_clase;
END$$

--
-- Procedure: `obtener_cursos_con_horarios`
--

DROP PROCEDURE IF EXISTS `obtener_cursos_con_horarios`$$
CREATE PROCEDURE `obtener_cursos_con_horarios`()
BEGIN
    SELECT 
        c.id,
        c.nombre,
        c.creditos,
        c.horas_semanales,
        c.area,
        c.ciclo,
        c.fecha_inicio,
        c.fecha_fin,
        g.nombre as grado_nombre,
        g.nivel,
        CONCAT(p.nombres, ' ', p.apellidos) as profesor_principal,
        COUNT(DISTINCT cp.profesor_id) as total_profesores,
        COUNT(DISTINCT h.id) as total_horarios,
        GROUP_CONCAT(DISTINCT 
            CONCAT(
                'Día: ', h.dia_semana, 
                ', Hora: ', TIME_FORMAT(h.hora_inicio, '%H:%i'), '-', TIME_FORMAT(h.hora_fin, '%H:%i'),
                ', Aula: ', a.nombre
            )
            ORDER BY h.dia_semana, h.hora_inicio SEPARATOR '; '
        ) as horarios_detalle
    FROM curso c
    JOIN grado g ON c.grado_id = g.id
    LEFT JOIN profesor prof ON c.profesor_id = prof.id
    LEFT JOIN persona p ON prof.persona_id = p.id
    LEFT JOIN curso_profesor cp ON c.id = cp.curso_id AND cp.eliminado = 0
    LEFT JOIN horario_clase h ON c.id = h.curso_id AND h.eliminado = 0
    LEFT JOIN aula a ON h.aula_id = a.id
    WHERE c.eliminado = 0
    AND c.activo = 1
    GROUP BY c.id, c.nombre, c.creditos, c.horas_semanales, c.area, c.ciclo, 
             c.fecha_inicio, c.fecha_fin, g.nombre, g.nivel, profesor_principal
    ORDER BY g.nivel, g.nombre, c.nombre;
END$$

--
-- Procedure: `obtener_horarios_por_curso_y_profesor`
--

DROP PROCEDURE IF EXISTS `obtener_horarios_por_curso_y_profesor`$$
CREATE PROCEDURE `obtener_horarios_por_curso_y_profesor`(
    IN p_curso_id INT,
    IN p_profesor_id INT
)
BEGIN
    SELECT 
        h.id,
        h.curso_id,
        h.turno_id,
        h.dia_semana,
        h.hora_inicio,
        h.hora_fin,
        h.aula_id,
        h.profesor_id,
        c.nombre as curso_nombre,
        t.nombre as turno_nombre,
        a.nombre as aula_nombre,
        s.nombre as sede_nombre,
        CONCAT(p.nombres, ' ', p.apellidos) as profesor_nombre
    FROM horario_clase h
    JOIN curso c ON h.curso_id = c.id
    JOIN turno t ON h.turno_id = t.id
    JOIN aula a ON h.aula_id = a.id
    JOIN sede s ON a.sede_id = s.id
    JOIN profesor prof ON h.profesor_id = prof.id
    JOIN persona p ON prof.persona_id = p.id
    WHERE h.curso_id = p_curso_id 
    AND h.profesor_id = p_profesor_id
    AND h.eliminado = 0
    AND h.activo = 1
    ORDER BY 
        FIELD(h.dia_semana, 'LUNES', 'MARTES', 'MIERCOLES', 'JUEVES', 'VIERNES', 'SABADO'),
        h.hora_inicio;
END$$

--
-- Procedure: `obtener_administradores`
--

DROP PROCEDURE IF EXISTS `obtener_administradores`$$
CREATE PROCEDURE `obtener_administradores`()
BEGIN
    SELECT 
        a.id,
        a.persona_id,
        a.cargo,
        a.codigo_administrativo,
        a.fecha_ingreso,
        a.departamento,
        a.estado,
        p.nombres,
        p.apellidos,
        p.correo,
        p.telefono,
        p.dni,
        u.username,
        u.rol
    FROM administrativo a
    JOIN persona p ON a.persona_id = p.id
    JOIN usuario u ON p.id = u.persona_id
    WHERE a.eliminado = 0
    AND a.activo = 1
    AND p.eliminado = 0
    AND u.activo = 1
    ORDER BY p.apellidos, p.nombres;
END$$

--
-- Procedure: `crear_administrativo`
--

DROP PROCEDURE IF EXISTS `crear_administrativo`$$
CREATE PROCEDURE `crear_administrativo`(
    IN p_nombres VARCHAR(100),
    IN p_apellidos VARCHAR(100),
    IN p_correo VARCHAR(100),
    IN p_dni VARCHAR(20),
    IN p_telefono VARCHAR(20),
    IN p_fecha_nacimiento DATE,
    IN p_direccion VARCHAR(255),
    IN p_cargo VARCHAR(100),
    IN p_departamento VARCHAR(100),
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(100)
)
BEGIN
    DECLARE v_persona_id INT;
    DECLARE v_administrativo_id INT;
    
    -- Insertar en personas
    INSERT INTO persona (
        tipo, nombres, apellidos, correo, dni, telefono,
        fecha_nacimiento, direccion
    ) VALUES (
        'ADMINISTRATIVO', p_nombres, p_apellidos, p_correo, p_dni, p_telefono,
        p_fecha_nacimiento, p_direccion
    );
    
    SET v_persona_id = LAST_INSERT_ID();
    
    -- Insertar en administrativos
    INSERT INTO administrativo (
        persona_id, cargo, codigo_administrativo, fecha_ingreso, departamento
    ) VALUES (
        v_persona_id, p_cargo, CONCAT('ADM-', LPAD(v_persona_id, 3, '0')), CURDATE(), p_departamento
    );
    
    SET v_administrativo_id = LAST_INSERT_ID();
    
    -- Crear usuario
    INSERT INTO usuario (persona_id, username, password, rol, activo)
    VALUES (v_persona_id, p_username, p_password, 'administrativo', TRUE);
    
    SELECT v_administrativo_id as id, 'Administrativo creado correctamente' as mensaje;
END$$

-- ------------------------------------------------------
-- PROCEDIMIENTOS ORIGINALES (actualizados con eliminación lógica)
-- ------------------------------------------------------

--
-- Procedure: `actualizar_grado`
--

DROP PROCEDURE IF EXISTS `actualizar_grado`$$
CREATE PROCEDURE `actualizar_grado`(
    IN p_id INT,
    IN p_nombre VARCHAR(100),
    IN p_nivel VARCHAR(50),
    IN p_orden INT
)
BEGIN
    UPDATE grado 
    SET nombre = p_nombre,
        nivel = p_nivel,
        orden = p_orden
    WHERE id = p_id AND eliminado = 0;
    
    SELECT 1 as resultado, 'Grado actualizado correctamente' as mensaje;
END$$

--
-- Procedure: `eliminar_logico_grado`
--

DROP PROCEDURE IF EXISTS `eliminar_logico_grado`$$
CREATE PROCEDURE `eliminar_logico_grado`(
    IN p_id INT
)
BEGIN
    UPDATE grado 
    SET eliminado = 1,
        activo = 0
    WHERE id = p_id AND eliminado = 0;
    
    SELECT 1 as resultado, 'Grado eliminado lógicamente correctamente' as mensaje;
END$$

--
-- Procedure: `actualizar_nota`
--

DROP PROCEDURE IF EXISTS `actualizar_nota`$$
CREATE PROCEDURE `actualizar_nota`(
    IN p_id INT,
    IN p_tarea_id INT,
    IN p_alumno_id INT,
    IN p_nota DECIMAL(5,2),
    IN p_observaciones TEXT
)
BEGIN
    UPDATE nota 
    SET tarea_id = p_tarea_id,
        alumno_id = p_alumno_id,
        nota = p_nota,
        observaciones = p_observaciones
    WHERE id = p_id AND eliminado = 0;
    
    SELECT 1 as resultado, 'Nota actualizada correctamente' as mensaje;
END$$

--
-- Procedure: `eliminar_logico_nota`
--

DROP PROCEDURE IF EXISTS `eliminar_logico_nota`$$
CREATE PROCEDURE `eliminar_logico_nota`(
    IN p_id INT
)
BEGIN
    UPDATE nota 
    SET eliminado = 1,
        activo = 0
    WHERE id = p_id AND eliminado = 0;
    
    SELECT 1 as resultado, 'Nota eliminada lógicamente correctamente' as mensaje;
END$$

--
-- Procedure: `actualizar_observacion`
--

DROP PROCEDURE IF EXISTS `actualizar_observacion`$$
CREATE PROCEDURE `actualizar_observacion`(
    IN p_id INT,
    IN p_alumno_id INT,
    IN p_texto TEXT,
    IN p_curso_id INT,
    IN p_tipo VARCHAR(20)
)
BEGIN
    UPDATE observacion 
    SET alumno_id = p_alumno_id,
        texto = p_texto,
        curso_id = p_curso_id,
        tipo = p_tipo
    WHERE id = p_id AND eliminado = 0;
    
    SELECT 1 as resultado, 'Observación actualizada correctamente' as mensaje;
END$$

--
-- Procedure: `eliminar_logico_observacion`
--

DROP PROCEDURE IF EXISTS `eliminar_logico_observacion`$$
CREATE PROCEDURE `eliminar_logico_observacion`(
    IN p_id INT
)
BEGIN
    UPDATE observacion 
    SET eliminado = 1,
        activo = 0
    WHERE id = p_id AND eliminado = 0;
    
    SELECT 1 as resultado, 'Observación eliminada lógicamente correctamente' as mensaje;
END$$

--
-- Procedure: `actualizar_profesor`
--

DROP PROCEDURE IF EXISTS `actualizar_profesor`$$
CREATE PROCEDURE `actualizar_profesor`(
    IN p_id INT,
    IN p_nombres VARCHAR(100),
    IN p_apellidos VARCHAR(100),
    IN p_correo VARCHAR(100),
    IN p_especialidad VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_dni VARCHAR(20)
)
BEGIN
    DECLARE v_persona_id INT;
    
    -- Obtener el persona_id del profesor
    SELECT persona_id INTO v_persona_id FROM profesor WHERE id = p_id AND eliminado = 0;
    
    IF v_persona_id IS NOT NULL THEN
        -- Actualizar la persona
        UPDATE persona 
        SET nombres = p_nombres,
            apellidos = p_apellidos,
            correo = p_correo,
            telefono = p_telefono,
            dni = p_dni
        WHERE id = v_persona_id AND eliminado = 0;
        
        -- Actualizar el profesor
        UPDATE profesor 
        SET especialidad = p_especialidad
        WHERE id = p_id AND eliminado = 0;
        
        SELECT 1 as resultado, 'Profesor actualizado correctamente' as mensaje;
    ELSE
        SELECT 0 as resultado, 'Profesor no encontrado' as mensaje;
    END IF;
END$$

--
-- Procedure: `eliminar_logico_profesor`
--

DROP PROCEDURE IF EXISTS `eliminar_logico_profesor`$$
CREATE PROCEDURE `eliminar_logico_profesor`(
    IN p_id INT
)
BEGIN
    DECLARE v_persona_id INT;
    
    -- Obtener el persona_id del profesor
    SELECT persona_id INTO v_persona_id FROM profesor WHERE id = p_id AND eliminado = 0;
    
    IF v_persona_id IS NOT NULL THEN
        -- Eliminar lógicamente el profesor
        UPDATE profesor 
        SET eliminado = 1,
            activo = 0,
            estado = 'INACTIVO'
        WHERE id = p_id;
        
        -- Eliminar lógicamente la persona
        UPDATE persona 
        SET eliminado = 1,
            activo = 0
        WHERE id = v_persona_id;
        
        -- Eliminar lógicamente el usuario asociado
        UPDATE usuario 
        SET eliminado = 1,
            activo = 0
        WHERE persona_id = v_persona_id;
        
        SELECT 1 as resultado, 'Profesor eliminado lógicamente correctamente' as mensaje;
    ELSE
        SELECT 0 as resultado, 'Profesor no encontrado' as mensaje;
    END IF;
END$$

--
-- Procedure: `actualizar_tarea`
--

DROP PROCEDURE IF EXISTS `actualizar_tarea`$$
CREATE PROCEDURE `actualizar_tarea`(
    IN p_id INT,
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT,
    IN p_fecha_entrega DATE,
    IN p_activo BOOLEAN,
    IN p_curso_id INT,
    IN p_tipo VARCHAR(20),
    IN p_peso DECIMAL(5,2),
    IN p_instrucciones TEXT
)
BEGIN
    UPDATE tarea 
    SET nombre = p_nombre,
        descripcion = p_descripcion,
        fecha_entrega = p_fecha_entrega,
        activo = p_activo,
        curso_id = p_curso_id,
        tipo = p_tipo,
        peso = p_peso,
        instrucciones = p_instrucciones
    WHERE id = p_id AND eliminado = 0;
    
    SELECT 1 as resultado, 'Tarea actualizada correctamente' as mensaje;
END$$

--
-- Procedure: `eliminar_logico_tarea`
--

DROP PROCEDURE IF EXISTS `eliminar_logico_tarea`$$
CREATE PROCEDURE `eliminar_logico_tarea`(
    IN p_id INT
)
BEGIN
    UPDATE tarea 
    SET eliminado = 1,
        activo = 0
    WHERE id = p_id AND eliminado = 0;
    
    SELECT 1 as resultado, 'Tarea eliminada lógicamente correctamente' as mensaje;
END$$

--
-- Procedure: `actualizar_usuario`
--

DROP PROCEDURE IF EXISTS `actualizar_usuario`$$
CREATE PROCEDURE `actualizar_usuario`(
    IN p_id INT,
    IN p_username VARCHAR(50),
    IN p_password VARCHAR(100),
    IN p_rol VARCHAR(20)
)
BEGIN
    UPDATE usuario 
    SET username = p_username,
        password = p_password,
        rol = p_rol
    WHERE id = p_id AND eliminado = 0;
    
    SELECT 1 as resultado, 'Usuario actualizado correctamente' as mensaje;
END$$

--
-- Procedure: `eliminar_logico_usuario`
--

DROP PROCEDURE IF EXISTS `eliminar_logico_usuario`$$
CREATE PROCEDURE `eliminar_logico_usuario`(
    IN p_id INT
)
BEGIN
    UPDATE usuario 
    SET eliminado = 1,
        activo = 0
    WHERE id = p_id AND eliminado = 0;
    
    SELECT 1 as resultado, 'Usuario eliminado lógicamente correctamente' as mensaje;
END$$

DELIMITER ;

-- ------------------------------------------------------
-- TRIGGERS para eliminación lógica
-- ------------------------------------------------------

DELIMITER $$

--
-- Trigger: `before_delete_persona`
--

DROP TRIGGER IF EXISTS `before_delete_persona`$$
CREATE TRIGGER `before_delete_persona`
BEFORE DELETE ON `persona`
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No se permite eliminación física. Use eliminación lógica.';
END$$

--
-- Trigger: `before_delete_alumno`
--

DROP TRIGGER IF EXISTS `before_delete_alumno`$$
CREATE TRIGGER `before_delete_alumno`
BEFORE DELETE ON `alumno`
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No se permite eliminación física. Use eliminación lógica.';
END$$

--
-- Trigger: `before_delete_profesor`
--

DROP TRIGGER IF EXISTS `before_delete_profesor`$$
CREATE TRIGGER `before_delete_profesor`
BEFORE DELETE ON `profesor`
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No se permite eliminación física. Use eliminación lógica.';
END$$

--
-- Trigger: `before_delete_curso`
--

DROP TRIGGER IF EXISTS `before_delete_curso`$$
CREATE TRIGGER `before_delete_curso`
BEFORE DELETE ON `curso`
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No se permite eliminación física. Use eliminación lógica.';
END$$

--
-- Trigger: `before_delete_usuario`
--

DROP TRIGGER IF EXISTS `before_delete_usuario`$$
CREATE TRIGGER `before_delete_usuario`
BEFORE DELETE ON `usuario`
FOR EACH ROW
BEGIN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'No se permite eliminación física. Use eliminación lógica.';
END$$

DELIMITER ;
DELIMITER $$

-- Crear justificación
DROP PROCEDURE IF EXISTS `crear_justificacion`$$
CREATE PROCEDURE `crear_justificacion`(
    IN p_asistencia_id INT,
    IN p_tipo_justificacion VARCHAR(50),
    IN p_descripcion TEXT,
    IN p_documento_adjunto VARCHAR(255),
    IN p_justificado_por INT
)
BEGIN
    INSERT INTO justificacion (
        asistencia_id,
        tipo_justificacion,
        descripcion,
        documento_adjunto,
        justificado_por,
        fecha_justificacion,
        estado,
        activo,
        eliminado
    ) VALUES (
        p_asistencia_id,
        p_tipo_justificacion,
        p_descripcion,
        p_documento_adjunto,
        p_justificado_por,
        NOW(),
        'PENDIENTE',
        1,
        0
    );
    
    SELECT LAST_INSERT_ID() as id;
END$$

-- Obtener justificaciones pendientes
DROP PROCEDURE IF EXISTS `obtener_justificaciones_pendientes`$$
CREATE PROCEDURE `obtener_justificaciones_pendientes`()
BEGIN
    SELECT 
        j.id,
        j.asistencia_id,
        j.tipo_justificacion,
        j.descripcion,
        j.documento_adjunto,
        j.justificado_por,
        j.fecha_justificacion,
        j.estado,
        j.aprobado_por,
        j.fecha_aprobacion,
        j.observaciones_aprobacion,
        j.activo,
        CONCAT(p_alumno.nombres, ' ', p_alumno.apellidos) as alumno_nombre,
        c.nombre as curso_nombre,
        DATE_FORMAT(a.fecha, '%d/%m/%Y') as fecha,
        TIME_FORMAT(a.hora_clase, '%H:%i') as hora_clase,
        CONCAT(p_padre.nombres, ' ', p_padre.apellidos) as padre_nombre
    FROM justificacion j
    INNER JOIN asistencia a ON j.asistencia_id = a.id
    INNER JOIN alumno al ON a.alumno_id = al.id
    INNER JOIN persona p_alumno ON al.persona_id = p_alumno.id
    INNER JOIN curso c ON a.curso_id = c.id
    LEFT JOIN persona p_padre ON j.justificado_por = p_padre.id
    WHERE j.estado = 'PENDIENTE'
    AND j.eliminado = 0
    AND j.activo = 1
    ORDER BY j.fecha_justificacion DESC;
END$$

-- Obtener justificaciones por alumno
DROP PROCEDURE IF EXISTS `obtener_justificaciones_por_alumno`$$
CREATE PROCEDURE `obtener_justificaciones_por_alumno`(
    IN p_alumno_id INT
)
BEGIN
    SELECT 
        j.id,
        j.asistencia_id,
        j.tipo_justificacion,
        j.descripcion,
        j.documento_adjunto,
        j.justificado_por,
        j.fecha_justificacion,
        j.estado,
        j.aprobado_por,
        j.fecha_aprobacion,
        j.observaciones_aprobacion,
        j.activo,
        c.nombre as curso_nombre,
        DATE_FORMAT(a.fecha, '%d/%m/%Y') as fecha,
        TIME_FORMAT(a.hora_clase, '%H:%i') as hora_clase,
        CONCAT(p_padre.nombres, ' ', p_padre.apellidos) as padre_nombre
    FROM justificacion j
    INNER JOIN asistencia a ON j.asistencia_id = a.id
    INNER JOIN curso c ON a.curso_id = c.id
    LEFT JOIN persona p_padre ON j.justificado_por = p_padre.id
    WHERE a.alumno_id = p_alumno_id
    AND j.eliminado = 0
    AND j.activo = 1
    ORDER BY j.fecha_justificacion DESC;
END$$

-- Aprobar justificación
DROP PROCEDURE IF EXISTS `aprobar_justificacion`$$
CREATE PROCEDURE `aprobar_justificacion`(
    IN p_justificacion_id INT,
    IN p_aprobado_por INT,
    IN p_observaciones TEXT
)
BEGIN
    DECLARE v_asistencia_id INT;
    
    -- Actualizar la justificación
    UPDATE justificacion
    SET estado = 'APROBADO',
        aprobado_por = p_aprobado_por,
        fecha_aprobacion = NOW(),
        observaciones_aprobacion = p_observaciones
    WHERE id = p_justificacion_id
    AND eliminado = 0;
    
    -- Obtener el ID de asistencia
    SELECT asistencia_id INTO v_asistencia_id
    FROM justificacion
    WHERE id = p_justificacion_id;
    
    -- Actualizar el estado de la asistencia a JUSTIFICADO
    UPDATE asistencia
    SET estado = 'JUSTIFICADO'
    WHERE id = v_asistencia_id
    AND eliminado = 0;
    
    SELECT 1 as resultado, 'Justificación aprobada correctamente' as mensaje;
END$$

-- Rechazar justificación
DROP PROCEDURE IF EXISTS `rechazar_justificacion`$$
CREATE PROCEDURE `rechazar_justificacion`(
    IN p_justificacion_id INT,
    IN p_aprobado_por INT,
    IN p_observaciones TEXT
)
BEGIN
    UPDATE justificacion
    SET estado = 'RECHAZADO',
        aprobado_por = p_aprobado_por,
        fecha_aprobacion = NOW(),
        observaciones_aprobacion = p_observaciones
    WHERE id = p_justificacion_id
    AND eliminado = 0;
    
    SELECT 1 as resultado, 'Justificación rechazada' as mensaje;
END$$

DELIMITER ;
-- ------------------------------------------------------
-- VISTAS para consultas frecuentes
-- ------------------------------------------------------

CREATE VIEW `vista_alumnos_activos` AS
SELECT 
    a.id,
    a.codigo_alumno,
    p.nombres,
    p.apellidos,
    p.correo,
    p.telefono,
    p.dni,
    p.fecha_nacimiento,
    g.nombre as grado_nombre,
    g.nivel,
    a.fecha_ingreso,
    a.estado
FROM alumno a
JOIN persona p ON a.persona_id = p.id
JOIN grado g ON a.grado_id = g.id
WHERE a.eliminado = 0
AND a.activo = 1
AND p.eliminado = 0
AND p.activo = 1;

CREATE VIEW `vista_profesores_activos` AS
SELECT 
    prof.id,
    prof.codigo_profesor,
    p.nombres,
    p.apellidos,
    p.correo,
    p.telefono,
    p.dni,
    prof.especialidad,
    prof.fecha_contratacion,
    prof.estado,
    u.username,
    u.rol
FROM profesor prof
JOIN persona p ON prof.persona_id = p.id
JOIN usuario u ON p.id = u.persona_id
WHERE prof.eliminado = 0
AND prof.activo = 1
AND p.eliminado = 0
AND p.activo = 1
AND u.activo = 1;

CREATE VIEW `vista_cursos_activos` AS
SELECT 
    c.id,
    c.nombre,
    c.creditos,
    c.horas_semanales,
    c.area,
    c.ciclo,
    c.fecha_inicio,
    c.fecha_fin,
    g.nombre as grado_nombre,
    g.nivel,
    CONCAT(p.nombres, ' ', p.apellidos) as profesor_principal,
    COUNT(DISTINCT cp.profesor_id) as total_profesores,
    COUNT(DISTINCT h.id) as total_horarios
FROM curso c
JOIN grado g ON c.grado_id = g.id
LEFT JOIN profesor prof ON c.profesor_id = prof.id
LEFT JOIN persona p ON prof.persona_id = p.id
LEFT JOIN curso_profesor cp ON c.id = cp.curso_id AND cp.eliminado = 0
LEFT JOIN horario_clase h ON c.id = h.curso_id AND h.eliminado = 0
WHERE c.eliminado = 0
AND c.activo = 1
GROUP BY c.id, c.nombre, c.creditos, c.horas_semanales, c.area, c.ciclo,
         c.fecha_inicio, c.fecha_fin, g.nombre, g.nivel, profesor_principal;

CREATE VIEW `vista_horarios_clase` AS
SELECT 
    h.id,
    h.curso_id,
    c.nombre as curso_nombre,
    h.turno_id,
    t.nombre as turno_nombre,
    h.dia_semana,
    h.hora_inicio,
    h.hora_fin,
    h.aula_id,
    a.nombre as aula_nombre,
    s.nombre as sede_nombre,
    h.profesor_id,
    CONCAT(p.nombres, ' ', p.apellidos) as profesor_nombre,
    g.nombre as grado_nombre,
    g.nivel
FROM horario_clase h
JOIN curso c ON h.curso_id = c.id
JOIN turno t ON h.turno_id = t.id
JOIN aula a ON h.aula_id = a.id
JOIN sede s ON a.sede_id = s.id
JOIN profesor prof ON h.profesor_id = prof.id
JOIN persona p ON prof.persona_id = p.id
JOIN grado g ON c.grado_id = g.id
WHERE h.eliminado = 0
AND h.activo = 1
AND c.eliminado = 0
AND c.activo = 1;

CREATE VIEW `vista_asistencias_diarias` AS
SELECT 
    a.id,
    a.fecha,
    a.hora_clase,
    a.estado,
    al.codigo_alumno,
    CONCAT(p.nombres, ' ', p.apellidos) as alumno_nombre,
    c.nombre as curso_nombre,
    t.nombre as turno_nombre,
    g.nombre as grado_nombre,
    a.observaciones,
    a.registrado_por,
    a.fecha_registro
FROM asistencia a
JOIN alumno al ON a.alumno_id = al.id
JOIN persona p ON al.persona_id = p.id
JOIN curso c ON a.curso_id = c.id
JOIN turno t ON a.turno_id = t.id
JOIN grado g ON al.grado_id = g.id
WHERE a.eliminado = 0
AND a.activo = 1
AND al.eliminado = 0
AND al.activo = 1
AND p.eliminado = 0
AND p.activo = 1;

-- ------------------------------------------------------
-- ÍNDICES para optimización
-- ------------------------------------------------------

CREATE INDEX `idx_persona_dni` ON `persona` (`dni`);
CREATE INDEX `idx_persona_nombres_apellidos` ON `persona` (`nombres`, `apellidos`);
CREATE INDEX `idx_alumno_codigo` ON `alumno` (`codigo_alumno`);
CREATE INDEX `idx_profesor_codigo` ON `profesor` (`codigo_profesor`);
CREATE INDEX `idx_curso_nombre` ON `curso` (`nombre`);
CREATE INDEX `idx_horario_curso_dia` ON `horario_clase` (`curso_id`, `dia_semana`);
CREATE INDEX `idx_asistencia_fecha_curso` ON `asistencia` (`fecha`, `curso_id`);
CREATE INDEX `idx_disponibilidad_profesor_dia` ON `disponibilidad_profesor` (`profesor_id`, `dia_semana`);
CREATE INDEX `idx_curso_profesor_curso` ON `curso_profesor` (`curso_id`, `profesor_id`);

-- ------------------------------------------------------
-- FIN DEL SCRIPT
-- ------------------------------------------------------

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;