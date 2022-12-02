/*
SQLyog Ultimate v11.11 (32 bit)
MySQL - 5.5.5-10.6.5-MariaDB : Database - taller
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`taller` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `taller`;

/*Table structure for table `ajustes` */

DROP TABLE IF EXISTS `ajustes`;

CREATE TABLE `ajustes` (
  `id_ajuste` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(30) DEFAULT NULL,
  `f_nro` int(11) DEFAULT NULL,
  `codigo` varchar(30) DEFAULT NULL,
  `lote` varchar(30) DEFAULT NULL,
  `tipo` varchar(60) DEFAULT NULL,
  `signo` varchar(2) DEFAULT NULL,
  `inicial` decimal(16,2) DEFAULT NULL,
  `ajuste` decimal(16,2) DEFAULT NULL,
  `final` decimal(16,2) DEFAULT NULL,
  `p_costo` decimal(16,2) DEFAULT NULL,
  `motivo` varchar(100) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` varchar(12) DEFAULT NULL,
  `um` varchar(10) DEFAULT NULL,
  `estado` varchar(10) DEFAULT NULL,
  `verificado_por` varchar(30) DEFAULT NULL,
  `verif_hora` datetime DEFAULT NULL,
  `valor_ajuste` decimal(16,2) DEFAULT NULL,
  `suc` varchar(10) DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id_ajuste`),
  KEY `Ref611` (`usuario`),
  KEY `Ref1018` (`um`),
  KEY `Ref352` (`f_nro`),
  CONSTRAINT `Refunidades_medida18` FOREIGN KEY (`um`) REFERENCES `unidades_medida` (`um_cod`),
  CONSTRAINT `Refusuarios11` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `ajustes` */

/*Table structure for table `art_images` */

DROP TABLE IF EXISTS `art_images`;

CREATE TABLE `art_images` (
  `id_img` int(11) NOT NULL,
  `codigo` varchar(30) NOT NULL,
  `url` varchar(200) DEFAULT NULL,
  `principal` varchar(2) DEFAULT NULL,
  PRIMARY KEY (`id_img`,`codigo`),
  KEY `Index_art_images` (`codigo`),
  CONSTRAINT `Refarticulos250` FOREIGN KEY (`codigo`) REFERENCES `articulos` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `art_images` */

insert  into `art_images`(`id_img`,`codigo`,`url`,`principal`) values (0,'IN0001','img/articulos/IN0001/0.jpg','Si'),(0,'IN0002','img/articulos/IN0002/0.jpg','Si'),(0,'IN0003','img/articulos/IN0003/0.jpg','Si'),(0,'IN0006','img/articulos/IN0006/0.jpg','Si'),(0,'SR001','img/articulos/SR001/0.jpg','No'),(0,'SR003','img/articulos/SR003/0.jpg','Si'),(1,'SR001','img/articulos/SR001/1.jpg','No'),(2,'SR001','img/articulos/SR001/2.jpg','Si');

/*Table structure for table `art_propiedades` */

DROP TABLE IF EXISTS `art_propiedades`;

CREATE TABLE `art_propiedades` (
  `cod_prop` varchar(30) NOT NULL,
  `descrip` varchar(120) NOT NULL,
  `tipo` varchar(20) DEFAULT NULL,
  `valor_def` varchar(60) DEFAULT NULL,
  `estado` varchar(30) NOT NULL,
  PRIMARY KEY (`cod_prop`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `art_propiedades` */

insert  into `art_propiedades`(`cod_prop`,`descrip`,`tipo`,`valor_def`,`estado`) values ('1','Completar',NULL,'Si,No','Activo'),('2','Completar',NULL,'Si,No','Activo'),('3','Completar',NULL,'Si,No','Activo'),('4','Completar',NULL,'Si,No','Activo'),('5','Completar',NULL,'Si,No','Activo');

/*Table structure for table `art_x_uso` */

DROP TABLE IF EXISTS `art_x_uso`;

CREATE TABLE `art_x_uso` (
  `cod_uso` int(11) NOT NULL,
  `codigo` varchar(30) NOT NULL,
  PRIMARY KEY (`cod_uso`,`codigo`),
  KEY `Ref120203` (`cod_uso`),
  KEY `Ref119204` (`codigo`),
  CONSTRAINT `Refarticulos204` FOREIGN KEY (`codigo`) REFERENCES `articulos` (`codigo`),
  CONSTRAINT `Refusos203` FOREIGN KEY (`cod_uso`) REFERENCES `usos` (`cod_uso`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `art_x_uso` */

/*Table structure for table `articulos` */

DROP TABLE IF EXISTS `articulos`;

CREATE TABLE `articulos` (
  `codigo` varchar(30) NOT NULL,
  `clase` varchar(16) DEFAULT NULL,
  `descrip` varchar(100) NOT NULL,
  `cod_sector` int(11) NOT NULL,
  `um` varchar(10) NOT NULL,
  `costo_prom` decimal(16,2) DEFAULT NULL,
  `costo_cif` decimal(16,2) DEFAULT NULL,
  `costo_fob` decimal(16,2) DEFAULT NULL,
  `art_venta` varchar(6) DEFAULT NULL,
  `art_inv` varchar(6) DEFAULT NULL,
  `art_compra` varchar(6) DEFAULT NULL,
  `img` varchar(100) DEFAULT NULL,
  `estado_venta` varchar(30) DEFAULT NULL,
  `composicion` varchar(30) DEFAULT NULL,
  `temporada` varchar(30) DEFAULT NULL,
  `ligamento` varchar(30) DEFAULT NULL,
  `combinacion` varchar(30) DEFAULT NULL,
  `especificaciones` varchar(1024) DEFAULT NULL,
  `acabado` varchar(30) DEFAULT NULL,
  `tipo` varchar(30) DEFAULT NULL,
  `estetica` varchar(30) DEFAULT NULL,
  `ancho` decimal(16,2) DEFAULT NULL,
  `espesor` decimal(16,4) DEFAULT NULL,
  `gramaje_prom` decimal(16,2) DEFAULT NULL,
  `rendimiento` decimal(16,2) DEFAULT NULL,
  `produc_ancho` decimal(10,2) DEFAULT NULL,
  `produc_largo` decimal(10,2) DEFAULT NULL,
  `produc_alto` decimal(10,2) DEFAULT NULL,
  `produc_costo` decimal(16,2) DEFAULT NULL,
  `mnj_x_lotes` varchar(2) DEFAULT NULL,
  `estado` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`codigo`),
  KEY `Ref123202` (`cod_sector`),
  KEY `Ref10208` (`um`),
  CONSTRAINT `Refsectores202` FOREIGN KEY (`cod_sector`) REFERENCES `sectores` (`cod_sector`),
  CONSTRAINT `Refunidades_medida208` FOREIGN KEY (`um`) REFERENCES `unidades_medida` (`um_cod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `articulos` */

insert  into `articulos`(`codigo`,`clase`,`descrip`,`cod_sector`,`um`,`costo_prom`,`costo_cif`,`costo_fob`,`art_venta`,`art_inv`,`art_compra`,`img`,`estado_venta`,`composicion`,`temporada`,`ligamento`,`combinacion`,`especificaciones`,`acabado`,`tipo`,`estetica`,`ancho`,`espesor`,`gramaje_prom`,`rendimiento`,`produc_ancho`,`produc_largo`,`produc_alto`,`produc_costo`,`mnj_x_lotes`,`estado`) values ('IN0001','Articulo','ACEITE 20-50 BARDHAL',102,'Unid',24000.00,25000.00,NULL,'true','true','true','','Normal','','Oto-Inv','','','','Mate','Punto','Liso',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'No','Activo'),('IN0002','Articulo','ACEITE 40 REPSOL',102,'Unid',56800.00,25000.00,NULL,'true','true','true','img/articulos/IN0002/0.jpg','Normal','','Oto-Inv','','','','Mate','Punto','Liso',0.00,0.0000,0.00,0.00,0.00,0.00,0.00,NULL,'No','Activo'),('IN0003','Articulo','Leichtlauf High Tech 5W-40 5Lts',102,'Unid',25000.00,25000.00,NULL,'true','true','true','','Normal','','Oto-Inv','','','','Mate','Punto','Liso',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'No','Activo'),('IN0004','Articulo','Super Leichtlauf 10W-40 1Lt',102,'Unid',25000.00,25000.00,NULL,'true','true','true','','Normal','','Oto-Inv','','','','Mate','Punto','Liso',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'No','Activo'),('IN0005','Articulo','Gulf Super Duty MP 40 12X1 Lts.',102,'Unid',25000.00,25000.00,NULL,'true','true','true','','Normal','','Oto-Inv','','','','Mate','Punto','Liso',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'No','Activo'),('IN0006','Articulo','Gulf Formula ULE 5W30 1 Lts.',102,'Unid',25000.00,25000.00,NULL,'true','true','true','','Normal','','Oto-Inv','','','','Mate','Punto','Liso',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'No','Activo'),('SR001','Trabajo','Mano Obra',101,'Unid',25000.00,25000.00,NULL,'true','false','false','img/articulos/SR001/2.jpg','Normal','','Perm','','','','Mate','Punto','Liso',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'No','Activo'),('SR003','Articulo','Trabajo de Torneria',101,'Unid',25000.00,25000.00,NULL,'true','false','false','img/articulos/SR003/0.jpg','Normal','','Oto-Inv','','','','Mate','Punto','Liso',0.00,0.0000,0.00,0.00,NULL,NULL,NULL,NULL,'No','Activo');

/*Table structure for table `articulos_x_temp` */

DROP TABLE IF EXISTS `articulos_x_temp`;

CREATE TABLE `articulos_x_temp` (
  `suc` varchar(10) NOT NULL,
  `temporada` int(11) NOT NULL,
  `estante` varchar(30) NOT NULL,
  `codigo` varchar(30) NOT NULL,
  `fila` int(11) NOT NULL,
  `col` int(11) NOT NULL,
  `um` varchar(10) DEFAULT NULL,
  `capacidad` decimal(16,2) DEFAULT NULL,
  `piezas` int(11) DEFAULT NULL,
  `usuario` varchar(20) DEFAULT NULL,
  `fecha` datetime DEFAULT NULL,
  PRIMARY KEY (`suc`,`temporada`,`estante`,`codigo`,`fila`,`col`),
  KEY `Ref119235` (`codigo`),
  KEY `Ref118292` (`temporada`,`suc`,`estante`),
  CONSTRAINT `Refarticulos235` FOREIGN KEY (`codigo`) REFERENCES `articulos` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `articulos_x_temp` */

/*Table structure for table `asientos` */

DROP TABLE IF EXISTS `asientos`;

CREATE TABLE `asientos` (
  `id_asiento` int(11) NOT NULL AUTO_INCREMENT,
  `fecha_reg` date NOT NULL,
  `fecha_contab` date NOT NULL,
  `fecha_doc` date DEFAULT NULL,
  `codigo_cc` int(11) NOT NULL,
  `suc` varchar(10) NOT NULL,
  `folio_num` varchar(30) DEFAULT NULL,
  `usuario` varchar(30) NOT NULL,
  `descrip` varchar(254) DEFAULT NULL,
  `memo` varchar(200) DEFAULT NULL,
  `origen` varchar(10) DEFAULT NULL,
  `nro_origen` int(11) DEFAULT NULL,
  `declarable` varchar(2) DEFAULT NULL,
  `estado` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`id_asiento`),
  KEY `Ref6239` (`usuario`),
  KEY `Ref18300` (`suc`),
  KEY `Ref153303` (`codigo_cc`),
  CONSTRAINT `Refcentro_costos303` FOREIGN KEY (`codigo_cc`) REFERENCES `centro_costos` (`codigo_cc`),
  CONSTRAINT `Refsucursales300` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`),
  CONSTRAINT `Refusuarios239` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `asientos` */

/*Table structure for table `asientos_det` */

DROP TABLE IF EXISTS `asientos_det`;

CREATE TABLE `asientos_det` (
  `id_asiento` int(11) NOT NULL,
  `linea` int(11) NOT NULL,
  `cuenta` varchar(30) NOT NULL,
  `nombre_cuenta` varchar(30) DEFAULT NULL,
  `suc` varchar(10) NOT NULL,
  `codigo_cc` int(11) NOT NULL,
  `debe` decimal(16,2) DEFAULT NULL,
  `haber` decimal(16,2) DEFAULT NULL,
  `cotiz` decimal(16,6) DEFAULT NULL,
  `debeMS` decimal(16,2) DEFAULT NULL,
  `haberMS` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`id_asiento`,`linea`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `asientos_det` */

/*Table structure for table `asistencias` */

DROP TABLE IF EXISTS `asistencias`;

CREATE TABLE `asistencias` (
  `id_asist` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(30) NOT NULL,
  `fecha_hora` datetime NOT NULL,
  `suc` varchar(10) NOT NULL,
  PRIMARY KEY (`id_asist`),
  KEY `Ref6240` (`usuario`),
  KEY `Ref18241` (`suc`),
  CONSTRAINT `Refsucursales241` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`),
  CONSTRAINT `Refusuarios240` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `asistencias` */

/*Table structure for table `aux_recep` */

DROP TABLE IF EXISTS `aux_recep`;

CREATE TABLE `aux_recep` (
  `id_part` int(11) NOT NULL,
  `descrip` varchar(100) DEFAULT NULL,
  `tipo_dato` varchar(30) DEFAULT NULL,
  `opciones` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id_part`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `aux_recep` */

insert  into `aux_recep`(`id_part`,`descrip`,`tipo_dato`,`opciones`) values (1,'Espejo Izq.','select','Normal,Roto,Raspon'),(2,'Espejo Der.','select','Normal,Roto,Raspon'),(3,'Parabrisas Izq. Del.','boolean','Si,No'),(4,'Parabrisas Der. Tra.','boolean','Si,No'),(5,'Parabrisas Der. Del.','boolean','Si,No'),(6,'Parabrisas Izq. Tra.','boolean','Si,No'),(7,'Parabrisas Delantero','select','Normal,Roto,Raspon'),(8,'Parabrisas Trasero','select','Normal,Roto,Raspon'),(9,'Faros Delantero Izq. ','select','Normal,Roto,Raspon'),(10,'Faros Delantero Der. ','select','Normal,Roto,Raspon'),(11,'Faros Trasero Izq.','select','Normal,Roto,Raspon'),(12,'Faros Trasero Der.','select','Normal,Roto,Raspon'),(13,'Paragolpe Delantero','select','Normal,Roto,Raspon,Abollado'),(14,'Paragolpe Trasero','select','Normal,Roto,Raspon,Abollado'),(15,'Llanta Delantera Izq.','select','Normal,Roto,Raspon'),(16,'Llanta Delantera Der.','select','Normal,Roto,Raspon'),(17,'Llanta Trasera Izq.','select','Normal,Roto,Raspon'),(18,'Llanta Trasera Der.','select','Normal,Roto,Raspon'),(19,'Perilla para abrir Capo','boolean','Si,No'),(20,'Capo','select','Normal,Roto,Raspon'),(21,'Techo','select','Normal,Roto,Raspon'),(22,'Techo Solar','select','Normal,Roto,Raspon,N/A'),(23,'A/C','select','Normal,Averiado'),(24,'Maletero','select','Normal,Abollado'),(25,'Radio/Stereo','boolean','Si,No'),(26,'Pantalla','boolean','Si,No'),(27,'Encendedor','boolean','Si,No'),(28,'Kit de Primeros Auxilios','boolean','Si,No'),(29,'Cinturon de Seguridad','boolean','Si,No'),(30,'Velocimetro','select','Normal,Averiado'),(31,'Antena','boolean','Si,No'),(32,'Balizas','boolean','Si,No'),(33,'Gato','boolean','Si,No'),(34,'Llave Rueda','boolean','Si,No'),(35,'Extintor','boolean','Si,No'),(36,'Rueda Auxilio','boolean','Si,No');

/*Table structure for table `bancos` */

DROP TABLE IF EXISTS `bancos`;

CREATE TABLE `bancos` (
  `id_banco` varchar(4) NOT NULL,
  `nombre` varchar(30) NOT NULL,
  `direccion` varchar(60) DEFAULT NULL,
  `tel` varchar(30) DEFAULT NULL,
  `contacto` varchar(30) DEFAULT NULL,
  `mail` varchar(30) DEFAULT NULL,
  `web` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_banco`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `bancos` */

insert  into `bancos`(`id_banco`,`nombre`,`direccion`,`tel`,`contacto`,`mail`,`web`) values ('001','Banco Continental',NULL,NULL,NULL,NULL,NULL),('002','Banco Regional',NULL,NULL,NULL,NULL,NULL),('003','Banco Itapua',NULL,NULL,NULL,NULL,NULL),('004','Banco Familiar',NULL,NULL,NULL,NULL,NULL),('005','Banco Itau',NULL,NULL,NULL,NULL,NULL),('006','Banco GNB',NULL,NULL,NULL,NULL,NULL),('007','Banco Vision',NULL,NULL,NULL,NULL,NULL),('008','Banco BBVA',NULL,NULL,NULL,NULL,NULL),('009','Sudameris Bank',NULL,NULL,NULL,NULL,NULL),('010','Banco BASA',NULL,NULL,NULL,NULL,NULL),('011','Banco Atlas',NULL,NULL,NULL,NULL,NULL),('012','BNF',NULL,NULL,NULL,NULL,NULL),('013','Citibank',NULL,NULL,NULL,NULL,NULL),('014','Banco Nacion Argentina',NULL,NULL,NULL,NULL,NULL),('015','Bancop',NULL,NULL,NULL,NULL,NULL),('016','Interfisa',NULL,NULL,NULL,NULL,NULL),('017','El Comercio',NULL,NULL,NULL,NULL,NULL),('018','Banco Rio',NULL,NULL,NULL,NULL,NULL);

/*Table structure for table `bcos_ctas` */

DROP TABLE IF EXISTS `bcos_ctas`;

CREATE TABLE `bcos_ctas` (
  `id_banco` varchar(4) NOT NULL,
  `cuenta` varchar(30) NOT NULL,
  `cta_cont` varchar(30) NOT NULL,
  `nombre` varchar(60) DEFAULT NULL,
  `cod_swift` varchar(30) DEFAULT NULL,
  `tipo` varchar(30) DEFAULT NULL,
  `m_cod` varchar(4) NOT NULL,
  `estado` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_banco`,`cuenta`),
  KEY `Ref1729` (`id_banco`),
  KEY `Ref1530` (`m_cod`),
  KEY `Ref138251` (`cta_cont`),
  CONSTRAINT `Refbancos29` FOREIGN KEY (`id_banco`) REFERENCES `bancos` (`id_banco`),
  CONSTRAINT `Refmonedas30` FOREIGN KEY (`m_cod`) REFERENCES `monedas` (`m_cod`),
  CONSTRAINT `Refplan_cuentas251` FOREIGN KEY (`cta_cont`) REFERENCES `plan_cuentas` (`cuenta`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `bcos_ctas` */

/*Table structure for table `bcos_ctas_mov` */

DROP TABLE IF EXISTS `bcos_ctas_mov`;

CREATE TABLE `bcos_ctas_mov` (
  `id_mov` int(11) NOT NULL AUTO_INCREMENT,
  `id_banco` varchar(4) NOT NULL,
  `cuenta` varchar(30) NOT NULL,
  `nro_deposito` varchar(30) DEFAULT NULL,
  `trans_num` varchar(30) DEFAULT NULL,
  `fecha_reg` date DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` time DEFAULT NULL,
  `entrada` decimal(16,2) DEFAULT NULL,
  `salida` decimal(16,2) DEFAULT NULL,
  `suc` varchar(10) NOT NULL,
  `estado` varchar(30) DEFAULT NULL,
  `id_concepto` int(11) NOT NULL,
  `usuario` varchar(30) NOT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id_mov`,`id_banco`,`cuenta`),
  KEY `Ref2631` (`cuenta`,`id_banco`),
  KEY `Ref1832` (`suc`),
  KEY `Ref3450` (`id_concepto`),
  KEY `Ref6121` (`usuario`),
  KEY `Refbcos_ctas31` (`id_banco`,`cuenta`),
  CONSTRAINT `Refbcos_ctas31` FOREIGN KEY (`id_banco`, `cuenta`) REFERENCES `bcos_ctas` (`id_banco`, `cuenta`),
  CONSTRAINT `Refconceptos50` FOREIGN KEY (`id_concepto`) REFERENCES `conceptos` (`id_concepto`),
  CONSTRAINT `Refsucursales32` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`),
  CONSTRAINT `Refusuarios121` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `bcos_ctas_mov` */

/*Table structure for table `caja` */

DROP TABLE IF EXISTS `caja`;

CREATE TABLE `caja` (
  `id_caja` int(11) NOT NULL AUTO_INCREMENT,
  `tipo` varchar(16) DEFAULT NULL,
  `moneda` varchar(4) NOT NULL,
  `usuario` varchar(30) NOT NULL,
  `suc` varchar(10) NOT NULL,
  `estado` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id_caja`),
  KEY `Ref15258` (`moneda`),
  KEY `Ref6259` (`usuario`),
  KEY `Ref18260` (`suc`),
  CONSTRAINT `Refmonedas258` FOREIGN KEY (`moneda`) REFERENCES `monedas` (`m_cod`),
  CONSTRAINT `Refsucursales260` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`),
  CONSTRAINT `Refusuarios259` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `caja` */

/*Table structure for table `caja_mov` */

DROP TABLE IF EXISTS `caja_mov`;

CREATE TABLE `caja_mov` (
  `id_caja_det` int(11) NOT NULL AUTO_INCREMENT,
  `id_caja` int(11) NOT NULL,
  PRIMARY KEY (`id_caja_det`,`id_caja`),
  KEY `Ref147257` (`id_caja`),
  CONSTRAINT `Refcaja257` FOREIGN KEY (`id_caja`) REFERENCES `caja` (`id_caja`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `caja_mov` */

/*Table structure for table `catalogo_muestras` */

DROP TABLE IF EXISTS `catalogo_muestras`;

CREATE TABLE `catalogo_muestras` (
  `nro` int(11) NOT NULL,
  `suc` varchar(10) NOT NULL,
  `fceha` datetime NOT NULL,
  `cod_cli` varchar(10) DEFAULT NULL,
  `cliente` varchar(100) DEFAULT NULL,
  `cantidad` int(11) DEFAULT NULL,
  `fecha_entrega` datetime DEFAULT NULL,
  `codigo` varchar(10) DEFAULT NULL,
  `articulo` varchar(60) DEFAULT NULL,
  `medida` varchar(30) DEFAULT NULL,
  `fecha_inicio` datetime DEFAULT NULL,
  `usuarios` varchar(200) DEFAULT NULL,
  `fecha_cierre` datetime DEFAULT NULL,
  `entregado_a` varchar(30) DEFAULT NULL,
  `obs` varchar(254) DEFAULT NULL,
  `ubic` varchar(30) DEFAULT NULL,
  `estado` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`nro`,`suc`),
  KEY `Ref18160` (`suc`),
  CONSTRAINT `Refsucursales160` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `catalogo_muestras` */

/*Table structure for table `centro_costos` */

DROP TABLE IF EXISTS `centro_costos`;

CREATE TABLE `centro_costos` (
  `codigo_cc` int(11) NOT NULL,
  `nombre` varchar(100) DEFAULT NULL,
  `clasif` varchar(60) DEFAULT NULL,
  `usuario` varchar(30) NOT NULL,
  `estado` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`codigo_cc`),
  KEY `Ref6290` (`usuario`),
  CONSTRAINT `Refusuarios290` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `centro_costos` */

/*Table structure for table `cheques` */

DROP TABLE IF EXISTS `cheques`;

CREATE TABLE `cheques` (
  `id_banco` varchar(4) NOT NULL,
  `cuenta` varchar(30) NOT NULL,
  `nro_cheque` varchar(30) NOT NULL,
  `fecha_emis` date DEFAULT NULL,
  `fecha_pago` date DEFAULT NULL,
  `benef` varchar(60) DEFAULT NULL,
  `moneda` varchar(4) NOT NULL,
  `valor` decimal(16,2) DEFAULT NULL,
  `tipo` varchar(10) DEFAULT NULL,
  `compl` varchar(40) DEFAULT NULL,
  `mot_anul` varchar(50) DEFAULT NULL,
  `estado` varchar(12) DEFAULT NULL,
  `id_concepto` int(11) DEFAULT NULL,
  `suc` varchar(10) DEFAULT NULL,
  `fecha_impresion` datetime DEFAULT NULL,
  PRIMARY KEY (`id_banco`,`cuenta`,`nro_cheque`),
  KEY `Ref26230` (`cuenta`,`id_banco`),
  KEY `Ref15231` (`moneda`),
  KEY `Ref34232` (`id_concepto`),
  KEY `Ref18233` (`suc`),
  CONSTRAINT `Refbcos_ctas230` FOREIGN KEY (`id_banco`, `cuenta`) REFERENCES `bcos_ctas` (`id_banco`, `cuenta`),
  CONSTRAINT `Refconceptos232` FOREIGN KEY (`id_concepto`) REFERENCES `conceptos` (`id_concepto`),
  CONSTRAINT `Refmonedas231` FOREIGN KEY (`moneda`) REFERENCES `monedas` (`m_cod`),
  CONSTRAINT `Refsucursales233` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `cheques` */

/*Table structure for table `cheques_ter` */

DROP TABLE IF EXISTS `cheques_ter`;

CREATE TABLE `cheques_ter` (
  `id_cheque` int(11) NOT NULL AUTO_INCREMENT,
  `nro_cheque` varchar(30) NOT NULL,
  `id_banco` varchar(4) NOT NULL,
  `f_nro` int(11) DEFAULT NULL,
  `trans_num` varchar(30) DEFAULT NULL,
  `id_concepto` int(11) NOT NULL,
  `cuenta` varchar(30) DEFAULT NULL,
  `fecha_ins` date DEFAULT NULL,
  `fecha_emis` date DEFAULT NULL,
  `fecha_pago` date DEFAULT NULL,
  `benef` varchar(80) DEFAULT NULL,
  `suc` varchar(10) DEFAULT NULL,
  `valor` decimal(16,2) DEFAULT NULL,
  `m_cod` varchar(4) NOT NULL,
  `cotiz` decimal(8,2) DEFAULT NULL,
  `valor_ref` decimal(16,2) DEFAULT NULL,
  `motivo_anul` varchar(200) DEFAULT NULL,
  `estado` varchar(30) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` varchar(10) DEFAULT NULL,
  `tipo` varchar(10) DEFAULT 'Al Dia',
  `recibido_admin` varchar(4) DEFAULT NULL,
  `recibido_ger` varchar(4) DEFAULT NULL,
  `entrega` varchar(4) DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id_cheque`,`nro_cheque`,`id_banco`),
  KEY `Ref1717` (`id_banco`),
  KEY `Ref324` (`f_nro`),
  KEY `Ref1546` (`m_cod`),
  KEY `Ref3465` (`id_concepto`),
  CONSTRAINT `Refbancos17` FOREIGN KEY (`id_banco`) REFERENCES `bancos` (`id_banco`),
  CONSTRAINT `Refconceptos65` FOREIGN KEY (`id_concepto`) REFERENCES `conceptos` (`id_concepto`),
  CONSTRAINT `Reffactura_venta24` FOREIGN KEY (`f_nro`) REFERENCES `factura_venta` (`f_nro`),
  CONSTRAINT `Refmonedas46` FOREIGN KEY (`m_cod`) REFERENCES `monedas` (`m_cod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `cheques_ter` */

/*Table structure for table `clientes` */

DROP TABLE IF EXISTS `clientes`;

CREATE TABLE `clientes` (
  `cod_cli` varchar(30) NOT NULL,
  `cta_cont` varchar(30) NOT NULL,
  `tipo_doc` varchar(30) DEFAULT NULL,
  `ci_ruc` varchar(30) DEFAULT NULL,
  `nombre` varchar(60) DEFAULT NULL,
  `cat` int(11) DEFAULT NULL,
  `suc` varchar(10) NOT NULL,
  `moneda` varchar(4) DEFAULT NULL,
  `tel` varchar(30) DEFAULT NULL,
  `email` varchar(40) DEFAULT NULL,
  `fecha_nac` date DEFAULT NULL,
  `pais` varchar(30) DEFAULT NULL,
  `estado` varchar(30) DEFAULT NULL,
  `ciudad` varchar(30) DEFAULT NULL,
  `dir` varchar(60) DEFAULT NULL,
  `geoloc` varchar(120) DEFAULT NULL,
  `ocupacion` varchar(30) DEFAULT NULL,
  `situacion` varchar(30) DEFAULT NULL,
  `tipo` varchar(16) DEFAULT NULL,
  `usuario` varchar(30) DEFAULT NULL,
  `fecha_reg` varchar(20) DEFAULT NULL,
  `fecha_ins` varchar(20) DEFAULT NULL,
  `limite_credito` int(11) DEFAULT NULL,
  `plazo_maximo` int(11) DEFAULT NULL,
  `cant_cuotas` int(11) DEFAULT NULL,
  `cuotas_atrasadas` int(11) DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`cod_cli`),
  KEY `Ref18126` (`suc`),
  KEY `Ref138255` (`cta_cont`),
  KEY `Ref15266` (`moneda`),
  CONSTRAINT `Refmonedas266` FOREIGN KEY (`moneda`) REFERENCES `monedas` (`m_cod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `clientes` */

/*Table structure for table `codigos_barras` */

DROP TABLE IF EXISTS `codigos_barras`;

CREATE TABLE `codigos_barras` (
  `codigo` varchar(30) NOT NULL,
  `barcode` varchar(60) NOT NULL,
  PRIMARY KEY (`codigo`,`barcode`),
  KEY `Ref119309` (`codigo`),
  CONSTRAINT `Refarticulos309` FOREIGN KEY (`codigo`) REFERENCES `articulos` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `codigos_barras` */

/*Table structure for table `compra_det` */

DROP TABLE IF EXISTS `compra_det`;

CREATE TABLE `compra_det` (
  `id_det` int(11) NOT NULL AUTO_INCREMENT,
  `n_nro` int(11) NOT NULL,
  `cod_prov` varchar(10) NOT NULL,
  `codigo` varchar(30) DEFAULT NULL,
  `descrip` varchar(30) DEFAULT NULL,
  `um` varchar(10) NOT NULL,
  `cod_catalogo` varchar(30) DEFAULT NULL,
  `fab_color_cod` varchar(30) DEFAULT NULL,
  `precio` decimal(16,2) DEFAULT NULL,
  `cantidad` decimal(16,2) DEFAULT NULL,
  `subtotal` decimal(16,2) DEFAULT NULL,
  `color` varchar(30) DEFAULT NULL,
  `color_comb` varchar(40) DEFAULT NULL,
  `design` varchar(60) DEFAULT NULL,
  `composicion` varchar(30) DEFAULT NULL,
  `ancho` decimal(16,2) DEFAULT NULL,
  `gramaje` decimal(16,2) DEFAULT NULL,
  `cant_enviada` decimal(16,2) DEFAULT NULL,
  `id_res` int(11) DEFAULT NULL,
  `estado` varchar(30) DEFAULT NULL,
  `unique_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_det`,`n_nro`,`cod_prov`),
  KEY `Ref5997` (`n_nro`,`cod_prov`),
  KEY `Ref1098` (`um`),
  CONSTRAINT `Refcompras97` FOREIGN KEY (`n_nro`, `cod_prov`) REFERENCES `compras` (`n_nro`, `cod_prov`),
  CONSTRAINT `Refunidades_medida98` FOREIGN KEY (`um`) REFERENCES `unidades_medida` (`um_cod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `compra_det` */

/*Table structure for table `compras` */

DROP TABLE IF EXISTS `compras`;

CREATE TABLE `compras` (
  `n_nro` int(11) NOT NULL,
  `cod_prov` varchar(10) NOT NULL,
  `usuario` varchar(30) DEFAULT NULL,
  `to_usuario` varchar(30) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `moneda` varchar(4) NOT NULL,
  `cotiz` decimal(10,2) DEFAULT NULL,
  `prioridad` int(11) DEFAULT NULL,
  `fecha_entrega` date DEFAULT NULL,
  `volumen` decimal(16,1) DEFAULT NULL,
  `estado` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`n_nro`,`cod_prov`),
  KEY `Ref5295` (`n_nro`),
  KEY `Ref1596` (`moneda`),
  KEY `Ref6105` (`usuario`),
  KEY `Ref6106` (`to_usuario`),
  KEY `Ref146252` (`cod_prov`),
  CONSTRAINT `Refmonedas96` FOREIGN KEY (`moneda`) REFERENCES `monedas` (`m_cod`),
  CONSTRAINT `Refnota_pedido_compra95` FOREIGN KEY (`n_nro`) REFERENCES `nota_pedido_compra` (`n_nro`),
  CONSTRAINT `Refproveedores252` FOREIGN KEY (`cod_prov`) REFERENCES `proveedores` (`cod_prov`),
  CONSTRAINT `Refusuarios105` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`),
  CONSTRAINT `Refusuarios106` FOREIGN KEY (`to_usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `compras` */

/*Table structure for table `conceptos` */

DROP TABLE IF EXISTS `conceptos`;

CREATE TABLE `conceptos` (
  `id_concepto` int(11) NOT NULL AUTO_INCREMENT,
  `descrip` varchar(60) NOT NULL,
  `tipo` varchar(2) DEFAULT NULL,
  `autom` varchar(4) DEFAULT NULL,
  `compl` varchar(4) DEFAULT NULL,
  PRIMARY KEY (`id_concepto`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;

/*Data for the table `conceptos` */

insert  into `conceptos`(`id_concepto`,`descrip`,`tipo`,`autom`,`compl`) values (1,'Venta de Mercaderias','E','Si','Si'),(2,'Vuelto por Venta de Mercaderias','S','Si','Si'),(3,'Entrada por Reserva de Mercaderias','E','Si','Si'),(4,'Vuelto por Reserva de Mercaderias','S','Si','Si'),(5,'Entrada por Cambio de Divisas','E','Si','Si'),(6,'Salida Por Cambio de Divisas','S','Si','Si'),(7,'Efectivo por cobro de Cuotas a Cliente','E','Si','Si'),(8,'Cobro cuotas a Clientes','E','Si','Si'),(9,'Deposito en Cuenta Corriente/Ahorro','S','Si','Si'),(10,'Ajuste (+) por Cambio de Divisas','E','Si','Si'),(11,'Ajuste (-) por Cambio de Divisas','S','Si','Si'),(12,'Salida por Devolucion Nota de Credito','S','Si','Si'),(13,'Sobrante en Caja x Sencillo','E','No','Si'),(14,'Sobrante x Diferencia de Cambio','E','No','Si'),(15,'Faltante x Diferencia de Cambio','S','No','Si'),(16,'Ajuste (+) por Redondeo','E','No','Si'),(17,'Ajuste (-) por Redondeo','S','No','Si'),(18,'Pago Efectuado por Comisiones','S','No','Si');

/*Table structure for table `cont_bill_det` */

DROP TABLE IF EXISTS `cont_bill_det`;

CREATE TABLE `cont_bill_det` (
  `id_det` int(11) NOT NULL AUTO_INCREMENT,
  `id_cont` int(11) NOT NULL,
  `m_cod` varchar(4) NOT NULL,
  `identif` varchar(30) NOT NULL,
  `cantidad` varchar(30) DEFAULT NULL,
  `valor` decimal(16,2) DEFAULT NULL,
  `total` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`id_det`,`id_cont`),
  KEY `Ref3755` (`id_cont`),
  KEY `Ref4158` (`identif`,`m_cod`),
  KEY `Refmon_subdiv58` (`m_cod`,`identif`),
  CONSTRAINT `Refcont_billetes55` FOREIGN KEY (`id_cont`) REFERENCES `cont_billetes` (`id_cont`),
  CONSTRAINT `Refmon_subdiv58` FOREIGN KEY (`m_cod`, `identif`) REFERENCES `mon_subdiv` (`m_cod`, `identif`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `cont_bill_det` */

/*Table structure for table `cont_billetes` */

DROP TABLE IF EXISTS `cont_billetes`;

CREATE TABLE `cont_billetes` (
  `id_cont` int(11) NOT NULL AUTO_INCREMENT,
  `suc` varchar(10) DEFAULT NULL,
  `pdv_cod` varchar(30) DEFAULT NULL,
  `fecha` varchar(30) NOT NULL,
  `cajero` varchar(30) NOT NULL,
  `tipo` varchar(30) DEFAULT NULL,
  `auditor` varchar(30) DEFAULT NULL,
  `audit_hora` timestamp NULL DEFAULT NULL,
  `estado` varchar(10) DEFAULT NULL,
  `cotiz_rs` decimal(14,2) DEFAULT NULL,
  `cotiz_us` decimal(14,2) DEFAULT NULL,
  `cotiz_ps` decimal(14,2) DEFAULT NULL,
  `total` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`id_cont`),
  KEY `Ref654` (`cajero`),
  CONSTRAINT `Refusuarios54` FOREIGN KEY (`cajero`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `cont_billetes` */

/*Table structure for table `contactos` */

DROP TABLE IF EXISTS `contactos`;

CREATE TABLE `contactos` (
  `id_contacto` varchar(30) NOT NULL,
  `codigo_entidad` varchar(10) NOT NULL,
  `nombre` varchar(60) DEFAULT NULL,
  `doc` varchar(30) DEFAULT NULL,
  `tel` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_contacto`,`codigo_entidad`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `contactos` */

/*Table structure for table `convenios` */

DROP TABLE IF EXISTS `convenios`;

CREATE TABLE `convenios` (
  `id_mov` int(11) NOT NULL AUTO_INCREMENT,
  `cod_conv` varchar(30) NOT NULL,
  `id_concepto` int(11) NOT NULL,
  `f_nro` int(11) DEFAULT NULL,
  `nro_reserva` int(11) DEFAULT NULL,
  `trans_num` varchar(30) DEFAULT NULL,
  `nombre` varchar(80) DEFAULT NULL,
  `tipo` varchar(30) DEFAULT NULL,
  `voucher` varchar(30) DEFAULT NULL,
  `monto` decimal(16,2) DEFAULT NULL,
  `moneda` varchar(4) DEFAULT NULL,
  `cotiz` decimal(16,2) DEFAULT NULL,
  `fecha_acred` date DEFAULT NULL,
  `neto` decimal(16,2) DEFAULT NULL,
  `estado` varchar(30) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` varchar(10) DEFAULT NULL,
  `suc` varchar(10) DEFAULT NULL,
  `timbrado_ret` varchar(20) DEFAULT NULL,
  `fecha_ret` date DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id_mov`),
  KEY `Ref325` (`f_nro`),
  KEY `Ref2944` (`nro_reserva`),
  KEY `Ref3445` (`id_concepto`),
  KEY `Ref163313` (`cod_conv`),
  CONSTRAINT `Refconceptos45` FOREIGN KEY (`id_concepto`) REFERENCES `conceptos` (`id_concepto`),
  CONSTRAINT `Reffactura_venta25` FOREIGN KEY (`f_nro`) REFERENCES `factura_venta` (`f_nro`),
  CONSTRAINT `Refreservas44` FOREIGN KEY (`nro_reserva`) REFERENCES `reservas` (`nro_reserva`),
  CONSTRAINT `Reftarjetas313` FOREIGN KEY (`cod_conv`) REFERENCES `tarjetas` (`cod_tarjeta`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `convenios` */

/*Table structure for table `cotizaciones` */

DROP TABLE IF EXISTS `cotizaciones`;

CREATE TABLE `cotizaciones` (
  `id_cotiz` int(11) NOT NULL AUTO_INCREMENT,
  `suc` varchar(10) NOT NULL,
  `m_cod` varchar(4) NOT NULL,
  `fecha` date NOT NULL,
  `hora` varchar(10) DEFAULT NULL,
  `compra` decimal(8,2) DEFAULT NULL,
  `venta` decimal(8,2) DEFAULT NULL,
  `ref` varchar(4) DEFAULT NULL,
  PRIMARY KEY (`id_cotiz`,`suc`),
  KEY `Ref1826` (`suc`),
  KEY `Ref1527` (`m_cod`),
  CONSTRAINT `Refmonedas27` FOREIGN KEY (`m_cod`) REFERENCES `monedas` (`m_cod`),
  CONSTRAINT `Refsucursales26` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`)
) ENGINE=InnoDB AUTO_INCREMENT=15752 DEFAULT CHARSET=latin1;

/*Data for the table `cotizaciones` */

insert  into `cotizaciones`(`id_cotiz`,`suc`,`m_cod`,`fecha`,`hora`,`compra`,`venta`,`ref`) values (23,'01','P$','2017-01-12','10:56:54',280.00,290.00,'G$'),(24,'01','R$','2017-01-12','10:57:13',1600.00,1610.00,'G$'),(25,'01','U$','2017-01-12','10:57:33',5590.00,5610.00,'G$'),(26,'01','R$','2017-01-12','12:55:23',1600.00,1705.00,'G$'),(163,'01','P$','2017-03-31','07:37:46',5390.00,5390.00,'G$'),(164,'01','R$','2017-03-31','07:38:13',1640.00,1640.00,'G$'),(165,'01','P$','2017-03-31','07:39:52',310.00,310.00,'G$'),(166,'01','U$','2017-03-31','07:40:36',5390.00,5390.00,'G$'),(187,'01','P$','2017-04-03','07:06:49',310.00,310.00,'G$'),(188,'01','R$','2017-04-03','07:07:27',1640.00,1640.00,'G$'),(189,'01','U$','2017-04-03','07:07:56',5370.00,5370.00,'G$'),(214,'01','U$','2017-04-04','07:11:55',5370.00,5370.00,'G$'),(215,'01','R$','2017-04-04','07:12:16',1650.00,1650.00,'G$'),(216,'01','P$','2017-04-04','07:12:37',300.00,300.00,'G$'),(238,'01','U$','2017-04-05','07:09:29',5380.00,5380.00,'G$'),(239,'01','R$','2017-04-05','07:09:50',1650.00,1650.00,'G$'),(240,'01','P$','2017-04-05','07:10:09',305.00,305.00,'G$'),(262,'01','U$','2017-04-06','07:00:47',5380.00,5380.00,'G$'),(263,'01','R$','2017-04-06','07:01:14',1660.00,1660.00,'G$'),(264,'01','P$','2017-04-06','07:01:32',310.00,310.00,'G$'),(287,'01','U$','2017-04-07','06:58:23',5400.00,5400.00,'G$'),(288,'01','R$','2017-04-07','06:58:41',1680.00,1680.00,'G$'),(289,'01','P$','2017-04-07','06:58:59',315.00,315.00,'G$'),(311,'01','U$','2017-04-08','07:04:18',5270.00,5270.00,'G$'),(312,'01','R$','2017-04-08','07:06:11',1610.00,1610.00,'G$'),(313,'01','P$','2017-04-08','07:06:59',305.00,305.00,'G$'),(337,'01','U$','2017-04-10','06:07:02',5320.00,5320.00,'G$'),(338,'01','P$','2017-04-10','06:07:23',1650.00,1650.00,'G$'),(339,'01','U$','2017-04-10','06:08:00',5320.00,5320.00,'G$'),(340,'01','R$','2017-04-10','06:08:19',1650.00,1650.00,'G$'),(341,'01','P$','2017-04-10','06:08:44',315.00,315.00,'G$'),(363,'01','U$','2017-04-11','06:57:57',5270.00,5270.00,'G$'),(364,'01','R$','2017-04-11','06:58:18',1650.00,1650.00,'G$'),(365,'01','P$','2017-04-11','06:58:39',300.00,300.00,'G$'),(390,'01','U$','2017-04-12','07:07:44',5340.00,5340.00,'G$'),(398,'01','R$','2017-04-12','07:15:19',1650.00,1650.00,'G$'),(399,'01','P$','2017-04-12','07:15:39',300.00,300.00,'G$'),(427,'01','U$','2017-04-17','07:13:38',5320.00,5320.00,'G$'),(428,'01','R$','2017-04-17','07:14:26',1650.00,1650.00,'G$'),(429,'01','U$','2017-04-17','07:15:20',5250.00,5250.00,'G$'),(430,'01','R$','2017-04-17','07:16:00',1580.00,1580.00,'G$'),(431,'01','P$','2017-04-17','07:16:19',295.00,295.00,'G$'),(458,'01','U$','2017-04-17','18:37:40',5510.00,5510.00,'G$'),(459,'01','P$','2017-04-17','18:38:38',5250.00,5250.00,'G$'),(460,'01','P$','2017-04-17','19:15:01',295.00,295.00,'G$'),(461,'01','U$','2017-04-17','19:15:28',5250.00,5250.00,'G$'),(462,'01','U$','2017-04-18','07:08:11',5250.00,5250.00,'G$'),(463,'01','R$','2017-04-18','07:08:35',1600.00,1600.00,'G$'),(464,'01','P$','2017-04-18','07:08:56',295.00,295.00,'G$'),(487,'01','U$','2017-04-18','14:57:00',5510.00,5510.00,'G$'),(488,'01','U$','2017-04-18','14:58:18',5250.00,5250.00,'G$'),(491,'01','P$','2017-04-15','07:15:39',300.00,300.00,'G$'),(495,'01','U$','2017-04-19','07:07:29',300.00,300.00,'G$'),(496,'01','U$','2017-04-19','07:08:04',5280.00,5280.00,'G$'),(497,'01','R$','2017-04-19','07:08:27',1600.00,1600.00,'G$'),(498,'01','P$','2017-04-19','07:08:57',300.00,300.00,'G$'),(524,'01','U$','2017-04-20','07:02:31',5310.00,5310.00,'G$'),(525,'01','R$','2017-04-20','07:02:50',1590.00,1590.00,'G$'),(526,'01','P$','2017-04-20','07:03:08',295.00,295.00,'G$'),(556,'01','U$','2017-04-21','07:01:42',5330.00,5330.00,'G$'),(557,'01','R$','2017-04-21','07:02:00',1600.00,1600.00,'G$'),(558,'01','P$','2017-04-21','07:02:18',295.00,295.00,'G$'),(582,'01','U$','2017-04-22','07:01:29',5340.00,5340.00,'G$'),(583,'01','R$','2017-04-22','07:01:57',1600.00,1600.00,'G$'),(584,'01','P$','2017-04-22','07:02:15',300.00,300.00,'G$'),(604,'01','U$','2017-04-24','16:20:34',5550.00,5550.00,'G$'),(605,'01','P$','2017-04-24','16:21:21',5340.00,5340.00,'G$'),(606,'01','P$','2017-04-24','16:22:10',300.00,300.00,'G$'),(607,'01','U$','2017-04-24','16:22:28',5340.00,5340.00,'G$'),(611,'01','U$','2017-04-25','07:06:50',5330.00,5330.00,'G$'),(612,'01','R$','2017-04-25','07:07:20',1610.00,1610.00,'G$'),(613,'01','P$','2017-04-25','07:07:43',300.00,300.00,'G$'),(642,'01','U$','2017-04-26','07:02:23',5350.00,5350.00,'G$'),(643,'01','R$','2017-04-26','07:03:47',1620.00,1620.00,'G$'),(644,'01','P$','2017-04-26','07:04:09',300.00,300.00,'G$'),(669,'01','U$','2017-04-26','16:40:17',5550.00,5550.00,'G$'),(673,'01','U$','2017-04-27','07:08:57',5340.00,5340.00,'G$'),(674,'01','R$','2017-04-27','07:09:29',1590.00,1590.00,'G$'),(675,'01','P$','2017-04-27','07:09:49',300.00,300.00,'G$'),(703,'01','U$','2017-04-28','06:59:16',5340.00,5340.00,'G$'),(704,'01','R$','2017-04-28','06:59:37',1600.00,1600.00,'G$'),(705,'01','P$','2017-04-28','06:59:57',300.00,300.00,'G$'),(758,'01','U$','2017-05-02','07:09:29',5330.00,5330.00,'G$'),(759,'01','R$','2017-05-02','07:09:49',1590.00,1590.00,'G$'),(760,'01','P$','2017-05-02','07:10:08',300.00,300.00,'G$'),(781,'01','U$','2017-05-03','07:12:44',5340.00,5340.00,'G$'),(799,'01','U$','2017-05-03','17:40:57',5570.00,5570.00,'G$'),(800,'01','U$','2017-05-03','17:42:03',5340.00,5340.00,'G$'),(801,'01','U$','2017-05-04','07:04:20',5350.00,5350.00,'G$'),(802,'01','R$','2017-05-04','07:05:01',1620.00,1620.00,'G$'),(803,'01','P$','2017-05-04','07:05:32',300.00,300.00,'G$'),(826,'01','U$','2017-05-05','06:59:04',5340.00,5340.00,'G$'),(827,'01','R$','2017-05-05','06:59:29',1600.00,1600.00,'G$'),(857,'01','U$','2017-05-05','17:37:21',5560.00,5560.00,'G$'),(858,'01','P$','2017-05-05','17:39:07',5340.00,5340.00,'G$'),(859,'01','P$','2017-05-05','17:42:23',300.00,300.00,'G$'),(860,'01','U$','2017-05-05','17:42:45',5340.00,5340.00,'G$'),(861,'01','U$','2017-05-06','07:06:14',5330.00,5330.00,'G$'),(862,'01','R$','2017-05-06','07:06:36',1620.00,1620.00,'G$'),(874,'01','R$','2017-05-08','07:07:00',1600.00,1600.00,'G$'),(884,'01','R$','2017-05-09','07:08:49',1590.00,1590.00,'G$'),(897,'01','U$','2017-05-09','16:26:40',5550.00,5550.00,'G$'),(898,'01','U$','2017-05-09','16:28:35',5330.00,5330.00,'G$'),(914,'01','U$','2017-05-11','07:04:24',5340.00,5340.00,'G$'),(915,'01','R$','2017-05-11','07:04:48',1610.00,1610.00,'G$'),(916,'01','P$','2017-05-11','07:05:09',300.00,300.00,'G$'),(938,'01','U$','2017-05-12','07:02:51',5330.00,5330.00,'G$'),(939,'01','R$','2017-05-12','07:03:10',1580.00,1580.00,'G$'),(940,'01','P$','2017-05-12','07:03:25',315.00,315.00,'G$'),(943,'01','P$','2017-05-12','07:05:29',305.00,305.00,'G$'),(965,'01','R$','2017-05-13','07:01:44',1620.00,1620.00,'G$'),(982,'01','U$','2017-05-17','06:58:07',5330.00,5330.00,'G$'),(983,'01','R$','2017-05-17','06:58:26',1630.00,1630.00,'G$'),(984,'01','P$','2017-05-17','06:58:45',300.00,300.00,'G$'),(1009,'01','U$','2017-05-18','07:03:56',5300.00,5300.00,'G$'),(1010,'01','R$','2017-05-18','07:04:15',1600.00,1600.00,'G$'),(1030,'01','U$','2017-05-19','07:03:58',5330.00,5330.00,'G$'),(1031,'01','R$','2017-05-19','07:04:16',1480.00,1480.00,'G$'),(1032,'01','P$','2017-05-19','07:04:32',290.00,290.00,'G$'),(1055,'01','U$','2017-05-20','06:56:35',5300.00,5300.00,'G$'),(1056,'01','R$','2017-05-20','06:57:14',1560.00,1560.00,'G$'),(1057,'01','P$','2017-05-20','06:57:42',285.00,285.00,'G$'),(1073,'01','U$','2017-05-22','07:15:00',5320.00,5320.00,'G$'),(1074,'01','P$','2017-05-22','07:15:19',280.00,280.00,'G$'),(1095,'01','P$','2017-05-24','07:12:20',5330.00,5330.00,'G$'),(1096,'01','U$','2017-05-24','07:12:44',5330.00,5330.00,'G$'),(1097,'01','R$','2017-05-24','07:13:00',1560.00,1560.00,'G$'),(1098,'01','P$','2017-05-24','07:13:17',290.00,290.00,'G$'),(1121,'01','U$','2017-05-25','07:02:39',5340.00,5340.00,'G$'),(1122,'01','R$','2017-05-25','07:02:56',1550.00,1550.00,'G$'),(1123,'01','P$','2017-05-25','07:03:11',295.00,295.00,'G$'),(1138,'01','U$','2017-05-26','07:01:49',5350.00,5350.00,'G$'),(1139,'01','R$','2017-05-26','07:02:11',1540.00,1540.00,'G$'),(1156,'01','U$','2017-05-27','07:04:40',5330.00,5330.00,'G$'),(1157,'01','R$','2017-05-27','07:05:04',1540.00,1540.00,'G$'),(1158,'01','P$','2017-05-27','07:05:19',290.00,290.00,'G$'),(1181,'01','U$','2017-05-30','07:08:50',5330.00,5330.00,'G$'),(1182,'01','R$','2017-05-30','07:09:10',1550.00,1550.00,'G$'),(1183,'01','P$','2017-05-30','07:09:25',290.00,290.00,'G$'),(1210,'01','U$','2017-05-31','07:10:10',5320.00,5320.00,'G$'),(1211,'01','R$','2017-05-31','07:10:27',1540.00,1540.00,'G$'),(1212,'01','P$','2017-05-31','07:10:42',285.00,285.00,'G$'),(1221,'01','U$','2017-06-01','07:05:22',5340.00,5340.00,'G$'),(1222,'01','R$','2017-06-01','07:05:39',1570.00,1570.00,'G$'),(1223,'01','P$','2017-06-01','07:05:57',290.00,290.00,'G$'),(1245,'01','R$','2017-06-02','07:10:52',1550.00,1550.00,'G$'),(1246,'01','P$','2017-06-02','07:11:08',285.00,285.00,'G$'),(1263,'01','U$','2017-06-03','06:53:40',5330.00,5330.00,'G$'),(1264,'01','R$','2017-06-03','06:54:02',1570.00,1570.00,'G$'),(1265,'01','P$','2017-06-03','06:54:18',290.00,290.00,'G$'),(1278,'01','U$','2017-06-05','07:14:29',5330.00,5330.00,'G$'),(1279,'01','R$','2017-06-05','07:14:45',1560.00,1560.00,'G$'),(1280,'01','P$','2017-06-05','07:15:00',290.00,290.00,'G$'),(1302,'01','U$','2017-06-06','06:59:50',5300.00,5300.00,'G$'),(1303,'01','R$','2017-06-06','07:00:07',1550.00,1550.00,'G$'),(1304,'01','P$','2017-06-06','07:00:26',285.00,285.00,'G$'),(1326,'01','U$','2017-06-06','14:05:44',5540.00,5540.00,'G$'),(1327,'01','U$','2017-06-06','14:06:55',5300.00,5300.00,'G$'),(1330,'01','U$','2017-06-07','07:07:08',5330.00,5330.00,'G$'),(1331,'01','R$','2017-06-07','07:07:25',1560.00,1560.00,'G$'),(1332,'01','P$','2017-06-07','07:07:41',290.00,290.00,'G$'),(1362,'01','U$','2017-06-09','07:00:22',5320.00,5320.00,'G$'),(1363,'01','R$','2017-06-09','07:00:40',1550.00,1550.00,'G$'),(1364,'01','P$','2017-06-09','07:00:55',295.00,295.00,'G$'),(1386,'01','U$','2017-06-13','07:01:03',5320.00,5320.00,'G$'),(1387,'01','R$','2017-06-13','07:01:22',1530.00,1530.00,'G$'),(1388,'01','P$','2017-06-13','07:01:39',285.00,285.00,'G$'),(1410,'01','U$','2017-06-14','07:04:58',5300.00,5300.00,'G$'),(1411,'01','R$','2017-06-14','07:05:14',1520.00,1520.00,'G$'),(1412,'01','P$','2017-06-14','07:05:28',280.00,280.00,'G$'),(1434,'01','U$','2017-06-15','06:59:33',5300.00,5300.00,'G$'),(1435,'01','R$','2017-06-15','06:59:49',1540.00,1540.00,'G$'),(1436,'01','P$','2017-06-15','07:00:06',285.00,285.00,'G$'),(1468,'01','U$','2017-06-17','07:10:57',5300.00,5300.00,'G$'),(1469,'01','R$','2017-06-17','07:11:17',1540.00,1540.00,'G$'),(1470,'01','P$','2017-06-17','07:11:32',285.00,285.00,'G$'),(1483,'01','U$','2017-06-19','07:04:54',5300.00,5300.00,'G$'),(1484,'01','R$','2017-06-19','07:05:10',1540.00,1540.00,'G$'),(1485,'01','P$','2017-06-19','07:05:25',280.00,280.00,'G$'),(1507,'01','U$','2017-06-20','07:08:09',5300.00,5300.00,'G$'),(1508,'01','R$','2017-06-20','07:08:24',1520.00,1520.00,'G$'),(1509,'01','P$','2017-06-20','07:08:40',285.00,285.00,'G$'),(1532,'01','U$','2017-06-21','06:56:33',5290.00,5290.00,'G$'),(1533,'01','R$','2017-06-21','06:56:51',1490.00,1490.00,'G$'),(1534,'01','P$','2017-06-21','06:57:08',285.00,285.00,'G$'),(1556,'01','U$','2017-06-22','07:05:31',5290.00,5290.00,'G$'),(1557,'01','R$','2017-06-22','07:05:49',1500.00,1500.00,'G$'),(1558,'01','P$','2017-06-22','07:06:06',275.00,275.00,'G$'),(1581,'01','U$','2017-06-23','06:54:03',5300.00,5300.00,'G$'),(1582,'01','R$','2017-06-23','06:54:21',1520.00,1520.00,'G$'),(1583,'01','P$','2017-06-23','06:54:36',280.00,280.00,'G$'),(1605,'01','U$','2017-06-26','07:00:29',5290.00,5290.00,'G$'),(1606,'01','R$','2017-06-26','07:00:46',1510.00,1510.00,'G$'),(1607,'01','P$','2017-06-26','07:00:59',275.00,275.00,'G$'),(1631,'01','U$','2017-06-27','06:57:24',5270.00,5270.00,'G$'),(1632,'01','R$','2017-06-27','06:57:44',1530.00,1530.00,'G$'),(1633,'01','P$','2017-06-27','06:57:59',270.00,270.00,'G$'),(1655,'01','U$','2017-06-28','07:07:07',5290.00,5290.00,'G$'),(1656,'01','R$','2017-06-28','07:07:33',1510.00,1510.00,'G$'),(1657,'01','P$','2017-06-28','07:07:47',275.00,275.00,'G$'),(1685,'01','U$','2017-06-29','06:58:56',5300.00,5300.00,'G$'),(1686,'01','R$','2017-06-29','06:59:19',1540.00,1540.00,'G$'),(1687,'01','P$','2017-06-29','06:59:34',280.00,280.00,'G$'),(1710,'01','U$','2017-06-30','06:58:34',5320.00,5320.00,'G$'),(1711,'01','R$','2017-06-30','06:58:51',1540.00,1540.00,'G$'),(1712,'01','P$','2017-06-30','06:59:06',285.00,285.00,'G$'),(1744,'01','U$','2017-07-01','07:04:40',5290.00,5290.00,'G$'),(1745,'01','R$','2017-07-01','07:04:57',1550.00,1550.00,'G$'),(1746,'01','P$','2017-07-01','07:05:15',280.00,280.00,'G$'),(1768,'01','U$','2017-07-03','07:06:42',5290.00,5290.00,'G$'),(1769,'01','R$','2017-07-03','07:07:01',1550.00,1550.00,'G$'),(1770,'01','P$','2017-07-03','07:07:15',275.00,275.00,'G$'),(1795,'01','U$','2017-07-04','06:57:53',5280.00,5280.00,'G$'),(1796,'01','R$','2017-07-04','06:58:10',1550.00,1550.00,'G$'),(1797,'01','P$','2017-07-04','06:58:28',270.00,270.00,'G$'),(1822,'01','U$','2017-07-05','07:10:51',5280.00,5280.00,'G$'),(1823,'01','R$','2017-07-05','07:11:10',1560.00,1560.00,'G$'),(1824,'01','P$','2017-07-05','07:11:36',265.00,265.00,'G$'),(1854,'01','U$','2017-07-06','07:01:28',5290.00,5290.00,'G$'),(1855,'01','R$','2017-07-06','07:01:47',1570.00,1570.00,'G$'),(1856,'01','P$','2017-07-06','07:02:01',260.00,260.00,'G$'),(1881,'01','U$','2017-07-07','07:08:51',5290.00,5290.00,'G$'),(1882,'01','R$','2017-07-07','07:09:08',1550.00,1550.00,'G$'),(1883,'01','P$','2017-07-07','07:09:25',275.00,275.00,'G$'),(1911,'01','U$','2017-07-08','06:59:34',5340.00,5340.00,'G$'),(1912,'01','R$','2017-07-08','06:59:52',1585.00,1585.00,'G$'),(1913,'01','U$','2017-07-08','07:00:24',5270.00,5270.00,'G$'),(1914,'01','R$','2017-07-08','07:00:51',1570.00,1570.00,'G$'),(1915,'01','P$','2017-07-08','07:01:10',275.00,275.00,'G$'),(1962,'01','U$','2017-07-10','07:06:30',5270.00,5270.00,'G$'),(1963,'01','R$','2017-07-10','07:06:49',1570.00,1570.00,'G$'),(1964,'01','P$','2017-07-10','07:07:06',275.00,275.00,'G$'),(1965,'01','U$','2017-07-11','07:12:18',5270.00,5270.00,'G$'),(1966,'01','R$','2017-07-11','07:12:36',1550.00,1550.00,'G$'),(1967,'01','P$','2017-07-11','07:12:51',270.00,270.00,'G$'),(1995,'01','U$','2017-07-12','07:08:14',5270.00,5270.00,'G$'),(1996,'01','R$','2017-07-12','07:08:33',1550.00,1550.00,'G$'),(1997,'01','P$','2017-07-12','07:08:50',265.00,265.00,'G$'),(2025,'01','U$','2017-07-13','07:05:01',5300.00,5300.00,'G$'),(2026,'01','R$','2017-07-13','07:05:18',1590.00,1590.00,'G$'),(2027,'01','P$','2017-07-13','07:05:34',265.00,265.00,'G$'),(2052,'01','U$','2017-07-14','07:03:43',5300.00,5300.00,'G$'),(2053,'01','R$','2017-07-14','07:03:59',1680.00,1680.00,'G$'),(2054,'01','P$','2017-07-14','07:04:13',270.00,270.00,'G$'),(2083,'01','U$','2017-07-15','06:52:09',5300.00,5300.00,'G$'),(2084,'01','R$','2017-07-15','06:52:27',1590.00,1590.00,'G$'),(2085,'01','P$','2017-07-15','06:52:57',265.00,265.00,'G$'),(2114,'01','U$','2017-07-20','07:06:54',5290.00,5290.00,'G$'),(2115,'01','R$','2017-07-20','07:07:11',1600.00,1600.00,'G$'),(2116,'01','P$','2017-07-20','07:07:29',260.00,260.00,'G$'),(2138,'01','U$','2017-07-21','06:54:53',5320.00,5320.00,'G$'),(2139,'01','R$','2017-07-21','06:55:08',1620.00,1620.00,'G$'),(2140,'01','P$','2017-07-21','06:55:27',250.00,250.00,'G$'),(2168,'01','U$','2017-07-22','06:54:15',5320.00,5320.00,'G$'),(2169,'01','R$','2017-07-22','06:54:32',1600.00,1600.00,'G$'),(2170,'01','P$','2017-07-22','06:54:45',250.00,250.00,'G$'),(2192,'01','U$','2017-07-24','07:06:53',5330.00,5330.00,'G$'),(2193,'01','R$','2017-07-24','07:07:08',1600.00,1600.00,'G$'),(2194,'01','P$','2017-07-24','07:07:24',250.00,250.00,'G$'),(2222,'01','U$','2017-07-25','07:03:05',5300.00,5300.00,'G$'),(2244,'01','R$','2017-07-25','07:13:22',1600.00,1600.00,'G$'),(2245,'01','P$','2017-07-25','07:13:37',250.00,250.00,'G$'),(2252,'01','U$','2017-07-26','07:03:42',5310.00,5310.00,'G$'),(2253,'01','R$','2017-07-26','07:04:00',1580.00,1580.00,'G$'),(2254,'01','P$','2017-07-26','07:04:15',250.00,250.00,'G$'),(2280,'01','U$','2017-07-27','06:56:06',5330.00,5330.00,'G$'),(2281,'01','U$','2017-07-27','06:56:26',1600.00,1600.00,'G$'),(2282,'01','R$','2017-07-27','06:56:45',1600.00,1600.00,'G$'),(2283,'01','U$','2017-07-27','06:57:09',5330.00,5330.00,'G$'),(2284,'01','P$','2017-07-27','06:58:08',250.00,250.00,'G$'),(2310,'01','U$','2017-07-28','06:57:01',5320.00,5320.00,'G$'),(2311,'01','R$','2017-07-28','06:57:18',1610.00,1610.00,'G$'),(2312,'01','P$','2017-07-28','06:57:34',250.00,250.00,'G$'),(2348,'01','U$','2017-07-29','07:07:10',5320.00,5320.00,'G$'),(2349,'01','R$','2017-07-29','07:07:30',1610.00,1610.00,'G$'),(2350,'01','P$','2017-07-29','07:07:44',250.00,250.00,'G$'),(2363,'01','U$','2017-07-31','07:05:13',5320.00,5320.00,'G$'),(2364,'01','R$','2017-07-31','07:05:31',1610.00,1610.00,'G$'),(2365,'01','P$','2017-07-31','07:05:47',260.00,260.00,'G$'),(2390,'01','U$','2017-08-01','06:56:33',5330.00,5330.00,'G$'),(2391,'01','R$','2017-08-01','06:56:49',1610.00,1610.00,'G$'),(2392,'01','P$','2017-08-01','06:57:06',255.00,255.00,'G$'),(2422,'01','U$','2017-08-02','07:08:34',5340.00,5340.00,'G$'),(2423,'01','R$','2017-08-02','07:08:49',1620.00,1620.00,'G$'),(2424,'01','P$','2017-08-02','07:09:04',285.00,285.00,'G$'),(2425,'01','P$','2017-08-02','07:09:25',265.00,265.00,'G$'),(2452,'01','U$','2017-08-03','07:05:31',5350.00,5350.00,'G$'),(2453,'01','R$','2017-08-03','07:05:47',1620.00,1620.00,'G$'),(2454,'01','P$','2017-08-03','07:06:03',260.00,260.00,'G$'),(2479,'01','U$','2017-08-04','06:55:46',5330.00,5330.00,'G$'),(2500,'01','R$','2017-08-04','07:05:44',1620.00,1620.00,'G$'),(2501,'01','P$','2017-08-04','07:05:59',260.00,260.00,'G$'),(2508,'01','U$','2017-08-05','07:04:02',5340.00,5340.00,'G$'),(2509,'01','R$','2017-08-05','07:04:20',1620.00,1620.00,'G$'),(2510,'01','P$','2017-08-05','07:04:37',265.00,265.00,'G$'),(2532,'01','U$','2017-08-07','06:59:38',5330.00,5330.00,'G$'),(2533,'01','R$','2017-08-07','06:59:54',1620.00,1620.00,'G$'),(2534,'01','P$','2017-08-07','07:00:09',260.00,260.00,'G$'),(2561,'01','U$','2017-08-08','06:55:12',5330.00,5330.00,'G$'),(2562,'01','R$','2017-08-08','06:55:29',1620.00,1620.00,'G$'),(2563,'01','P$','2017-08-08','06:55:43',255.00,255.00,'G$'),(2588,'01','U$','2017-08-09','06:51:35',5340.00,5340.00,'G$'),(2589,'01','R$','2017-08-09','06:51:52',1620.00,1620.00,'G$'),(2590,'01','P$','2017-08-09','06:52:19',265.00,265.00,'G$'),(2616,'01','U$','2017-08-10','06:54:22',5350.00,5350.00,'G$'),(2617,'01','R$','2017-08-10','06:54:39',1610.00,1610.00,'G$'),(2618,'01','P$','2017-08-10','06:54:59',265.00,265.00,'G$'),(2647,'01','U$','2017-08-11','06:54:24',5360.00,5360.00,'G$'),(2648,'01','R$','2017-08-11','06:54:42',1600.00,1600.00,'G$'),(2649,'01','P$','2017-08-11','06:54:56',260.00,260.00,'G$'),(2682,'01','U$','2017-08-12','06:59:29',5340.00,5340.00,'G$'),(2683,'01','R$','2017-08-12','06:59:46',1620.00,1620.00,'G$'),(2707,'01','P$','2017-08-12','07:10:10',260.00,260.00,'G$'),(2712,'01','U$','2017-08-14','06:57:24',5340.00,5340.00,'G$'),(2713,'01','R$','2017-08-14','06:57:41',1600.00,1600.00,'G$'),(2714,'01','P$','2017-08-14','06:57:55',255.00,255.00,'G$'),(2739,'01','U$','2017-08-16','07:06:55',5330.00,5330.00,'G$'),(2740,'01','R$','2017-08-16','07:07:11',1610.00,1610.00,'G$'),(2741,'01','P$','2017-08-16','07:07:25',265.00,265.00,'G$'),(2766,'01','U$','2017-08-17','07:00:36',5340.00,5340.00,'G$'),(2767,'01','R$','2017-08-17','07:00:56',1620.00,1620.00,'G$'),(2768,'01','P$','2017-08-17','07:01:10',260.00,260.00,'G$'),(2793,'01','U$','2017-08-18','06:53:16',5350.00,5350.00,'G$'),(2794,'01','R$','2017-08-18','06:53:34',1595.00,1595.00,'G$'),(2795,'01','P$','2017-08-18','06:53:48',260.00,260.00,'G$'),(2822,'01','U$','2017-08-19','06:51:48',5340.00,5340.00,'G$'),(2823,'01','R$','2017-08-19','06:52:07',1645.00,1645.00,'G$'),(2824,'01','P$','2017-08-19','06:52:22',265.00,265.00,'G$'),(2846,'01','U$','2017-08-21','07:06:43',5340.00,5340.00,'G$'),(2847,'01','R$','2017-08-21','07:07:00',1635.00,1635.00,'G$'),(2848,'01','P$','2017-08-21','07:07:18',260.00,260.00,'G$'),(2875,'01','U$','2017-08-22','06:58:38',5360.00,5360.00,'G$'),(2876,'01','R$','2017-08-22','06:58:58',1610.00,1610.00,'G$'),(2877,'01','P$','2017-08-22','06:59:12',260.00,260.00,'G$'),(2902,'01','U$','2017-08-23','07:07:15',5370.00,5370.00,'G$'),(2903,'01','R$','2017-08-23','07:07:34',1630.00,1630.00,'G$'),(2904,'01','P$','2017-08-23','07:07:51',260.00,260.00,'G$'),(2929,'01','U$','2017-08-23','17:23:42',5580.00,5580.00,'G$'),(2930,'01','U$','2017-08-23','17:29:09',5370.00,5370.00,'G$'),(2931,'01','U$','2017-08-24','06:53:52',5370.00,5370.00,'G$'),(2932,'01','R$','2017-08-24','06:54:10',1640.00,1640.00,'G$'),(2933,'01','P$','2017-08-24','06:54:25',265.00,265.00,'G$'),(2960,'01','U$','2017-08-25','06:55:23',5420.00,5420.00,'G$'),(2961,'01','R$','2017-08-25','06:55:46',1650.00,1650.00,'G$'),(2962,'01','P$','2017-08-25','06:56:01',265.00,265.00,'G$'),(2987,'01','U$','2017-08-26','06:58:30',5390.00,5390.00,'G$'),(2988,'01','R$','2017-08-26','06:58:56',1630.00,1630.00,'G$'),(2989,'01','P$','2017-08-26','06:59:14',270.00,270.00,'G$'),(3011,'01','P$','2017-08-26','07:15:36',5420.00,5420.00,'G$'),(3012,'01','P$','2017-08-26','07:16:55',270.00,270.00,'G$'),(3013,'01','U$','2017-08-26','07:17:58',5420.00,5420.00,'G$'),(3014,'01','U$','2017-08-26','07:27:12',5390.00,5390.00,'G$'),(3015,'01','U$','2017-08-26','07:50:01',5420.00,5420.00,'G$'),(3016,'01','U$','2017-08-26','07:51:49',5390.00,5390.00,'G$'),(3017,'01','U$','2017-08-28','06:56:12',5400.00,5400.00,'G$'),(3018,'01','R$','2017-08-28','06:56:42',1630.00,1630.00,'G$'),(3019,'01','P$','2017-08-28','06:56:58',270.00,270.00,'G$'),(3044,'01','U$','2017-08-29','06:57:50',5390.00,5390.00,'G$'),(3045,'01','R$','2017-08-29','06:58:08',1620.00,1620.00,'G$'),(3046,'01','P$','2017-08-29','06:58:23',265.00,265.00,'G$'),(3071,'01','U$','2017-08-30','07:04:55',5400.00,5400.00,'G$'),(3092,'01','R$','2017-08-30','07:15:19',1620.00,1620.00,'G$'),(3093,'01','P$','2017-08-30','07:15:45',265.00,265.00,'G$'),(3100,'01','U$','2017-08-31','06:55:33',5410.00,5410.00,'G$'),(3101,'01','R$','2017-08-31','06:56:17',1640.00,1640.00,'G$'),(3102,'01','P$','2017-08-31','06:56:34',270.00,270.00,'G$'),(3129,'01','U$','2017-09-01','06:55:21',5400.00,5400.00,'G$'),(3130,'01','R$','2017-09-01','06:55:45',1640.00,1640.00,'G$'),(3131,'01','P$','2017-09-01','06:56:07',275.00,275.00,'G$'),(3156,'01','U$','2017-09-02','06:55:59',5400.00,5400.00,'G$'),(3157,'01','R$','2017-09-02','06:56:17',1630.00,1630.00,'G$'),(3158,'01','P$','2017-09-02','06:56:33',275.00,275.00,'G$'),(3190,'01','U$','2017-09-04','07:08:46',5400.00,5400.00,'G$'),(3191,'01','R$','2017-09-04','07:09:10',1630.00,1630.00,'G$'),(3192,'01','P$','2017-09-04','07:09:26',275.00,275.00,'G$'),(3216,'01','P$','2017-09-05','07:12:05',270.00,270.00,'G$'),(3230,'01','U$','2017-09-05','07:19:53',5400.00,5400.00,'G$'),(3231,'01','R$','2017-09-05','07:20:11',1630.00,1630.00,'G$'),(3243,'01','U$','2017-09-06','06:58:53',5410.00,5410.00,'G$'),(3244,'01','R$','2017-09-06','06:59:09',1650.00,1650.00,'G$'),(3245,'01','P$','2017-09-06','06:59:25',275.00,275.00,'G$'),(3270,'01','U$','2017-09-07','07:05:35',5420.00,5420.00,'G$'),(3271,'01','R$','2017-09-07','07:05:50',1670.00,1670.00,'G$'),(3272,'01','P$','2017-09-07','07:06:05',275.00,275.00,'G$'),(3300,'01','U$','2017-09-08','06:56:29',5410.00,5410.00,'G$'),(3301,'01','R$','2017-09-08','06:56:45',1660.00,1660.00,'G$'),(3302,'01','P$','2017-09-08','06:57:01',275.00,275.00,'G$'),(3331,'01','U$','2017-09-09','06:56:23',5410.00,5410.00,'G$'),(3332,'01','R$','2017-09-09','06:56:39',1680.00,1680.00,'G$'),(3333,'01','P$','2017-09-09','06:56:55',1680.00,1680.00,'G$'),(3334,'01','P$','2017-09-09','06:57:13',275.00,275.00,'G$'),(3353,'01','U$','2017-09-12','06:52:09',5410.00,5410.00,'G$'),(3354,'01','R$','2017-09-12','06:52:36',1670.00,1670.00,'G$'),(3355,'01','P$','2017-09-12','06:52:52',275.00,275.00,'G$'),(3380,'01','U$','2017-09-13','06:55:33',5420.00,5420.00,'G$'),(3381,'01','R$','2017-09-13','06:55:54',1650.00,1650.00,'G$'),(3382,'01','P$','2017-09-13','06:56:16',270.00,270.00,'G$'),(3407,'01','U$','2017-09-14','06:55:42',5420.00,5420.00,'G$'),(3408,'01','R$','2017-09-14','06:56:00',1665.00,1665.00,'G$'),(3409,'01','P$','2017-09-14','06:56:16',275.00,275.00,'G$'),(3436,'01','U$','2017-09-15','06:58:06',5420.00,5420.00,'G$'),(3437,'01','R$','2017-09-15','06:58:24',1665.00,1665.00,'G$'),(3438,'01','P$','2017-09-15','06:58:39',275.00,275.00,'G$'),(3466,'01','U$','2017-09-16','06:54:39',5420.00,5420.00,'G$'),(3467,'01','R$','2017-09-16','06:55:00',1670.00,1670.00,'G$'),(3468,'01','P$','2017-09-16','06:55:14',275.00,275.00,'G$'),(3508,'01','U$','2017-09-18','07:02:36',5420.00,5420.00,'G$'),(3509,'01','R$','2017-09-18','07:03:01',1670.00,1670.00,'G$'),(3510,'01','P$','2017-09-18','07:03:19',275.00,275.00,'G$'),(3517,'01','U$','2017-09-19','06:55:16',5430.00,5430.00,'G$'),(3518,'01','R$','2017-09-19','06:55:35',1665.00,1665.00,'G$'),(3519,'01','P$','2017-09-19','06:55:52',275.00,275.00,'G$'),(3545,'01','U$','2017-09-20','06:56:02',5440.00,5440.00,'G$'),(3546,'01','R$','2017-09-20','06:56:22',1655.00,1655.00,'G$'),(3547,'01','P$','2017-09-20','06:56:38',275.00,275.00,'G$'),(3591,'01','U$','2017-09-21','07:03:35',5440.00,5440.00,'G$'),(3592,'01','R$','2017-09-21','07:03:53',1655.00,1655.00,'G$'),(3593,'01','P$','2017-09-21','07:04:13',275.00,275.00,'G$'),(3610,'01','U$','2017-09-23','06:51:22',5440.00,5440.00,'G$'),(3611,'01','R$','2017-09-23','06:51:38',1680.00,1680.00,'G$'),(3612,'01','P$','2017-09-23','06:51:54',275.00,275.00,'G$'),(3634,'01','U$','2017-09-25','06:57:17',5430.00,5430.00,'G$'),(3635,'01','R$','2017-09-25','06:57:33',1680.00,1680.00,'G$'),(3636,'01','P$','2017-09-25','06:57:47',275.00,275.00,'G$'),(3660,'01','U$','2017-09-26','06:55:15',5430.00,5430.00,'G$'),(3661,'01','R$','2017-09-26','06:55:31',1650.00,1650.00,'G$'),(3662,'01','P$','2017-09-26','06:55:46',275.00,275.00,'G$'),(3688,'01','U$','2017-09-27','06:58:53',5420.00,5420.00,'G$'),(3689,'01','R$','2017-09-27','06:59:09',1650.00,1650.00,'G$'),(3690,'01','P$','2017-09-27','06:59:24',270.00,270.00,'G$'),(3715,'01','U$','2017-09-28','06:55:57',5420.00,5420.00,'G$'),(3716,'01','R$','2017-09-28','06:56:13',1620.00,1620.00,'G$'),(3717,'01','P$','2017-09-28','06:56:28',270.00,270.00,'G$'),(3742,'01','U$','2017-09-29','06:54:30',5400.00,5400.00,'G$'),(3743,'01','R$','2017-09-29','06:54:49',1635.00,1635.00,'G$'),(3744,'01','P$','2017-09-29','06:55:03',265.00,265.00,'G$'),(3774,'01','U$','2017-09-30','06:57:18',5410.00,5410.00,'G$'),(3775,'01','R$','2017-09-30','06:57:34',1645.00,1645.00,'G$'),(3776,'01','P$','2017-09-30','06:57:52',270.00,270.00,'G$'),(3823,'01','U$','2017-10-03','06:14:52',5410.00,5410.00,'G$'),(3824,'01','R$','2017-10-03','06:15:13',1645.00,1645.00,'G$'),(3825,'01','P$','2017-10-03','06:15:37',270.00,270.00,'G$'),(3836,'01','U$','2017-10-04','07:08:35',5410.00,5410.00,'G$'),(3837,'01','R$','2017-10-04','07:08:52',1650.00,1650.00,'G$'),(3838,'01','P$','2017-10-04','07:09:09',270.00,270.00,'G$'),(3864,'01','U$','2017-10-05','06:58:55',5410.00,5410.00,'G$'),(3865,'01','R$','2017-10-05','06:59:18',1655.00,1655.00,'G$'),(3866,'01','P$','2017-10-05','06:59:34',270.00,270.00,'G$'),(3891,'01','U$','2017-10-06','06:55:19',5415.00,5415.00,'G$'),(3892,'01','R$','2017-10-06','06:55:35',1645.00,1645.00,'G$'),(3893,'01','P$','2017-10-06','06:55:50',270.00,270.00,'G$'),(3924,'01','U$','2017-10-07','06:56:51',5390.00,5390.00,'G$'),(3925,'01','R$','2017-10-07','06:57:08',1645.00,1645.00,'G$'),(3926,'01','P$','2017-10-07','06:57:25',270.00,270.00,'G$'),(3948,'01','U$','2017-10-09','07:02:52',5400.00,5400.00,'G$'),(3949,'01','R$','2017-10-09','07:03:08',1645.00,1645.00,'G$'),(3950,'01','P$','2017-10-09','07:03:25',270.00,270.00,'G$'),(3969,'01','U$','2017-10-10','07:00:10',5380.00,5380.00,'G$'),(3970,'01','R$','2017-10-10','07:00:26',1620.00,1620.00,'G$'),(3971,'01','P$','2017-10-10','07:00:43',270.00,270.00,'G$'),(3996,'01','U$','2017-10-11','06:57:32',5370.00,5370.00,'G$'),(3997,'01','R$','2017-10-11','06:57:48',1630.00,1630.00,'G$'),(3998,'01','P$','2017-10-11','06:58:09',270.00,270.00,'G$'),(4025,'01','U$','2017-10-12','06:55:49',5400.00,5400.00,'G$'),(4026,'01','R$','2017-10-12','06:56:08',1635.00,1635.00,'G$'),(4027,'01','P$','2017-10-12','06:56:25',270.00,270.00,'G$'),(4052,'01','U$','2017-10-13','06:55:40',5410.00,5410.00,'G$'),(4053,'01','R$','2017-10-13','06:55:57',1640.00,1640.00,'G$'),(4054,'01','P$','2017-10-13','06:56:12',270.00,270.00,'G$'),(4086,'01','U$','2017-10-14','06:48:59',5400.00,5400.00,'G$'),(4087,'01','R$','2017-10-14','06:49:17',1645.00,1645.00,'G$'),(4088,'01','P$','2017-10-14','06:49:31',270.00,270.00,'G$'),(4117,'01','U$','2017-10-16','07:11:48',5400.00,5400.00,'G$'),(4118,'01','R$','2017-10-16','07:12:05',1645.00,1645.00,'G$'),(4119,'01','P$','2017-10-16','07:12:20',270.00,270.00,'G$'),(4140,'01','U$','2017-10-17','07:06:07',5400.00,5400.00,'G$'),(4141,'01','R$','2017-10-17','07:06:24',1630.00,1630.00,'G$'),(4142,'01','P$','2017-10-17','07:06:40',270.00,270.00,'G$'),(4167,'01','U$','2017-10-18','07:03:45',5390.00,5390.00,'G$'),(4188,'01','R$','2017-10-18','07:12:44',1630.00,1630.00,'G$'),(4189,'01','P$','2017-10-18','07:13:00',270.00,270.00,'G$'),(4194,'01','U$','2017-10-19','07:08:03',5400.00,5400.00,'G$'),(4195,'01','R$','2017-10-19','07:08:20',1640.00,1640.00,'G$'),(4196,'01','P$','2017-10-19','07:08:34',270.00,270.00,'G$'),(4221,'01','U$','2017-10-20','06:56:28',5400.00,5400.00,'G$'),(4222,'01','R$','2017-10-20','06:56:44',1645.00,1645.00,'G$'),(4223,'01','P$','2017-10-20','06:56:59',270.00,270.00,'G$'),(4269,'01','U$','2017-10-23','07:00:39',5400.00,5400.00,'G$'),(4270,'01','R$','2017-10-23','07:00:56',1635.00,1635.00,'G$'),(4271,'01','P$','2017-10-23','07:01:10',270.00,270.00,'G$'),(4296,'01','U$','2017-10-24','06:59:21',5380.00,5380.00,'G$'),(4297,'01','R$','2017-10-24','06:59:39',1610.00,1610.00,'G$'),(4298,'01','P$','2017-10-24','06:59:55',270.00,270.00,'G$'),(4325,'01','U$','2017-10-25','07:00:35',5450.00,5450.00,'G$'),(4326,'01','U$','2017-10-25','07:01:11',5400.00,5400.00,'G$'),(4327,'01','R$','2017-10-25','07:01:37',1610.00,1610.00,'G$'),(4328,'01','P$','2017-10-25','07:01:53',270.00,270.00,'G$'),(4369,'01','U$','2017-10-26','07:03:06',5400.00,5400.00,'G$'),(4370,'01','R$','2017-10-26','07:03:23',1610.00,1610.00,'G$'),(4371,'01','P$','2017-10-26','07:03:38',270.00,270.00,'G$'),(4381,'01','U$','2017-10-27','06:56:33',5400.00,5400.00,'G$'),(4382,'01','R$','2017-10-27','06:56:49',1600.00,1600.00,'G$'),(4383,'01','P$','2017-10-27','06:57:07',270.00,270.00,'G$'),(4414,'01','U$','2017-10-28','06:50:29',5400.00,5400.00,'G$'),(4415,'01','R$','2017-10-28','06:50:47',1600.00,1600.00,'G$'),(4416,'01','P$','2017-10-28','06:51:02',270.00,270.00,'G$'),(4435,'01','U$','2017-10-31','06:54:11',5400.00,5400.00,'G$'),(4436,'01','R$','2017-10-31','06:54:29',1580.00,1580.00,'G$'),(4437,'01','P$','2017-10-31','06:54:44',270.00,270.00,'G$'),(4468,'01','U$','2017-11-01','06:53:45',5390.00,5390.00,'G$'),(4469,'01','R$','2017-11-01','06:54:06',1590.00,1590.00,'G$'),(4470,'01','P$','2017-11-01','06:54:21',270.00,270.00,'G$'),(4504,'01','U$','2017-11-02','07:00:04',5410.00,5410.00,'G$'),(4505,'01','R$','2017-11-02','07:00:28',1605.00,1605.00,'G$'),(4506,'01','P$','2017-11-02','07:00:42',270.00,270.00,'G$'),(4536,'01','U$','2017-11-03','07:19:09',5410.00,5410.00,'G$'),(4537,'01','R$','2017-11-03','07:19:26',1605.00,1605.00,'G$'),(4538,'01','P$','2017-11-03','07:19:45',270.00,270.00,'G$'),(4560,'01','U$','2017-11-04','06:52:02',5400.00,5400.00,'G$'),(4561,'01','R$','2017-11-04','06:52:19',1570.00,1570.00,'G$'),(4562,'01','P$','2017-11-04','06:52:37',270.00,270.00,'G$'),(4593,'01','U$','2017-11-06','06:58:44',5400.00,5400.00,'G$'),(4594,'01','R$','2017-11-06','06:59:01',1570.00,1570.00,'G$'),(4595,'01','P$','2017-11-06','06:59:15',270.00,270.00,'G$'),(4617,'01','U$','2017-11-07','06:58:49',5400.00,5400.00,'G$'),(4618,'01','R$','2017-11-07','06:59:06',1600.00,1600.00,'G$'),(4619,'01','P$','2017-11-07','06:59:20',270.00,270.00,'G$'),(4646,'01','U$','2017-11-08','07:01:42',5400.00,5400.00,'G$'),(4647,'01','R$','2017-11-08','07:02:00',1580.00,1580.00,'G$'),(4648,'01','P$','2017-11-08','07:02:13',270.00,270.00,'G$'),(4674,'01','U$','2017-11-09','06:56:06',5410.00,5410.00,'G$'),(4675,'01','R$','2017-11-09','06:56:22',1590.00,1590.00,'G$'),(4676,'01','P$','2017-11-09','06:56:36',270.00,270.00,'G$'),(4714,'01','U$','2017-11-10','07:02:11',5410.00,5410.00,'G$'),(4715,'01','R$','2017-11-10','07:02:29',1590.00,1590.00,'G$'),(4716,'01','P$','2017-11-10','07:02:45',270.00,270.00,'G$'),(4738,'01','U$','2017-11-11','06:52:38',5400.00,5400.00,'G$'),(4739,'01','R$','2017-11-11','06:52:56',1590.00,1590.00,'G$'),(4740,'01','P$','2017-11-11','06:53:11',270.00,270.00,'G$'),(4767,'01','U$','2017-11-13','07:08:30',5400.00,5400.00,'G$'),(4768,'01','R$','2017-11-13','07:08:45',1590.00,1590.00,'G$'),(4769,'01','P$','2017-11-13','07:09:01',270.00,270.00,'G$'),(4796,'01','U$','2017-11-14','06:58:00',5400.00,5400.00,'G$'),(4797,'01','R$','2017-11-14','06:58:15',1590.00,1590.00,'G$'),(4798,'01','P$','2017-11-14','06:58:30',270.00,270.00,'G$'),(4828,'01','U$','2017-11-16','06:56:22',5400.00,5400.00,'G$'),(4829,'01','R$','2017-11-16','06:56:41',1590.00,1590.00,'G$'),(4830,'01','P$','2017-11-16','06:56:55',270.00,270.00,'G$'),(4856,'01','U$','2017-11-17','06:55:32',5400.00,5400.00,'G$'),(4857,'01','R$','2017-11-17','06:55:49',1585.00,1585.00,'G$'),(4858,'01','P$','2017-11-17','06:56:04',270.00,270.00,'G$'),(4893,'01','U$','2017-11-20','06:57:57',5400.00,5400.00,'G$'),(4894,'01','R$','2017-11-20','06:58:13',1595.00,1595.00,'G$'),(4895,'01','P$','2017-11-20','06:58:30',270.00,270.00,'G$'),(4922,'01','U$','2017-11-21','07:08:28',5390.00,5390.00,'G$'),(4923,'01','R$','2017-11-21','07:08:45',1595.00,1595.00,'G$'),(4924,'01','P$','2017-11-21','07:09:01',270.00,270.00,'G$'),(4950,'01','U$','2017-11-22','06:53:13',5490.00,5490.00,'G$'),(4951,'01','R$','2017-11-22','06:53:29',1600.00,1600.00,'G$'),(4952,'01','P$','2017-11-22','06:53:43',270.00,270.00,'G$'),(4957,'01','U$','2017-11-22','06:55:46',5390.00,5390.00,'G$'),(4984,'01','U$','2017-11-23','06:55:33',5400.00,5400.00,'G$'),(4985,'01','R$','2017-11-23','06:55:49',1605.00,1605.00,'G$'),(4986,'01','P$','2017-11-23','06:56:06',270.00,270.00,'G$'),(5020,'01','U$','2017-11-24','06:57:17',5400.00,5400.00,'G$'),(5021,'01','R$','2017-11-24','06:57:33',1610.00,1610.00,'G$'),(5022,'01','P$','2017-11-24','06:57:55',270.00,270.00,'G$'),(5048,'01','U$','2017-11-25','06:54:16',5400.00,5400.00,'G$'),(5049,'01','R$','2017-11-25','06:54:32',1620.00,1620.00,'G$'),(5050,'01','P$','2017-11-25','06:54:47',270.00,270.00,'G$'),(5076,'01','U$','2017-11-27','07:02:26',5400.00,5400.00,'G$'),(5077,'01','R$','2017-11-27','07:02:44',1620.00,1620.00,'G$'),(5078,'01','P$','2017-11-27','07:02:59',270.00,270.00,'G$'),(5109,'01','U$','2017-11-28','07:10:31',5400.00,5400.00,'G$'),(5110,'01','R$','2017-11-28','07:10:49',1630.00,1630.00,'G$'),(5111,'01','P$','2017-11-28','07:11:05',270.00,270.00,'G$'),(5139,'01','U$','2017-11-29','06:52:55',5390.00,5390.00,'G$'),(5140,'01','R$','2017-11-29','06:53:12',1620.00,1620.00,'G$'),(5141,'01','P$','2017-11-29','06:53:26',270.00,270.00,'G$'),(5173,'01','U$','2017-11-30','07:01:14',5400.00,5400.00,'G$'),(5174,'01','R$','2017-11-30','07:01:34',1620.00,1620.00,'G$'),(5175,'01','P$','2017-11-30','07:01:50',270.00,270.00,'G$'),(5209,'01','U$','2017-12-01','06:59:33',5400.00,5400.00,'G$'),(5210,'01','R$','2017-12-01','06:59:49',1610.00,1610.00,'G$'),(5211,'01','P$','2017-12-01','07:00:04',270.00,270.00,'G$'),(5235,'01','U$','2017-12-02','07:00:40',5400.00,5400.00,'G$'),(5236,'01','R$','2017-12-02','07:00:57',1620.00,1620.00,'G$'),(5237,'01','P$','2017-12-02','07:01:11',270.00,270.00,'G$'),(5264,'01','U$','2017-12-04','06:57:30',5400.00,5400.00,'G$'),(5265,'01','R$','2017-12-04','06:57:49',1620.00,1620.00,'G$'),(5266,'01','P$','2017-12-04','06:58:07',270.00,270.00,'G$'),(5298,'01','U$','2017-12-05','07:12:22',5390.00,5390.00,'G$'),(5299,'01','R$','2017-12-05','07:12:37',1620.00,1620.00,'G$'),(5300,'01','P$','2017-12-05','07:12:51',270.00,270.00,'G$'),(5325,'01','U$','2017-12-06','06:55:04',5400.00,5400.00,'G$'),(5326,'01','R$','2017-12-06','06:55:24',1630.00,1630.00,'G$'),(5327,'01','P$','2017-12-06','06:55:39',270.00,270.00,'G$'),(5353,'01','U$','2017-12-07','07:05:04',5390.00,5390.00,'G$'),(5354,'01','R$','2017-12-07','07:05:27',1620.00,1620.00,'G$'),(5355,'01','P$','2017-12-07','07:05:50',275.00,275.00,'G$'),(5384,'01','U$','2017-12-11','06:59:03',5350.00,5350.00,'G$'),(5385,'01','R$','2017-12-11','06:59:19',1600.00,1600.00,'G$'),(5386,'01','P$','2017-12-11','06:59:33',270.00,270.00,'G$'),(5418,'01','U$','2017-12-12','06:57:32',5340.00,5340.00,'G$'),(5419,'01','R$','2017-12-12','06:57:51',1590.00,1590.00,'G$'),(5420,'01','P$','2017-12-12','06:58:06',270.00,270.00,'G$'),(5450,'01','U$','2017-12-13','07:06:05',5350.00,5350.00,'G$'),(5451,'01','R$','2017-12-13','07:06:23',1580.00,1580.00,'G$'),(5452,'01','P$','2017-12-13','07:06:37',270.00,270.00,'G$'),(5477,'01','U$','2017-12-14','06:57:51',5350.00,5350.00,'G$'),(5478,'01','R$','2017-12-14','06:58:08',1590.00,1590.00,'G$'),(5479,'01','P$','2017-12-14','06:58:23',270.00,270.00,'G$'),(5506,'01','U$','2017-12-15','06:48:28',5350.00,5350.00,'G$'),(5507,'01','R$','2017-12-15','06:48:44',1570.00,1570.00,'G$'),(5508,'01','P$','2017-12-15','06:49:01',270.00,270.00,'G$'),(5539,'01','U$','2017-12-16','06:54:47',5350.00,5350.00,'G$'),(5540,'01','R$','2017-12-16','06:55:04',1690.00,1690.00,'G$'),(5541,'01','R$','2017-12-16','06:55:21',1590.00,1590.00,'G$'),(5542,'01','P$','2017-12-16','06:55:39',260.00,260.00,'G$'),(5564,'01','U$','2017-12-18','07:08:33',5370.00,5370.00,'G$'),(5565,'01','R$','2017-12-18','07:08:50',1590.00,1590.00,'G$'),(5566,'01','P$','2017-12-18','07:09:07',260.00,260.00,'G$'),(5589,'01','U$','2017-12-19','07:02:39',5350.00,5350.00,'G$'),(5590,'01','R$','2017-12-19','07:02:55',1590.00,1590.00,'G$'),(5591,'01','P$','2017-12-19','07:03:09',260.00,260.00,'G$'),(5618,'01','U$','2017-12-20','07:04:01',5350.00,5350.00,'G$'),(5619,'01','R$','2017-12-20','07:04:19',1580.00,1580.00,'G$'),(5620,'01','P$','2017-12-20','07:04:32',255.00,255.00,'G$'),(5650,'01','U$','2017-12-21','06:55:52',5360.00,5360.00,'G$'),(5651,'01','R$','2017-12-21','06:56:08',1590.00,1590.00,'G$'),(5652,'01','P$','2017-12-21','06:56:22',260.00,260.00,'G$'),(5677,'01','U$','2017-12-22','07:08:55',5310.00,5310.00,'G$'),(5678,'01','R$','2017-12-22','07:09:16',1570.00,1570.00,'G$'),(5679,'01','P$','2017-12-22','07:09:29',250.00,250.00,'G$'),(5705,'01','U$','2017-12-23','07:00:59',5280.00,5280.00,'G$'),(5706,'01','R$','2017-12-23','07:01:17',1580.00,1580.00,'G$'),(5707,'01','P$','2017-12-23','07:01:31',250.00,250.00,'G$'),(5734,'01','U$','2017-12-26','07:06:37',5200.00,5200.00,'G$'),(5735,'01','R$','2017-12-26','07:06:54',1580.00,1580.00,'G$'),(5736,'01','P$','2017-12-26','07:07:08',250.00,250.00,'G$'),(5761,'01','U$','2017-12-27','07:09:55',5270.00,5270.00,'G$'),(5762,'01','P$','2017-12-27','07:10:12',1590.00,1590.00,'G$'),(5763,'01','R$','2017-12-27','07:10:32',1580.00,1580.00,'G$'),(5764,'01','P$','2017-12-27','07:10:49',240.00,240.00,'G$'),(5798,'01','U$','2017-12-28','07:01:35',5280.00,5280.00,'G$'),(5799,'01','R$','2017-12-28','07:01:51',1580.00,1580.00,'G$'),(5800,'01','P$','2017-12-28','07:02:04',230.00,230.00,'G$'),(5825,'01','U$','2017-12-29','07:14:49',5250.00,5250.00,'G$'),(5826,'01','R$','2017-12-29','07:15:24',1580.00,1580.00,'G$'),(5827,'01','P$','2017-12-29','07:15:39',220.00,220.00,'G$'),(5852,'01','U$','2017-12-30','07:01:34',5250.00,5250.00,'G$'),(5853,'01','R$','2017-12-30','07:01:50',1580.00,1580.00,'G$'),(5854,'01','P$','2017-12-30','07:02:05',220.00,220.00,'G$'),(5879,'01','U$','2018-01-02','06:56:24',5200.00,5200.00,'G$'),(5880,'01','R$','2018-01-02','06:56:40',1580.00,1580.00,'G$'),(5881,'01','P$','2018-01-02','06:56:54',220.00,220.00,'G$'),(5914,'01','U$','2018-01-03','07:09:01',5320.00,5320.00,'G$'),(5915,'01','R$','2018-01-03','07:09:16',1580.00,1580.00,'G$'),(5916,'01','P$','2018-01-03','07:09:31',225.00,225.00,'G$'),(5941,'01','U$','2018-01-04','07:02:51',5330.00,5330.00,'G$'),(5942,'01','R$','2018-01-04','07:03:08',1610.00,1610.00,'G$'),(5943,'01','P$','2018-01-04','07:03:22',230.00,230.00,'G$'),(5972,'01','U$','2018-01-05','07:08:33',5350.00,5350.00,'G$'),(5973,'01','R$','2018-01-05','07:08:51',1620.00,1620.00,'G$'),(5974,'01','P$','2018-01-05','07:09:06',230.00,230.00,'G$'),(6005,'01','U$','2018-01-06','07:08:44',5350.00,5350.00,'G$'),(6006,'01','R$','2018-01-06','07:09:03',1600.00,1600.00,'G$'),(6007,'01','P$','2018-01-06','07:09:18',230.00,230.00,'G$'),(6033,'01','U$','2018-01-08','07:07:29',5350.00,5350.00,'G$'),(6034,'01','R$','2018-01-08','07:07:45',1600.00,1600.00,'G$'),(6035,'01','P$','2018-01-08','07:07:59',230.00,230.00,'G$'),(6060,'01','U$','2018-01-09','06:58:29',5450.00,5450.00,'G$'),(6061,'01','R$','2018-01-09','06:58:48',1610.00,1610.00,'G$'),(6062,'01','P$','2018-01-09','06:59:03',230.00,230.00,'G$'),(6070,'01','U$','2018-01-09','07:02:13',5350.00,5350.00,'G$'),(6093,'01','U$','2018-01-10','06:59:52',5340.00,5340.00,'G$'),(6094,'01','R$','2018-01-10','07:00:07',1620.00,1620.00,'G$'),(6095,'01','P$','2018-01-10','07:00:21',225.00,225.00,'G$'),(6120,'01','U$','2018-01-11','07:02:49',5350.00,5350.00,'G$'),(6121,'01','R$','2018-01-11','07:03:06',1620.00,1620.00,'G$'),(6122,'01','P$','2018-01-11','07:03:33',240.00,240.00,'G$'),(6148,'01','U$','2018-01-12','07:06:21',5360.00,5360.00,'G$'),(6149,'01','R$','2018-01-12','07:06:39',1620.00,1620.00,'G$'),(6150,'01','P$','2018-01-12','07:06:54',245.00,245.00,'G$'),(6182,'01','U$','2018-01-13','07:01:55',5360.00,5360.00,'G$'),(6183,'01','R$','2018-01-13','07:02:10',1630.00,1630.00,'G$'),(6184,'01','P$','2018-01-13','07:02:24',240.00,240.00,'G$'),(6206,'01','U$','2018-01-15','07:08:23',5370.00,5370.00,'G$'),(6207,'01','R$','2018-01-15','07:08:41',1630.00,1630.00,'G$'),(6208,'01','P$','2018-01-15','07:09:00',240.00,240.00,'G$'),(6224,'01','P$','2018-01-16','07:07:35',240.00,240.00,'G$'),(6225,'01','R$','2018-01-16','07:07:58',1630.00,1630.00,'G$'),(6226,'01','U$','2018-01-16','07:08:51',5360.00,5360.00,'G$'),(6258,'01','P$','2018-01-17','07:18:45',235.00,235.00,'G$'),(6259,'01','P$','2018-01-17','07:19:01',1620.00,1620.00,'G$'),(6260,'01','U$','2018-01-17','07:19:28',5350.00,5350.00,'G$'),(6261,'01','R$','2018-01-17','07:19:52',1620.00,1620.00,'G$'),(6262,'01','P$','2018-01-17','07:20:17',235.00,235.00,'G$'),(6284,'01','U$','2018-01-17','16:34:12',5550.00,5550.00,'G$'),(6285,'01','U$','2018-01-17','16:36:38',5350.00,5350.00,'G$'),(6289,'01','R$','2018-01-18','07:04:46',1630.00,1630.00,'G$'),(6290,'01','P$','2018-01-18','07:05:09',240.00,240.00,'G$'),(6337,'01','U$','2018-01-19','16:15:25',5540.00,5540.00,'G$'),(6338,'01','U$','2018-01-19','16:21:31',5350.00,5350.00,'G$'),(6353,'01','U$','2018-01-20','07:13:06',5340.00,5340.00,'G$'),(6354,'01','P$','2018-01-20','07:13:40',235.00,235.00,'G$'),(6373,'01','U$','2018-01-22','07:57:48',5410.00,5410.00,'G$'),(6374,'01','R$','2018-01-22','07:58:12',1640.00,1640.00,'G$'),(6385,'01','U$','2018-01-23','07:13:08',5340.00,5340.00,'G$'),(6386,'01','R$','2018-01-23','07:13:52',1620.00,1620.00,'G$'),(6387,'01','P$','2018-01-23','07:14:18',230.00,230.00,'G$'),(6408,'01','P$','2018-01-24','07:20:35',235.00,235.00,'G$'),(6409,'01','R$','2018-01-24','07:21:14',1610.00,1610.00,'G$'),(6410,'01','U$','2018-01-24','07:21:34',5340.00,5340.00,'G$'),(6432,'01','U$','2018-01-25','07:23:28',5330.00,5330.00,'G$'),(6433,'01','R$','2018-01-25','07:24:18',1640.00,1640.00,'G$'),(6434,'01','P$','2018-01-25','07:25:11',225.00,225.00,'G$'),(6483,'01','U$','2018-01-27','07:12:16',5360.00,5360.00,'G$'),(6485,'01','R$','2018-01-27','07:12:49',1650.00,1650.00,'G$'),(6486,'01','P$','2018-01-27','07:13:21',235.00,235.00,'G$'),(6504,'01','R$','2018-01-29','07:16:38',1660.00,1660.00,'G$'),(6505,'01','P$','2018-01-29','07:17:03',230.00,230.00,'G$'),(6527,'01','U$','2018-01-30','06:58:37',5350.00,5350.00,'G$'),(6528,'01','R$','2018-01-30','06:59:03',1630.00,1630.00,'G$'),(6548,'01','P$','2018-01-31','07:07:01',235.00,235.00,'G$'),(6549,'01','R$','2018-01-31','07:07:39',1640.00,1640.00,'G$'),(6566,'01','U$','2018-02-01','07:02:29',5330.00,5330.00,'G$'),(6595,'01','P$','2018-02-02','07:16:40',237.00,237.00,'G$'),(6622,'01','P$','2018-02-03','08:56:29',230.00,230.00,'G$'),(6623,'01','R$','2018-02-03','08:56:48',1650.00,1650.00,'G$'),(6624,'01','U$','2018-02-03','08:57:17',5400.00,5400.00,'G$'),(6628,'01','U$','2018-02-03','09:40:37',5340.00,5340.00,'G$'),(6629,'01','R$','2018-02-03','09:41:01',1630.00,1630.00,'G$'),(6630,'01','P$','2018-02-03','09:42:01',237.00,237.00,'G$'),(6640,'01','R$','2018-02-05','06:54:17',1620.00,1620.00,'G$'),(6663,'01','P$','2018-02-06','07:12:55',235.00,235.00,'G$'),(6664,'01','R$','2018-02-06','07:13:24',1600.00,1600.00,'G$'),(6665,'01','U$','2018-02-06','07:13:46',5320.00,5320.00,'G$'),(6717,'01','U$','2018-02-08','07:13:30',5300.00,5300.00,'G$'),(6718,'01','R$','2018-02-08','07:13:57',1575.00,1575.00,'G$'),(6752,'01','P$','2018-02-09','07:23:34',230.00,230.00,'G$'),(6753,'01','R$','2018-02-09','07:24:28',1580.00,1580.00,'G$'),(6754,'01','U$','2018-02-09','07:25:04',5320.00,5320.00,'G$'),(6837,'01','P$','2018-02-13','07:06:54',225.00,225.00,'G$'),(6838,'01','U$','2018-02-13','07:07:20',5280.00,5280.00,'G$'),(6839,'01','R$','2018-02-13','07:07:47',1560.00,1560.00,'G$'),(6895,'01','R$','2018-02-15','07:14:00',1580.00,1580.00,'G$'),(6922,'01','U$','2018-02-16','07:26:58',5300.00,5300.00,'G$'),(6923,'01','R$','2018-02-16','07:27:28',1590.00,1590.00,'G$'),(6946,'01','U$','2018-02-17','07:09:07',5325.00,5325.00,'G$'),(6947,'01','R$','2018-02-17','07:09:26',1605.00,1605.00,'G$'),(6965,'01','U$','2018-02-19','07:09:07',5335.00,5335.00,'G$'),(6967,'01','R$','2018-02-19','07:09:22',1610.00,1610.00,'G$'),(6968,'01','P$','2018-02-19','07:09:36',230.00,230.00,'G$'),(6987,'01','P$','2018-02-20','07:10:21',235.00,235.00,'G$'),(6988,'01','R$','2018-02-20','07:10:39',1620.00,1620.00,'G$'),(6989,'01','U$','2018-02-20','07:11:00',5345.00,5345.00,'G$'),(7008,'01','R$','2018-02-21','07:01:18',1610.00,1610.00,'G$'),(7059,'01','U$','2018-02-23','07:05:15',5350.00,5350.00,'G$'),(7073,'01','U$','2018-02-23','16:55:33',5500.00,5500.00,'G$'),(7077,'01','U$','2018-02-23','17:19:16',5350.00,5350.00,'G$'),(7081,'01','U$','2018-02-24','07:09:40',5340.00,5340.00,'G$'),(7095,'01','U$','2018-02-24','08:37:49',5350.00,5350.00,'G$'),(7096,'01','P$','2018-02-24','08:40:52',5340.00,5340.00,'G$'),(7097,'01','P$','2018-02-24','08:43:58',235.00,235.00,'G$'),(7098,'01','U$','2018-02-24','08:44:47',5340.00,5340.00,'G$'),(7105,'01','U$','2018-02-26','06:58:42',5350.00,5350.00,'G$'),(7141,'01','P$','2018-02-28','07:12:12',230.00,230.00,'G$'),(7142,'01','R$','2018-02-28','07:12:29',1620.00,1620.00,'G$'),(7144,'01','P$','2018-02-28','07:12:50',5340.00,5340.00,'G$'),(7145,'01','U$','2018-02-28','07:13:15',5340.00,5340.00,'G$'),(7146,'01','P$','2018-02-28','07:13:53',230.00,230.00,'G$'),(7169,'01','P$','2018-03-01','07:08:52',235.00,235.00,'G$'),(7170,'01','R$','2018-03-01','07:09:32',1600.00,1600.00,'G$'),(7189,'01','R$','2018-03-02','07:17:21',1595.00,1595.00,'G$'),(7190,'01','U$','2018-03-02','07:17:48',5330.00,5330.00,'G$'),(7217,'01','U$','2018-03-03','07:31:35',5310.00,5310.00,'G$'),(7237,'01','U$','2018-03-05','07:11:16',5290.00,5290.00,'G$'),(7238,'01','P$','2018-03-05','07:11:41',230.00,230.00,'G$'),(7239,'01','R$','2018-03-05','07:12:04',1580.00,1580.00,'G$'),(7260,'01','R$','2018-03-06','07:44:01',1585.00,1585.00,'G$'),(7276,'01','P$','2018-03-07','07:04:55',235.00,235.00,'G$'),(7277,'01','U$','2018-03-07','07:05:15',5300.00,5300.00,'G$'),(7278,'01','R$','2018-03-07','07:05:32',1610.00,1610.00,'G$'),(7304,'01','R$','2018-03-08','07:58:31',1585.00,1585.00,'G$'),(7324,'01','U$','2018-03-09','07:07:57',5310.00,5310.00,'G$'),(7325,'01','R$','2018-03-09','07:08:20',1580.00,1580.00,'G$'),(7326,'01','P$','2018-03-09','07:08:45',230.00,230.00,'G$'),(7343,'01','R$','2018-03-10','07:00:29',1595.00,1595.00,'G$'),(7344,'01','P$','2018-03-10','07:01:27',235.00,235.00,'G$'),(7382,'01','R$','2018-03-13','07:06:26',1590.00,1590.00,'G$'),(7383,'01','U$','2018-03-13','07:06:43',5300.00,5300.00,'G$'),(7402,'01','R$','2018-03-14','07:03:31',1595.00,1595.00,'G$'),(7424,'01','U$','2018-03-15','07:15:19',5310.00,5310.00,'G$'),(7425,'01','R$','2018-03-15','07:15:38',1590.00,1590.00,'G$'),(7444,'01','R$','2018-03-16','07:09:14',1580.00,1580.00,'G$'),(7445,'01','U$','2018-03-16','07:09:30',5315.00,5315.00,'G$'),(7474,'01','U$','2018-03-17','07:12:01',5320.00,5320.00,'G$'),(7475,'01','R$','2018-03-17','07:12:34',1585.00,1585.00,'G$'),(7512,'01','U$','2018-03-20','07:03:29',5315.00,5315.00,'G$'),(7513,'01','R$','2018-03-20','07:03:49',1580.00,1580.00,'G$'),(7535,'01','U$','2018-03-21','07:10:08',5320.00,5320.00,'G$'),(7536,'01','R$','2018-03-21','07:10:29',1575.00,1575.00,'G$'),(7537,'01','P$','2018-03-21','07:10:45',230.00,230.00,'G$'),(7558,'01','U$','2018-03-22','07:16:55',5330.00,5330.00,'G$'),(7559,'01','R$','2018-03-22','07:17:14',1590.00,1590.00,'G$'),(7607,'01','R$','2018-03-24','07:55:40',1580.00,1580.00,'G$'),(7621,'01','U$','2018-03-26','08:01:30',5330.00,5330.00,'G$'),(7622,'01','R$','2018-03-26','08:01:48',1575.00,1575.00,'G$'),(7623,'01','P$','2018-03-26','08:04:21',235.00,235.00,'G$'),(7640,'01','P$','2018-03-27','07:03:02',230.00,230.00,'G$'),(7661,'01','U$','2018-03-28','07:00:52',5325.00,5325.00,'G$'),(7662,'01','R$','2018-03-28','07:01:20',1580.00,1580.00,'G$'),(7690,'01','U$','2018-03-31','08:13:35',5310.00,5310.00,'G$'),(7691,'01','R$','2018-03-31','08:14:05',1550.00,1550.00,'G$'),(7710,'01','U$','2018-04-02','08:01:18',5315.00,5315.00,'G$'),(7733,'01','U$','2018-04-03','07:10:12',5310.00,5310.00,'G$'),(7749,'01','U$','2018-04-04','07:05:00',5320.00,5320.00,'G$'),(7780,'01','U$','2018-04-05','07:03:43',5325.00,5325.00,'G$'),(7804,'01','P$','2018-04-06','07:13:02',235.00,235.00,'G$'),(7808,'01','R$','2018-04-06','07:44:35',1560.00,1560.00,'G$'),(7830,'01','U$','2018-04-07','07:03:11',5310.00,5310.00,'G$'),(7834,'01','R$','2018-04-07','07:16:38',1540.00,1540.00,'G$'),(7865,'01','U$','2018-04-10','06:51:55',5300.00,5300.00,'G$'),(7866,'01','R$','2018-04-10','06:52:12',1510.00,1510.00,'G$'),(7867,'01','P$','2018-04-10','06:52:27',230.00,230.00,'G$'),(7890,'01','P$','2018-04-11','07:02:18',235.00,235.00,'G$'),(7891,'01','U$','2018-04-11','07:02:36',5310.00,5310.00,'G$'),(7892,'01','R$','2018-04-11','07:02:53',1505.00,1505.00,'G$'),(7915,'01','U$','2018-04-12','07:03:59',5315.00,5315.00,'G$'),(7916,'01','R$','2018-04-12','07:04:29',1520.00,1520.00,'G$'),(7935,'01','U$','2018-04-13','07:03:10',5320.00,5320.00,'G$'),(7958,'01','R$','2018-04-14','06:59:38',1510.00,1510.00,'G$'),(7960,'01','U$','2018-04-14','06:59:58',5315.00,5315.00,'G$'),(8019,'01','U$','2018-04-18','07:09:27',5310.00,5310.00,'G$'),(8020,'01','R$','2018-04-18','07:09:43',1515.00,1515.00,'G$'),(8041,'01','R$','2018-04-19','07:07:15',1525.00,1525.00,'G$'),(8042,'01','U$','2018-04-19','07:07:30',5315.00,5315.00,'G$'),(8057,'01','U$','2018-04-20','07:15:59',5325.00,5325.00,'G$'),(8058,'01','R$','2018-04-20','07:16:20',1515.00,1515.00,'G$'),(8087,'01','R$','2018-04-21','07:03:01',1510.00,1510.00,'G$'),(8088,'01','U$','2018-04-21','07:03:21',5320.00,5320.00,'G$'),(8133,'01','R$','2018-04-24','07:10:33',1490.00,1490.00,'G$'),(8156,'01','U$','2018-04-25','07:17:28',5325.00,5325.00,'G$'),(8177,'01','U$','2018-04-26','07:06:25',5330.00,5330.00,'G$'),(8178,'01','R$','2018-04-26','07:07:17',1480.00,1480.00,'G$'),(8197,'01','U$','2018-04-27','06:57:06',5335.00,5335.00,'G$'),(8198,'01','R$','2018-04-27','06:57:26',1490.00,1490.00,'G$'),(8227,'01','R$','2018-04-28','07:08:17',1495.00,1495.00,'G$'),(8228,'01','P$','2018-04-28','07:08:37',230.00,230.00,'G$'),(8274,'01','R$','2018-05-02','07:06:44',1480.00,1480.00,'G$'),(8275,'01','U$','2018-05-02','07:07:07',5330.00,5330.00,'G$'),(8298,'01','R$','2018-05-03','07:15:40',1460.00,1460.00,'G$'),(8299,'01','P$','2018-05-03','07:15:58',225.00,225.00,'G$'),(8300,'01','U$','2018-05-03','07:16:16',5335.00,5335.00,'G$'),(8316,'01','P$','2018-05-04','07:02:56',200.00,200.00,'G$'),(8317,'01','R$','2018-05-04','07:03:25',1450.00,1450.00,'G$'),(8321,'01','U$','2018-05-04','07:03:50',5340.00,5340.00,'G$'),(8351,'01','U$','2018-05-05','07:02:23',5350.00,5350.00,'G$'),(8352,'01','R$','2018-05-05','07:02:53',1475.00,1475.00,'G$'),(8353,'01','P$','2018-05-05','07:04:07',205.00,205.00,'G$'),(8374,'01','P$','2018-05-07','07:27:15',210.00,210.00,'G$'),(8375,'01','R$','2018-05-07','07:27:37',1480.00,1480.00,'G$'),(8398,'01','P$','2018-05-08','07:00:24',215.00,215.00,'G$'),(8400,'01','R$','2018-05-08','07:00:50',1450.00,1450.00,'G$'),(8417,'01','P$','2018-05-09','06:59:47',205.00,205.00,'G$'),(8449,'01','U$','2018-05-10','08:12:02',5370.00,5370.00,'G$'),(8468,'01','P$','2018-05-11','07:05:53',1455.00,1455.00,'G$'),(8469,'01','P$','2018-05-11','07:11:47',205.00,205.00,'G$'),(8470,'01','R$','2018-05-11','07:12:09',1455.00,1455.00,'G$'),(8495,'01','P$','2018-05-12','07:03:57',195.00,195.00,'G$'),(8496,'01','U$','2018-05-12','07:04:24',5360.00,5360.00,'G$'),(8522,'01','P$','2018-05-16','07:27:39',170.00,170.00,'G$'),(8523,'01','P$','2018-05-16','07:27:57',1400.00,1400.00,'G$'),(8526,'01','P$','2018-05-16','07:33:24',170.00,170.00,'G$'),(8527,'01','R$','2018-05-16','07:33:41',1400.00,1400.00,'G$'),(8546,'01','P$','2018-05-17','07:06:39',185.00,185.00,'G$'),(8547,'01','R$','2018-05-17','07:07:06',1410.00,1410.00,'G$'),(8548,'01','U$','2018-05-17','07:07:34',5390.00,5390.00,'G$'),(8567,'01','U$','2018-05-18','07:04:30',5400.00,5400.00,'G$'),(8616,'01','P$','2018-05-21','07:20:56',180.00,180.00,'G$'),(8617,'01','R$','2018-05-21','07:21:51',1400.00,1400.00,'G$'),(8618,'01','U$','2018-05-21','07:22:16',5430.00,5430.00,'G$'),(8637,'01','P$','2018-05-22','07:01:37',185.00,185.00,'G$'),(8638,'01','R$','2018-05-22','07:03:25',1415.00,1415.00,'G$'),(8639,'01','U$','2018-05-22','07:03:49',5420.00,5420.00,'G$'),(8655,'01','U$','2018-05-23','06:55:33',5430.00,5430.00,'G$'),(8656,'01','R$','2018-05-23','06:56:29',1435.00,1435.00,'G$'),(8676,'01','P$','2018-05-24','07:05:59',190.00,190.00,'G$'),(8677,'01','R$','2018-05-24','07:06:20',1445.00,1445.00,'G$'),(8693,'01','U$','2018-05-25','07:08:19',5480.00,5480.00,'G$'),(8694,'01','R$','2018-05-25','07:08:34',1450.00,1450.00,'G$'),(8717,'01','R$','2018-05-26','07:19:10',1435.00,1435.00,'G$'),(8718,'01','U$','2018-05-26','07:19:34',5460.00,5460.00,'G$'),(8738,'01','R$','2018-05-28','07:04:48',1440.00,1440.00,'G$'),(8760,'01','U$','2018-05-29','07:06:07',5490.00,5490.00,'G$'),(8761,'01','R$','2018-05-29','07:06:29',1420.00,1420.00,'G$'),(8789,'01','U$','2018-05-30','07:00:58',5420.00,5420.00,'G$'),(8790,'01','U$','2018-05-30','07:05:57',5520.00,5520.00,'G$'),(8791,'01','P$','2018-05-30','07:06:13',185.00,185.00,'G$'),(8813,'01','U$','2018-05-31','07:05:48',5510.00,5510.00,'G$'),(8814,'01','P$','2018-05-31','07:06:17',190.00,190.00,'G$'),(8815,'01','R$','2018-05-31','07:06:58',1425.00,1425.00,'G$'),(8836,'01','U$','2018-06-01','07:10:42',5515.00,5515.00,'G$'),(8837,'01','R$','2018-06-01','07:11:01',1430.00,1430.00,'G$'),(8861,'01','R$','2018-06-02','07:19:08',1410.00,1410.00,'G$'),(8862,'01','U$','2018-06-02','07:19:29',5500.00,5500.00,'G$'),(8879,'01','R$','2018-06-04','06:54:36',1420.00,1420.00,'G$'),(8901,'01','U$','2018-06-05','07:14:37',5460.00,5460.00,'G$'),(8902,'01','R$','2018-06-05','07:15:05',1415.00,1415.00,'G$'),(8921,'01','U$','2018-06-06','07:05:18',5490.00,5490.00,'G$'),(8922,'01','R$','2018-06-06','07:05:44',1385.00,1385.00,'G$'),(8946,'01','U$','2018-06-07','07:09:08',5500.00,5500.00,'G$'),(8947,'01','R$','2018-06-07','07:09:27',1390.00,1390.00,'G$'),(8948,'01','U$','2018-06-07','07:10:38',5470.00,5470.00,'G$'),(8974,'01','R$','2018-06-08','07:19:04',1340.00,1340.00,'G$'),(8975,'01','U$','2018-06-08','07:19:22',5450.00,5450.00,'G$'),(8999,'01','U$','2018-06-09','07:08:07',5460.00,5460.00,'G$'),(9000,'01','R$','2018-06-09','07:08:27',1400.00,1400.00,'G$'),(9003,'01','P$','2018-06-09','07:19:40',185.00,185.00,'G$'),(9022,'01','U$','2018-06-11','07:00:52',5470.00,5470.00,'G$'),(9023,'01','R$','2018-06-11','07:01:10',1415.00,1415.00,'G$'),(9034,'01','U$','2018-06-12','07:05:26',5520.00,5520.00,'G$'),(9035,'01','R$','2018-06-12','07:05:49',1435.00,1435.00,'G$'),(9042,'01','P$','2018-06-12','07:10:10',190.00,190.00,'G$'),(9043,'01','R$','2018-06-12','07:10:29',1425.00,1425.00,'G$'),(9044,'01','U$','2018-06-12','07:10:44',5470.00,5470.00,'G$'),(9067,'01','P$','2018-06-13','07:07:48',180.00,180.00,'G$'),(9068,'01','U$','2018-06-13','07:08:09',5460.00,5460.00,'G$'),(9069,'01','R$','2018-06-13','07:08:25',1410.00,1410.00,'G$'),(9094,'01','P$','2018-06-14','07:06:47',175.00,175.00,'G$'),(9095,'01','R$','2018-06-14','07:07:10',1420.00,1420.00,'G$'),(9097,'01','U$','2018-06-14','07:07:30',5470.00,5470.00,'G$'),(9116,'01','R$','2018-06-15','07:09:00',1370.00,1370.00,'G$'),(9117,'01','P$','2018-06-15','07:10:14',165.00,165.00,'G$'),(9141,'01','R$','2018-06-16','07:04:09',1390.00,1390.00,'G$'),(9142,'01','P$','2018-06-16','07:04:30',160.00,160.00,'G$'),(9167,'01','P$','2018-06-18','07:30:30',165.00,165.00,'G$'),(9168,'01','R$','2018-06-18','07:30:50',1405.00,1405.00,'G$'),(9169,'01','U$','2018-06-18','07:31:09',5475.00,5475.00,'G$'),(9191,'01','P$','2018-06-19','07:08:28',160.00,160.00,'G$'),(9192,'01','R$','2018-06-19','07:10:20',1390.00,1390.00,'G$'),(9193,'01','U$','2018-06-19','07:10:39',5470.00,5470.00,'G$'),(9215,'01','U$','2018-06-20','07:07:00',5490.00,5490.00,'G$'),(9216,'01','R$','2018-06-20','07:07:15',1405.00,1405.00,'G$'),(9217,'01','P$','2018-06-20','07:07:31',165.00,165.00,'G$'),(9244,'01','U$','2018-06-21','07:07:05',5500.00,5500.00,'G$'),(9245,'01','R$','2018-06-21','07:07:22',1400.00,1400.00,'G$'),(9271,'01','U$','2018-06-22','07:07:37',5510.00,5510.00,'G$'),(9272,'01','R$','2018-06-22','07:07:58',1380.00,1380.00,'G$'),(9273,'01','P$','2018-06-22','07:08:33',170.00,170.00,'G$'),(9298,'01','U$','2018-06-23','07:16:29',5490.00,5490.00,'G$'),(9299,'01','R$','2018-06-23','07:16:49',1400.00,1400.00,'G$'),(9375,'01','U$','2018-06-28','07:04:09',5500.00,5500.00,'G$'),(9376,'01','R$','2018-06-28','07:04:26',1370.00,1370.00,'G$'),(9403,'01','P$','2018-06-29','07:10:58',165.00,165.00,'G$'),(9404,'01','U$','2018-06-29','07:11:46',5510.00,5510.00,'G$'),(9405,'01','R$','2018-06-29','07:12:11',1390.00,1390.00,'G$'),(9424,'01','U$','2018-06-30','07:05:45',5490.00,5490.00,'G$'),(9425,'01','R$','2018-06-30','07:06:06',1370.00,1370.00,'G$'),(9426,'01','P$','2018-06-30','07:06:23',160.00,160.00,'G$'),(9449,'01','R$','2018-07-02','06:59:13',1350.00,1350.00,'G$'),(9450,'01','U$','2018-07-02','06:59:30',5520.00,5520.00,'G$'),(9459,'01','R$','2018-07-02','07:23:12',1360.00,1360.00,'G$'),(9460,'01','U$','2018-07-02','07:23:30',5500.00,5500.00,'G$'),(9472,'01','P$','2018-07-03','07:05:09',165.00,165.00,'G$'),(9473,'01','R$','2018-07-03','07:05:35',1350.00,1350.00,'G$'),(9474,'01','U$','2018-07-03','07:06:00',5490.00,5490.00,'G$'),(9504,'01','U$','2018-07-04','07:08:18',5500.00,5500.00,'G$'),(9505,'01','R$','2018-07-04','07:08:41',1370.00,1370.00,'G$'),(9524,'01','R$','2018-07-05','07:03:35',1350.00,1350.00,'G$'),(9552,'01','U$','2018-07-06','07:04:33',5510.00,5510.00,'G$'),(9553,'01','R$','2018-07-06','07:04:51',1340.00,1340.00,'G$'),(9578,'01','R$','2018-07-07','07:05:20',1355.00,1355.00,'G$'),(9598,'01','R$','2018-07-09','07:07:11',1365.00,1365.00,'G$'),(9617,'01','U$','2018-07-10','06:58:27',5500.00,5500.00,'G$'),(9618,'01','R$','2018-07-10','06:58:48',1350.00,1350.00,'G$'),(9645,'01','U$','2018-07-11','07:03:56',5470.00,5470.00,'G$'),(9646,'01','R$','2018-07-11','07:04:29',1370.00,1370.00,'G$'),(9647,'01','P$','2018-07-11','07:06:03',170.00,170.00,'G$'),(9674,'01','P$','2018-07-12','07:15:50',165.00,165.00,'G$'),(9675,'01','U$','2018-07-12','07:16:07',5490.00,5490.00,'G$'),(9696,'01','U$','2018-07-13','07:05:41',5500.00,5500.00,'G$'),(9697,'01','R$','2018-07-13','07:05:59',1360.00,1360.00,'G$'),(9717,'01','R$','2018-07-14','07:06:42',1370.00,1370.00,'G$'),(9730,'01','U$','2018-07-16','07:04:13',5490.00,5490.00,'G$'),(9731,'01','R$','2018-07-16','07:04:28',1370.00,1370.00,'G$'),(9755,'01','U$','2018-07-17','06:59:23',5480.00,5480.00,'G$'),(9781,'01','U$','2018-07-18','07:07:07',5500.00,5500.00,'G$'),(9782,'01','R$','2018-07-18','07:07:29',1375.00,1375.00,'G$'),(9805,'01','U$','2018-07-19','07:03:26',5510.00,5510.00,'G$'),(9806,'01','R$','2018-07-19','07:03:40',1370.00,1370.00,'G$'),(9835,'01','U$','2018-07-20','07:10:56',5520.00,5520.00,'G$'),(9854,'01','R$','2018-07-21','06:59:01',1400.00,1400.00,'G$'),(9881,'01','U$','2018-07-23','07:14:41',5500.00,5500.00,'G$'),(9901,'01','R$','2018-07-24','07:03:16',1380.00,1380.00,'G$'),(9917,'01','U$','2018-07-25','07:02:56',5520.00,5520.00,'G$'),(9918,'01','R$','2018-07-25','07:03:17',1410.00,1410.00,'G$'),(9946,'01','R$','2018-07-26','07:06:38',1430.00,1430.00,'G$'),(9947,'01','P$','2018-07-26','07:07:21',170.00,170.00,'G$'),(9973,'01','R$','2018-07-27','07:09:56',1425.00,1425.00,'G$'),(9996,'01','U$','2018-07-28','07:08:07',5525.00,5525.00,'G$'),(9997,'01','R$','2018-07-28','07:08:20',1420.00,1420.00,'G$'),(10023,'01','U$','2018-07-30','07:10:39',5530.00,5530.00,'G$'),(10061,'01','R$','2018-08-01','06:55:14',1415.00,1415.00,'G$'),(10081,'01','U$','2018-08-02','06:58:30',5545.00,5545.00,'G$'),(10084,'01','R$','2018-08-02','06:58:58',1400.00,1400.00,'G$'),(10121,'01','U$','2018-08-03','07:09:19',5540.00,5540.00,'G$'),(10122,'01','R$','2018-08-03','07:09:35',1410.00,1410.00,'G$'),(10154,'01','U$','2018-08-04','07:08:15',5530.00,5530.00,'G$'),(10155,'01','R$','2018-08-04','07:08:38',1420.00,1420.00,'G$'),(10173,'01','U$','2018-08-06','07:09:07',5540.00,5540.00,'G$'),(10174,'01','R$','2018-08-06','07:09:26',1430.00,1430.00,'G$'),(10197,'01','R$','2018-08-07','07:17:50',1420.00,1420.00,'G$'),(10226,'01','R$','2018-08-08','07:10:37',1410.00,1410.00,'G$'),(10227,'01','P$','2018-08-08','07:11:43',175.00,175.00,'G$'),(10245,'01','U$','2018-08-09','07:03:55',5550.00,5550.00,'G$'),(10246,'01','R$','2018-08-09','07:04:15',1420.00,1420.00,'G$'),(10278,'01','R$','2018-08-10','07:04:03',1400.00,1400.00,'G$'),(10279,'01','P$','2018-08-10','07:04:34',170.00,170.00,'G$'),(10297,'01','P$','2018-08-11','07:03:16',160.00,160.00,'G$'),(10298,'01','R$','2018-08-11','07:03:46',1380.00,1380.00,'G$'),(10320,'01','P$','2018-08-13','07:05:12',165.00,165.00,'G$'),(10344,'01','U$','2018-08-14','07:09:35',5550.00,5550.00,'G$'),(10345,'01','R$','2018-08-14','07:10:29',1370.00,1370.00,'G$'),(10346,'01','P$','2018-08-14','07:10:52',155.00,155.00,'G$'),(10361,'01','R$','2018-08-15','07:10:33',1365.00,1365.00,'G$'),(10363,'01','P$','2018-08-15','07:12:36',160.00,160.00,'G$'),(10378,'01','P$','2018-08-16','07:05:15',155.00,155.00,'G$'),(10379,'01','R$','2018-08-16','07:05:31',1350.00,1350.00,'G$'),(10405,'01','R$','2018-08-17','08:13:33',1360.00,1360.00,'G$'),(10406,'01','U$','2018-08-17','08:13:52',5560.00,5560.00,'G$'),(10431,'01','P$','2018-08-18','07:14:39',160.00,160.00,'G$'),(10447,'01','U$','2018-08-20','07:04:50',5570.00,5570.00,'G$'),(10470,'01','U$','2018-08-21','07:13:30',5580.00,5580.00,'G$'),(10471,'01','R$','2018-08-21','07:13:57',1345.00,1345.00,'G$'),(10492,'01','U$','2018-08-22','07:03:11',5590.00,5590.00,'G$'),(10493,'01','R$','2018-08-22','07:03:28',1330.00,1330.00,'G$'),(10518,'01','P$','2018-08-23','07:08:02',157.00,157.00,'G$'),(10523,'01','R$','2018-08-23','08:00:27',1310.00,1310.00,'G$'),(10524,'01','U$','2018-08-23','08:00:53',5600.00,5600.00,'G$'),(10540,'01','P$','2018-08-24','07:00:30',155.00,155.00,'G$'),(10546,'01','R$','2018-08-24','07:30:53',1290.00,1290.00,'G$'),(10571,'01','P$','2018-08-25','07:06:00',150.00,150.00,'G$'),(10572,'01','R$','2018-08-25','07:06:19',1330.00,1330.00,'G$'),(10573,'01','U$','2018-08-25','07:06:52',5630.00,5630.00,'G$'),(10594,'01','U$','2018-08-27','07:05:30',5600.00,5600.00,'G$'),(10595,'01','P$','2018-08-27','07:06:05',155.00,155.00,'G$'),(10602,'01','R$','2018-08-27','09:10:39',1310.00,1310.00,'G$'),(10620,'01','P$','2018-08-28','07:02:54',150.00,150.00,'G$'),(10641,'01','U$','2018-08-29','07:10:10',5620.00,5620.00,'G$'),(10642,'01','R$','2018-08-29','07:10:37',1290.00,1290.00,'G$'),(10663,'01','P$','2018-08-30','06:57:13',135.00,135.00,'G$'),(10664,'01','R$','2018-08-30','06:57:49',1310.00,1310.00,'G$'),(10677,'01','P$','2018-08-30','11:08:28',120.00,120.00,'G$'),(10707,'01','P$','2018-08-31','09:39:35',115.00,115.00,'G$'),(10708,'01','U$','2018-08-31','09:39:55',5650.00,5650.00,'G$'),(10709,'01','R$','2018-08-31','09:40:20',1290.00,1290.00,'G$'),(10728,'01','P$','2018-09-01','07:07:25',125.00,125.00,'G$'),(10729,'01','R$','2018-09-01','07:07:49',1320.00,1320.00,'G$'),(10730,'01','U$','2018-09-01','07:08:11',5640.00,5640.00,'G$'),(10746,'01','P$','2018-09-03','07:04:39',120.00,120.00,'G$'),(10747,'01','U$','2018-09-03','07:05:09',5630.00,5630.00,'G$'),(10748,'01','R$','2018-09-03','07:05:36',1310.00,1310.00,'G$'),(10777,'01','R$','2018-09-04','07:02:34',1295.00,1295.00,'G$'),(10800,'01','U$','2018-09-05','07:09:33',5640.00,5640.00,'G$'),(10816,'01','P$','2018-09-06','07:03:49',125.00,125.00,'G$'),(10817,'01','R$','2018-09-06','07:04:10',1310.00,1310.00,'G$'),(10819,'01','U$','2018-09-06','07:05:50',5655.00,5655.00,'G$'),(10841,'01','U$','2018-09-07','07:06:10',5650.00,5650.00,'G$'),(10842,'01','R$','2018-09-07','07:06:29',1330.00,1330.00,'G$'),(10866,'01','P$','2018-09-08','07:08:48',130.00,130.00,'G$'),(10886,'01','R$','2018-09-10','07:07:23',1325.00,1325.00,'G$'),(10888,'01','U$','2018-09-10','07:11:01',5640.00,5640.00,'G$'),(10907,'01','R$','2018-09-11','06:55:37',1310.00,1310.00,'G$'),(10908,'01','P$','2018-09-11','06:56:04',125.00,125.00,'G$'),(10932,'01','P$','2018-09-12','07:03:00',123.00,123.00,'G$'),(10933,'01','R$','2018-09-12','07:03:20',1300.00,1300.00,'G$'),(10934,'01','U$','2018-09-12','07:03:42',5650.00,5650.00,'G$'),(10955,'01','R$','2018-09-13','07:00:38',1310.00,1310.00,'G$'),(10956,'01','P$','2018-09-13','07:00:57',120.00,120.00,'G$'),(10984,'01','P$','2018-09-14','07:03:24',116.00,116.00,'G$'),(10985,'01','U$','2018-09-14','07:10:59',5670.00,5670.00,'G$'),(10986,'01','R$','2018-09-14','07:11:19',1300.00,1300.00,'G$'),(11013,'01','R$','2018-09-15','07:03:14',1315.00,1315.00,'G$'),(11014,'01','P$','2018-09-15','07:03:57',117.00,117.00,'G$'),(11035,'01','R$','2018-09-17','07:17:36',1315.00,1315.00,'G$'),(11038,'01','P$','2018-09-17','07:17:57',116.00,116.00,'G$'),(11040,'01','U$','2018-09-17','07:18:15',5650.00,5650.00,'G$'),(11058,'01','R$','2018-09-18','07:07:57',1290.00,1290.00,'G$'),(11059,'01','P$','2018-09-18','07:08:11',115.00,115.00,'G$'),(11084,'01','P$','2018-09-19','07:08:01',117.00,117.00,'G$'),(11085,'01','R$','2018-09-19','07:08:16',1310.00,1310.00,'G$'),(11086,'01','U$','2018-09-19','07:08:36',5660.00,5660.00,'G$'),(11104,'01','U$','2018-09-20','07:04:49',5670.00,5670.00,'G$'),(11105,'01','P$','2018-09-20','07:05:07',120.00,120.00,'G$'),(11131,'01','R$','2018-09-21','07:07:53',1335.00,1335.00,'G$'),(11153,'01','P$','2018-09-22','06:59:01',126.00,126.00,'G$'),(11154,'01','R$','2018-09-22','06:59:21',1340.00,1340.00,'G$'),(11192,'01','P$','2018-09-25','07:11:06',125.00,125.00,'G$'),(11193,'01','R$','2018-09-25','07:11:32',1330.00,1330.00,'G$'),(11212,'01','P$','2018-09-26','07:07:42',120.00,120.00,'G$'),(11213,'01','U$','2018-09-26','07:07:57',5690.00,5690.00,'G$'),(11236,'01','P$','2018-09-27','07:11:07',123.00,123.00,'G$'),(11237,'01','U$','2018-09-27','07:11:26',5710.00,5710.00,'G$'),(11240,'01','R$','2018-09-27','07:11:54',1350.00,1350.00,'G$'),(11263,'01','P$','2018-09-28','07:06:22',120.00,120.00,'G$'),(11264,'01','R$','2018-09-28','07:06:43',1355.00,1355.00,'G$'),(11268,'01','U$','2018-09-28','07:37:32',5720.00,5720.00,'G$'),(11287,'01','P$','2018-09-29','07:11:33',115.00,115.00,'G$'),(11288,'01','U$','2018-09-29','07:11:51',5690.00,5690.00,'G$'),(11289,'01','R$','2018-09-29','07:12:10',1345.00,1345.00,'G$'),(11326,'01','P$','2018-10-02','07:08:54',120.00,120.00,'G$'),(11327,'01','U$','2018-10-02','07:09:12',5700.00,5700.00,'G$'),(11328,'01','R$','2018-10-02','07:09:33',1355.00,1355.00,'G$'),(11353,'01','P$','2018-10-03','07:05:22',125.00,125.00,'G$'),(11354,'01','R$','2018-10-03','07:05:51',1385.00,1385.00,'G$'),(11355,'01','U$','2018-10-03','07:06:24',5710.00,5710.00,'G$'),(11381,'01','P$','2018-10-04','07:03:40',128.00,128.00,'G$'),(11382,'01','R$','2018-10-04','07:04:17',1430.00,1430.00,'G$'),(11407,'01','P$','2018-10-05','07:07:18',123.00,123.00,'G$'),(11408,'01','U$','2018-10-05','07:07:48',5720.00,5720.00,'G$'),(11409,'01','R$','2018-10-05','07:08:12',1425.00,1425.00,'G$'),(11433,'01','P$','2018-10-06','07:03:39',126.00,126.00,'G$'),(11434,'01','R$','2018-10-06','07:04:04',1430.00,1430.00,'G$'),(11435,'01','U$','2018-10-06','07:05:02',5710.00,5710.00,'G$'),(11451,'01','R$','2018-10-08','06:57:30',1420.00,1420.00,'G$'),(11452,'01','U$','2018-10-08','06:58:00',5725.00,5725.00,'G$'),(11455,'01','P$','2018-10-08','07:17:37',125.00,125.00,'G$'),(11480,'01','P$','2018-10-09','07:07:34',127.00,127.00,'G$'),(11481,'01','R$','2018-10-09','07:07:55',1460.00,1460.00,'G$'),(11482,'01','U$','2018-10-09','07:08:21',5710.00,5710.00,'G$'),(11506,'01','R$','2018-10-10','07:14:50',1470.00,1470.00,'G$'),(11507,'01','P$','2018-10-10','07:15:09',130.00,130.00,'G$'),(11508,'01','U$','2018-10-10','07:15:25',5730.00,5730.00,'G$'),(11528,'01','R$','2018-10-11','07:08:11',1470.00,1470.00,'G$'),(11529,'01','U$','2018-10-11','07:08:28',5735.00,5735.00,'G$'),(11549,'01','U$','2018-10-12','07:03:48',5750.00,5750.00,'G$'),(11572,'01','R$','2018-10-13','07:23:03',1460.00,1460.00,'G$'),(11573,'01','U$','2018-10-13','07:23:26',5770.00,5770.00,'G$'),(11597,'01','U$','2018-10-15','07:55:04',5760.00,5760.00,'G$'),(11632,'01','R$','2018-10-17','07:17:51',1480.00,1480.00,'G$'),(11654,'01','R$','2018-10-18','07:15:15',1500.00,1500.00,'G$'),(11655,'01','U$','2018-10-18','07:15:35',5790.00,5790.00,'G$'),(11683,'01','R$','2018-10-19','07:15:07',1490.00,1490.00,'G$'),(11704,'01','U$','2018-10-20','07:06:59',5800.00,5800.00,'G$'),(11705,'01','R$','2018-10-20','07:07:31',1495.00,1495.00,'G$'),(11726,'01','R$','2018-10-22','07:05:44',1505.00,1505.00,'G$'),(11754,'01','P$','2018-10-23','07:09:38',135.00,135.00,'G$'),(11755,'01','U$','2018-10-23','07:11:22',5820.00,5820.00,'G$'),(11756,'01','R$','2018-10-23','07:11:36',1510.00,1510.00,'G$'),(11763,'01','U$','2018-10-23','14:40:50',5990.00,5990.00,'G$'),(11764,'01','U$','2018-10-23','16:47:19',5820.00,5820.00,'G$'),(11769,'01','R$','2018-10-24','07:00:29',1500.00,1500.00,'G$'),(11791,'01','U$','2018-10-25','06:59:17',5830.00,5830.00,'G$'),(11792,'01','R$','2018-10-25','06:59:31',1495.00,1495.00,'G$'),(11819,'01','R$','2018-10-26','07:05:04',1515.00,1515.00,'G$'),(11820,'01','U$','2018-10-26','07:13:49',5850.00,5850.00,'G$'),(11846,'01','R$','2018-10-27','08:05:38',1530.00,1530.00,'G$'),(11881,'01','R$','2018-10-30','07:02:29',1510.00,1510.00,'G$'),(11882,'01','U$','2018-10-30','07:02:49',5830.00,5830.00,'G$'),(11900,'01','R$','2018-10-31','07:07:19',1500.00,1500.00,'G$'),(11949,'01','U$','2018-11-02','07:14:36',5800.00,5800.00,'G$'),(11950,'01','R$','2018-11-02','07:14:50',1505.00,1505.00,'G$'),(11951,'01','P$','2018-11-02','07:15:09',140.00,140.00,'G$'),(11973,'01','R$','2018-11-03','07:02:13',1500.00,1500.00,'G$'),(12026,'01','U$','2018-11-06','07:08:14',5780.00,5780.00,'G$'),(12053,'01','U$','2018-11-07','08:01:54',5750.00,5750.00,'G$'),(12054,'01','R$','2018-11-07','08:02:16',1470.00,1470.00,'G$'),(12071,'01','U$','2018-11-08','07:15:47',5740.00,5740.00,'G$'),(12149,'01','U$','2018-11-13','07:06:49',5750.00,5750.00,'G$'),(12170,'01','P$','2018-11-14','10:27:28',135.00,135.00,'G$'),(12171,'01','R$','2018-11-14','10:27:41',1450.00,1450.00,'G$'),(12198,'01','R$','2018-11-15','07:30:15',1465.00,1465.00,'G$'),(12220,'01','R$','2018-11-16','07:07:15',1460.00,1460.00,'G$'),(12221,'01','U$','2018-11-16','07:07:29',5740.00,5740.00,'G$'),(12244,'01','R$','2018-11-17','07:08:32',1470.00,1470.00,'G$'),(12245,'01','U$','2018-11-17','07:09:15',5730.00,5730.00,'G$'),(12265,'01','U$','2018-11-19','07:09:41',5720.00,5720.00,'G$'),(12290,'01','R$','2018-11-20','07:25:00',1465.00,1465.00,'G$'),(12306,'01','R$','2018-11-21','07:08:03',1460.00,1460.00,'G$'),(12333,'01','U$','2018-11-22','07:09:22',5740.00,5740.00,'G$'),(12334,'01','R$','2018-11-22','07:10:06',1450.00,1450.00,'G$'),(12378,'01','P$','2018-11-24','07:02:43',130.00,130.00,'G$'),(12379,'01','R$','2018-11-24','07:03:08',1445.00,1445.00,'G$'),(12380,'01','U$','2018-11-24','07:03:51',5750.00,5750.00,'G$'),(12396,'01','R$','2018-11-26','07:06:50',1450.00,1450.00,'G$'),(12415,'01','P$','2018-11-27','07:01:02',125.00,125.00,'G$'),(12417,'01','R$','2018-11-27','07:01:19',1400.00,1400.00,'G$'),(12439,'01','P$','2018-11-28','07:06:10',127.00,127.00,'G$'),(12440,'01','R$','2018-11-28','07:06:35',1430.00,1430.00,'G$'),(12441,'01','U$','2018-11-28','07:06:59',5760.00,5760.00,'G$'),(12460,'01','P$','2018-11-29','07:23:48',130.00,130.00,'G$'),(12461,'01','R$','2018-11-29','07:24:08',1440.00,1440.00,'G$'),(12462,'01','U$','2018-11-29','07:24:30',5765.00,5765.00,'G$'),(12483,'01','R$','2018-11-30','07:19:25',1430.00,1430.00,'G$'),(12484,'01','U$','2018-11-30','07:19:46',5740.00,5740.00,'G$'),(12501,'01','R$','2018-12-01','07:04:41',1435.00,1435.00,'G$'),(12540,'01','U$','2018-12-04','07:27:37',5700.00,5700.00,'G$'),(12541,'01','R$','2018-12-04','07:27:52',1445.00,1445.00,'G$'),(12550,'01','U$','2018-12-05','07:01:43',5710.00,5710.00,'G$'),(12568,'01','R$','2018-12-06','07:04:11',1420.00,1420.00,'G$'),(12590,'01','U$','2018-12-07','07:12:46',5720.00,5720.00,'G$'),(12591,'01','R$','2018-12-07','07:13:22',1415.00,1415.00,'G$'),(12613,'01','U$','2018-12-10','07:09:13',5700.00,5700.00,'G$'),(12628,'01','U$','2018-12-11','06:59:32',5730.00,5730.00,'G$'),(12631,'01','P$','2018-12-11','06:59:51',1400.00,1400.00,'G$'),(12636,'01','P$','2018-12-11','07:12:31',130.00,130.00,'G$'),(12637,'01','R$','2018-12-11','07:12:46',1400.00,1400.00,'G$'),(12655,'01','U$','2018-12-12','07:12:18',5740.00,5740.00,'G$'),(12656,'01','R$','2018-12-12','07:12:35',1420.00,1420.00,'G$'),(12675,'01','R$','2018-12-13','07:00:37',1435.00,1435.00,'G$'),(12697,'01','P$','2018-12-14','07:01:37',125.00,125.00,'G$'),(12699,'01','U$','2018-12-14','07:01:55',5720.00,5720.00,'G$'),(12704,'01','R$','2018-12-14','07:48:51',1420.00,1420.00,'G$'),(12731,'01','R$','2018-12-15','07:05:39',1420.00,1420.00,'G$'),(12732,'01','U$','2018-12-15','07:06:05',5710.00,5710.00,'G$'),(12757,'01','R$','2018-12-17','07:11:00',1410.00,1410.00,'G$'),(12758,'01','U$','2018-12-17','07:12:19',5700.00,5700.00,'G$'),(12759,'01','P$','2018-12-17','07:12:34',120.00,120.00,'G$'),(12773,'01','R$','2018-12-18','07:02:46',1415.00,1415.00,'G$'),(12795,'01','U$','2018-12-19','07:03:43',5710.00,5710.00,'G$'),(12834,'01','R$','2018-12-21','06:59:36',1430.00,1430.00,'G$'),(12836,'01','U$','2018-12-21','07:00:07',5700.00,5700.00,'G$'),(12860,'01','R$','2018-12-22','07:14:09',1410.00,1410.00,'G$'),(12880,'01','U$','2018-12-24','07:32:11',5650.00,5650.00,'G$'),(12891,'01','U$','2018-12-26','07:05:53',5600.00,5600.00,'G$'),(12914,'01','P$','2018-12-27','07:20:41',115.00,115.00,'G$'),(12915,'01','R$','2018-12-27','07:21:09',1420.00,1420.00,'G$'),(12916,'01','U$','2018-12-27','07:22:13',5700.00,5700.00,'G$'),(12931,'01','U$','2018-12-28','07:02:37',5740.00,5740.00,'G$'),(12932,'01','R$','2018-12-28','07:03:03',1430.00,1430.00,'G$'),(12967,'01','U$','2018-12-29','07:21:57',5650.00,5650.00,'G$'),(12968,'01','R$','2018-12-29','07:22:12',1420.00,1420.00,'G$'),(12980,'01','R$','2018-12-31','07:02:54',1400.00,1400.00,'G$'),(12981,'01','U$','2018-12-31','07:03:21',5660.00,5660.00,'G$'),(12996,'01','U$','2019-01-02','06:59:26',5550.00,5550.00,'G$'),(13022,'01','U$','2019-01-03','07:05:35',5750.00,5750.00,'G$'),(13023,'01','R$','2019-01-03','07:05:56',1445.00,1445.00,'G$'),(13049,'01','R$','2019-01-04','07:11:19',1480.00,1480.00,'G$'),(13050,'01','P$','2019-01-04','07:11:34',120.00,120.00,'G$'),(13070,'01','R$','2019-01-05','07:08:53',1500.00,1500.00,'G$'),(13071,'01','U$','2019-01-05','07:09:11',5780.00,5780.00,'G$'),(13084,'01','U$','2019-01-07','07:01:26',5800.00,5800.00,'G$'),(13090,'01','R$','2019-01-07','07:11:25',1505.00,1505.00,'G$'),(13103,'01','U$','2019-01-08','06:55:09',5770.00,5770.00,'G$'),(13104,'01','R$','2019-01-08','06:55:42',1495.00,1495.00,'G$'),(13133,'01','U$','2019-01-09','07:06:03',5790.00,5790.00,'G$'),(13134,'01','R$','2019-01-09','07:06:39',1510.00,1510.00,'G$'),(13157,'01','P$','2019-01-10','07:02:09',125.00,125.00,'G$'),(13158,'01','R$','2019-01-10','07:02:29',1520.00,1520.00,'G$'),(13159,'01','U$','2019-01-10','07:03:06',5810.00,5810.00,'G$'),(13205,'01','U$','2019-01-12','07:14:07',5820.00,5820.00,'G$'),(13216,'01','R$','2019-01-14','06:54:50',1515.00,1515.00,'G$'),(13236,'01','R$','2019-01-15','07:04:02',1525.00,1525.00,'G$'),(13238,'01','U$','2019-01-15','07:04:23',5830.00,5830.00,'G$'),(13268,'01','P$','2019-01-16','07:19:36',128.00,128.00,'G$'),(13269,'01','R$','2019-01-16','07:19:57',1520.00,1520.00,'G$'),(13270,'01','U$','2019-01-16','07:20:19',5840.00,5840.00,'G$'),(13285,'01','P$','2019-01-17','07:19:41',127.00,127.00,'G$'),(13286,'01','U$','2019-01-17','07:20:44',5850.00,5850.00,'G$'),(13298,'01','P$','2019-01-18','07:00:40',125.00,125.00,'G$'),(13299,'01','R$','2019-01-18','07:01:04',1510.00,1510.00,'G$'),(13301,'01','U$','2019-01-18','07:01:29',5860.00,5860.00,'G$'),(13326,'01','P$','2019-01-19','07:03:28',125.00,125.00,'G$'),(13327,'01','R$','2019-01-19','07:04:46',1520.00,1520.00,'G$'),(13328,'01','U$','2019-01-19','07:05:04',5860.00,5860.00,'G$'),(13344,'01','P$','2019-01-21','07:03:53',127.00,127.00,'G$'),(13345,'01','R$','2019-01-21','07:04:12',1520.00,1520.00,'G$'),(13346,'01','U$','2019-01-21','07:04:40',5840.00,5840.00,'G$'),(13347,'01','U$','2019-01-21','07:05:01',5870.00,5870.00,'G$'),(13367,'01','P$','2019-01-22','07:08:14',125.00,125.00,'G$'),(13368,'01','R$','2019-01-22','07:08:33',1500.00,1500.00,'G$'),(13369,'01','U$','2019-01-22','07:08:52',5850.00,5850.00,'G$'),(13383,'01','P$','2019-01-23','07:05:30',125.00,125.00,'G$'),(13384,'01','R$','2019-01-23','07:05:52',1500.00,1500.00,'G$'),(13385,'01','U$','2019-01-23','07:06:23',5850.00,5850.00,'G$'),(13406,'01','P$','2019-01-24','07:05:22',130.00,130.00,'G$'),(13407,'01','R$','2019-01-24','07:05:46',1500.00,1500.00,'G$'),(13408,'01','U$','2019-01-24','07:06:08',5840.00,5840.00,'G$'),(13424,'01','R$','2019-01-25','07:03:05',1505.00,1505.00,'G$'),(13425,'01','U$','2019-01-25','07:03:31',5850.00,5850.00,'G$'),(13426,'01','P$','2019-01-25','07:03:53',130.00,130.00,'G$'),(13467,'01','R$','2019-01-28','07:11:16',1500.00,1500.00,'G$'),(13486,'01','R$','2019-01-29','07:05:49',1505.00,1505.00,'G$'),(13487,'01','U$','2019-01-29','07:06:20',5860.00,5860.00,'G$'),(13501,'01','R$','2019-01-30','07:07:52',1520.00,1520.00,'G$'),(13503,'01','U$','2019-01-30','07:08:14',5580.00,5880.00,'G$'),(13523,'01','U$','2019-01-30','17:56:06',5860.00,5860.00,'G$'),(13543,'01','R$','2019-02-01','07:07:08',1540.00,1540.00,'G$'),(13545,'01','U$','2019-02-01','07:07:30',5850.00,5850.00,'G$'),(13567,'01','U$','2019-02-02','07:04:04',5820.00,5820.00,'G$'),(13568,'01','R$','2019-02-02','07:04:24',1540.00,1540.00,'G$'),(13589,'01','U$','2019-02-04','07:21:25',5830.00,5830.00,'G$'),(13601,'01','R$','2019-02-05','07:05:34',1535.00,1535.00,'G$'),(13623,'01','U$','2019-02-06','07:09:25',5820.00,5820.00,'G$'),(13624,'01','R$','2019-02-06','07:09:43',1520.00,1520.00,'G$'),(13639,'01','R$','2019-02-07','07:10:31',1515.00,1515.00,'G$'),(13640,'01','U$','2019-02-07','07:10:52',5830.00,5830.00,'G$'),(13663,'01','R$','2019-02-08','07:11:41',1510.00,1510.00,'G$'),(13669,'01','R$','2019-02-09','07:09:33',1500.00,1500.00,'G$'),(13732,'01','U$','2019-02-13','09:07:49',5850.00,5850.00,'G$'),(13733,'01','R$','2019-02-13','09:08:21',1510.00,1510.00,'G$'),(13741,'01','R$','2019-02-14','07:23:10',1490.00,1490.00,'G$'),(13761,'01','R$','2019-02-15','07:27:21',1505.00,1505.00,'G$'),(13762,'01','U$','2019-02-15','07:27:46',5860.00,5860.00,'G$'),(13777,'01','R$','2019-02-16','07:18:10',1515.00,1515.00,'G$'),(13778,'01','U$','2019-02-16','07:18:39',5850.00,5850.00,'G$'),(13789,'01','U$','2019-02-18','07:44:02',5860.00,5860.00,'G$'),(13790,'01','P$','2019-02-18','07:45:26',130.00,130.00,'G$'),(13791,'01','R$','2019-02-18','07:45:43',1515.00,1515.00,'G$'),(13815,'01','P$','2019-02-19','07:14:33',125.00,125.00,'G$'),(13816,'01','R$','2019-02-19','07:14:59',1505.00,1505.00,'G$'),(13817,'01','U$','2019-02-19','07:15:20',5850.00,5850.00,'G$'),(13856,'01','P$','2019-02-21','07:27:46',120.00,120.00,'G$'),(13858,'01','R$','2019-02-21','07:28:06',1515.00,1515.00,'G$'),(13859,'01','U$','2019-02-21','07:28:24',5880.00,5880.00,'G$'),(13891,'01','P$','2019-02-23','08:08:55',125.00,125.00,'G$'),(13892,'01','U$','2019-02-23','08:09:19',5870.00,5870.00,'G$'),(13913,'01','U$','2019-02-25','08:21:12',5880.00,5880.00,'G$'),(13914,'01','R$','2019-02-25','08:21:35',1505.00,1505.00,'G$'),(13926,'01','U$','2019-02-26','07:30:17',5860.00,5860.00,'G$'),(13946,'01','R$','2019-02-27','07:56:05',1500.00,1500.00,'G$'),(13947,'01','U$','2019-02-27','07:56:43',5880.00,5880.00,'G$'),(13956,'01','P$','2019-02-28','07:30:50',130.00,130.00,'G$'),(13957,'01','R$','2019-02-28','07:31:10',1505.00,1505.00,'G$'),(13974,'01','P$','2019-03-01','07:24:19',125.00,125.00,'G$'),(13975,'01','R$','2019-03-01','07:24:37',1510.00,1510.00,'G$'),(13976,'01','U$','2019-03-01','07:24:57',5860.00,5860.00,'G$'),(13997,'01','R$','2019-03-02','07:38:01',1490.00,1490.00,'G$'),(13998,'01','U$','2019-03-02','07:38:24',5850.00,5850.00,'G$'),(14051,'01','P$','2019-03-07','07:35:27',120.00,120.00,'G$'),(14052,'01','R$','2019-03-07','07:35:44',1460.00,1460.00,'G$'),(14071,'01','P$','2019-03-08','07:47:03',115.00,115.00,'G$'),(14072,'01','R$','2019-03-08','07:47:26',1445.00,1445.00,'G$'),(14074,'01','U$','2019-03-08','07:47:46',5875.00,5875.00,'G$'),(14092,'01','P$','2019-03-09','07:33:13',120.00,120.00,'G$'),(14093,'01','R$','2019-03-09','07:33:34',1460.00,1460.00,'G$'),(14094,'01','U$','2019-03-09','07:34:06',5880.00,5880.00,'G$'),(14107,'01','R$','2019-03-11','07:24:51',1455.00,1455.00,'G$'),(14130,'01','R$','2019-03-12','08:06:03',1465.00,1465.00,'G$'),(14131,'01','U$','2019-03-12','08:06:32',5890.00,5890.00,'G$'),(14150,'01','R$','2019-03-13','07:44:28',1470.00,1470.00,'G$'),(14166,'01','U$','2019-03-14','08:06:29',5900.00,5900.00,'G$'),(14175,'01','R$','2019-03-15','07:08:42',1475.00,1475.00,'G$'),(14176,'01','U$','2019-03-15','07:09:01',5910.00,5910.00,'G$'),(14201,'01','P$','2019-03-16','07:27:34',123.00,123.00,'G$'),(14202,'01','R$','2019-03-16','07:27:53',1495.00,1495.00,'G$'),(14203,'01','U$','2019-03-16','07:28:13',5930.00,5930.00,'G$'),(14219,'01','P$','2019-03-18','07:35:10',120.00,120.00,'G$'),(14220,'01','R$','2019-03-18','07:35:27',1490.00,1490.00,'G$'),(14238,'01','U$','2019-03-19','07:42:19',5920.00,5920.00,'G$'),(14250,'01','U$','2019-03-20','07:07:10',5925.00,5925.00,'G$'),(14266,'01','R$','2019-03-21','07:12:09',1510.00,1510.00,'G$'),(14267,'01','U$','2019-03-21','07:12:29',5940.00,5940.00,'G$'),(14290,'01','R$','2019-03-22','07:56:43',1490.00,1490.00,'G$'),(14305,'01','R$','2019-03-23','07:45:11',1480.00,1480.00,'G$'),(14306,'01','U$','2019-03-23','07:45:35',5950.00,5950.00,'G$'),(14319,'01','R$','2019-03-25','08:14:25',1470.00,1470.00,'G$'),(14336,'01','U$','2019-03-26','07:05:28',5960.00,5960.00,'G$'),(14351,'01','P$','2019-03-27','07:24:52',115.00,115.00,'G$'),(14352,'01','U$','2019-03-27','07:25:28',5950.00,5950.00,'G$'),(14367,'01','R$','2019-03-28','08:28:09',1440.00,1440.00,'G$'),(14368,'01','U$','2019-03-28','08:28:31',5960.00,5960.00,'G$'),(14390,'01','R$','2019-03-29','07:18:55',1460.00,1460.00,'G$'),(14391,'01','U$','2019-03-29','07:19:18',5970.00,5970.00,'G$'),(14410,'01','R$','2019-03-30','07:20:59',1455.00,1455.00,'G$'),(14411,'01','U$','2019-03-30','07:21:25',5980.00,5980.00,'G$'),(14453,'01','P$','2019-04-03','07:16:02',120.00,120.00,'G$'),(14454,'01','R$','2019-04-03','07:16:23',1480.00,1480.00,'G$'),(14458,'01','P$','2019-04-03','08:16:57',130.00,130.00,'G$'),(14470,'01','P$','2019-04-04','07:07:01',125.00,125.00,'G$'),(14471,'01','U$','2019-04-04','07:07:18',5990.00,5990.00,'G$'),(14489,'01','R$','2019-04-05','07:36:05',1485.00,1485.00,'G$'),(14490,'01','U$','2019-04-05','07:36:24',6000.00,6000.00,'G$'),(14501,'01','R$','2019-04-06','07:22:18',1490.00,1490.00,'G$'),(14502,'01','U$','2019-04-06','07:22:47',5990.00,5990.00,'G$'),(14529,'01','U$','2019-04-09','07:10:27',6000.00,6000.00,'G$'),(14556,'01','R$','2019-04-11','07:33:37',1500.00,1500.00,'G$'),(14557,'01','U$','2019-04-11','07:33:59',6010.00,6010.00,'G$'),(14570,'01','R$','2019-04-12','07:09:34',1490.00,1490.00,'G$'),(14588,'01','R$','2019-04-13','07:29:50',1485.00,1485.00,'G$'),(14602,'01','R$','2019-04-15','06:20:55',1490.00,1490.00,'G$'),(14603,'01','U$','2019-04-15','06:21:10',6025.00,6025.00,'G$'),(14624,'01','U$','2019-04-16','08:02:38',6010.00,6010.00,'G$'),(14636,'01','R$','2019-04-17','07:22:39',1480.00,1480.00,'G$'),(14637,'01','U$','2019-04-17','07:23:18',6000.00,6000.00,'G$'),(14646,'01','R$','2019-04-20','11:30:48',1470.00,1470.00,'G$'),(14672,'01','U$','2019-04-23','07:10:32',6010.00,6010.00,'G$'),(14674,'01','R$','2019-04-23','07:10:52',1475.00,1475.00,'G$'),(14687,'01','R$','2019-04-24','07:15:02',1460.00,1460.00,'G$'),(14688,'01','U$','2019-04-24','07:15:20',6020.00,6020.00,'G$'),(14707,'01','P$','2019-04-25','11:23:34',115.00,115.00,'G$'),(14714,'01','R$','2019-04-26','07:38:36',1470.00,1470.00,'G$'),(14715,'01','U$','2019-04-26','07:38:53',6040.00,6040.00,'G$'),(14735,'01','U$','2019-04-27','08:25:24',6050.00,6050.00,'G$'),(14759,'01','P$','2019-04-30','07:31:04',120.00,120.00,'G$'),(14760,'01','U$','2019-04-30','07:31:23',6070.00,6070.00,'G$'),(14774,'01','R$','2019-05-02','07:35:59',1450.00,1450.00,'G$'),(14791,'01','U$','2019-05-03','07:07:17',6080.00,6080.00,'G$'),(14819,'01','U$','2019-05-06','07:39:27',6060.00,6060.00,'G$'),(14831,'01','R$','2019-05-07','07:42:43',1455.00,1455.00,'G$'),(14832,'01','U$','2019-05-07','07:43:00',6080.00,6080.00,'G$'),(14844,'01','R$','2019-05-08','07:45:29',1450.00,1450.00,'G$'),(14845,'01','U$','2019-05-08','07:45:47',6085.00,6085.00,'G$'),(14884,'01','R$','2019-05-10','07:56:07',1430.00,1430.00,'G$'),(14900,'01','U$','2019-05-11','07:17:13',6130.00,6130.00,'G$'),(14901,'01','R$','2019-05-11','07:17:38',1435.00,1435.00,'G$'),(14921,'01','R$','2019-05-14','07:23:03',1410.00,1410.00,'G$'),(14922,'01','U$','2019-05-14','07:23:30',6080.00,6080.00,'G$'),(14942,'01','U$','2019-05-17','07:21:45',6040.00,6040.00,'G$'),(14959,'01','R$','2019-05-18','07:20:04',1390.00,1390.00,'G$'),(14960,'01','U$','2019-05-18','07:20:25',6020.00,6020.00,'G$'),(14973,'01','U$','2019-05-20','07:54:35',6030.00,6030.00,'G$'),(14974,'01','R$','2019-05-20','07:55:02',1400.00,1400.00,'G$'),(15004,'01','R$','2019-05-22','08:22:42',1410.00,1410.00,'G$'),(15005,'01','U$','2019-05-22','08:22:59',6050.00,6050.00,'G$'),(15017,'01','R$','2019-05-23','07:18:17',1400.00,1400.00,'G$'),(15036,'01','U$','2019-05-24','07:40:55',6030.00,6030.00,'G$'),(15037,'01','R$','2019-05-24','07:41:12',1385.00,1385.00,'G$'),(15045,'01','R$','2019-05-25','07:40:11',1390.00,1390.00,'G$'),(15060,'01','R$','2019-05-27','08:24:13',1395.00,1395.00,'G$'),(15071,'01','R$','2019-05-28','07:22:47',1390.00,1390.00,'G$'),(15072,'01','U$','2019-05-28','07:23:07',6010.00,6010.00,'G$'),(15091,'01','U$','2019-05-29','07:16:12',6030.00,6030.00,'G$'),(15103,'01','U$','2019-05-30','07:10:33',6060.00,6060.00,'G$'),(15104,'01','U$','2019-05-30','07:12:14',1400.00,1400.00,'G$'),(15105,'01','U$','2019-05-30','07:18:54',6060.00,6060.00,'G$'),(15106,'01','R$','2019-05-30','07:19:20',1400.00,1400.00,'G$'),(15121,'01','U$','2019-05-31','07:29:30',6030.00,6030.00,'G$'),(15122,'01','R$','2019-05-31','07:30:04',1405.00,1405.00,'G$'),(15167,'01','R$','2019-06-04','12:36:19',1410.00,1410.00,'G$'),(15177,'01','R$','2019-06-05','07:43:51',1420.00,1420.00,'G$'),(15178,'01','U$','2019-06-05','07:44:18',6000.00,6000.00,'G$'),(15194,'01','U$','2019-06-06','08:30:56',6010.00,6010.00,'G$'),(15208,'01','R$','2019-06-07','10:23:42',1430.00,1430.00,'G$'),(15217,'01','R$','2019-06-08','07:16:07',1420.00,1420.00,'G$'),(15218,'01','U$','2019-06-08','07:16:46',6000.00,6000.00,'G$'),(15249,'01','U$','2019-06-11','07:52:26',5970.00,5970.00,'G$'),(15264,'01','R$','2019-06-12','08:32:20',1430.00,1430.00,'G$'),(15289,'01','U$','2019-06-14','07:59:21',5950.00,5950.00,'G$'),(15304,'01','U$','2019-06-15','08:19:31',5900.00,5900.00,'G$'),(15305,'01','R$','2019-06-15','08:34:01',1425.00,1425.00,'G$'),(15314,'01','U$','2019-06-17','07:24:20',5890.00,5890.00,'G$'),(15354,'01','R$','2019-06-20','08:03:56',1430.00,1430.00,'G$'),(15355,'01','U$','2019-06-20','08:04:11',5900.00,5900.00,'G$'),(15366,'01','U$','2019-06-21','07:50:08',5880.00,5880.00,'G$'),(15367,'01','R$','2019-06-21','07:50:25',1435.00,1435.00,'G$'),(15383,'01','R$','2019-06-22','08:06:08',1440.00,1440.00,'G$'),(15384,'01','U$','2019-06-22','08:06:33',5890.00,5890.00,'G$'),(15410,'01','R$','2019-06-25','08:28:31',1430.00,1430.00,'G$'),(15427,'01','R$','2019-06-26','08:46:23',1415.00,1415.00,'G$'),(15449,'01','R$','2019-06-27','17:20:12',1425.00,1425.00,'G$'),(15453,'01','R$','2019-06-28','07:11:14',1430.00,1430.00,'G$'),(15455,'01','R$','2019-06-28','07:12:09',1420.00,1420.00,'G$'),(15480,'01','U$','2019-06-29','08:48:43',5870.00,5870.00,'G$'),(15513,'01','U$','2019-07-03','08:49:06',5880.00,5880.00,'G$'),(15530,'01','U$','2019-07-04','08:18:04',5870.00,5870.00,'G$'),(15545,'01','R$','2019-07-05','08:14:45',1430.00,1430.00,'G$'),(15546,'01','U$','2019-07-05','08:15:03',5810.00,5810.00,'G$'),(15563,'01','R$','2019-07-06','08:41:07',1435.00,1435.00,'G$'),(15578,'01','U$','2019-07-08','07:35:39',5800.00,5800.00,'G$'),(15579,'01','R$','2019-07-08','07:35:59',1420.00,1420.00,'G$'),(15594,'01','R$','2019-07-09','08:08:03',1430.00,1430.00,'G$'),(15595,'01','U$','2019-07-09','08:08:21',5790.00,5790.00,'G$'),(15611,'01','U$','2019-07-10','07:46:00',5730.00,5730.00,'G$'),(15612,'01','R$','2019-07-10','07:46:22',1415.00,1415.00,'G$'),(15626,'01','R$','2019-07-11','07:54:06',1420.00,1420.00,'G$'),(15641,'01','R$','2019-07-12','07:30:54',1430.00,1430.00,'G$'),(15642,'01','U$','2019-07-12','07:32:09',5720.00,5720.00,'G$'),(15662,'01','U$','2019-07-15','08:28:20',5700.00,5700.00,'G$'),(15666,'01','R$','2019-07-15','08:40:35',1420.00,1420.00,'G$'),(15674,'01','P$','2019-07-16','07:10:32',115.00,115.00,'G$'),(15676,'01','R$','2019-07-16','07:11:59',1400.00,1400.00,'G$'),(15678,'01','U$','2019-07-16','07:12:17',5650.00,5650.00,'G$'),(15705,'01','R$','2019-07-17','07:13:13',1420.00,1420.00,'G$'),(15706,'01','U$','2019-07-17','07:13:31',5700.00,5700.00,'G$'),(15739,'01','R$','2019-07-19','08:34:38',1415.00,1415.00,'G$'),(15740,'01','U$','2019-07-19','08:34:57',5670.00,5670.00,'G$'),(15751,'01','R$','2019-07-20','08:10:26',1405.00,1405.00,'G$');

/*Table structure for table `cotizaciones_contables` */

DROP TABLE IF EXISTS `cotizaciones_contables`;

CREATE TABLE `cotizaciones_contables` (
  `id_cotiz` int(11) NOT NULL AUTO_INCREMENT,
  `suc` varchar(10) NOT NULL,
  `m_cod` varchar(4) NOT NULL,
  `fecha` date NOT NULL,
  `hora` varchar(10) DEFAULT NULL,
  `compra` decimal(8,2) DEFAULT NULL,
  `venta` decimal(8,2) DEFAULT NULL,
  `ref` varchar(4) DEFAULT NULL,
  PRIMARY KEY (`id_cotiz`,`suc`),
  KEY `Ref18327` (`suc`),
  KEY `Ref15328` (`m_cod`),
  CONSTRAINT `Refmonedas328` FOREIGN KEY (`m_cod`) REFERENCES `monedas` (`m_cod`),
  CONSTRAINT `Refsucursales327` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `cotizaciones_contables` */

/*Table structure for table `cuotas` */

DROP TABLE IF EXISTS `cuotas`;

CREATE TABLE `cuotas` (
  `f_nro` int(11) NOT NULL,
  `id_cuota` int(11) NOT NULL,
  `moneda` varchar(4) NOT NULL,
  `monto` decimal(16,2) DEFAULT NULL,
  `cotiz` decimal(8,2) DEFAULT NULL,
  `monto_ref` decimal(16,2) DEFAULT NULL,
  `monto_s_total` decimal(16,0) DEFAULT NULL,
  `valor_total` decimal(16,2) DEFAULT NULL,
  `saldo` decimal(16,2) DEFAULT NULL,
  `dias` int(11) DEFAULT NULL,
  `porcentaje` decimal(16,4) DEFAULT NULL,
  `vencimiento` date NOT NULL,
  `tasa_interes` decimal(16,2) DEFAULT NULL,
  `ret_iva` decimal(16,2) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` varchar(10) DEFAULT NULL,
  `suc` varchar(10) DEFAULT NULL,
  `estado` varchar(30) DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`f_nro`,`id_cuota`),
  KEY `Ref323` (`f_nro`),
  KEY `Ref1528` (`moneda`),
  CONSTRAINT `Reffactura_venta23` FOREIGN KEY (`f_nro`) REFERENCES `factura_venta` (`f_nro`),
  CONSTRAINT `Refmonedas28` FOREIGN KEY (`moneda`) REFERENCES `monedas` (`m_cod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `cuotas` */

/*Table structure for table `desc_lotes` */

DROP TABLE IF EXISTS `desc_lotes`;

CREATE TABLE `desc_lotes` (
  `codigo` varchar(30) NOT NULL,
  `lote` varchar(60) NOT NULL,
  `num` int(11) NOT NULL,
  `moneda` varchar(4) NOT NULL,
  `um` varchar(10) NOT NULL,
  `descuento` decimal(10,6) DEFAULT NULL,
  PRIMARY KEY (`codigo`,`lote`,`num`,`moneda`,`um`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `desc_lotes` */

/*Table structure for table `descuentos` */

DROP TABLE IF EXISTS `descuentos`;

CREATE TABLE `descuentos` (
  `cod_desc` tinyint(4) NOT NULL,
  `descrip` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`cod_desc`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `descuentos` */

insert  into `descuentos`(`cod_desc`,`descrip`) values (0,'Sin Descuento'),(1,'Descuento Categoria 1 y 2 x Valor > 330.000'),(2,'Ventas Discriminadas'),(3,'Ventas Mayorista'),(4,'SEDECO');

/*Table structure for table `designs` */

DROP TABLE IF EXISTS `designs`;

CREATE TABLE `designs` (
  `design` varchar(30) NOT NULL,
  `descrip` varchar(30) DEFAULT NULL,
  `estado` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`design`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `designs` */

/*Table structure for table `det_catalogo` */

DROP TABLE IF EXISTS `det_catalogo`;

CREATE TABLE `det_catalogo` (
  `id_det` int(11) NOT NULL AUTO_INCREMENT,
  `nro` int(11) NOT NULL,
  `lote` varchar(30) DEFAULT NULL,
  `cantidad` varchar(30) DEFAULT NULL,
  `pantone` varchar(16) DEFAULT NULL,
  `color` varchar(30) DEFAULT NULL,
  `fab_color_cod` varchar(30) DEFAULT NULL,
  `img` varchar(30) DEFAULT NULL,
  `usuario` varchar(30) DEFAULT NULL,
  `fecha_hora_ini` datetime DEFAULT NULL,
  `fecha_hora_fin` datetime DEFAULT NULL,
  `encargado` varchar(30) DEFAULT NULL,
  `estado` int(11) DEFAULT NULL,
  `suc` varchar(10) NOT NULL,
  PRIMARY KEY (`id_det`),
  KEY `Ref99194` (`nro`,`suc`),
  CONSTRAINT `Refcatalogo_muestras194` FOREIGN KEY (`nro`, `suc`) REFERENCES `catalogo_muestras` (`nro`, `suc`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `det_catalogo` */

/*Table structure for table `diag_det` */

DROP TABLE IF EXISTS `diag_det`;

CREATE TABLE `diag_det` (
  `id_diag` int(11) DEFAULT NULL,
  `id_det` int(11) DEFAULT NULL,
  `descrip` varchar(2048) DEFAULT NULL,
  `precio` decimal(16,2) DEFAULT NULL,
  `cant` int(11) DEFAULT NULL,
  `subtotal` decimal(16,2) DEFAULT NULL,
  KEY `id_diag` (`id_diag`),
  CONSTRAINT `diag_det_ibfk_1` FOREIGN KEY (`id_diag`) REFERENCES `diagnosticos` (`id_diag`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `diag_det` */

insert  into `diag_det`(`id_diag`,`id_det`,`descrip`,`precio`,`cant`,`subtotal`) values (1,1,'Bla bla bla',100.00,2,200.00),(1,2,'xxxxx',150.00,2,300.00),(1,3,'Lorep ipsun dolor,Lorep ipsun dolor,Lorep ipsun dolor,Lorep ipsun dolor,Lorep ipsun dolor,Lorep ipsun dolor,Lorep ipsun dolor,Lorep ipsun dolor,Lorep ipsun dolor,Lorep ipsun dolor,Lorep ipsun dolor,Lorep ipsun dolor,Lorep ipsun dolor,Lorep ipsun dolor,Lorep ipsun dolor,Lorep ipsun dolor,Lorep ',5000.00,2,10000.00),(1,4,'bla bla bla',5200.00,1,5200.00),(6,1,'Presenta una falla en los frenos',36500.00,3,109500.00),(6,2,'12s31f3sd1f1321321f\nsdfsd\nf\nsfs',24500.00,2,49000.00),(6,3,'sd2f3s2dfsd',45000.00,1,45000.00),(8,1,'Buje de parrilla dañado lado izquierdo y derecho',125000.00,2,250000.00),(8,2,'Guardapolvos delanteros',45500.00,2,91000.00),(8,3,'Soporte de Motor (Taco de goma)',85000.00,3,255000.00),(8,4,'Mano de Obra',350000.00,1,350000.00);

/*Table structure for table `diagnosticos` */

DROP TABLE IF EXISTS `diagnosticos`;

CREATE TABLE `diagnosticos` (
  `id_diag` int(11) NOT NULL AUTO_INCREMENT,
  `id_rec` int(11) DEFAULT NULL,
  `chapa` varchar(30) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `usuario` varchar(30) DEFAULT NULL,
  `tecnico_autoriz` varchar(30) DEFAULT NULL,
  `fecha_ingreso` datetime DEFAULT NULL,
  `fecha_salida` datetime DEFAULT NULL,
  `estado` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_diag`),
  KEY `usuario` (`usuario`),
  CONSTRAINT `diagnosticos_ibfk_1` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=latin1;

/*Data for the table `diagnosticos` */

insert  into `diagnosticos`(`id_diag`,`id_rec`,`chapa`,`fecha`,`usuario`,`tecnico_autoriz`,`fecha_ingreso`,`fecha_salida`,`estado`) values (1,54,'KDG 973','2021-11-09','douglas','douglas','2021-11-09 15:24:00','0000-00-00 00:00:00','Abierto'),(6,62,'ABC 123','2021-11-15','douglas','douglas','2021-11-15 08:20:18',NULL,'Abierto'),(7,61,'ABC 123','2021-11-15','douglas','douglas','2021-11-15 08:31:35','2000-01-01 00:00:00','Abierto'),(8,57,'NAH 367','2021-11-15','douglas','douglas','2021-11-15 09:03:34','2000-01-01 00:00:00','Abierto'),(9,61,'ABC 123','2021-11-15','douglas','douglas','2021-11-15 09:08:01','2000-01-01 00:00:00','Abierto'),(10,54,'KDG 973','2021-11-15','douglas','douglas','2021-11-15 09:10:28','2000-01-01 00:00:00','Abierto'),(11,66,'NAH 367','2021-12-28','douglas','douglas','2021-12-28 05:45:02','2000-01-01 00:00:00','Abierto');

/*Table structure for table `edicion_lotes` */

DROP TABLE IF EXISTS `edicion_lotes`;

CREATE TABLE `edicion_lotes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(30) DEFAULT NULL,
  `codigo` varchar(30) DEFAULT NULL,
  `lote` varchar(30) DEFAULT NULL,
  `descrip` varchar(40) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` varchar(10) DEFAULT NULL,
  `suc` varchar(10) NOT NULL,
  `estado_venta` varchar(20) DEFAULT NULL,
  `tara` decimal(12,2) DEFAULT NULL,
  `ancho` decimal(16,2) DEFAULT NULL,
  `kg` decimal(16,2) DEFAULT NULL,
  `gramaje` decimal(16,2) DEFAULT NULL,
  `obs` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Ref6131` (`usuario`),
  KEY `Ref18132` (`suc`),
  CONSTRAINT `Refsucursales132` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`),
  CONSTRAINT `Refusuarios131` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `edicion_lotes` */

/*Table structure for table `efectivo` */

DROP TABLE IF EXISTS `efectivo`;

CREATE TABLE `efectivo` (
  `id_pago` int(11) NOT NULL AUTO_INCREMENT,
  `id_concepto` int(11) NOT NULL,
  `f_nro` int(11) DEFAULT NULL,
  `nro_reserva` int(11) DEFAULT NULL,
  `nota_credito` int(11) DEFAULT NULL,
  `nro_deposito` varchar(30) DEFAULT NULL,
  `m_cod` varchar(4) NOT NULL,
  `usuario` varchar(30) NOT NULL,
  `trans_num` varchar(30) DEFAULT NULL,
  `entrada` decimal(16,2) DEFAULT 0.00,
  `salida` decimal(16,2) DEFAULT 0.00,
  `cotiz` decimal(8,2) DEFAULT NULL,
  `entrada_ref` decimal(16,2) DEFAULT 0.00,
  `salida_ref` decimal(16,2) DEFAULT 0.00,
  `fecha_reg` date DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` varchar(10) DEFAULT NULL,
  `suc` varchar(10) DEFAULT NULL,
  `estado` varchar(10) DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id_pago`),
  KEY `Ref312` (`f_nro`),
  KEY `Ref1513` (`m_cod`),
  KEY `Ref2942` (`nro_reserva`),
  KEY `Ref3443` (`id_concepto`),
  KEY `Ref6120` (`usuario`),
  CONSTRAINT `Refconceptos43` FOREIGN KEY (`id_concepto`) REFERENCES `conceptos` (`id_concepto`),
  CONSTRAINT `Reffactura_venta12` FOREIGN KEY (`f_nro`) REFERENCES `factura_venta` (`f_nro`),
  CONSTRAINT `Refmonedas13` FOREIGN KEY (`m_cod`) REFERENCES `monedas` (`m_cod`),
  CONSTRAINT `Refreservas42` FOREIGN KEY (`nro_reserva`) REFERENCES `reservas` (`nro_reserva`),
  CONSTRAINT `Refusuarios120` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=latin1;

/*Data for the table `efectivo` */

insert  into `efectivo`(`id_pago`,`id_concepto`,`f_nro`,`nro_reserva`,`nota_credito`,`nro_deposito`,`m_cod`,`usuario`,`trans_num`,`entrada`,`salida`,`cotiz`,`entrada_ref`,`salida_ref`,`fecha_reg`,`fecha`,`hora`,`suc`,`estado`,`e_sap`) values (1,1,20,NULL,NULL,NULL,'G$','douglas',NULL,200000.00,0.00,1.00,200000.00,0.00,'2020-03-02','2020-03-02','18:48:07','01','Pendiente',NULL),(5,2,20,NULL,NULL,NULL,'G$','douglas',NULL,0.00,24000.00,1.00,0.00,24000.00,'2020-03-02','2020-03-02','18:48:07','01','Pendiente',NULL),(6,1,22,NULL,NULL,NULL,'G$','douglas',NULL,400000.00,0.00,1.00,400000.00,0.00,'2020-03-02','2020-03-02','19:45:01','01','Pendiente',NULL),(7,2,22,NULL,NULL,NULL,'G$','douglas',NULL,0.00,20000.00,1.00,0.00,20000.00,'2020-03-02','2020-03-02','19:45:01','01','Pendiente',NULL),(8,1,21,NULL,NULL,NULL,'G$','douglas',NULL,55000.00,0.00,1.00,55000.00,0.00,'2020-03-18','2020-03-18','18:37:22','01','Pendiente',NULL),(9,1,30,NULL,NULL,NULL,'G$','douglas',NULL,60000.00,0.00,1.00,60000.00,0.00,'2020-06-29','2022-02-21','23:42:21','01','Pendiente',NULL),(10,1,30,NULL,NULL,NULL,'R$','douglas',NULL,6.00,0.00,1405.00,8430.00,0.00,'2020-06-29','2022-02-21','23:42:21','01','Pendiente',NULL),(12,2,30,NULL,NULL,NULL,'G$','douglas',NULL,0.00,1430.00,1.00,0.00,1430.00,'2020-06-29','2022-02-21','23:42:21','01','Pendiente',NULL),(13,1,40,NULL,NULL,NULL,'G$','douglas',NULL,25000.00,0.00,1.00,25000.00,0.00,'2022-02-21','2022-02-21','23:39:13','01','Pendiente',NULL),(14,1,25,NULL,NULL,NULL,'G$','douglas',NULL,1000.00,0.00,1.00,1000.00,0.00,'2022-03-03','2022-03-03','17:34:53','01','Pendiente',NULL),(28,1,42,NULL,NULL,NULL,'G$','douglas',NULL,3896200.00,0.00,1.00,3896200.00,0.00,'2022-03-07','2022-03-07','15:46:00','01','Pendiente',NULL),(29,1,24,NULL,NULL,NULL,'G$','douglas',NULL,174500.00,0.00,1.00,174500.00,0.00,'2022-03-07','2022-03-07','15:57:48','01','Pendiente',NULL),(30,1,38,NULL,NULL,NULL,'G$','douglas',NULL,982000.00,0.00,1.00,982000.00,0.00,'2022-03-07','2022-03-07','16:01:22','01','Pendiente',NULL),(31,1,28,NULL,NULL,NULL,'G$','douglas',NULL,1009000.00,0.00,1.00,1009000.00,0.00,'2022-03-11','2022-03-11','18:53:50','01','Pendiente',NULL),(32,2,28,NULL,NULL,NULL,'G$','douglas',NULL,0.00,1009000.00,1.00,0.00,1009000.00,'2022-03-11','2022-03-11','18:53:50','01','Pendiente',NULL),(33,1,37,NULL,NULL,NULL,'G$','douglas',NULL,125000.00,0.00,1.00,125000.00,0.00,'2022-03-11','2022-03-11','19:10:23','01','Pendiente',NULL),(34,1,31,NULL,NULL,NULL,'G$','douglas',NULL,560000.00,0.00,1.00,560000.00,0.00,'2022-03-11','2022-03-11','19:22:51','01','Pendiente',NULL),(35,1,46,NULL,NULL,NULL,'G$','douglas',NULL,220000.00,0.00,1.00,220000.00,0.00,'2022-03-11','2022-03-11','19:28:39','01','Pendiente',NULL);

/*Table structure for table `emis_det` */

DROP TABLE IF EXISTS `emis_det`;

CREATE TABLE `emis_det` (
  `nro_emis` int(11) NOT NULL,
  `nro_orden` int(11) NOT NULL,
  `id_det` int(11) NOT NULL,
  `codigo_ref` varchar(10) DEFAULT NULL,
  `codigo` varchar(10) DEFAULT NULL,
  `lote` varchar(30) DEFAULT NULL,
  `descrip` varchar(60) DEFAULT NULL,
  `color` varchar(30) DEFAULT NULL,
  `design` varchar(30) DEFAULT NULL,
  `cant_lote` decimal(30,0) DEFAULT NULL,
  `usuario` varchar(30) NOT NULL,
  `cant_frac` decimal(16,2) DEFAULT NULL,
  `largo` decimal(16,2) DEFAULT NULL,
  `tipo_saldo` varchar(10) DEFAULT NULL,
  `saldo` decimal(16,2) DEFAULT NULL,
  `codigo_om` varchar(20) DEFAULT NULL,
  `diff` decimal(16,2) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` varchar(10) DEFAULT NULL,
  `precio_costo` decimal(16,2) DEFAULT NULL,
  `um` varchar(10) DEFAULT NULL,
  `multiplicador` int(11) DEFAULT NULL,
  `fila_orig` int(11) DEFAULT NULL,
  PRIMARY KEY (`nro_emis`,`nro_orden`,`id_det`),
  KEY `Ref85148` (`nro_orden`,`nro_emis`),
  KEY `Ref6153` (`usuario`),
  CONSTRAINT `Refemis_produc148` FOREIGN KEY (`nro_emis`, `nro_orden`) REFERENCES `emis_produc` (`nro_emis`, `nro_orden`),
  CONSTRAINT `Refusuarios153` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `emis_det` */

/*Table structure for table `emis_produc` */

DROP TABLE IF EXISTS `emis_produc`;

CREATE TABLE `emis_produc` (
  `nro_emis` int(11) NOT NULL AUTO_INCREMENT,
  `nro_orden` int(11) NOT NULL,
  `suc` varchar(10) NOT NULL,
  `usuario` varchar(30) NOT NULL,
  `fecha` date DEFAULT NULL,
  `hora` varchar(10) DEFAULT NULL,
  `fecha_proc` date DEFAULT NULL,
  `hora_proc` varchar(10) DEFAULT NULL,
  `fecha_cierre` date DEFAULT NULL,
  `hora_cierre` varchar(10) DEFAULT NULL,
  `estado` varchar(12) DEFAULT NULL,
  `sap_doc` int(11) DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`nro_emis`,`nro_orden`),
  KEY `Ref83149` (`nro_orden`),
  KEY `Ref6150` (`usuario`),
  KEY `Ref18151` (`suc`),
  CONSTRAINT `Reforden_fabric149` FOREIGN KEY (`nro_orden`) REFERENCES `orden_fabric` (`nro_orden`),
  CONSTRAINT `Refsucursales151` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`),
  CONSTRAINT `Refusuarios150` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `emis_produc` */

/*Table structure for table `ent_gastos` */

DROP TABLE IF EXISTS `ent_gastos`;

CREATE TABLE `ent_gastos` (
  `id_ent` int(11) NOT NULL,
  `cod_gasto` int(11) NOT NULL,
  `valor` decimal(16,2) DEFAULT NULL,
  `moneda` varchar(4) NOT NULL,
  `cotiz` decimal(16,2) DEFAULT NULL,
  `valor_ref` decimal(16,2) DEFAULT NULL,
  `req` varchar(4) DEFAULT NULL,
  PRIMARY KEY (`id_ent`,`cod_gasto`),
  KEY `Ref48113` (`id_ent`),
  KEY `Ref166321` (`cod_gasto`),
  KEY `Ref15323` (`moneda`),
  CONSTRAINT `Refentrada_merc113` FOREIGN KEY (`id_ent`) REFERENCES `entrada_merc` (`id_ent`),
  CONSTRAINT `Refmonedas323` FOREIGN KEY (`moneda`) REFERENCES `monedas` (`m_cod`),
  CONSTRAINT `Reftipos_gastos321` FOREIGN KEY (`cod_gasto`) REFERENCES `tipos_gastos` (`cod_gasto`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `ent_gastos` */

/*Table structure for table `entrada_det` */

DROP TABLE IF EXISTS `entrada_det`;

CREATE TABLE `entrada_det` (
  `id_ent` int(11) NOT NULL,
  `id_det` int(11) NOT NULL,
  `nro_pedido` int(11) DEFAULT NULL,
  `id_pack` int(11) DEFAULT NULL,
  `store_no` varchar(30) DEFAULT NULL,
  `bale` int(11) DEFAULT NULL,
  `piece` int(11) DEFAULT NULL,
  `codigo` varchar(30) NOT NULL,
  `lote` varchar(30) DEFAULT NULL,
  `cod_barras` varchar(30) DEFAULT NULL,
  `descrip` varchar(140) DEFAULT NULL,
  `um` varchar(10) NOT NULL,
  `cod_catalogo` varchar(30) DEFAULT NULL,
  `fab_color_cod` varchar(30) DEFAULT NULL,
  `precio` decimal(16,2) DEFAULT NULL,
  `cantidad` decimal(16,2) DEFAULT NULL,
  `subtotal` decimal(16,2) DEFAULT NULL,
  `precio_ms` decimal(16,2) DEFAULT NULL,
  `porc_particip` decimal(16,2) DEFAULT NULL,
  `sobre_costo` decimal(16,0) DEFAULT NULL,
  `precio_real` decimal(16,2) DEFAULT NULL,
  `color` varchar(30) DEFAULT NULL,
  `color_comb` varchar(40) DEFAULT NULL,
  `design` varchar(30) DEFAULT NULL,
  `ancho` decimal(16,2) DEFAULT NULL,
  `gramaje` decimal(16,2) DEFAULT NULL,
  `obs` varchar(1024) DEFAULT NULL,
  `um_prod` varchar(6) DEFAULT NULL,
  `cant_calc` decimal(16,2) DEFAULT NULL,
  `cod_pantone` varchar(12) DEFAULT NULL,
  `nro_lote_fab` varchar(8) DEFAULT NULL,
  `quty_ticket` decimal(16,2) DEFAULT NULL,
  `kg_desc` decimal(16,2) DEFAULT NULL,
  `ancho_real` decimal(16,2) DEFAULT NULL,
  `gramaje_m` decimal(16,2) DEFAULT NULL,
  `tara` int(11) DEFAULT NULL,
  `equiv` decimal(16,2) DEFAULT NULL,
  `recibido` varchar(2) DEFAULT NULL,
  `printed` varchar(4) DEFAULT NULL,
  `notas` varchar(254) DEFAULT NULL,
  `fraccion_de` varchar(30) DEFAULT NULL,
  `img` varchar(40) DEFAULT NULL,
  `initial_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_ent`,`id_det`),
  KEY `Ref48112` (`id_ent`),
  KEY `Ref160298` (`design`),
  CONSTRAINT `Refdesigns298` FOREIGN KEY (`design`) REFERENCES `designs` (`design`),
  CONSTRAINT `Refentrada_merc112` FOREIGN KEY (`id_ent`) REFERENCES `entrada_merc` (`id_ent`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `entrada_det` */

/*Table structure for table `entrada_merc` */

DROP TABLE IF EXISTS `entrada_merc`;

CREATE TABLE `entrada_merc` (
  `id_ent` int(11) NOT NULL AUTO_INCREMENT,
  `suc` varchar(10) DEFAULT NULL,
  `usuario` varchar(30) NOT NULL,
  `invoice` varchar(40) DEFAULT NULL,
  `n_nro` int(11) DEFAULT NULL,
  `tipo_doc_sap` varchar(30) DEFAULT NULL,
  `folio_num` varchar(30) DEFAULT NULL,
  `cod_prov` varchar(10) NOT NULL,
  `proveedor` varchar(80) DEFAULT NULL,
  `fecha` varchar(30) DEFAULT NULL,
  `fecha_fact` date DEFAULT NULL,
  `moneda` varchar(30) DEFAULT NULL,
  `cotiz` varchar(30) DEFAULT NULL,
  `total` decimal(16,2) DEFAULT NULL,
  `origen` varchar(30) DEFAULT NULL,
  `pais_origen` varchar(30) NOT NULL,
  `coment` varchar(254) DEFAULT NULL,
  `estado` varchar(16) DEFAULT NULL,
  `sap_doc` int(11) DEFAULT NULL,
  `frac` varchar(2) DEFAULT NULL,
  `timbrado` varchar(30) DEFAULT NULL,
  `porc_recargo` decimal(16,4) DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id_ent`),
  KEY `Ref675` (`usuario`),
  KEY `Ref1878` (`suc`),
  KEY `Ref61111` (`invoice`,`n_nro`),
  KEY `Ref146256` (`cod_prov`),
  KEY `Ref150265` (`pais_origen`),
  CONSTRAINT `Refpaises265` FOREIGN KEY (`pais_origen`) REFERENCES `paises` (`codigo_pais`),
  CONSTRAINT `Refproveedores256` FOREIGN KEY (`cod_prov`) REFERENCES `proveedores` (`cod_prov`),
  CONSTRAINT `Refsucursales78` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`),
  CONSTRAINT `Refusuarios75` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=22 DEFAULT CHARSET=latin1;

/*Data for the table `entrada_merc` */

/*Table structure for table `exoneraciones` */

DROP TABLE IF EXISTS `exoneraciones`;

CREATE TABLE `exoneraciones` (
  `id_ex` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(30) NOT NULL,
  `DocNum` int(11) DEFAULT NULL,
  `InstallmentID` int(11) DEFAULT NULL,
  `fecha` datetime DEFAULT NULL,
  `exonerada` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_ex`),
  KEY `Ref6136` (`usuario`),
  CONSTRAINT `Refusuarios136` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `exoneraciones` */

/*Table structure for table `extractos_ext` */

DROP TABLE IF EXISTS `extractos_ext`;

CREATE TABLE `extractos_ext` (
  `id_ext` int(11) NOT NULL AUTO_INCREMENT,
  `id_banco` varchar(4) NOT NULL,
  `cuenta` varchar(30) NOT NULL,
  `fecha_reg` date DEFAULT NULL,
  `fecha_trans` date DEFAULT NULL,
  `cod_mov` varchar(60) DEFAULT NULL,
  `concepto` varchar(60) DEFAULT NULL,
  `debe` decimal(16,2) DEFAULT NULL,
  `haber` decimal(16,2) DEFAULT NULL,
  `saldo` decimal(16,2) DEFAULT NULL,
  `confirmado` varchar(2) DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id_ext`),
  KEY `Ref26139` (`cuenta`,`id_banco`),
  KEY `Refbcos_ctas139` (`id_banco`,`cuenta`),
  CONSTRAINT `Refbcos_ctas139` FOREIGN KEY (`id_banco`, `cuenta`) REFERENCES `bcos_ctas` (`id_banco`, `cuenta`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `extractos_ext` */

/*Table structure for table `fact_vent_det` */

DROP TABLE IF EXISTS `fact_vent_det`;

CREATE TABLE `fact_vent_det` (
  `id_det` int(11) NOT NULL AUTO_INCREMENT,
  `f_nro` int(11) NOT NULL,
  `lote` varchar(30) DEFAULT NULL,
  `codigo` varchar(30) DEFAULT NULL,
  `um_prod` varchar(10) DEFAULT NULL,
  `descrip` varchar(120) DEFAULT NULL,
  `um_cod` varchar(10) NOT NULL,
  `cantidad` decimal(16,2) DEFAULT NULL,
  `cod_falla` varchar(6) DEFAULT NULL,
  `cant_falla` decimal(14,2) DEFAULT NULL,
  `cod_falla_e` varchar(6) DEFAULT NULL,
  `falla_real` decimal(14,2) DEFAULT NULL,
  `precio_venta` decimal(16,2) DEFAULT NULL,
  `descuento` decimal(16,2) DEFAULT NULL,
  `precio_neto` decimal(16,2) DEFAULT NULL,
  `subtotal` decimal(16,2) DEFAULT NULL,
  `gramaje` decimal(16,2) DEFAULT NULL,
  `ancho` decimal(8,2) DEFAULT NULL,
  `kg_calc` decimal(16,3) DEFAULT NULL,
  `kg_med` decimal(16,3) DEFAULT NULL,
  `cant_med` decimal(16,2) DEFAULT NULL,
  `sis_med` varchar(10) DEFAULT NULL,
  `verificador` varchar(30) DEFAULT NULL,
  `fuera_rango` decimal(12,2) DEFAULT NULL,
  `dif` decimal(12,2) DEFAULT NULL,
  `tipo_desc` varchar(6) DEFAULT NULL,
  `precio_costo` decimal(16,2) DEFAULT NULL,
  `estado` varchar(30) DEFAULT NULL,
  `estado_venta` varchar(16) DEFAULT NULL,
  `control_laser` varchar(30) DEFAULT NULL,
  `paquete` int(11) DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id_det`,`f_nro`),
  KEY `Ref31` (`f_nro`),
  KEY `Ref109` (`um_cod`),
  CONSTRAINT `Reffactura_venta1` FOREIGN KEY (`f_nro`) REFERENCES `factura_venta` (`f_nro`),
  CONSTRAINT `Refunidades_medida9` FOREIGN KEY (`um_cod`) REFERENCES `unidades_medida` (`um_cod`)
) ENGINE=InnoDB AUTO_INCREMENT=128 DEFAULT CHARSET=latin1;

/*Data for the table `fact_vent_det` */

/*Table structure for table `factura_cont` */

DROP TABLE IF EXISTS `factura_cont`;

CREATE TABLE `factura_cont` (
  `fact_nro` varchar(30) NOT NULL,
  `suc` varchar(10) NOT NULL,
  `pdv_cod` varchar(30) NOT NULL,
  `tipo_fact` varchar(16) NOT NULL,
  `tipo_doc` varchar(30) NOT NULL,
  `moneda` varchar(4) NOT NULL,
  `fecha_venc` date DEFAULT NULL,
  `usuario` varchar(30) DEFAULT NULL,
  `estado` varchar(30) DEFAULT NULL,
  `motivo_anul` varchar(200) DEFAULT NULL,
  `timbrado` int(11) DEFAULT NULL,
  `establecimiento` varchar(6) DEFAULT NULL,
  `tipo` varchar(10) DEFAULT NULL,
  `id_pago` int(11) DEFAULT NULL,
  PRIMARY KEY (`fact_nro`,`suc`,`pdv_cod`,`tipo_fact`,`tipo_doc`,`moneda`),
  KEY `Ref2321` (`pdv_cod`,`suc`),
  KEY `Ref1570` (`moneda`),
  KEY `Ref44137` (`id_pago`),
  CONSTRAINT `Refmonedas70` FOREIGN KEY (`moneda`) REFERENCES `monedas` (`m_cod`),
  CONSTRAINT `Refpagos_recibidos137` FOREIGN KEY (`id_pago`) REFERENCES `pagos_recibidos` (`id_pago`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `factura_cont` */

insert  into `factura_cont`(`fact_nro`,`suc`,`pdv_cod`,`tipo_fact`,`tipo_doc`,`moneda`,`fecha_venc`,`usuario`,`estado`,`motivo_anul`,`timbrado`,`establecimiento`,`tipo`,`id_pago`) values ('1','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Cerrada',NULL,12345678,'007','Contado',NULL),('10','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Cerrada',NULL,12345678,'007','Credito',NULL),('11','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('12','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('13','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('14','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('15','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('16','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('17','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('18','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('19','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('2','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Cerrada',NULL,12345678,'007','Contado',NULL),('20','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('21','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('22','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('23','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('24','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('25','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('26','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('27','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('28','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('29','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('3','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Cerrada',NULL,12345678,'007','Contado',NULL),('30','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('31','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('32','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('33','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('34','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('35','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('36','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('37','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('38','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('39','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('4','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Cerrada',NULL,12345678,'007','Contado',NULL),('40','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('41','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('42','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('43','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('44','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('45','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('46','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('47','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('48','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('49','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('5','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Cerrada',NULL,12345678,'007','Contado',NULL),('50','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Disponible',NULL,12345678,'007',NULL,NULL),('6','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Cerrada',NULL,12345678,'007','Credito',NULL),('7','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Cerrada',NULL,12345678,'007','Credito',NULL),('8','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Cerrada',NULL,12345678,'007','Credito',NULL),('9','01','001','Pre-Impresa','Factura','G$','2021-02-05','douglas','Cerrada',NULL,12345678,'007','Contado',NULL);

/*Table structure for table `factura_venta` */

DROP TABLE IF EXISTS `factura_venta`;

CREATE TABLE `factura_venta` (
  `f_nro` int(11) NOT NULL AUTO_INCREMENT,
  `cod_cli` varchar(30) NOT NULL,
  `cliente` varchar(60) NOT NULL,
  `usuario` varchar(30) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` varchar(10) DEFAULT NULL,
  `turno` varchar(12) DEFAULT NULL,
  `ruc_cli` varchar(20) NOT NULL,
  `tipo_doc_cli` varchar(20) DEFAULT NULL,
  `suc` varchar(10) DEFAULT NULL,
  `cat` int(11) NOT NULL,
  `total` decimal(18,2) DEFAULT NULL,
  `desc_sedeco` decimal(16,2) DEFAULT NULL,
  `total_desc` decimal(18,2) DEFAULT NULL,
  `total_bruto` decimal(18,2) DEFAULT NULL,
  `estado` varchar(20) DEFAULT NULL,
  `pdv_cod` varchar(30) DEFAULT NULL,
  `fact_nro` varchar(30) DEFAULT NULL,
  `tipo_fact` varchar(16) DEFAULT NULL,
  `tipo_doc` varchar(30) DEFAULT NULL,
  `cod_desc` tinyint(4) NOT NULL,
  `empaque` varchar(30) NOT NULL,
  `pref_pago` varchar(30) DEFAULT NULL,
  `fecha_cierre` date DEFAULT NULL,
  `hora_cierre` varchar(10) DEFAULT NULL,
  `nro_reserva` int(11) DEFAULT NULL,
  `moneda` varchar(4) NOT NULL,
  `cotiz` decimal(10,2) DEFAULT NULL,
  `control_caja` varchar(4) DEFAULT NULL,
  `cant_cuotas` int(11) DEFAULT NULL,
  `tipo` varchar(10) DEFAULT NULL,
  `empaquetador` varchar(30) DEFAULT NULL,
  `nro_orden` varchar(11) DEFAULT NULL,
  `orden_cli` varchar(40) DEFAULT NULL,
  `orden_valor` decimal(16,2) DEFAULT NULL,
  `turno_id` int(11) DEFAULT NULL,
  `turno_fecha` datetime DEFAULT NULL,
  `turno_llamada` datetime DEFAULT NULL,
  `notas` varchar(100) DEFAULT NULL,
  `nro_diag` int(11) DEFAULT NULL,
  `clase` varchar(10) DEFAULT '''Articulo''',
  `nro_recibo` varchar(10) DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`f_nro`),
  KEY `Ref67` (`usuario`),
  KEY `Ref2222` (`pdv_cod`,`tipo_doc`,`tipo_fact`,`suc`,`fact_nro`,`moneda`),
  KEY `Ref2833` (`cod_desc`),
  KEY `Ref2947` (`nro_reserva`),
  KEY `Ref1569` (`moneda`),
  KEY `Reffactura_cont22` (`suc`,`pdv_cod`,`fact_nro`,`tipo_fact`,`tipo_doc`,`moneda`),
  CONSTRAINT `Refdescuentos33` FOREIGN KEY (`cod_desc`) REFERENCES `descuentos` (`cod_desc`),
  CONSTRAINT `Refmonedas69` FOREIGN KEY (`moneda`) REFERENCES `monedas` (`m_cod`),
  CONSTRAINT `Refreservas47` FOREIGN KEY (`nro_reserva`) REFERENCES `reservas` (`nro_reserva`),
  CONSTRAINT `Refusuarios7` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=latin1;

/*Data for the table `factura_venta` */

insert  into `factura_venta`(`f_nro`,`cod_cli`,`cliente`,`usuario`,`fecha`,`hora`,`turno`,`ruc_cli`,`tipo_doc_cli`,`suc`,`cat`,`total`,`desc_sedeco`,`total_desc`,`total_bruto`,`estado`,`pdv_cod`,`fact_nro`,`tipo_fact`,`tipo_doc`,`cod_desc`,`empaque`,`pref_pago`,`fecha_cierre`,`hora_cierre`,`nro_reserva`,`moneda`,`cotiz`,`control_caja`,`cant_cuotas`,`tipo`,`empaquetador`,`nro_orden`,`orden_cli`,`orden_valor`,`turno_id`,`turno_fecha`,`turno_llamada`,`notas`,`nro_diag`,`clase`,`nro_recibo`,`e_sap`) values (19,'C155604','VANESSA CABRERA','douglas','2020-02-24','23:11','1','4512156-7','C.I.','01',1,359000.00,0.00,0.00,359000.00,'Abierta',NULL,NULL,NULL,NULL,0,'Si','Contado',NULL,NULL,NULL,'G$',1.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'Basado en Diagnostico Nro: 20',20,'\'Articulo\'',NULL,NULL),(20,'C000027','VIDALIA ZOTELO','douglas','2020-02-26','22:04','1','3502835-1','C.I.','01',5,176000.00,0.00,0.00,176000.00,'Cerrada','001','2','Pre-Impresa','Factura',0,'Si','Otros','2020-03-02','18:48:07',NULL,'G$',1.00,NULL,NULL,'Contado',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'\'Articulo\'',NULL,NULL),(21,'C031511','ROMINA GARCIA','douglas','2020-02-27','23:09','1','3922441','C.I.','01',1,355000.00,0.00,0.00,355000.00,'En_caja','001','5','Pre-Impresa','Factura',0,'Si','Contado',NULL,NULL,NULL,'G$',1.00,NULL,3,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'\'Articulo\'',NULL,NULL),(22,'C055608','LUIS ENRIQUE RAMIRO','douglas','2020-03-02','22:43','1','5755300-9','C.I.','01',1,380000.00,0.00,0.00,380000.00,'En_caja','001','3','Pre-Impresa','Factura',0,'Si','Contado',NULL,NULL,NULL,'G$',1.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'\'Articulo\'',NULL,NULL),(23,'C108588','DOGLAS MAURICIO KOCH','douglas','2020-03-02','22:49','1','3934809-1','C.I.','01',1,0.00,0.00,0.00,0.00,'Abierta',NULL,NULL,NULL,NULL,0,'Si',NULL,NULL,NULL,NULL,'G$',1.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'\'Articulo\'',NULL,NULL),(24,'C000360','CARMEN GONZALEZ DE WACHHOLZ','douglas','2020-03-02','22:55','1','3747173-2','C.I.','01',2,174500.00,0.00,0.00,174500.00,'Cerrada',NULL,NULL,NULL,NULL,0,'Si',NULL,'2022-03-07','15:57:48',NULL,'G$',1.00,NULL,NULL,'Contado',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'\'Articulo\'',NULL,NULL),(25,'C002788','ROMINA NOELIA SCHMIDKE NAHER','douglas','2020-03-02','22:58','1','3964166-0','C.I.','01',2,369600.00,0.00,0.00,369600.00,'En_caja',NULL,NULL,NULL,NULL,0,'Si','Contado',NULL,NULL,NULL,'G$',1.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'\'Articulo\'',NULL,NULL),(26,'C108588','DOGLAS MAURICIO KOCH','douglas','2020-05-18','22:51','1','3934809-1','C.I.','01',1,0.00,NULL,0.00,0.00,'Abierta',NULL,NULL,NULL,NULL,0,'Si',NULL,NULL,NULL,NULL,'G$',1.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'\'Articulo\'',NULL,NULL),(27,'C000002','DOGLAS A DEMBOGURSKI FEIX','douglas','2020-05-21','00:28','1','4933243-0','C.I.','01',1,42000.00,0.00,0.00,42000.00,'Abierta',NULL,NULL,NULL,NULL,0,'Si',NULL,NULL,NULL,NULL,'G$',1.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'\'Articulo\'',NULL,NULL),(28,'C000006','ROMINA DELGADO GRAZ','douglas','2020-05-26','23:05','1','4851225-7','C.I.','01',1,1009000.00,0.00,0.00,1009000.00,'Cerrada','001','10','Pre-Impresa','Factura',0,'Si',NULL,'2022-03-11','18:53:50',NULL,'G$',1.00,NULL,1,'Credito',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'\'Articulo\'',NULL,NULL),(29,'C000003','ANDREA DUNKE','douglas','2020-06-18','22:34','1','5715509-7','C.I.','01',1,200000.00,0.00,0.00,200000.00,'En_caja',NULL,NULL,NULL,NULL,0,'Si','Contado',NULL,NULL,NULL,'G$',1.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'\'Articulo\'',NULL,NULL),(30,'C000002','DOGLAS A DEMBOGURSKI FEIX','douglas','2020-06-29','22:07','1','4933243-0','C.I.','01',1,67000.00,0.00,0.00,67000.00,'Cerrada','001','4','Pre-Impresa','Factura',0,'Si','Contado','2022-02-21','23:42:21',NULL,'G$',1.00,NULL,NULL,'Contado',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'\'Articulo\'',NULL,NULL),(31,'C000002','DOGLAS A DEMBOGURSKI FEIX','douglas','2021-02-13','11:53','1','4933243-0','C.I.','01',1,560000.00,0.00,0.00,560000.00,'Cerrada',NULL,NULL,NULL,NULL,0,'Si',NULL,'2022-03-11','19:22:51',NULL,'G$',1.00,NULL,NULL,'Contado',NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'\'Articulo\'',NULL,NULL),(32,'C000002','DOGLAS A DEMBOGURSKI FEIX','douglas','2021-10-21','19:24','1','4933243-0','C.I.','01',1,0.00,NULL,0.00,0.00,'Abierta',NULL,NULL,NULL,NULL,0,'Si',NULL,NULL,NULL,NULL,'U$',6800.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'\'Articulo\'',NULL,NULL),(33,'C000010','JORGE GUEDES','douglas','2021-10-25','17:46','1','7854215-4','C.I.','01',1,0.00,NULL,0.00,0.00,'Abierta',NULL,NULL,NULL,NULL,0,'Si',NULL,NULL,NULL,NULL,'G$',1.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'\'Articulo\'',NULL,NULL),(36,'C000028','JOEL GARCIA MORENO','douglas','2021-10-27','17:43','1','','C.I.','01',1,0.00,NULL,0.00,0.00,'Presupuesto',NULL,NULL,NULL,NULL,0,'Si',NULL,NULL,NULL,NULL,'G$',1.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'\'Articulo\'',NULL,NULL),(37,'C000002','DOGLAS A DEMBOGURSKI FEIX','douglas','2021-10-27','20:14','1','4933243-0','C.I.','01',1,125000.00,0.00,0.00,125000.00,'Cerrada',NULL,NULL,NULL,NULL,0,'Si',NULL,'2022-03-11','19:10:23',NULL,'G$',1.00,NULL,NULL,'Contado',NULL,NULL,NULL,NULL,0,NULL,NULL,'Basado en Diagnostico Nro: 57',57,'\'Articulo\'',NULL,NULL),(38,'C000002','DOGLAS A DEMBOGURSKI FEIX','douglas','2021-10-27','20:53','1','4933243-0','C.I.','01',1,982000.00,0.00,0.00,982000.00,'Presupuesto','001','9','Pre-Impresa','Factura',0,'Si',NULL,NULL,NULL,NULL,'G$',1.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,NULL,NULL,'\'Articulo\'',NULL,NULL),(39,'C000007','FEDERICO BORDON','douglas','2021-10-29','21:32','1','45212015-2','C.I.','01',1,100000.00,0.00,0.00,100000.00,'Presupuesto',NULL,NULL,NULL,NULL,0,'Si',NULL,NULL,NULL,NULL,'G$',1.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'',NULL,'\'Articulo\'',NULL,NULL),(40,'C000013','FERNANDO LLAMOSSAS','douglas','2021-10-29','21:34','1','6289266-5','C.I.','01',1,25000.00,0.00,0.00,25000.00,'Cerrada',NULL,NULL,NULL,NULL,0,'Si','Contado','2022-02-21','23:39:13',NULL,'G$',1.00,NULL,NULL,'Contado',NULL,NULL,NULL,NULL,0,NULL,NULL,'Basado en Diagnostico Nro: 47',47,'\'Articulo\'',NULL,NULL),(41,'C000007','FEDERICO BORDON','douglas','2021-10-29','21:39','1','45212015-2','C.I.','01',1,0.00,NULL,0.00,0.00,'Presupuesto',NULL,NULL,NULL,NULL,0,'Si',NULL,NULL,NULL,NULL,'G$',1.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'Basado en Diagnostico Nro: 56',56,'\'Articulo\'',NULL,NULL),(42,'C000002','DOGLAS A DEMBOGURSKI FEIX','douglas','2021-10-29','22:23','1','4933243-0','C.I.','01',1,3896200.00,2.00,0.00,3896200.00,'Cerrada','001','8','Pre-Impresa','Factura',0,'Si',NULL,'2022-03-07','15:46:00',NULL,'G$',1.00,NULL,NULL,'Contado',NULL,NULL,NULL,NULL,0,NULL,NULL,'Basado en Diagnostico Nro: 38',38,'\'Articulo\'',NULL,NULL),(43,'C000002','DOGLAS A DEMBOGURSKI FEIX','douglas','2021-11-02','19:19','1','4933243-0','C.I.','01',1,0.00,NULL,0.00,0.00,'Presupuesto',NULL,NULL,NULL,NULL,0,'Si',NULL,NULL,NULL,NULL,'G$',1.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'Basado en Diagnostico Nro: 59',59,'\'Articulo\'',NULL,NULL),(44,'C000002','DOGLAS A DEMBOGURSKI FEIX','douglas','2021-12-28','17:46','1','4933243-0','C.I.','01',1,0.00,NULL,0.00,0.00,'Presupuesto',NULL,NULL,NULL,NULL,0,'Si',NULL,NULL,NULL,NULL,'G$',1.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'Basado en Diagnostico Nro: 66',66,'\'Articulo\'',NULL,NULL),(45,'C000003','ANDREA DUNKE','douglas','2022-02-10','22:50','1','5715509-7','C.I.','01',1,0.00,NULL,0.00,0.00,'Presupuesto',NULL,NULL,NULL,NULL,0,'Si',NULL,NULL,NULL,NULL,'G$',1.00,NULL,NULL,NULL,NULL,NULL,NULL,NULL,0,NULL,NULL,'',NULL,'\'Articulo\'',NULL,NULL),(46,'C000003','ANDREA DUNKE','douglas','2022-02-22','23:22','1','5715509-7','C.I.','01',1,220000.00,0.00,0.00,220000.00,'Cerrada',NULL,NULL,NULL,NULL,0,'Si',NULL,'2022-03-11','19:28:39',NULL,'G$',1.00,NULL,NULL,'Contado',NULL,NULL,NULL,NULL,0,NULL,NULL,'',NULL,'\'Articulo\'',NULL,NULL);

/*Table structure for table `fallas` */

DROP TABLE IF EXISTS `fallas`;

CREATE TABLE `fallas` (
  `nro_falla` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(30) NOT NULL,
  `lote` varchar(60) NOT NULL,
  `padre` varchar(60) DEFAULT NULL,
  `tipo_falla` varchar(4) DEFAULT NULL,
  `usuario` varchar(30) NOT NULL,
  `fecha` datetime DEFAULT NULL,
  `mts` decimal(6,2) DEFAULT NULL,
  `mts_inv` decimal(6,2) DEFAULT NULL,
  `stock_actual` decimal(16,2) DEFAULT NULL,
  `img` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`nro_falla`,`codigo`,`lote`),
  KEY `Ref122319` (`lote`,`codigo`),
  KEY `Ref6320` (`usuario`),
  KEY `Reflotes3191` (`codigo`,`lote`),
  CONSTRAINT `Reflotes3191` FOREIGN KEY (`codigo`, `lote`) REFERENCES `lotes` (`codigo`, `lote`),
  CONSTRAINT `Refusuarios3201` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `fallas` */

/*Table structure for table `fraccionamientos` */

DROP TABLE IF EXISTS `fraccionamientos`;

CREATE TABLE `fraccionamientos` (
  `id_frac` int(11) NOT NULL AUTO_INCREMENT,
  `fecha` date DEFAULT NULL,
  `hora` varchar(12) DEFAULT NULL,
  `usuario` varchar(30) NOT NULL,
  `codigo` varchar(30) DEFAULT NULL,
  `lote` varchar(30) DEFAULT NULL,
  `tipo` varchar(60) DEFAULT NULL,
  `signo` varchar(2) DEFAULT NULL,
  `inicial` decimal(16,2) DEFAULT NULL,
  `cantidad` decimal(16,2) DEFAULT NULL,
  `final` decimal(16,2) DEFAULT NULL,
  `um` varchar(10) NOT NULL,
  `p_costo` decimal(16,2) DEFAULT NULL,
  `motivo` varchar(100) DEFAULT NULL,
  `tara` int(11) DEFAULT NULL,
  `kg_desc` decimal(16,3) DEFAULT NULL,
  `gramaje` varchar(30) DEFAULT NULL,
  `ancho` decimal(16,2) DEFAULT NULL,
  `tiempo_proc` decimal(12,0) DEFAULT NULL,
  `estado` varchar(10) DEFAULT NULL,
  `valor` decimal(16,2) DEFAULT NULL,
  `suc` varchar(10) DEFAULT NULL,
  `suc_destino` varchar(10) DEFAULT NULL,
  `presentacion` varchar(30) DEFAULT NULL,
  `padre` varchar(30) DEFAULT NULL,
  `cta_cont` varchar(30) DEFAULT NULL,
  `pais_origen` varchar(30) DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id_frac`),
  KEY `Ref6118` (`usuario`),
  KEY `Ref10119` (`um`),
  CONSTRAINT `Refunidades_medida119` FOREIGN KEY (`um`) REFERENCES `unidades_medida` (`um_cod`),
  CONSTRAINT `Refusuarios118` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `fraccionamientos` */

/*Table structure for table `grupos` */

DROP TABLE IF EXISTS `grupos`;

CREATE TABLE `grupos` (
  `id_grupo` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) DEFAULT NULL,
  `descrip` varchar(1024) DEFAULT NULL,
  `modulo` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_grupo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

/*Data for the table `grupos` */

insert  into `grupos`(`id_grupo`,`nombre`,`descrip`,`modulo`) values (1,'Mecanicos','Mecanicos','Mecanicos'),(2,'Auxiliar de Mecanicos','Auxiliares de Mecanicos','Auxiliares'),(3,'Gerentes','Gerentes','Gerentes'),(4,'Cajeros','Cajeros','Caja'),(5,'TI','Gerentes de Tecnologias de Información','TI');

/*Table structure for table `hist_precios` */

DROP TABLE IF EXISTS `hist_precios`;

CREATE TABLE `hist_precios` (
  `id_hist` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(30) NOT NULL,
  `fecha` date DEFAULT NULL,
  `hora` varchar(10) DEFAULT NULL,
  `suc` varchar(4) DEFAULT NULL,
  `codigo` varchar(30) NOT NULL,
  `lote` varchar(60) NOT NULL,
  `num` int(11) NOT NULL,
  `moneda` varchar(4) NOT NULL,
  `um` varchar(10) NOT NULL,
  `precio_art_ant` decimal(16,2) DEFAULT NULL,
  `desc_ant` decimal(10,6) DEFAULT NULL,
  `precio_final_ant` decimal(16,2) DEFAULT NULL,
  `precio_art_actual` decimal(16,2) DEFAULT NULL,
  `desc_actual` decimal(10,6) DEFAULT NULL,
  `precio_final_actual` decimal(16,2) DEFAULT NULL,
  `estado_venta` varchar(16) DEFAULT NULL,
  `fecha_impresion` datetime DEFAULT NULL,
  `cant_impresiones` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_hist`),
  KEY `Ref6114` (`usuario`),
  KEY `Ref157291` (`codigo`,`um`,`moneda`,`num`,`lote`),
  CONSTRAINT `Refusuarios114` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `hist_precios` */

/*Table structure for table `historial` */

DROP TABLE IF EXISTS `historial`;

CREATE TABLE `historial` (
  `id_hist` int(11) NOT NULL AUTO_INCREMENT,
  `suc` varchar(10) NOT NULL,
  `codigo` varchar(30) NOT NULL,
  `lote` varchar(30) NOT NULL,
  `tipo_ent` varchar(4) NOT NULL,
  `nro_identif` int(11) NOT NULL,
  `linea` int(11) NOT NULL,
  `tipo_doc` varchar(4) DEFAULT NULL,
  `nro_doc` int(11) DEFAULT NULL,
  `fecha_hora` datetime DEFAULT NULL,
  `usuario` varchar(30) NOT NULL,
  `direccion` varchar(10) DEFAULT NULL,
  `cantidad` decimal(16,2) DEFAULT NULL,
  `gramaje` decimal(16,2) DEFAULT NULL,
  `tara` decimal(16,2) DEFAULT NULL,
  `ancho` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`id_hist`,`suc`,`codigo`,`lote`,`tipo_ent`,`nro_identif`,`linea`),
  KEY `Ref121220` (`suc`,`codigo`,`lote`,`linea`,`tipo_ent`,`nro_identif`),
  KEY `Ref6221` (`usuario`),
  KEY `Refstock220` (`suc`,`codigo`,`lote`,`tipo_ent`,`nro_identif`,`linea`),
  CONSTRAINT `Refstock220` FOREIGN KEY (`suc`, `codigo`, `lote`, `tipo_ent`) REFERENCES `stock` (`suc`, `codigo`, `lote`, `tipo_ent`),
  CONSTRAINT `Refusuarios221` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=latin1;

/*Data for the table `historial` */

/*Table structure for table `historial_costos` */

DROP TABLE IF EXISTS `historial_costos`;

CREATE TABLE `historial_costos` (
  `id_hist` int(11) NOT NULL AUTO_INCREMENT,
  `codigo` varchar(30) NOT NULL,
  `usuario` varchar(30) NOT NULL,
  `fecha` datetime DEFAULT NULL,
  `cuenta_aum` varchar(30) NOT NULL,
  `cuenta_dism` varchar(30) NOT NULL,
  `costo_prom` decimal(16,2) DEFAULT NULL,
  `costo_cif` decimal(16,2) NOT NULL,
  `notas` varchar(400) DEFAULT NULL,
  PRIMARY KEY (`id_hist`,`codigo`),
  KEY `Ref119244` (`codigo`),
  KEY `Ref10245` (`cuenta_aum`),
  KEY `Ref31246` (`usuario`),
  KEY `Ref10247` (`cuenta_dism`),
  CONSTRAINT `Refarticulos244` FOREIGN KEY (`codigo`) REFERENCES `articulos` (`codigo`),
  CONSTRAINT `Refplan_cuentas245` FOREIGN KEY (`cuenta_aum`) REFERENCES `plan_cuentas` (`cuenta`),
  CONSTRAINT `Refplan_cuentas247` FOREIGN KEY (`cuenta_dism`) REFERENCES `plan_cuentas` (`cuenta`),
  CONSTRAINT `Refusuarios246` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=latin1;

/*Data for the table `historial_costos` */

/*Table structure for table `historial_seg` */

DROP TABLE IF EXISTS `historial_seg`;

CREATE TABLE `historial_seg` (
  `id_hist` int(11) NOT NULL AUTO_INCREMENT,
  `sap_doc` int(11) DEFAULT NULL,
  `id_cuota` int(11) DEFAULT NULL,
  `usuario` varchar(30) NOT NULL,
  `fecha` varchar(30) DEFAULT NULL,
  `tipo_com` varchar(30) DEFAULT NULL,
  `notas` varchar(1024) DEFAULT NULL,
  `estado` varchar(10) DEFAULT NULL,
  `f_nro` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_hist`),
  KEY `Ref20143` (`f_nro`,`id_cuota`),
  KEY `Ref6144` (`usuario`),
  CONSTRAINT `Refusuarios144` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `historial_seg` */

/*Table structure for table `imagenes` */

DROP TABLE IF EXISTS `imagenes`;

CREATE TABLE `imagenes` (
  `id_diag` int(11) NOT NULL,
  `url` varchar(140) NOT NULL,
  `descrip` varchar(6000) DEFAULT NULL,
  PRIMARY KEY (`id_diag`,`url`),
  CONSTRAINT `Refdiagnosticos248` FOREIGN KEY (`id_diag`) REFERENCES `recepcion` (`id_diag`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `imagenes` */

insert  into `imagenes`(`id_diag`,`url`,`descrip`) values (30,'diag_0.jpg','1111 taschibra'),(30,'diag_1.jpg','Fa plac '),(30,'diag_2.jpg','Dell '),(30,'diag_3.jpg','Sate'),(30,'diag_4.jpg','Hfvbjg'),(30,'diag_5.jpg','Hfufyf6f6ucucu'),(31,'diag_0.jpg','Prueba 01 chapas'),(32,'diag_0.jpg','Prueba 01 chapas'),(32,'diag_1.jpg','Prueba imagen 02'),(33,'diag_0.jpg',''),(33,'diag_1.jpg',''),(33,'diag_2.jpg',''),(33,'diag_3.jpg',''),(34,'diag_0.jpg',''),(35,'diag_0.jpg','Fully furnished, equipped with latest generation appliances, 2'),(35,'diag_1.jpg','Large room, 4-leaf glass door opening onto the coutyard, glass door opening onto'),(36,'diag_0.jpg','  WHERE codigo_entidad =  AND chapa  '),(37,'diag_0.jpg','adsfasdfasdf'),(38,'diag_0.jpg','diagnostico 1'),(38,'diag_1.jpg','Fully furnished, equipped with latest generation appliances, 2'),(38,'diag_2.jpg','Large room, 4-leaf glass door opening onto the coutyard, glass door opening onto'),(39,'diag_0.jpg','Fully furnished, equipped with latest generation appliances, 2'),(39,'diag_1.jpg','Large room, 4-leaf glass door opening onto the coutyard, glass door opening onto  Large room, 4-leaf glass door opening onto the coutyard, glass door opening onto Large room, 4-leaf glass door opening onto the coutyard, glass door opening onto'),(39,'diag_2.jpg','Tuggyfu'),(40,'diag_0.jpg','D1'),(40,'diag_1.jpg','D2'),(41,'diag_0.jpg','Cambiar cables '),(41,'diag_1.jpg','Cable roto'),(43,'diag_0.jpg',''),(43,'diag_1.jpg',''),(44,'diag_0.jpg','Discos de Frenos delanteros deteriorados'),(48,'diag_0.jpg','Eje trasero roto'),(48,'diag_1.jpg','Varilla derecha rota'),(49,'diag_0.jpg','rotula rota'),(52,'diag_0.jpg',''),(60,'diag_0.jpg','Pastgjvcg'),(67,'diag_0.jpg','dfd');

/*Table structure for table `imventario_cab` */

DROP TABLE IF EXISTS `imventario_cab`;

CREATE TABLE `imventario_cab` (
  `id_inv` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(30) DEFAULT NULL,
  `suc` varchar(10) NOT NULL,
  `inicio` datetime DEFAULT NULL,
  `fin` datetime DEFAULT NULL,
  `estado` varchar(50) DEFAULT NULL,
  `cerrado_por` varbinary(50) DEFAULT NULL,
  PRIMARY KEY (`id_inv`),
  KEY `Ref18197` (`suc`),
  CONSTRAINT `Refsucursales197` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `imventario_cab` */

/*Table structure for table `inv_gastos` */

DROP TABLE IF EXISTS `inv_gastos`;

CREATE TABLE `inv_gastos` (
  `nro_gasto` int(11) NOT NULL AUTO_INCREMENT,
  `invoice` varchar(40) NOT NULL,
  `n_nro` int(11) NOT NULL,
  `cod_gasto` int(11) DEFAULT NULL,
  `nombre_gasto` varchar(40) DEFAULT NULL,
  `valor` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`nro_gasto`,`invoice`,`n_nro`),
  KEY `Ref61108` (`n_nro`,`invoice`),
  KEY `Refinvoice108` (`invoice`,`n_nro`),
  CONSTRAINT `Refinvoice108` FOREIGN KEY (`invoice`, `n_nro`) REFERENCES `invoice` (`invoice`, `n_nro`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `inv_gastos` */

/*Table structure for table `inventario` */

DROP TABLE IF EXISTS `inventario`;

CREATE TABLE `inventario` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_inv` int(11) NOT NULL,
  `usuario` varchar(30) NOT NULL,
  `suc` varchar(10) DEFAULT NULL,
  `um` varchar(10) DEFAULT NULL,
  `lote` varchar(30) DEFAULT NULL,
  `codigo` varchar(30) NOT NULL,
  `stock_ini` decimal(16,2) DEFAULT NULL,
  `gramaje_ini` decimal(16,2) DEFAULT NULL,
  `ancho_ini` decimal(3,2) DEFAULT NULL,
  `tara_ini` decimal(16,2) DEFAULT NULL,
  `kg_desc_ini` decimal(16,3) DEFAULT NULL,
  `tipo_ini` varchar(11) DEFAULT NULL,
  `kg_calc` decimal(16,3) DEFAULT NULL,
  `stock` decimal(16,2) DEFAULT NULL,
  `gramaje` decimal(16,2) DEFAULT NULL,
  `ancho` decimal(3,2) DEFAULT NULL,
  `tara` decimal(16,2) DEFAULT NULL,
  `kg` decimal(16,3) DEFAULT NULL,
  `kg_desc` decimal(16,3) DEFAULT NULL,
  `tipo` varchar(11) DEFAULT NULL,
  `fecha` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`,`id_inv`),
  KEY `Ref109195` (`id_inv`),
  KEY `Ref6196` (`usuario`),
  CONSTRAINT `Refimventario_cab195` FOREIGN KEY (`id_inv`) REFERENCES `imventario_cab` (`id_inv`),
  CONSTRAINT `Refusuarios196` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `inventario` */

/*Table structure for table `invoice` */

DROP TABLE IF EXISTS `invoice`;

CREATE TABLE `invoice` (
  `invoice` varchar(40) NOT NULL,
  `n_nro` int(11) NOT NULL,
  `moneda` varchar(4) NOT NULL,
  `usuario` varchar(30) NOT NULL,
  `cod_prov` varchar(10) DEFAULT NULL,
  `ruc` varchar(30) DEFAULT NULL,
  `proveedor` varchar(80) DEFAULT NULL,
  `cotiz` decimal(16,2) DEFAULT NULL,
  `total` decimal(16,2) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `obs` varchar(2048) DEFAULT NULL,
  `origen` varchar(80) DEFAULT NULL,
  `estado` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`invoice`,`n_nro`),
  KEY `Ref6101` (`usuario`),
  KEY `Ref52107` (`n_nro`),
  KEY `Ref15109` (`moneda`),
  CONSTRAINT `Refmonedas109` FOREIGN KEY (`moneda`) REFERENCES `monedas` (`m_cod`),
  CONSTRAINT `Refnota_pedido_compra107` FOREIGN KEY (`n_nro`) REFERENCES `nota_pedido_compra` (`n_nro`),
  CONSTRAINT `Refusuarios101` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `invoice` */

/*Table structure for table `lista_adyacencias` */

DROP TABLE IF EXISTS `lista_adyacencias`;

CREATE TABLE `lista_adyacencias` (
  `suc` varchar(10) NOT NULL,
  `nodo` varchar(6) NOT NULL,
  `adya` varchar(6) NOT NULL,
  `costo` int(11) DEFAULT NULL,
  PRIMARY KEY (`suc`,`nodo`,`adya`),
  KEY `Ref112193` (`nodo`,`suc`),
  CONSTRAINT `Refnodos193` FOREIGN KEY (`suc`, `nodo`) REFERENCES `nodos` (`suc`, `nodo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `lista_adyacencias` */

/*Table structure for table `lista_materiales` */

DROP TABLE IF EXISTS `lista_materiales`;

CREATE TABLE `lista_materiales` (
  `codigo` varchar(30) NOT NULL,
  `articulo` varchar(30) NOT NULL,
  `ref` varchar(6) DEFAULT NULL,
  `descrip` varchar(100) DEFAULT NULL,
  `um` varchar(10) NOT NULL,
  `cantidad` decimal(16,2) DEFAULT NULL,
  `rendimiento` decimal(14,2) DEFAULT NULL,
  `precio_unit` decimal(16,2) DEFAULT NULL,
  `sub_total` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`codigo`,`articulo`),
  KEY `Ref10271` (`um`),
  KEY `Ref119272` (`codigo`),
  KEY `Ref119275` (`articulo`),
  CONSTRAINT `Refarticulos272` FOREIGN KEY (`codigo`) REFERENCES `articulos` (`codigo`),
  CONSTRAINT `Refarticulos275` FOREIGN KEY (`articulo`) REFERENCES `articulos` (`codigo`),
  CONSTRAINT `Refunidades_medida271` FOREIGN KEY (`um`) REFERENCES `unidades_medida` (`um_cod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `lista_materiales` */

/*Table structure for table `lista_prec_x_art` */

DROP TABLE IF EXISTS `lista_prec_x_art`;

CREATE TABLE `lista_prec_x_art` (
  `num` int(11) NOT NULL,
  `moneda` varchar(4) NOT NULL,
  `um` varchar(10) NOT NULL,
  `codigo` varchar(30) NOT NULL,
  `precio` decimal(16,2) DEFAULT NULL,
  `usuario` varchar(30) NOT NULL,
  `fecha` datetime DEFAULT NULL,
  PRIMARY KEY (`num`,`moneda`,`um`,`codigo`),
  KEY `Ref156281` (`um`,`num`,`moneda`),
  KEY `Ref119282` (`codigo`),
  KEY `Ref6283` (`usuario`),
  CONSTRAINT `Refarticulos282` FOREIGN KEY (`codigo`) REFERENCES `articulos` (`codigo`),
  CONSTRAINT `Refusuarios283` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `lista_prec_x_art` */

insert  into `lista_prec_x_art`(`num`,`moneda`,`um`,`codigo`,`precio`,`usuario`,`fecha`) values (1,'G$','CJ-10','IN0001',0.00,'douglas','2022-01-13 17:31:37'),(1,'G$','CJ-5','IN0001',0.00,'douglas','2022-01-13 17:35:09'),(1,'G$','Unid','IN0001',25000.00,'douglas','2020-02-26 19:53:24'),(1,'G$','Unid','IN0002',21000.00,'douglas','2020-02-26 19:54:42'),(1,'G$','Unid','IN0003',95000.00,'douglas','2020-02-27 19:49:28'),(1,'G$','Unid','IN0004',32000.00,'douglas','2020-02-27 19:51:06'),(1,'G$','Unid','IN0005',40000.00,'douglas','2020-02-27 19:54:47'),(1,'G$','Unid','IN0006',90000.00,'douglas','2020-02-27 19:56:53'),(1,'G$','Unid','SR001',10000.00,'douglas','2020-02-24 20:16:59'),(1,'G$','Unid','SR003',0.00,'douglas','2021-11-02 14:25:49'),(2,'G$','Unid','IN0001',24500.00,'douglas','2020-02-26 19:53:24'),(2,'G$','Unid','IN0002',20600.00,'douglas','2020-02-26 19:54:42'),(2,'G$','Unid','IN0003',93100.00,'douglas','2020-02-27 19:49:28'),(2,'G$','Unid','IN0004',31350.00,'douglas','2020-02-27 19:51:06'),(2,'G$','Unid','IN0005',39200.00,'douglas','2020-02-27 19:54:47'),(2,'G$','Unid','IN0006',88200.00,'douglas','2020-02-27 19:56:53'),(2,'G$','Unid','SR001',9800.00,'douglas','2020-02-24 20:16:59'),(2,'G$','Unid','SR003',0.00,'douglas','2021-11-02 14:25:49'),(3,'G$','Unid','IN0001',23750.00,'douglas','2020-02-26 19:53:24'),(3,'G$','Unid','IN0002',19950.00,'douglas','2020-02-26 19:54:42'),(3,'G$','Unid','IN0003',90250.00,'douglas','2020-02-27 19:49:28'),(3,'G$','Unid','IN0004',30400.00,'douglas','2020-02-27 19:51:06'),(3,'G$','Unid','IN0005',38000.00,'douglas','2020-02-27 19:54:47'),(3,'G$','Unid','IN0006',85500.00,'douglas','2020-02-27 19:56:53'),(3,'G$','Unid','SR001',9500.00,'douglas','2020-02-24 20:16:59'),(3,'G$','Unid','SR003',0.00,'douglas','2021-11-02 14:25:49'),(4,'G$','Unid','IN0001',23000.00,'douglas','2020-02-26 19:53:24'),(4,'G$','Unid','IN0002',19300.00,'douglas','2020-02-26 19:54:42'),(4,'G$','Unid','IN0003',87400.00,'douglas','2020-02-27 19:49:28'),(4,'G$','Unid','IN0004',29450.00,'douglas','2020-02-27 19:51:06'),(4,'G$','Unid','IN0005',36800.00,'douglas','2020-02-27 19:54:47'),(4,'G$','Unid','IN0006',82800.00,'douglas','2020-02-27 19:56:53'),(4,'G$','Unid','SR001',9200.00,'douglas','2020-02-24 20:16:59'),(4,'G$','Unid','SR003',0.00,'douglas','2021-11-02 14:25:49'),(5,'G$','Unid','IN0001',22500.00,'douglas','2020-02-26 19:53:24'),(5,'G$','Unid','IN0002',18900.00,'douglas','2020-02-26 19:54:42'),(5,'G$','Unid','IN0003',85500.00,'douglas','2020-02-27 19:49:28'),(5,'G$','Unid','IN0004',28800.00,'douglas','2020-02-27 19:51:06'),(5,'G$','Unid','IN0005',36000.00,'douglas','2020-02-27 19:54:47'),(5,'G$','Unid','IN0006',81000.00,'douglas','2020-02-27 19:56:53'),(5,'G$','Unid','SR001',9000.00,'douglas','2020-02-24 20:16:59'),(5,'G$','Unid','SR003',0.00,'douglas','2021-11-02 14:25:49');

/*Table structure for table `lista_precios` */

DROP TABLE IF EXISTS `lista_precios`;

CREATE TABLE `lista_precios` (
  `num` int(11) NOT NULL,
  `moneda` varchar(4) NOT NULL,
  `um` varchar(10) NOT NULL,
  `descrip` varchar(30) DEFAULT NULL,
  `ref_num` int(11) NOT NULL,
  `ref_moneda` varchar(4) NOT NULL,
  `ref_um` varchar(10) NOT NULL,
  `factor` decimal(4,3) DEFAULT NULL,
  `regla_redondeo` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`num`,`moneda`,`um`),
  KEY `Ref15276` (`moneda`),
  KEY `Ref10278` (`um`),
  KEY `Ref156280` (`ref_um`,`ref_num`,`ref_moneda`),
  KEY `Reflista_precios280` (`ref_num`,`ref_moneda`,`ref_um`),
  CONSTRAINT `Reflista_precios280` FOREIGN KEY (`ref_num`, `ref_moneda`, `ref_um`) REFERENCES `lista_precios` (`num`, `moneda`, `um`),
  CONSTRAINT `Refmonedas276` FOREIGN KEY (`moneda`) REFERENCES `monedas` (`m_cod`),
  CONSTRAINT `Refunidades_medida278` FOREIGN KEY (`um`) REFERENCES `unidades_medida` (`um_cod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `lista_precios` */

insert  into `lista_precios`(`num`,`moneda`,`um`,`descrip`,`ref_num`,`ref_moneda`,`ref_um`,`factor`,`regla_redondeo`) values (1,'G$','CJ-10','1-Gs-CJ-10',1,'G$','Unid',1.000,'SEDECO'),(1,'G$','CJ-5','1-Gs-CJ-5',1,'G$','Unid',1.000,'SEDECO'),(1,'G$','Mts','1-Gs-Mts',1,'G$','Mts',1.000,'SEDECO'),(1,'G$','Unid','1-Gs-Unid',1,'G$','Unid',1.000,'SEDECO'),(2,'G$','Mts','2-Gs-Mts',1,'G$','Mts',0.980,'SEDECO'),(2,'G$','Unid','2-Gs-Unid',1,'G$','Unid',0.980,'SEDECO'),(3,'G$','Mts','3-Gs-Mts',1,'G$','Mts',0.950,'SEDECO'),(3,'G$','Unid','3-Gs-Unid',1,'G$','Unid',0.950,'SEDECO'),(4,'G$','Mts','4-Gs-Mts',1,'G$','Mts',0.920,'SEDECO'),(4,'G$','Unid','4-Gs-Unid',1,'G$','Unid',0.920,'SEDECO'),(5,'G$','Mts','5-Gs-Mts',1,'G$','Mts',0.900,'SEDECO'),(5,'G$','Unid','5-Gs-Unid',1,'G$','Unid',0.900,'SEDECO');

/*Table structure for table `logs` */

DROP TABLE IF EXISTS `logs`;

CREATE TABLE `logs` (
  `id_log` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(30) NOT NULL,
  `ip` varchar(30) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` varchar(12) DEFAULT NULL,
  `accion` varchar(30) DEFAULT NULL,
  `tipo` varchar(20) DEFAULT NULL,
  `doc_num` varchar(16) DEFAULT NULL,
  `data` varchar(1000) DEFAULT NULL,
  PRIMARY KEY (`id_log`),
  KEY `Ref639` (`usuario`),
  CONSTRAINT `Refusuarios39` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=59 DEFAULT CHARSET=latin1;

/*Data for the table `logs` */

insert  into `logs`(`id_log`,`usuario`,`ip`,`fecha`,`hora`,`accion`,`tipo`,`doc_num`,`data`) values (1,'douglas',NULL,'2020-03-02','18:27:16','Error Stock','Stock insuficiente','20',' | Stock insuficiente Codigo: SR001  Lote:   ( < 1.00) |  | Stock insuficiente Codigo: IN0002  Lote:   ( < 5.00) |  | Stock insuficiente Codigo: IN0005  Lote:   ( < 1.00) |  | Stock insuficiente Codigo: IN0002  Lote:   ( < 1.00) | '),(2,'douglas',NULL,'2020-03-02','18:28:25','Error Stock','Stock insuficiente','20',' | Stock insuficiente Codigo: SR001  Lote:   ( < 1.00) |  | Stock insuficiente Codigo: IN0002  Lote:   ( < 5.00) |  | Stock insuficiente Codigo: IN0005  Lote:   ( < 1.00) |  | Stock insuficiente Codigo: IN0002  Lote:   ( < 1.00) | '),(3,'douglas',NULL,'2020-03-02','18:48:07','Cerrar Venta','Factura','20','Factura Nro: 20'),(4,'douglas',NULL,'2021-10-27','15:26:07','Error Stock','Stock insuficiente','25',' | Stock insuficiente Codigo: IN0002  Lote:   ( < 2.00) | '),(5,'taller','127.0.0.1','2022-02-09','18:22:07','Costo PPP',NULL,NULL,'Codigo: IN0002, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 44.00, Valor Compra Actual: 756000, Ref.: 1'),(6,'taller','127.0.0.1','2022-02-09','18:22:07','Costo PPP',NULL,NULL,'Codigo: IN0001, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 20.00, Valor Compra Actual: 90000, Ref.: 1'),(7,'taller','127.0.0.1','2022-02-09','18:26:51','Costo PPP',NULL,NULL,'Codigo: IN0002, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 44.00, Valor Compra Actual: 756000, Ref.: 1'),(8,'taller','127.0.0.1','2022-02-09','18:26:51','Costo PPP',NULL,NULL,'Codigo: IN0001, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 20.00, Valor Compra Actual: 90000, Ref.: 1'),(9,'taller','127.0.0.1','2022-02-09','18:29:15','Costo PPP',NULL,NULL,'Codigo: IN0002, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 44.00, Valor Compra Actual: 756000, Ref.: 1'),(10,'taller','127.0.0.1','2022-02-09','18:29:15','Costo PPP',NULL,NULL,'Codigo: IN0001, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 20.00, Valor Compra Actual: 90000, Ref.: 1'),(11,'taller','127.0.0.1','2022-02-09','18:30:46','Costo PPP',NULL,NULL,'Codigo: IN0002, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 44.00, Valor Compra Actual: 756000, Ref.: 1'),(12,'taller','127.0.0.1','2022-02-09','18:30:46','Costo PPP',NULL,NULL,'Codigo: IN0001, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 20.00, Valor Compra Actual: 90000, Ref.: 1'),(13,'taller','127.0.0.1','2022-02-09','18:36:46','Costo PPP',NULL,NULL,'Codigo: IN0002, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 44.00, Valor Compra Actual: 756000, Ref.: 1'),(14,'taller','127.0.0.1','2022-02-09','18:36:46','Costo PPP',NULL,NULL,'Codigo: IN0001, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 20.00, Valor Compra Actual: 90000, Ref.: 1'),(15,'taller','127.0.0.1','2022-02-10','19:26:16','Costo PPP',NULL,NULL,'Codigo: IN0001, Stock_Sctual:20.00, Costo PPP Actual:4500.00, Valor Stock Actual: 90000.0000, Cant.Compra Actual: 10.00, Valor Compra Actual: 10200000, Ref.: 2'),(16,'taller','127.0.0.1','2022-02-10','19:26:16','Costo PPP',NULL,NULL,'Codigo: IN0006, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 16.00, Valor Compra Actual: 1523200, Ref.: 2'),(17,'taller','127.0.0.1','2022-02-10','19:26:16','Costo PPP',NULL,NULL,'Codigo: IN0002, Stock_Sctual:44.00, Costo PPP Actual:17181.82, Valor Stock Actual: 756000.0800, Cant.Compra Actual: 10.00, Valor Compra Actual: 8160000, Ref.: 2'),(18,'taller','127.0.0.1','2022-02-10','19:30:54','Costo PPP',NULL,NULL,'Codigo: IN0001, Stock_Sctual:20.00, Costo PPP Actual:343000.00, Valor Stock Actual: 6860000.0000, Cant.Compra Actual: 10.00, Valor Compra Actual: 10200000, Ref.: 2'),(19,'taller','127.0.0.1','2022-02-10','19:30:54','Costo PPP',NULL,NULL,'Codigo: IN0006, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 16.00, Valor Compra Actual: 1523200, Ref.: 2'),(20,'taller','127.0.0.1','2022-02-10','19:30:54','Costo PPP',NULL,NULL,'Codigo: IN0002, Stock_Sctual:44.00, Costo PPP Actual:165111.11, Valor Stock Actual: 7264888.8400, Cant.Compra Actual: 10.00, Valor Compra Actual: 8160000, Ref.: 2'),(21,'douglas',NULL,'2022-02-21','23:39:13','Cerrar Venta','Factura','40','Factura Nro: 40'),(22,'douglas',NULL,'2022-02-21','23:42:21','Cerrar Venta','Factura','30','Factura Nro: 30'),(26,'Sistema','127.0.0.1','2022-02-22','00:08:58','Costo PPP',NULL,NULL,'Codigo: IN0001, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 10.00, Valor Compra Actual: 2500000, Ref.: 3'),(27,'Sistema','127.0.0.1','2022-02-23','15:29:32','Costo PPP',NULL,NULL,'Codigo: IN0001, Stock_Sctual:10.00, Costo PPP Actual:25000.00, Valor Stock Actual: 250000.0000, Cant.Compra Actual: 1.00, Valor Compra Actual: 30000, Ref.: 4'),(28,'Sistema','127.0.0.1','2022-02-23','15:31:31','Costo PPP',NULL,NULL,'Codigo: IN0001, Stock_Sctual:10.00, Costo PPP Actual:25454.55, Valor Stock Actual: 254545.5000, Cant.Compra Actual: 10.00, Valor Compra Actual: 2800000, Ref.: 5'),(29,'Sistema','127.0.0.1','2022-02-23','15:33:32','Costo PPP',NULL,NULL,'Codigo: IN0001, Stock_Sctual:10.00, Costo PPP Actual:152727.28, Valor Stock Actual: 1527272.8000, Cant.Compra Actual: 10.00, Valor Compra Actual: 280000, Ref.: 5'),(30,'Sistema','127.0.0.1','2022-02-23','15:36:31','Costo PPP',NULL,NULL,'Codigo: IN0001, Stock_Sctual:10.00, Costo PPP Actual:25000.00, Valor Stock Actual: 250000.0000, Cant.Compra Actual: 5.00, Valor Compra Actual: 118000, Ref.: 6'),(31,'Sistema','127.0.0.1','2022-02-23','15:37:21','Costo PPP',NULL,NULL,'Codigo: IN0001, Stock_Sctual:10.00, Costo PPP Actual:24533.33, Valor Stock Actual: 245333.3000, Cant.Compra Actual: 2500000.00, Valor Compra Actual: 250000, Ref.: 7'),(32,'Sistema','127.0.0.1','2022-02-23','15:40:25','Costo PPP',NULL,NULL,'Codigo: IN0001, Stock_Sctual:10.00, Costo PPP Actual:25000.00, Valor Stock Actual: 250000.0000, Cant.Compra Actual: 20.00, Valor Compra Actual: 880000, Ref.: 8'),(33,'Sistema','127.0.0.1','2022-02-23','15:44:15','Costo PPP',NULL,NULL,'Codigo: IN0001, Stock_Sctual:10.00, Costo PPP Actual:37666.67, Valor Stock Actual: 376666.7000, Cant.Compra Actual: 20.00, Valor Compra Actual: 440000, Ref.: 9'),(34,'Sistema','127.0.0.1','2022-02-23','16:20:18','Costo PPP',NULL,NULL,'Codigo: IN0002, Stock_Sctual:5.00, Costo PPP Actual:130000.00, Valor Stock Actual: 650000.0000, Cant.Compra Actual: 14.00, Valor Compra Actual: 47600000000, Ref.: 11'),(35,'Sistema','127.0.0.1','2022-02-23','16:24:21','Costo PPP',NULL,NULL,'Codigo: IN0002, Stock_Sctual:5.00, Costo PPP Actual:2505297368.42, Valor Stock Actual: 12526486842.1000, Cant.Compra Actual: 14.00, Valor Compra Actual: 47600000000, Ref.: 11'),(36,'Sistema','127.0.0.1','2022-02-23','16:25:17','Costo PPP',NULL,NULL,'Codigo: IN0002, Stock_Sctual:5.00, Costo PPP Actual:3164551939.06, Valor Stock Actual: 15822759695.3000, Cant.Compra Actual: 14.00, Valor Compra Actual: 47600000000, Ref.: 11'),(37,'Sistema','127.0.0.1','2022-02-23','16:26:49','Costo PPP',NULL,NULL,'Codigo: IN0002, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 14.00, Valor Compra Actual: 47600000000, Ref.: 11'),(38,'Sistema','127.0.0.1','2022-02-23','16:30:31','Costo PPP',NULL,NULL,'Codigo: IN0001, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 1.00, Valor Compra Actual: 32000, Ref.: 12'),(39,'Sistema','127.0.0.1','2022-02-23','16:30:31','Costo PPP',NULL,NULL,'Codigo: IN0002, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 5.00, Valor Compra Actual: 125000, Ref.: 12'),(40,'Sistema','127.0.0.1','2022-02-23','16:31:39','Costo PPP',NULL,NULL,'Codigo: IN0001, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 1.00, Valor Compra Actual: 32000, Ref.: 12'),(41,'Sistema','127.0.0.1','2022-02-23','16:31:39','Costo PPP',NULL,NULL,'Codigo: IN0002, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 5.00, Valor Compra Actual: 125000, Ref.: 12'),(42,'Sistema','127.0.0.1','2022-02-23','16:34:48','Costo PPP',NULL,NULL,'Codigo: IN0001, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 10.00, Valor Compra Actual: 24000, Ref.: 13'),(43,'Sistema','127.0.0.1','2022-02-23','16:34:48','Costo PPP',NULL,NULL,'Codigo: IN0002, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 3.00, Valor Compra Actual: 8400, Ref.: 13'),(44,'Sistema','127.0.0.1','2022-02-24','14:59:52','Costo PPP',NULL,NULL,'Codigo: IN0001, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 10.00, Valor Compra Actual: 240000, Ref.: 16'),(45,'Sistema','127.0.0.1','2022-02-24','14:59:52','Costo PPP',NULL,NULL,'Codigo: IN0002, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 2.00, Valor Compra Actual: 120000, Ref.: 16'),(46,'Sistema','127.0.0.1','2022-02-24','15:06:39','Costo PPP',NULL,NULL,'Codigo: IN0002, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 4.00, Valor Compra Actual: 128000, Ref.: 17'),(47,'Sistema','127.0.0.1','2022-02-24','15:07:23','Costo PPP',NULL,NULL,'Codigo: IN0002, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 4.00, Valor Compra Actual: 480000, Ref.: 18'),(48,'Sistema','127.0.0.1','2022-02-24','15:10:53','Costo PPP',NULL,NULL,'Codigo: IN0002, Stock_Sctual:0, Costo PPP Actual:0, Valor Stock Actual: 0, Cant.Compra Actual: 4.00, Valor Compra Actual: 184000, Ref.: 19'),(49,'Sistema','127.0.0.1','2022-02-24','15:15:14','Costo PPP',NULL,NULL,'Codigo: IN0002, Stock_Sctual:16.00, Costo PPP Actual:46000.00, Valor Stock Actual: 736000.0000, Cant.Compra Actual: 4.00, Valor Compra Actual: 400000, Ref.: 20'),(50,'douglas',NULL,'2022-03-02','14:33:45','Error Stock','Stock insuficiente','25',' | Stock insuficiente Codigo: IN0005  Lote:   ( < 2.00) | '),(51,'douglas',NULL,'2022-03-02','14:35:33','Error Stock','Stock insuficiente','25',' | Stock insuficiente Codigo: IN0005  Lote:   ( < 2.00) | '),(52,'douglas',NULL,'2022-03-02','14:49:54','Error Stock','Stock insuficiente','25',' | Stock insuficiente Codigo: IN0005 Limite Stock Negativo:  ( < 2.00) | '),(53,'douglas',NULL,'2022-03-07','15:46:00','Cerrar Venta','Factura','42','Factura Nro: 42'),(54,'douglas',NULL,'2022-03-07','15:57:48','Cerrar Venta','Factura','24','Factura Nro: 24'),(55,'douglas',NULL,'2022-03-11','18:53:50','Cerrar Venta','Factura','28','Factura Nro: 28'),(56,'douglas',NULL,'2022-03-11','19:10:23','Cerrar Venta','Factura','37','Factura Nro: 37'),(57,'douglas',NULL,'2022-03-11','19:22:52','Cerrar Venta','Factura','31','Factura Nro: 31'),(58,'douglas',NULL,'2022-03-11','19:28:39','Cerrar Venta','Factura','46','Factura Nro: 46');

/*Table structure for table `lotes` */

DROP TABLE IF EXISTS `lotes`;

CREATE TABLE `lotes` (
  `codigo` varchar(30) NOT NULL,
  `lote` varchar(60) NOT NULL,
  `cod_serie` varchar(4) NOT NULL,
  `pantone` varchar(30) NOT NULL,
  `umc` varchar(10) NOT NULL,
  `um_prod` varchar(6) DEFAULT NULL,
  `nro_lote_fab` varchar(30) DEFAULT NULL,
  `store` varchar(30) DEFAULT NULL,
  `bag` int(11) DEFAULT NULL,
  `nro_pieza` int(11) DEFAULT NULL,
  `ancho` decimal(16,2) DEFAULT NULL,
  `gramaje` decimal(16,2) DEFAULT NULL,
  `gramaje_m` decimal(16,2) DEFAULT NULL,
  `tara` decimal(16,2) DEFAULT NULL,
  `kg_desc` decimal(16,2) DEFAULT NULL,
  `quty_ticket` decimal(16,2) DEFAULT NULL,
  `quty_c_um` varchar(30) DEFAULT NULL,
  `color_comb` varchar(30) DEFAULT NULL,
  `color_cod_fabric` varchar(20) DEFAULT NULL,
  `design` varchar(30) DEFAULT NULL,
  `cod_catalogo` varchar(30) DEFAULT NULL,
  `notas` varchar(30) DEFAULT NULL,
  `img` varchar(30) DEFAULT NULL,
  `padre` varchar(30) DEFAULT NULL,
  `rec` varchar(2) DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT NULL,
  `id_ent` int(11) DEFAULT NULL,
  `id_det` int(11) DEFAULT NULL,
  `id_frac` int(11) DEFAULT NULL,
  `id_prod_ter` int(11) DEFAULT NULL,
  PRIMARY KEY (`codigo`,`lote`),
  KEY `Ref119205` (`codigo`),
  KEY `Ref128216` (`cod_serie`),
  KEY `Ref134217` (`pantone`),
  KEY `Ref10219` (`umc`),
  KEY `Ref65293` (`id_ent`,`id_det`),
  KEY `Ref69294` (`id_frac`),
  KEY `Ref88295` (`id_prod_ter`),
  KEY `Ref160297` (`design`),
  CONSTRAINT `Refarticulos205` FOREIGN KEY (`codigo`) REFERENCES `articulos` (`codigo`),
  CONSTRAINT `Refdesigns297` FOREIGN KEY (`design`) REFERENCES `designs` (`design`),
  CONSTRAINT `Refentrada_det293` FOREIGN KEY (`id_ent`, `id_det`) REFERENCES `entrada_det` (`id_ent`, `id_det`),
  CONSTRAINT `Reffraccionamientos294` FOREIGN KEY (`id_frac`) REFERENCES `fraccionamientos` (`id_frac`),
  CONSTRAINT `Refpantone217` FOREIGN KEY (`pantone`) REFERENCES `pantone` (`pantone`),
  CONSTRAINT `Refprod_terminado295` FOREIGN KEY (`id_prod_ter`) REFERENCES `prod_terminado` (`id_res`),
  CONSTRAINT `Refseries_lotes216` FOREIGN KEY (`cod_serie`) REFERENCES `series_lotes` (`cod_serie`),
  CONSTRAINT `Refunidades_medida219` FOREIGN KEY (`umc`) REFERENCES `unidades_medida` (`um_cod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `lotes` */

/*Table structure for table `marcas` */

DROP TABLE IF EXISTS `marcas`;

CREATE TABLE `marcas` (
  `marca` varchar(100) NOT NULL,
  `hits` int(11) DEFAULT NULL,
  PRIMARY KEY (`marca`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `marcas` */

insert  into `marcas`(`marca`,`hits`) values ('Abarth',0),('Alfa Romeo',0),('Asia',0),('Aston Martin',0),('Audi',3),('Bentley',0),('BMW',2),('Cadillac',0),('Chevrolet',1),('Chrysler',0),('Citroen',0),('Dacia',0),('Daewoo',0),('Daihatsu',0),('Dodge',0),('Ferrari',0),('Fiat',1),('Ford',8),('Galloper',0),('GMC',3),('Honda',0),('Hummer',0),('Hyundai',4),('Infiniti',NULL),('Isuzu',0),('Iveco',0),('Iveco Pegaso',0),('Jaguar',0),('Jeep',0),('Kia',1),('Lada',0),('Lamborghini',0),('Lancia',0),('Land Rover',0),('Lexus',0),('Lotus',0),('Mahindra',0),('Maserati',0),('Mazda',0),('Mercedes Benz',0),('MG',0),('Mini',0),('Mitsubishi',0),('Nissan',14),('Opel',0),('Peugeot',0),('Pontiac',0),('Porsche',0),('Renault',0),('Rolls Royce',0),('Rover',0),('Santana',0),('Seat',0),('Skoda',0),('Smart',0),('Ssangyong',0),('Subaru',0),('Suzuki',5),('Tata',0),('Tesla',NULL),('Toyota',9),('Volkswagen',0),('Volvo',5);

/*Table structure for table `metas` */

DROP TABLE IF EXISTS `metas`;

CREATE TABLE `metas` (
  `id_meta` smallint(6) NOT NULL,
  `usuario` varchar(30) NOT NULL,
  `meta_minima` decimal(16,0) DEFAULT NULL,
  `meta_base` decimal(16,0) DEFAULT NULL,
  `sueldo_base` decimal(16,0) DEFAULT NULL,
  `ponderacion` decimal(3,0) DEFAULT NULL,
  PRIMARY KEY (`id_meta`,`usuario`),
  KEY `Ref6142` (`usuario`),
  CONSTRAINT `Refusuarios142` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `metas` */

/*Table structure for table `modelos` */

DROP TABLE IF EXISTS `modelos`;

CREATE TABLE `modelos` (
  `marca` varchar(100) NOT NULL,
  `modelo` varchar(100) NOT NULL,
  PRIMARY KEY (`marca`,`modelo`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Data for the table `modelos` */

/*Table structure for table `mon_subdiv` */

DROP TABLE IF EXISTS `mon_subdiv`;

CREATE TABLE `mon_subdiv` (
  `m_cod` varchar(4) NOT NULL,
  `identif` varchar(30) NOT NULL,
  `valor` decimal(16,2) DEFAULT NULL,
  `estado` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`m_cod`,`identif`),
  KEY `Ref1557` (`m_cod`),
  CONSTRAINT `Refmonedas57` FOREIGN KEY (`m_cod`) REFERENCES `monedas` (`m_cod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `mon_subdiv` */

insert  into `mon_subdiv`(`m_cod`,`identif`,`valor`,`estado`) values ('G$','b_10000',10000.00,'Activo'),('G$','b_100000',100000.00,'Activo'),('G$','b_2000',2000.00,'Activo'),('G$','b_20000',20000.00,'Activo'),('G$','b_5000',5000.00,'Activo'),('G$','b_50000',50000.00,'Activo'),('G$','m_100',100.00,'Activo'),('G$','m_1000',1000.00,'Activo'),('G$','m_50',50.00,'Activo'),('G$','m_500',500.00,'Activo'),('P$','b_1',1.00,'Inactivo'),('P$','b_10',10.00,'Activo'),('P$','b_100',100.00,'Activo'),('P$','b_1000',1000.00,'Activo'),('P$','b_2',2.00,'Inactivo'),('P$','b_20',20.00,'Activo'),('P$','b_200',200.00,'Activo'),('P$','b_5',5.00,'Activo'),('P$','b_50',50.00,'Activo'),('P$','b_500',500.00,'Activo'),('P$','m_0_05',0.05,'Activo'),('P$','m_0_10',0.10,'Activo'),('P$','m_0_25',0.25,'Activo'),('P$','m_0_50',0.50,'Activo'),('P$','m_1',1.00,'Activo'),('P$','m_2',2.00,'Activo'),('R$','b_1',1.00,'Activo'),('R$','b_10',10.00,'Activo'),('R$','b_100',100.00,'Activo'),('R$','b_2',2.00,'Activo'),('R$','b_20',20.00,'Activo'),('R$','b_5',5.00,'Activo'),('R$','b_50',50.00,'Activo'),('R$','m_0_05',0.05,'Activo'),('R$','m_0_10',0.10,'Activo'),('R$','m_0_25',0.25,'Activo'),('R$','m_0_50',0.50,'Activo'),('R$','m_1',1.00,'Activo'),('U$','b_1',1.00,'Activo'),('U$','b_10',10.00,'Activo'),('U$','b_100',100.00,'Activo'),('U$','b_2',2.00,'Activo'),('U$','b_20',20.00,'Activo'),('U$','b_5',5.00,'Activo'),('U$','b_50',50.00,'Activo'),('U$','m_0_05',0.05,'Activo'),('U$','m_0_10',0.10,'Activo'),('U$','m_0_25',0.25,'Activo'),('U$','m_0_50',0.50,'Activo'),('U$','m_1',1.00,'Activo');

/*Table structure for table `monedas` */

DROP TABLE IF EXISTS `monedas`;

CREATE TABLE `monedas` (
  `m_cod` varchar(4) NOT NULL,
  `m_descri` varchar(30) DEFAULT NULL,
  `m_ref` varchar(4) DEFAULT NULL,
  PRIMARY KEY (`m_cod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `monedas` */

insert  into `monedas`(`m_cod`,`m_descri`,`m_ref`) values ('G$','Guaranies','Si'),('P$','Pesos','No'),('R$','Reales','No'),('U$','Dolares','No');

/*Table structure for table `movil_recep` */

DROP TABLE IF EXISTS `movil_recep`;

CREATE TABLE `movil_recep` (
  `id_diag` int(11) DEFAULT NULL,
  `id_part` int(11) DEFAULT NULL,
  `valor` varchar(200) DEFAULT NULL,
  KEY `diagnosticos` (`id_diag`),
  KEY `aux_recep` (`id_part`),
  CONSTRAINT `aux_recep` FOREIGN KEY (`id_part`) REFERENCES `aux_recep` (`id_part`),
  CONSTRAINT `diagnosticos` FOREIGN KEY (`id_diag`) REFERENCES `recepcion` (`id_diag`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `movil_recep` */

insert  into `movil_recep`(`id_diag`,`id_part`,`valor`) values (30,1,'Normal'),(30,2,'Normal'),(30,3,'Si'),(56,1,'Normal'),(56,2,'Normal'),(56,3,'Si'),(56,4,'No'),(56,5,'Si'),(56,6,'No'),(56,7,'Normal'),(56,8,'Normal'),(56,9,'Normal'),(56,10,'Normal'),(56,11,'Normal'),(56,12,'Normal'),(56,13,'Abollado'),(56,14,'Roto'),(56,15,'Raspon'),(56,16,'Roto'),(56,17,'Roto'),(56,18,'Normal'),(56,19,'No'),(56,20,'Normal'),(56,21,'Normal'),(56,22,'N/A'),(56,23,'Normal'),(56,24,'Normal'),(56,25,'Si'),(56,26,'Si'),(56,27,'Si'),(56,28,'Si'),(56,29,'Si'),(56,30,'Normal'),(56,31,'No'),(56,32,'Si'),(56,33,'Si'),(56,34,'Si'),(56,35,'Si'),(56,36,'Si'),(57,1,'Normal'),(57,2,'Normal'),(57,3,'Si'),(57,4,'Si'),(57,5,'Si'),(57,6,'Si'),(57,7,'Normal'),(57,8,'Normal'),(57,9,'Normal'),(57,10,'Roto'),(57,11,'Normal'),(57,12,'Raspon'),(57,13,'Normal'),(57,14,'Normal'),(57,15,'Normal'),(57,16,'Normal'),(57,17,'Normal'),(57,18,'Normal'),(57,19,'Si'),(57,20,'Normal'),(57,21,'Normal'),(57,22,'Normal'),(57,23,'Normal'),(57,24,'Normal'),(57,25,'Si'),(57,26,'No'),(57,27,'No'),(57,28,'Si'),(57,29,'Si'),(57,30,'Normal'),(57,31,'No'),(57,32,'Si'),(57,33,'Si'),(57,34,'Si'),(57,35,'No'),(57,36,'No'),(58,1,'Normal'),(58,2,'Normal'),(58,3,'Si'),(58,4,'Si'),(58,5,'Si'),(58,6,'Si'),(58,7,'Raspon'),(58,8,'Normal'),(58,9,'Normal'),(58,10,'Normal'),(58,11,'Normal'),(58,12,'Normal'),(58,13,'Normal'),(58,14,'Normal'),(58,15,'Normal'),(58,16,'Normal'),(58,17,'Normal'),(58,18,'Normal'),(58,19,'Si'),(58,20,'Normal'),(58,21,'Normal'),(58,22,'N/A'),(58,23,'Normal'),(58,24,'Normal'),(58,25,'Si'),(58,26,'No'),(58,27,'Si'),(58,28,'Si'),(58,29,'Si'),(58,30,'Normal'),(58,31,'Si'),(58,32,'Si'),(58,33,'Si'),(58,34,'Si'),(58,35,'Si'),(58,36,'Si'),(59,1,'Normal'),(59,2,'Normal'),(59,3,'Si'),(59,4,'Si'),(59,5,'Si'),(59,6,'Si'),(59,7,'Normal'),(59,8,'Normal'),(59,9,'Normal'),(59,10,'Normal'),(59,11,'Normal'),(59,12,'Roto'),(59,13,'Normal'),(59,14,'Abollado'),(59,15,'Normal'),(59,16,'Normal'),(59,17,'Normal'),(59,18,'Normal'),(59,19,'Si'),(59,20,'Normal'),(59,21,'Normal'),(59,22,'N/A'),(59,23,'Normal'),(59,24,'Normal'),(59,25,'Si'),(59,26,'No'),(59,27,'Si'),(59,28,'Si'),(59,29,'Si'),(59,30,'Normal'),(59,31,'Si'),(59,32,'Si'),(59,33,'Si'),(59,34,'Si'),(59,35,'Si'),(59,36,'Si'),(60,1,'Raspon'),(60,2,'Normal'),(60,3,'Si'),(60,4,'Si'),(60,5,'Si'),(60,6,'Si'),(60,7,'Normal'),(60,8,'Normal'),(60,9,'Normal'),(60,10,'Normal'),(60,11,'Normal'),(60,12,'Normal'),(60,13,'Normal'),(60,14,'Normal'),(60,15,'Normal'),(60,16,'Normal'),(60,17,'Normal'),(60,18,'Normal'),(60,19,'Si'),(60,20,'Normal'),(60,21,'Normal'),(60,22,'Normal'),(60,23,'Normal'),(60,24,'Normal'),(60,25,'Si'),(60,26,'Si'),(60,27,'Si'),(60,28,'Si'),(60,29,'Si'),(60,30,'Normal'),(60,31,'No'),(60,32,'Si'),(60,33,'No'),(60,34,'Si'),(60,35,'Si'),(60,36,'Si'),(63,1,'Normal'),(63,2,'Normal'),(63,3,'Si'),(63,4,'Si'),(63,5,'Si'),(63,6,'Si'),(63,7,'Normal'),(63,8,'Normal'),(63,9,'Normal'),(63,10,'Normal'),(63,11,'Normal'),(63,12,'Normal'),(63,13,'Normal'),(63,14,'Normal'),(63,15,'Normal'),(63,16,'Normal'),(63,17,'Normal'),(63,18,'Normal'),(63,19,'Si'),(63,20,'Normal'),(63,21,'Normal'),(63,22,'Normal'),(63,23,'Normal'),(63,24,'Normal'),(63,25,'Si'),(63,26,'Si'),(63,27,'Si'),(63,28,'Si'),(63,29,'Si'),(63,30,'Normal'),(63,31,'Si'),(63,32,'Si'),(63,33,'Si'),(63,34,'Si'),(63,35,'Si'),(63,36,'Si'),(64,1,'Normal'),(64,2,'Normal'),(64,3,'Si'),(64,4,'Si'),(64,5,'No'),(64,6,'Si'),(64,7,'Normal'),(64,8,'Normal'),(64,9,'Normal'),(64,10,'Normal'),(64,11,'Normal'),(64,12,'Normal'),(64,13,'Normal'),(64,14,'Normal'),(64,15,'Normal'),(64,16,'Normal'),(64,17,'Normal'),(64,18,'Normal'),(64,19,'Si'),(64,20,'Normal'),(64,21,'Normal'),(64,22,'Normal'),(64,23,'Normal'),(64,24,'Normal'),(64,25,'No'),(64,26,'Si'),(64,27,'Si'),(64,28,'Si'),(64,29,'Si'),(64,30,'Normal'),(64,31,'Si'),(64,32,'Si'),(64,33,'No'),(64,34,'Si'),(64,35,'Si'),(64,36,'Si'),(65,1,'Normal'),(65,2,'Normal'),(65,3,'Si'),(65,4,'Si'),(65,5,'Si'),(65,6,'Si'),(65,7,'Normal'),(65,8,'Normal'),(65,9,'Normal'),(65,10,'Normal'),(65,11,'Normal'),(65,12,'Normal'),(65,13,'Normal'),(65,14,'Normal'),(65,15,'Normal'),(65,16,'Normal'),(65,17,'Normal'),(65,18,'Normal'),(65,19,'Si'),(65,20,'Normal'),(65,21,'Normal'),(65,22,'Normal'),(65,23,'Normal'),(65,24,'Normal'),(65,25,'Si'),(65,26,'Si'),(65,27,'Si'),(65,28,'Si'),(65,29,'Si'),(65,30,'Normal'),(65,31,'Si'),(65,32,'Si'),(65,33,'Si'),(65,34,'Si'),(65,35,'Si'),(65,36,'Si'),(66,1,'Normal'),(66,2,'Normal'),(66,3,'Si'),(66,4,'Si'),(66,5,'Si'),(66,6,'Si'),(66,7,'Normal'),(66,8,'Normal'),(66,9,'Normal'),(66,10,'Normal'),(66,11,'Normal'),(66,12,'Normal'),(66,13,'Normal'),(66,14,'Normal'),(66,15,'Normal'),(66,16,'Normal'),(66,17,'Normal'),(66,18,'Normal'),(66,19,'Si'),(66,20,'Normal'),(66,21,'Normal'),(66,22,'Normal'),(66,23,'Normal'),(66,24,'Normal'),(66,25,'Si'),(66,26,'No'),(66,27,'Si'),(66,28,'Si'),(66,29,'Si'),(66,30,'Normal'),(66,31,'Si'),(66,32,'No'),(66,33,'No'),(66,34,'Si'),(66,35,'Si'),(66,36,'Si'),(67,1,'Normal'),(67,2,'Normal'),(67,3,'Si'),(67,4,'Si'),(67,5,'Si'),(67,6,'Si'),(67,7,'Normal'),(67,8,'Normal'),(67,9,'Normal'),(67,10,'Normal'),(67,11,'Normal'),(67,12,'Normal'),(67,13,'Normal'),(67,14,'Normal'),(67,15,'Normal'),(67,16,'Normal'),(67,17,'Normal'),(67,18,'Normal'),(67,19,'Si'),(67,20,'Normal'),(67,21,'Normal'),(67,22,'Normal'),(67,23,'Normal'),(67,24,'Normal'),(67,25,'Si'),(67,26,'Si'),(67,27,'Si'),(67,28,'Si'),(67,29,'Si'),(67,30,'Normal'),(67,31,'Si'),(67,32,'Si'),(67,33,'Si'),(67,34,'Si'),(67,35,'Si'),(67,36,'Si');

/*Table structure for table `moviles` */

DROP TABLE IF EXISTS `moviles`;

CREATE TABLE `moviles` (
  `id_movil` int(30) NOT NULL AUTO_INCREMENT,
  `codigo_entidad` varchar(10) NOT NULL,
  `rua` varchar(30) DEFAULT NULL,
  `chapa` varchar(30) NOT NULL,
  `marca` varchar(30) DEFAULT NULL,
  `modelo` varchar(100) DEFAULT NULL,
  `vim` varchar(200) DEFAULT NULL,
  `anio_fab` int(11) DEFAULT NULL,
  `color` varchar(100) DEFAULT NULL,
  `combustible` varchar(30) DEFAULT NULL,
  `tipo` varchar(60) DEFAULT '''Sedan''',
  `motor` varchar(20) DEFAULT NULL,
  `otros` varchar(300) DEFAULT NULL,
  PRIMARY KEY (`id_movil`,`codigo_entidad`,`chapa`),
  KEY `Ref146326` (`codigo_entidad`),
  KEY `tipo_movil` (`tipo`),
  CONSTRAINT `tipo_movil` FOREIGN KEY (`tipo`) REFERENCES `tipos_moviles` (`tipo_movil`)
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=latin1;

/*Data for the table `moviles` */

insert  into `moviles`(`id_movil`,`codigo_entidad`,`rua`,`chapa`,`marca`,`modelo`,`vim`,`anio_fab`,`color`,`combustible`,`tipo`,`motor`,`otros`) values (4,'C000002','123456','NAH 367','Nissan','SUNNY','FB-12545125',2004,'Blanco','Nafta','Sedan','1.5','xxxddd'),(6,'C000002','','AJU 492','Volvo','S80 T6','FB-12545125',2004,'Blanco','Nafta','Sedan',NULL,'xxx'),(7,'C000003','','NAS 886','Nissan','BLUEBIRD','1562123131',2001,'Burdeos c','Nafta','Roadster',NULL,'xxxccc'),(8,'C000012','','ABC 123','Toyota','CAMRY','2324221231656',2003,'NEGRO','Nafta','Cabriolet',NULL,''),(9,'C000013','','ABC 789','Kia','SORENTO','JDISBDBBSIE',2008,'AZUL','Nafta','SUV','1.8',''),(12,'C000005',NULL,'HUN 345','Hyundai','Tucson','',NULL,'','Nafta','Sedan',NULL,''),(14,'C000003','1512121212','PRV 001','Volkswagen','GOL TREND','1562123131',2001,'Burdeos c','Nafta','Sedan',NULL,'xxxccc'),(15,'C000002',NULL,'TAk 962','Toyota','Mark x 250g','FB-12545125',2004,'Blanco','Nafta','Sedan',NULL,'xxx'),(16,'C000003',NULL,'AJC 100','Volvo','XC 60 D4','1562123131',2001,'Burdeos c','Nafta','Roadster',NULL,'xxxccc'),(17,'C000011',NULL,'PY5 352 ','Volkswagen','GOL TREND','',2018,'PLATA','Nafta','Sedan',NULL,''),(18,'C000007',NULL,'KDG 973','Audi','A4','I7272y18e7',2006,'Blanco','Nafta','SportCar',NULL,''),(19,'C000002',NULL,'ABG 420','Toyota','Rav 4','FB-12545125',2004,'Blanco','Nafta','Sedan',NULL,''),(20,'C000004',NULL,'ABT 452','Nissan','Centra Centenial Edition','5152156312521',2014,'NEGRO','Nafta','Sedan','LTZ 1.8','V6'),(23,'C000003',NULL,'ATG 136','Toyota','Rav4','246512132',2006,'AZUL FRACIA','Diesel','SUV',NULL,'4X4'),(24,'C000001',NULL,'GHJ 332','Hyundai','ACCENT','',2007,'BLANCO','Nafta','Sedan',NULL,'4X2'),(25,'C000001',NULL,'AGH 458','Suzuki','Vitara','',NULL,'','Nafta','SUV',NULL,''),(26,'C000022',NULL,'ZGK554 ','BMW','Z3','156513213212',2003,'VERDE MUZGO','Nafta','Sedan',NULL,''),(27,'C000002',NULL,'AHJ345','Suzuki','Swift','879889897765',2015,'ROJO','Nafta','HatchBack','1.4','');

/*Table structure for table `moviles_img` */

DROP TABLE IF EXISTS `moviles_img`;

CREATE TABLE `moviles_img` (
  `id_movil` int(11) DEFAULT NULL,
  `id_img` int(11) DEFAULT NULL,
  `url_img` varchar(200) DEFAULT NULL,
  `principal` varchar(4) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

/*Data for the table `moviles_img` */

insert  into `moviles_img`(`id_movil`,`id_img`,`url_img`,`principal`) values (4,2,'img/vehiculos/4/2.jpg','No'),(4,1,'img/vehiculos/4/1.jpg','No'),(4,3,'img/vehiculos/4/3.jpg','No'),(6,2,'img/vehiculos/6/2.jpg',NULL),(6,3,'img/vehiculos/6/3.jpg',NULL),(6,4,'img/vehiculos/6/4.jpg',NULL),(6,5,'img/vehiculos/6/5.jpg',NULL);

/*Table structure for table `nodos` */

DROP TABLE IF EXISTS `nodos`;

CREATE TABLE `nodos` (
  `suc` varchar(10) NOT NULL,
  `nodo` varchar(6) NOT NULL,
  `prioridad` decimal(4,2) DEFAULT NULL,
  `x` decimal(10,2) DEFAULT NULL,
  `y` decimal(10,2) DEFAULT NULL,
  `size` int(11) DEFAULT NULL,
  PRIMARY KEY (`suc`,`nodo`),
  KEY `Ref18170` (`suc`),
  CONSTRAINT `Refsucursales170` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `nodos` */

/*Table structure for table `nota_credito` */

DROP TABLE IF EXISTS `nota_credito`;

CREATE TABLE `nota_credito` (
  `n_nro` int(11) NOT NULL AUTO_INCREMENT,
  `cod_cli` varchar(30) DEFAULT NULL,
  `cliente` varchar(60) DEFAULT NULL,
  `ruc_cli` varchar(20) DEFAULT NULL,
  `usuario` varchar(30) NOT NULL,
  `req_auth` varchar(2) DEFAULT NULL,
  `autorizado_por` varchar(30) DEFAULT NULL,
  `f_nro` int(11) DEFAULT NULL,
  `moneda` varchar(4) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` varchar(10) DEFAULT NULL,
  `suc` varchar(10) NOT NULL,
  `tipo` varchar(12) DEFAULT NULL,
  `total` decimal(16,2) DEFAULT NULL,
  `saldo` decimal(16,2) DEFAULT NULL,
  `fact_nro` varchar(30) DEFAULT NULL,
  `pdv_cod` varchar(30) DEFAULT NULL,
  `tipo_fact` varchar(16) DEFAULT NULL,
  `tipo_doc` varchar(30) DEFAULT NULL,
  `estado` varchar(10) DEFAULT NULL,
  `tipo_nc` varchar(16) DEFAULT NULL,
  `vendedor` varchar(30) DEFAULT NULL,
  `cat` int(11) DEFAULT NULL,
  `fecha_creacion` timestamp NULL DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`n_nro`),
  KEY `Ref1860` (`suc`),
  KEY `Ref661` (`usuario`),
  KEY `Ref362` (`f_nro`),
  KEY `Ref2263` (`tipo_doc`,`moneda`,`pdv_cod`,`tipo_fact`,`fact_nro`,`suc`),
  KEY `Reffactura_cont63` (`moneda`,`suc`,`fact_nro`,`pdv_cod`,`tipo_fact`,`tipo_doc`),
  CONSTRAINT `Reffactura_cont63` FOREIGN KEY (`moneda`, `suc`, `fact_nro`, `pdv_cod`, `tipo_fact`, `tipo_doc`) REFERENCES `factura_cont` (`fact_nro`, `suc`, `pdv_cod`, `tipo_fact`, `tipo_doc`, `moneda`),
  CONSTRAINT `Reffactura_venta62` FOREIGN KEY (`f_nro`) REFERENCES `factura_venta` (`f_nro`),
  CONSTRAINT `Refsucursales60` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`),
  CONSTRAINT `Refusuarios61` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `nota_credito` */

/*Table structure for table `nota_credito_det` */

DROP TABLE IF EXISTS `nota_credito_det`;

CREATE TABLE `nota_credito_det` (
  `id_det` int(11) NOT NULL AUTO_INCREMENT,
  `n_nro` int(11) NOT NULL,
  `codigo` varchar(30) DEFAULT NULL,
  `lote` varchar(30) DEFAULT NULL,
  `um_prod` varchar(10) DEFAULT NULL,
  `descrip` varchar(120) DEFAULT NULL,
  `cantidad` decimal(16,2) DEFAULT NULL,
  `precio_unit` decimal(16,2) DEFAULT NULL,
  `subtotal` decimal(16,2) DEFAULT NULL,
  `estado` varchar(10) DEFAULT NULL,
  `estado_venta` varchar(20) DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id_det`,`n_nro`),
  KEY `Ref4259` (`n_nro`),
  CONSTRAINT `Refnota_credito59` FOREIGN KEY (`n_nro`) REFERENCES `nota_credito` (`n_nro`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `nota_credito_det` */

/*Table structure for table `nota_ped_comp_det` */

DROP TABLE IF EXISTS `nota_ped_comp_det`;

CREATE TABLE `nota_ped_comp_det` (
  `id_det` int(11) NOT NULL AUTO_INCREMENT,
  `n_nro` int(11) NOT NULL,
  `usuario` varchar(30) NOT NULL,
  `suc` varchar(10) DEFAULT NULL,
  `cod_cli` varchar(12) DEFAULT NULL,
  `cliente` varchar(60) DEFAULT NULL,
  `ponderacion` decimal(4,2) DEFAULT NULL,
  `codigo` varchar(30) NOT NULL,
  `lote` varchar(30) DEFAULT NULL,
  `um_prod` varchar(10) DEFAULT NULL,
  `obs` varchar(120) DEFAULT NULL,
  `cantidad` decimal(16,2) DEFAULT NULL,
  `cantidad_pond` decimal(16,2) DEFAULT NULL,
  `precio_venta` decimal(16,2) DEFAULT NULL,
  `color` varchar(100) DEFAULT NULL,
  `estado` varchar(30) DEFAULT NULL,
  `mayorista` varchar(30) DEFAULT NULL,
  `descrip` varchar(80) DEFAULT NULL,
  `urge` varchar(4) DEFAULT NULL,
  `presentacion` varchar(10) DEFAULT NULL,
  `c_prov_cod` varchar(12) DEFAULT NULL,
  `c_prov` varchar(60) DEFAULT NULL,
  `c_precio_compra` decimal(16,2) DEFAULT NULL,
  `c_fecha_compra` date DEFAULT NULL,
  `c_fecha_prev` date DEFAULT NULL,
  `c_lote` varchar(16) DEFAULT NULL,
  `c_obs` varchar(60) DEFAULT NULL,
  `c_ref_unif` int(11) DEFAULT NULL,
  `c_um` varchar(6) DEFAULT NULL,
  `c_catalogo` varchar(4) DEFAULT NULL,
  `c_fab_color_cod` varchar(6) DEFAULT NULL,
  `c_color_comb` varchar(40) DEFAULT NULL,
  `c_design` varchar(60) DEFAULT NULL,
  `c_color` varchar(100) DEFAULT NULL,
  `c_estado` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id_det`,`n_nro`),
  KEY `Ref5281` (`n_nro`),
  KEY `Ref685` (`usuario`),
  KEY `Ref18175` (`suc`),
  CONSTRAINT `Refnota_pedido_compra81` FOREIGN KEY (`n_nro`) REFERENCES `nota_pedido_compra` (`n_nro`),
  CONSTRAINT `Refsucursales175` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`),
  CONSTRAINT `Refusuarios85` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `nota_ped_comp_det` */

/*Table structure for table `nota_ped_resumen` */

DROP TABLE IF EXISTS `nota_ped_resumen`;

CREATE TABLE `nota_ped_resumen` (
  `id_res` int(11) NOT NULL AUTO_INCREMENT,
  `id_det` int(11) NOT NULL,
  `n_nro` int(11) NOT NULL,
  `codigo` varchar(30) NOT NULL,
  `descrip` varchar(80) DEFAULT NULL,
  `um_prod` varchar(10) DEFAULT NULL,
  `obs` varchar(120) DEFAULT NULL,
  `cantidad` decimal(16,2) DEFAULT NULL,
  `cantidad_pond` decimal(16,2) DEFAULT NULL,
  `color` varchar(30) DEFAULT NULL,
  `precio_est` decimal(16,2) DEFAULT NULL,
  `ventas` decimal(16,2) DEFAULT NULL,
  `rango_ventas` varchar(30) DEFAULT NULL,
  `estado` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_res`,`id_det`,`n_nro`),
  KEY `Ref5383` (`id_det`,`n_nro`),
  CONSTRAINT `Refnota_ped_comp_det83` FOREIGN KEY (`id_det`, `n_nro`) REFERENCES `nota_ped_comp_det` (`id_det`, `n_nro`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `nota_ped_resumen` */

/*Table structure for table `nota_ped_tracking` */

DROP TABLE IF EXISTS `nota_ped_tracking`;

CREATE TABLE `nota_ped_tracking` (
  `id_track` int(11) NOT NULL AUTO_INCREMENT,
  `id_det` int(11) DEFAULT NULL,
  `n_nro` int(11) DEFAULT NULL,
  `usuario` varchar(30) NOT NULL,
  `fecha_hora` datetime DEFAULT NULL,
  `obs` varchar(60) DEFAULT NULL,
  `fecha_prev` date DEFAULT NULL,
  `estado` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id_track`),
  KEY `Ref5386` (`id_det`,`n_nro`),
  KEY `Ref687` (`usuario`),
  CONSTRAINT `Refnota_ped_comp_det86` FOREIGN KEY (`id_det`, `n_nro`) REFERENCES `nota_ped_comp_det` (`id_det`, `n_nro`),
  CONSTRAINT `Refusuarios87` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `nota_ped_tracking` */

/*Table structure for table `nota_pedido_compra` */

DROP TABLE IF EXISTS `nota_pedido_compra`;

CREATE TABLE `nota_pedido_compra` (
  `n_nro` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(30) NOT NULL,
  `temporada` varchar(20) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` varchar(10) DEFAULT NULL,
  `suc` varchar(10) NOT NULL,
  `fecha_cierre` date DEFAULT NULL,
  `hora_cierre` varchar(10) DEFAULT NULL,
  `obs` varchar(200) DEFAULT NULL,
  `nac_int` varchar(30) DEFAULT NULL,
  `estado` varchar(20) DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`n_nro`),
  KEY `Ref1880` (`suc`),
  KEY `Ref6171` (`usuario`),
  CONSTRAINT `Refsucursales80` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`),
  CONSTRAINT `Refusuarios171` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `nota_pedido_compra` */

/*Table structure for table `nota_rem_det` */

DROP TABLE IF EXISTS `nota_rem_det`;

CREATE TABLE `nota_rem_det` (
  `id_det` int(11) NOT NULL AUTO_INCREMENT,
  `n_nro` int(11) NOT NULL,
  `codigo` varchar(30) DEFAULT NULL,
  `lote` varchar(30) DEFAULT NULL,
  `um_prod` varchar(10) DEFAULT NULL,
  `descrip` varchar(120) DEFAULT NULL,
  `cantidad` decimal(16,2) DEFAULT NULL,
  `cant_inicial` decimal(16,2) DEFAULT NULL,
  `gramaje` decimal(16,2) DEFAULT NULL,
  `ancho` decimal(16,2) DEFAULT NULL,
  `kg_env` decimal(16,3) DEFAULT NULL,
  `kg_rec` decimal(16,3) DEFAULT NULL,
  `cant_calc_env` decimal(16,2) DEFAULT NULL,
  `cant_calc_rec` decimal(16,2) DEFAULT NULL,
  `tara` decimal(16,2) DEFAULT NULL,
  `procesado` varchar(4) DEFAULT NULL,
  `estado` varchar(30) DEFAULT NULL,
  `verificado_por` varchar(30) DEFAULT NULL,
  `kg_desc` decimal(16,2) DEFAULT NULL,
  `tipo_control` varchar(10) DEFAULT NULL,
  `paquete` int(11) DEFAULT NULL,
  `usuario_ins` varchar(30) DEFAULT NULL,
  `fecha_ins` datetime DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id_det`,`n_nro`),
  KEY `Ref5792` (`n_nro`),
  CONSTRAINT `Refnota_remision92` FOREIGN KEY (`n_nro`) REFERENCES `nota_remision` (`n_nro`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `nota_rem_det` */

/*Table structure for table `nota_remision` */

DROP TABLE IF EXISTS `nota_remision`;

CREATE TABLE `nota_remision` (
  `n_nro` int(11) NOT NULL AUTO_INCREMENT,
  `fecha` date DEFAULT NULL,
  `hora` varchar(10) DEFAULT NULL,
  `usuario` varchar(30) NOT NULL,
  `recepcionista` varchar(30) DEFAULT NULL,
  `suc` varchar(10) NOT NULL,
  `suc_d` varchar(10) NOT NULL,
  `fecha_cierre` date DEFAULT NULL,
  `hora_cierre` varchar(10) DEFAULT NULL,
  `obs` varchar(100) DEFAULT NULL,
  `estado` varchar(10) DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  `transportadora` varchar(50) DEFAULT NULL,
  `nro_levante` varchar(50) DEFAULT NULL,
  `cod_cli` varchar(10) DEFAULT NULL,
  `transp_ruc` varchar(20) DEFAULT NULL,
  `chofer` varchar(100) DEFAULT NULL,
  `ci_chofer` varbinary(20) DEFAULT NULL,
  `nro_chapa` varchar(10) DEFAULT NULL,
  `rua` varbinary(30) DEFAULT NULL,
  `nota_rem_legal` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`n_nro`),
  KEY `Ref688` (`usuario`),
  KEY `Ref1889` (`suc`),
  KEY `Ref1890` (`suc_d`),
  KEY `Ref691` (`recepcionista`),
  CONSTRAINT `Refsucursales89` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`),
  CONSTRAINT `Refsucursales90` FOREIGN KEY (`suc_d`) REFERENCES `sucursales` (`suc`),
  CONSTRAINT `Refusuarios88` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`),
  CONSTRAINT `Refusuarios91` FOREIGN KEY (`recepcionista`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `nota_remision` */

/*Table structure for table `orden_det` */

DROP TABLE IF EXISTS `orden_det`;

CREATE TABLE `orden_det` (
  `nro_orden` int(11) NOT NULL,
  `id_det` int(11) NOT NULL,
  `codigo` varchar(10) DEFAULT NULL,
  `descrip` varchar(60) DEFAULT NULL,
  `cantidad` decimal(16,2) DEFAULT NULL,
  `largo` decimal(16,2) DEFAULT NULL,
  `design` varchar(30) DEFAULT NULL,
  `obs` varchar(60) DEFAULT NULL,
  `sap_doc` int(11) DEFAULT NULL,
  PRIMARY KEY (`nro_orden`,`id_det`),
  KEY `Ref83147` (`nro_orden`),
  CONSTRAINT `Reforden_fabric147` FOREIGN KEY (`nro_orden`) REFERENCES `orden_fabric` (`nro_orden`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `orden_det` */

/*Table structure for table `orden_fabric` */

DROP TABLE IF EXISTS `orden_fabric`;

CREATE TABLE `orden_fabric` (
  `nro_orden` int(11) NOT NULL AUTO_INCREMENT,
  `cod_cli` varchar(12) DEFAULT NULL,
  `cliente` varchar(60) DEFAULT NULL,
  `usuario` varchar(30) NOT NULL,
  `fecha` date DEFAULT NULL,
  `hora` varchar(10) DEFAULT NULL,
  `suc` varchar(10) NOT NULL,
  `suc_d` varchar(10) DEFAULT NULL,
  `estado` varchar(10) DEFAULT NULL,
  `asignado_a` varchar(30) DEFAULT NULL,
  `fecha_asign` date DEFAULT NULL,
  `hora_asig` varchar(10) DEFAULT NULL,
  `obs` varchar(100) DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`nro_orden`),
  KEY `Ref6145` (`usuario`),
  KEY `Ref18146` (`suc`),
  CONSTRAINT `Refsucursales146` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`),
  CONSTRAINT `Refusuarios145` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `orden_fabric` */

/*Table structure for table `orden_procesamiento` */

DROP TABLE IF EXISTS `orden_procesamiento`;

CREATE TABLE `orden_procesamiento` (
  `id_orden` int(11) NOT NULL AUTO_INCREMENT,
  `id_ent` int(11) DEFAULT NULL,
  `id_det` int(11) DEFAULT NULL,
  `usuario` varchar(30) NOT NULL,
  `suc` varchar(10) NOT NULL,
  `nro_pedido` int(11) DEFAULT NULL,
  `cod_cli` varchar(20) DEFAULT NULL,
  `codigo` varchar(30) DEFAULT NULL,
  `lote` varchar(30) DEFAULT NULL,
  `color` varchar(100) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` time DEFAULT NULL,
  `presentacion` varchar(10) DEFAULT NULL,
  `cantidad` decimal(16,2) DEFAULT NULL,
  `prioridad` int(11) DEFAULT NULL,
  `operador` varchar(30) DEFAULT NULL,
  `fecha_inicio` datetime DEFAULT NULL,
  `iniciado_por` varchar(30) DEFAULT NULL,
  `estado` varchar(20) DEFAULT NULL,
  `tipo_proc` varchar(30) DEFAULT NULL,
  `obs` varchar(2048) DEFAULT NULL,
  PRIMARY KEY (`id_orden`),
  KEY `Ref65115` (`id_ent`,`id_det`),
  KEY `Ref6116` (`usuario`),
  KEY `Ref18117` (`suc`),
  CONSTRAINT `Refentrada_det115` FOREIGN KEY (`id_ent`, `id_det`) REFERENCES `entrada_det` (`id_ent`, `id_det`),
  CONSTRAINT `Refsucursales117` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`),
  CONSTRAINT `Refusuarios116` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `orden_procesamiento` */

/*Table structure for table `orden_trab` */

DROP TABLE IF EXISTS `orden_trab`;

CREATE TABLE `orden_trab` (
  `id_orden` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(30) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `tecnico` varchar(30) DEFAULT NULL,
  `fecha_ini` datetime DEFAULT NULL,
  `fecha_fin` datetime DEFAULT NULL,
  `obs` varchar(1024) DEFAULT NULL,
  `estado` varchar(30) DEFAULT NULL,
  `id_diag` int(11) DEFAULT NULL,
  `chapa` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_orden`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

/*Data for the table `orden_trab` */

insert  into `orden_trab`(`id_orden`,`usuario`,`fecha`,`tecnico`,`fecha_ini`,`fecha_fin`,`obs`,`estado`,`id_diag`,`chapa`) values (1,'douglas','2021-11-29','taller','2021-11-29 07:55:27','2021-11-29 07:55:27','Prueba 01','Abierto',1,'KDG 973'),(2,'douglas','2021-11-30','douglas','0000-00-00 00:00:00','0000-00-00 00:00:00','\nDiidkdkdkd\nDkkskdiis\n','Abierto',2,'ABC 123'),(3,'douglas','2021-12-28','douglas','2021-12-28 05:47:00','2021-12-28 05:47:00','Basado en Diagnostico Nro:8 Chapa: NAH 367','Abierto',8,'NAH 367'),(4,'douglas','2021-12-28','douglas','2021-12-28 05:58:14','2021-12-28 05:58:14','Basado en Diagnostico Nro:6 Chapa: ABC 123','Abierto',6,'ABC 123'),(5,'douglas','2021-12-28','douglas','2021-12-28 05:58:52','2021-12-28 05:58:52','Basado en Diagnostico Nro:1 Chapa: KDG 973','Abierto',1,'KDG 973'),(6,'douglas','2021-12-28','douglas','2021-12-28 06:18:56','2021-12-28 06:18:56','Basado en Diagnostico Nro:7 Chapa: ABC 123','Abierto',7,'ABC 123'),(7,'douglas','2022-01-05','douglas','2022-01-05 08:43:49','2022-01-05 08:43:49','Basado en Diagnostico Nro:11 Chapa: NAH 367','Abierto',11,'NAH 367'),(8,'douglas','2022-01-05','douglas','2022-01-05 08:44:26','2022-01-05 08:44:26','Basado en Diagnostico Nro:11 Chapa: NAH 367','Abierto',11,'NAH 367'),(9,'douglas','2022-01-05','douglas','2022-01-05 08:45:00','2022-01-05 08:45:00','Basado en Diagnostico Nro:8 Chapa: NAH 367','Abierto',8,'NAH 367'),(10,'douglas','2022-01-05','douglas','2022-01-05 08:53:20','2022-01-05 08:53:20','Basado en Diagnostico Nro:8 Chapa: NAH 367','Abierto',8,'NAH 367'),(11,'douglas','2022-01-05','douglas','2022-01-05 08:53:20','2022-01-05 08:53:20','Basado en Diagnostico Nro:8 Chapa: NAH 367','Abierto',8,'NAH 367'),(12,'douglas','2022-01-05','douglas','2022-01-05 08:54:48','2022-01-05 08:54:48','Basado en Diagnostico Nro:10 Chapa: KDG 973','Abierto',10,'KDG 973');

/*Table structure for table `orden_trab_det` */

DROP TABLE IF EXISTS `orden_trab_det`;

CREATE TABLE `orden_trab_det` (
  `id_orden` int(11) NOT NULL,
  `id_det` int(11) NOT NULL,
  `descrip` varchar(254) DEFAULT NULL,
  `fecha_hora` datetime DEFAULT NULL,
  `estado` varchar(20) DEFAULT NULL,
  `obs_tecnico` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id_orden`,`id_det`),
  CONSTRAINT `id_orden` FOREIGN KEY (`id_orden`) REFERENCES `orden_trab` (`id_orden`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `orden_trab_det` */

insert  into `orden_trab_det`(`id_orden`,`id_det`,`descrip`,`fecha_hora`,`estado`,`obs_tecnico`) values (1,1,'xxxxx','2021-11-30 00:00:00','En Proceso','ccc'),(1,2,'Modificado','2021-12-21 17:27:00','En Proceso','Prueba'),(1,3,'Lorep ipsun dolor','2021-12-22 17:29:00','En Proceso','Lorep ipsun dolorxxx'),(1,4,'ggggggggggggg','2021-12-22 14:39:00','En Proceso',''),(1,5,'xxxxxxxxxxxxxx','0000-00-00 00:00:00','Pendiente',''),(2,1,'xxxxx','0000-00-00 00:00:00','Pendiente',''),(11,1,'ssssssssssss','0000-00-00 00:00:00','Pendiente',''),(11,2,'sssssssssssss','0000-00-00 00:00:00','Pendiente',''),(12,1,'asdasdasd','0000-00-00 00:00:00','Pendiente',''),(12,2,'asdasdada','0000-00-00 00:00:00','Pendiente','');

/*Table structure for table `packing_list` */

DROP TABLE IF EXISTS `packing_list`;

CREATE TABLE `packing_list` (
  `id_pack` int(11) NOT NULL AUTO_INCREMENT,
  `invoice` varchar(40) NOT NULL,
  `n_nro` int(11) NOT NULL,
  `cod_prov` varchar(10) NOT NULL,
  `id_det` int(11) DEFAULT NULL,
  `bale` int(11) DEFAULT NULL,
  `piece` int(11) DEFAULT NULL,
  `codigo` varchar(30) DEFAULT NULL,
  `lote` varchar(30) DEFAULT NULL,
  `descrip` varchar(30) DEFAULT NULL,
  `um` varchar(10) NOT NULL,
  `cod_catalogo` varchar(30) DEFAULT NULL,
  `fab_color_cod` varchar(30) DEFAULT NULL,
  `precio` decimal(16,2) DEFAULT NULL,
  `cantidad` decimal(16,2) DEFAULT NULL,
  `subtotal` decimal(16,2) DEFAULT NULL,
  `color` varchar(30) DEFAULT NULL,
  `color_comb` varchar(40) DEFAULT NULL,
  `design` varchar(60) DEFAULT NULL,
  `composicion` varchar(30) DEFAULT NULL,
  `ancho` decimal(16,2) DEFAULT NULL,
  `gramaje` decimal(16,2) DEFAULT NULL,
  `edited` varchar(1) DEFAULT NULL,
  `obs` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id_pack`,`invoice`,`n_nro`,`cod_prov`),
  KEY `Ref61102` (`n_nro`,`invoice`),
  KEY `Ref59110` (`n_nro`,`cod_prov`),
  KEY `Refinvoice102` (`invoice`,`n_nro`),
  CONSTRAINT `Refcompras110` FOREIGN KEY (`n_nro`, `cod_prov`) REFERENCES `compras` (`n_nro`, `cod_prov`),
  CONSTRAINT `Refinvoice102` FOREIGN KEY (`invoice`, `n_nro`) REFERENCES `invoice` (`invoice`, `n_nro`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `packing_list` */

/*Table structure for table `pago_efec_det` */

DROP TABLE IF EXISTS `pago_efec_det`;

CREATE TABLE `pago_efec_det` (
  `id_amort` int(11) NOT NULL,
  `id_pago` int(11) NOT NULL,
  `ref` int(11) DEFAULT NULL,
  `tipo` varchar(30) DEFAULT NULL,
  `valor` decimal(16,2) DEFAULT NULL,
  `comis_dev` decimal(16,2) DEFAULT NULL,
  `estado` varchar(16) DEFAULT NULL,
  `e_sap` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_amort`,`id_pago`),
  KEY `Ref35183` (`id_amort`,`id_pago`),
  CONSTRAINT `Refpago_rec_det183` FOREIGN KEY (`id_amort`, `id_pago`) REFERENCES `pago_rec_det` (`id_amort`, `id_pago`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `pago_efec_det` */

/*Table structure for table `pago_rec_det` */

DROP TABLE IF EXISTS `pago_rec_det`;

CREATE TABLE `pago_rec_det` (
  `id_amort` int(11) NOT NULL AUTO_INCREMENT,
  `id_pago` int(11) NOT NULL,
  `factura` int(11) DEFAULT NULL,
  `id_cuota` int(11) DEFAULT NULL,
  `valor` decimal(16,2) DEFAULT NULL,
  `fecha_fac` date DEFAULT NULL,
  `folio_num` varchar(30) DEFAULT NULL,
  `pagado` decimal(16,2) DEFAULT NULL,
  `entrega_actual` decimal(16,2) DEFAULT NULL,
  `estado` varchar(16) DEFAULT NULL,
  `tipo` varchar(30) DEFAULT NULL,
  `interes` decimal(16,2) DEFAULT NULL,
  `e_sap` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_amort`,`id_pago`),
  KEY `Ref4464` (`id_pago`),
  CONSTRAINT `Refpagos_recibidos64` FOREIGN KEY (`id_pago`) REFERENCES `pagos_recibidos` (`id_pago`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `pago_rec_det` */

/*Table structure for table `pagos_cancelados` */

DROP TABLE IF EXISTS `pagos_cancelados`;

CREATE TABLE `pagos_cancelados` (
  `id_cancel` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(30) NOT NULL,
  `f_nro` int(11) NOT NULL,
  `id_pago` int(11) NOT NULL,
  `fecha_hora` varchar(20) DEFAULT NULL,
  `e_sap` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_cancel`,`usuario`,`f_nro`,`id_pago`),
  KEY `Ref6176` (`usuario`),
  KEY `Ref3177` (`f_nro`),
  KEY `Ref44178` (`id_pago`),
  CONSTRAINT `Reffactura_venta177` FOREIGN KEY (`f_nro`) REFERENCES `factura_venta` (`f_nro`),
  CONSTRAINT `Refpagos_recibidos178` FOREIGN KEY (`id_pago`) REFERENCES `pagos_recibidos` (`id_pago`),
  CONSTRAINT `Refusuarios176` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `pagos_cancelados` */

/*Table structure for table `pagos_efectuados` */

DROP TABLE IF EXISTS `pagos_efectuados`;

CREATE TABLE `pagos_efectuados` (
  `id_pago` int(11) NOT NULL,
  `suc` varchar(10) NOT NULL,
  `fecha` date DEFAULT NULL,
  `hora` varchar(10) DEFAULT NULL,
  `id_concepto` int(11) NOT NULL,
  `estado` varchar(10) DEFAULT NULL,
  `complemento` varchar(100) DEFAULT NULL,
  `control_caja` varchar(4) DEFAULT NULL,
  `valor` decimal(16,2) DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id_pago`),
  KEY `Ref44179` (`id_pago`),
  KEY `Ref18180` (`suc`),
  KEY `Ref34181` (`id_concepto`),
  CONSTRAINT `Refconceptos181` FOREIGN KEY (`id_concepto`) REFERENCES `conceptos` (`id_concepto`),
  CONSTRAINT `Refpagos_recibidos179` FOREIGN KEY (`id_pago`) REFERENCES `pagos_recibidos` (`id_pago`),
  CONSTRAINT `Refsucursales180` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `pagos_efectuados` */

/*Table structure for table `pagos_recibidos` */

DROP TABLE IF EXISTS `pagos_recibidos`;

CREATE TABLE `pagos_recibidos` (
  `id_pago` int(11) NOT NULL AUTO_INCREMENT,
  `suc` varchar(10) NOT NULL,
  `moneda` varchar(4) NOT NULL,
  `cotiz` decimal(10,2) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `hora` varchar(10) DEFAULT NULL,
  `cod_cli` varchar(30) DEFAULT NULL,
  `cliente` varchar(60) DEFAULT NULL,
  `ruc_cli` varchar(20) DEFAULT NULL,
  `usuario` varchar(30) NOT NULL,
  `folio_num` varchar(30) DEFAULT NULL,
  `pdv_cod` varchar(8) DEFAULT NULL,
  `estado` varchar(10) DEFAULT NULL,
  `control_caja` varchar(4) DEFAULT NULL,
  `pago_a_cuenta` decimal(16,2) DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id_pago`),
  KEY `Ref1866` (`suc`),
  KEY `Ref667` (`usuario`),
  KEY `Ref1568` (`moneda`),
  CONSTRAINT `Refmonedas68` FOREIGN KEY (`moneda`) REFERENCES `monedas` (`m_cod`),
  CONSTRAINT `Refsucursales66` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`),
  CONSTRAINT `Refusuarios67` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `pagos_recibidos` */

/*Table structure for table `paises` */

DROP TABLE IF EXISTS `paises`;

CREATE TABLE `paises` (
  `codigo_pais` varchar(30) NOT NULL,
  `nombre` varchar(30) DEFAULT NULL,
  `hits` int(11) DEFAULT NULL,
  PRIMARY KEY (`codigo_pais`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `paises` */

insert  into `paises`(`codigo_pais`,`nombre`,`hits`) values ('AD','Andorra',NULL),('AE','United Arab Emir.',NULL),('AF','Afghanistan',NULL),('AG','Antigua/Barbuda',NULL),('AI','Anguilla',NULL),('AL','Albania',NULL),('AM','Armenia',NULL),('AN','Dutch Antilles',NULL),('AO','Angola',NULL),('AQ','Antarctica',NULL),('AR','Argentina',10),('AS','Samoa, American',NULL),('AT','Austria',NULL),('AU','Australia',NULL),('AW','Aruba',NULL),('AZ','Azerbaijan',NULL),('BA','Bosnia-Herzegovina',NULL),('BB','Barbados',NULL),('BD','Bangladesh',NULL),('BE','Belgica',NULL),('BF','Burkina-Faso',NULL),('BG','Bulgaria',NULL),('BH','Bahrain',NULL),('BI','Burundi',NULL),('BJ','Benin',NULL),('BL','Saint Barthelemy',NULL),('BM','Bermuda',NULL),('BN','Brunei Dar-es-S',NULL),('BO','Bolivia',6),('BR','Brasil',30),('BS','Bahamas',NULL),('BT','Bhutan',NULL),('BV','Bouvet Island',NULL),('BW','Botswana',NULL),('BY','Belarus',NULL),('BZ','Belize',NULL),('CA','Canada',NULL),('CC','Coconut Islands',NULL),('CF','Central African Rep',NULL),('CG','Congo',NULL),('CH','Schweiz',NULL),('CI','Ivory Coast',NULL),('CK','Cook Islands',NULL),('CL','Chile',5),('CM','Camerun',NULL),('CN','China',0),('CO','Colombia',3),('CR','Costa Rica',NULL),('CU','Cuba',NULL),('CV','Cape Verde',NULL),('CX','Christmas Island',NULL),('CY','Cyprus',NULL),('CZ','Czech Republic',NULL),('DE','Germany',NULL),('DJ','Djibouti',NULL),('DK','Denmark',NULL),('DM','Dominica',NULL),('DO','Republica Dominicana',NULL),('DZ','Algeria',NULL),('EC','Ecuador',NULL),('EE','Estonia',NULL),('EG','Egypt',NULL),('EH','West Sahara',NULL),('EL','Greece',NULL),('ER','Eritrea',NULL),('ES','Spain',NULL),('ET','Ethiopia',NULL),('FI','Finland',NULL),('FJ','Fiji',NULL),('FK','Falkland Islands',NULL),('FM','Micronesia',NULL),('FO','Faroe Islands',NULL),('FR','Francia',NULL),('GA','Gabon',NULL),('GB','United Kingdom',NULL),('GD','Grenada',NULL),('GE','Georgia',NULL),('GF','French Guayana',NULL),('GG','Guernsey',NULL),('GH','Ghana',NULL),('GI','Gibraltar',NULL),('GL','Greenland',NULL),('GM','Gambia',NULL),('GN','Guinea',NULL),('GP','Guadeloupe',NULL),('GQ','Equatorial Guinea',NULL),('GS','S. Sandwich Ins',NULL),('GT','Guatemala',NULL),('GU','Guam',NULL),('GW','Guinea-Bissau',NULL),('GY','Guyana',NULL),('HK','Hong Kong',NULL),('HM','Heard/McDnld Islnds',NULL),('HN','Honduras',NULL),('HR','Croatia',NULL),('HT','Haiti',NULL),('HU','Hungary',NULL),('ID','Indonesia',NULL),('IE','Ireland',NULL),('IL','Israel',NULL),('IM','Isle of Man',NULL),('IN','India',NULL),('IO','Brit.Ind.Oc.Ter',NULL),('IQ','Iraq',NULL),('IR','Iran',NULL),('IS','Iceland',NULL),('IT','Italia',NULL),('JE','Jersey',NULL),('JM','Jamaica',NULL),('JO','Jordan',NULL),('JP','Japon',NULL),('KE','Kenya',NULL),('KG','Kyrgyzstan',NULL),('KH','Cambodia',NULL),('KI','Kiribati',NULL),('KM','Comoros',NULL),('KN','St Kitts & Nevis',NULL),('KP','Korea del Norte',NULL),('KR','Korea del Sur',NULL),('KW','Kuwait',NULL),('KY','Cayman Islands',NULL),('KZ','Kazakhstan',NULL),('LA','Laos',NULL),('LB','Lebanon',NULL),('LC','St. Lucia',NULL),('LI','Liechtenstein',NULL),('LK','Sri Lanka',NULL),('LR','Liberia',NULL),('LS','Lesotho',NULL),('LT','Lithuania',NULL),('LU','Luxemburgo',NULL),('LV','Latvia',NULL),('LY','Libya',NULL),('MA','Morocco',NULL),('MC','Monaco',NULL),('MD','Moldavia',NULL),('ME','Montenegro',NULL),('MF','Saint Martin',NULL),('MG','Madagascar',NULL),('MH','Marshall Islands',NULL),('MK','Republic of Macedonia',NULL),('ML','Mali',NULL),('MM','Myanmar',NULL),('MN','Mongolia',NULL),('MO','Macau',NULL),('MP','N.Mariana Island',NULL),('MQ','Martinique',NULL),('MR','Mauretania',NULL),('MS','Montserrat',NULL),('MT','Malta',NULL),('MU','Mauritius',NULL),('MV','Maldives',NULL),('MW','Malawi',NULL),('MX','Mexico',NULL),('MY','Malaysia',NULL),('MZ','Mozambique',NULL),('NA','Namibia',NULL),('NC','New Caledonia',NULL),('NE','Niger',NULL),('NF','Norfolk Island',NULL),('NG','Nigeria',NULL),('NI','Nicaragua',NULL),('NL','Netherlands',NULL),('NO','Norway',NULL),('NP','Nepal',NULL),('NR','Nauru',NULL),('NU','Niue Islands',NULL),('NZ','New Zealand',NULL),('OM','Oman',NULL),('PA','Panama',NULL),('PE','Peru',4),('PF','French Polynesia',NULL),('PG','Papua New Guinea',NULL),('PH','Philippines',NULL),('PK','Pakistan',NULL),('PL','Poland',NULL),('PM','St.Pier,Miquel.',NULL),('PN','Pitcairn Islands',NULL),('PR','Puerto Rico',NULL),('PS','Palestinian Territory',NULL),('PT','Portugal',NULL),('PW','Palau',NULL),('PY','Paraguay',100),('QA','Qatar',NULL),('RE','Reunion',NULL),('RO','Romania',NULL),('RS','Serbia',NULL),('RU','Russian Fed.',NULL),('RW','Ruanda',NULL),('SA','Saudi Arabia',NULL),('SB','Solomon Islands',NULL),('SC','Seychelles',NULL),('SD','Sudan',NULL),('SE','Sweden',NULL),('SG','Singapore',NULL),('SH','St. Helena',NULL),('SI','Slovenia',NULL),('SJ','Svalbard',NULL),('SK','Slovakia',NULL),('SL','Sierra Leone',NULL),('SM','San Marino',NULL),('SN','Senegal',NULL),('SO','Somalia',NULL),('SR','Suriname',NULL),('ST','S.Tome,Principe',NULL),('SV','El Salvador',NULL),('SX','Sint Maarten',NULL),('SY','Syria',NULL),('SZ','Swaziland',NULL),('TC','Turksh Caicosin',NULL),('TD','Chad',NULL),('TF','French S.Territ',NULL),('TG','Togo',NULL),('TH','Thailand',NULL),('TJ','Tajikstan',NULL),('TK','Tokelau Islands',NULL),('TL','East Timor',NULL),('TM','Turkmenistan',NULL),('TN','Tunisia',NULL),('TO','Tonga',NULL),('TR','Turkey',NULL),('TT','Trinidad,Tobago',NULL),('TV','Tuvalu',NULL),('TW','Taiwan',NULL),('TZ','Tanzania',NULL),('UA','Ukraine',NULL),('UG','Uganda',NULL),('UM','Minor Outl.Ins.',NULL),('US','USA',NULL),('UY','Uruguay',2),('UZ','Uzbekistan',NULL),('VA','Vatican City',NULL),('VC','St. Vincent',NULL),('VE','Venezuela',1),('VG','British Virg. Islnd',NULL),('VI','American Virg.Islnd',NULL),('VN','Vietnam',NULL),('VU','Vanuatu',NULL),('WF','Wallis,Futuna',NULL),('WS','Western Samoa',NULL),('XX','-No Country-',NULL),('YE','Yemen',NULL),('YT','Mayotte',NULL),('ZA','South Africa',NULL),('ZM','Zambia',NULL),('ZW','Zimbabwe',NULL);

/*Table structure for table `pantone` */

DROP TABLE IF EXISTS `pantone`;

CREATE TABLE `pantone` (
  `pantone` varchar(30) NOT NULL,
  `nombre_color` varchar(50) DEFAULT NULL,
  `rgb` varchar(12) DEFAULT NULL,
  `estado` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`pantone`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `pantone` */

insert  into `pantone`(`pantone`,`nombre_color`,`rgb`,`estado`) values ('00-0000','SIN COLOR','','Activo'),('00-0001','BLANCO AZULADO','','Activo'),('00-0002','AZUL CLEMATIS/AMARILLO GREEN SHEEN','','Activo'),('00-0003','AZUL ROYAL/BLANCO BRILLANTE','','Activo'),('00-0004','AZUL PEACOAT/BLANCO BRILLANTE','','Activo'),('00-0005','NEGRO METEORITO/BLANCO','','Activo'),('00-0006','ROJO ESCARLATA/BLANCO BRILLANTE','','Activo'),('00-0007','AZUL BRILLANTE/BLANCO BRILLANTE','','Activo'),('00-0008','NEGRO METEORITO/AMARILLO LIMON','','Activo'),('00-0009','NEGRO METEORITO/AZUL SURF','','Activo'),('00-0010','NEGRO METEORITO/ROJO HIGH RISK','','Activo'),('00-0011','ROJO POPPY/AMARILLO SUPER LIMON','','Activo'),('00-0012','ROJO ESCARLATA/AZUL ROYAL','','Activo'),('00-0013','ROJO FORMULA UNO/AZUL PEACOAT','','Activo'),('00-0014','AZUL VISTA/BLANCO BRILLANTE','','Activo'),('00-0015','VERDE FRIJOL/BLANCO BRILLANTE','','Activo'),('00-0016','NEGRO METEORITO/FUCSIA ROSE','','Activo'),('00-0017','GRIS OSCURO SOMBRAS/GRIS DAPLE','','Activo'),('00-0018','VERDE CIPRES/BEIGE CASTILLO','','Activo'),('00-0019','NEGRO METEORITO/CELESTE ANGEL','','Activo'),('00-0020','NARANJA MIEL/GRIS DAPLE','','Activo'),('00-0021','NEGRO METEORITO/BEIGE SAFARI','','Activo'),('00-0022','PURPURA ASTER/BLANCO BRILLANTE','','Activo'),('00-0023','NEGRO METEORITO/GRIS CASTLEROCK','','Activo'),('00-0024','LILA ZARZAMORA/GRIS HIERRO FORJADO','','Activo'),('00-0025','ROJO POMPEYA/GRIS OSCURO SOMBRAS','','Activo'),('00-0026','FUCSIA ROSE/GRIS TORNADO','','Activo'),('00-0027','CORAL PICADO/BLANCO BRILLANTE','','Activo'),('00-0028','FUCSIA ROSE/BEIGE OSTRA','','Activo'),('00-0029','AMARILLO YEMA/GRIS DAPLE','','Activo'),('00-0030','MARRON CAFE OSCURO/BEIGE CASTILLO','','Activo'),('00-0031','VERDE CERAMICA/BLANCO BRILLANTE','','Activo'),('00-0032','AZUL ECLIPSE TOTAL/GRIS HIERRO FORJADO','','Activo'),('00-0033','AZUL ULTRAMARINO/GRIS DAPLE','','Activo'),('00-0034','NEGRO METEORITO/VERDE NEON','','Activo'),('00-0035','NEGRO METEORITO/TURQUESA SUIZA','','Activo'),('00-0036','FUCSIA ROSE/BLANCO BRILLANTE','','Activo'),('00-0037','MAGENTA FRAMBUESA/GRIS HIERRO FORJADO','','Activo'),('00-0038','BLANCO AZULADO+','','Activo'),('11-0103','NATURAL EGRET','','Activo'),('11-0104','VAINILLA HIELO','','Activo'),('11-0105','BLANCO ANTIGUO','','Activo'),('11-0107','BLANCO PAPIRO','','Activo'),('11-0304','VERDE CLARO LILY','','Activo'),('11-0507','VAINILLA INVIERNO','','Activo'),('11-0510','MARFIL AFTERGLOW','','Activo'),('11-0601','BLANCO BRILLANTE','','Activo'),('11-0602','BLANCO NIEVE','','Activo'),('11-0603','BLANCO PERGAMINO PASTEL','','Activo'),('11-0604','NATURAL GARDENIA','','Activo'),('11-0605','BLANCO JET STREAM','','Activo'),('11-0606','BLANCO PRISTINO','','Activo'),('11-0616','AMARILLO PASTEL','','Activo'),('11-0617','AMARILLO TRANSPARENTE','','Activo'),('11-0618','AMARILLO CERA','','Activo'),('11-0619','AMARILLO FLAN','','Activo'),('11-0620','AMARILLO ELFIN','','Activo'),('11-0622','AMARILLO IRIS','','Activo'),('11-0701','BLANCO SUSURRO','','Activo'),('11-0710','AMARILLO TIERNO','','Activo'),('11-0809','BEIGE ECRU','','Activo'),('11-0907','MARFIL PERLADO','','Activo'),('11-1001','BLANCO ALYSSUM','','Activo'),('11-1305','ROSA ANGEL','','Activo'),('11-1404','NATURAL POLVO PUFF','','Activo'),('11-2409','ROSA DELICADO','','Activo'),('11-4201','BLANCO NUBE','','Activo'),('11-4202','BLANCO ESTRELLA','','Activo'),('11-4300','BLANCO MALVAVISCO','','Activo'),('11-4301','BLANCO LILY','','Activo'),('11-4601','CELESTE PALIDO','','Activo'),('11-4800','BLANCO DE BLANC','','Activo'),('12-0000','NATURAL CISNE','','Activo'),('12-0104','BLANCO ESPARRAGOS','','Activo'),('12-0106','VERDE PRADO MIST','','Activo'),('12-0109','VERDE AMBROSIA','','Activo'),('12-0225','VERDE PATINA','','Activo'),('12-0304','BEIGE WHITECAP','','Activo'),('12-0311','BEIGE ESPARRAGO','','Activo'),('12-0312','VERDE LIMA CREMA','','Activo'),('12-0313','VERDE ESPUMA MAR','','Activo'),('12-0315','VERDE JADE BLANCO','','Activo'),('12-0317','VERDE DESTELLO','','Activo'),('12-0322','VERDE MARIPOSA','','Activo'),('12-0435','VERDE DAIQUIRI','','Activo'),('12-0521','AMARILLO TRIGO JOVEN','','Activo'),('12-0601','NATURAL PONCHE','','Activo'),('12-0605','BEIGE ANGORA','','Activo'),('12-0619','AMARILLO ANTIGUO','','Activo'),('12-0626','AMARILLO LIMON GRASS','','Activo'),('12-0633','AMARILLO CANARIO','','Activo'),('12-0642','AMARILLO AURORA','','Activo'),('12-0643','AMARILLO BLAZING','','Activo'),('12-0703','NATURAL PERLA','','Activo'),('12-0709','BEIGE MACADAMIA','','Activo'),('12-0710','NATURAL NAVAJO','','Activo'),('12-0711','AMARILLO LIMON MERENGUE','','Activo'),('12-0712','VAINILLA','','Activo'),('12-0713','VAINILLA ALMENDRA','','Activo'),('12-0714','AMARILLO MAIZ CLARO','','Activo'),('12-0717','AMARILLO ANIS','','Activo'),('12-0718','AMARILLO PIÑA','','Activo'),('12-0720','AMARILLO MELOSO','','Activo'),('12-0721','AMARILLO LIMONADA','','Activo'),('12-0722','VAINILLA FRANCESA','','Activo'),('12-0727','AMARILLO SOL','','Activo'),('12-0729','AMARILLO SOL DRESS','','Activo'),('12-0736','AMARILLO LIMON DROP','','Activo'),('12-0737','AMARILLO JILGUERO','','Activo'),('12-0738','AMARILLO CREMA','','Activo'),('12-0740','AMARILLO LIMA SUAVE','','Activo'),('12-0741','AMARILLO LIMA SOLEADO','','Activo'),('12-0752','AMARILLO MANTECA','','Activo'),('12-0758','AMARILLO YARROW','','Activo'),('12-0804','VAINILLA CREMA','','Activo'),('12-0806','VAINILLA NABO SUECO','','Activo'),('12-0811','SALMON AMANECER','','Activo'),('12-0812','AMARILLO ALABASTRO','','Activo'),('12-0815','AMARILLO VAINILLA','','Activo'),('12-0822','VAINILLA ORO','','Activo'),('12-0824','AMARILLO BANANA PALIDO','','Activo'),('12-0825','AMARILLO POPCORN','','Activo'),('12-0826','AMARILLO HAZE','','Activo'),('12-0910','BEIGE LANA','','Activo'),('12-0911','NUDE','','Activo'),('12-0912','SALMON MELOCOTON','','Activo'),('12-0913','SALMON ALESAN','','Activo'),('12-0915','SALMON DURAZNO PALIDO','','Activo'),('12-1005','SALMON NOVELLE PEACH','','Activo'),('12-1006','BEIGE MADRE PERLA','','Activo'),('12-1007','ROSA PASTEL TAN','','Activo'),('12-1011','ROSA MELOCOTON PUREE','','Activo'),('12-1106','ROSA PURA','','Activo'),('12-1206','ROSA PEONIA SILVER','','Activo'),('12-1207','ROSA PERLA BLUSH','','Activo'),('12-1212','ROSA VELADA','','Activo'),('12-1304','ROSA PERLA','','Activo'),('12-1310','ROSA BRIDE','','Activo'),('12-1403','BEIGE TAPIOCA','','Activo'),('12-1605','ROSA CRISTAL','','Activo'),('12-1706','ROSA DOGWOOD','','Activo'),('12-1708','ROSA SUAVE CRISTAL','','Activo'),('12-2902','ROSA TIZA MAUVE','','Activo'),('12-2903','LILA LIGERO','','Activo'),('12-2904','ROSA PRIMROSE','','Activo'),('12-2905','ROSA INFANTIL','','Activo'),('12-2906','ROSA SUAVE','','Activo'),('12-4604','CELESTE CLARABOYA','','Activo'),('12-4607','AZUL PASTEL','','Activo'),('12-4608','CELESTE AGUA CLARA','','Activo'),('12-4610','CELESTE SUSURRO','','Activo'),('12-4805','CELESTE PALIDO OSCURO','','Activo'),('12-5202','NATURAL TORTOLA CLARO','','Activo'),('12-5205','NATURAL TORTOLA','','Activo'),('12-5406','CELESTE OPALO','','Activo'),('12-5408','VERDE AGUA MOONLIGHT','','Activo'),('12-5410','TURQUESA AGUA CLARA','','Activo'),('12-5505','CELESTE GLACIAR','','Activo'),('12-5507','VERDE AGUA BAHIA','','Activo'),('12-5808','VERDE AGUA HONEYDEW','','Activo'),('12-6204','NATURAL PLATA','','Activo'),('13-0000','GRIS MOONBEAM','','Activo'),('13-0002','BLANCO ARENA','','Activo'),('13-0107','VERDE AGUA DEWKIST','','Activo'),('13-0111','VERDE SEACREST','','Activo'),('13-0116','VERDE PASTEL','','Activo'),('13-0117','VERDE ASH','','Activo'),('13-0210','VERDE NEBLINA','','Activo'),('13-0220','VERDE PARAISO','','Activo'),('13-0221','VERDE PISTACHO','','Activo'),('13-0317','VERDE LILY','','Activo'),('13-0319','AMARILLO LIMA SOMBRA','','Activo'),('13-0324','VERDE LECHUGA','','Activo'),('13-0331','VERDE SAVIA','','Activo'),('13-0401','BEIGE HARINA','','Activo'),('13-0403','GRIS MOM','','Activo'),('13-0442','VERDE RESPLANDOR','','Activo'),('13-0513','VAINILLA FROZEN','','Activo'),('13-0522','VERDE PALIDO','','Activo'),('13-0530','VERDE LIMA SORBETE','','Activo'),('13-0535','VERDE AGUDO','','Activo'),('13-0540','VERDE LIMA SALVAJE','','Activo'),('13-0550','VERDE LIMA PUNCH','','Activo'),('13-0607','BEIGE FOG','','Activo'),('13-0614','AMARILLO JARDIN CLARO','','Activo'),('13-0624','VAINILLA GOLDEN MIST','','Activo'),('13-0632','AMARILLO ESCAROLA','','Activo'),('13-0633','AMARILLO CHARDONNAY','','Activo'),('13-0640','AMARILLO ACACIA','','Activo'),('13-0645','AMARILLO LIMEADE','','Activo'),('13-0648','AMARILLO GREEN SHEEN','','Activo'),('13-0650','VERDE AZUFRE SPRING','','Activo'),('13-0715','BEIGE NIEBLA MARINA','','Activo'),('13-0720','AMARILLO NATA','','Activo'),('13-0725','CAMEL RAFFIA','','Activo'),('13-0739','AMARILLO CREMA GOLD','','Activo'),('13-0746','AMARILLO MAIZ','','Activo'),('13-0752','AMARILLO LIMON','','Activo'),('13-0755','AMARILLO PRIMROSE','','Activo'),('13-0756','AMARILLO LIMON ZEST','','Activo'),('13-0758','AMARILLO DANDELION','','Activo'),('13-0759','AMARILLO SOL POWER','','Activo'),('13-0814','VAINILLA MELON SUMMER','','Activo'),('13-0815','AMARILLO BANANA CREMA','','Activo'),('13-0822','AMARILLO LUZ SOLAR','','Activo'),('13-0840','AMARILLO SNAP','','Activo'),('13-0850','AMARILLO ALAMO','','Activo'),('13-0858','AMARILLO VIBRANTE','','Activo'),('13-0859','AMARILLO LIMON CROMO','','Activo'),('13-0907','BEIGE SANDSHELL','','Activo'),('13-0908','NATURAL PERGAMINO','','Activo'),('13-0915','VAINILLA CAÑA','','Activo'),('13-0916','AMARILLO MANZANILLA','','Activo'),('13-0917','AMARILLO PAJA ITALIANA','','Activo'),('13-0922','BEIGE STRAW','','Activo'),('13-0932','AMARILLO MAIZ SEDA','','Activo'),('13-0935','AMARILLO FLAX','','Activo'),('13-0939','AMARILLO GOLDEN CREAM','','Activo'),('13-0940','AMARILLO OCASO DORADO','','Activo'),('13-0941','AMARILLO BANANA','','Activo'),('13-0942','AMARILLO AMBAR','','Activo'),('13-0947','AMARILLO BANANA OSCURO','','Activo'),('13-1006','BEIGE CREME BRULEE','','Activo'),('13-1007','BEIGE OSCURO OSTRA','','Activo'),('13-1008','BEIGE ARENA CLARA','','Activo'),('13-1009','BEIGE BISCOTTI','','Activo'),('13-1010','BEIGE ARENA GRAY','','Activo'),('13-1011','BEIGE CREMA','','Activo'),('13-1012','BEIGE ALMENDRA HIELO','','Activo'),('13-1014','SALMON MELLOW BUFF','','Activo'),('13-1015','SALMON MIEL','','Activo'),('13-1016','BEIGE TRIGO CLARO','','Activo'),('13-1017','SALMON CREMA','','Activo'),('13-1018','NARANJA DESERT DUST','','Activo'),('13-1021','NARANJA SUNSET','','Activo'),('13-1022','CORAL CARAMELO CREMA','','Activo'),('13-1024','VAINILLA BUFF','','Activo'),('13-1027','NARANJA CREMA','','Activo'),('13-1107','BEIGE SUSPIRO ROSA','','Activo'),('13-1108','ROSA CREMA TAN','','Activo'),('13-1109','SALMON MARISCO','','Activo'),('13-1114','SALMON BELLINI','','Activo'),('13-1310','ROSA INGLES','','Activo'),('13-1318','ROSA TROPICAL','','Activo'),('13-1404','ROSA PALIDO','','Activo'),('13-1406','ROSA NUBE','','Activo'),('13-1407','ROSA SUAVE CRIOLLA','','Activo'),('13-1408','ROSA CHINTZ','','Activo'),('13-1409','ROSA SEACHELL','','Activo'),('13-1504','ROSA MELOCOTON BLUSH','','Activo'),('13-1510','ROSA FLORAL','','Activo'),('13-1513','ROSA CLARO ARAÑA','','Activo'),('13-1904','ROSA TIZA','','Activo'),('13-1906','ROSA SOMBRA','','Activo'),('13-2004','ROSA POTPOURRI','','Activo'),('13-2005','ROSA FRESA CREMA','','Activo'),('13-2006','ROSA BLOSSOM','','Activo'),('13-2010','ROSA ORQUIDEA','','Activo'),('13-2802','ROSA FAIRY TALE','','Activo'),('13-2804','ROSA PARFAIT','','Activo'),('13-2805','ROSA BRUMA','','Activo'),('13-2806','ROSA MUJER','','Activo'),('13-2807','ROSA BAILARINA','','Activo'),('13-3405','ROSA LILAC SNOW','','Activo'),('13-3406','LILA ORQUIDEA HIELO','','Activo'),('13-3801','GRIS CRISTAL','','Activo'),('13-3802','LILA ORQUIDEA TINTA','','Activo'),('13-3803','LILA CENIZA CLARO','','Activo'),('13-3820','LILA LAVANDA FOG','','Activo'),('13-4103','CELESTE ILUSION','','Activo'),('13-4108','GRIS NIMBUS CLOUD','','Activo'),('13-4200','CELESTE VERNA','','Activo'),('13-4303','GRIS AMANECER','','Activo'),('13-4304','AZUL BALADA','','Activo'),('13-4308','AZUL BEBE','','Activo'),('13-4405','AZUL CELESTE NIEBLA','','Activo'),('13-4409','CELESTE GLOW','','Activo'),('13-4411','CELESTE CRISTAL','','Activo'),('13-4809','CELESTE PLUMA','','Activo'),('13-4909','CELESTE LIGHT','','Activo'),('13-4910','VERDE AGUA TINT','','Activo'),('13-5309','TURQUESA PASTEL','','Activo'),('13-5313','TURQUESA ARUBA','','Activo'),('13-5409','VERDE AGUA YUCCA','','Activo'),('13-5412','VERDE AGUA GLASS','','Activo'),('13-5414','VERDE AGUA HIELO','','Activo'),('13-5714','VERDE AGUA CABBAGE','','Activo'),('13-5907','VERDE AGUA ARAÑA','','Activo'),('13-6007','VERDE AGUA SPRAY','','Activo'),('13-6009','VERDE AGUA BROOK','','Activo'),('13-6106','VERDE TINTA','','Activo'),('13-6107','VERDE AGUA LILY','','Activo'),('13-6208','VERDE BOK CHOY','','Activo'),('14-0000','GRIS PLATA','','Activo'),('14-0105','BEIGE NUBLADO','','Activo'),('14-0108','BEIGE CASTILLO','','Activo'),('14-0115','VERDE ESPUMA','','Activo'),('14-0116','VERDE MARGARITA','','Activo'),('14-0123','VERDE ARCADIAN','','Activo'),('14-0127','VERDE GAGE','','Activo'),('14-0156','VERDE VERANO','','Activo'),('14-0226','VERDE OPALINA','','Activo'),('14-0232','VERDE LIMA JADE','','Activo'),('14-0244','VERDE LIMA BRILLANTE','','Activo'),('14-0418','VERDE PANTANO CLARO','','Activo'),('14-0434','VERDE BANANA','','Activo'),('14-0445','VERDE CHARTREUSE','','Activo'),('14-0446','VERDE TENDER SHOOTS','','Activo'),('14-0452','VERDE LIMA','','Activo'),('14-0626','AMARILLO MUSGO SECO','','Activo'),('14-0636','AMARILLO LIMA APAGADO','','Activo'),('14-0647','AMARILLO APIO','','Activo'),('14-0708','BEIGE CEMENTO','','Activo'),('14-0740','AMARILLO BAMBOO','','Activo'),('14-0754','AMARILLO SUPER LIMON','','Activo'),('14-0755','AMARILLO AZUFRE','','Activo'),('14-0756','AMARILLO IMPERIO','','Activo'),('14-0760','AMARILLO CYBER','','Activo'),('14-0826','VAINILLA PAMPA','','Activo'),('14-0827','AMARILLO CITRUS OSCURO','','Activo'),('14-0837','AMARILLO MISTED','','Activo'),('14-0846','AMARILLO YEMA','','Activo'),('14-0848','AMARILLO MIMOSA','','Activo'),('14-0850','NARANJA NARCISO','','Activo'),('14-0851','AMARILLO SOL SAMOAN','','Activo'),('14-0852','AMARILLO FREESIA','','Activo'),('14-0935','AMARILLO JOJOBA','','Activo'),('14-0936','VAINILLA SAHARA SOL','','Activo'),('14-0941','NARANJA MIEL','','Activo'),('14-0951','AMARILLO CORONA','','Activo'),('14-0955','AMARILLO CITRUS','','Activo'),('14-0957','AMARILLO SPECTRA','','Activo'),('14-1012','BEIGE CHAMPAGNE','','Activo'),('14-1014','BEIGE GRAVA','','Activo'),('14-1025','VAINILLA CAPULLO','','Activo'),('14-1031','AMARILLO RATTAN','','Activo'),('14-1036','AMARILLO OCRE','','Activo'),('14-1038','BEIGE TRIGO','','Activo'),('14-1041','CAMEL APRICOT','','Activo'),('14-1064','AMARILLO AZAFRAN','','Activo'),('14-1106','BEIGE PEYOTE','','Activo'),('14-1107','BEIGE OSTRA','','Activo'),('14-1108','BEIGE WOOD ASH','','Activo'),('14-1110','BEIGE BOULDER','','Activo'),('14-1112','BEIGE GUIJARRO','','Activo'),('14-1113','BEIGE MAZAPAN','','Activo'),('14-1116','BEIGE ALMENDRA','','Activo'),('14-1118','BEIGE','','Activo'),('14-1119','BEIGE TRIGO WINTER','','Activo'),('14-1120','SALMON ILUSION','','Activo'),('14-1122','SALMON PIEL CARNERO','','Activo'),('14-1127','BEIGE DESIERTO MIST','','Activo'),('14-1128','NARANJA BUFF','','Activo'),('14-1135','SALMON BUFF','','Activo'),('14-1139','NARANJA PUMPKIN','','Activo'),('14-1159','NARANJA ZINNIA','','Activo'),('14-1209','BEIGE SMOKE GRAY','','Activo'),('14-1210','BEIGE ARENA MOVEDIZA','','Activo'),('14-1212','BEIGE FRAPPE','','Activo'),('14-1213','BEIGE ALMENDRA TOSTADA','','Activo'),('14-1217','SALMON LUZ AMBAR','','Activo'),('14-1219','ROSA MELOCOTON PARFAIT','','Activo'),('14-1224','CORAL ARENA CLARO','','Activo'),('14-1225','CORAL ARENA','','Activo'),('14-1227','NARANJA MELOCOTON','','Activo'),('14-1228','ROSA MELOCOTON','','Activo'),('14-1230','NARANJA LAVADO','','Activo'),('14-1305','BEIGE HONGOS','','Activo'),('14-1307','ROSA EMPOLVADO','','Activo'),('14-1311','ROSA AMANECER ARENA','','Activo'),('14-1312','ROSA RUBOR PALIDO','','Activo'),('14-1313','ROSA NUBE CLARO','','Activo'),('14-1314','ROSA ESPAÑOL VILLA','','Activo'),('14-1316','SALMON ANTIGUO','','Activo'),('14-1318','CORAL ROSA','','Activo'),('14-1323','SALMON','','Activo'),('14-1418','ROSA MELOCOTON MELBA','','Activo'),('14-1419','ROSA DURAZNO CLARO','','Activo'),('14-1506','ROSA SMOKE','','Activo'),('14-1508','ROSA METAL','','Activo'),('14-1511','ROSA POLVO','','Activo'),('14-1513','ROSA FLOR CLARA','','Activo'),('14-1521','ROSA MELOCOTON CREMA','','Activo'),('14-1714','ROSA QUARZO','','Activo'),('14-1905','ROSA LOTUS','','Activo'),('14-1907','ROSA PIEL DURAZNO','','Activo'),('14-1909','ROSA CORAL BLUSH','','Activo'),('14-1911','ROSA CARAMELO','','Activo'),('14-2305','ROSA NECTAR','','Activo'),('14-2307','ROSA CAMEO','','Activo'),('14-2311','ROSA PRISMA','','Activo'),('14-2710','FUCSIA LILAC','','Activo'),('14-2808','LILA DULCE','','Activo'),('14-3204','LILA PERFUMADA','','Activo'),('14-3206','LILA MARAVILLOSO','','Activo'),('14-3207','ROSA LAVANDA','','Activo'),('14-3209','LILA LAVANDA PASTEL','','Activo'),('14-3612','LILA ORQUIDEA BLOOM','','Activo'),('14-3710','LILA ORQUIDEA PETALOS','','Activo'),('14-3805','LILA IRIS','','Activo'),('14-3812','LILA PASTEL','','Activo'),('14-3903','GRIS LILA MARIBE','','Activo'),('14-3911','LILA LAVANDA HEATHER','','Activo'),('14-3949','LILA XENON','','Activo'),('14-4002','GRIS WIND CHIME','','Activo'),('14-4102','GRIS GLACIAR','','Activo'),('14-4103','GRIS VIOLETA','','Activo'),('14-4105','GRIS MICRO CHIP','','Activo'),('14-4110','LILA HEATHER','','Activo'),('14-4112','CELESTE SKYWAY','','Activo'),('14-4115','CELESTE CASHMERE','','Activo'),('14-4121','AZUL BELL','','Activo'),('14-4201','GRIS LUNAR ROCK','','Activo'),('14-4203','GRIS VAPOR','','Activo'),('14-4206','GRIS PERLA','','Activo'),('14-4210','CELESTE CELESTIAL','','Activo'),('14-4214','CELESTE POLVO','','Activo'),('14-4306','CELESTE NUBE','','Activo'),('14-4307','CELESTE CIELO WINTER','','Activo'),('14-4310','TURQUESA TOPACIO','','Activo'),('14-4311','CELESTE CORYDALIS','','Activo'),('14-4313','CELESTE','','Activo'),('14-4317','CELESTE FRIO','','Activo'),('14-4318','CELESTE CIELO CLARO','','Activo'),('14-4500','GRIS LUNATICO','','Activo'),('14-4501','GRIS PLATA LINING','','Activo'),('14-4503','GRIS METAL','','Activo'),('14-4504','CIELO GRIS','','Activo'),('14-4508','CELESTE ESTRATOSFERA','','Activo'),('14-4510','CELESTE ACUATICO','','Activo'),('14-4511','CELESTE STREAM','','Activo'),('14-4512','CELESTE PORCELANA','','Activo'),('14-4516','CELESTE PETIT FOUR','','Activo'),('14-4522','TURQUESA BOTON','','Activo'),('14-4804','GRIS FOX','','Activo'),('14-4807','VERDE SURF SPRAY','','Activo'),('14-4810','CELESTE CANAL','','Activo'),('14-4811','CELESTE CIELO','','Activo'),('14-4812','CELESTE SPLASH','','Activo'),('14-4814','CELESTE ANGEL','','Activo'),('14-4816','TURQUESA RESPLANDOR','','Activo'),('14-4908','VERDE AGUA HARBOR','','Activo'),('14-5002','GRIS SILVER','','Activo'),('14-5413','VERDE AGUA HOLIDAY','','Activo'),('14-5416','VERDE BERMUDA','','Activo'),('14-5420','AGUAMARINA LOCKATOO','','Activo'),('14-5711','VERDE OCEANO','','Activo'),('14-5713','VERDE AGUA CASCADA','','Activo'),('14-5714','VERDE AGUA LUCITE','','Activo'),('14-5718','VERDE AGUA OPALO','','Activo'),('14-5721','VERDE AGUA ELECTRICO','','Activo'),('14-6007','VERDE ESPUMA OCEANO','','Activo'),('14-6008','VERDE SUTIL','','Activo'),('14-6017','VERDE AGUA NEPTUNO','','Activo'),('14-6305','NATURAL PELICANO','','Activo'),('14-6308','VERDE ALFALFA','','Activo'),('14-6316','VERDE SPRUCESTONE','','Activo'),('14-6324','VERDE ARVERJAS','','Activo'),('14-6327','VERDE CEFIRO','','Activo'),('14-6330','VERDE AGUA PRIMAVERA','','Activo'),('14-6340','VERDE AGUA BOUQUET','','Activo'),('14-6408','GRIS PIEDRA ABADIA','','Activo'),('15-0000','GRIS PALOMA','','Activo'),('15-0146','VERDE FLASH','','Activo'),('15-0309','BEIGE SPRAY GREEN','','Activo'),('15-0318','BEIGE SAGE GREEN','','Activo'),('15-0332','VERDE HOJA','','Activo'),('15-0336','VERDE HIERBA CLARO','','Activo'),('15-0341','VERDE LORO','','Activo'),('15-0343','VERDE VEGETACION','','Activo'),('15-0522','VERDE OLIVA PALIDO','','Activo'),('15-0523','VERDE PERA WINTER','','Activo'),('15-0525','BEIGE SAUCE LLORON','','Activo'),('15-0531','VERDE GUISANTE','','Activo'),('15-0535','VERDE PALMA','','Activo'),('15-0545','VERDE JAZMIN','','Activo'),('15-0548','AMARILLO CITRONELA','','Activo'),('15-0643','VERDE BERRO','','Activo'),('15-0646','VERDE OLIVA WARM','','Activo'),('15-0703','GRIS CENIZA CLARO','','Activo'),('15-0719','BEIGE HELECHO','','Activo'),('15-0730','BEIGE MUSGO SUR','','Activo'),('15-0732','BEIGE OLIVENITE','','Activo'),('15-0743','AMARILLO ACEITE','','Activo'),('15-0751','AMARILLO LIMON CURRY','','Activo'),('15-0850','AMARILLO CEYLON','','Activo'),('15-0927','BEIGE ORO PALIDO','','Activo'),('15-0942','AMARILLO VINO BLANCO','','Activo'),('15-0948','AMARILLO CHINO','','Activo'),('15-0953','AMARILLO ORO OSCURO','','Activo'),('15-0955','AMARILLO OLD GOLD','','Activo'),('15-1046','AMARILLO MINERAL','','Activo'),('15-1049','AMARILLO ARTESANO','','Activo'),('15-1050','NARANJA DORADO','','Activo'),('15-1054','NARANJA CADMIUM','','Activo'),('15-1058','NARANJA RADIANTE','','Activo'),('15-1062','AMARILLO ORO','','Activo'),('15-1114','MARRON TRAVERTINE','','Activo'),('15-1116','BEIGE SAFARI','','Activo'),('15-1119','BEIGE TAOS','','Activo'),('15-1132','BEIGE OTOÑO','','Activo'),('15-1142','AMARILLO MIEL ORO','','Activo'),('15-1145','NARANJA CHAMOIS','','Activo'),('15-1147','NARANJA CARAMELO','','Activo'),('15-1150','NARANJA CHEDDAR','','Activo'),('15-1157','NARANJA CLARO FLAMA','','Activo'),('15-1160','NARANJA BLAZING','','Activo'),('15-1164','NARANJA MARIGOLD','','Activo'),('15-1213','BEIGE JENGIBRE','','Activo'),('15-1214','BEIGE ARENA WARM','','Activo'),('15-1215','BEIGE SESAMO','','Activo'),('15-1216','BEIGE KAQUI PALIDO','','Activo'),('15-1217','BEIGE DESIERTO MOJAVE','','Activo'),('15-1218','BEIGE SEMOLINA','','Activo'),('15-1220','BEIGE LATTE','','Activo'),('15-1225','CAMEL ARENA','','Activo'),('15-1234','NARANJA DORADO TIERRA','','Activo'),('15-1242','NARANJA MUSKMELON','','Activo'),('15-1245','SALMON MOCK','','Activo'),('15-1247','NARANJA MANDARINA','','Activo'),('15-1263','NARANJA OTOÑO','','Activo'),('15-1304','BEIGE HUMUS','','Activo'),('15-1305','GRIS PLUMA','','Activo'),('15-1306','BEIGE OXFORD','','Activo'),('15-1307','BEIGE PIMIENTA WHITE','','Activo'),('15-1308','BEIGE DOESKIN','','Activo'),('15-1309','BEIGE MOONLIGHT','','Activo'),('15-1314','BEIGE ARENA CUBA','','Activo'),('15-1315','BEIGE RUGBY','','Activo'),('15-1316','BEIGE MAPLE SUGAR','','Activo'),('15-1318','ROSA ARENA','','Activo'),('15-1319','SALMON APRICOT','','Activo'),('15-1327','MELOCOTON BLOOM','','Activo'),('15-1331','CORAL REEF','','Activo'),('15-1333','SALMON ATARDECER','','Activo'),('15-1334','CORAL SHELL','','Activo'),('15-1340','CORAL CADMIUM','','Activo'),('15-1415','CORAL NUBE','','Activo'),('15-1423','ROSA MELOCOTON AMBER','','Activo'),('15-1433','CORAL PAPAYA','','Activo'),('15-1435','CORAL FLOR DESIERTO','','Activo'),('15-1506','GRIS ETHEREA','','Activo'),('15-1511','ROSA CAOBA','','Activo'),('15-1512','ROSA MISTY','','Activo'),('15-1515','ROSA MELLOW','','Activo'),('15-1516','ROSA MELOCOTON BEIGE','','Activo'),('15-1530','ROSA DURAZNO VELA','','Activo'),('15-1607','LILA MALVA PALIDO','','Activo'),('15-1611','ROSA NOVIA','','Activo'),('15-1614','ROSA BLUSH','','Activo'),('15-1621','ROSA DURAZNO','','Activo'),('15-1626','ROSA SALMON','','Activo'),('15-1717','ROSA GLASEADO','','Activo'),('15-1816','ROSA PEONIA','','Activo'),('15-1906','ROSA CEFIRO','','Activo'),('15-1912','ROSA MAR','','Activo'),('15-1920','ROSA AMANECER','','Activo'),('15-1922','FUCSIA GERANIO','','Activo'),('15-2210','ROSA ORQUIDEA SMOKE','','Activo'),('15-2214','ROSA BLOOM','','Activo'),('15-2215','ROSA BEGONIA','','Activo'),('15-2216','FUCSIA SACHET','','Activo'),('15-2217','ROSA AURORA','','Activo'),('15-2706','LILA VIOLETA HIELO','','Activo'),('15-2718','FUCSIA ROSA','','Activo'),('15-2913','FUCSIA CHIFFON','','Activo'),('15-3207','LILA MALVA NIEBLA','','Activo'),('15-3412','LILA ORQUIDEA','','Activo'),('15-3508','LILA ORQUIDEA FAIR','','Activo'),('15-3620','LILA LAVENDULA','','Activo'),('15-3800','GRIS MARSOPA','','Activo'),('15-3802','GRIS NUBE','','Activo'),('15-3817','LILA LAVANDA','','Activo'),('15-3909','LILA COSMIC SKY','','Activo'),('15-3912','LILA ALEUTIAN','','Activo'),('15-3920','AZUL PLACID','','Activo'),('15-3930','AZUL VISTA','','Activo'),('15-3932','AZUL BEL AIR','','Activo'),('15-4005','CELESTE SUEÑOS','','Activo'),('15-4008','AZUL NIEBLA','','Activo'),('15-4020','CELESTE CERULEO','','Activo'),('15-4030','CELESTE CHAMBRAY','','Activo'),('15-4101','GRIS HIGH RISE','','Activo'),('15-4105','AZUL ANGEL','','Activo'),('15-4225','AZUL ALASKA','','Activo'),('15-4305','GRIS QUARRY','','Activo'),('15-4307','GRIS TRADEWINDS','','Activo'),('15-4312','CELESTE FORGET','','Activo'),('15-4319','AZUL BRISA','','Activo'),('15-4323','TURQUESA ETEREO','','Activo'),('15-4415','CELESTE MILKY','','Activo'),('15-4421','CELESTE GRUTA','','Activo'),('15-4427','TURQUESA NORSE','','Activo'),('15-4502','GRIS NUBE PLATA','','Activo'),('15-4503','GRIS CASTILLO CLARO','','Activo'),('15-4703','GRIS MIRAGE','','Activo'),('15-4706','GRIS NIEBLA','','Activo'),('15-4712','AGUAMARINA','','Activo'),('15-4714','AGUAMARINA ACUARELA','','Activo'),('15-4715','CELESTE MAR','','Activo'),('15-4720','TURQUESA RIO','','Activo'),('15-4722','TURQUESA CAPRI','','Activo'),('15-4825','TURQUESA CURACAO','','Activo'),('15-5205','GRIS AQUA','','Activo'),('15-5207','VERDE ACUIFERO','','Activo'),('15-5209','CELESTE AGUA','','Activo'),('15-5210','AGUAMARINA NILO','','Activo'),('15-5217','VERDE TURQUESA','','Activo'),('15-5218','VERDE AGUA PISCINA','','Activo'),('15-5416','VERDE AGUA FLORIDA','','Activo'),('15-5421','VERDE AGUA','','Activo'),('15-5425','VERDE ATLANTIS','','Activo'),('15-5516','VERDE CASCADA','','Activo'),('15-5519','VERDE AGUA TURQUESA','','Activo'),('15-5534','VERDE BRILLANTE','','Activo'),('15-5706','VERDE FROSTY','','Activo'),('15-5711','VERDE AGUA JADE','','Activo'),('15-5718','VERDE VIZCAYA','','Activo'),('15-5728','VERDE HOJA MENTA','','Activo'),('15-5819','VERDE AGUA MENTA','','Activo'),('15-6120','VERDE AGUA MING','','Activo'),('15-6123','VERDE JADE CREMA','','Activo'),('15-6304','GRIS PUSSYWILLOW','','Activo'),('15-6307','GRIS AGATA','','Activo'),('15-6313','VERDE LAUREL','','Activo'),('15-6340','VERDE IRLANDES','','Activo'),('15-6410','GRIS MUSGO','','Activo'),('15-6414','VERDE RESEDA','','Activo'),('15-6423','VERDE BOSQUE SHADE','','Activo'),('15-6428','VERDE TE','','Activo'),('15-6432','VERDE SHAMROCK','','Activo'),('15-6437','VERDE CLARO PASTO','','Activo'),('15-6442','VERDE BROTE','','Activo'),('16-0000','GRIS PALOMA CLARO','','Activo'),('16-0110','GRIS DESIERTO SALVIA','','Activo'),('16-0123','VERDE ZARCILLO','','Activo'),('16-0205','VERDE KHAKI VINTAGE','','Activo'),('16-0213','VERDE MUSGO TE','','Activo'),('16-0220','VERDE MUERDAGO','','Activo'),('16-0224','VERDE EYES','','Activo'),('16-0228','VERDE JADE','','Activo'),('16-0230','VERDE GUACAMAYO','','Activo'),('16-0233','VERDE PRADO','','Activo'),('16-0235','VERDE KIWI','','Activo'),('16-0237','VERDE FOLLAJE','','Activo'),('16-0421','VERDE SALVIA','','Activo'),('16-0430','VERDE FERN','','Activo'),('16-0435','VERDE CITRON OSCURO','','Activo'),('16-0439','VERDE ESPINACA','','Activo'),('16-0518','VERDE GRISACEO','','Activo'),('16-0526','VERDE CEDRO','','Activo'),('16-0532','VERDE MUSGO','','Activo'),('16-0540','VERDE OASIS','','Activo'),('16-0632','VERDE SAUCE','','Activo'),('16-0639','AMARILLO OLIVA DORADO','','Activo'),('16-0713','BEIGE SLATE','','Activo'),('16-0730','BEIGE DORADO','','Activo'),('16-0737','AMARILLO ORO VIEJO','','Activo'),('16-0742','MOSTAZA AZUFRE','','Activo'),('16-0836','COBRE ORO','','Activo'),('16-0847','VERDE OLIVA ACEITE','','Activo'),('16-0906','MARRON PARDO SIMPLE','','Activo'),('16-0920','BEIGE CURDS','','Activo'),('16-0924','BEIGE CROISSANT','','Activo'),('16-0928','BEIGE CURRY','','Activo'),('16-0940','CAMEL CARAMELO','','Activo'),('16-0945','AMARILLO OROPEL','','Activo'),('16-0946','AMARILLO MIEL','','Activo'),('16-0947','AMARILLO DORADO','','Activo'),('16-0948','AMARILLO DORADO OSCURO','','Activo'),('16-0950','AMARILLO NARCISO','','Activo'),('16-0952','AMARILLO GOTA DE ORO','','Activo'),('16-0953','AMARILLO OLIVA TOSTADO','','Activo'),('16-0954','AMARILLO MADERA','','Activo'),('16-1010','BEIGE INCIENSO','','Activo'),('16-1054','AMARILLO GIRASOL','','Activo'),('16-1104','MARRON VAJILLA CLARO','','Activo'),('16-1105','BEIGE PLAZA TAUPE','','Activo'),('16-1106','MARRON TUFFET','','Activo'),('16-1108','BEIGE TWILL','','Activo'),('16-1109','BEIGE GREIGE','','Activo'),('16-1110','BEIGE OLIVA','','Activo'),('16-1118','BEIGE SPONGE','','Activo'),('16-1120','CAMEL STARFISH','','Activo'),('16-1126','BEIGE ANTILOPE','','Activo'),('16-1133','CAMEL MOSTAZA ORO','','Activo'),('16-1139','BEIGE AMBAR','','Activo'),('16-1140','NARANJA BATATA','','Activo'),('16-1142','NARANJA NUGGET','','Activo'),('16-1143','AMARILLO MIEL OSCURO','','Activo'),('16-1144','CAMEL ROBLE','','Activo'),('16-1149','NARANJA SOL DESIERTO','','Activo'),('16-1150','NARANJA TOPACIO','','Activo'),('16-1210','BEIGE LIGERO','','Activo'),('16-1212','BEIGE NOMADE','','Activo'),('16-1219','BEIGE TOSCANA','','Activo'),('16-1220','MARRON CAFÉ CREMA','','Activo'),('16-1221','BEIGE ROEBUCK','','Activo'),('16-1235','BEIGE ARENA TORMENTA','','Activo'),('16-1253','NARANJA OCRE','','Activo'),('16-1255','NARANJA RUSSET','','Activo'),('16-1257','NARANJA SOL','','Activo'),('16-1260','NARANJA CALABAZA','','Activo'),('16-1305','MARRON CLARO CUERDA','','Activo'),('16-1310','BEIGE NATURAL','','Activo'),('16-1315','MARRON CEREAL','','Activo'),('16-1317','BEIGE BRUSH','','Activo'),('16-1318','BEIGE PARDO WARM','','Activo'),('16-1320','BEIGE NOUGAT','','Activo'),('16-1324','BEIGE ALONDRA','','Activo'),('16-1326','BEIGE ARENA PRADERA','','Activo'),('16-1327','CAMEL NUEZ TOSTADA','','Activo'),('16-1328','BEIGE ARENA','','Activo'),('16-1329','CORAL HAZE','','Activo'),('16-1330','SALMON MUTED CLAY','','Activo'),('16-1331','BEIGE TOSTADO','','Activo'),('16-1333','CAMEL DOE','','Activo'),('16-1334','CAMEL TAN','','Activo'),('16-1336','BEIGE BISCUIT','','Activo'),('16-1337','NARANJA CORAL GOLD','','Activo'),('16-1342','MARRON SUEDE','','Activo'),('16-1344','NARANJA POLVOSA','','Activo'),('16-1346','OCRE DORADO','','Activo'),('16-1349','NARANJA CORAL','','Activo'),('16-1350','NARANJA AMBAR','','Activo'),('16-1356','NARANJA PERSIMMON','','Activo'),('16-1359','NARANJA PEEL','','Activo'),('16-1361','NARANJA ZANAHORIA','','Activo'),('16-1362','NARANJA BERMELLON','','Activo'),('16-1363','NARANJA PUFFINS BILL','','Activo'),('16-1364','NARANJA VIBRANTE','','Activo'),('16-1406','GRIS ATMOSFERA','','Activo'),('16-1407','BEIGE GUIJARRO OSCURO','','Activo'),('16-1412','MARRON STUCCO','','Activo'),('16-1414','MARRON CHANTERELLE','','Activo'),('16-1415','MARRON ALMONDINE','','Activo'),('16-1422','MARRON CORCHO','','Activo'),('16-1431','ROSA ARCILLA','','Activo'),('16-1434','CORAL ALMENDRA','','Activo'),('16-1439','NARANJA CARAMELO OSCURO','','Activo'),('16-1440','CORAL LANGOSTINO','','Activo'),('16-1441','NARANJA ARABESCO','','Activo'),('16-1443','NARANJA PULIDO','','Activo'),('16-1448','NARANJA QUEMADO','','Activo'),('16-1450','CORAL FLAMENCO','','Activo'),('16-1452','CORAL PETARDO','','Activo'),('16-1454','NARANJA JAFFA','','Activo'),('16-1459','NARANJA MANDARIN','','Activo'),('16-1462','NARANJA AMAPOLA','','Activo'),('16-1506','GRIS BARK','','Activo'),('16-1508','ROSA ADOBE','','Activo'),('16-1509','GRIS SOMBRAS','','Activo'),('16-1510','ROSA VIEJO PARDO','','Activo'),('16-1511','ROSA TAN','','Activo'),('16-1516','MARRON CAMEO','','Activo'),('16-1518','ROSA ROSETTE','','Activo'),('16-1520','ROSA LANGOSTA','','Activo'),('16-1522','ROSA DAWN','','Activo'),('16-1526','NARANJA TERRACOTA','','Activo'),('16-1529','CORAL QUEMADO','','Activo'),('16-1532','ROSA MANZANA SILVESTRE','','Activo'),('16-1539','CORAL','','Activo'),('16-1541','CORAL CAMELLIA','','Activo'),('16-1542','CORAL SALMON FRESH','','Activo'),('16-1543','CORAL FUSION','','Activo'),('16-1544','CORAL PERSIMMON','','Activo'),('16-1546','CORAL VIVO','','Activo'),('16-1610','ROSA APRICOT','','Activo'),('16-1617','ROSA BRILLO MALVA','','Activo'),('16-1620','ROSA TE','','Activo'),('16-1624','ROSA LANTANA','','Activo'),('16-1626','ROSA FLOR MELOCOTON','','Activo'),('16-1632','ROSA CORAL SHELL','','Activo'),('16-1640','ROSA CORAL SUGAR','','Activo'),('16-1641','CORAL GEORGIA','','Activo'),('16-1708','LILA LILAS','','Activo'),('16-1710','ROSA FOXGLOVE','','Activo'),('16-1712','LILA POLIGNAC','','Activo'),('16-1715','ROSA SALVAJE','','Activo'),('16-1720','FUCSIA FRESA','','Activo'),('16-1723','ROSA CONFETTI','','Activo'),('16-1731','ROSA FRESA','','Activo'),('16-1735','FUCSIA LIMONADA','','Activo'),('16-1806','ROSA WOODROSE','','Activo'),('16-2111','LILA ORQUIDEA MALVA','','Activo'),('16-2120','FUCSIA ORQUIDEA SALVAJE','','Activo'),('16-2124','ROSA CLAVEL','','Activo'),('16-2126','FUCSIA AZALEA','','Activo'),('16-2215','ROSA CASHMERE','','Activo'),('16-2614','LILA MALVA MOONITE','','Activo'),('16-3115','LILA AZAFRAN','','Activo'),('16-3118','FUCSIA CYCLAMEN','','Activo'),('16-3205','LILA MALVA SHADOWS','','Activo'),('16-3307','LILA LAVANDA MIST','','Activo'),('16-3320','LILA VIOLETA','','Activo'),('16-3416','VIOLETA TUL','','Activo'),('16-3520','VIOLETA AFRICA','','Activo'),('16-3521','LILA LUPINE','','Activo'),('16-3617','LILA PURO','','Activo'),('16-3801','GRIS OPALO','','Activo'),('16-3802','GRIS CENIZA','','Activo'),('16-3803','GRIS GAVIOTA','','Activo'),('16-3815','LILA VIOLA','','Activo'),('16-3817','LILA RAPSODIA','','Activo'),('16-3823','LILA TULIPA','','Activo'),('16-3850','GRIS PLATA SCONCE','','Activo'),('16-3907','GRIS DAPPLE','','Activo'),('16-3915','GRIS ALLOY','','Activo'),('16-3916','GRIS AGUANIEVE','','Activo'),('16-3920','LILA LAVANDA LUSTRE','','Activo'),('16-3922','LILA BRUNNERA','','Activo'),('16-3925','LILA EASTER','','Activo'),('16-3930','LILA CARDO','','Activo'),('16-4010','AZUL POLVORIENTO','','Activo'),('16-4013','AZUL ASHLEY','','Activo'),('16-4020','AZUL DELLA ROBBIA','','Activo'),('16-4021','AZUL ALLURE','','Activo'),('16-4032','AZUL PROVENCE','','Activo'),('16-4109','GRIS ARONA','','Activo'),('16-4120','CELESTE ANOCHECER','','Activo'),('16-4132','CELESTE NIÑO','','Activo'),('16-4134','AZUL BONNIE','','Activo'),('16-4400','GRIS PALOMA MOURNING','','Activo'),('16-4402','GRIS LLOVIZNA','','Activo'),('16-4408','GRIS PIZARRA','','Activo'),('16-4411','GRIS TOURMALINE','','Activo'),('16-4414','AZUL CAMEO','','Activo'),('16-4421','TURQUESA NIEBLA','','Activo'),('16-4427','TURQUESA HORIZONTE','','Activo'),('16-4519','CELESTE DELPHINIUM','','Activo'),('16-4525','AGUAMARINA MAUI','','Activo'),('16-4529','TURQUESA CYAN','','Activo'),('16-4530','TURQUESA ACUARIO','','Activo'),('16-4535','TURQUESA ATOLON','','Activo'),('16-4610','CELESTE AGUA QUIETA','','Activo'),('16-4612','CELESTE AGUA ARRECIFES','','Activo'),('16-4702','GRIS CALIZA','','Activo'),('16-4703','GRIS FANTASMA OSCURO','','Activo'),('16-4712','VERDE AGUA MINERAL','','Activo'),('16-4719','AGUAMARINA PORCELANA','','Activo'),('16-4725','TURQUESA AGUA BUCEO','','Activo'),('16-4728','TURQUESA PAVO REAL','','Activo'),('16-5101','GRIS HUMEDO','','Activo'),('16-5106','VERDE SURF','','Activo'),('16-5109','AGUAMARINA WASABI','','Activo'),('16-5112','VERDE CANTON','','Activo'),('16-5119','VERDE AZUL MAR','','Activo'),('16-5123','VERDE BALTICO','','Activo'),('16-5127','VERDE CERAMICA','','Activo'),('16-5304','VERDE JADEITE','','Activo'),('16-5418','AGUAMARINA LAGUNA','','Activo'),('16-5422','VERDE AGUAMARINA','','Activo'),('16-5431','VERDE PAVO REAL','','Activo'),('16-5515','VERDE BERILO','','Activo'),('16-5533','VERDE ARCADIA','','Activo'),('16-5803','GRIS PEDERNAL','','Activo'),('16-5806','GRIS MILIEU','','Activo'),('16-5807','GRIS LILY PAD','','Activo'),('16-5808','GRIS ICEBERG','','Activo'),('16-5815','VERDE AGUA FELDSPAR','','Activo'),('16-5820','VERDE SPRUCE','','Activo'),('16-5825','VERDE GUMDROP','','Activo'),('16-5904','GRIS IRON','','Activo'),('16-5907','VERDE AGUA GRANITO','','Activo'),('16-5919','VERDE MENTA CREMA','','Activo'),('16-5924','VERDE WINTER','','Activo'),('16-5932','VERDE HOLLY','','Activo'),('16-5938','VERDE MENTA','','Activo'),('16-5942','VERDE LABIA','','Activo'),('16-6008','GRIS SEAGRASS','','Activo'),('16-6127','VERDE BRIER','','Activo'),('16-6138','VERDE KELLY','','Activo'),('16-6216','VERDE ALBAHACA','','Activo'),('16-6240','VERDE ISLA','','Activo'),('16-6339','VERDE VIBRANTE','','Activo'),('16-6340','VERDE CLASICO','','Activo'),('16-6444','VERDE VENENO','','Activo'),('17-0000','GRIS ESCARCHADO','','Activo'),('17-0115','VERDE ACEITE','','Activo'),('17-0133','VERDE FLUORITE','','Activo'),('17-0145','VERDE LIMA ONLINE','','Activo'),('17-0207','GRIS ROCK RIDGE','','Activo'),('17-0230','VERDE BOSQUE','','Activo'),('17-0235','VERDE PICANTE','','Activo'),('17-0324','VERDE EPSOM','','Activo'),('17-0330','VERDE TORTUGA','','Activo'),('17-0336','VERDE PERIDOT','','Activo'),('17-0510','BEIGE SILVER SAGE','','Activo'),('17-0525','VERDE MOSSTONE','','Activo'),('17-0535','VERDE OLIVA CLARO','','Activo'),('17-0610','BEIGE ROBLE OAK','','Activo'),('17-0613','GRIS VETIVER','','Activo'),('17-0618','VERDE SIRENA','','Activo'),('17-0620','MARRON ALOE','','Activo'),('17-0627','VERDE SECO','','Activo'),('17-0808','MARRON GRIS PÁRDO','','Activo'),('17-0836','VERDE ACEITUNA','','Activo'),('17-0840','VERDE ALMIRANTE','','Activo'),('17-0843','AMARILLO BRONCE','','Activo'),('17-0929','CAMEL SEMILLAS','','Activo'),('17-0935','BEIGE ORO SECO','','Activo'),('17-1009','MARRON DUNA','','Activo'),('17-1019','BEIGE OLMO','','Activo'),('17-1022','CAMEL KELP','','Activo'),('17-1028','BEIGE BRONCE','','Activo'),('17-1036','MARRON BISTRE','','Activo'),('17-1038','MARRON OJO TIGRE','','Activo'),('17-1040','AMARILLO SPRUCE','','Activo'),('17-1044','MARRON ARDILLA','','Activo'),('17-1045','AMARILLO CANELA','','Activo'),('17-1046','NARANJA ROBLE ORO','','Activo'),('17-1047','AMARILLO MIEL MOSTAZA','','Activo'),('17-1048','AMARILLO INCA DORADO','','Activo'),('17-1109','BEIGE CHINCHILLA','','Activo'),('17-1113','VERDE CILANTRO','','Activo'),('17-1118','MARRON PLOMO','','Activo'),('17-1125','MARRON DIJON','','Activo'),('17-1128','MARRON HUESO','','Activo'),('17-1129','CAMEL MADERA','','Activo'),('17-1134','MARRON AZUCAR','','Activo'),('17-1137','MARRON ANACARDO','','Activo'),('17-1143','MARRON AVELLANA','','Activo'),('17-1212','GRIS HONGOS','','Activo'),('17-1223','CAMEL PRALINE','','Activo'),('17-1224','CAMEL','','Activo'),('17-1225','MARRON ABEDUL','','Activo'),('17-1230','MARRON MOCA MOUSSE','','Activo'),('17-1310','MARRON LOBO TIMBER','','Activo'),('17-1311','GRIS PARDO DESIERTO','','Activo'),('17-1312','MARRON MINK','','Activo'),('17-1316','BEIGE PORTABELLA','','Activo'),('17-1319','MARRON ANFORA','','Activo'),('17-1320','MARRON TANNIN','','Activo'),('17-1321','MARRON WOODSMOKE','','Activo'),('17-1322','BEIGE BURRO','','Activo'),('17-1327','MARRON TABACO','','Activo'),('17-1328','CAMEL INDIAN TAN','','Activo'),('17-1330','MARRON LEON','','Activo'),('17-1336','BEIGE SALVADO','','Activo'),('17-1340','MARRON ADOBE','','Activo'),('17-1349','NARANJA EXUBERANTE','','Activo'),('17-1350','NARANJA POPSICLE','','Activo'),('17-1353','NARANJA DAMASCO','','Activo'),('17-1360','NARANJA CELOSIA','','Activo'),('17-1410','MARRON PINO CORTEZA','','Activo'),('17-1417','MARRON CASTOR','','Activo'),('17-1422','MARRON RAW UMDER','','Activo'),('17-1444','NARANJA JENGIBRE','','Activo'),('17-1446','MARRON MANGO','','Activo'),('17-1449','NARANJA CALABAZA PUREED','','Activo'),('17-1452','NARANJA KOI','','Activo'),('17-1456','CORAL TIGERLILY','','Activo'),('17-1461','NARANJA','','Activo'),('17-1462','NARANJA FLAMA','','Activo'),('17-1464','ROJO NARANJA','','Activo'),('17-1500','GRIS AGUJA','','Activo'),('17-1501','GRIS PALOMA SALVAJE','','Activo'),('17-1502','GRIS NUBARRON','','Activo'),('17-1505','LILA CODORNIZ','','Activo'),('17-1506','GRIS CINDER','','Activo'),('17-1510','LILA MOGOTE','','Activo'),('17-1512','ROSA NOSTALGIA','','Activo'),('17-1514','ROSA CENIZA','','Activo'),('17-1518','ROSA VIEJO','','Activo'),('17-1520','ROSA CANYON','','Activo'),('17-1522','LILA MALVA MADERA','','Activo'),('17-1525','ROSA MADERA CEDRO','','Activo'),('17-1532','MARRON ARAGON','','Activo'),('17-1537','ROJO MINERAL','','Activo'),('17-1544','CORAL SIENNA','','Activo'),('17-1545','ROJO ARANDANO','','Activo'),('17-1547','CORAL GLOW','','Activo'),('17-1553','ROJO PAPRIKA','','Activo'),('17-1558','CORAL GRANADINA','','Activo'),('17-1562','ROJO MANDARIN','','Activo'),('17-1563','NARANJA TOMATE','','Activo'),('17-1564','CORAL FIESTA','','Activo'),('17-1605','LILA ELDERBERRY','','Activo'),('17-1608','LILA ROSA HEATHER','','Activo'),('17-1609','LILA ROSA MESA','','Activo'),('17-1610','LILA ORQUIDEA DUSKY','','Activo'),('17-1612','LILA MALVA','','Activo'),('17-1623','ROSA VINO','','Activo'),('17-1633','MAGENTA HOLLY','','Activo'),('17-1635','CORAL ROSA SHARON','','Activo'),('17-1641','ROSA CRISANTEMO','','Activo'),('17-1643','ROSA PORCELANA','','Activo'),('17-1644','CORAL PICADO','','Activo'),('17-1647','FUCSIA DUBARRY','','Activo'),('17-1654','CORAL POINSETTIA','','Activo'),('17-1663','CORAL AGRIDULCE','','Activo'),('17-1664','ROJO POPPY','','Activo'),('17-1710','LILA BORDEAUX','','Activo'),('17-1718','LILA ANTIGUO','','Activo'),('17-1723','LILA MALAGA','','Activo'),('17-1736','ROSA CORAL SUNKIST','','Activo'),('17-1744','CORAL CALYPSO','','Activo'),('17-1753','CORAL GERANIO','','Activo'),('17-1755','FUCSIA PARAISO','','Activo'),('17-1818','VIOLETA ROJIZO','','Activo'),('17-1831','MAGENTA CARMIN','','Activo'),('17-1842','MAGENTA AZALEA','','Activo'),('17-1927','ROSA DESIERTO','','Activo'),('17-1928','ROSA CHICLE','','Activo'),('17-1929','ROSA RAPTURE','','Activo'),('17-1930','ROSA CAMELLIA','','Activo'),('17-1937','ROSA HOT','','Activo'),('17-2031','FUCSIA ROSE','','Activo'),('17-2033','ROSA FANDANGO','','Activo'),('17-2036','MAGENTA','','Activo'),('17-2120','ROSA CASTILLO','','Activo'),('17-2127','ROSA SHOCKING','','Activo'),('17-2227','LILA ROSA','','Activo'),('17-2230','ROSA CARMIN','','Activo'),('17-2520','ROSA IBIS','','Activo'),('17-2601','GRIS ZINC','','Activo'),('17-2617','VIOLETA DALIA MALVA','','Activo'),('17-2624','MAGENTA VIOLETA','','Activo'),('17-2625','FUCSIA SUPER','','Activo'),('17-2627','FUCSIA PHLOX','','Activo'),('17-3014','LILA MORA CLARO','','Activo'),('17-3020','LILA COCO SPRING','','Activo'),('17-3023','LILA CAPULLO','','Activo'),('17-3313','LILA LAVANDA ANTIGUA','','Activo'),('17-3323','VIOLETA ORQUIDEA CLARO','','Activo'),('17-3410','LILA VALERIANA','','Activo'),('17-3615','VIOLETA TIZA','','Activo'),('17-3617','LAVANDA INGLES','','Activo'),('17-3619','VIOLETA JACINTO','','Activo'),('17-3628','VIOLETA ORQUIDEA','','Activo'),('17-3725','LILA BOUGA','','Activo'),('17-3730','LILA CACHEMIR','','Activo'),('17-3808','LILA NIRVANA','','Activo'),('17-3817','LILA DAYBREAK','','Activo'),('17-3826','PURPURA ASTER','','Activo'),('17-3834','PURPURA DALIA','','Activo'),('17-3906','GRIS MINIMAL','','Activo'),('17-3910','LILA LAVANDA GRAY','','Activo'),('17-3911','GRIS PLATA FILIGREE','','Activo'),('17-3917','LILA STONEWASH','','Activo'),('17-3918','AZUL COUNTRY','','Activo'),('17-3919','LILA IMPRESSION','','Activo'),('17-3922','LILA HIELO','','Activo'),('17-3923','AZUL COLONIA','','Activo'),('17-3924','VIOLETA LAVANDA','','Activo'),('17-3925','LILA PERSA','','Activo'),('17-3930','LILA JACARANDA','','Activo'),('17-3932','LILA BIGARO OSCURO','','Activo'),('17-3934','LILA JOYA PERSA','','Activo'),('17-3936','AZUL BONNET','','Activo'),('17-4014','GRIS TITANIO','','Activo'),('17-4020','AZUL SOMBRA','','Activo'),('17-4021','CELESTE FADED DENIM','','Activo'),('17-4023','AZUL CIELO OSCURO','','Activo'),('17-4027','AZUL RIVIERA','','Activo'),('17-4030','AZUL LAGO SILVER','','Activo'),('17-4037','CELESTE ULTRAMARINO','','Activo'),('17-4041','CELESTE MARINA','','Activo'),('17-4111','AZUL CITADEL','','Activo'),('17-4131','AZUL CENIZA OSCURO','','Activo'),('17-4139','AZUL AZURE','','Activo'),('17-4247','AZUL DIVA','','Activo'),('17-4320','AZUL ADRIATICO','','Activo'),('17-4328','AZUL LUNA','','Activo'),('17-4336','TURQUESA BLITHE','','Activo'),('17-4402','GRIS NEUTRO','','Activo'),('17-4405','GRIS MONUMENTO','','Activo'),('17-4408','GRIS PLOMO','','Activo'),('17-4421','AZUL ESPUELA','','Activo'),('17-4427','TURQUESA URRACA','','Activo'),('17-4432','AZUL VIVID','','Activo'),('17-4433','TURQUESA DRESDEN','','Activo'),('17-4435','AZUL MALIBU','','Activo'),('17-4440','AZUL DANUBIO','','Activo'),('17-4540','TURQUESA HAWAIIAN','','Activo'),('17-4716','AZUL TORMENTA','','Activo'),('17-4724','AGUAMARINA PAGODA','','Activo'),('17-4728','TURQUESA ALGERIA','','Activo'),('17-4730','TURQUESA BAHIA','','Activo'),('17-4735','TURQUESA CAPRI BRISA','','Activo'),('17-4818','VERDE AGUA BRISTOL','','Activo'),('17-4911','VERDE ARTICO','','Activo'),('17-4928','AGUAMARINA LAKE','','Activo'),('17-5024','AGUAMARINA TEAL','','Activo'),('17-5025','AGUAMARINA NAVIGATE','','Activo'),('17-5034','AGUAMARINA LAPIS','','Activo'),('17-5102','GRIS GRIFFIN','','Activo'),('17-5117','AGUAMARINA SLATE','','Activo'),('17-5122','AGUAMARINA BAY','','Activo'),('17-5126','AGUAMARINA VIRIDIAN','','Activo'),('17-5130','VERDE AGUA COLUMBIA','','Activo'),('17-5330','VERDE DINASTIA','','Activo'),('17-5421','VERDE PORCELANA','','Activo'),('17-5430','VERDE ALHAMBRA','','Activo'),('17-5513','VERDE AGUA OSCURO','','Activo'),('17-5528','VERDE LAGO','','Activo'),('17-5633','VERDE ESMERALDA PROFUNDO','','Activo'),('17-5641','VERDE ESMERALDA','','Activo'),('17-5734','VERDE VIRIDIS','','Activo'),('17-5735','VERDE PERICO','','Activo'),('17-5923','VERDE PINO','','Activo'),('17-5936','VERDE SIMPLE','','Activo'),('17-6009','VERDE CORONA LAUREL','','Activo'),('17-6030','VERDE FRIJOL','','Activo'),('17-6153','VERDE HELECHO','','Activo'),('17-6206','GRIS SHADOW','','Activo'),('17-6212','GRIS VERDE SPRAY','','Activo'),('17-6229','VERDE MEDIO','','Activo'),('17-6323','VERDE HEDGE','','Activo'),('18-0000','GRIS PERLA OSCURO','','Activo'),('18-0117','VERDE VIÑEDOS','','Activo'),('18-0119','VERDE RAMA','','Activo'),('18-0125','VERDE ALCACHOFA','','Activo'),('18-0130','VERDE CACTUS','','Activo'),('18-0201','GRIS CASTLEROCK','','Activo'),('18-0228','VERDE PESTO','','Activo'),('18-0306','GRIS GUNMETAL','','Activo'),('18-0312','VERDE LICHEN','','Activo'),('18-0316','VERDE OLIVINE','','Activo'),('18-0317','VERDE BRONCE','','Activo'),('18-0322','VERDE CIPRES','','Activo'),('18-0324','VERDE CALLISTE','','Activo'),('18-0328','VERDE CEDRO OSCURO','','Activo'),('18-0332','VERDE SALTAMONTES','','Activo'),('18-0403','GRIS GAVIOTA OSCURO','','Activo'),('18-0420','VERDE TREBOL','','Activo'),('18-0422','VERDE LODEN','','Activo'),('18-0426','VERDE OLIVA CAPULETO','','Activo'),('18-0430','VERDE AGUACATE','','Activo'),('18-0435','VERDE CALA','','Activo'),('18-0503','GRIS GARGOLA','','Activo'),('18-0513','GRIS CUERDA','','Activo'),('18-0515','VERDE OLIVA ANTIGUO','','Activo'),('18-0521','VERDE OLIVA QUEMADO','','Activo'),('18-0523','VERDE MUSGO INVIERNO','','Activo'),('18-0525','VERDE IGUANA','','Activo'),('18-0527','VERDE RAMA OLIVA','','Activo'),('18-0538','VERDE MADRESELVA','','Activo'),('18-0601','GRIS CARBON','','Activo'),('18-0617','BEIGE COVERT','','Activo'),('18-0622','VERDE OLIVA','','Activo'),('18-0627','VERDE ABETO','','Activo'),('18-0629','VERDE LAGARTIJA','','Activo'),('18-0724','MARRON OLIVA GOTICO','','Activo'),('18-0820','MARRON ALCAPARRAS','','Activo'),('18-0825','VERDE NUTRIA','','Activo'),('18-0830','MARRON BUTTERNUT','','Activo'),('18-0835','VERDE TABACO SECO','','Activo'),('18-0920','MARRON CANGURO','','Activo'),('18-0928','MARRON SEPIA','','Activo'),('18-0930','MARRON LICOR CAFÉ','','Activo'),('18-0933','MARRON RUBBER','','Activo'),('18-0937','MARRON BRONCE','','Activo'),('18-0939','MARRON COMINO','','Activo'),('18-0950','MARRON CATHAY','','Activo'),('18-1015','MARRON SHITAKE','','Activo'),('18-1016','MARRON CUB','','Activo'),('18-1017','MARRON CARIBOU','','Activo'),('18-1018','MARRON NUTRIA','','Activo'),('18-1022','MARRON ARMIÑO','','Activo'),('18-1027','MARRON BISON','','Activo'),('18-1029','MARRON COCO TOSTADO','','Activo'),('18-1030','MARRON TRUSH','','Activo'),('18-1031','MARRON CARAMELO','','Activo'),('18-1033','MARRON DACHSHUND','','Activo'),('18-1048','MARRON MONJE','','Activo'),('18-1108','MARRON FALLEN','','Activo'),('18-1110','BEIGE BRINDLE','','Activo'),('18-1112','MARRON NUEZ','','Activo'),('18-1124','MARRON PERDIZ','','Activo'),('18-1130','MARRON AZTECA','','Activo'),('18-1137','MARRON CUERO CRUDO','','Activo'),('18-1140','MARRON MOCHA BISQUE','','Activo'),('18-1142','MARRON CUERO','','Activo'),('18-1148','MARRON CAFÉ CARAMELO','','Activo'),('18-1154','MARRON JENGIBRE GLAZED','','Activo'),('18-1160','MARRON SUDAN','','Activo'),('18-1210','GRIS DRIFTWOOD','','Activo'),('18-1222','MARRON COCOA','','Activo'),('18-1229','MARRON ALGARROBO','','Activo'),('18-1230','MARRON COCONUT SHELL','','Activo'),('18-1235','MARRON RUSSET','','Activo'),('18-1238','MARRON RUSTICO','','Activo'),('18-1239','MARRON SIERRA','','Activo'),('18-1244','MARRON JENGIBRE','','Activo'),('18-1246','MARRON OCRE OSCURO','','Activo'),('18-1248','NARANJA RUST','','Activo'),('18-1304','MARRON FALCON','','Activo'),('18-1306','GRIS HIERRO','','Activo'),('18-1312','MARRON PARDO OSCURO','','Activo'),('18-1314','MARRON BELLOTA','','Activo'),('18-1321','MARRON BROWNIE','','Activo'),('18-1326','MARRON NUEZ MOSCADA','','Activo'),('18-1340','MARRON ARCILLA','','Activo'),('18-1343','MARRON CASTAÑO','','Activo'),('18-1345','NARANJA CANELA RAMA','','Activo'),('18-1350','NARANJA LADRILLO QUEMADO','','Activo'),('18-1354','NARANJA OCRE QUEMADO','','Activo'),('18-1355','NARANJA ROOIBOS','','Activo'),('18-1404','LILA GORRION','','Activo'),('18-1415','MARRON','','Activo'),('18-1421','MARRON COGNAC','','Activo'),('18-1435','ROSA MARCHITA','','Activo'),('18-1436','CAOBA CLARA','','Activo'),('18-1444','ROJO TANDORI SPICE','','Activo'),('18-1445','NARANJA PICANTE','','Activo'),('18-1447','NARANJA OXIDO','','Activo'),('18-1449','ROJO KETCHUP','','Activo'),('18-1450','NARANJA MECCA','','Activo'),('18-1451','MARRON OTOÑO','','Activo'),('18-1454','ROJO ARCILLA','','Activo'),('18-1531','ROJO GRANERO','','Activo'),('18-1536','MARRON HOTSAUCE','','Activo'),('18-1540','BORDO CINNABAR','','Activo'),('18-1547','MARRON BOSSA NOVA','','Activo'),('18-1550','ROJO AURORA','','Activo'),('18-1555','ROJO LAVA MOLTEN','','Activo'),('18-1561','ROJO NARANJA COM','','Activo'),('18-1564','NARANJA POINCIANA','','Activo'),('18-1612','ROSA PARDO','','Activo'),('18-1616','ROJO RUANO','','Activo'),('18-1619','GRANATE','','Activo'),('18-1629','ROSA FADED','','Activo'),('18-1631','ROJO TIERRA','','Activo'),('18-1634','ROSA BARROCO','','Activo'),('18-1635','ROSA SLATE','','Activo'),('18-1643','BORDO CARDINAL','','Activo'),('18-1648','MARRON MANZANA BAKED','','Activo'),('18-1649','CORAL OSCURO','','Activo'),('18-1651','CORAL PIMENTON','','Activo'),('18-1655','ROJO MARTE','','Activo'),('18-1657','ROJO SALSA','','Activo'),('18-1658','ROJO POMPEYA','','Activo'),('18-1660','ROJO TOMATO','','Activo'),('18-1661','ROJO TOMATE PURE','','Activo'),('18-1662','ROJO FLAME ESCARLATA','','Activo'),('18-1663','ROJO CHINO','','Activo'),('18-1664','ROJO FIERY','','Activo'),('18-1703','GRIS TIBURON','','Activo'),('18-1709','LILA TULIPWOOD','','Activo'),('18-1710','LILA NECTAR','','Activo'),('18-1720','VIOLETA QUARZO','','Activo'),('18-1725','BORDO SECA','','Activo'),('18-1741','MAGENTA VINO FRESA','','Activo'),('18-1754','FUCSIA RASPBERRY','','Activo'),('18-1755','FUCSIA ROUGE','','Activo'),('18-1756','FUCSIA TEABERRY','','Activo'),('18-1760','MAGENTA BARBERRY','','Activo'),('18-1761','ROJO SKI PATROL','','Activo'),('18-1762','ROJO HIBISCUS','','Activo'),('18-1763','ROJO HIGH RISK','','Activo'),('18-1764','ROJO LOLLIPOP','','Activo'),('18-1807','LILA MALVA CREPUSCULO','','Activo'),('18-1852','ROJO ROSA','','Activo'),('18-1856','MAGENTA VIRTUAL','','Activo'),('18-1945','ROSA BRILLANTE','','Activo'),('18-1950','FUCSIA JAZZY','','Activo'),('18-2027','BORDO BEAUJOLAIS','','Activo'),('18-2043','MAGENTA SORBETE','','Activo'),('18-2109','LILA UVA SHAKE','','Activo'),('18-2120','FUCSIA HONEY','','Activo'),('18-2133','FUCSIA FLAMBE','','Activo'),('18-2140','FUCSIA CABARET','','Activo'),('18-2143','FUCSIA REMOLACHA','','Activo'),('18-2320','VIOLETA CLOVER','','Activo'),('18-2326','MAGENTA FLOR CACTUS','','Activo'),('18-2328','FUCSIA RED','','Activo'),('18-2333','FUCSIA ROSA FRAMBUESA','','Activo'),('18-2336','FUCSIA BERRY','','Activo'),('18-2436','FUCSIA OSCURO','','Activo'),('18-2525','MAGENTA HAZE','','Activo'),('18-2527','VIOLETA CARMIN','','Activo'),('18-2929','PURPURA VINO','','Activo'),('18-3011','PURPURA ARGYLE','','Activo'),('18-3013','LILA BERRY','','Activo'),('18-3015','VIOLETA AMATISTA','','Activo'),('18-3022','LILA ORQUIDEA OSCURO','','Activo'),('18-3027','VIOLETA PURPURA ORQUIDEA','','Activo'),('18-3211','LILA GRAPA','','Activo'),('18-3220','LILA VERY GRAPE','','Activo'),('18-3224','LILA RADIANTE ORQUIDEA','','Activo'),('18-3230','LILA MALVA PRADO','','Activo'),('18-3324','VIOLETA DALIA','','Activo'),('18-3331','VIOLETA JACINTO OSCURO','','Activo'),('18-3339','VIOLETA VIOLA VIVID','','Activo'),('18-3410','LILA VIOLETA VINTAGE','','Activo'),('18-3415','VIOLETA UVA MERMELADA','','Activo'),('18-3418','VIOLETA CHINO','','Activo'),('18-3518','VIOLETA PURPURA','','Activo'),('18-3522','LILA UVA CRUSHED','','Activo'),('18-3531','VIOLETA LILAC ROYAL','','Activo'),('18-3533','VIOLETA BAYA','','Activo'),('18-3615','VIOLETA IMPERIAL','','Activo'),('18-3620','VIOLETA MISTICO','','Activo'),('18-3628','LILA CAMPANILLAS','','Activo'),('18-3633','LILA LAVANDA PROFUNDO','','Activo'),('18-3635','VIOLETA PICASSO','','Activo'),('18-3710','LILA GRISACEO','','Activo'),('18-3714','LILA UVA PICADA','','Activo'),('18-3715','LILA UVA MONTANA','','Activo'),('18-3718','LILA NEBLINA','','Activo'),('18-3737','VIOLETA FLOR PASION','','Activo'),('18-3817','LILA GAVIOTA','','Activo'),('18-3833','VIOLETA DUSTED PERI','','Activo'),('18-3834','LILA VERONICA','','Activo'),('18-3838','VIOLETA ULTRA','','Activo'),('18-3905','GRIS EXCALIBUR','','Activo'),('18-3907','GRIS TORNADO','','Activo'),('18-3912','GRIS GRISAILLE','','Activo'),('18-3918','GRIS CHINA','','Activo'),('18-3920','AZUL COSTAL','','Activo'),('18-3921','AZUL BIJOU','','Activo'),('18-3927','LILA VELVET MADRUGADA','','Activo'),('18-3928','AZUL HOLANDES','','Activo'),('18-3930','LILA DENIM','','Activo'),('18-3932','VIOLETA MARLIN','','Activo'),('18-3933','LILA GRANITO','','Activo'),('18-3935','LILA WEDGEWOOD','','Activo'),('18-3937','AZUL YONDER','','Activo'),('18-3943','AZUL IRIS','','Activo'),('18-3944','LILA VIOLETA TORMENTA','','Activo'),('18-3945','AZUL AMPARO','','Activo'),('18-3946','AZUL BAJA','','Activo'),('18-3949','AZUL DESLUMBRANTE','','Activo'),('18-3963','AZUL ESPECTRO','','Activo'),('18-4005','GRIS METAL OSCURO','','Activo'),('18-4006','GRIS SOMBRA QUIETA','','Activo'),('18-4016','GRIS DECEMBER','','Activo'),('18-4018','AZUL REAL TEAL','','Activo'),('18-4023','AZUL CENIZA','','Activo'),('18-4025','AZUL COPEN','','Activo'),('18-4026','AZUL ESTELAR','','Activo'),('18-4027','AZUL MOONLIGHT','','Activo'),('18-4028','AZUL OCEANO','','Activo'),('18-4029','AZUL FEDERAL','','Activo'),('18-4032','AZUL AGUA PROFUNDO','','Activo'),('18-4034','AZUL VALLARTA','','Activo'),('18-4039','AZUL REGATTA','','Activo'),('18-4041','AZUL SAFIRO STAR','','Activo'),('18-4043','AZUL PALACIO','','Activo'),('18-4045','AZUL DAFNE','','Activo'),('18-4051','AZUL FUERTE','','Activo'),('18-4105','GRIS NIEBLA LUNA','','Activo'),('18-4140','AZUL FRANCES','','Activo'),('18-4141','AZUL CAMPANULA','','Activo'),('18-4148','AZUL VICTORIA','','Activo'),('18-4215','AZUL ILUSION','','Activo'),('18-4220','AZUL PROVINCIAL','','Activo'),('18-4222','AZUL ACERO','','Activo'),('18-4225','AZUL SAJONIA','','Activo'),('18-4231','AZUL ZAFIRO','','Activo'),('18-4232','VERDE AGUA LOZA','','Activo'),('18-4244','AZUL DIRECTORIO','','Activo'),('18-4247','AZUL BRILLANTE','','Activo'),('18-4252','AZUL ASTER','','Activo'),('18-4320','AZUL EGEO','','Activo'),('18-4330','TURQUESA SUIZA','','Activo'),('18-4334','AZUL MEDITERRANEO','','Activo'),('18-4417','AZUL TAPIZ','','Activo'),('18-4432','AZUL TURCO','','Activo'),('18-4434','AZUL MYKONOS','','Activo'),('18-4440','AZUL CLOISONNE','','Activo'),('18-4510','GRIS SOLDADO','','Activo'),('18-4522','TURQUESA COLONIAL','','Activo'),('18-4528','AZUL MOSAICO','','Activo'),('18-4537','AZUL METILO','','Activo'),('18-4612','VERDE ATLANTICO NORTE','','Activo'),('18-4718','AGUAMARINA HYDRO','','Activo'),('18-4726','TURQUESA BISCAY','','Activo'),('18-4728','AGUAMARINA HARBOR','','Activo'),('18-4733','TURQUESA ENAMEL','','Activo'),('18-4735','AGUAMARINA AZULEJO','','Activo'),('18-4834','VERDE PROFUNDO','','Activo'),('18-4930','AGUAMARINA TROPICAL','','Activo'),('18-4936','VERDE AGUA FANFARE','','Activo'),('18-5020','AGUAMARINA PARASAILING','','Activo'),('18-5102','GRIS NIQUEL','','Activo'),('18-5105','GRIS SEDONA','','Activo'),('18-5115','VERDE OCEANO NORTE','','Activo'),('18-5121','VERDE PANTANO','','Activo'),('18-5128','VERDE HIERBA','','Activo'),('18-5203','GRIS PELTRE','','Activo'),('18-5210','LILA EIFFEL','','Activo'),('18-5315','VERDE BAYBERRY','','Activo'),('18-5322','VERDE ALPINO','','Activo'),('18-5338','VERDE','','Activo'),('18-5424','VERDE CADMIUM','','Activo'),('18-5606','VERDE BALSAMO','','Activo'),('18-5610','VERDE AGUA BRITTANY','','Activo'),('18-5612','VERDE ARTEMISA','','Activo'),('18-5616','VERDE RAMILLETE','','Activo'),('18-5619','AGUAMARINA TIDEPOOL','','Activo'),('18-5620','VERDE HIEDRA','','Activo'),('18-5622','VERDE ESCARCHADO','','Activo'),('18-5624','VERDE SHADY','','Activo'),('18-5633','VERDE BOSFORO','','Activo'),('18-5642','VERDE GOLF','','Activo'),('18-5725','VERDE GALAPAGOS','','Activo'),('18-5806','VERDE AGAVE','','Activo'),('18-5841','VERDE PIMIENTA','','Activo'),('18-6018','VERDE FOLLAJE OSCURO','','Activo'),('18-6022','VERDE DUENDE','','Activo'),('18-6024','VERDE AMAZONAS','','Activo'),('18-6030','VERDE JOLLY','','Activo'),('18-6114','VERDE MIRTO','','Activo'),('18-6320','VERDE FAIRWAY','','Activo'),('18-6330','VERDE JUNIPER','','Activo'),('19-0000','GRIS CUERVO','','Activo'),('19-0201','GRIS ASFALTO','','Activo'),('19-0230','VERDE JARDIN','','Activo'),('19-0303','NEGRO AZABACHE','','Activo'),('19-0307','VERDE HIEDRA GRIS','','Activo'),('19-0309','VERDE TOMILLO','','Activo'),('19-0312','VERDE ESCARABAJO','','Activo'),('19-0315','VERDE BOSQUE OSCURO','','Activo'),('19-0323','VERDE CHIVE','','Activo'),('19-0405','GRIS BELUGA','','Activo'),('19-0414','MARRON BOSQUE NOCHE','','Activo'),('19-0415','VERDE DUFFEL BAG','','Activo'),('19-0417','VERDE KOMBU','','Activo'),('19-0419','VERDE RIFLE','','Activo'),('19-0506','NEGRO TINTA','','Activo'),('19-0508','GRIS PEAT','','Activo'),('19-0509','VERDE RESINA','','Activo'),('19-0511','VERDE HOJA UVA','','Activo'),('19-0512','MARRON HIEDRA','','Activo'),('19-0515','VERDE OLIVA OSCURO','','Activo'),('19-0516','VERDE OLIVA MARRON','','Activo'),('19-0614','MARRON WREN','','Activo'),('19-0617','MARRON TECA','','Activo'),('19-0618','MARRON BEECH','','Activo'),('19-0622','VERDE OLIVA MILITAR','','Activo'),('19-0712','MARRON DEMITASSE','','Activo'),('19-0808','MARRON MOREL','','Activo'),('19-0809','CHOCOLATE CHIP','','Activo'),('19-0810','MARRON MAJOR','','Activo'),('19-0812','MARRON CAFE TURCO','','Activo'),('19-0814','MARRON SLATE BLACK','','Activo'),('19-0815','MARRON PALMERA DESIERTO','','Activo'),('19-0820','MARRON CANTINA','','Activo'),('19-0822','MARRON TARMAC','','Activo'),('19-0840','MARRON DELICIOSO OSCURO','','Activo'),('19-0910','MARRON MULCH','','Activo'),('19-0915','MARRON CAFÉ','','Activo'),('19-0916','MARRON RAIN DRUM','','Activo'),('19-1012','MARRON TOSTADO','','Activo'),('19-1015','MARRON BRACKEN','','Activo'),('19-1016','MARRON JAVA','','Activo'),('19-1018','MARRON CHOCOLATE OSCURO','','Activo'),('19-1020','MARRON TIERRA OSCURO','','Activo'),('19-1034','MARRON BREEN','','Activo'),('19-1101','MARRON ANOCHECER','','Activo'),('19-1102','MARRON LICOIRE','','Activo'),('19-1103','MARRON ESPRESSO','','Activo'),('19-1106','MARRON MOLE','','Activo'),('19-1111','MARRON CAFÉ OSCURO','','Activo'),('19-1116','MARRON CARAFE','','Activo'),('19-1118','MARRON CASTAÑA','','Activo'),('19-1121','MARRON PINECONE','','Activo'),('19-1213','MARRON SHOPPING','','Activo'),('19-1214','CHOCOLATE LAB','','Activo'),('19-1217','MARRON MUSTANG','','Activo'),('19-1218','MARRON MACETA','','Activo'),('19-1220','MARRON CAPUCCINO','','Activo'),('19-1228','MARRON CERVEZA RAIZ','','Activo'),('19-1230','MARRON FRAILE','','Activo'),('19-1235','MARRON BRUNETTE','','Activo'),('19-1241','MARRON SHELL','','Activo'),('19-1245','MARRON ARABIA','','Activo'),('19-1250','MARRON PICANTE','','Activo'),('19-1314','MARRON SEAL','','Activo'),('19-1317','MARRON CHOCOLATE AMARGO','','Activo'),('19-1320','MARRON SABLE','','Activo'),('19-1321','MARRON RON PASAS','','Activo'),('19-1322','MARRON PARDO','','Activo'),('19-1327','BORDO ANDORRA','','Activo'),('19-1331','MARRON RAIZ MADDER','','Activo'),('19-1333','MARRON SECOYA','','Activo'),('19-1334','MARRON HENNA OSCURO','','Activo'),('19-1338','MARRON RUSSET BROWN','','Activo'),('19-1420','MARRON CAOBA OSCURO','','Activo'),('19-1431','MARRON CHOCOLATE HELADO','','Activo'),('19-1436','MARRON CANELA','','Activo'),('19-1518','MARRON ROJIZO','','Activo'),('19-1522','BORDO ZINFANDEL','','Activo'),('19-1524','BORDO GUINDA','','Activo'),('19-1526','MARRON TRUFA','','Activo'),('19-1528','BORDO VINO WINDSOR','','Activo'),('19-1530','BORDO RUSSET','','Activo'),('19-1531','BORDO TOMATE SECO','','Activo'),('19-1532','BORDO PALO ROSA','','Activo'),('19-1533','BORDO CUERO','','Activo'),('19-1535','BORDO SYRAH','','Activo'),('19-1540','BORDO HENNA','','Activo'),('19-1543','BORDO BRICK','','Activo'),('19-1555','BORDO DAHLIA','','Activo'),('19-1557','ROJO PEPPER','','Activo'),('19-1559','BORDO SCARLATA','','Activo'),('19-1606','PURPURA RAISIN','','Activo'),('19-1608','PURPURA PRUNE OSCURO','','Activo'),('19-1617','BORDO BORGOÑA','','Activo'),('19-1619','MARRON FUDGE','','Activo'),('19-1620','LILA ARANDANO','','Activo'),('19-1621','LILA UVA CATAWBA','','Activo'),('19-1625','BORDO DECADENTE','','Activo'),('19-1627','BORDO PUERTO ROYALE','','Activo'),('19-1629','BORDO VINO RUBY','','Activo'),('19-1650','ROJO VIKINGO','','Activo'),('19-1652','BORDO RUIBARBO','','Activo'),('19-1655','BORDO GRANATE','','Activo'),('19-1656','ROJO RIO','','Activo'),('19-1662','ROJO SAMBA','','Activo'),('19-1663','ROJO RIBBON','','Activo'),('19-1664','ROJO VERDADERO','','Activo'),('19-1718','PURPURA FIG','','Activo'),('19-1724','ROJO CABERNET','','Activo'),('19-1725','BORDO PUERTO TAWNY','','Activo'),('19-1726','BORDO CORDOBES','','Activo'),('19-1757','ROJO BARBADOS','','Activo'),('19-1758','ROJO HAUTE','','Activo'),('19-1759','ROJO AMERICAN BEAUTY','','Activo'),('19-1760','ROJO SCARLATA','','Activo'),('19-1761','ROJO TANGO','','Activo'),('19-1762','ROJO CARMESI','','Activo'),('19-1763','ROJO FORMULA UNO','','Activo'),('19-1764','ROJO LABIAL','','Activo'),('19-1840','ROJO PROFUNDO CLARET','','Activo'),('19-1850','ROJO BUD','','Activo'),('19-1860','BORDO PERSA','','Activo'),('19-1862','ROJO BUFON','','Activo'),('19-1863','BORDO SCOOTER','','Activo'),('19-1930','BORDO GRANADA','','Activo'),('19-1934','BORDO TIBETANO','','Activo'),('19-1940','BORDO RUMBA','','Activo'),('19-1955','FUCSIA CEREZA','','Activo'),('19-2014','PURPURA PRUNE','','Activo'),('19-2024','BORDO RODODENDRO','','Activo'),('19-2025','BORDO PLUM','','Activo'),('19-2030','ROJO REMOLACHA','','Activo'),('19-2033','BORDO ANEMONA','','Activo'),('19-2041','FUCSIA CEREZA JUBILEE','','Activo'),('19-2045','MAGENTA VIVO','','Activo'),('19-2047','MAGENTA SANGRIA','','Activo'),('19-2118','VIOLETA VINO','','Activo'),('19-2311','LILA BERENJENA','','Activo'),('19-2312','VIOLETA CRUSHED','','Activo'),('19-2315','BORDO UVA VINO','','Activo'),('19-2410','VIOLETA AMARANTO','','Activo'),('19-2428','PURPURA','','Activo'),('19-2430','PURPURA POCION','','Activo'),('19-2431','MAGENTA BOYSENBERRY','','Activo'),('19-2432','MAGENTA FRAMBUESA','','Activo'),('19-2434','MAGENTA FESTIVAL','','Activo'),('19-2514','VIOLETA CIRUELA ITALIA','','Activo'),('19-2520','PURPURA POTENTE','','Activo'),('19-2524','PURPURA OSCURO','','Activo'),('19-2630','VIOLETA SALVAJE ASTER','','Activo'),('19-2814','LILA WINEBERRY','','Activo'),('19-2816','LILA VINO','','Activo'),('19-2820','VIOLETA PHLOX','','Activo'),('19-2924','VIOLETA HOLLYHOCK','','Activo'),('19-3022','LILA GLOXINIA','','Activo'),('19-3138','VIOLETA BIZANCIO','','Activo'),('19-3215','VIOLETA INDIGO','','Activo'),('19-3217','PURPURA SOMBRAS','','Activo'),('19-3218','PURPURA CIRUELA','','Activo'),('19-3220','VIOLETA CIRUELA','','Activo'),('19-3223','PURPURA PASION','','Activo'),('19-3230','VIOLETA UVA JUGO','','Activo'),('19-3316','LILA CIRUELA PERFECT','','Activo'),('19-3323','PURPURA PROFUNDO','','Activo'),('19-3325','VIOLETA MADERA','','Activo'),('19-3336','VIOLETA UVA BRILLANTE','','Activo'),('19-3424','PURPURA ATARDECER','','Activo'),('19-3438','VIOLETA BRILLANTE','','Activo'),('19-3514','VIOLETA MAJESTAD','','Activo'),('19-3518','VIOLETA UVA REAL','','Activo'),('19-3519','MORADO PENNANT','','Activo'),('19-3520','LILA ZARZAMORA','','Activo'),('19-3526','VIOLETA PRADO','','Activo'),('19-3528','PURPURA IMPERIAL','','Activo'),('19-3536','PURPURA AMARANTO','','Activo'),('19-3540','VIOLETA MAGICO','','Activo'),('19-3542','VIOLETA PANSY','','Activo'),('19-3617','VIOLETA MISTERIO','','Activo'),('19-3620','VIOLETA REINO','','Activo'),('19-3622','VIOLETA FRAMBUESA','','Activo'),('19-3628','VIOLETA ACAI','','Activo'),('19-3632','VIOLETA PETUNIA','','Activo'),('19-3638','VIOLETA TILLANDSIA','','Activo'),('19-3640','LILA CORONA JEWEL','','Activo'),('19-3642','VIOLETA ROYAL','','Activo'),('19-3712','VIOLETA HIERBA MORA','','Activo'),('19-3713','AZUL OSCURO WELL','','Activo'),('19-3714','VIOLETA MARINO COSMOS','','Activo'),('19-3716','PURPURA PLUMERIA','','Activo'),('19-3720','VIOLETA UVA GOTICA','','Activo'),('19-3722','PURPURA MORA','','Activo'),('19-3725','PURPURA VELVET','','Activo'),('19-3728','VIOLETA UVA','','Activo'),('19-3730','VIOLETA GENCIANA','','Activo'),('19-3731','LILA PURPURA','','Activo'),('19-3737','VIOLETA HELIOTROPE','','Activo'),('19-3748','VIOLETA PRISMA','','Activo'),('19-3803','MARRON GATITO','','Activo'),('19-3810','AZUL ECLIPSE','','Activo'),('19-3815','AZUL NOCHE OSCURO','','Activo'),('19-3830','PURPURA ASTRAL','','Activo'),('19-3832','AZUL MARINO CLARO','','Activo'),('19-3839','AZUL RIBBON','','Activo'),('19-3842','LILA WISTERIA OSCURO','','Activo'),('19-3847','VIOLETA PROFUNDO','','Activo'),('19-3850','VIOLETA LIBERTY','','Activo'),('19-3864','AZUL MAZARINE','','Activo'),('19-3900','GRIS PAVIMIENTO','','Activo'),('19-3901','GRIS MAGNET','','Activo'),('19-3903','GRIS SHALE','','Activo'),('19-3905','GRIS CONEJO','','Activo'),('19-3906','GRIS OSCURO SOMBRAS','','Activo'),('19-3907','GRIS HIERRO FORJADO','','Activo'),('19-3908','GRIS HIERRO NINE','','Activo'),('19-3910','GRIS IRON GATE','','Activo'),('19-3915','GRIS PIEDRA','','Activo'),('19-3918','GRIS PERISCOPIO','','Activo'),('19-3919','AZUL NOCHE SOMBRA','','Activo'),('19-3920','AZUL PEACOAT','','Activo'),('19-3921','AZUL IRIS OSCURO','','Activo'),('19-3922','AZUL CAPITAN','','Activo'),('19-3923','AZUL MARINO','','Activo'),('19-3924','AZUL NIGHT SKY','','Activo'),('19-3925','AZUL PATRIOTA','','Activo'),('19-3926','AZUL CORONA','','Activo'),('19-3927','AZUL GRAFITO','','Activo'),('19-3928','AZUL INDIGO','','Activo'),('19-3929','AZUL VINTAGE','','Activo'),('19-3933','AZUL MEDIEVAL','','Activo'),('19-3935','AZUL COBALTO PROFUNDO','','Activo'),('19-3936','AZUL SKIPPER','','Activo'),('19-3938','AZUL CREPUSCULO','','Activo'),('19-3939','AZUL PRINT','','Activo'),('19-3940','AZUL PROFUNDO','','Activo'),('19-3950','AZUL ULTRAMARINO','','Activo'),('19-3951','AZUL CLEMATIS','','Activo'),('19-3952','AZUL SURF','','Activo'),('19-3953','AZUL SODALITA','','Activo'),('19-3955','AZUL ROYAL','','Activo'),('19-3964','AZUL MONACO','','Activo'),('19-4004','NEGRO TAP SHOE','','Activo'),('19-4005','NEGRO STRETCH LIMO','','Activo'),('19-4006','NEGRO CAVIAR','','Activo'),('19-4007','NEGRO ANTRACITA','','Activo'),('19-4008','NEGRO METEORITO','','Activo'),('19-4009','AZUL ESPACIO OUTER','','Activo'),('19-4010','AZUL ECLIPSE TOTAL','','Activo'),('19-4011','AZUL SALUTE','','Activo'),('19-4012','AZUL CARBON','','Activo'),('19-4013','AZUL MARINO OSCURO','','Activo'),('19-4014','GRIS OMBRE','','Activo'),('19-4019','GRIS INDIAN INK','','Activo'),('19-4020','AZUL ZAFIRO OSCURO','','Activo'),('19-4021','VIOLETA ARANDANO','','Activo'),('19-4022','AZUL NOCHE PARIS','','Activo'),('19-4023','AZUL NOCHE','','Activo'),('19-4024','AZUL DRESS','','Activo'),('19-4025','AZUL INDIGO MOOD','','Activo'),('19-4026','AZUL BANDERA','','Activo'),('19-4027','AZUL FINCA','','Activo'),('19-4028','AZUL INSIGNIA','','Activo'),('19-4030','AZUL MARINO TRUE','','Activo'),('19-4033','AZUL POSEIDON','','Activo'),('19-4035','AZUL OSCURO','','Activo'),('19-4037','AZUL COBALTO','','Activo'),('19-4039','AZUL PORCELANA','','Activo'),('19-4044','AZUL LIMOGES','','Activo'),('19-4050','AZUL NAUTICO','','Activo'),('19-4052','AZUL CLASICO','','Activo'),('19-4053','AZUL MAR TURCO','','Activo'),('19-4056','AZUL OLIMPIA','','Activo'),('19-4057','AZUL','','Activo'),('19-4104','GRIS EBANO','','Activo'),('19-4110','AZUL MARINO MEDIANOCHE','','Activo'),('19-4118','AZUL DENIM OSCURO','','Activo'),('19-4121','AZUL ALAS','','Activo'),('19-4125','AZUL MAJOLICA','','Activo'),('19-4127','AZUL MEDIANOCHE','','Activo'),('19-4150','AZUL PRINCES','','Activo'),('19-4151','AZUL DIVER','','Activo'),('19-4203','GRIS NOCHE MOONLESS','','Activo'),('19-4205','GRIS FANTASMA','','Activo'),('19-4215','GRIS TURBULENCIA','','Activo'),('19-4220','AZUL OSCURO SLATE','','Activo'),('19-4227','AZUL INDIAN TEAL','','Activo'),('19-4234','AZUL INK','','Activo'),('19-4241','AZUL MARRUECOS','','Activo'),('19-4245','AZUL IMPERIAL','','Activo'),('19-4305','VERDE PIRATA','','Activo'),('19-4324','AZUL LEGION','','Activo'),('19-4326','AZUL ESTANQUE','','Activo'),('19-4340','AZUL LYON','','Activo'),('19-4342','AGUAMARINA SEAPORT','','Activo'),('19-4524','VERDE PICEA','','Activo'),('19-4526','AZUL CORAL','','Activo'),('19-4535','AZUL OCEANO PROFUNDO','','Activo'),('19-4726','VERDE ATLANTICO PROFUNDO','','Activo'),('19-4818','VERDE MALLARD','','Activo'),('19-4826','AZUL LIBELULA','','Activo'),('19-4906','VERDE GABLES','','Activo'),('19-4914','VERDE TEAL OSCURO','','Activo'),('19-4916','AGUAMARINA PACIFICO','','Activo'),('19-4922','VERDE TEAL','','Activo'),('19-5004','GRIS URBAN CHIC','','Activo'),('19-5212','VERDE OSCURO SPRUCE','','Activo'),('19-5217','VERDE TORMENTA','','Activo'),('19-5220','VERDE BOTANICO','','Activo'),('19-5226','VERDE EVERGLADE','','Activo'),('19-5320','VERDE PINO PONDEROSA','','Activo'),('19-5350','VERDE SCARAB','','Activo'),('19-5406','VERDE PINAR','','Activo'),('19-5411','VERDE TREKKING','','Activo'),('19-5414','VERDE JUNE BUG','','Activo'),('19-5420','VERDE EVER','','Activo'),('19-5511','VERDE CAZADOR','','Activo'),('19-5513','VERDE OSCURO','','Activo'),('19-5708','AZUL JET SET','','Activo'),('19-5914','VERDE JUNGLA','','Activo'),('19-5917','VERDE SICOMORO','','Activo'),('19-5920','VERDE AGUJA PINO','','Activo'),('19-6026','VERDE VERDANT','','Activo'),('19-6050','VERDE EDEN','','Activo'),('19-6311','VERDE PASTO OSCURO','','Activo'),('2925-C','CYAN NEON','','Activo'),('802-C','VERDE NEON','','Activo'),('803-C','VERDE CLARO NEON','','Activo'),('804-C','NARANJA NEON','','Activo'),('805-C','CORAL NEON','','Activo'),('806-C','FUCSIA OSCURO NEON','','Activo'),('807-C','FUCSIA NEON','','Activo'),('809-C','AMARILLO NEON','','Activo');

/*Table structure for table `parametros` */

DROP TABLE IF EXISTS `parametros`;

CREATE TABLE `parametros` (
  `clave` varchar(40) NOT NULL,
  `usuario` varchar(30) NOT NULL,
  `valor` varchar(60) DEFAULT NULL,
  `descrip` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`clave`,`usuario`),
  KEY `Ref6289` (`usuario`),
  CONSTRAINT `Refusuarios289` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `parametros` */

insert  into `parametros`(`clave`,`usuario`,`valor`,`descrip`) values ('factura_interval_dup','douglas','51','5 Intervalo de Documento'),('factura_margen_der','*','',''),('factura_margen_der','douglas','7','2 Derecha'),('factura_margen_inf','*','',''),('factura_margen_izq','*','',''),('factura_margen_izq','douglas','5','4 Izquierda'),('factura_margen_sup','*','',''),('factura_margen_sup','douglas','50','1 Arriba'),('limite_stock_negativo','*','-10','Permitir o no Stock negativo'),('margen_tol_empaque','*','2','Margen de Tolerancia en Empaque 2% del Metraje'),('nombre_empresa','*','Nombre de su Taller','Taller el Zar'),('nro_pallet','*','A00','Nro de Pallet actual'),('porc_tolerancia_remsiones','*','2','Porcentaje de Tolerancia en Remisiones en Base a la Cant. In'),('vent_det_limit','*','15','Limite de Carga en Detalle de Venta');

/*Table structure for table `pcs` */

DROP TABLE IF EXISTS `pcs`;

CREATE TABLE `pcs` (
  `ip` varchar(16) NOT NULL,
  `suc` varchar(10) NOT NULL,
  `tipo_periferico` varchar(30) NOT NULL,
  `ip_alt` varchar(16) DEFAULT NULL,
  `local` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`ip`,`suc`,`tipo_periferico`),
  KEY `Ref1851` (`suc`),
  CONSTRAINT `Refsucursales51` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `pcs` */

/*Table structure for table `pdvs` */

DROP TABLE IF EXISTS `pdvs`;

CREATE TABLE `pdvs` (
  `pdv_cod` varchar(30) NOT NULL,
  `suc` varchar(10) NOT NULL,
  `pdv_ubic` varchar(30) NOT NULL,
  `tipo` varchar(30) NOT NULL,
  `moneda` varchar(4) NOT NULL,
  `sub_tipo` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`pdv_cod`,`suc`,`pdv_ubic`,`tipo`,`moneda`),
  KEY `Ref1820` (`suc`),
  KEY `Ref15140` (`moneda`),
  CONSTRAINT `Refmonedas140` FOREIGN KEY (`moneda`) REFERENCES `monedas` (`m_cod`),
  CONSTRAINT `Refsucursales20` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `pdvs` */

insert  into `pdvs`(`pdv_cod`,`suc`,`pdv_ubic`,`tipo`,`moneda`,`sub_tipo`) values ('001','01','Factura','Pre-Impresa','G$','Factura'),('001','01','Recibo','Pre-Impresa','G$','Recibo');

/*Table structure for table `pedido_tras_det` */

DROP TABLE IF EXISTS `pedido_tras_det`;

CREATE TABLE `pedido_tras_det` (
  `id_det` int(11) NOT NULL AUTO_INCREMENT,
  `n_nro` int(11) NOT NULL,
  `codigo` varchar(30) DEFAULT NULL,
  `lote` varchar(30) DEFAULT NULL,
  `um_prod` varchar(10) DEFAULT NULL,
  `descrip` varchar(120) DEFAULT NULL,
  `cantidad` decimal(16,2) DEFAULT NULL,
  `precio_venta` decimal(16,2) DEFAULT NULL,
  `color` varchar(30) DEFAULT NULL,
  `estado` varchar(30) DEFAULT NULL,
  `mayorista` varchar(30) DEFAULT NULL,
  `urge` varchar(4) DEFAULT NULL,
  `obs` varchar(60) DEFAULT NULL,
  `lote_rem` varchar(30) DEFAULT NULL,
  `ubic` varchar(20) DEFAULT NULL,
  `nodo` varchar(10) DEFAULT NULL,
  `pallet` varchar(14) DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id_det`,`n_nro`),
  KEY `Ref4674` (`n_nro`),
  CONSTRAINT `Refpedido_traslado74` FOREIGN KEY (`n_nro`) REFERENCES `pedido_traslado` (`n_nro`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `pedido_tras_det` */

/*Table structure for table `pedido_traslado` */

DROP TABLE IF EXISTS `pedido_traslado`;

CREATE TABLE `pedido_traslado` (
  `n_nro` int(11) NOT NULL AUTO_INCREMENT,
  `nro_catalogo_muestras` int(11) DEFAULT NULL,
  `cod_cli` varchar(12) DEFAULT NULL,
  `cliente` varchar(60) DEFAULT NULL,
  `cat` int(11) DEFAULT NULL,
  `usuario` varchar(30) NOT NULL,
  `fecha` date DEFAULT NULL,
  `hora` varchar(10) DEFAULT NULL,
  `total` double(18,0) DEFAULT NULL,
  `estado` varchar(20) DEFAULT NULL,
  `suc` varchar(10) NOT NULL,
  `suc_d` varchar(10) DEFAULT NULL,
  `fecha_cierre` date DEFAULT NULL,
  `hora_cierre` varchar(10) DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`n_nro`),
  KEY `Ref1872` (`suc`),
  KEY `Ref673` (`usuario`),
  CONSTRAINT `Refsucursales72` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`),
  CONSTRAINT `Refusuarios73` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `pedido_traslado` */

/*Table structure for table `pedidos_x_entrada` */

DROP TABLE IF EXISTS `pedidos_x_entrada`;

CREATE TABLE `pedidos_x_entrada` (
  `id_ent` int(11) NOT NULL,
  `n_nro` int(11) NOT NULL,
  PRIMARY KEY (`id_ent`,`n_nro`),
  KEY `Ref48133` (`id_ent`),
  KEY `Ref52134` (`n_nro`),
  CONSTRAINT `Refentrada_merc133` FOREIGN KEY (`id_ent`) REFERENCES `entrada_merc` (`id_ent`),
  CONSTRAINT `Refnota_pedido_compra134` FOREIGN KEY (`n_nro`) REFERENCES `nota_pedido_compra` (`n_nro`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `pedidos_x_entrada` */

/*Table structure for table `permisos` */

DROP TABLE IF EXISTS `permisos`;

CREATE TABLE `permisos` (
  `id_permiso` varchar(10) NOT NULL,
  `descripcion` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id_permiso`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `permisos` */

insert  into `permisos`(`id_permiso`,`descripcion`) values ('1','Acceso al Menu Ventas'),('1.1','Acceso al Menu Nueva Venta (Factura Deudor)'),('1.2','Acceso al Menu Ventas Abiertas (Facturas Deudores)'),('1.3','Acceso al Menu Nueva Orden de Reserva'),('1.4','Acceso al Menu Reservas Abiertas'),('1.5','Acceso al Menu Notas de Pedido'),('1.5.1','Acceso al Menu Solicitudes de Traslado'),('1.5.2','Acceso al Menu Pedidos de Compra'),('1.5.3','Cerrar Pedido de Compra Internacional'),('1.5.4','Acceso al Menu Tracking de Pedidos'),('1.5.5','Tracking de Pedidos Filtrar Pedidos de Todos los Usuarios'),('1.5.6','Acceso al Menu Solicitudes de Traslados Entrantes'),('1.5.7','Acceso al Menu Solicitudes de Traslado Mobile'),('1.5.8','Acceso al Menu Orden de Fabricacion'),('1.6','Acceso al Menu Ventas Discriminadas/Mayoristas'),('1.6.1','Acceso al Boton Discriminar Precios'),('1.6.2','Permitir Discriminar Precios Debajo del Minimo'),('10','Acceso al Menu Reportes'),('10.1','Reporte Facturas Legales Star Soft'),('10.2','Reporte de Controles Fuera de Rango (Empaque)'),('10.3','Reporte de Mis Ventas (Para Vendedores)'),('10.4','Reporte de Ventas de Todos los Vendedores (Gerentes)'),('10.5','Reporte Prorrateo de Gastos'),('11','Acceso al Menu Recepcion de Vehiculos'),('12','Acceso al Menu Diagnosticos'),('12.1','Acceso al Menu Ordenes de Trabajo'),('2','Acceso al Menu Empaque'),('2.1','Acceso al Menu Control de Empaque'),('2.2','Acceso al Menu Ajustes'),('2.3','Acceso al Menu Impresion Codigo Barras'),('2.3.1','Permiso para Imprimir Codigos Barras Estantes y Stacks'),('2.4','Acceso al Menu Entrada Directa Mercaderias'),('2.5','Modificar Margen por mal corte'),('2.6','Forzar Control Empaque'),('3','Acceso al Menu Caja'),('3.1','Acceso al Menu Ventas en Caja'),('3.1.6','Permiso para Exonerar Intereses'),('3.10','Acceso al Menu Notas de Credito Nuevas/Abiertas/Pendientes'),('3.11','Autorizar Nota de Credito'),('3.12','Acceso al Menu Declaracion de Documentos'),('3.2','Acceso al Menu Depositos en CC'),('3.3','Acceso al Menu Cargar Facturas Contables'),('3.4','Acceso al Menu Cotizaciones'),('3.5','Acceso al Menu Reservas en Caja'),('3.6','Acceso al Menu Cobro Cuotas'),('3.7','Acceso al Menu Cambio de Divisas'),('3.8','Acceso al Menu Arqueo de Caja'),('3.8.1','Modificar Sucursal en Reportes'),('3.8.2','Verificacion de Control de Cobros'),('3.8.3','Verificacion de Movimientos de Facturas Ventas'),('3.8.4','Enviar pagos de Facturas a SAP'),('3.8.5','Enviar cobros de Cuotas a SAP'),('3.9','Acceso al Menu Ingreso y Egreso de Caja'),('4','Acceso al Menu Produccion'),('4.1','Acceso al Menu Ajustes'),('4.2','Acceso al Menu Solicitudes de Traslado Pendientes'),('4.3','Acceso al Menu Emision para Produccion'),('4.4','Acceso al Menu Fabrica'),('4.5','Acceso al Menu Recibo de Produccion'),('4.6','Acceso al Menu Catalogos de Muestras'),('4.6.1','Acceso al Menu Pedidos de Muestras'),('4.6.2','Acceso al Menu Fabricacion de Muestras'),('4.7','Acceso al Menu Renombrar Estantes'),('4.8','Acceso al Menu de Produccion de Manteles'),('5','Acceso al Menu Configuracion'),('5.1','Acceso al Menu Administracion de Usuarios'),('5.2','Acceso al Menu Impresion de Credenciales'),('5.3','Acceso al Menu Configuracion de taller'),('5.3.1','Acceso al Menu Permisos x Grupo'),('5.4','Acceso al Menu Perfil y Password'),('5.5','Acceso al Menu Tabla Auxiliar de Partes de Vehiculos'),('6','Acceso al Menu Administracion'),('6.1','Acceso al Menu Clientes'),('6.1.1','Modificar Categoria de Clientes'),('6.2','Acceso al Menu Extracto de Cuentas de Clientes'),('6.3','Acceso al Menu Levantar Extractos Bancarios'),('6.4','Acceso al Menu Autorizados de Clientes'),('6.5','Acceso al Menu Registro de Ausencias de Funcionarios'),('6.5.1','Permiso para ver Reporte de Ausencias'),('6.6','Permiso para Ver Auditoria de Lotes'),('6.7','Acceso al Menu Finanzas'),('6.7.1','Acceso al Menu Plan de Cuentas'),('6.7.2','Acceso al Menu Centro de Costos'),('6.7.3','Acceso al Menu Asientos Contables'),('6.7.4','Acceso al Menu Cotizaciones Contables'),('6.8','Acceso al Menu Proveedores'),('7','Acceso al Menu Compras'),('7.1','Acceso al Menu Entrada de Mercaderias'),('7.10','Acceso al Menu Recepcion de Mercaderias Nuevo'),('7.2','Acceso al Menu Recepcion de Mercaderias (YA NO SE UTILIZA)'),('7.3','Acceso al Fraccionamiento Logico y Distribucion'),('7.3.1','Permiso para Modificar prioridad en Orden de Procesamiento'),('7.3.2','Permiso para Asignar Operador en Orden de Procesamiento'),('7.4','Acceso al Menu Pedidos de Compras Pendientes'),('7.5','Acceso al Menu Pedidos de Compras En Proceso'),('7.6','Acceso al Menu Shipment Table'),('7.7','Acceso al Menu Medicion/Fraccionamiento'),('7.8','Acceso al Menu Control de Distribucion'),('7.9','Acceso al Menu Fotografia Ancho y Gramaje'),('8','Acceso al Menu Remisiones'),('8.1','Acceso al Menu Remisiones Abiertas'),('8.1.1','Permiso para Cambiar Estado de Remisiones En Proceso y Cerrada'),('8.2','Acceso al Menu Remisiones Entrantes'),('9','Acceso al Menu Articulos'),('9.1','Acceso al Menu Historial de un Lote'),('9.10','Acceso al Menu Inventario'),('9.10.3','Permiso para Hacer a Revalorizacion de Inventario'),('9.11','Acceso al Menu Maestro de Articulos'),('9.12','Acceso al Menu Maestro de Lista de Precios'),('9.13','Acceso a Agregar Fallas'),('9.2','Acceso al Menu Unidades de Medida'),('9.2.1','Ver Precio Costo y Valor minimo de Venta'),('9.3','Acceso al Menu Politica de Cortes'),('9.4','Acceso al Menu Fraccionar'),('9.5','Acceso al Menu Ubicar Lotes'),('9.5.1','Permiso para Modificar Temporadas y Capacidades de Estantes'),('9.6','Acceso al Menu Galeria de Imagenes'),('9.7','Acceso al Menu Edicion de Lotes'),('9.8','Acceso al Menu Lista de Precios'),('9.9','Acceso a Modificar Ancho Tara y Gramaje');

/*Table structure for table `permisos_x_grupo` */

DROP TABLE IF EXISTS `permisos_x_grupo`;

CREATE TABLE `permisos_x_grupo` (
  `id_permiso` varchar(10) NOT NULL,
  `id_grupo` int(11) NOT NULL,
  `trustee` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id_permiso`,`id_grupo`),
  KEY `Ref75` (`id_permiso`),
  KEY `Ref58` (`id_grupo`),
  CONSTRAINT `Refgrupos8` FOREIGN KEY (`id_grupo`) REFERENCES `grupos` (`id_grupo`),
  CONSTRAINT `Refpermisos5` FOREIGN KEY (`id_permiso`) REFERENCES `permisos` (`id_permiso`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `permisos_x_grupo` */

insert  into `permisos_x_grupo`(`id_permiso`,`id_grupo`,`trustee`) values ('1',3,'vem'),('1',5,'vem'),('1.1',3,'vem'),('1.1',5,'vem'),('1.2',3,'vem'),('1.2',5,'vem'),('1.3',5,'---'),('1.4',5,'---'),('1.5',5,'---'),('1.5.1',5,'---'),('1.5.2',5,'---'),('1.5.3',5,'---'),('1.5.4',5,'---'),('1.5.5',5,'---'),('1.5.6',5,'---'),('1.5.7',5,'---'),('1.5.8',5,'---'),('1.6',5,'---'),('1.6.1',5,'---'),('1.6.2',5,'---'),('10',5,'vem'),('10.1',5,'---'),('10.2',5,'vem'),('10.3',5,'vem'),('10.4',5,'vem'),('10.5',5,'vem'),('11',5,'vem'),('12',3,'vem'),('12',5,'vem'),('12.1',3,'vem'),('12.1',5,'vem'),('2',5,'---'),('2.1',5,'---'),('2.2',5,'---'),('3',5,'vem'),('3.1',5,'vem'),('3.1.6',5,'vem'),('3.12',5,'---'),('3.2',5,'---'),('3.3',5,'vem'),('3.8',5,'vem'),('3.8.1',5,'vem'),('3.8.2',5,'vem'),('3.9',5,'vem'),('4',5,'---'),('4.1',5,'---'),('4.2',5,'---'),('4.3',5,'---'),('4.4',5,'---'),('4.5',5,'---'),('4.6',5,'---'),('4.6.1',5,'---'),('4.6.2',5,'---'),('4.7',5,'---'),('4.8',5,'vem'),('5',5,'vem'),('5.1',5,'vem'),('5.2',5,'vem'),('5.3',5,'vem'),('5.3.1',5,'vem'),('5.4',5,'vem'),('5.5',3,'vem'),('5.5',5,'vem'),('6',5,'vem'),('6.1',5,'vem'),('6.1.1',5,'vem'),('6.2',5,'---'),('6.3',5,'---'),('6.4',5,'---'),('6.5',5,'---'),('6.5.1',5,'---'),('6.6',5,'---'),('6.7',5,'---'),('6.7.1',5,'---'),('6.7.2',5,'---'),('6.7.3',5,'---'),('6.7.4',5,'---'),('6.8',5,'vem'),('7',3,'vem'),('7',5,'vem'),('7.1',3,'vem'),('7.1',5,'vem'),('7.10',5,'---'),('7.2',5,'---'),('7.3',5,'---'),('7.3.1',5,'vem'),('7.3.2',5,'vem'),('7.4',5,'---'),('7.5',5,'---'),('7.6',5,'---'),('7.7',5,'---'),('7.8',5,'---'),('7.9',5,'---'),('8',5,'---'),('8.1',5,'vem'),('8.1.1',5,'vem'),('8.2',5,'vem'),('9',5,'vem'),('9.1',3,'vem'),('9.1',5,'vem'),('9.10',5,'---'),('9.10.3',3,'vem'),('9.10.3',5,'vem'),('9.11',3,'vem'),('9.11',5,'vem'),('9.12',3,'vem'),('9.12',5,'vem'),('9.13',5,'---'),('9.2',3,'vem'),('9.2',5,'vem'),('9.2.1',5,'---'),('9.3',5,'---'),('9.4',5,'---'),('9.5',5,'---'),('9.5.1',5,'---'),('9.6',5,'---'),('9.7',5,'---'),('9.8',5,'---'),('9.9',5,'---');

/*Table structure for table `plan_cuentas` */

DROP TABLE IF EXISTS `plan_cuentas`;

CREATE TABLE `plan_cuentas` (
  `cuenta` varchar(30) NOT NULL,
  `nombre_cuenta` varchar(100) DEFAULT NULL,
  `moneda` varchar(4) NOT NULL,
  `padre` varchar(30) DEFAULT NULL,
  `tipo` varchar(4) DEFAULT NULL,
  `asentable` varchar(4) DEFAULT NULL,
  `nivel` int(11) DEFAULT NULL,
  `saldo` decimal(30,2) DEFAULT NULL,
  `saldoMS` decimal(30,2) DEFAULT NULL,
  `suc` varchar(4) DEFAULT NULL,
  `estado` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`cuenta`),
  KEY `Ref15237` (`moneda`),
  CONSTRAINT `Refmonedas237` FOREIGN KEY (`moneda`) REFERENCES `monedas` (`m_cod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `plan_cuentas` */

insert  into `plan_cuentas`(`cuenta`,`nombre_cuenta`,`moneda`,`padre`,`tipo`,`asentable`,`nivel`,`saldo`,`saldoMS`,`suc`,`estado`) values ('1','ACTIVO','G$','','D','No',1,0.00,0.00,'*','Activa'),('11','ACTIVO CORRIENTE','G$','1','D','No',2,0.00,0.00,'*','Activa'),('111','DISPONIBILIDADES','G$','11','D','No',3,0.00,0.00,'*','Activa'),('1111','CAJA CHICA','G$','111','D','No',4,0.00,0.00,'*','Activa'),('111101','Caja','G$','1111','D','Si',5,0.00,0.00,'*','Activa'),('111102','Caja Chica Matriz','G$','1111','D','Si',5,0.00,0.00,'*','Activa'),('111103','Caja Chica Terminal','G$','1111','D','Si',5,0.00,0.00,'*','Activa'),('111104','Caja Chica Obligado','G$','1111','D','Si',5,0.00,0.00,'*','Activa'),('111105','Caja Chica Santa Rita','G$','1111','D','Si',5,0.00,0.00,'*','Activa'),('111106','Caja Chica CDE km 3,5','G$','1111','D','Si',5,0.00,0.00,'*','Activa'),('111107','Caja Chica CDE Centro','G$','1111','D','Si',5,0.00,0.00,'*','Activa'),('111108','Caja Chica Produccion 00','G$','1111','D','Si',5,0.00,0.00,'*','Activa'),('111109','Caja Chica San Lorenzo','G$','1111','D','Si',5,0.00,0.00,'*','Activa'),('111110','Caja Chica Terminal - P','G$','1111','D','Si',5,0.00,0.00,'*','Activa'),('111111','Caja Chica Obligado - P','G$','1111','D','Si',5,0.00,0.00,'*','Activa'),('111112','Caja Chica Santa Rita- P','G$','1111','D','Si',5,0.00,0.00,'*','Activa'),('111113','Caja Chica CDE Km 3,5- P','G$','1111','D','Si',5,0.00,0.00,'*','Activa'),('111114','Caja Chica CDE Centro- P','G$','1111','D','Si',5,0.00,0.00,'*','Activa'),('111115','Caja Chica Produccion 00- P','G$','1111','D','Si',5,0.00,0.00,'*','Activa'),('111116','Caja Chica Matriz-P','G$','1111','D','Si',5,0.00,0.00,'*','Activa'),('111117','Caja Chica San Lorenzo - P','G$','1111','D','Si',5,0.00,0.00,'*','Activa'),('111118','Caja Chica Asuncion','G$','1111','D','Si',5,0.00,0.00,'*','Activa'),('111119','Caja Chica Asuncion - P','G$','1111','D','Si',5,0.00,0.00,'*','Activa'),('111120','Caja Chica Lambare','G$','1111','D','Si',5,0.00,0.00,'*','Activa'),('111121','Caja Chica Lambare - P','G$','1111','D','Si',5,0.00,0.00,'*','Activa'),('111122','Caja Chica Avenida','G$','1111','D','Si',5,0.00,0.00,'*','Activa'),('111123','Caja Chica Avenida - P','G$','1111','D','Si',5,0.00,0.00,'*','Activa'),('1112','RECAUDACIONES A DEPOSITAR','G$','111','D','No',4,0.00,0.00,'*','Activa'),('11121','Recaudaciones a Depositar','G$','1112','D','Si',5,0.00,0.00,'*','Activa'),('1112101','Caja Matriz Gs.','G$','1112','D','Si',8,0.00,0.00,'*','Activa'),('1112102','Caja Matriz U$D 24.776.-','U$','1112','D','Si',8,0.00,0.00,'*','Activa'),('11122','Recaudaciones a Depositar Avenida','G$','1112','D','Si',5,0.00,0.00,'*','Activa'),('11123','Recaudaciones a Depositar Terminal','G$','1112','D','Si',5,0.00,0.00,'*','Activa'),('11124','Recaudaciones a Depositar CDE km 3,5','G$','1112','D','Si',5,0.00,0.00,'*','Activa'),('11125','Recaudaciones a Depositar Santa Rita','G$','1112','D','Si',5,0.00,0.00,'*','Activa'),('11126','Recaudaciones a Depositar Obligado','G$','1112','D','Si',5,0.00,0.00,'*','Activa'),('11127','Recaudaciones a Depositar CDE Centro','G$','1112','D','Si',5,0.00,0.00,'*','Activa'),('11128','Recaudaciones a Depositar San Lorenzo','G$','1112','D','Si',5,0.00,0.00,'*','Activa'),('11129','Recaudaciones a Depositar Asuncion','G$','1112','D','Si',5,0.00,0.00,'*','Activa'),('1112901','Recaudaciones a Depositar Lambare','G$','1112','D','Si',8,0.00,0.00,'*','Activa'),('1112909','Recaudaciones Criptomonedas','G$','1112','D','Si',8,0.00,0.00,'*','Activa'),('1113','CAJA DE SENCILLOS','G$','111','D','No',4,0.00,0.00,'*','Activa'),('11130','Caja Sencillo Lambare','G$','1113','A','Si',5,0.00,0.00,'*','Activa'),('11131','Caja Sencillo Avenida','G$','1113','D','Si',5,0.00,0.00,'*','Activa'),('11132','Caja Sencillo Terminal','G$','1113','D','Si',5,0.00,0.00,'*','Activa'),('11133','Caja Sencillo CDE km 3,5','G$','1113','D','Si',5,0.00,0.00,'*','Activa'),('11134','Caja Sencillo Santa Rita','G$','1113','D','Si',5,0.00,0.00,'*','Activa'),('11135','Caja Sencillo Obligado','G$','1113','D','Si',5,0.00,0.00,'*','Activa'),('11136','Caja Sencillo CDE Centro','G$','1113','D','Si',5,0.00,0.00,'*','Activa'),('11137','Caja Sencillo Matriz','G$','1113','D','Si',5,0.00,0.00,'*','Activa'),('11138','Caja Sencillo San Lorenzo','G$','1113','D','Si',5,0.00,0.00,'*','Activa'),('11139','Caja Sencillo Asuncion','G$','1113','D','Si',5,0.00,0.00,'*','Activa'),('1114','BANCOS','G$','111','D','No',4,0.00,0.00,'*','Activa'),('11141','Banco Regional Cta Gs.Nº 1107052043','G$','1114','D','Si',5,0.00,0.00,'*','Activa'),('11142','Banco Regional Cta Gs. 14101060014','G$','1114','D','Si',5,0.00,0.00,'*','Activa'),('11143','Banco Regional Cta U$D. Nº7064127 U$ 2,98..','U$','1114','D','Si',5,0.00,0.00,'*','Activa'),('11144','Banco Continental Gs.21-23892003-05','G$','1114','D','Si',5,0.00,0.00,'*','Activa'),('11145','Banco Regional Cta U$D Nº 7602656 U$-40.835,19','U$','1114','D','Si',5,0.00,0.00,'*','Activa'),('11146','Banco Regional Cta U$D Nº 7471199','U$','1114','D','Si',5,0.00,0.00,'*','Activa'),('11147','Banco Regional Cta U$D Nº 1027003100','U$','1114','D','Si',5,0.00,0.00,'*','Activa'),('11148','Banco Continental Cta U$ Nº 21145243-05 U$1.319,20','U$','1114','D','Si',5,0.00,0.00,'*','Activa'),('11149','Banco Continental Cta Gs. Nº 21 0467200 07','G$','1114','D','Si',5,0.00,0.00,'*','Activa'),('11150','Banco Continental Cta U$ Nº 21 0755501 05 U$6.356,','U$','1115','D','Si',5,0.00,0.00,'*','Activa'),('11151','Banco Continental Cta U$D Nº 21 800062 03 U$0,79','U$','1115','D','Si',5,0.00,0.00,'*','Activa'),('11152','Banco Itapua Cta Gs. Nº 1008000874','G$','1115','D','Si',5,0.00,0.00,'*','Activa'),('11153','Banco Familiar Cta U$D Nº 14-000620104','U$','1115','D','Si',5,0.00,0.00,'*','Activa'),('11154','Banco Regional Cta. Gs.Nº 7051953','G$','1115','D','Si',5,0.00,0.00,'*','Activa'),('11155','Banco Continental Cta U$D N°21019758403 U$118.257,58','U$','1115','D','Si',5,0.00,0.00,'*','Activa'),('11156','Banco Familiar Cta. Gs.N° 141421599','G$','1115','D','Si',5,0.00,0.00,'*','Activa'),('11157','Banco Continental Cta. Gs.N°10652608','G$','1115','D','Si',5,0.00,0.00,'*','Activa'),('11158','Banco Familiar Cta U$D 1427179 U$ 3781,89','U$','1115','D','Si',5,0.00,0.00,'*','Activa'),('11159','Banco Continental Tarjeta de Credito','G$','1115','D','Si',5,0.00,0.00,'*','Activa'),('1115901','Banco Itapua Cta.Gs.48005395','G$','1115','D','Si',5,0.00,0.00,'*','Activa'),('1115902','Financiera Paraguaya Japones SAECA','G$','1115','D','Si',5,0.00,0.00,'*','Activa'),('1116','INVERSION DE CAPITAL','G$','111','D','No',4,0.00,0.00,'*','Activa'),('11161','Criptomonedas','G$','1116','D','Si',5,0.00,0.00,'*','Activa'),('112','CREDITOS','G$','11','D','No',3,0.00,0.00,'*','Activa'),('1122','CUENTAS A COBRAR','G$','112','D','No',4,0.00,0.00,'*','Activa'),('11221','CLIENTES','G$','1122','D','No',5,0.00,0.00,'*','Activa'),('11222','Clientes Avenida','G$','1122','D','No',5,0.00,0.00,'*','Activa'),('11222001','Clientes Varios','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222002','Adilson Almeida Vivero','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222003','Alberto Ruggeri','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222004','Alicia Benitez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222005','Amin Yunis Afara','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222006','Andrea Alejandra Rotzen (Funcionaria)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222007','Antonio Montania','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222008','Armin Clar Benkenstein','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222009','Arnaldo Agustin Aquino Caire','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222010','Arnoldo Gonzalez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222011','Sindicato de Empleados Banco Regional','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222012','Asociacion Kuña Ha Kuimba.e Tekove(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222013','Avelina López de Maier','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222014','Carlos Alan Verdun','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222015','Comercial Karima S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222016','Casiana Baran','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222017','Cecilio Aguilera Valdez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222018','Centro de las Sabanas','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222019','Centro del Goldstar S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222020','Cristhian Arthuro Siegel','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222021','El Castillo de las Sabanas S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222022','El Emporio S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222023','Elisa Franco','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222024','Estación La Paz S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222025','Esteban López Cristaldo','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222026','Fabian Alvarez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222027','Fabio Ricardo Riveros Soley','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222028','Fabiola Morel','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222029','Fernando Juan Gabriel Delvalle (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222030','Fernando Agustin Morales Gallinar','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222031','Leila Darouche(Filotex)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222032','Francisco Ubaldo Gracia','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222033','Geronimo Emilio Irala','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222034','Gobernación de Itapúa','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222035','Graciela Beatriz Lopez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222036','Graciela Irene Ramirez Esquivel','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222037','H y S Novedades S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222038','Hassan Abdul Raouf Jassin','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222039','Hector Aspeleiter','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222040','Hugo Javier Fernandez Cuenca','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222041','Ignacio Javier Benitez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222042','Ignacio Portillo Diaz','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222043','Isidoro Salustiano Coronel Vega(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222044','Jazmin Creaciones','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222045','Jorge Vera','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222046','José David Ruggeri','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222047','José María Chaparro(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222048','José Quiroga','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222049','Juan Bogado','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222050','Juan Carlos Cabrera','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222051','Juan David Margott Pintos (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222052','Juan Eudes Afara Maciel','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222053','Julio Anibal Dominguez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222054','Julio Miranda','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222055','Laura Carolina Irala Ortiz (Funcionaria)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222056','Laura Paredes','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222057','Lelia Segovia Ortiz','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222058','Leoncio Pradejzuk','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222059','Lilo Bass S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222060','Lisa Veronica Alegre Ayala','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222061','Liz Bianchetti','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222062','Luis Vázquez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222063','Luisa Mabel Ramirez Silva','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222064','Luz Arguello De Afara','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222065','Marcos Enrique Squef Manevy','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222066','Marcos Feliciano Lezcano Morel (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222067','Marcos Troche','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222068','Maria Fátima Benitez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222069','Maria Isabel Serial','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222070','Maria Kolesnikievich','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222071','Maria Zoraida Maciel Espinola (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222072','Mauricio Ramon Vazquez Duarte','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222073','Medina Center','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222074','Metalurgica Araucarea','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222075','Miguel Angel Sanabria','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222076','Miguel Carlos Andreoli','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222077','Mirta Machuca','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222078','Moda Center','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222079','Nelida Alicia Cantero','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222080','Nelly Sandalia Acevedo','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222081','Nilfa Cornelia Sanabria Vallejos','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222082','Noelia Beatriz Araujo','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222083','Nolberto Antonio Godoy Gimenez (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222084','Painco S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222085','Patricia Garcete','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222086','Pedro Fidel Guerreo Schuber','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222087','Perla Soledad Gomez Sarabia (Funcionaria)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222088','Ramona Teresa Bogado Benitez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222089','Raul Jorge Esteche Romero','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222090','Reina Yeza de Genez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222091','Reinerio Insauralde Legal','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222092','Restituto Cabañas(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222093','Roberto Villalba','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222094','Rocio López Franco','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222095','Rubén Dario Ortíz','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222096','Sabina Benítez Ayala','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222097','Sandra Petrona Vera Almeida (Funcionaria)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222098','Schapovaloff S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222099','Sebastian López','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222100','Sendy Chamorro','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222101','Sergio Riveros','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222102','Shyrley Rossani Argaña de Zaracho','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222103','Silvia Analía Benitez López','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222104','Sofia Sinchuk de Kuzmicz - Casa el Amanecer','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222105','Sonia Cocian','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222106','Susana Beatriz Araujo Rodriguez (Funcionaria)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222107','Syren S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222109','Truniforms','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222110','Victor Andres Aguero Sanchez (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222111','Victor Gonzalez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222112','Victor Orrego','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222113','Visitación Venialgo','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222114','Walter Obregon','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222115','Zulma Albina Martinez Vallejos (Funcionaria)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222116','Angela Cubilla de Flores (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222117','Dina Celeste Portillo (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222118','Isabelino Andres Galeano (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222119','Mariza Leonor Arrua Urbina (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222120','Roberto Carlos Sotelo (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222121','Erica López (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222122','Mirtha Silva (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222123','Asociacion Educadores del Paraná(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222124','Maria Nelly Cristaldo(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222125','Asociación Afuni(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222126','Asoc. Funcionarios de la Gobernación de Itapúa(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222127','Goncar S.A. (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222128','Mirian Soraida Gonzalez Benitez(Jerusalen)(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222129','Rolando Sebastian MIralles Miciukiewicz(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222130','Walter Omar Arias Afara(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222131','Arnoldo Franck Schauer(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222132','Lucio Javier Lucero B. (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222133','Mirtha Dovhun (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222134','Blanca Marina Barboza de Ramirez ( 02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222135','Sebastiana Silva de Aguilera ( 02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222136','Ricardo Nayib Yunis Afara','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222137','Fepisa S.A.(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222138','Maria Carolina Gauto Escobar','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222139','Vidalia Zotelo','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222140','Miguel Angel Ledesma','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222141','Rafael Gimenez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222142','Hugo Daniel Saucedo Ocampos(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222143','Lilia Nuñez Dasilveira Leguizamon(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222144','Analia Patricia Genez de Villar(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222145','Claudia Mabel Maier Gomez(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222146','Dina Esther Barboza de Acosta','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222147','Soraya Elizabeth Bitar','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222148','Luisa Noemi Chaparro Paniagua','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222149','Fabio Ledezma Cabral (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222150','Asencion Rolon Arce','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222151','La Familia S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222152','Luis Alejandro Fernandez Zang','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222153','Julio Maciel Armoa (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222154','Diana Carmen Gonzalez Gonzalez(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222155','Maxifarma Encarnacion S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222156','Fermin Lopez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222157','Pablino Sanabria Vallejos','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222158','Celsa Mary Gomez de Vera (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222159','Said Camel Escandar Ortiz','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222160','Luz Maria Verdun Barboza (Funcionaria)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222161','Deisy Pamela Vazquez Ruiz Diaz','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222162','Sonia Isabel Aguero Yeza','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222163','Marcelo Javier Velazquez Bogado (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222200','AFUNI Asoc. de Funcionarios de la UNI (convenio)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222201','ABR Asoc. Banco Regional (convenio)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222202','CUENTA LIBRE PARA USAR','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222203','AEE Asoc.de Educadores de Encarnaciòn(convenio)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222204','Maria Lilian Dominguez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222205','Maryan Alejandra Aguilera Valenzuela','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222206','Fundación Hogar del Niño  Piche Roga','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222207','Parana Emprendiminetos S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222208','Abdo Dib Chebli (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222209','Silvia Florentin Ocampos (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222210','Delia Medina (Medina Center)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222211','Higinio Salinas Sosa EIRL','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222212','Las Perlas Emprendimientos S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222213','Maria Vidalina Vera Meza','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222214','Reinaldo Martinez Arguello','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222215','Textil Italia S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222216','Walter Omar Burgos Pereira','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222217','Lisandro Duette','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222218','Luisa Morais de Vazquez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222219','Wakeb Ibrahim Charif (Casa Karima)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222220','Wilian Rene Esquivel','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222221','Pablino Gonzalez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222222','Maria Ojeda (Telepatia)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222223','Fredy Lopez (Confecciones Aurora)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222224','Adela Noemi Muñoz Galvez (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222225','Angelina Florentin Gonzalez(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222226','Emijidia Gimenez Bareiro(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222227','utilizar para otro cliente','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222228','Maria Estela Bareiro Cristaldo','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222229','Asociacion de Estudiantes de Agro','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222230','Ramón Peralta Penayo (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222231','Juan Andres Lopez Villamayor(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222232','Delba S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222233','A y V Importaciones S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222234','Ms Emprendimientos S.A.(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222235','Nancy Graciela Bareiro Grischuk (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222236','Hassan Abdallah Halawi','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222237','Ghaleb Hassan El Zein','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222238','Sadek Klalil Hachem','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222239','Antonia Amarilla Venialgo(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222240','Panama S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222241','Fawaz Mouhammed Hammoudi','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222243','Rodolfo Insfran','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222244','Carlos Raul Leiva Palacios','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222245','Chebli S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222249','Nicolas Cardozo Meza','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222250','Mariam Elizabeth Martina Arrua (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222251','Maria Alicia Baez Fleitas (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222254','Karina Hachem','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222256','Tarek Hussein El Mahanto','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222257','Mohammed Jebara','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222258','Eduardo Andres Verdun Barboza (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222259','Santiago Miguel Alarcon Benitez (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222260','Shirley Fabiana Martinez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222261','Cesar Antonio Villalba Rodriguez (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222262','Jose Maria Olmedo Torres','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222263','Susana Dovhun','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222264','Luis Marcelo Araujo','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222265','Lali Violeta Otazu','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222266','Fadua Import Export','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222267','Maria Alejandra Benitez (Funcionaria)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222268','Marta Dovhun','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222269','Maria Victoria Yunis Afara','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222270','Juan Bernardo Duarte','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222271','Maria Graciela Lopez Duarte','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222273','Victor Hugo Oviedo Delvalle (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222274','Tienda Juanita Importacione S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222275','Alinne Elecciones S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222276','Miguel Angel Abatte Cortazar','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222277','Hugo Ruben Medina Valiente','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222278','Gregorio Luzco y Cia. S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222279','Jorge Ramon Dominguez Lopez (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222280','Alexis Samuel Duette Riveros','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222281','Cyntia Celeste Galeano Cabral','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222282','Nora Duarte Gonzalez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222283','Celeste Ana Maria Acevedo Trinidad (Funcionaria)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222284','Selva Encina Rolon EIRL','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222285','Casa Atlas S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222286','Carlos Ramon Acosta Delvalle','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222287','Selva Aguilar de Oviedo','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222288','Gladys Josefina Caballero Saldivar','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222289','Virina Benitez de Adorno(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222290','Juan Pablo Rios Lezcano','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222291','Leyla Elizabeth Añazco Osorio','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222292','Tomas Benitez Gayoso','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222293','Genaro Bogado Ovelar(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222294','Guillermo Ramon Ghiringhelli','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222295','Maria del Carmen Sanchez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222296','Monica Ana Liz Pedrozo Gonzalez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222297','Teresita Dolores Lopez Leon','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222298','Blanca  Estela Benitez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222299','Magdalena Saucedo Irala','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222300','Carlos Andres Guerrero Rivas','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222301','Francisco Paniagua Patiño(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222302','Liliana Hortencia Gonzalez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222303','Dora Benitez de Florentin','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222304','Carina Elizabeth Aguilar','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222305','Gilda Gladys Martinez Servin','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222306','Nacional Foot Boll Club','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222307','Oscar Fabian Fariña','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222308','Waldemar Bresanovich Unsain','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222309','Diego Lopez Solis','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222310','Luz Marina Isabel Paniagua','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222311','Emilce  Soledad Santander','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222312','Flavia Gamarra de Romero','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222313','Olga Rossana Sanchez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222314','Daniela Fernandez de Leguizamon','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222315','Gerardo Fleitas','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222316','Natalia Belen Rienzzi Fernandez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222317','Walter Rojas','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222318','Julian Martin  Fernandez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222319','Liz Maria Griselda Dominguez(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222320','Jose Oscar Benitez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222321','Macro S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222322','Don Felipe S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222323','Osvaldo Encina Florentin','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222324','David Dietze Servin(02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222325','Sleiman Talih Ahmad','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222326','Leonora González Escobar (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222327','Jorge Antonio Vazquez Martinez (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222328','Lisa Mariel Allende Franco','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222329','Benita Zarate Gaona','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222330','Abbas Hassan Hoteit','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222331','Gregorio Jeremias Riveros Paniagua','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222332','Vanina Edit Villalba','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222333','Virgilio Oscar Gonzalez (Deysi Creaciones)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222334','Brenda Dalila Rojas Amarilla','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222335','Raul Simeon Cortesi Peralta','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222336','Ladi Lorena Candia Pedrozo','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222337','Agueda Olmedo de Matto','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222338','Pedro Domingo Zarate','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222339','Ruben Humberto Medina','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222340','Miriam Malaquias','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222341','Corporacion Textil S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222342','Angie Makarena Alderete','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222344','Enriquito Comercial S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222345','Enrique Caceres S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222346','Ana Elizabeth Sanchez Villalba','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222347','Juan Esteban Irala','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222348','Hamid Lamia Ibrahin Abdul','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222349','Transruta Courier S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222350','Tomas Julian Medina Gonzalez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222351','Susana Semeniuk','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222352','Gaby Stefany Figueredo Gauto (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222353','Laureno Scholler Dressler','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222354','Julia Carolina Salinas Villalba (Funcionaria)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222355','Juan Pintkowski Drozzina (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222356','Tapizcenter S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222357','Doglas Dembogurski','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222358','Jorge Armando Colina (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222359','Estanislao Ramon Verdun Barboza (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222360','Javier Emilio Morel Altamirano','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222361','Dumbus S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222362','Michatex S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222363','Grupo CartAgena S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222364','Dionicio Cesar Espinola Benitez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222365','Genilda Teresa Torres de Fariña','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222366','Fernando Javier Aranda Hermosilla (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222367','Marcos Gustavo Meaurio Ortellado (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222368','Club Internacional de Tenis CIT','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222369','Maria Veronica Bobadilla Rondelli(Casa Tela)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222370','Epifania Sanchez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222371','Marcos Ariel Benitez Villalba (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222372','Juan Elias Zayas Tillner','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222373','Dionicia Mabel Duarte Oviedo','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222374','Marcial Rivas Figueredo','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222375','Oscar Ruben Rivas Contretra','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222376','Julio Cesar Antonio Mussi','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222377','Lourdes Concepcion Figueredo Elizauer','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222378','Arabi Ibrahim','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222379','Mouhamed Hammoudi Fawaz','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222380','Panitex S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222381','Casa Medina S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222382','Felicia Montiel de Gomez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222383','Enrique Samuel Aguilera','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222384','Romina Selent Chaparro (Funcionaria)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222385','Amada Soledad Vazquez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222386','Antonio Godoy Delgado (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222387','Wood and Group S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222388','Atilio Rolando Zotelo Salinas (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222389','Derliz Gomez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222390','Nicolas Adrian Santesteban Monzon (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222391','Rosaura Selent Chaparro (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222392','Nestor Lucia Alvarez Arce','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222393','Fermina Rodriguez de Wolf','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222394','Lorenzo Zarate Martinez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222395','Geminis Super Center','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222396','Maria del Rosario Benitez (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222397','Micaela Soledad Gaona Lezcano (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222398','Mariam Darwiche','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222399','Eduarda Elizabeth Alfonso','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222400','Pedro Carlos Martinez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222401','Nancy Carolina Luzco Szostak','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222402','Bernardo Brizuela Rivas','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222403','Camila Soledad Aguilar Gomez (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222404','Julieta Ortiz (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222405','La Gondola S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222406','Casa de la Ofertas de Salto del Guaira S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222407','Edgar Crescencio Ruiz Diaz','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222408','Celsa Ursula Alvarenga Vallejos','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222409','Gustavo Samuel Pinkowski Zaracho (funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222410','Oscar Javier Cuevas Bernal','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222411','Nelly Rosalba Caceres Maldonado','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222412','Jorge Arnaldo Verdun Barboza (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222413','Vidal Alvarez Aquino (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222414','Diana Benitez Bogado','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222415','Rocio del Jazmin Ortellado Carballar','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222416','Gustavo Adin Cantero Santacruz','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222417','Canaltex SACI','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222419','Salvador Díaz','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222420','Corina Miguela Lupetegui Ortiz','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222421','Ramon Peralta Penayo','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222423','Juan Carlos Meza','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222424','Cristian Ariel Benitez Bogado','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222425','Monarca SACI','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222426','Tienda SHHSA','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222427','Pascacio Servin Zotelo','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222428','Zunilda Gonzalez de Gonzalez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222429','Celia Irene Gonzalez Zena','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222430','Super Pilar S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222431','Luis Enrique Peralta Rolon','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222432','Andresa Avelina Aranda Lezcano','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222433','Osvaldo Lezcano','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222434','Olga Oviedo de Gutierrez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222435','Maria del Carmen Salvioni','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222436','Jorge Miguel Morales Sanabria','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222437','Celestina Espinola de Acevedo (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222438','Beba Nancy Duarte de Avalos','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222439','Gloria Alice Delmas','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222440','Nilda Josefina Gonzalez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222441','Mirtha Elizabeth Ruiz','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222442','Carlos Travieso Romero','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222443','Ruta 10 SRL','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222444','Enrique Leiva Ortiz','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222445','Olga Gonzalez de Silva','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222446','Carlos Antonio Nunhez Alcaraz','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222447','Sonia Silva Sugastti','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222448','MCCAR S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222449','Marcos Manuel Figueredo Cabrera','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222450','Maria Cristina Steimberger Lacy','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222451','Iris Rosana Vera Almeida','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222452','Fredy Denis Aranda Ramirez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222453','Cristian Miguel Martinez Fernandez (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222454','Carmen Concepcion Baez Fretes','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222455','Juan Aranda','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222456','Cynthia Carolina Balmaceda Gonzalez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222457','Frederick David Vazquez Portillo','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222458','Vazport S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222459','Maria Ojeda Ozuna','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222460','Julio Cesar Portillo Chaparro','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222461','Jurac S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222462','Virginia Gomez Martinez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222463','Mabel Violeta Cespedes Alvarez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222464','Pablo Daniel Cuquejo','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222465','Sonia Ester Villasanti Pacheco','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222466','Maria Hildebrand Friesen','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222467','Sergio Antonio Ocampos(funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222468','Maria Margarita Ruiz Diaz (Funcionaria)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222469','Edilburga Narvaez Vda de Ocampos','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222470','Nilsa Ocampo','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222471','Marta Graciela Penayo López (MGP Uniformes Paraguay)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222472','Alfredo Espinoza Morel','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222473','El Campero S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222474','Liz Confecciones S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222475','Mirian Soraida Gonzalez de Leiva','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222476','Ali Halawi','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222477','AJM S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222478','Salomon Abdo Escandar Bareiro','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222479','Quelly Karina Romero Jara','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222480','Maria del Carmen Toledo Jara (Luxor Emprendimientos)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222481','Irene Lidia Locbel de Frank (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222482','Rosa Mabel Alcaraz de Cardozo','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222483','Alicia Lucia Santesteban Monzon (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222484','Alberto Ezequiel Benitez Caballero (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222485','Aurelia Ruiz Núñez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222486','Diego Nicolas Vazquez Cabañas','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222487','Andrea Noemi Lopez (Funcionaria)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222488','Claudia Vanessa Krummel','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222489','Liz Andrea Acosta Morel (Funcionaria)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222490','Gloria Belen Servin (Funcionaria)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222491','Evany Ramos Benitez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222492','Maria Ramona Ojeda (Funcionaria)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222493','Asoc. de Func. Escuela General Díaz (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222494','Diana Marlene Peña (Funcionaria)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222495','Yanina Brizuela (Funcionaria)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222496','Alcides Andres Martinez Benitez (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222497','Aldo Samuel Castillo Mongelos (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222498','Emilce Bernal Vigo (Funcionaria)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222499','Francisca Orrego de González','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222500','Politex Importaciones S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222501','María Angélica Viveros Báez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222502','Nadir Kharfan Darwich','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222503','Comercial Walaa Sajida','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222504','Wilfrido Atilio Gauto Carrera','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222505','Jorge Armando Perez Perez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222506','Susana Beatriz Centurion','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222507','Universidad del Norte','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222508','El Mouhanto Hayssam Hussein Eirl','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222509','Inocencia Mercado de Morinigo','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222510','Elisa Rossana Deleon Quintana','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222511','Lelly Javier Acosta Silva','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222512','Caceres y Caceres SRL','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222513','Nelson Torres Arias','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222514','Carlos Gabriel Vargas Gimenez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222515','La Montaña S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222516','Iglu Emprendimientos S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222517','Maria Mercedes Vazquez Arguello','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222518','Angel Benitez Villaverde','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222519','Fabiana Maria Belen Ocampos Oviedo ( Funcionaria)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222520','Alejandro Ariel Bobadilla Ramirez (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222521','Luis Alberto Salinas','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222522','El Baratisimo S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222523','Rocio Josefina Ovelar Caballero','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222524','Antonio Orue Zarate','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222525','De Todo S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222526','Pablo Jose Valdez Gonzalez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222527','Matias Emanuel Suarez Benitez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222528','Lider Leonardo Aguero Domiguez (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222529','Dynasty Industrial y Comercial S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222530','Alaa Housain Mhanto','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222531','Fanyna Sociedad de Responsabilidad Limitada Imp y Exp','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222532','Nancy Soledad Irala Ortega','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222533','Perla Martinez Nuñez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222534','Maria Luz Torrez de Gimenez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222535','David Jhonatan Benitez Villalba (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222536','Clara Caballero Bernal','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222537','Cooperativa de Producción Agricola Bergthal Ltda.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222538','Deysi Ariana Franck Locbel (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222539','Luis Antonio Martinez Montiel (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222540','Leonida Haydee Villamayor de Mazur','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222541','Hector Perez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222542','Vera Yvania Bar Neumann','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222543','Quintin Gonzalez Lezcano','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222544','Antonio Orue Medina','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222545','Juanita Textil S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222546','Maria Victoria Afara de Yunis (Funcionaria)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222547','Electronica Marbella S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222549','Daniel Aguero Bareiro (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222550','Maria Margarita Gonzalez Vda de Yegros (Casa Perlita)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222551','Jorge Roberto Siminovich','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222552','Halavvi Achraf Mahmoud E.I.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222553','Casa La Gloria S.R.L.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222554','Ana Mabel Machado Fleitas','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222555','Jose Euripides Freitas Da Silva (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222556','Carlos Alberto Ortellado Leon','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222557','NJA S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222558','Andrea Veronica Vera Almeida (Funcionaria)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222559','RF Group S.A.','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222561','Fidelino Perez Zarate Norimar Confecciones','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222562','Victor Antonio Portillo','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222563','Rodrigo Cuevas Sanchez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222564','Jorge Miguel Anzoategui (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222565','Jhony Enrique Noguera Acosta (Funcionario)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222566','Aracely Maria Paz Caceres San Martin (Funcionaria)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222567','Natividad Trinidad (02)','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222568','Salvador Muñoz Nuñez','G$','11222','D','Si',6,0.00,0.00,'*','Activa'),('11222800','(-)Previsión  Clientes con mora (>90 <180)días','G$','112228','D','Si',7,0.00,0.00,'*','Activa'),('11222801','(-)Previsión Clientes con mora (>180<365) días','G$','112228','D','Si',7,0.00,0.00,'*','Activa'),('11222802','(-)Previsión Clientes con mora (> a 365) días','G$','112228','D','Si',7,0.00,0.00,'*','Activa'),('11223','Clientes Terminal','G$','1122','D','No',5,0.00,0.00,'*','Activa'),('11223001','Agueda de Jesús Jara','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223002','Antonia Amarilla Venialgo(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223003','Antonia Gauna de Prieto','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223004','Arnaldo Vera González','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223005','Beatriz  Penayo de Irigoita','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223006','Benk S.A.','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223007','Blanca Teresa Noguera de Burgo','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223008','Carlos Sanabria','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223009','Claudia Lorena Villalba','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223010','Claudia Mabel Maier Gómez(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223011','Diana Carmen González González(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223012','Dionicia Carolina Acuña Maidana','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223013','Dionicio Báez Brizuela','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223014','Edilia Ramona Areco','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223015','Edita Dominski de Melo','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223016','Edorita Zotelo','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223017','Eligio Daniel Ruiz Díaz','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223018','Elvio Rolón','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223019','Emijidia Gimenez(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223020','Eustacia González','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223021','Gladys Nilsa Ibarra Anzoategui','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223022','Hortencia Dominguez','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223023','Hugo Luis Paredes','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223024','Jorge Luis Martinez','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223025','Jose Maria Olmedo','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223026','Josefa Castellano de Arzamendia','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223027','Juan Bernardo Duarte','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223028','Juan Ignacio Fernandez','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223029','Julio Maciel Armoa(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223030','Leonora González Escobar (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223031','Lilian Andrea Duarte','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223032','Lilia Nuñez Da Silveira (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223033','Luis A.Benitez Nuñez','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223034','Marcelina Villasboa de Arce','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223035','Maria del Carmen Candia','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223036','Maria Graciela López Duarte','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223037','Mariela Pacheco','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223038','MIrian Morínigo','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223039','Mirian Ocampos Vera','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223040','Municipalidad de Encarnación','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223041','Nery Ramón Jara Vera','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223042','Nestor Flores','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223043','Nestor Julian Duarte','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223044','Ninfa Ramirez','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223045','Pablo Moreira','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223046','Pedro Marcial Sendoa','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223047','Pedro Pereira','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223048','Ramón Peralta Penayo(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223049','Ramón Ricardo Armoa González','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223050','Silvia Florentin Ocampos (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223051','Silvio González','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223052','Tapiceria Walter','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223053','Teresa Adorno','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223054','Angela Cubilla de Flores (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223055','Dina Celeste Portillo (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223056','Isabelino Andrés Galeano (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223057','Mariza Leonor Arrua Urbina (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223058','Roberto Carlos Sotelo (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223059','Erica López (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223060','Mirtha Silva (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223061','Asociacion Educadores del Paraná (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223062','Maria Nelly Cristaldo (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223063','Asociación Afuni (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223064','Asoc. Funcionarios de la  Gobernación de Itapua(01','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223065','Goncar S.A. (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223066','Mirian Soraida González Benitez(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223067','Rolando Sebastian Miralles Miciukiewicz(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223068','Walter Omar Arias Afara (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223069','Dolores Beatriz Galeano de Cristaldo(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223070','Abdo Dib Chebli (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223071','Zunilda Haidee Rivas Cabañas','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223072','Ramona Elizabeth Torales de Gimenez','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223073','Maria Isabel Araujo Espinola','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223074','Hilda Graciela Rodriguez','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223075','Comite Mujeres Unidas del Municipio Cap. Miranda','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223076','Gladys Ester Rivero de Palmerola','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223077','Valeriana Rojas Sanders','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223078','Adela Noemi Muñoz Galvez','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223079','Gladys Concepción Denis Aguirre','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223080','Monica Vanessa Almada Gonzalez','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223081','Maria Deidamia Franco Rivarola','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223082','Fernando Juan Gabriel Delvalle Segovia (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223083','Susana Dovhun Murawczuk (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223084','Talent Sir S.A.','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223085','Asoc. de Educadores del Paraná ( 01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223086','Nolberto Antonio Godoy Gimenez ( 01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223087','Sebastiana Silva de Aguilera (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223088','Delfina Elizabeth Trinidad de Paredes','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223089','Marcelo Daniel Bogado','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223090','MS Emprendimientos S.A. (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223091','Celsa Mary Gomez de Vera(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223092','Norma Beatriz Baez Britez','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223093','Belen Carolina Torres Garay','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223094','Sergio Marcelino Godoy Caballero','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223095','Marissa Rocio Maldonado Piriz (Funcionaria)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223096','Lidia Magdalena Venialgo','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223097','Ramona Ferreira Villalba','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223098','Claudia Mariel Alvarez de Oreggioni','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223099','Juan Andres Lopez Vilamayor(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223100','Jose Luis Bareiro Castillo','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223101','Nancy Graciela Bareiro Grischuk(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223102','Maria Elvira Penayo de Melgarejo','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223103','Josias Aguilera Miranda(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223104','Otoniel Olmedo Mira(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223105','Ramon Ricardo Chaparro Saucedo','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223106','Laura Esequiela Portillo Diaz','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223107','Blas Gustavo Cabrera Pereira','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223108','Oscar Gustavo Rossi','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223109','Dahiana Elizabeth Lezcano Gomez (Funcionaria)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223110','Marly Delosangele Portillo Castillo','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223200','AFUNI Asoc.Funcionarios de la UNI(convenio)(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223201','ABR Asoc.Banco Regional (convenio) (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223202','cuenta libre para usar','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223203','AEE Asoc.Educadores de Encarnación(convenio)(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223204','Asociacion Kuña Ha Kuimba.e Tekove(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223205','Gladys Cristina Delvalle Miranda','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223206','Blanca Marina Barboza de Ramirez  ( 01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223207','Claudina Beatriz  López de Alvizo (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223208','Angelina Florentin Gonzalez(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223209','Nancy Baez Britez','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223210','Isabel Gonzalez de Almada (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223211','Maria Zoraida Maciel Espinola (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223212','Gladys Marlene Zimmer de Leidemer (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223213','Hugo Daniel Saucedo Ocampos (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223214','Diana A. Aguirre Ibarra','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223215','Luz Amada Acosta','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223216','Mabel Celeste Miranda','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223217','Natalia Liz Lopez Benitez','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223218','Sonno Import Export S.A.','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223219','Yohana Carina Pereira Riveros','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223220','Fernando Luis Gaete','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223221','Asociacion de Empleados del Banco Regional','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223222','Mariam Elizabeth Martina Arrua(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223223','Eva Clotilde Benitez Martinez','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223224','Maria Alicia Baez Fleitas(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223226','Diego Ramon Benitez Ramos','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223228','Vidalina Zotelo(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223229','Santiago Miguel Alarcon Benitez (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223230','Fepisa S.A.(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223231','Francisco Paniagua(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223232','Restituto Cabañas Villagra(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223233','Maxima Aguirre Almiron','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223234','Maria Aydee Alonso de Vera','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223235','Carlos Pereira Cubilla','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223236','Jorge Ramon Dominguez Lopez (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223237','David Dietze Servin(01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223238','Juan Antonio Zotelo','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223239','Marina Deidama Zarza Ledezma (Confec. Giovanny)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223240','Miguel Babak','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223241','Karina Andrea Alvarenga Balbuena (Funcionario)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223242','Andrea Noelia Quiroz Ramirez','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223243','Camila Dahiana Alfonzo Bogado (Funcionario)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223244','Mario Fabian Altamirano Tilleria (Funcionario)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223245','Sergio Javier Vazquez Aquino (Funcionario)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223246','Daniel Andres Alvarez Mauro (Funcionario)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223247','Carlos Diosnel Irala Pinkowski (Funcionario)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223248','APACED','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223249','Liliana Andrea Martinez','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223250','Diana Beatriz Romero Benitez','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223251','Pablo Toranzo','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223252','Lucas Hernan Sotelo Doldan','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223253','Francisco Feliciano Duarte Ramírez','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223254','Giovanni Confecciones S.A.','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223255','Painco S.A. (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223256','Graciela Beatriz Lopez (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223257','Luis Marcelo Araujo Cabrera (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223258','Sergio Riveros (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223259','Pascacio Servin Zotelo (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223260','Alicia Lucia Santesban (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223261','Alfredo Espinoza Morel (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223262','Talia Marlene Cabral Barzala (Funcionaria)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223263','Felipa Pinto Britez','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223264','Jessy Lens S.R.L.','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223265','Cecilio Aguilera Valdez (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223266','Sandra Rosalia Ibarra','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223267','Mirian Rodriguez Gonzalez','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223268','Asoc. de Func. Escuela General Diaz (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223269','Jacinta Roque Cabral Acosta (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223270','Radio Parana S.R.L.','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223271','Juan Carlos Candado','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223272','Alex Gabriel Fernandez Meza (Funcionario)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223273','Deysi Ariana Franck Locbel (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223274','Yoe Jin Emmanuel Son Lee','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223275','Hernan Ovelar','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223276','Victor Manuel Portal Almada (Funcionario)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223277','Juan Carlos Gimenez','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223278','Identidad Publicidad S.A.','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223279','Hector Javier Rojas Lezcano','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223280','Nestor Fabian Acevedo Gonzalez','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223281','Natividad Trinidad (01)','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223282','Luis Alberto Madrigal','G$','11223','D','Si',6,0.00,0.00,'*','Activa'),('11223400','(-)Previsión  Clientes con mora (>90 <180)días','G$','112234','D','Si',7,0.00,0.00,'*','Activa'),('11223401','(-)Previsión Clientes con mora (>180<365) días','G$','112234','D','Si',7,0.00,0.00,'*','Activa'),('11223402','(-)Previsión Clientes con mora (> a 365) días','G$','112234','D','Si',7,0.00,0.00,'*','Activa'),('11224','Clientes CDE km 3,5','G$','1122','D','No',5,0.00,0.00,'*','Activa'),('11224001','Acción S.R.L.','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224002','Aczel Favian Ortiz Benítez','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224003','Adolfina Avalos de Ríos','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224004','Analía Zunilda Vallejos de Gill','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224005','Angel Lezme Rodriguez','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224006','Blanca Estela Bogado','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224007','Carolina González','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224008','Celia Vázquez','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224009','Claudia Rosa Ruiz De Silvero','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224010','Derlys Antonio Gimenez Ojeda','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224011','Diego González','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224012','Digna Florencia Garcia Ayala','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224013','Dora Concepción Fariña','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224014','Elba Ramona Fatecha','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224015','Elva Liliana Zarza Arce','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224016','Eva Antonia Franco Nuñez','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224017','Gerardo Ramon Chavez','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224018','Gloria Elizabeth Valenzuela','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224019','Grupo Akis S.A.','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224020','Impar Paraguay S.A.','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224021','Isabel Vera de Fernandez','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224022','Laura Rocio Colman Britez (Funcionaria)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224023','Laura Coronel Delvalle','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224024','Liana Schlickmann','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224025','Maria Elena Paoli (Fabrik)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224026','Maria Soledad Rolón Torres','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224027','Marta Raquel Valiente','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224028','Mirta Alvarez','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224029','Obdulia Ojeda','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224030','Olga Bresanovich Villamayor','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224031','Oscar Leguizamon Ftaut','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224032','Paulina E. Morinigo','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224033','Pedro Luis Aquino Gimenez','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224034','Ricardo Ferreira','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224035','Rida Assaad Gebai','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224036','Robert A. Cabaña Bazan (Funcionario)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224037','Robert S. Clothes S.R.L.(06)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224038','Rosalina M. Lezcano','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224039','Tania Acuña Mereles','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224040','Vinca Criton de Acosta','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224041','Viviana Soledad Casco','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224042','Zunilda Fatecha','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224043','Analise Piazza Melgarejo (06)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224044','Susana Dovhun (06)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224045','Marta Dovhun (06)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224046','Mirtha Dovhun (06)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224047','NIlda Rossana Escobar Onell','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224048','Teofilo Silvero Andino','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224049','Brayan Ignacio Caceres Velazquez','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224050','Rumilda Fernandez','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224051','Mat Clau Confecciones Import Export S.R.L.','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224052','Juana Antonia Fernandez de Escobar','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224053','Albino Raul Rodas Escobar','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224054','Carlos Adrian Bogarin (Funcionario)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224055','Iglu Emprendimientos S.A.','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224056','Lilia Quintana Delvalle','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224057','Hector Rafael Armoa Silvero','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224058','Juan Ramon Torres Duarte(06)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224059','Alceu Aldisio Becker','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224060','Tecnippon S.A. (06)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224061','Viela S.A.','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224062','Angel Isaac Benitez Rodriguez','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224063','Maria Auxiliadora Rivas','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224064','Antonia Amarilla Venialgo(06)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224065','Mirna Marcela Davalos Zorrilla','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224066','Becker y Maia S.A.(06)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224067','Hernan Dario Quiñonez','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224068','Eumelio Ramon Villar Espinola','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224069','Lorenzo Gomez Saenger','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224070','David Dietze Servin(06)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224071','Mario Antonio Gauto Lezcano','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224072','Alexis Daniel Cortaza (Funcionario)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224073','Jacinta Roque Cabral Acosta','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224074','Victor Ruben Denis Rodriguez','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224075','Fabio Toledo Martinez','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224076','Alberto Escobar Fernandez','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224077','David Oberladstatter Noguera','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224078','Maria Liliana Cardozo','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224079','Francisco Gonzalez Florenciano','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224080','Blanca Mabel Maldonado','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224081','Adrian Alfredo González Cochere','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224082','Aricio Villlalba','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224083','Juan Esteban Irala','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224084','Maria Lilian Dominguez Gonzalez (Funcionaria)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224085','Miguel Angel Villalba Benitez','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224086','Celia Elizabeth Vazquez de Acuña (Funcionaria)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224087','Angela Hermosilla','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224088','Daniel Pereira Tilleria','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224089','Oscar Arminio Ortiz','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224090','Enrique David Noguera','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224091','Eumelia Angelica Gauto Lezcano','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224092','Guido Cañete','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224093','Sergio David Roman Melgarejo','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224094','Deoliria Gonzalez de Villalba','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224095','Alicia Concepcion Gonzalez De Centurion','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224096','Aida Eresmilda Gonzalez Doldan','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224097','Ana Maria Suarez','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224098','Francisco Silvero Andino','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224099','Arcelly Denisse Villamayor Godoy','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224100','PANKY SA','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224101','Juan Pablo Caballero Figueredo','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224102','Carlos Ramon Galeano','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224104','Marly Delosangele Portillo Castillo (06)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224105','Diego Benitez Romero (Funcionario)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224106','Delia Maria Medina (Medina Center) (06)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224107','Marli Mabel Rolon (Funcionaria)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224108','Santacruz Irala Perez','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224109','Sonia Silva Sugastti','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224110','Alcides Rojas','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224111','Gloria Valenzuela de Benitez','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224112','Ninfa Elizabeth Dominguez Gonzalez (Funcionaria)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224113','Divina Home','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224114','Alicia Gonzalez de Centurion','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224115','Digna Collante de Alfonzo','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224116','Juan Edgar González (Soriana Confecciones)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224117','Patricia Doldan de Gimenez','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224118','Maria Antonia Mora Britez (06)','G$','11224','D','Si',6,0.00,0.00,'*','Activa'),('11224400','(-)Previsión  Clientes con mora (>90 <180)días','G$','112244','D','Si',7,0.00,0.00,'*','Activa'),('11224401','(-)Previsión Clientes con mora (>180<365) días','G$','112244','D','Si',7,0.00,0.00,'*','Activa'),('11224402','(-)Previsión Clientes con mora (> a 365) días','G$','112244','D','Si',7,0.00,0.00,'*','Activa'),('11225','Clientes Santa Rita','G$','1122','D','No',5,0.00,0.00,'*','Activa'),('11225001','Adir Anesi Kelm','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225002','Adir Marasca Da Silveira','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225003','Alberta Wolf Morinigo','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225004','Alcides Ariel Aquino Bogado','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225005','Alcides Fernandez Coronel','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225006','Alessandro Luis Santini','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225007','Eltermir Alves Freitas','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225008','Ana Arámbulo','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225009','Ana Machuca Vera','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225010','Ana María Arce De Rojas','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225011','Amalia de Rodriguez','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225012','Aurelia Isabel Venialgo','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225013','Beatriz Lauer','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225014','Berghofer S.R.L.','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225015','Blanca Estela Isea de Portillo','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225016','Blanca Lettieri','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225017','Carmen Yolanda Quintana','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225018','Celsa Gladys Zorrilla','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225019','Claudio Boroski','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225020','Clayton Nieuwenh','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225021','Dario Autelio Medina Meza','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225022','Deisi Duarte','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225023','Derlainen S.A.','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225024','Dito Sehleicher Zeizer','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225025','Divino Alves Pereira','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225026','Eder Gumercindo Candia Z.','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225027','Edison A. Prieto Ramirez','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225028','Edith Nancy Chamorro','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225029','Elba Ayala','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225030','Elisabeth Franz Goulaert','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225031','Elizabeth Camapaña de Ozuna','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225032','Erika Klingel','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225033','Florentina Salhman','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225034','Gilberto Torbesz','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225035','Gladys Britos','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225036','Herculano Cristaldo','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225037','Herme Bogado','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225038','Herna Chávez','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225039','Lara Veira de Medina','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225040','Irene Sosa','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225041','Ires Knob','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225042','Isabel Bogado','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225043','Ivanete Paim de Alves','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225044','Ivete Bamberg','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225045','Ivete Heck','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225046','Janikson Rafael Pires','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225047','Jose Sauer','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225048','Juan Angel Martinez','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225049','Jucelia Strapason','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225050','Leonardo Cesar Cassemiro','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225051','Liz Lilian Britez','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225052','Lurdes Rodriguez','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225053','Marcela Zeneida Vera Florentin (05)','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225054','Marcia Eliane Ricon','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225055','Marcia Urnau De Roque','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225056','Marcos A. Schmidt','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225057','Margarita de Roja','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225058','Maria Barreto Z.','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225059','Maria Clara Alegre','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225060','Maria De Lourdes Favero','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225061','Maria Teresa Guerrero','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225062','Maria Victoria Britez','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225063','Marisa Garcete','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225064','Martina Benitez','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225065','Liz Myrian Delvalle Ruiz de Inchausti','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225066','Movidal S.A.','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225067','Municipalidad de Santa Rita','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225068','Nancy Silvero','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225069','Natalia Gronda De Cabral','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225070','Natana Franz G.','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225071','News Center S.R.L.','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225072','Nidia González','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225073','Nilsa Drakeford','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225074','Nina Bella S.A.','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225075','Noelia Ortigoza','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225076','Norma Lucia Lencina','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225077','Norma Silveyra','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225078','Patricia Kunkel Joner','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225079','Richard René Benitez','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225080','Rosa Sanabria','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225081','Rosana Bez','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225082','Samuel Moraes','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225083','Sara Ruiz','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225084','Sintia Gullon','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225085','Sirlei Moro','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225086','Susana Aparecida','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225087','Gertrudis Teresa Alfonso Ullon (Funcionario)','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225088','Teresa Alvez Sequeira','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225089','Valmir Matte','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225090','Vardete Sozzo Da Silva','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225091','Waldir Nilton Wolkbring','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225092','Wilma Chamorro','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225093','Wilma Evangelista Ayala','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225094','Zenir Silveira Rizzoto','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225095','Zulma Fernandez','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225096','Lucio Javier Lucero B.(05)','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225097','Analise Piazza Melgarejo (05)','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225098','Susana Dovhun (05)','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225099','Marta Dovhun (05)','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225100','Mirtha Dovhun (05)','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225101','Armelindo Duarte','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225102','Vicente Ariel Muñoz','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225103','Cleude Bez  ( 05)','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225104','Hugo Ariel Diaz Sosa','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225105','Karina Soledad Gonzalez Baez','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225106','Gricelda Ruiz Lopez','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225107','Sandra Noelia Mendoza (Funcionaria)','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225108','Leandrina de Fatima Riboli','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225109','Alejandro Ivan Aquino Olmedo','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225110','Raquel Britos Caceres','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225111','Comision Vecinal Santa Rita Centro','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225112','Maria Lucia de Soares Carriel Sauer','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225113','Tecnippon S.A.(05)','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225114','Becker y Maia S.A.(05)','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225115','Hilda Benitez Anzuategui','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225116','Claudinei Gallas Chuster','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225117','Gracinda Ortiz de Chamorro(Ozeias de Mello)','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225118','Willian Luan Wagner (Danniele Hoffmann)','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225119','Multinsumos S.A.(05)','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225120','H.F. Comercial SRL (Daniele Hoffmann)','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225121','Daniele Hoffmann','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225122','Ozeias de Mello','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225123','Matte Valmir','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225124','Alceu Aldisio Becker','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225125','Eloi Schroder','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225126','Faberson Luis Junges Traesel','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225127','Estela Maria Lourdes Delvalle de Benitez','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225128','Industrias Conford Tapizados S.A.','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225129','Juan Ramon Torres Duarte(05)','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225130','Michael Salhmann Diaz (05)','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225131','Iara Regina Vieira de Medina','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225132','Miguel Ignacio Maidana Rodriguez','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225133','Bomir Fetsch','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225134','Yrene Antonia Acosta Lopez','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225135','Cristian Benitez Franco','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225136','Nerci Inacio Schimunech','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225137','Maria Carolina Benitez de Arce','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225138','Nancy Noelia Martinez Portillo','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225139','Nancy Elvira Montiel','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225140','Jorge Dario Colman Cabaña (Funcionario)','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225141','A Torres Import Export S.A.','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225142','Federico Fariña Benitez (Funcionario)','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225143','Flavio Pedro Dalazem','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225144','Arsenio Rios Pereira','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225145','Lucia Ayala Ortega','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225146','Marlene Ramirez Reyes','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225147','Hermelinda Bogado Velazquez','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225148','Teresinha Gutjahr','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225149','Laura Viviana Medina Olmedo','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225150','Miguel Angel Benitez Prieto','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225151','Rolando Gabriel Orue','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225152','Idacir Rodrigues Da Costa','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225153','Rudi Jaco Back','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225154','Sonia Elizabeth Gonzalez Cabrera (Funcionaria)','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225155','Carlos Antonio Nuñez Alcaraz','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225156','Patricia Ines Back Leichtveis','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225157','Victorina Tellez Quintana','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225158','Cristobal Martinez Acosta (Funcionario)','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225159','Catalina Martinez de Ferreira (Funcionaria)','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225160','Kenedy Alves Paim','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225161','Rosalina Florentin de Fernandez','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225162','Victor Hugo Ramirez Roman','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225163','Joseane Carlos de Almeida','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225164','Eligio Aquino Díaz','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225165','Javier Gonzalez - Jw Creaciones','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225166','Tapizados Dimone','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225167','Diego Rodrigo Vellozo Bozo','G$','11225','D','Si',6,0.00,0.00,'*','Activa'),('11225400','(-)Previsión  Clientes con mora (>90 <180)días','G$','112254','D','Si',7,0.00,0.00,'*','Activa'),('11225401','(-)Previsión Clientes con mora (>180<365) días','G$','112254','D','Si',7,0.00,0.00,'*','Activa'),('11225402','(-)Previsión Clientes con mora (> a 365) días','G$','112254','D','Si',7,0.00,0.00,'*','Activa'),('11226','Clientes Obligado','G$','1122','D','No',5,0.00,0.00,'*','Activa'),('11226001','Alicia Santesteban','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226002','Alicia Rosana Zang Toniolo (Funcionaria)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226003','Asociacion Paraguaya de los Adventistas','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226004','Asunción Mereles','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226005','Brunhilde Graf','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226006','Celsa Mary Gómez de Vera(04)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226007','Charlotte Lorraine Fischer','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226008','Claudia Becker Abadi','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226009','Claudina  Beatriz López  de Alvizo ( 04)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226010','Cleude Bez (04)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226011','Dabid Javier Aquino Amarilla','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226012','Deisy E. Schneider','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226013','Elena Brigida Drodowski de Scholz','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226014','Evelin Evany Sosa Almada (Funcionaria)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226015','Gladys Marlene Zimmer de Leidemer (04)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226016','Gladys Clara Schneider Scholler','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226017','Graciela Duttil Cabrera (Funcionaria)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226018','Hubert Heinrich Bronstrup','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226019','Ida Cecilia Reinhardt','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226020','Isabel González de Almada','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226021','Jamile Closs','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226022','Josefina Acosta de Espinola','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226023','Josias Aguilera Miranda(04)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226024','Juan Dario Meza','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226025','Juana Beatriz Peralta','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226026','Juana Rosa Florentin','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226027','Laura Rossana Ferreira Vera (Funcionaria)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226028','Liduvina Ayala','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226029','Lucas Rivarola','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226030','Luis Alberto Acosta','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226031','Marlene Beatriz Kleiner SA','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226032','Mirian Irene Yamet','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226033','Norma Bogado','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226034','Sandra E. Mathias','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226035','Sandra Ramirez Dominguez (Funcionaria)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226036','Santa Sabina Orrego','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226037','Arnoldo Franck Shauer (04)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226038','Dolores Beatriz Galeano de Cristaldo(04)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226039','Susana Dovhun (04)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226040','Marta Dovhun (04)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226041','Mirtha Dovhun (04)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226042','Ana Ester Stang Enhart','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226043','Alejandro Rafael Dominguez Gonzalez','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226044','Marcela Zeneida Vera Florentin (04)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226045','Hector Daniel Mathias Gysin','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226046','Sandra Mabel Algarin Luckmann','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226047','Andrea Giselle Mohr Acuña (Funcionaria)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226048','Multinsumos S.A.(04)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226049','Daniela Trombetta de Rolin','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226050','Francisco Paniagua(04)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226051','Liz Maria Griselda Dominguez(04)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226052','Antonia Amarilla Venialgo(04)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226053','Juana Maria Peralta de Amarilla','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226054','Tecnippon S.A.(04)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226055','Marlene Ruth Storrer','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226056','Michael Salhmann Diaz (04)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226057','Creaciones del Sur S.R.L.','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226058','Mathias Vera Leal','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226060','David Dietze Servin(04)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226061','Irene Lidia Locbel de Frank','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226062','Carlos Abel Maciel Gomez (Funcionario)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226063','Panitex S.R.L.','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226064','Dionicia Cano','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226065','Judith Joy Fischer','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226066','Alicia Beatriz Baez','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226067','Diego Ricardo Lugo Florentin','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226068','Norma Beatriz Penayo de Bonhaure','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226069','Sintia Marlene Sosa Martinez','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226070','Cooperativa Colonias Unidas Agropec. Ind. Ltda.','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226071','Nicolasa Barrios de  Maciel','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226072','Jacinta Roque Cabral Acosta','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226073','Maria Cristina Steimberguer Lacy (04)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226074','Norma Alejandra Silveyra (04)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226075','Sociedad Cultural y Deportivo Alemana Obligado','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226076','Nicolasa Ester Paiva','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226077','Pablo Elizer Rivarola Arrieta (Funcionario)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226078','Yenni Quintana Villordo (Funcionaria)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226079','José Oscar Benitez (Funcionario)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226080','Fernando David Espinola (Funcionario)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226081','Club de Caza y Pesca de Bella Vista','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226082','Stella Mary Riveros de Cuella- MR Eventos','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226083','Natividad Trinidad','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226084','Zulma Wiesenhutter de Collante','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226085','Deysi Ariana Franck Locbel (04)','G$','11226','D','Si',6,0.00,0.00,'*','Activa'),('11226400','(-)Previsión  Clientes con mora (>90 <180)días','G$','112264','D','Si',7,0.00,0.00,'*','Activa'),('11226401','(-)Previsión Clientes con mora (>180<365) días','G$','112264','D','Si',7,0.00,0.00,'*','Activa'),('11226402','(-)Previsión Clientes con mora (> a 365) días','G$','112264','D','Si',7,0.00,0.00,'*','Activa'),('11227','Clientes CDE Centro','G$','1122','D','No',5,0.00,0.00,'*','Activa'),('11227001','Mirtha Dovhun (10)','G$','11227','D','Si',6,0.00,0.00,'*','Activa'),('11227002','Ricardo Velazquez Cantero (Funcionario)','G$','11227','D','Si',6,0.00,0.00,'*','Activa'),('11227003','Yannina Elizabeth Roa Maciel (Funcionaria)','G$','11227','D','Si',6,0.00,0.00,'*','Activa'),('11227005','Maria Antonia Mora Britez','G$','11227','D','Si',6,0.00,0.00,'*','Activa'),('11227006','Noelia Beatriz Rios','G$','11227','D','Si',6,0.00,0.00,'*','Activa'),('11227007','Diego Armando Vera Sanchez (Funcionario)','G$','11227','D','Si',6,0.00,0.00,'*','Activa'),('11227008','Jorge Almeida (Funcionario)','G$','11227','D','Si',6,0.00,0.00,'*','Activa'),('11227009','Rossana Emilt Ruiz','G$','11227','D','Si',6,0.00,0.00,'*','Activa'),('11227010','Sonia Elizabeth Sanchez Baez (Funcionaria)','G$','11227','D','Si',6,0.00,0.00,'*','Activa'),('11227011','Rita de Fatima Oliveira','G$','11227','D','Si',6,0.00,0.00,'*','Activa'),('11227400','(-)Previsión  Clientes con mora (>90 <180)días','G$','112274','D','Si',7,0.00,0.00,'*','Activa'),('11227401','(-)Previsión Clientes con mora (>180<365) días','G$','112274','D','Si',7,0.00,0.00,'*','Activa'),('11227402','(-)Previsión Clientes con mora (> a 365) días','G$','112274','D','Si',7,0.00,0.00,'*','Activa'),('11228','Clientes San Lorenzo','G$','1122','D','No',5,0.00,0.00,'*','Activa'),('11228001','Diana Angelica Meza Genez','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228002','Carolina Noemi Amarilla Duarte (Funcionaria)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228003','Valeriana Arevalos Martinez','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228004','Marina Ester Pereira Benitez','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228005','Marciane Frare Willemann','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228006','Teodora Elizabet Cabrera','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228007','Maria Antonia Barreto','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228008','Cooperativa Col.Mut. Fernheim Ltda.','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228009','Multinsumos S.A.','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228010','Mauro Federico Cabrera Candia','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228012','Maria Leonida Dominguez(24)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228013','Isidoro Salustiano Coronel Vega (24)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228014','Neri Esteban Mettel Linares(24)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228015','Clara Ines Escobar Nuñez (Funcionaria)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228016','Ricardo Gabriel Valiente Gonzalez','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228017','Virina Benitez de Adorno(24)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228018','Abrahan Silvano Cabrera Candia(24)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228019','Jose Anibal Cohene Gonzalez','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228020','Maria Concepcion Oviedo de Bogado(24)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228021','Maria Gloria Barreto Marin','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228022','Isabel Orue de Ortiz','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228023','Noan S.R.L.','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228024','Salvador Muñoz Nuñez','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228025','Daisi Jorgelina Rivas Paiva','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228026','Maria Luisa Graciela Alonzo de Ortiz(24)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228027','Mary Beatriz Cespedes Salinas','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228028','Maria Liz Olmedo Nuñez','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228029','Maria Dulcelina Mongelos Leguizamon','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228030','Lucio Rafael Caceres Fernandez','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228031','Tienda Real S.R.L.','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228032','Ivan Antonio Gonzalez Gomez','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228033','Nelida Felicia Espinola de Vallejos','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228034','Emilce Soledad Santander(24)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228035','Genaro Bogado Ovelar(24)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228036','Nancy Carmen Chaparro Gimenez','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228037','Nicolas Sebastian Rojas Villaverde (Funcionario)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228038','Elizabeth Margarita Gonzalez Alonso','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228039','Silvia Fleitas Colman','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228040','Lenita Mello de Recalde','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228041','Ruth Leticia Mendez Agostini','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228042','Nelson Dario Villar Paez','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228043','Victor Manuel Salas','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228044','Ana Maria Portillo Vda.de Sanchez','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228045','Estefana Antonia Chilavert Espinola','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228046','Wilfrido Junior Palacios Gonzalez (Funcionario)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228047','Pedro Amado Ortiz','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228048','Cipriano Candia','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228049','Ramona Beatriz Sanchez','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228050','Hugo Ramon Barrios Estigarribia','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228051','Wilson Ricardo Ortiz Lezcano (Funcionario)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228052','Alicia Ramirez Bogado','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228053','Claudio David Grande Gaete','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228054','Francisco Santander','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228055','LIz Mabel Ferreira','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228056','Amado Rodriguez (Tapiceria JR)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228057','Griselda Beatriz Cantero','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228058','Juana Bobadilla','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228059','Tomas Benitez Gayoso(24)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228060','Osvaldo Lezcano (24)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228061','Celestina Espinola de Acevedo (24)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228062','Nilda Josefina Gonzalez','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228063','MCCAR S.R.L. (24)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228064','Juan Carlos Jimenez Barrios','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228065','Gabino Ortiz Espinoza (24)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228066','Industrias Salemma S.A.','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228067','Carlos Travieso Romero (Distribuidora Fabricato) (24)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228068','Jorge Fabian Bogado Griño','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228069','Hugo Enrique Vazquez Irala','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228070','Zunilda Benitez de Acuña','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228071','Alcides Antonio Alonso Gonzalez','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228072','Ruben Arias','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228073','MT Alimentos y Bebidas S.A.','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228074','Mundo Trade S.A.','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228075','Ramona Arce de Vargas','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228076','Monarca SACI (24)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228077','Edelio Vera Bernal','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228078','Mirian Caballero Franco','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228079','Ilse Jara Zarate','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228080','Moderna Confecciones S.A.','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228081','La Princesa S.A.','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228082','Dora Villar de Escobar','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228083','Miguel Angel Valdes Leite','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228084','Cynthia Carolina Acuña Morel','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228085','Candelaria Notario Dure','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228086','Alfonso Penayo Garcia','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228087','Richard Ramon Roman Gonzalez (Funcionario)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228088','Liz Cristina Estigarribia Castellani (Funcionaria)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228089','Zoilo Ortiz Sanchez (Funcionario)','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228090','Pablo José Valdez González','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228091','Isidro Salustiano Coronel Vega','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228092','Factor Positivo S.A.','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228093','Surcos de America S.A.','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228094','Rita Beatriz Vargas Arce','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228095','Julio Cesar Gimenez Paredes','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228096','Victor Ariel Subeldia Mora','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228097','VRO Pardo S.R.L.','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228098','Liz Beatriz Subeldia Ocampos','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228099','Pablo Alfredo Rodriguez Armoa','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228100','Eustacio Gonzalez Olavarrieta','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228101','Francisco Ayala Recalde','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228102','Lisa Dolores Pereira Gimenez','G$','11228','D','Si',6,0.00,0.00,'*','Activa'),('11228400','(-)Prevision Clientes con mora (_90 a 180) dias','G$','112284','D','Si',7,0.00,0.00,'*','Activa'),('11228401','(-)Prevision Clientes con mora (>180<365) dias','G$','112284','D','Si',7,0.00,0.00,'*','Activa'),('11228402','(-)Prevision Clientes con mora (mayor 365) dias','G$','112284','D','Si',7,0.00,0.00,'*','Activa'),('11229','Clientes Asuncion','G$','1122','D','No',5,0.00,0.00,'*','Activa'),('11229001','Leonardo Lopez Cubilla','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229002','Cristhian David Duarte Marecos','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229003','Julio Cesar Sanchez Cespedes','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229004','Camila Valentina Cristaldo Urbieta','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229005','Maria Leonida Dominguez de Rodriguez(25)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229006','Virina Benitez de Adorno(25)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229007','Maria Luisa Graciela Alonzo de Ortiz (25)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229008','Rosalba Galeano (Funcionaria)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229009','Maria Silvia Gonzalez Sarquis','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229010','Milda Yamida Benitez Riveiro','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229011','Neri Estenan Mettel Linares(25)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229012','Leandro Rodriguez Lazzini','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229013','Robert S. Clothes S.R.L.(25)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229014','Gustavo Adrian Ortega Colman','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229015','Gabino Ortiz Espinoza','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229016','Gustavo Abel Arguello Cardozo (Funcionario)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229017','Abrahan Silvano Cabrera Candia(25)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229018','Waldemar Bresanovich Unsain(25)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229019','Blue Desing S.A.E.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229020','Elba Esperanza Gomez Barrios','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229021','Tania Lorena Bendlin Gonzalez','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229022','Gustavo Marcelo Jara Frontela (Funcionario)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229023','Maria Sandra Cabrera Cabral','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229024','Rosa Marlene Franco de Achucarro','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229025','Fepisa S.A.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229026','Maria Clara Nuñez','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229027','Confort House S.A.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229028','Alto Group S.R.L.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229029','Alcides Rene Candia','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229030','Cancun S.R.L.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229031','Comercial El Cacique SRL','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229032','Jessica Victoria Baez Rodriguez','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229033','Laura Rocio Gamarra Lopez','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229034','Juan Oscar Leiva','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229035','Cipriano Estigarribia Casco','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229036','Valeria Monserrat Franco','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229037','Gilber Ariel Añasco Maldonado','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229038','Incade S.A.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229039','Alfredo Arturo Vega Berocay','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229040','Samas S.A.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229041','Leonor Elizabeth Ocampo Molas (Funcionaria)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229042','Valeria Magali Perez Caceres (Funcionaria)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229043','Tinola Borbon S.A.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229045','Celsa Ursula Alvarenga Vallejos (25)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229046','Monarca SACI (25)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229047','Carlos Travieso Romero (Distribuidora Fabricato)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229048','Marcelo Ariel Gauto (Funcionario)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229049','Patricia Baetcke Olmedo (Funcionaria)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229050','Nicanor Valdez Casco','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229051','Lezcano Osorio S.R.L.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229052','Eladio Zayas Diaz','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229053','Victor Sanchez','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229054','SEDAMA S.A.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229055','Rodelu S.A.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229056','Tienda la S.A.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229057','Mayco Lucas de Moura','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229058','Ana Liz Centurion Reyes (Funcionaria)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229059','Linda Belen Pereira Riveros (Funcionaria)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229060','Betel S.A.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229061','Wilson Daniel Leiva Sanabria','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229062','Fusion Industrial y Comercial S.A.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229063','Juan Antonio Szezerba','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229064','Maria Luz Torres de Gimenez','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229065','Diego Fabian Konther Lezcano','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229066','Jose Domingo Nuñez Ferreira','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229067','D-Life Group S.A.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229068','Industrias FYC SRL','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229069','Mas Fiesta SRL','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229070','Osvaldo Castro Copa','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229071','Edgar Gonzalez Barchello','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229072','Hipertelas S.R.L.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229073','Mano S.R.L.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229074','Young Hee Kim','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229075','Margarita Ortigoza de Cáceres','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229076','Dynasty Industrial y Comercial S.A.(25)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229077','TV Acción S.A.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229078','Gotex S.A.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229079','Industrial y Comercial San Basilio S.A.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229080','Lizeth Castro','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229081','Maria Sonia Gauto','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229082','MCCAR S.R.L.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229083','Marciana Macoritto','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229084','Global Concepts S.A.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229085','Estilo Global S.A.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229086','City Sport SRL','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229087','Maria Beatriz Sosa de Muñoz','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229088','Luciana Abente','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229089','Juan Elias Zayas Tillner (Funcionario)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('11229401','(-)Prevision Clientes con mora (>180<365) dias','G$','112294','D','Si',7,0.00,0.00,'*','Activa'),('112299','Clientes Lambare','G$','1122','D','No',5,0.00,0.00,'*','Activa'),('112299001','Angelina Lopez','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('112299002','Nilda Leticia Roman Salinas','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('112299003','Sandra Carolina Ojeda Casco','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('112299004','Cristian Rafael Peralta','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('112299005','Maria Fatima Martinez Velazquez','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('112299006','Victor Mario Barrios Francia','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('112299007','Luis Enrique Peralta Rolon','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('112299008','Angelica Vera','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('112299009','Adolfina Rios Landaida (Funcionaria)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('112299010','Marta Beatriz Ortega de Velazquez','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('112299011','Richard Andres López (Funcionario)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('112299012','Ana Carolina Berdoy Gonzalez (Funcionaria)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('112299013','Hamilkar Gonzalez Caballero (Funcionario)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('112299014','Lelly Javier Acosta Silva (30)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('112299015','Pedro Paiva Maldonado','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('112299016','Celestina Espinola de Acevedo (30)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('112299017','Osvaldo Lezcano (30)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('112299018','Juan Oscar Leiva (30)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('112299019','Carlos Antonio Nuñez Alcaraz (30)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('112299020','TST S.A.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('112299021','Nery Francisco Benitez Rodas','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('112299022','Industria de Espuma Asuncena S.A.','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('112299023','Maria Isabel Zelaya Miranda (Funcionaria)','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('112299024','Doosung Won','G$','11229','D','Si',6,0.00,0.00,'*','Activa'),('1122999','Clientes Hormiforte','G$','1122','D','No',5,0.00,0.00,'*','Activa'),('112299901','Oleaginoza Raatz S.A.','G$','1122999','D','Si',8,0.00,0.00,'*','Activa'),('112299902','Granja Avicola La Blanca S.A.','G$','1122999','D','Si',8,0.00,0.00,'*','Activa'),('112299903','Procesadora y Proveedora de Carnes y Lactosa','G$','1122999','D','Si',8,0.00,0.00,'*','Activa'),('1123','OTROS CREDITOS','G$','112','D','No',4,0.00,0.00,'*','Activa'),('11231','Cheques a Acreditar','G$','1123','D','Si',5,0.00,0.00,'*','Activa'),('11232','Tarjetas a Acreditar','G$','1123','D','Si',5,0.00,0.00,'*','Activa'),('11233','Anticipo Impuesto a la Renta','G$','1123','D','Si',5,0.00,0.00,'*','Activa'),('11234','Retención Impuesto a la Renta','G$','1123','D','Si',5,0.00,0.00,'*','Activa'),('11235','IVA Credito 5%','G$','1123','D','Si',5,0.00,0.00,'*','Activa'),('11236','IVA Credito 10 %','G$','1123','D','Si',5,0.00,0.00,'*','Activa'),('11237','Alq. Pag. por Adelantado CDE Km 3,5 U$12.176','U$','1123','D','Si',5,0.00,0.00,'*','Activa'),('11238','Alquileres Pagados por Adelantado','G$','1123','D','Si',5,0.00,0.00,'*','Activa'),('11239','Anticipo Dividendos Amin Yunis','G$','1123','D','Si',5,0.00,0.00,'*','Activa'),('1123901','Anticipo de Dividendos Maria Afara','G$','1123','D','Si',5,0.00,0.00,'*','Activa'),('112391','Inversion de Capital','G$','1123','D','Si',5,0.00,0.00,'*','Activa'),('112392','Anticipo Dividendos Jose Yunis','G$','1123','D','Si',5,0.00,0.00,'*','Activa'),('112393','Gastos Pagados por Adelantado','G$','1123','D','Si',5,0.00,0.00,'*','Activa'),('11240','Anticipo Dividendos Elias Yunis','G$','1124','D','Si',5,0.00,0.00,'*','Activa'),('11241','Anticipo al Personal','G$','1124','D','No',5,0.00,0.00,'*','Activa'),('1124101','Adelanto de Salario','G$','11241','D','Si',6,0.00,0.00,'*','Activa'),('1124102','Adelanto de Aguinaldos','G$','11241','D','Si',6,0.00,0.00,'*','Activa'),('1124103','Préstamo a funcionario','G$','11241','D','Si',6,0.00,0.00,'*','Activa'),('1124104','Asociación','G$','11241','D','Si',6,0.00,0.00,'*','Activa'),('1124105','Aporte Solidario','G$','11241','D','Si',6,0.00,0.00,'*','Activa'),('1124106','Compra de Muebles','G$','11241','D','Si',6,0.00,0.00,'*','Activa'),('1124107','Linea de Crédito','G$','11241','D','Si',6,0.00,0.00,'*','Activa'),('1124108','Uniformes','G$','11241','D','Si',6,0.00,0.00,'*','Activa'),('1124109','Tigo Corporativo','G$','11241','D','Si',6,0.00,0.00,'*','Activa'),('1124110','Pago IPS Terceros','G$','11241','D','Si',6,0.00,0.00,'*','Activa'),('11241101','Sobregiro Funcionarios','G$','11241','D','Si',6,0.00,0.00,'*','Activa'),('11241102','Capacitaciòn Funcionarios','G$','11241','D','Si',6,0.00,0.00,'*','Activa'),('11242','Anticipo Gastos a Rendir','G$','1124','D','Si',5,0.00,0.00,'*','Activa'),('11243','Retención IVA Crédito Fiscal','G$','1124','D','Si',5,0.00,0.00,'*','Activa'),('1124301','Prestamos a Texpar S.A.','G$','1124','D','Si',5,0.00,0.00,'*','Activa'),('11244','Préstamos a Socios','G$','1124','D','Si',5,0.00,0.00,'*','Activa'),('1124401','Intereses a Devengar por Prestamos Otorgados','G$','1124','D','Si',5,0.00,0.00,'*','Activa'),('11245','Seguros Pagados por Adelantado','G$','1124','D','Si',5,0.00,0.00,'*','Activa'),('11246','Garantia de Alquiler','G$','1124','D','Si',5,0.00,0.00,'*','Activa'),('11247','Prestamo Jose Yshibashi','G$','1124','D','Si',5,0.00,0.00,'*','Activa'),('11248','Prestamo Maria Yunis','G$','1124','D','Si',5,0.00,0.00,'*','Activa'),('11249','Prestamo a Terceros','G$','1124','D','Si',5,0.00,0.00,'*','Activa'),('11250','Seguro Medico Familiar Pag.por Adelantado','G$','1125','D','Si',5,0.00,0.00,'*','Activa'),('113','BIENES DE CAMBIO','G$','11','D','No',3,0.00,0.00,'*','Activa'),('1131','MERCADERIAS','G$','113','D','No',4,0.00,0.00,'*','Activa'),('11311','Mercaderias Avenida','G$','1131','D','Si',5,0.00,0.00,'*','Activa'),('11312','Mercaderias Terminal','G$','1131','D','Si',5,0.00,0.00,'*','Activa'),('11313','Mercaderías CDE KM 3,5','G$','1131','D','Si',5,0.00,0.00,'*','Activa'),('11314','Mercaderías Santa Rita','G$','1131','D','Si',5,0.00,0.00,'*','Activa'),('11315','Mercaderías Obligado','G$','1131','D','Si',5,0.00,0.00,'*','Activa'),('11316','Mercaderías CDE Centro','G$','1131','D','Si',5,0.00,0.00,'*','Activa'),('11317','Mercaderías Depósito 00','G$','1131','D','Si',5,0.00,0.00,'*','Activa'),('11318','Mercaderías Depósito 07','G$','1131','D','Si',5,0.00,0.00,'*','Activa'),('11319','Mercaderías Depósito 08','G$','1131','D','Si',5,0.00,0.00,'*','Activa'),('11320','Mercaderías Depósito 09','G$','1132','D','Si',5,0.00,0.00,'*','Activa'),('11321','Mercaderías Virtual 11','G$','1132','D','Si',5,0.00,0.00,'*','Activa'),('11322','Mercaderías Depósito 12','G$','1132','D','Si',5,0.00,0.00,'*','Activa'),('11323','Mercaderías Depósito 13','G$','1132','D','Si',5,0.00,0.00,'*','Activa'),('11324','Mercaderías San Lorenzo','G$','1132','D','Si',5,0.00,0.00,'*','Activa'),('11325','Mercaderias Asuncion','G$','1132','D','Si',5,0.00,0.00,'*','Activa'),('11326','Mercaderias Lambare','G$','1132','D','Si',5,0.00,0.00,'*','Activa'),('11330','Mercaderías Varias','G$','1133','D','Si',5,0.00,0.00,'*','Activa'),('114','ANTICIPOS','G$','11','D','Si',3,0.00,0.00,'*','Activa'),('1141','IMPORTACIONES EN CURSO','G$','114','D','No',4,0.00,0.00,'*','Activa'),('11411','Importaciones en Curso - China','G$','1141','D','Si',5,0.00,0.00,'*','Activa'),('1141100','Imp. Despacho 3355Z','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141101','Imp. Despacho 3358T','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141102','Imp. Despacho 3493T','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141103','Imp. Despacho 1014Y','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141104','Imp. Despacho 4024K','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141105','Imp.Despacho 13287V','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141106','Imp.Despacho 10502L','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141107','Imp.Despacho10127Y','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141108','Imp.Despacho 4220X','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141109','Imp.Despacho 10906T','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141110','Imp. Despacho 4253Y','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('11411100','Imp. Despacho 10905S','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141111','Imp. Despacho 0438','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141112','Imp. Despacho 11042L','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141113','Imp. Despacho 11539w','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141114','Imp. Despacho 4527S','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141115','Imp.Despacho 12290R','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141116','Imp. Despacho 04950S','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141117','Imp. Despacho 012757C','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141118','Imp. Despacho 05098W','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141119','Imp. Despacho 012910Z','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141120','Imp.Despacho 011042l-B','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141121','Imp.Despacho 05166S','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141122','Imp.Despacho 05158T','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141123','Imp. Despacho 105254Z','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141124','Imp. Despacho 05338T','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141125','Imp.Despacho 013774C','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141126','Imp. Despacho 05478B','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141127','Imp.Despacho 05782W','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141128','Imp.Despacho 874E/18','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141129','Imp.Despacho 022018N - Brasil','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141130','Imp.Despacho 06673W','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141131','Imp.Despacho 06852V','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141132','Desp. Imp.55 Bultos-Chile','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141133','Imp.Despacho 977 Bultos','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141134','Imp.Despacho 0163L','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141135','Imp.Despacho Lufamar 165 V','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141136','Imp.Despacho 0128M','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141137','Imp.Despacho 0218M','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141138','Imp.Despacho 0381N- Acetato','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141139','Imp.Despacho 0538R','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141140','Imp.Despacho 0482P','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141141','Imp. Despacho 0899E','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141142','Imp.Despacho 0465A','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141143','Imp.Despacho 01052J','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141144','Imp.Despacho 01098T','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141145','Imp.Despacho 0835R Diolen','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141146','Imp.Despacho 0639T','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141147','Imp.Despacho 01388V','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141148','Imp.Despacho 01598E','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141149','Imp.Despacho 0707P','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141150','Imp.Despacho 0929V','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141151','Imp.Despacho 0974V','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141152','Imp.Despacho 01275Z','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141153','Imp. Despacho 01022G','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141154','Imp.Despacho 01109M','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141155','Imp.Despacho 01178S','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141156','Imp. Despacho 01631M','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141157','Imp. Despacho 01228Y','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141158','Imp.Despacho 01766V','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141159','Imp.Despacho 01802M','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141160','Imp.Despacho 01705Y','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141161','Imp.Despacho 01753R','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141162','Imp. Despacho 01899P','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141163','Imp.Despacho 02785A','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141164','Imp.Despacho 54 Bultos','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141165','Imp. Mercaderìas de Panama','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141166','Imp.Despacho 04189A','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141167','Imp.Despacho 04403M','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141168','Imp.Despacho 04491T','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141169','Imp. en Curso Textela','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141170','Imp. en Curso Maquinarias','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141171','Imp. Mercaderias de Chile','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141172','Imp.Despacho 09733D','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141173','Imp.Despacho 09549X','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141174','Imp.Despacho 04755W','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141175','Imp. Rodado','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141176','Imp.Despacho 046660R','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141177','Imp. Despacho 05101X','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141178','Imp. Despacho 010901P','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141179','Imp. Estantes Brasil','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141180','Imp. Despacho 010829B','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141181','Imp. Despacho 011141M','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141182','Imp. Despacho 05516S','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141183','Imp.Despacho 05644U','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141184','Imp.Despacho 011434R','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141185','Imp.Despacho 1128 Bultos','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141186','Imp. Despacho 012005M','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141187','Imp. Despacho 012102K','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141188','Imp.Despacho Carritos de Golf','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141189','Imp.','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141190','Imp.','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141192','Imp.','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141194','Imp.','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141196','Imp.','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141197','Imp.','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141198','Imp.','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('1141199','Imp.','G$','11411','D','Si',6,0.00,0.00,'*','Activa'),('11412','Caución por Mercaderías','G$','1141','D','Si',5,0.00,0.00,'*','Activa'),('1141200','Imp. Despacho','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141201','Imp. Despacho 1131F','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141202','Imp. Despacho 1369V','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141203','Imp. Despacho 1615P','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141204','Imp. Despacho 1739W','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141205','Imp. Despacho 1626Y','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141206','Imp. Despacho 1722Y','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141207','Imp. Despacho 1850K','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141209','Imp. Despacho 2614P','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141210','Imp. Despacho 2468W','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141211','Imp. Despacho 2311J','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141212','Imp. Despacho 2314M','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141213','Imp. Despacho 3073P','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141214','Imp. Despacho 2981W','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141215','Imp. Despacho 2694A','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141216','Imp.Despacho 3446T','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141217','Imp. Despacho 3699G','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141218','Imp. Despacho 3398C','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141219','Imp.Despacho 3448V','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141220','Imp. Despacho 4058T','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141221','Imp. Despacho 3935W','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141222','Imp. Despacho 5078W','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141223','Imp. Despacho 4819B','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141224','Imp. Despacho 4358W','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141225','Imp. Despacho 1574Z','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141226','Imp. Despacho 3993D','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141227','Imp. Despacho 5092S','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141228','Imp. Despacho 6073P','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141229','Imp. Despacho 405 Bultos','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141230','Imp. Despacho 6602N','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('11412300','Imp. Despacho cma cgm','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141231','Imp. Despacho 5542S','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141232','Imp. Despacho 6028S','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141233','Imp. Despacho 3287B','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141234','Imp. Despacho 6458C','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141235','Imp. Despacho 6970B','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141236','Imp. Despacho 7096B','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141237','Imp. Despacho 8323S','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141238','Imp. Despacho 4871B','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141239','Imp. Despacho 7888K','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141240','Imp. Despacho 8793G','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141241','Imp. Despacho 4613S','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141242','Imp.Despacho 10018M','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141243','Imp.Despacho 10201G','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141244','Imp. Despacho4522N','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141245','Imp. Despacho 15168U','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141246','Imp. Despacho 1714Z','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141247','Imp. Despacho 11650P','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141248','Imp.Despacho 12230K','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141249','Imp.Despacho 12227Z','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141250','Imp. Despacho 12488C','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141251','Imp. Despacho 12860T','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141252','Imp. Despacho 17213N','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141253','Imp.Despacho 1270U','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141254','Imp. Despacho 13498E','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141255','Imp. Despacho 12915U','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141256','Imp. Despacho 22102 Bultos','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141257','Imp.Despacho 12927A','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141258','Imp. Despacho 13131L','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141259','Imp. Despacho 13051 M','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141260','Imp. Despacho 13363S','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141261','Imp. Despacho 5688C','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141262','Imp. Despacho 14220L','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141263','Imp. Despacho 40DC','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141264','Imp.Despacho 13601N','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141265','Imp. Despacho 13924V','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141266','Imp. Despacho 14267W','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141267','Imp. Despacho 14272S','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141268','Imp.Despacho 14486C','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141269','Imp. Despacho 14863B','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141270','Imp. Despacho 15964E','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141271','Imp. Despacho 6655W','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141272','Imp. Despacho 6631Z','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141273','Imp. Despacho 778 Bultos','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141274','Imp. Despacho 227Y','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141275','Imp. Despacho 2446 Bultos','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141276','Imp. Despacho 789 Bultos','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141277','Imp.Despacho 150 Bultos','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141278','Imp. Despacho 150J','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141279','Imp. Despacho 173L','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141280','Imp. Despacho 156M','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141281','Imp. Despacho 587C','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141282','Imp. Despacho 1196W','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141283','Imp. Despacho 490Y','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141284','Imp. Despacho 739U','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141285','Imp. Despacho 1335R','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141286','Imp. Despacho 1617U','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141287','Imp. Despacho 1171P','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141288','Imp. Despacho 1404Y','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141289','Imp. Despacho 2836W','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141290','Imp. Despacho 2251N','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141291','Imp. Despacho 2499E','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141292','Imp. Despacho 2646V','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141293','Imp. Despacho 3082Z','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141294','Imp.Despacho 3674A','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141295','Imp. Despacho 3962A','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141296','Imp. Desoacho 3490T','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141297','Imp. Despacho 3331N','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141298','Imp. Despacho 3350Y','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('1141299','Imp. Despacho 3604Z','G$','11412','D','Si',6,0.00,0.00,'*','Activa'),('11413','Anticipo a Proveedores U$ 615.690.-','U$','1141','D','Si',5,0.00,0.00,'*','Activa'),('1141300','Imp. Despacho 1728T','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141301','Imp. Despacho 3546V','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141302','Imp. Despacho 3450P','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141303','Imp. Despacho 4006N','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141304','Imp. Despacho 1432K','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141305','Imp. Despacho 1440J','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141306','Imp. Despacho 4596E','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141307','Imp. Despacho4290S','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141308','Imp. Despacho 5374W','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141309','Imp. Despacho 2280 Bultos','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141310','Imp. Despacho 6026R','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141311','Imp. Despacho 1788B','G$','11413','D','Si',6,0.00,0.00,'','Activa'),('1141312','Imp. Despacho 1834Z','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141313','Imp. Despacho 1919U','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141314','Imp, Despacho 690 Bultos','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141315','Imp. Despacho 5026Z','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141316','Imp. Despacho 5857F','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141317','Imp. Despacho 5529B','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141318','Imp. Despacho 5320N','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141319','Imp. Despacho2585V','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141320','Imp. Despacho 2639V','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141321','Imp.Despacho 2602L','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141322','Imp. Despacho 32 Bultos','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141323','Imp. Despacho 5913V','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141324','Imp. Despacho 01293R','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141328','Imp. Despacho XXXX','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141329','Imp.Despacho 06946C','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1141330','Imp.Despacho 070X','G$','11413','D','Si',6,0.00,0.00,'*','Activa'),('1142','GASTOS NO DEVENGADOS','G$','114','D','No',4,0.00,0.00,'*','Activa'),('11421','Insumos Varios','G$','1142','D','Si',5,0.00,0.00,'*','Activa'),('1143','ACUERDO SOCIETARIO','G$','114','D','No',4,0.00,0.00,'*','Activa'),('11431','Acuerdo Societario Victoria Afara','G$','1143','D','Si',5,0.00,0.00,'*','Activa'),('115','ANTICIPOS LOCALES','G$','11','D','No',3,0.00,0.00,'*','Activa'),('1151','PROVEEDORES LOCALES','G$','115','D','No',4,0.00,0.00,'*','Activa'),('11511','Anticipo a Proveedores Locales','G$','1151','D','Si',5,0.00,0.00,'*','Activa'),('12','ACTIVO NO CORRIENTE','G$','1','D','No',2,0.00,0.00,'*','Activa'),('121','BIENES DE USO','G$','12','D','No',3,0.00,0.00,'*','Activa'),('12101','MUEBLES Y UTILES','G$','121','D','No',4,0.00,0.00,'*','Activa'),('121011','Muebles y Utiles','G$','1210','D','Si',5,0.00,0.00,'*','Activa'),('121012','Utiles y Enseres','G$','1210','D','Si',5,0.00,0.00,'*','Activa'),('121013','- Depreciacion Acumulada','G$','1210','A','Si',5,0.00,0.00,'*','Activa'),('12102','MAQUINARIAS, HERRAMIENTAS Y EQUIPOS','G$','121','D','No',4,0.00,0.00,'*','Activa'),('121021','Maquinarias','G$','1210','D','Si',5,0.00,0.00,'*','Activa'),('121022','Herramientas y Equipos','G$','1210','D','Si',5,0.00,0.00,'*','Activa'),('121023','Equipos de Informatica','G$','1210','D','Si',5,0.00,0.00,'*','Activa'),('121024','- Depreciacion Acumulada','G$','1210','A','Si',5,0.00,0.00,'*','Activa'),('12103','TRANSPORTE TERRESTRE','G$','121','D','No',4,0.00,0.00,'*','Activa'),('121031','Rodados','G$','1210','D','Si',5,0.00,0.00,'*','Activa'),('121032','Motocicletas','G$','1210','D','Si',5,0.00,0.00,'*','Activa'),('121033','Restantes Bienes','G$','1210','D','Si',5,0.00,0.00,'*','Activa'),('121034','- Depreciacion Acumulada','G$','1210','A','Si',5,0.00,0.00,'*','Activa'),('12104','INSTALACIONES','G$','121','D','No',4,0.00,0.00,'*','Activa'),('121041','Instalaciones','G$','1210','D','Si',5,0.00,0.00,'*','Activa'),('121042','- Depreciacion Acumulada','G$','1210','A','Si',5,0.00,0.00,'*','Activa'),('12105','INSTALACIONES ELECTRICAS','G$','121','D','No',4,0.00,0.00,'*','Activa'),('121051','Instalaciones Electricas','G$','1210','D','Si',5,0.00,0.00,'*','Activa'),('121052','- Depreciacion Acumulada','G$','1210','A','Si',5,0.00,0.00,'*','Activa'),('12106','UNIFORMES','G$','121','D','No',4,0.00,0.00,'*','Activa'),('121061','Uniformes','G$','1210','D','Si',5,0.00,0.00,'*','Activa'),('121062','- Depreciacion Acumulada','G$','1210','A','Si',5,0.00,0.00,'*','Activa'),('12107','INMUEBLES','G$','121','D','No',4,0.00,0.00,'*','Activa'),('121071','Edificios','G$','1210','D','Si',5,0.00,0.00,'*','Activa'),('121072','Mejoras en Prop. Ajena','G$','1210','D','Si',5,0.00,0.00,'*','Activa'),('121073','Terreno','G$','1210','D','Si',5,0.00,0.00,'*','Activa'),('121074','Mejoras en Predio Propio','G$','1210','D','Si',5,0.00,0.00,'*','Activa'),('121075','- Depreciacion Acumulada','G$','1210','A','Si',5,0.00,0.00,'*','Activa'),('12108','EQUIPOS Y ACCESORIOS','G$','121','D','No',4,0.00,0.00,'*','Activa'),('121081','Equipos y Accesorios','G$','1210','D','Si',5,0.00,0.00,'*','Activa'),('121082','- Depreciacion Acumulada','G$','1210','A','Si',5,0.00,0.00,'*','Activa'),('12109','CARTELES','G$','121','D','No',4,0.00,0.00,'*','Activa'),('121091','Carteles','G$','1210','D','Si',5,0.00,0.00,'*','Activa'),('121092','- Depreciacion Acumulada','G$','1210','A','Si',5,0.00,0.00,'*','Activa'),('12110','ACTIVOS INTANGIBLES','G$','121','D','No',4,0.00,0.00,'*','Activa'),('121101','Software','G$','1211','D','Si',5,0.00,0.00,'*','Activa'),('121102','Amortizacion Software','G$','1211','A','Si',5,0.00,0.00,'*','Activa'),('121109','- Depreciacion Acumulada','G$','1211','A','Si',5,0.00,0.00,'*','Activa'),('122','CARGOS DIFERIDOS','G$','12','D','No',3,0.00,0.00,'*','Activa'),('1221','GASTOS DIFERIDOS','G$','122','D','No',4,0.00,0.00,'*','Activa'),('12211','Gastos de Fusion','G$','1221','D','Si',5,0.00,0.00,'*','Activa'),('12212','Amortizacion Gastos de Fusion','G$','1221','A','Si',5,0.00,0.00,'*','Activa'),('12213','Gastos de Desarrollo e Inversion','G$','1221','D','Si',5,0.00,0.00,'*','Activa'),('12214','Registro de Marca','G$','1221','D','Si',5,0.00,0.00,'*','Activa'),('12215','Amortizacion Registro de Marca','G$','1221','A','Si',5,0.00,0.00,'*','Activa'),('12219','- Amortizacion de Gastos','G$','1221','A','Si',5,0.00,0.00,'*','Activa'),('1222','OTROS DIFERIDOS','G$','122','D','No',4,0.00,0.00,'*','Activa'),('12221','Alquiler a Vencer','G$','1222','D','Si',5,0.00,0.00,'*','Activa'),('12222','Seguros a Vencer','G$','1222','D','Si',5,0.00,0.00,'*','Activa'),('12223','Intereses y Comisiones a Vencer','G$','1222','D','Si',5,0.00,0.00,'*','Activa'),('12224','Obras en Ejecución','G$','1222','D','Si',5,0.00,0.00,'*','Activa'),('12225','Obras en Ejecución - Cta.Miranda','G$','1222','D','Si',5,0.00,0.00,'*','Activa'),('12226','Insumos para Hormiforte','G$','1222','D','Si',5,0.00,0.00,'*','Activa'),('123','CREDITOS','G$','12','D','No',3,0.00,0.00,'*','Activa'),('1231','CREDITOS EN GESTION DE COBROS','G$','123','D','No',4,0.00,0.00,'*','Activa'),('12311','Caución por Mercaderías U$ 66.812.-','U$','1231','D','Si',5,0.00,0.00,'*','Activa'),('2','PASIVO','G$','','A','No',1,0.00,0.00,'*','Activa'),('21','PASIVO CORRIENTE','G$','2','A','No',2,0.00,0.00,'*','Activa'),('211','DEUDAS','G$','21','A','No',3,0.00,0.00,'*','Activa'),('2111','DEUDAS COMERCIALES','G$','211','A','No',4,0.00,0.00,'*','Activa'),('21111','Proveedores Locales','G$','2111','A','No',5,0.00,0.00,'*','Activa'),('21111001','Proveedores Locales','G$','2111100','A','Si',8,0.00,0.00,'*','Activa'),('21111002','Amado Jure S.A.C.','G$','2111100','A','Si',8,0.00,0.00,'*','Activa'),('21111003','Best Brands Paraguay S.A.','G$','2111100','A','Si',8,0.00,0.00,'*','Activa'),('21111004','Carlos Cáceres','G$','2111100','A','Si',8,0.00,0.00,'*','Activa'),('21111005','Carsisa S.A.C.','G$','2111100','A','Si',8,0.00,0.00,'*','Activa'),('21111006','Casa Brasil S.A.','G$','2111100','A','Si',8,0.00,0.00,'*','Activa'),('21111007','Casa Imperial S.A.','G$','2111100','A','Si',8,0.00,0.00,'*','Activa'),('21111008','Distribuidora Roque Pedro S.A.C.I.','G$','2111100','A','Si',8,0.00,0.00,'*','Activa'),('21111009','Doña Blanca','G$','2111100','A','Si',8,0.00,0.00,'*','Activa'),('21111010','Elias Armele S.A.','G$','2111101','A','Si',8,0.00,0.00,'*','Activa'),('21111011','Empresa C.G.L. S.A.','G$','2111101','A','Si',8,0.00,0.00,'*','Activa'),('21111012','Fashion Textil S.A.','G$','2111101','A','Si',8,0.00,0.00,'*','Activa'),('21111013','Fremar S.R.L.','G$','2111101','A','Si',8,0.00,0.00,'*','Activa'),('21111014','Gimenez Calvo S.A.C.','G$','2111101','A','Si',8,0.00,0.00,'*','Activa'),('21111015','Graciela Sanabria Almada','G$','2111101','A','Si',8,0.00,0.00,'*','Activa'),('21111016','Haida S.R.L.','G$','2111101','A','Si',8,0.00,0.00,'*','Activa'),('21111017','Hassan Waked (Confecciones Pague Menos)','G$','2111101','A','Si',8,0.00,0.00,'*','Activa'),('21111018','Ilsa Ingrid Benitez Acosta','G$','2111101','A','Si',8,0.00,0.00,'*','Activa'),('21111019','Industrias de Laminados Sintéticos S.A.','G$','2111101','A','Si',8,0.00,0.00,'*','Activa'),('21111020','Kadima S.A.','G$','2111102','A','Si',8,0.00,0.00,'*','Activa'),('21111021','Karretel S.R.L.','G$','2111102','A','Si',8,0.00,0.00,'*','Activa'),('21111022','King Tex S.A.','G$','2111102','A','Si',8,0.00,0.00,'*','Activa'),('21111023','Los Mil Colores S.R.L.','G$','2111102','A','Si',8,0.00,0.00,'*','Activa'),('21111024','Manufactura Indutex S.A.','G$','2111102','A','Si',8,0.00,0.00,'*','Activa'),('21111025','Manufactura Pilar S.A.','G$','2111102','A','Si',8,0.00,0.00,'*','Activa'),('21111026','Misael Sanchez Vazquez','G$','2111102','A','Si',8,0.00,0.00,'*','Activa'),('21111027','N.J.A. S.A.','G$','2111102','A','Si',8,0.00,0.00,'*','Activa'),('21111028','NE S.R.L.','G$','2111102','A','Si',8,0.00,0.00,'*','Activa'),('21111029','Newtex S.A.C.I.','G$','2111102','A','Si',8,0.00,0.00,'*','Activa'),('21111030','Ocean S.R.L.','G$','2111103','A','Si',8,0.00,0.00,'*','Activa'),('21111031','Paraguay Textil S.A.','G$','2111103','A','Si',8,0.00,0.00,'*','Activa'),('21111032','Politex Importaciones S.A.','G$','2111103','A','Si',8,0.00,0.00,'*','Activa'),('21111033','Punto Textil S.A.','G$','2111103','A','Si',8,0.00,0.00,'*','Activa'),('21111034','Rajsa S.A.','G$','2111103','A','Si',8,0.00,0.00,'*','Activa'),('21111035','Rolac Industrial y Comercial S.A.','G$','2111103','A','Si',8,0.00,0.00,'*','Activa'),('21111036','Sabe S.A.C.','G$','2111103','A','Si',8,0.00,0.00,'*','Activa'),('21111037','Sebastian Calvo S.A.','G$','2111103','A','Si',8,0.00,0.00,'*','Activa'),('21111038','Styletex S.A.','G$','2111103','A','Si',8,0.00,0.00,'*','Activa'),('21111039','Tendencias S.A.','G$','2111103','A','Si',8,0.00,0.00,'*','Activa'),('21111040','Unicentro S.A.','G$','2111104','A','Si',8,0.00,0.00,'*','Activa'),('21111041','Varzan Hermanos S.A.','G$','2111104','A','Si',8,0.00,0.00,'*','Activa'),('21111042','Achon Bau S.A.','G$','2111104','A','Si',8,0.00,0.00,'*','Activa'),('21111043','Smartex S.A.','G$','2111104','A','Si',8,0.00,0.00,'*','Activa'),('21111044','Lisa Ingrid Benitez Acoste (Tienda San Lorenzo)','G$','2111104','A','Si',8,0.00,0.00,'*','Activa'),('21111045','Julio Alberto Schneiderman (Los Mil Colores)','G$','2111104','A','Si',8,0.00,0.00,'*','Activa'),('21111046','Megaplastico S.A.','G$','2111104','A','Si',8,0.00,0.00,'*','Activa'),('21111047','Global Concepts SA','G$','2111104','A','Si',8,0.00,0.00,'*','Activa'),('21111048','Lisa Textil','G$','2111104','A','Si',8,0.00,0.00,'*','Activa'),('21111049','Yam Naom','G$','2111104','A','Si',8,0.00,0.00,'*','Activa'),('21111050','Said Scandar Proveedor','G$','2111105','A','Si',8,0.00,0.00,'*','Activa'),('21111051','Gredorio Luzko y Cia S.R.L.','G$','2111105','A','Si',8,0.00,0.00,'*','Activa'),('21111052','Importadora de la Victoria S.A.','G$','2111105','A','Si',8,0.00,0.00,'*','Activa'),('21111053','Maria Victoria Afara','G$','2111105','A','Si',8,0.00,0.00,'*','Activa'),('21111054','Dinamica S.A.','G$','2111105','A','Si',8,0.00,0.00,'*','Activa'),('21111055','Astro S.A.','G$','2111105','A','Si',8,0.00,0.00,'*','Activa'),('21111056','Jol Tejidos ( Juan  Oscar Leiva)','G$','2111105','A','Si',8,0.00,0.00,'*','Activa'),('21111057','Acevedo Hnos. S.A.','G$','2111105','A','Si',8,0.00,0.00,'*','Activa'),('21111058','Imab S.A.','G$','2111105','A','Si',8,0.00,0.00,'*','Activa'),('21111059','Tk Textil','G$','2111105','A','Si',8,0.00,0.00,'*','Activa'),('21111061','Mundial Telas','G$','2111106','A','Si',8,0.00,0.00,'*','Activa'),('21111062','V Y H China','G$','2111106','A','Si',8,0.00,0.00,'*','Activa'),('21111063','EMHIL SA','G$','2111106','A','Si',8,0.00,0.00,'*','Activa'),('21111064','RG COMERCIAL ( RAQUEL NOEMI GONZALEZ DIAZ)','G$','2111106','A','Si',8,0.00,0.00,'*','Activa'),('21111065','KIM`S TOWEL SACI','G$','2111106','A','Si',8,0.00,0.00,'*','Activa'),('21111066','Cynthia Baeatriz Gonzalez Martinez','G$','2111106','A','Si',8,0.00,0.00,'*','Activa'),('21111067','Itaipu Textile SA','G$','2111106','A','Si',8,0.00,0.00,'*','Activa'),('21111068','Blanca Talavera','G$','2111106','A','Si',8,0.00,0.00,'*','Activa'),('21111069','Paranatex Textil Paraguay Sa','G$','2111106','A','Si',8,0.00,0.00,'*','Activa'),('21111070','Ara Internacional SRL','G$','2111107','A','Si',8,0.00,0.00,'*','Activa'),('21111071','Acosta Stefani Trociuk y Asociados','G$','2111107','A','Si',8,0.00,0.00,'*','Activa'),('21111072','Michatex S.A.','G$','2111107','A','Si',8,0.00,0.00,'*','Activa'),('21111073','Canal Guapa SA','G$','2111107','A','Si',8,0.00,0.00,'*','Activa'),('21111074','Ferrere  Abogados','G$','2111107','A','Si',8,0.00,0.00,'*','Activa'),('21111075','Prourbe Medios SA','G$','2111107','A','Si',8,0.00,0.00,'*','Activa'),('21111076','Metalurgica San Pablo SA','G$','2111107','A','Si',8,0.00,0.00,'*','Activa'),('21111077','Auto Market SA','G$','2111107','A','Si',8,0.00,0.00,'*','Activa'),('21111078','Jose Efraim Cardozo Fiorio','G$','2111107','A','Si',8,0.00,0.00,'*','Activa'),('21111079','Grupo Fabricato','G$','2111107','A','Si',8,0.00,0.00,'*','Activa'),('21111080','Evelyn Andrea Silvero','G$','2111108','A','Si',8,0.00,0.00,'*','Activa'),('21111081','Alfa Plasticos (Rogerio Do Amaral)','G$','2111108','A','Si',8,0.00,0.00,'*','Activa'),('21111082','Lucky Import Export Sociedad Anonima','G$','2111108','A','Si',8,0.00,0.00,'*','Activa'),('21111083','Ruben Eduardo Sigaud','G$','2111108','A','Si',8,0.00,0.00,'*','Activa'),('21111084','Comercial San Luis del Sur S.A','G$','2111108','A','Si',8,0.00,0.00,'*','Activa'),('21111085','Concesionaria del Sur SRL','G$','2111108','A','Si',8,0.00,0.00,'*','Activa'),('21111086','DyF Group SA','G$','2111108','A','Si',8,0.00,0.00,'*','Activa'),('21111087','Maritime Services Line Paraguay SA','G$','2111108','A','Si',8,0.00,0.00,'*','Activa'),('21111200','Cheques Proveedores a Debitar','G$','2111120','A','Si',8,0.00,0.00,'*','Activa'),('21112','Proveedor del Exterior','G$','2111','A','Si',5,0.00,0.00,'*','Activa'),('2112','DEUDAS FINANCIERAS','G$','211','A','No',4,0.00,0.00,'*','Activa'),('21121','Prestamos Bancarios','G$','2112','A','Si',5,0.00,0.00,'*','Activa'),('21122','Intereses a Pagar a Devengar s/ Prestamo','G$','2112','A','Si',5,0.00,0.00,'*','Activa'),('21123','Prestamos Bancarios Continental SAECA','G$','2112','A','Si',5,0.00,0.00,'*','Activa'),('21124','Intereses a Pagar a Devengar s/ Prestamo','G$','2112','A','Si',5,0.00,0.00,'*','Activa'),('21125','Documentos Descontados','G$','2112','A','Si',5,0.00,0.00,'*','Activa'),('21126','Intereses a Pagar a Devengar s/ Documentos','G$','2112','A','Si',5,0.00,0.00,'*','Activa'),('21128','Sobregiros en Cta. Cte.','G$','2112','A','Si',5,0.00,0.00,'*','Activa'),('2113','DEUDAS FISCALES Y SOCIALES','G$','211','A','No',4,0.00,0.00,'*','Activa'),('21131','IVA Debito 5%','G$','2113','A','Si',5,0.00,0.00,'*','Activa'),('21132','IVA Debito 10%','G$','2113','A','Si',5,0.00,0.00,'*','Activa'),('21133','Dcion Gral de Recaudacion','G$','2113','A','Si',5,0.00,0.00,'*','Activa'),('21134','Instituto de Prevision Social','G$','2113','A','Si',5,0.00,0.00,'*','Activa'),('21135','Retencion del IVA','G$','2113','A','Si',5,0.00,0.00,'*','Activa'),('21136','Retención de Imp. a la Renta','G$','2113','A','Si',5,0.00,0.00,'*','Activa'),('2114','PROVISIONES','G$','211','A','No',4,0.00,0.00,'*','Activa'),('211401','Sueldo a Pagar','G$','2114','A','Si',5,0.00,0.00,'*','Activa'),('211402','Aportes y Retenciones a Pagar','G$','2114','A','Si',5,0.00,0.00,'*','Activa'),('211403','Honorarios a Pagar Consultoria','G$','2114','A','Si',5,0.00,0.00,'*','Activa'),('211404','Honorarios a Pagar Contabilidad','G$','2114','A','Si',5,0.00,0.00,'*','Activa'),('211405','Honorarios a Pagar Ing. Informática','G$','2114','A','Si',5,0.00,0.00,'*','Activa'),('211406','Honorarios a Pagar Asesor Jurídico','G$','2114','A','Si',5,0.00,0.00,'*','Activa'),('211407','Remuneraciones a Pagar','G$','2114','A','Si',5,0.00,0.00,'*','Activa'),('211408','Dividendos a Pagar','G$','2114','A','Si',5,0.00,0.00,'*','Activa'),('211409','Aguinaldos a Pagar','G$','2114','A','Si',5,0.00,0.00,'*','Activa'),('211410','Premios a Pagar','G$','2114','A','Si',5,0.00,0.00,'*','Activa'),('211411','IVA a Pagar','G$','2114','A','Si',5,0.00,0.00,'*','Activa'),('211412','Impuesto a la Renta a Pagar','G$','2114','A','Si',5,0.00,0.00,'*','Activa'),('211413','Dividendos a Pagar - Acumulado','G$','2114','A','Si',5,0.00,0.00,'*','Activa'),('211414','Dividendos a Pagar Victoria Afara','G$','2114','A','Si',5,0.00,0.00,'*','Activa'),('211415','Dividendos a Pagar Jose Yunis','G$','2114','A','Si',5,0.00,0.00,'*','Activa'),('211416','Dividendos a Pagar Ricardo Yunis','G$','2114','A','Si',5,0.00,0.00,'*','Activa'),('211417','Dividendos a Pagar Amin Yunis','G$','2114','A','Si',5,0.00,0.00,'*','Activa'),('211418','Dividendos a Pagar Elias Yunis','G$','2114','A','Si',5,0.00,0.00,'*','Activa'),('2115','OTRAS DEUDAS','G$','211','A','No',4,0.00,0.00,'*','Activa'),('21151','Acreedores Varios','G$','2115','A','No',5,0.00,0.00,'*','Activa'),('21151001','Adir Narasca Da Silveira','G$','2115100','A','Si',8,0.00,0.00,'*','Activa'),('21151002','Alamo S.A.','G$','2115100','A','Si',8,0.00,0.00,'*','Activa'),('21151003','ANDE','G$','2115100','A','Si',8,0.00,0.00,'*','Activa'),('21151004','Asociacion Capellania Empresarial','G$','2115100','A','Si',8,0.00,0.00,'*','Activa'),('21151005','Bancard S.A.','G$','2115100','A','Si',8,0.00,0.00,'*','Activa'),('21151006','Café Ficha S.R.L.','G$','2115100','A','Si',8,0.00,0.00,'*','Activa'),('21151007','Condor S.A.C.I.','G$','2115100','A','Si',8,0.00,0.00,'*','Activa'),('21151008','Copaco S.A.','G$','2115100','A','Si',8,0.00,0.00,'*','Activa'),('21151009','Cristian Edgar Benitez Ruiz Díaz','G$','2115100','A','Si',8,0.00,0.00,'*','Activa'),('21151010','Disal S.R.L.','G$','2115101','A','Si',8,0.00,0.00,'*','Activa'),('21151011','Editorial Azeta S.A.','G$','2115101','A','Si',8,0.00,0.00,'*','Activa'),('21151012','Emac S.R.L.','G$','2115101','A','Si',8,0.00,0.00,'*','Activa'),('21151013','Empresa Distribuidora Especializada S.A.','G$','2115101','A','Si',8,0.00,0.00,'*','Activa'),('21151014','ESSAP S.A.','G$','2115101','A','Si',8,0.00,0.00,'*','Activa'),('21151015','J. Fleischman y Cia. S.A.','G$','2115101','A','Si',8,0.00,0.00,'*','Activa'),('21151016','Los Guardianes Grupo Elite S.A.','G$','2115101','A','Si',8,0.00,0.00,'*','Activa'),('21151017','Luminotecnia S.A.','G$','2115101','A','Si',8,0.00,0.00,'*','Activa'),('21151018','Mario Espínola','G$','2115101','A','Si',8,0.00,0.00,'*','Activa'),('21151019','Monital S.R.L.','G$','2115101','A','Si',8,0.00,0.00,'*','Activa'),('21151020','Neumáticos Paraná S.R.L.','G$','2115102','A','Si',8,0.00,0.00,'*','Activa'),('21151021','Piro-y S.A.','G$','2115102','A','Si',8,0.00,0.00,'*','Activa'),('21151022','Regional Seguros S.A.','G$','2115102','A','Si',8,0.00,0.00,'*','Activa'),('21151023','Rieder y Cia S.A.','G$','2115102','A','Si',8,0.00,0.00,'*','Activa'),('21151024','Ruel S.A.','G$','2115102','A','Si',8,0.00,0.00,'*','Activa'),('21151025','Seguritec Ingenieria S.A.','G$','2115102','A','Si',8,0.00,0.00,'*','Activa'),('21151027','Silvia Gil','G$','2115102','A','Si',8,0.00,0.00,'*','Activa'),('21151028','Telecel S.A.','G$','2115102','A','Si',8,0.00,0.00,'*','Activa'),('21151029','Vane S.A.','G$','2115102','A','Si',8,0.00,0.00,'*','Activa'),('21151030','Waszaj S.R.L.','G$','2115103','A','Si',8,0.00,0.00,'*','Activa'),('21151031','Yoe Jin Enmanuel Son Lee','G$','2115103','A','Si',8,0.00,0.00,'*','Activa'),('21151032','José Ishibashi','G$','2115103','A','Si',8,0.00,0.00,'*','Activa'),('21151033','Kyung Jin Lee','G$','2115103','A','Si',8,0.00,0.00,'*','Activa'),('21151034','Transmulticarga S.A.','G$','2115103','A','Si',8,0.00,0.00,'*','Activa'),('21151035','Plastienvase S.R.L.','G$','2115103','A','Si',8,0.00,0.00,'*','Activa'),('21151036','Florencio Ayala López','G$','2115103','A','Si',8,0.00,0.00,'*','Activa'),('21151037','Jin Emanuel Son Lee(Mx Informatica)','G$','2115103','A','Si',8,0.00,0.00,'*','Activa'),('21151038','Carlino Yeza','G$','2115103','A','Si',8,0.00,0.00,'*','Activa'),('21151040','Alfa Trading SA','G$','2115104','A','Si',8,0.00,0.00,'*','Activa'),('21151041','Gilmar Becker','G$','2115104','A','Si',8,0.00,0.00,'*','Activa'),('21151042','Jose Maria Alegre( Imprenta JM)','G$','2115104','A','Si',8,0.00,0.00,'*','Activa'),('21151043','Akihiro Ishibashi','G$','2115104','A','Si',8,0.00,0.00,'*','Activa'),('21151044','Exxis Paraguay S.A.','G$','2115104','A','Si',8,0.00,0.00,'*','Activa'),('21151045','Mercoeste S.A.','G$','2115104','A','Si',8,0.00,0.00,'*','Activa'),('21151046','Mega Transport Paraguay SRL','G$','2115104','A','Si',8,0.00,0.00,'*','Activa'),('21151047','LUMI CORP','G$','2115104','A','Si',8,0.00,0.00,'*','Activa'),('21151048','Nestor Gonzalez Bartomeu','G$','2115104','A','Si',8,0.00,0.00,'*','Activa'),('21151049','Juan Alberto Bernal','G$','2115104','A','Si',8,0.00,0.00,'*','Activa'),('21151059','Rubens(Asociación)','G$','2115105','A','Si',8,0.00,0.00,'*','Activa'),('21151060','A & D S.R.L.','G$','2115106','A','Si',8,0.00,0.00,'*','Activa'),('21151061','Walid Sakhr (Condominio)','G$','2115106','A','Si',8,0.00,0.00,'*','Activa'),('21151062','Maria Remezovskiy Novosad(Multicolor Pinturas)','G$','2115106','A','Si',8,0.00,0.00,'*','Activa'),('21151063','Real Vidrios( Wilfrido Perez)','G$','2115106','A','Si',8,0.00,0.00,'*','Activa'),('21151064','Ogara Construcciones S.R.L.','G$','2115106','A','Si',8,0.00,0.00,'*','Activa'),('21151065','Serincar S.A.','G$','2115106','A','Si',8,0.00,0.00,'*','Activa'),('21151066','Editorial El Pais S.A.','G$','2115106','A','Si',8,0.00,0.00,'*','Activa'),('21151067','Equifax  Paraguay S.A.','G$','2115106','A','Si',8,0.00,0.00,'*','Activa'),('21151068','Christian Scheid','G$','2115106','A','Si',8,0.00,0.00,'*','Activa'),('21151069','Power  Link S.R.L.','G$','2115106','A','Si',8,0.00,0.00,'*','Activa'),('21151070','Cecilia Catalina Ortigoza Orrego(Graf Star?','G$','2115107','A','Si',8,0.00,0.00,'*','Activa'),('21151071','Gladiz E. Kobs E. (Ruschel)','G$','2115107','A','Si',8,0.00,0.00,'*','Activa'),('21151072','Luis Octavio Benitez (Herravic)','G$','2115107','A','Si',8,0.00,0.00,'*','Activa'),('21151073','Celia Ortigoza (Grafstar)','G$','2115107','A','Si',8,0.00,0.00,'*','Activa'),('21151075','Refilltec S.A.','G$','2115107','A','Si',8,0.00,0.00,'*','Activa'),('21151076','Icompy S.A.','G$','2115107','A','Si',8,0.00,0.00,'*','Activa'),('21151077','Anemp S.R.L.','G$','2115107','A','Si',8,0.00,0.00,'*','Activa'),('21151078','Emprendimientos Recreativos S.R.L.','G$','2115107','A','Si',8,0.00,0.00,'*','Activa'),('21151079','Glass y Co. S.A.','G$','2115107','A','Si',8,0.00,0.00,'*','Activa'),('21151080','Oscar Raul Ruschel','G$','2115108','A','Si',8,0.00,0.00,'*','Activa'),('21151081','Starsoft S.R.L.','G$','2115108','A','Si',8,0.00,0.00,'*','Activa'),('21151082','Muebles del Angel','G$','2115108','A','Si',8,0.00,0.00,'*','Activa'),('21151083','Christian David Scheid Centurion','G$','2115108','A','Si',8,0.00,0.00,'*','Activa'),('21151084','Sergio Lovel','G$','2115108','A','Si',8,0.00,0.00,'*','Activa'),('21151085','Justo Benitez','G$','2115108','A','Si',8,0.00,0.00,'*','Activa'),('21151086','Oda SRL(Restaurant Hiroshima)','G$','2115108','A','Si',8,0.00,0.00,'*','Activa'),('21151088','Ramon Antonio Delgado Ramirez','G$','2115108','A','Si',8,0.00,0.00,'*','Activa'),('21151089','Ricardo Yunis','G$','2115108','A','Si',8,0.00,0.00,'*','Activa'),('21151090','Diviportas S.A.','G$','2115109','A','Si',8,0.00,0.00,'*','Activa'),('21151091','Bartholo Transportes Representaciones S.R.L.','G$','2115109','A','Si',8,0.00,0.00,'*','Activa'),('21151092','UNAE','G$','2115109','A','Si',8,0.00,0.00,'*','Activa'),('21151093','Marrob S.R.L.','G$','2115109','A','Si',8,0.00,0.00,'*','Activa'),('21151094','Airetec S.R.L.','G$','2115109','A','Si',8,0.00,0.00,'*','Activa'),('21151095','Vidriopar S.A.','G$','2115109','A','Si',8,0.00,0.00,'*','Activa'),('21151096','Ji Hyun Chung','G$','2115109','A','Si',8,0.00,0.00,'*','Activa'),('21151097','Navarez Branda Cristian Salvador','G$','2115109','A','Si',8,0.00,0.00,'*','Activa'),('21151098','Daniel Omar Jara Rojas','G$','2115109','A','Si',8,0.00,0.00,'*','Activa'),('21151099','Digital Touch S.R.L.','G$','2115109','A','Si',8,0.00,0.00,'*','Activa'),('21151100','Jose Maria Gamarra','G$','2115110','A','Si',8,0.00,0.00,'*','Activa'),('21151101','Publicitaria Parana S.R.L.','G$','2115110','A','Si',8,0.00,0.00,'*','Activa'),('21151102','Focus Media S.A.','G$','2115110','A','Si',8,0.00,0.00,'*','Activa'),('21151103','Rafael Nicolas Gimenez EIRL','G$','2115110','A','Si',8,0.00,0.00,'*','Activa'),('21151104','Alberto Maldonado Centurion(Pigmentos)','G$','2115110','A','Si',8,0.00,0.00,'*','Activa'),('21151105','Vallcan Logistic S.A.','G$','2115110','A','Si',8,0.00,0.00,'*','Activa'),('21151106','Record Electric SAECA','G$','2115110','A','Si',8,0.00,0.00,'*','Activa'),('21151107','Eduarda Alfonso de Pranczak','G$','2115110','A','Si',8,0.00,0.00,'*','Activa'),('21151108','Group S.A. (JM Services)','G$','2115110','A','Si',8,0.00,0.00,'*','Activa'),('21151109','Jorge Torales (Grafica Elias)','G$','2115110','A','Si',8,0.00,0.00,'*','Activa'),('21151111','Casa Oliva S.R.L.','G$','2115111','A','Si',8,0.00,0.00,'*','Activa'),('21151112','Sergio David Vazquez','G$','2115111','A','Si',8,0.00,0.00,'*','Activa'),('21151113','Casa Litani S.R.L.','G$','2115111','A','Si',8,0.00,0.00,'*','Activa'),('21151114','Hotel Itapua S.R.L.','G$','2115111','A','Si',8,0.00,0.00,'*','Activa'),('21151115','Casa Dragon S.R.L.','G$','2115111','A','Si',8,0.00,0.00,'*','Activa'),('21151116','Andres Sipìliuk Denega','G$','2115111','A','Si',8,0.00,0.00,'*','Activa'),('21151117','Cesar Ramirez Troche','G$','2115111','A','Si',8,0.00,0.00,'*','Activa'),('21151118','Sair S.A.','G$','2115111','A','Si',8,0.00,0.00,'*','Activa'),('21151119','Ana Ibarra Acuña','G$','2115111','A','Si',8,0.00,0.00,'*','Activa'),('21151120','Miguel Lopatiuk','G$','2115112','A','Si',8,0.00,0.00,'*','Activa'),('21151121','Rodrigo Alberto Maldonado','G$','2115112','A','Si',8,0.00,0.00,'*','Activa'),('21151122','Maria Yunis','G$','2115112','A','Si',8,0.00,0.00,'*','Activa'),('21151123','Manpower Paraguay S.R.L.','G$','2115112','A','Si',8,0.00,0.00,'*','Activa'),('21151124','Luis Alberto Castillo','G$','2115112','A','Si',8,0.00,0.00,'*','Activa'),('21151125','Juan Alfredo Acuña Garay','G$','2115112','A','Si',8,0.00,0.00,'*','Activa'),('21151126','Carmen Avalos','G$','2115112','A','Si',8,0.00,0.00,'*','Activa'),('21151127','Grupo SIT SA','G$','2115112','A','Si',8,0.00,0.00,'*','Activa'),('21151128','Bepsa del Paraguay SAECA','G$','2115112','A','Si',8,0.00,0.00,'*','Activa'),('21151129','Keops Goup S.A.','G$','2115112','A','Si',8,0.00,0.00,'*','Activa'),('21151130','Nolberto Godoy','G$','2115113','A','Si',8,0.00,0.00,'*','Activa'),('21151131','Asistec S.A.','G$','2115113','A','Si',8,0.00,0.00,'*','Activa'),('21151132','Gloria Angelica Cardozo','G$','2115113','A','Si',8,0.00,0.00,'*','Activa'),('21151133','Diario Express S.R.L.','G$','2115113','A','Si',8,0.00,0.00,'*','Activa'),('21151134','Ceramica Schmid S.A.','G$','2115113','A','Si',8,0.00,0.00,'*','Activa'),('21151135','Transruta Courier SA','G$','2115113','A','Si',8,0.00,0.00,'*','Activa'),('21151140','Nilsa Boutique','G$','2115114','A','Si',8,0.00,0.00,'*','Activa'),('21151141','Firme SA','G$','2115114','A','Si',8,0.00,0.00,'*','Activa'),('21151142','Aguilar Asistencias','G$','2115114','A','Si',8,0.00,0.00,'*','Activa'),('21151143','Industrial Grafica','G$','2115114','A','Si',8,0.00,0.00,'*','Activa'),('21151144','HOSPICENTER SA','G$','2115114','A','Si',8,0.00,0.00,'*','Activa'),('21151145','Dionicia Lezcano','G$','2115114','A','Si',8,0.00,0.00,'*','Activa'),('21151146','La Mercantil del Este SA','G$','2115114','A','Si',8,0.00,0.00,'*','Activa'),('21151147','EGAN HEIMBORG (TRANSPORTE Y SERVICIOS)','G$','2115114','A','Si',8,0.00,0.00,'*','Activa'),('21151148','Calida ( Edita Dominiski de Melo)','G$','2115114','A','Si',8,0.00,0.00,'*','Activa'),('21151149','Patria SA de Seguros y Reaseguros','G$','2115114','A','Si',8,0.00,0.00,'*','Activa'),('21151150','Gandys SA','G$','2115115','A','Si',8,0.00,0.00,'*','Activa'),('21151151','Interocean S.R.L','G$','2115115','A','Si',8,0.00,0.00,'*','Activa'),('21151152','BARBARA SANABRIA( ESCRIBANIA)','G$','2115115','A','Si',8,0.00,0.00,'*','Activa'),('21151153','Fabrica Paraguaya de Sierras SA','G$','2115115','A','Si',8,0.00,0.00,'*','Activa'),('21151154','KUROSU & CIA','G$','2115115','A','Si',8,0.00,0.00,'*','Activa'),('21151155','SOCIEDAD PARAGUAYA DE SERVICIOS','G$','2115115','A','Si',8,0.00,0.00,'*','Activa'),('21151156','Musica y Pasion SA','G$','2115115','A','Si',8,0.00,0.00,'*','Activa'),('21151157','GRUPO LASO SA','G$','2115115','A','Si',8,0.00,0.00,'*','Activa'),('21151158','Agrologistica SA','G$','2115115','A','Si',8,0.00,0.00,'*','Activa'),('21151201','FIRE  MASTERS','G$','2115120','A','Si',8,0.00,0.00,'*','Activa'),('211512018','GRUPO SEVIPAR SAECA','G$','2115120','A','Si',8,0.00,0.00,'*','Activa'),('21151202','Adriana Noemi Aceval de Graziani','G$','2115120','A','Si',8,0.00,0.00,'*','Activa'),('21151203','Harkon Refrigeracion SRL','G$','2115120','A','Si',8,0.00,0.00,'*','Activa'),('21151204','Metalurgica Vazquez SRL','G$','2115120','A','Si',8,0.00,0.00,'*','Activa'),('21151205','Datasystems','G$','2115120','A','Si',8,0.00,0.00,'*','Activa'),('21151206','Interviajes','G$','2115120','A','Si',8,0.00,0.00,'*','Activa'),('21151207','CMA CGM PARAGUAY SRL','G$','2115120','A','Si',8,0.00,0.00,'*','Activa'),('21151208','CREAMOST','G$','2115120','A','Si',8,0.00,0.00,'*','Activa'),('21151209','SEGUPAK SA','G$','2115120','A','Si',8,0.00,0.00,'*','Activa'),('21151210','Tupi Ramos Generales','G$','2115121','A','Si',8,0.00,0.00,'*','Activa'),('21151211','Corrugadora Paraguaya','G$','2115121','A','Si',8,0.00,0.00,'*','Activa'),('21151212','Suppot SA','G$','2115121','A','Si',8,0.00,0.00,'*','Activa'),('21151213','Global Shipping','G$','2115121','A','Si',8,0.00,0.00,'*','Activa'),('21151214','Plastizil','G$','2115121','A','Si',8,0.00,0.00,'*','Activa'),('21151215','Dr. Alcides N. Ayala','G$','2115121','A','Si',8,0.00,0.00,'*','Activa'),('21151216','Nacir Miscevski','G$','2115121','A','Si',8,0.00,0.00,'*','Activa'),('21151217','Rodomaq SA','G$','2115121','A','Si',8,0.00,0.00,'*','Activa'),('21151218','Parana Pisos','G$','2115121','A','Si',8,0.00,0.00,'*','Activa'),('21151219','Evaristo Rubens Torres','G$','2115121','A','Si',8,0.00,0.00,'*','Activa'),('21151220','Post Courier','G$','2115122','A','Si',8,0.00,0.00,'*','Activa'),('21151221','Impar','G$','2115122','A','Si',8,0.00,0.00,'*','Activa'),('21151222','Hierroscenter (Fernando miguel Remezowski)','G$','2115122','A','Si',8,0.00,0.00,'*','Activa'),('21151223','Pluscargo Paraguay SA','G$','2115122','A','Si',8,0.00,0.00,'*','Activa'),('21151224','La Imprenta (Jose Antonio Leitte)','G$','2115122','A','Si',8,0.00,0.00,'*','Activa'),('21151225','Fuerte Roble SA (Encarnacion Playa)','G$','2115122','A','Si',8,0.00,0.00,'*','Activa'),('21151226','Sancor Seguros del Paraguay','G$','2115122','A','Si',8,0.00,0.00,'*','Activa'),('21151227','NAVEMAR SA','G$','2115122','A','Si',8,0.00,0.00,'*','Activa'),('21151228','Miro Glassmann( Mecanica Estrella)','G$','2115122','A','Si',8,0.00,0.00,'*','Activa'),('21151229','Procard','G$','2115122','A','Si',8,0.00,0.00,'*','Activa'),('21151230','Ingenio Tecnologias SRL','G$','2115123','A','Si',8,0.00,0.00,'*','Activa'),('21151231','NJA S.A','G$','2115123','A','Si',8,0.00,0.00,'*','Activa'),('21151232','Ruta 10 SRL','G$','2115123','A','Si',8,0.00,0.00,'*','Activa'),('21151399','Otros Acreedores','G$','2115139','A','Si',8,0.00,0.00,'*','Activa'),('21151400','Cheques Acreedores a Debitar','G$','2115140','A','Si',8,0.00,0.00,'*','Activa'),('2116','PRESTAMOS PARTICULARES','G$','211','A','No',4,0.00,0.00,'*','Activa'),('21161','Prestamo America Maciel','G$','2116','A','Si',5,0.00,0.00,'*','Activa'),('21162','Prestamo Jose Yunis','G$','2116','A','Si',5,0.00,0.00,'*','Activa'),('2117','OTROS PASIVOS','G$','211','A','No',4,0.00,0.00,'*','Activa'),('21171','Anticipo de Clientes','G$','2117','A','Si',5,0.00,0.00,'*','Activa'),('22','PASIVOS NO CORRIENTE','G$','2','A','No',2,0.00,0.00,'*','Activa'),('221','PROVISIONES','G$','22','A','No',3,0.00,0.00,'*','Activa'),('2211','PROVISION Y PREVISION','G$','221','A','No',4,0.00,0.00,'*','Activa'),('22111','Provision para Despido','G$','2211','A','Si',5,0.00,0.00,'*','Activa'),('22112','Provision para Diferencia de Cambios','G$','2211','A','Si',5,0.00,0.00,'*','Activa'),('22113','Ganancias Diferidas por Mercaderías','G$','2211','A','Si',5,0.00,0.00,'*','Activa'),('222','UTILIDADES DIFERIDAS','G$','22','A','No',3,0.00,0.00,'*','Activa'),('2221','UTILIDADES DIFERIDAS S/ VENTAS','G$','222','A','No',4,0.00,0.00,'*','Activa'),('22211','Utilidades Diferidas s/ Ventas a Plazo','G$','2221','A','Si',5,0.00,0.00,'*','Activa'),('223','PRESTAMOS','G$','22','A','No',3,0.00,0.00,'*','Activa'),('2231','PRESTAMOS BANCARIOS','G$','223','A','No',4,0.00,0.00,'*','Activa'),('22311','Prestamos Banco Regional SAECA','G$','2231','A','Si',5,0.00,0.00,'*','Activa'),('22312','Prestamos Banco Largo Plazo','G$','2231','A','Si',5,0.00,0.00,'*','Activa'),('22315','Intereses a Devengar Bancos','G$','2231','A','Si',5,0.00,0.00,'*','Activa'),('2232','PRESTAMOS PARTICULARES','G$','223','A','No',4,0.00,0.00,'*','Activa'),('22321','Prestamo Particular - U$D 250.000.-','U$','2232','A','Si',5,0.00,0.00,'*','Activa'),('22322','Intereses a Devengar Particulares-U$D 12.000.-','U$','2232','A','Si',5,0.00,0.00,'*','Activa'),('22323','Prestamo Amin Yunis','G$','2232','A','Si',5,0.00,0.00,'*','Activa'),('3','PATRIMONIO NETO','G$','','A','No',1,0.00,0.00,'*','Activa'),('33','CAPITAL RESERVAS Y RESULTADOS','G$','3','A','No',2,0.00,0.00,'*','Activa'),('331','CAPITAL SOCIAL','G$','33','A','No',3,0.00,0.00,'*','Activa'),('3311','Capital Integrado','G$','331','A','Si',4,0.00,0.00,'*','Activa'),('3312','Capital Suscripto','G$','331','A','Si',4,0.00,0.00,'*','Activa'),('3313','Capital Realizado','G$','331','A','Si',4,0.00,0.00,'*','Activa'),('332','RESERVAS','G$','33','A','No',3,0.00,0.00,'*','Activa'),('3321','Reserva de Revaluo','G$','332','A','Si',4,0.00,0.00,'*','Activa'),('3322','Reserva Legal','G$','332','A','Si',4,0.00,0.00,'*','Activa'),('3323','Reserva Facultativa','G$','332','A','Si',4,0.00,0.00,'*','Activa'),('333','RESULTADOS','G$','33','A','No',3,0.00,0.00,'*','Activa'),('3331','Resultados Acumulados','G$','333','A','Si',4,0.00,0.00,'*','Activa'),('3332','Resultado del Ejercicio','G$','333','A','Si',4,0.00,0.00,'*','Activa'),('4','INGRESOS','G$','','A','No',1,0.00,0.00,'*','Activa'),('41','INGRESOS OPERATIVOS','G$','4','A','No',2,0.00,0.00,'*','Activa'),('411','VENTAS DE MERCADERIAS Y SERVICIOS','G$','41','A','No',3,0.00,0.00,'*','Activa'),('4111','VENTAS DE MERCADERIAS','G$','411','A','No',4,0.00,0.00,'*','Activa'),('41111','Ventas de Mercaderias','G$','4111','A','Si',5,0.00,0.00,'*','Activa'),('41112','Ventas de Mercaderias Sector Público','G$','4111','A','Si',5,0.00,0.00,'*','Activa'),('41113','Ventas de Mercaderias Suc. Avenida','G$','4111','A','Si',5,0.00,0.00,'02','Activa'),('41114','Ventas de Mercaderias Suc. Terminal','G$','4111','A','Si',5,0.00,0.00,'01','Activa'),('41115','Ventas de Mercaderias Suc. CDE Km. 3,5','G$','4111','A','Si',5,0.00,0.00,'*','Activa'),('41116','Ventas de Mercaderias Suc. Santa Rita','G$','4111','A','Si',5,0.00,0.00,'*','Activa'),('41117','Ventas de Mercaderias Suc. Obligado','G$','4111','A','Si',5,0.00,0.00,'*','Activa'),('41118','Ventas de Mercaderias CDE Centro','G$','4111','A','Si',5,0.00,0.00,'*','Activa'),('41119','Ventas de Mercaderías Suc. San Lorenzo','G$','4111','A','Si',5,0.00,0.00,'*','Activa'),('411191','Ventas de Mercaderias Asuncion','G$','4111','A','Si',5,0.00,0.00,'*','Activa'),('411192','Venta de Mercaderias Lambare','G$','4111','A','Si',5,0.00,0.00,'*','Activa'),('411193','Ventas Externas','G$','4111','A','Si',5,0.00,0.00,'*','Activa'),('411194','Ventas Servicios de Hormiforte','G$','4111','A','Si',5,0.00,0.00,'*','Activa'),('4112','COSTO DE MERCEDERIAS VENDIDAS','G$','411','D','No',4,0.00,0.00,'*','Activa'),('41121','Costo de Mercaderias Avenida','G$','4112','D','Si',5,0.00,0.00,'*','Activa'),('41122','Costo de Mercaderia Terminal','G$','4112','D','Si',5,0.00,0.00,'*','Activa'),('41123','Costo de Mercaderia CDE km 3,5','G$','4112','D','Si',5,0.00,0.00,'*','Activa'),('41124','Costo de Mercaderia Santa Rita','G$','4112','D','Si',5,0.00,0.00,'*','Activa'),('41125','Costo de Mercaderia Obligado','G$','4112','D','Si',5,0.00,0.00,'*','Activa'),('41126','Costo de Mercaderia CDE Centro','G$','4112','D','Si',5,0.00,0.00,'*','Activa'),('41127','Costo de Mercadería San Lorenzo','G$','4112','D','Si',5,0.00,0.00,'*','Activa'),('41128','Costo de Mercaderias Asuncion','G$','4112','D','Si',5,0.00,0.00,'*','Activa'),('41129','Costo de Venta Lambare','G$','4112','D','Si',5,0.00,0.00,'*','Activa'),('4112901','Costo Ventas Externas','G$','4112','D','Si',5,0.00,0.00,'*','Activa'),('412','OTROS INGRESOS','G$','41','A','No',3,0.00,0.00,'*','Activa'),('41211','Descuentos Obtenidos','G$','4121','A','Si',5,0.00,0.00,'*','Activa'),('41212','Alquileres Cobrados','G$','4121','A','Si',5,0.00,0.00,'*','Activa'),('41213','Intereses Cobrados','G$','4121','A','Si',5,0.00,0.00,'*','Activa'),('41214','Ingresos Varios','G$','4121','A','Si',5,0.00,0.00,'*','Activa'),('41215','Sobrante en Caja','G$','4121','A','Si',5,0.00,0.00,'*','Activa'),('41216','Recupero de Previsión sobre Clientes','G$','4121','A','Si',5,0.00,0.00,'*','Activa'),('41217','Diferencia de Cambio-Ventas','G$','4121','A','Si',5,0.00,0.00,'*','Activa'),('41218','Diferencia de Cambio-Prestamo Valuacion','G$','4121','A','Si',5,0.00,0.00,'*','Activa'),('41219','Diferencia de Cambio-Proveedores Locales','G$','4121','A','Si',5,0.00,0.00,'*','Activa'),('412191','Diferencia de Cambio-Proveedores Internacionales','G$','4121','A','Si',5,0.00,0.00,'*','Activa'),('412192','Diferencia de Cambio-Bancos','G$','4121','A','Si',5,0.00,0.00,'*','Activa'),('412193','Ventas de Activos Fijos','G$','4121','A','Si',5,0.00,0.00,'*','Activa'),('412195','Costos de Ventas Activos Fijos','G$','4121','A','Si',5,0.00,0.00,'*','Activa'),('412196','Recupero de Intereses por Socios','G$','4121','A','Si',5,0.00,0.00,'*','Activa'),('412197','Ajuste Positivo de Stock','G$','4121','A','Si',5,0.00,0.00,'*','Activa'),('5','EGRESOS','G$','','D','No',1,0.00,0.00,'*','Activa'),('51','EGRESOS OPERATIVOS','G$','5','D','No',2,0.00,0.00,'*','Activa'),('511','GASTOS DE COMERCIALIZACION','G$','51','D','No',3,0.00,0.00,'*','Activa'),('5111','GASTOS DE VENTAS','G$','511','D','No',4,0.00,0.00,'*','Activa'),('51111','Premios Pagados','G$','5111','D','Si',5,0.00,0.00,'*','Activa'),('51112','Descuentos Concedidos','G$','5111','D','Si',5,0.00,0.00,'*','Activa'),('51113','Descuentos Concedidos Cat.1','G$','5111','D','Si',5,0.00,0.00,'*','Activa'),('51114','Descuentos Concedidos Cat.2','G$','5111','D','Si',5,0.00,0.00,'*','Activa'),('51115','Comisiones Pagadas por Tarjetas','G$','5111','D','Si',5,0.00,0.00,'*','Activa'),('51116','Alquiler de Pos','G$','5111','D','Si',5,0.00,0.00,'*','Activa'),('51117','Publicidad Televisiva','G$','5111','D','Si',5,0.00,0.00,'*','Activa'),('51118','Publicidad Escrita','G$','5111','D','Si',5,0.00,0.00,'*','Activa'),('51119','Publicidad Radial','G$','5111','D','Si',5,0.00,0.00,'*','Activa'),('5111901','Publicidad en Redes Sociales','G$','5111','A','Si',5,0.00,0.00,'*','Activa'),('511191','Diferencia de Cambio-Valuacion Prestamo','G$','5111','D','Si',5,0.00,0.00,'*','Activa'),('511192','Diferencia de Cambio-Proveedores','G$','5111','D','Si',5,0.00,0.00,'*','Activa'),('511193','Diferencia de Cambio-Proveedores Internacionales','G$','5111','D','Si',5,0.00,0.00,'*','Activa'),('511194','Diferencia de Cambio-Bancos','G$','5111','D','Si',5,0.00,0.00,'*','Activa'),('51120','Diferencia de Cambio-Ventas','G$','5112','D','Si',5,0.00,0.00,'*','Activa'),('51121','Publicidad Carteles y Pasacalles','G$','5112','D','Si',5,0.00,0.00,'*','Activa'),('51122','Auspicios y Participacion','G$','5112','D','Si',5,0.00,0.00,'*','Activa'),('51123','Impresiones Publicitarias','G$','5112','D','Si',5,0.00,0.00,'*','Activa'),('51124','Obsequios Publicitarios','G$','5112','D','Si',5,0.00,0.00,'*','Activa'),('51125','Descuentos en Caja','G$','5112','D','Si',5,0.00,0.00,'*','Activa'),('51126','Afectación de Previsión sobre Clientes','G$','5112','D','Si',5,0.00,0.00,'*','Activa'),('51127','Comisiones por Giros Cambios Chaco','G$','5112','D','Si',5,0.00,0.00,'*','Activa'),('5112701','Comisiones por transf.al Exterior','G$','5112','D','Si',5,0.00,0.00,'*','Activa'),('51128','Comisiones Pagadas Vendedores Externos','G$','5112','D','Si',5,0.00,0.00,'*','Activa'),('51129','Cafeteria','G$','5112','D','Si',5,0.00,0.00,'*','Activa'),('51130','Fletes Pagados por Distribución y Ventas','G$','5113','D','Si',5,0.00,0.00,'*','Activa'),('51131','Bolsitas','G$','5113','D','Si',5,0.00,0.00,'*','Activa'),('51132','Accesorios para Salon','G$','5113','D','Si',5,0.00,0.00,'*','Activa'),('51133','Muestrarios','G$','5113','D','Si',5,0.00,0.00,'*','Activa'),('51134','Insumos para Confecciones','G$','5113','D','Si',5,0.00,0.00,'*','Activa'),('51135','Servicios de Confecciones','G$','5113','D','Si',5,0.00,0.00,'*','Activa'),('51136','Informconf','G$','5113','D','Si',5,0.00,0.00,'*','Activa'),('51137','Registro de Firmas en Aduanas','G$','5113','D','Si',5,0.00,0.00,'*','Activa'),('51138','Estudio de Mercado','G$','5113','D','Si',5,0.00,0.00,'*','Activa'),('51139','Fletes Nacionales por Compras de Mercaderias','G$','5113','D','Si',5,0.00,0.00,'*','Activa'),('51140','Seguros sobre Mercaderias','G$','5114','D','Si',5,0.00,0.00,'*','Activa'),('51141','Comision Asesor Juridico','G$','5114','D','Si',5,0.00,0.00,'*','Activa'),('51142','Pérdida por Créditos Incobrables','G$','5114','D','Si',5,0.00,0.00,'*','Activa'),('51143','Comisión por Servicios de Hormiforte','G$','5114','D','Si',5,0.00,0.00,'*','Activa'),('512','GASTOS FINANCIEROS','G$','51','D','No',3,0.00,0.00,'*','Activa'),('5121','GASTOS BANCARIOS Y NO BANCARIOS','G$','512','D','No',4,0.00,0.00,'*','Activa'),('51211','Gastos Bancarios','G$','5121','D','Si',5,0.00,0.00,'*','Activa'),('51212','Sobregiro en Cuenta','G$','5121','D','Si',5,0.00,0.00,'*','Activa'),('51213','Comisiones por Prestamos','G$','5121','D','Si',5,0.00,0.00,'*','Activa'),('51214','Otros Intereses','G$','5121','D','Si',5,0.00,0.00,'*','Activa'),('51215','Interese Tarjeta de Credito','G$','5121','D','Si',5,0.00,0.00,'*','Activa'),('5122','GASTOS POR PRESTAMOS','G$','512','D','No',4,0.00,0.00,'*','Activa'),('51221','Intereses Pagados por Préstamos Bancarios','G$','5122','D','Si',5,0.00,0.00,'*','Activa'),('51222','Intereses Pagados por Préstamos Particulares','G$','5122','D','Si',5,0.00,0.00,'*','Activa'),('51223','Intereses Pagados por Documentos Descontados','G$','5122','D','Si',5,0.00,0.00,'*','Activa'),('51224','Int. Moratorios y Punitorios por Prestamos','G$','5122','D','Si',5,0.00,0.00,'*','Activa'),('513','GASTOS ADMINISTRATIVOS','G$','51','D','No',3,0.00,0.00,'*','Activa'),('5131','SUELDOS Y CARGAS SOCIALES','G$','513','D','No',4,0.00,0.00,'*','Activa'),('513101','Sueldos y Jornales','G$','5131','D','Si',5,0.00,0.00,'*','Activa'),('513102','Aporte Patronal IPS','G$','5131','D','Si',5,0.00,0.00,'*','Activa'),('513103','Aguinaldos','G$','5131','D','Si',5,0.00,0.00,'*','Activa'),('513104','Indemnizaciones','G$','5131','D','Si',5,0.00,0.00,'*','Activa'),('513105','Vacaciones','G$','5131','D','Si',5,0.00,0.00,'*','Activa'),('513106','Preaviso','G$','5131','D','Si',5,0.00,0.00,'*','Activa'),('513107','MJT Planilla Semestral','G$','5131','D','Si',5,0.00,0.00,'*','Activa'),('513108','Cursos de Capacitacion','G$','5131','D','Si',5,0.00,0.00,'*','Activa'),('513109','Primeros Auxilios','G$','5131','D','Si',5,0.00,0.00,'*','Activa'),('513110','Recibo de Salario','G$','5131','D','Si',5,0.00,0.00,'*','Activa'),('513111','Uniforme del Personal','G$','5131','D','Si',5,0.00,0.00,'*','Activa'),('513112','Estetica del Personal','G$','5131','D','Si',5,0.00,0.00,'*','Activa'),('513113','Festejos - Cumpleaños','G$','5131','D','Si',5,0.00,0.00,'*','Activa'),('513114','Festejos de Fin de Año','G$','5131','D','Si',5,0.00,0.00,'*','Activa'),('513115','Festejo dia del Trabajador','G$','5131','D','Si',5,0.00,0.00,'*','Activa'),('513116','Reclutamiento del Personal','G$','5131','D','Si',5,0.00,0.00,'*','Activa'),('513117','Pago Merienda del Personal','G$','5131','D','Si',5,0.00,0.00,'*','Activa'),('513118','Remuneracion Personal Superior','G$','5131','D','Si',5,0.00,0.00,'*','Activa'),('513119','Homologacion de Contratos','G$','5131','D','Si',5,0.00,0.00,'*','Activa'),('513120','Gastos de Admision IPS','G$','5131','D','Si',5,0.00,0.00,'*','Activa'),('5132','HONORARIOS PROFESIONALES','G$','513','D','No',4,0.00,0.00,'*','Activa'),('51321','Honorarios por Servicios Contables','G$','5132','D','Si',5,0.00,0.00,'*','Activa'),('51322','Honorarios por Asesoramiento Jurídico','G$','5132','D','Si',5,0.00,0.00,'*','Activa'),('51323','Honorarios por Auditoria Externa','G$','5132','D','Si',5,0.00,0.00,'*','Activa'),('51324','Honorarios por Consultoria','G$','5132','D','Si',5,0.00,0.00,'*','Activa'),('51325','Honorarios Ing.Informático','G$','5132','D','Si',5,0.00,0.00,'*','Activa'),('51326','Honorario por Asesoria de RR.HH','G$','5132','D','Si',5,0.00,0.00,'*','Activa'),('5133','IMPRESOS Y UTILES','G$','513','D','No',4,0.00,0.00,'*','Activa'),('51331','Utiles de Oficina','G$','5133','D','Si',5,0.00,0.00,'*','Activa'),('51332','Papeleria','G$','5133','D','Si',5,0.00,0.00,'*','Activa'),('5134','ALQUILERES PAGADOS','G$','513','D','No',4,0.00,0.00,'*','Activa'),('51341','Alquileres Pagados por Inmuebles','G$','5134','D','Si',5,0.00,0.00,'*','Activa'),('51342','Alquileres Pagados','G$','5134','D','Si',5,0.00,0.00,'*','Activa'),('51343','Pago de Condominio','G$','5134','D','Si',5,0.00,0.00,'*','Activa'),('5135','SERVICIOS BASICOS','G$','513','D','No',4,0.00,0.00,'*','Activa'),('51351','Luz','G$','5135','D','Si',5,0.00,0.00,'*','Activa'),('51352','Agua','G$','5135','D','Si',5,0.00,0.00,'*','Activa'),('51353','Telefono','G$','5135','D','Si',5,0.00,0.00,'*','Activa'),('51354','Internet','G$','5135','D','Si',5,0.00,0.00,'*','Activa'),('51355','Servicio de Seguridad','G$','5135','D','Si',5,0.00,0.00,'*','Activa'),('51356','Monitoreo taller Alarma','G$','5135','D','Si',5,0.00,0.00,'*','Activa'),('51357','Tigo Corporativo','G$','5135','D','Si',5,0.00,0.00,'*','Activa'),('51358','Gastos de Comunicacion','G$','5135','D','Si',5,0.00,0.00,'*','Activa'),('5136','REPARACION Y MANTENIMIENTO','G$','513','D','No',4,0.00,0.00,'*','Activa'),('51361','Mantenimiento Pintura Local','G$','5136','D','Si',5,0.00,0.00,'*','Activa'),('51362','Plomeria','G$','5136','D','Si',5,0.00,0.00,'*','Activa'),('51363','Reparacion Estructura Local (Techo, pared)','G$','5136','D','Si',5,0.00,0.00,'*','Activa'),('51364','Reparación e Instalaciones Electricas','G$','5136','D','Si',5,0.00,0.00,'*','Activa'),('51365','Reparación Puertas y Vidriales','G$','5136','D','Si',5,0.00,0.00,'*','Activa'),('51366','Reparación Muebles y Equipos','G$','5136','D','Si',5,0.00,0.00,'*','Activa'),('51367','Rep.y Mant. Aire Acondicionado','G$','5136','D','Si',5,0.00,0.00,'*','Activa'),('51368','Rep.y Mant. Rodados','G$','5136','D','Si',5,0.00,0.00,'*','Activa'),('51369','Rep.y Mant. Maquinarias','G$','5136','D','Si',5,0.00,0.00,'*','Activa'),('513691','Gastos de Ornamentacion','G$','5136','D','Si',5,0.00,0.00,'*','Activa'),('513692','Refacciones','G$','5136','D','Si',5,0.00,0.00,'*','Activa'),('5137','GASTOS DE MOVILIDAD','G$','513','D','No',4,0.00,0.00,'*','Activa'),('51371','Combustibles y Lubricantes','G$','5137','D','Si',5,0.00,0.00,'*','Activa'),('51372','Pasaje Traslado de Personas','G$','5137','D','Si',5,0.00,0.00,'*','Activa'),('51373','Hospedaje','G$','5137','D','Si',5,0.00,0.00,'*','Activa'),('51374','Consumición','G$','5137','D','Si',5,0.00,0.00,'*','Activa'),('51375','Estacionamiento','G$','5137','D','Si',5,0.00,0.00,'*','Activa'),('51376','Peajes','G$','5137','D','Si',5,0.00,0.00,'*','Activa'),('51377','Costos Operativo Viajes al Exterior','G$','5137','D','Si',5,0.00,0.00,'*','Activa'),('5138','IMPUESTOS, PATENTES Y TASAS','G$','513','D','No',4,0.00,0.00,'*','Activa'),('51381','Patentes e Impuestos','G$','5138','D','Si',5,0.00,0.00,'*','Activa'),('51382','Tasas Municipales','G$','5138','D','Si',5,0.00,0.00,'*','Activa'),('51383','Multas','G$','5138','D','Si',5,0.00,0.00,'*','Activa'),('51384','Impuesto al Valor Agregado (IVA)','G$','5138','D','Si',5,0.00,0.00,'*','Activa'),('51385','Impuesto a la Renta','G$','5138','D','Si',5,0.00,0.00,'*','Activa'),('51386','Impuesto Inmobiliario','G$','5138','D','Si',5,0.00,0.00,'*','Activa'),('51387','Impuesto 5% Dist. Util. GND','G$','5138','D','Si',5,0.00,0.00,'*','Activa'),('51388','Tasas Judiciales','G$','5138','D','Si',5,0.00,0.00,'*','Activa'),('5139','OTROS GASTOS ADMINISTRATIVOS','G$','513','D','No',4,0.00,0.00,'*','Activa'),('513901','Donaciones y Contribucion','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513902','Seguros Pagados','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513903','Accesorios para Computadora','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513904','Cartuchos y Tinta p/ Impresoras','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513905','Soporte Informático','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513906','Rep.y Mant. Equipos de Informatica','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513907','Servicios de Limpieza','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513908','Articulos de Limpieza','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513909','Aromatizadores','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513910','Capellania','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513911','Gastos de Escribania','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513912','Servicio de Tasación','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513913','Agua Mineral','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513914','Vasos y Servilletas','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513915','Camara de Comercio','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513916','Topografia','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513917','Recarga de Extintores','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513918','Servicio de Fumigacion','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513919','Gastos de Registro Insustrial','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513920','Levantamiento Hipoteca','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513921','Gastos de Seguridad','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513922','Gastos de Inventario','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513923','Aso. Ind. Confeccionistas del Py.','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513924','Gastos de Hipoteca','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513925','Seguro Medico Familiar','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513926','Gastos de Fusion','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513927','Gastos de Licencia Ambiental','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('513928','Software','G$','5139','D','Si',5,0.00,0.00,'*','Activa'),('514','GASTOS OPERACIONALES','G$','51','D','No',3,0.00,0.00,'*','Activa'),('5141','GASTOS OPERACIONALES','G$','514','D','No',4,0.00,0.00,'*','Activa'),('514101','Cintas e Hilos de Embalar','G$','5141','D','Si',5,0.00,0.00,'*','Activa'),('514102','Lavanderia','G$','5141','D','Si',5,0.00,0.00,'*','Activa'),('514103','Servicio de Courrier','G$','5141','D','Si',5,0.00,0.00,'*','Activa'),('514104','Proveedores Fardos','G$','5141','D','Si',5,0.00,0.00,'*','Activa'),('514105','Afilado de Tijeras','G$','5141','D','Si',5,0.00,0.00,'*','Activa'),('514106','Precinta','G$','5141','D','Si',5,0.00,0.00,'*','Activa'),('514107','Caños','G$','5141','D','Si',5,0.00,0.00,'*','Activa'),('514108','Gomitas','G$','5141','D','Si',5,0.00,0.00,'*','Activa'),('514109','Tablitas','G$','5141','D','Si',5,0.00,0.00,'*','Activa'),('514110','Pallet','G$','5141','D','Si',5,0.00,0.00,'*','Activa'),('514111','Gastos de Codificacion','G$','5141','D','Si',5,0.00,0.00,'*','Activa'),('514112','Fletes Pagados','G$','5141','D','Si',5,0.00,0.00,'*','Activa'),('514113','Costos Manipuleo Contenedor','G$','5141','D','Si',5,0.00,0.00,'*','Activa'),('514114','XXXXXXX','G$','5141','D','Si',5,0.00,0.00,'*','Activa'),('514115','Tijeras','G$','5141','D','Si',5,0.00,0.00,'*','Activa'),('514116','Cintas Metricas','G$','5141','D','Si',5,0.00,0.00,'*','Activa'),('514119','Utiles Varios','G$','5141','D','Si',5,0.00,0.00,'*','Activa'),('514120','Gastos Varios','G$','5141','D','Si',5,0.00,0.00,'*','Activa'),('514121','Mermas','G$','5141','D','Si',5,0.00,0.00,'*','Activa'),('514122','Cartones para Sabanas','G$','5141','D','Si',5,0.00,0.00,'*','Activa'),('518','GASTOS NO DED. AMORTIZ, DEPRECIACIONES','G$','51','D','No',3,0.00,0.00,'*','Activa'),('5181','GASTOS NO DEDUCIBLES','G$','518','D','No',4,0.00,0.00,'*','Activa'),('51811','Recargos y Multas','G$','5181','D','Si',5,0.00,0.00,'*','Activa'),('51812','Reserva Legal','G$','5181','D','Si',5,0.00,0.00,'*','Activa'),('51813','Impuesto a la Renta Ley 125/91','G$','5181','D','Si',5,0.00,0.00,'*','Activa'),('51814','Gastos No Deducibles','G$','5181','D','Si',5,0.00,0.00,'*','Activa'),('5182','AMORTIZACIONES','G$','518','D','No',4,0.00,0.00,'*','Activa'),('51821','Amortiz. B.P. Gtos Deducibles','G$','5182','D','Si',5,0.00,0.00,'*','Activa'),('5183','DEPRECIACIONES','G$','5183','D','No',5,0.00,0.00,'*','Activa'),('51831','Depreciacion del Ejercicio','G$','5183','D','Si',5,0.00,0.00,'*','Activa'),('51832','Depreciacion del Ejercicio GND','G$','5183','D','Si',5,0.00,0.00,'*','Activa'),('519','RESULTADO DEL EJERCICIO','G$','51','D','No',3,0.00,0.00,'*','Activa'),('5191','PERDIDAS Y GANANCIAS','G$','519','D','No',4,0.00,0.00,'*','Activa'),('51911','Resultado a la Fecha','G$','5191','D','Si',5,0.00,0.00,'*','Activa');

/*Table structure for table `politica_cortes` */

DROP TABLE IF EXISTS `politica_cortes`;

CREATE TABLE `politica_cortes` (
  `codigo` varchar(30) NOT NULL,
  `suc` varchar(10) NOT NULL,
  `politica` int(11) DEFAULT NULL,
  `presentacion` varchar(16) DEFAULT NULL,
  `estado` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`codigo`,`suc`),
  KEY `Ref18214` (`suc`),
  KEY `Ref119215` (`codigo`),
  CONSTRAINT `Refarticulos215` FOREIGN KEY (`codigo`) REFERENCES `articulos` (`codigo`),
  CONSTRAINT `Refsucursales214` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `politica_cortes` */

/*Table structure for table `prod_terminado` */

DROP TABLE IF EXISTS `prod_terminado`;

CREATE TABLE `prod_terminado` (
  `id_res` int(11) NOT NULL AUTO_INCREMENT,
  `nro_emis` int(11) DEFAULT NULL,
  `nro_orden` int(11) DEFAULT NULL,
  `codigo` varchar(10) DEFAULT NULL,
  `lote` varchar(30) DEFAULT NULL,
  `descrip` varchar(60) DEFAULT NULL,
  `color` varchar(30) DEFAULT NULL,
  `design` varchar(30) DEFAULT NULL,
  `cant_frac` decimal(16,2) DEFAULT NULL,
  `usuario` varchar(30) NOT NULL,
  `fecha` datetime DEFAULT NULL,
  PRIMARY KEY (`id_res`),
  KEY `Ref85156` (`nro_orden`,`nro_emis`),
  KEY `Ref6185` (`usuario`),
  KEY `Refemis_produc156` (`nro_emis`,`nro_orden`),
  CONSTRAINT `Refemis_produc156` FOREIGN KEY (`nro_emis`, `nro_orden`) REFERENCES `emis_produc` (`nro_emis`, `nro_orden`),
  CONSTRAINT `Refusuarios185` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `prod_terminado` */

/*Table structure for table `prop_x_art` */

DROP TABLE IF EXISTS `prop_x_art`;

CREATE TABLE `prop_x_art` (
  `codigo` varchar(30) NOT NULL,
  `cod_prop` varchar(30) NOT NULL,
  `valor` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`codigo`,`cod_prop`),
  KEY `Ref119210` (`codigo`),
  KEY `Ref126211` (`cod_prop`),
  CONSTRAINT `Refart_propiedades211` FOREIGN KEY (`cod_prop`) REFERENCES `art_propiedades` (`cod_prop`),
  CONSTRAINT `Refarticulos210` FOREIGN KEY (`codigo`) REFERENCES `articulos` (`codigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `prop_x_art` */

/*Table structure for table `proveedores` */

DROP TABLE IF EXISTS `proveedores`;

CREATE TABLE `proveedores` (
  `cod_prov` varchar(10) NOT NULL,
  `cta_cont` varchar(30) NOT NULL,
  `moneda` varchar(4) NOT NULL,
  `tipo_doc` varchar(30) DEFAULT NULL,
  `ci_ruc` varchar(30) DEFAULT NULL,
  `nombre` varchar(60) DEFAULT NULL,
  `tel` varchar(30) DEFAULT NULL,
  `email` varchar(40) DEFAULT NULL,
  `fecha_nac` date DEFAULT NULL,
  `pais` varchar(30) DEFAULT NULL,
  `ciudad` varchar(30) DEFAULT NULL,
  `dir` varchar(60) DEFAULT NULL,
  `ocupacion` varchar(30) DEFAULT NULL,
  `situacion` varchar(30) DEFAULT NULL,
  `tipo` varchar(16) DEFAULT NULL,
  `usuario` varchar(30) NOT NULL,
  `fecha_reg` date DEFAULT NULL,
  `estado` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`cod_prov`),
  KEY `Ref6253` (`usuario`),
  KEY `Ref138254` (`cta_cont`),
  KEY `Ref15304` (`moneda`),
  CONSTRAINT `Refmonedas304` FOREIGN KEY (`moneda`) REFERENCES `monedas` (`m_cod`),
  CONSTRAINT `Refplan_cuentas254` FOREIGN KEY (`cta_cont`) REFERENCES `plan_cuentas` (`cuenta`),
  CONSTRAINT `Refusuarios253` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `proveedores` */

/*Table structure for table `recepcion` */

DROP TABLE IF EXISTS `recepcion`;

CREATE TABLE `recepcion` (
  `id_diag` int(11) NOT NULL AUTO_INCREMENT,
  `cod_cli` varchar(30) DEFAULT NULL,
  `usuario` varchar(30) NOT NULL,
  `chapa` varchar(30) DEFAULT NULL,
  `marca` varchar(100) DEFAULT NULL,
  `fecha` datetime DEFAULT NULL,
  `descrip` varchar(10000) DEFAULT NULL,
  `porc_combustible` decimal(16,2) DEFAULT NULL,
  `km_actual` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`id_diag`),
  KEY `Refvehiculos242` (`chapa`),
  KEY `Refusuarios245` (`usuario`),
  KEY `Refclientes246` (`cod_cli`),
  KEY `Refmarcas247` (`marca`),
  CONSTRAINT `Refmarcas247` FOREIGN KEY (`marca`) REFERENCES `marcas` (`marca`),
  CONSTRAINT `Refusuarios245` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=68 DEFAULT CHARSET=latin1;

/*Data for the table `recepcion` */

insert  into `recepcion`(`id_diag`,`cod_cli`,`usuario`,`chapa`,`marca`,`fecha`,`descrip`,`porc_combustible`,`km_actual`) values (30,'C000001','douglas','Hsg 188','Suzuki','2020-06-29 00:00:00','General',65.00,136000.00),(31,'C000001','douglas','xyz 632','GMC','2020-06-30 00:00:00','Prueba 01 chapas general',65.00,136000.00),(32,'C000014','douglas','xyz 632','GMC','2020-06-30 00:00:00','Prueba 01 chapas general',65.00,136000.00),(33,'C000001','douglas','ABC 987','Ford','2020-06-30 00:00:00','Prueba general ',65.00,136000.00),(34,'C000008','douglas','XYZ 689','Toyota','2020-06-30 00:00:00','',65.00,136000.00),(35,'C000005','douglas','NAK 698','Toyota','2020-06-30 00:00:00','pruebassssss',65.00,136000.00),(36,'C000006','douglas','NGK 698','Ford','2020-06-30 00:00:00',' SELECT COUNT(*) AS cant FROM moviles WHERE codigo_entidad ',65.00,136000.00),(37,'C000008','douglas','AKL 898','Hyundai','2020-06-30 00:00:00','asdfasdfasdf',65.00,136000.00),(38,'C000002','douglas','NAH 367','Nissan','2020-07-01 00:00:00','Prueba 01',65.00,136000.00),(39,'C000003','douglas','NAS 886','Nissan','2020-07-01 00:00:00','Problema con escape bbbbbb',65.00,136000.00),(40,'C000005','douglas','NAH 376','Hyundai','2020-09-17 00:00:00','Jdjdbsvsvhshvzsvhshdbdbzbdbd\nNsnsnnsnnsnsms',65.00,136000.00),(41,'C000017','douglas','ABC 988','Suzuki','2020-09-28 00:00:00','Bloqueo central no funciona',65.00,136000.00),(42,'C000002','douglas','NAH 367','Nissan','2020-09-28 00:00:00','Prueba',65.00,136000.00),(43,'C000002','douglas','NAH 367','Nissan','2021-10-12 00:00:00','Problema de caja',65.00,136000.00),(44,'C000012','douglas','ABC 123','Toyota','2021-10-11 00:00:00','Problemas con los discos de frenos delanteros',65.00,136000.00),(45,'C000002','douglas','NAH 367','Nissan','2021-10-12 00:00:00','2132132s\nsafdasdf\nsadfasf\nasfd\nasdf\nsfda\nsfda\n',65.00,136000.00),(47,'C000013','douglas','ABC 789','Kia','2021-10-12 00:00:00','xxxxxxx',65.00,136000.00),(48,'C000002','douglas','ABG 420','Toyota','2021-10-12 00:00:00','CCCCC',65.00,136000.00),(49,'C000003','douglas','AJC 100','Volvo','2021-10-12 00:00:00','Rotula trasera rota',65.00,136000.00),(50,'C000002','douglas','NAH 367','Nissan','2021-10-13 00:00:00','xxxxx\nxxxxx',65.00,136000.00),(51,'C000002','douglas','AJU 492','Volvo','2021-10-14 00:00:00','Prueba de Range y tanque',65.00,136000.00),(52,'C000003','douglas','NAS 886','Nissan','2021-10-14 00:00:00','Prueba tanque y km',15.00,134000.00),(54,'C000007','douglas','KDG 973','Audi','2021-10-18 00:00:00','No arranca',70.00,124000.00),(55,'C000007','douglas','KDG 973','Audi','2021-10-18 00:00:00','',50.00,NULL),(56,'C000007','douglas','KDG 973','Audi','2021-10-18 00:00:00','No arranca',20.00,114000.00),(57,'C000002','douglas','NAH 367','Nissan','2021-10-19 00:00:00','',10.00,142000.00),(58,'C000001','douglas','AJU 492','Volvo','2021-10-20 00:00:00','Se frena solo, diagnostico de prueba\nSe frena solo, diagnostico de prueba\nSe frena solo, diagnostico de prueba',95.00,136000.00),(59,'C000002','douglas','NAH 367','Nissan','2021-10-29 00:00:00','Problema',20.00,135000.00),(60,'C000002','douglas','NAH 367','Nissan','2021-11-01 00:00:00','Fufufychvnvnvjvjvjvvj j',75.00,140000.00),(61,'C000012','douglas','ABC 123','Toyota','2021-11-10 00:00:00','Bloqueo automatico de freno',100.00,76500.00),(62,'C000012','douglas','ABC 123','Toyota','2021-11-10 00:00:00','Bloqueo automatico de freno',100.00,76500.00),(63,'C000012','douglas','ABC 123','Toyota','2021-11-10 00:00:00','Bloqueo automatico de freno',100.00,76500.00),(64,'C000003','douglas','AJC 100','Volvo','2021-11-10 00:00:00','',70.00,5600.00),(65,'C000003','douglas','AJC 100','Volvo','2021-11-10 00:00:00','sfsdfsdfsdfsf',60.00,124000.00),(66,'C000002','douglas','NAH 367','Nissan','2021-12-28 00:00:00','Problema de cremallera',70.00,12500.00),(67,'C000004','douglas','ABT 452','Nissan','2022-03-02 00:00:00','',50.00,NULL);

/*Table structure for table `recon_det` */

DROP TABLE IF EXISTS `recon_det`;

CREATE TABLE `recon_det` (
  `id_rec_det` int(11) NOT NULL AUTO_INCREMENT,
  `id_rec` varchar(30) NOT NULL,
  `id_pago` int(11) DEFAULT NULL,
  `f_nro` int(11) DEFAULT NULL,
  `id_cuota` int(11) DEFAULT NULL,
  `valor` decimal(16,2) DEFAULT NULL,
  PRIMARY KEY (`id_rec_det`,`id_rec`),
  KEY `Ref44246` (`id_pago`),
  KEY `Ref20247` (`id_cuota`,`f_nro`),
  KEY `Ref140248` (`id_rec`),
  CONSTRAINT `Refpagos_recibidos246` FOREIGN KEY (`id_pago`) REFERENCES `pagos_recibidos` (`id_pago`),
  CONSTRAINT `Refreconciliaciones248` FOREIGN KEY (`id_rec`) REFERENCES `reconciliaciones` (`id_rec`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `recon_det` */

/*Table structure for table `reconciliaciones` */

DROP TABLE IF EXISTS `reconciliaciones`;

CREATE TABLE `reconciliaciones` (
  `id_rec` varchar(30) NOT NULL,
  `usuario` varchar(30) NOT NULL,
  `fecha` datetime DEFAULT NULL,
  `cod_cli` varchar(30) NOT NULL,
  `moneda` varchar(4) NOT NULL,
  `tipo` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id_rec`),
  KEY `Ref6243` (`usuario`),
  KEY `Ref73249` (`cod_cli`),
  KEY `Ref15250` (`moneda`),
  CONSTRAINT `Refclientes249` FOREIGN KEY (`cod_cli`) REFERENCES `clientes` (`cod_cli`),
  CONSTRAINT `Refmonedas250` FOREIGN KEY (`moneda`) REFERENCES `monedas` (`m_cod`),
  CONSTRAINT `Refusuarios243` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `reconciliaciones` */

/*Table structure for table `reg_impresion` */

DROP TABLE IF EXISTS `reg_impresion`;

CREATE TABLE `reg_impresion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(30) DEFAULT NULL,
  `codigo` varchar(30) DEFAULT NULL,
  `lote` varchar(24) DEFAULT NULL,
  `suc_user` varchar(10) DEFAULT NULL,
  `suc_lote` varchar(10) DEFAULT NULL,
  `fecha` datetime DEFAULT NULL,
  `obs` varchar(100) DEFAULT NULL,
  `motivo` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Ref671` (`usuario`),
  CONSTRAINT `Refusuarios71` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `reg_impresion` */

/*Table structure for table `reg_produccion` */

DROP TABLE IF EXISTS `reg_produccion`;

CREATE TABLE `reg_produccion` (
  `id_reg` int(11) NOT NULL AUTO_INCREMENT,
  `usuario_reg` varchar(30) DEFAULT NULL,
  `fecha_prod` date DEFAULT NULL,
  `usuario_prod` varchar(30) DEFAULT NULL,
  `suc` varchar(10) NOT NULL,
  `codigo` varchar(20) DEFAULT NULL,
  `articulo` varchar(60) DEFAULT NULL,
  `fecha_reg` datetime DEFAULT NULL,
  `cant_prod` int(11) DEFAULT NULL,
  `obs` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id_reg`),
  KEY `Ref18189` (`suc`),
  CONSTRAINT `Refsucursales189` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `reg_produccion` */

/*Table structure for table `reg_ubic` */

DROP TABLE IF EXISTS `reg_ubic`;

CREATE TABLE `reg_ubic` (
  `id_ubic` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) NOT NULL,
  `suc` varchar(10) NOT NULL,
  `fila` int(11) NOT NULL,
  `col` int(11) NOT NULL,
  `nro_pallet` varchar(30) NOT NULL,
  `codigo` varchar(30) NOT NULL,
  `lote` varchar(30) NOT NULL,
  `usuario` varchar(30) NOT NULL,
  `hits` int(11) DEFAULT NULL,
  `fecha_hora` datetime NOT NULL,
  `cantidad` decimal(16,2) DEFAULT NULL,
  `obs` varchar(120) DEFAULT NULL,
  `estado` varchar(10) DEFAULT NULL,
  `fecha_salida` datetime DEFAULT NULL,
  `usuario_salida` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`id_ubic`,`nombre`,`suc`,`fila`,`col`,`nro_pallet`,`codigo`,`lote`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `reg_ubic` */

/*Table structure for table `registro_ausencias` */

DROP TABLE IF EXISTS `registro_ausencias`;

CREATE TABLE `registro_ausencias` (
  `id_aus` int(11) NOT NULL AUTO_INCREMENT,
  `jefe` varchar(30) NOT NULL,
  `usuario` varchar(30) NOT NULL,
  `fecha_reg` date DEFAULT NULL,
  `fecha_desde` datetime DEFAULT NULL,
  `fecha_hasta` datetime DEFAULT NULL,
  `fecha_retorno` datetime DEFAULT NULL,
  `motivo` varchar(1024) DEFAULT NULL,
  `tipo_lic` varchar(30) DEFAULT NULL,
  `tipo_perm` varchar(20) DEFAULT NULL,
  `valor_descuento` decimal(16,2) DEFAULT NULL,
  `horas` decimal(16,2) DEFAULT NULL,
  `suc` varchar(10) NOT NULL,
  PRIMARY KEY (`id_aus`),
  KEY `Ref6186` (`usuario`),
  KEY `Ref18187` (`suc`),
  KEY `Ref6207` (`jefe`),
  CONSTRAINT `Refsucursales187` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`),
  CONSTRAINT `Refusuarios186` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`),
  CONSTRAINT `Refusuarios207` FOREIGN KEY (`jefe`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `registro_ausencias` */

/*Table structure for table `reservas` */

DROP TABLE IF EXISTS `reservas`;

CREATE TABLE `reservas` (
  `nro_reserva` int(11) NOT NULL AUTO_INCREMENT,
  `suc` varchar(10) DEFAULT NULL,
  `usuario` varchar(30) NOT NULL,
  `fecha` date DEFAULT NULL,
  `vencimiento` date DEFAULT NULL,
  `cod_cli` varchar(30) DEFAULT NULL,
  `ruc_cli` varchar(20) DEFAULT NULL,
  `cliente` varchar(60) DEFAULT NULL,
  `cat` int(11) DEFAULT NULL,
  `valor_total_ref` decimal(16,2) DEFAULT NULL,
  `minimo_senia_ref` decimal(16,2) DEFAULT NULL,
  `senia_entrega_ref` decimal(16,2) DEFAULT NULL,
  `estado` varchar(10) DEFAULT NULL,
  `fecha_cierre` date DEFAULT NULL,
  `hora_cierre` varchar(10) DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`nro_reserva`),
  KEY `Ref634` (`usuario`),
  KEY `Ref1835` (`suc`),
  CONSTRAINT `Refsucursales35` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`),
  CONSTRAINT `Refusuarios34` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `reservas` */

/*Table structure for table `reservas_det` */

DROP TABLE IF EXISTS `reservas_det`;

CREATE TABLE `reservas_det` (
  `id_det` int(11) NOT NULL AUTO_INCREMENT,
  `nro_reserva` int(11) NOT NULL,
  `codigo` varchar(30) DEFAULT NULL,
  `lote` varchar(30) DEFAULT NULL,
  `descrip` varchar(60) DEFAULT NULL,
  `cantidad` decimal(16,2) DEFAULT NULL,
  `precio` decimal(16,2) DEFAULT NULL,
  `um` varchar(10) NOT NULL,
  `subtotal` decimal(16,2) DEFAULT NULL,
  `e_sap` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id_det`,`nro_reserva`),
  KEY `Ref2937` (`nro_reserva`),
  KEY `Ref1038` (`um`),
  CONSTRAINT `Refreservas37` FOREIGN KEY (`nro_reserva`) REFERENCES `reservas` (`nro_reserva`),
  CONSTRAINT `Refunidades_medida38` FOREIGN KEY (`um`) REFERENCES `unidades_medida` (`um_cod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `reservas_det` */

/*Table structure for table `sectores` */

DROP TABLE IF EXISTS `sectores`;

CREATE TABLE `sectores` (
  `cod_sector` int(11) NOT NULL,
  `descrip` varchar(60) DEFAULT NULL,
  `prefijo` varchar(4) DEFAULT NULL,
  `longitud` int(11) DEFAULT NULL,
  `serie` int(11) DEFAULT NULL,
  PRIMARY KEY (`cod_sector`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `sectores` */

insert  into `sectores`(`cod_sector`,`descrip`,`prefijo`,`longitud`,`serie`) values (101,'SERVICIOS','SR',3,3),(102,'INSUMOS','IN',4,7),(103,'REPUESTOS','RP',4,1),(104,'LUBRICANTES','LB',4,1),(105,'FILTROS','FL',4,1),(106,'FLUIDOS','FD',4,1),(107,'SUSPENSION Y DIRECION','SD',4,1),(108,'PASTILLAS DE FRENOS','PF',3,1),(109,'LAMPARAS','LM',3,1),(110,'FRENO Y EMBRAGUE','FE',3,1),(111,'ACCESORIOS','AC',4,1),(112,'KIT DISTRIBUCION','KD',3,1),(113,'CAJA Y DIFERENCIAL','CD',4,1),(114,'MOTOR','MT',4,1),(115,'PARTE ELECTRICA','PE',4,1),(116,'HERRAMIENTAS','HE',4,1),(117,'TRANSMISION DE POTENCIA','TP',4,1),(118,'RODAMIENTOS','RD',4,1),(119,'RETENES','RT',4,1),(120,'CORREAS','CO',4,1),(121,'CARROCERIA','CA',4,1);

/*Table structure for table `series_lotes` */

DROP TABLE IF EXISTS `series_lotes`;

CREATE TABLE `series_lotes` (
  `cod_serie` varchar(4) NOT NULL,
  `anio` varchar(4) NOT NULL,
  `serie` int(11) DEFAULT NULL,
  PRIMARY KEY (`cod_serie`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `series_lotes` */

insert  into `series_lotes`(`cod_serie`,`anio`,`serie`) values ('01','2001',13626),('02','2002',18768),('03','2003',22395),('04','2004',11071),('05','2005',31209),('06','2006',56879),('07','2007',82757),('08','2008',1298),('09','2009',36828),('10','2010',70444),('11','2011',16445),('12','2012',7435),('13','2013',87107),('14','2014',117734),('15','2015',223233),('16','2016',228001),('17','2017',254135),('18','2018',248284),('19','2019',140374),('20','2020',17),('21','2021',1),('22','2022',1),('23','2023',1),('24','2024',1),('25','2025',1),('26','2026',1),('27','2027',1),('28','2028',1),('29','2029',1),('30','2030',1);

/*Table structure for table `sesiones` */

DROP TABLE IF EXISTS `sesiones`;

CREATE TABLE `sesiones` (
  `id_sesion` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(30) NOT NULL,
  `fecha` varchar(30) DEFAULT NULL,
  `hora` varchar(30) DEFAULT NULL,
  `ip` varchar(30) DEFAULT NULL,
  `serial` varchar(100) DEFAULT NULL,
  `limite_sesion` int(11) DEFAULT NULL,
  `expira` varchar(30) DEFAULT NULL,
  `estado` varchar(16) DEFAULT NULL,
  PRIMARY KEY (`id_sesion`,`usuario`),
  KEY `Ref610` (`usuario`),
  CONSTRAINT `Refusuarios10` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=772 DEFAULT CHARSET=latin1;

/*Data for the table `sesiones` */

insert  into `sesiones`(`id_sesion`,`usuario`,`fecha`,`hora`,`ip`,`serial`,`limite_sesion`,`expira`,`estado`) values (91,'douglas','2020-02-24','19:13:02','::1','08d57ec54dd1aa681198363eb9b7b011b2ed851b',3600,'2020-02-27 07:13:02','Inactiva'),(92,'douglas','2020-02-24','19:25:02','::1','43eb55f45e96b2d7d894a611afbdbb37941d0b21',3600,'2020-02-27 07:35:02','Inactiva'),(93,'douglas','2020-02-24','19:36:56','::1','bc4eea054762f134d14f5fb8a2f97446ed1b77eb',3600,'2020-02-27 07:36:56','Inactiva'),(94,'douglas','2020-02-24','19:38:55','::1','319d2f4d5510186c53a401648c799f2ac8c06386',3600,'2020-02-27 07:38:55','Inactiva'),(95,'douglas','2020-02-24','19:42:22','::1','bf91c8245bcbbf580624ca0c7ec167f119a1417f',3600,'2020-02-27 07:42:22','Inactiva'),(96,'douglas','2020-02-24','19:43:06','::1','914e94739a0dcbc7f0e9cae93458078dfdb186db',3600,'2020-02-27 08:33:07','Inactiva'),(97,'douglas','2020-02-24','20:34:13','::1','6af959576d2b6d3d295c7c6ecc2ea9425d4391c1',3600,'2020-02-27 08:43:07','Inactiva'),(98,'douglas','2020-02-25','19:18:39','::1','542c90cb57b53ee7ece67f595ddc13ee130b7d94',3600,'2020-02-28 07:23:40','Inactiva'),(99,'douglas','2020-02-26','19:03:52','::1','ad1cab3f7f967c2000423d5c96e87eb6772b86d0',3600,'2020-02-29 07:48:55','Inactiva'),(100,'douglas','2020-02-26','19:51:58','::1','4b8f1fd1c88dcc830ca0298f61a61a9520a08b12',3600,'2020-02-29 07:56:59','Inactiva'),(101,'douglas','2020-02-26','20:00:41','::1','950ce1cd3d97aeed51c0c01a539698a12bcca40d',3600,'2020-03-01 06:03:49','Inactiva'),(102,'douglas','2020-02-27','18:05:32','::1','7f3f87b202e9d23c4527180c9271f29b1eca41e7',3600,'2020-03-01 08:05:38','Inactiva'),(103,'douglas','2020-02-27','20:08:36','::1','e251fa4de1195d634b5352348cc3b7ab618246e4',3600,'2020-03-01 08:18:37','Inactiva'),(105,'douglas','2020-03-02','18:04:14','::1','8732ab5d8b17a08c2d1c1bbceec4bcceb1a93bc8',3600,'2020-03-05 06:14:15','Inactiva'),(106,'douglas','2020-03-02','18:15:17','::1','a74bc90ce31857a7e34fd097208cce494a11cc7e',3600,'2020-03-05 06:15:17','Inactiva'),(107,'douglas','2020-03-02','18:16:29','::1','2c18b75edd4401c4a99289f1219a5779fe7cc650',3600,'2020-03-05 06:31:30','Inactiva'),(108,'douglas','2020-03-02','18:35:08','::1','410ff318ea64ae786fb0e5a4ba0c041350567d31',3600,'2020-03-05 06:40:09','Inactiva'),(109,'douglas','2020-03-02','18:40:35','::1','75068740447fdb94b4f36ecc6a08a1a06b659997',3600,'2020-03-05 06:45:35','Inactiva'),(110,'douglas','2020-03-02','19:43:16','::1','fdf70d396a525d24c8e1307a57abaff07a534b7b',3600,'2020-03-05 07:48:16','Inactiva'),(111,'douglas','2020-03-02','19:50:14','::1','2656feae3d5b3c5d810f30b694ad295b13ddaaf7',3600,'2020-03-05 07:50:14','Inactiva'),(112,'douglas','2020-03-02','19:54:50','::1','52f86513d2be6bdbf08d34b1e81ecdf8577ca954',3600,'2020-03-05 07:54:50','Inactiva'),(113,'douglas','2020-03-02','19:58:02','::1','cf6d7e0c1555b076947c554f104bbb5acb774684',3600,'2020-03-05 07:58:02','Inactiva'),(114,'douglas','2020-03-18','17:58:31','::1','dce61f076befe229b279aaa89d8fc120be6ce4b8',3600,'2020-03-21 06:43:32','Inactiva'),(115,'douglas','2020-03-18','18:03:39','192.168.0.42','c7f674ecbe87189ddf62c44cf94c87722ca1752f',3600,'2020-03-21 06:03:39','Inactiva'),(116,'douglas','2020-05-18','18:01:58','::1','4bf2b2927e96a27376dc42cdec5717d3e4435ec3',3600,'2020-05-21 06:06:59','Inactiva'),(117,'douglas','2020-05-18','18:29:36','::1','86280c60081f366fbd35a9649601e1ef6ce97b34',3600,'2020-05-21 06:29:36','Inactiva'),(118,'douglas','2020-05-18','18:32:25','::1','32708f8be3736537096b294fda1fa1f679f9da16',3600,'2020-05-21 06:32:25','Inactiva'),(119,'douglas','2020-05-18','18:33:59','::1','75938739ac8ef8db3d55554c4ae38bcdc043359f',3600,'2020-05-21 06:33:59','Inactiva'),(120,'douglas','2020-05-18','18:36:48','::1','3ecbf04f42990e73065a61612716219f233ac5f5',3600,'2020-05-21 06:36:48','Inactiva'),(121,'douglas','2020-05-18','18:37:20','::1','09aa2efc26d333bf6282550d242cc74f6950db55',3600,'2020-05-21 06:52:21','Inactiva'),(122,'douglas','2020-05-18','18:52:41','::1','4b7c8336cb7696ea872727e3c978d1a86d684968',3600,'2020-05-21 06:52:41','Inactiva'),(123,'douglas','2020-05-18','18:55:02','::1','2af0cd752b8c7597544dadfc01e8813e3ded88fc',3600,'2020-05-21 07:55:03','Inactiva'),(124,'douglas','2020-05-18','19:47:28','192.168.0.42','23e425c484a1766e326385cf6d4a6bb7d3a2c0f5',3600,'2020-05-21 07:47:28','Inactiva'),(125,'douglas','2020-05-18','19:54:38','192.168.0.42','441a9b8d255d711741d7823e2a41f04293636d85',3600,'2020-05-21 07:54:38','Inactiva'),(126,'douglas','2020-05-19','18:12:20','::1','f315bfa5dc83e81e4301edc2c4cd85fc36592b74',3600,'2020-05-22 07:47:21','Inactiva'),(127,'douglas','2020-05-19','18:15:37','192.168.0.42','abd1171a4e6ba9378433ef679bb7e3c1e9c316f0',3600,'2020-05-22 06:15:37','Inactiva'),(128,'douglas','2020-05-19','18:46:35','192.168.0.42','608c0c0914c4083f8bb61e5983eb5784edc054d8',3600,'2020-05-22 06:46:35','Inactiva'),(129,'douglas','2020-05-19','18:49:55','192.168.0.42','42206066dded1e4f23038022066a4ef4575e0878',3600,'2020-05-22 07:17:07','Inactiva'),(130,'douglas','2020-05-21','18:31:52','::1','96734de6d96ca0a33bd046638bea15a5eb6bde15',3600,'2020-05-24 06:47:53','Inactiva'),(131,'douglas','2020-05-21','18:45:11','::1','3c752450c9d51cd967f32bd139b83d8ee1d4e7f8',3600,'2020-05-24 06:45:11','Inactiva'),(132,'douglas','2020-05-21','18:49:21','::1','8b484c5f4bba0bb16caec2cdc71bf855bffdfdc7',3600,'2020-05-24 08:34:21','Inactiva'),(133,'douglas','2020-05-21','19:15:47','192.168.0.42','e5f214fb6bde8e1e9478ebec0349a2cc71a88997',3600,'2020-05-24 08:27:57','Inactiva'),(134,'douglas','2020-05-21','20:28:45','192.168.0.42','9c503f8ef84ecf4cc52b7d6ea005bdc580f55a62',3600,'2020-05-24 08:35:03','Inactiva'),(135,'douglas','2020-05-22','17:44:27','::1','bbdd47794f5168e00cfc5f408c5d97a45459a964',3600,'2020-05-25 07:24:33','Inactiva'),(136,'douglas','2020-05-22','17:57:36','192.168.0.42','adad4762d9fb02b6c9789a3087a1a20e8a0437e5',3600,'2020-05-25 05:57:36','Inactiva'),(137,'douglas','2020-05-22','18:34:34','192.168.0.42','edf7c927d1d0ec2eaa3414609ba7da390f12fb20',3600,'2020-05-25 06:43:43','Inactiva'),(138,'douglas','2020-05-25','17:55:34','::1','34a905645c54eb4f331154e85799d87af3fd626b',3600,'2020-05-28 06:45:37','Inactiva'),(139,'douglas','2020-05-25','18:24:38','192.168.0.42','192b42c3d30872294f0b6c2cfc9ea517571b3135',3600,'2020-05-28 06:24:38','Inactiva'),(140,'douglas','2020-05-25','18:26:57','192.168.0.42','dec15ae547599b265eb722fd14efea33ba5a68e6',3600,'2020-05-28 06:45:18','Inactiva'),(141,'douglas','2020-05-25','18:46:43','192.168.0.42','ba3d689bdd3d1a6e33dc6699fd30270bcb54c562',3600,'2020-05-28 06:46:43','Inactiva'),(142,'douglas','2020-05-25','18:49:45','::1','d0c3123d35f2bd3899e74892fb5f49d855c4af5d',3600,'2020-05-28 06:49:45','Inactiva'),(143,'douglas','2020-05-25','18:55:40','::1','4a39b75bc0db4931362ccdf475282f2c21fea75a',3600,'2020-05-28 07:20:41','Inactiva'),(144,'douglas','2020-05-25','19:17:17','192.168.0.42','e7061013a63fac5b64969490c116168019eeef8f',3600,'2020-05-28 07:17:17','Inactiva'),(145,'douglas','2020-05-26','19:04:10','192.168.0.42','589a64e51d17814e3554913e562ed73e0d30ed5a',3600,'2020-05-29 08:27:03','Inactiva'),(146,'douglas','2020-05-26','19:05:07','::1','96c74a3475dfeb61df38cbb2e6ff05ac38a75589',3600,'2020-05-30 06:12:06','Inactiva'),(147,'douglas','2020-05-26','20:30:22','192.168.0.42','4669f823b42c84cce8fce9149f1f3fa107f7312d',3600,'2020-05-29 08:30:22','Inactiva'),(148,'douglas','2020-05-27','18:15:29','::1','88bb29f6729431f581f13c7b951593010ae589a8',3600,'2020-05-30 06:25:30','Inactiva'),(149,'douglas','2020-05-27','18:29:09','::1','c9bbd95c964120b8750248fa00af84d26166ed2a',3600,'2020-05-30 06:29:09','Inactiva'),(150,'douglas','2020-05-27','18:35:13','::1','faa55a3b7a4d892b2bad9167435e5b64f40ca718',3600,'2020-05-30 06:35:13','Inactiva'),(151,'douglas','2020-05-27','18:42:35','::1','05a89b14828f68e76fb97939533db1eac626df55',3600,'2020-05-30 06:42:35','Inactiva'),(152,'douglas','2020-05-27','18:46:33','::1','feed539ea5398c5460a1f50ee999a159a669227e',3600,'2020-05-30 07:01:34','Inactiva'),(153,'douglas','2020-05-27','18:56:15','192.168.0.42','fc06aa09cfa5e6cfcaf15b7ed5dcd2dfb18fa9ea',3600,'2020-05-30 06:56:15','Inactiva'),(154,'douglas','2020-05-27','19:09:57','::1','b18a1ae680653ee481613d2f4d161981dba9b85c',3600,'2020-05-31 08:57:38','Inactiva'),(155,'douglas','2020-06-01','19:57:39','::1','0530d10c7fe61782c1036df4bde0e3abc4cf2034',3600,'2020-06-04 07:57:39','Inactiva'),(156,'douglas','2020-06-04','17:53:04','::1','f0ae2fb507370ef6566fd2dd9e13775f6127a693',3600,'2020-06-07 05:53:04','Inactiva'),(157,'douglas','2020-06-04','18:35:01','192.168.0.42','d1d13c71ca78e981c8f10fea0cc1796d1cec91a4',3600,'2020-06-07 06:40:03','Inactiva'),(158,'douglas','2020-06-05','18:34:48','192.168.0.42','2b992807819c6f635d7c854ce03f39ed6aba09fb',3600,'2020-06-08 08:37:27','Inactiva'),(159,'douglas','2020-06-05','19:28:54','::1','992c89e9b428459a53d8762b89861409da7cf806',3600,'2020-06-08 08:44:01','Inactiva'),(160,'douglas','2020-06-09','17:59:38','::1','ed91ea13fd77f112b2705022cb41a7ae78bbf4f2',3600,'2020-06-12 06:09:39','Inactiva'),(161,'douglas','2020-06-09','18:11:22','::1','a13586003a65e401b555d7e91306c86bc346f27c',3600,'2020-06-12 06:16:23','Inactiva'),(162,'douglas','2020-06-09','18:16:40','::1','c7dc10d5bc7727e0c81017d7c43dff128ba8c7d5',3600,'2020-06-12 06:26:41','Inactiva'),(163,'douglas','2020-06-09','18:41:35','::1','f52453194a2c218ec9c05103d792020ecb97e631',3600,'2020-06-12 06:46:37','Inactiva'),(164,'douglas','2020-06-09','18:52:13','::1','1d2bcec7db800df53fbb84e90c54a8b4fbc76a4d',3600,'2020-06-12 06:52:13','Inactiva'),(165,'douglas','2020-06-09','19:10:00','::1','c69c7cc63dbece5a3c164b54d46f05ac58a72b38',3600,'2020-06-12 07:10:00','Inactiva'),(166,'douglas','2020-06-09','19:25:08','::1','3dbbc4218498a23f609a528097ab1e5eed57bf4b',3600,'2020-06-12 07:25:08','Inactiva'),(167,'douglas','2020-06-09','19:45:22','::1','482769ee0238cde35c4cf4e6fbfb539d2a2dfdda',3600,'2020-06-12 07:45:22','Inactiva'),(168,'douglas','2020-06-11','20:21:54','192.168.0.42','e80e91ab5bd9b717fb0aa0bbf8e1adbb6fb4f9b0',3600,'2020-06-14 08:21:54','Inactiva'),(169,'douglas','2020-06-11','20:22:36','192.168.0.36','52bcf55e5b073ff0cc70410b2de15bea989a53f4',3600,'2020-06-14 08:22:36','Inactiva'),(170,'douglas','2020-06-11','20:27:49','192.168.0.36','c8166cbe610dda782daaae44270f464111b8051a',3600,'2020-06-14 08:27:49','Inactiva'),(171,'douglas','2020-06-11','20:29:06','192.168.0.254','9fda5631d523e7dd664af587696644eebc227d45',3600,'2020-06-14 08:29:06','Inactiva'),(172,'douglas','2020-06-11','20:30:19','192.168.0.254','96215bac7e96fc10777152cc01175a373efa252f',3600,'2020-06-14 08:50:20','Inactiva'),(173,'douglas','2020-06-11','20:31:13','192.168.0.36','b873d698d92f6aa8f2ba76668d41d399f0e6e0c9',3600,'2020-06-14 08:31:13','Inactiva'),(174,'douglas','2020-06-11','20:42:29','192.168.0.42','7ee1fe68749453dc98bf1666756a89c99cf09590',3600,'2020-06-14 08:42:29','Inactiva'),(175,'douglas','2020-06-11','20:46:30','192.168.0.42','950949b289682f576c2981476b24b573dcd33a27',3600,'2020-06-14 08:46:30','Inactiva'),(176,'douglas','2020-06-11','20:53:18','192.168.0.42','37dcec14f46ff27756df374d7e6bc796da285d43',3600,'2020-06-14 08:53:18','Inactiva'),(177,'douglas','2020-06-15','19:16:16','192.168.0.42','189e71f322a14c407845ff421f02fc4a6a7d474d',3600,'2020-06-18 07:16:16','Inactiva'),(178,'douglas','2020-06-15','19:18:04','192.168.0.254','e8c774b3048cf58c4b72d64f5b4335d82546c5f1',3600,'2020-06-18 07:18:04','Inactiva'),(179,'douglas','2020-06-15','19:35:15','192.168.0.254','7e3e389333b817f3325510d8826d28576a9bc78b',3600,'2020-06-18 07:35:15','Inactiva'),(180,'douglas','2020-06-15','19:37:26','192.168.0.254','eff535003da100fcd9cf72a03f88af4591afb628',3600,'2020-06-18 07:42:26','Inactiva'),(181,'douglas','2020-06-15','19:48:30','192.168.0.254','50b4e9619bd5fb21df7750f2bae155071b5b5011',3600,'2020-06-18 08:33:31','Inactiva'),(182,'douglas','2020-06-15','20:23:32','192.168.0.42','6f3909ac1d9f771fd37085fb88f74cca43e9b1ad',3600,'2020-06-18 08:23:32','Inactiva'),(183,'douglas','2020-06-15','20:26:25','192.168.0.42','544e7a5af6cef3f9ea89f01505f2c2de28a50465',3600,'2020-06-18 08:26:25','Inactiva'),(184,'douglas','2020-06-15','20:49:55','192.168.0.42','77c8b28c5860586e45b7d701cbd7c9fea4f7f4fe',3600,'2020-06-18 08:49:55','Inactiva'),(185,'douglas','2020-06-18','17:49:20','192.168.0.36','e0b0b95087efc1ffc8b83f1082f82086ccc5c170',3600,'2020-06-21 05:49:20','Inactiva'),(186,'douglas','2020-06-18','17:53:29','192.168.0.36','f98f2b0607d6e3abd22211b89c58e4319103a9cf',3600,'2020-06-21 06:21:50','Inactiva'),(187,'douglas','2020-06-18','18:16:36','::1','70030c2edbae7dfe8377b4501552b789f1d44795',3600,'2020-06-21 06:41:38','Inactiva'),(188,'douglas','2020-06-18','18:23:07','192.168.0.42','d7ede8b3b53652b88f743b2305d0fe9d2485bb27',3600,'2020-06-21 06:23:07','Inactiva'),(189,'douglas','2020-06-18','19:04:09','::1','e41b56fe5f0f7d96bfa9eedaf2ee02309ff7b52e',3600,'2020-06-21 07:09:09','Inactiva'),(190,'douglas','2020-06-23','18:02:59','::1','6da33f8e1bc31fba9f106191ca098dd8d4ceba27',3600,'2020-06-26 06:02:59','Inactiva'),(191,'douglas','2020-06-23','18:14:55','192.168.0.42','da29404dc0c83eaa7a8ab825f9d96cc280d0c225',3600,'2020-06-26 07:25:39','Inactiva'),(192,'douglas','2020-06-23','19:04:21','::1','3e54d29771661df9c10accc01e8f0ea748a98130',3600,'2020-06-26 07:04:21','Inactiva'),(193,'douglas','2020-06-23','19:09:55','::1','26dc69cac4164270a5b46911a3ed842d0411c3cd',3600,'2020-06-26 07:09:55','Inactiva'),(194,'douglas','2020-06-23','19:13:41','::1','415a69b6fdb21b298061781e1922f5eed2976769',3600,'2020-06-28 06:39:43','Inactiva'),(195,'douglas','2020-06-23','19:39:18','192.168.0.42','7c7b65da2274c1f48b485eff809093df9756dc47',3600,'2020-06-26 07:39:18','Inactiva'),(196,'douglas','2020-06-25','18:22:29','192.168.0.42','098182193c8262c7a499e617680446ad042e76d2',3600,'2020-06-28 06:34:13','Inactiva'),(197,'douglas','2020-06-25','18:38:45','192.168.0.42','bb8ef543af429d6ecee6aaa16a569d6ee6f159d6',3600,'2020-06-28 06:38:45','Inactiva'),(198,'douglas','2020-06-25','18:44:09','192.168.0.42','563e97fe489982b7967fbbe00228b80e993125a8',3600,'2020-06-28 06:49:11','Inactiva'),(199,'douglas','2020-06-25','18:49:59','::1','2b128bd56a4961a02cb185663e6c920e0c98e5ba',3600,'2020-06-28 07:50:00','Inactiva'),(200,'douglas','2020-06-25','18:53:46','192.168.0.42','b1832f1a169a2c29cbc53bd14f29937c128048c0',3600,'2020-06-28 06:53:46','Inactiva'),(201,'douglas','2020-06-25','19:32:49','192.168.0.42','a231841c4d0a7b46ff2e168a3770558ab08a7c71',3600,'2020-06-28 07:38:08','Inactiva'),(202,'douglas','2020-06-25','19:56:08','192.168.0.42','b9918554f648b7235ebb364aec7a011739019a95',3600,'2020-06-28 08:01:58','Inactiva'),(203,'douglas','2020-06-29','18:07:00','::1','b43eca9be186e4de7070b418428df87f26919f00',3600,'2020-07-02 06:07:00','Inactiva'),(204,'douglas','2020-06-29','18:28:23','::1','cde7a99eda63247801a6d0c8ee32982a0aea5624',3600,'2020-07-03 06:48:26','Inactiva'),(205,'douglas','2020-06-29','18:52:14','192.168.0.42','72b15f62e64b53d5c1e0dc26315a8686101342b0',3600,'2020-07-02 06:58:33','Inactiva'),(206,'douglas','2020-06-29','19:08:01','192.168.0.42','cae091b08df8a0b02f19aa29d904e193d346c238',3600,'2020-07-02 07:08:01','Inactiva'),(207,'douglas','2020-06-30','18:44:14','::1','e6e880a47e0e165e10553363cf6ce0bf543c6be0',3600,'2020-07-03 07:29:14','Inactiva'),(208,'douglas','2020-06-30','19:36:17','::1','8811d03b4daeef9c89765e4f1edb752aca8359a4',3600,'2020-07-04 07:08:24','Inactiva'),(209,'douglas','2020-07-01','18:32:42','192.168.0.42','c2347ae6aa992b9e084206f831d4bafa5d725b5b',3600,'2020-07-04 06:32:42','Inactiva'),(210,'douglas','2020-07-01','18:33:31','192.168.0.42','ab319f79d8c18c4c31e9157bfb1ae27818a17130',3600,'2020-07-04 06:33:31','Inactiva'),(211,'douglas','2020-07-01','19:00:55','192.168.0.42','463ca9745f3f7cf11327d05f3132c7cd2f46e93c',3600,'2020-07-04 07:00:55','Inactiva'),(212,'douglas','2020-07-01','19:05:51','192.168.0.42','cb75965c998ab488073b55fa6c92f930ad56d007',3600,'2020-07-04 07:05:51','Inactiva'),(213,'douglas','2020-07-01','19:06:12','192.168.0.42','421a62996fb6708ef27379a82b075fcceac49571',3600,'2020-07-04 07:51:59','Inactiva'),(214,'douglas','2020-07-01','19:10:41','::1','c611eb9ce0a14b81e9c95c00dabba323e16aa3fc',3600,'2020-07-05 08:13:03','Inactiva'),(215,'douglas','2020-07-01','19:52:20','192.168.0.42','163692a712bc3f0e7674af306988c3d9584e0f07',3600,'2020-07-04 07:52:20','Inactiva'),(216,'douglas','2020-07-01','19:53:17','192.168.0.42','23a4e92894e0479493e05ea445dddf092866e8bd',3600,'2020-07-04 07:58:17','Inactiva'),(217,'douglas','2020-07-02','20:04:11','192.168.0.42','b3ea3f8d4a476810854a9422a2e0b344adcb0045',3600,'2020-07-05 08:04:11','Inactiva'),(218,'douglas','2020-07-02','20:07:40','192.168.0.42','51bae47d7036874e9d9d96154c11b090f9ef14bf',3600,'2020-07-05 08:07:40','Inactiva'),(219,'douglas','2020-07-02','20:09:43','192.168.0.42','c85f34ecdf6c5b4f84b6c4ea7a62595e4c9ba254',3600,'2020-07-05 08:09:43','Inactiva'),(220,'douglas','2020-09-17','18:02:01','::1','950e1bdb5a43eddc1e61c5bc2b3223370ffbce58',3600,'2020-09-20 06:42:03','Inactiva'),(221,'douglas','2020-09-17','18:10:31','192.168.0.42','b35170740c858ca02909403dbefcc5975a2ff29f',3600,'2020-09-20 06:10:31','Inactiva'),(222,'douglas','2020-09-17','18:13:52','192.168.0.42','d96c006cb9d450072e4768fd8738c257fde9e7cf',3600,'2020-09-20 06:13:52','Inactiva'),(223,'douglas','2020-09-17','18:14:16','192.168.0.42','01be8769f2d0db79ee722f023de628c45f6daab1',3600,'2020-09-20 06:14:16','Inactiva'),(224,'douglas','2020-09-17','18:14:52','192.168.0.42','dc6e12f3a97844ed220f829ba83d1c4176324ae9',3600,'2020-09-20 06:14:52','Inactiva'),(225,'douglas','2020-09-19','12:56:29','::1','df40aa38b8e75d026f7b27482630b5fb61119785',3600,'2020-09-22 01:01:36','Inactiva'),(226,'douglas','2020-09-19','13:10:22','::1','04b7c19493d0431e837b02537aa33fc27c06d2bf',3600,'2020-09-22 01:25:22','Inactiva'),(227,'douglas','2020-09-26','12:34:48','::1','36bfe32311b297c82f771922acb40de00de2151f',3600,'2020-09-29 00:39:54','Inactiva'),(228,'douglas','2020-09-28','18:04:36','::1','f4cb7ec7d222caa428db10b0f2a6b9a29adf8811',3600,'2020-10-01 06:34:37','Inactiva'),(229,'douglas','2020-09-28','18:44:13','::1','22a0166d080adb62f5fcfd1c3f6b0be569153065',3600,'2020-10-01 07:19:14','Inactiva'),(230,'douglas','2020-09-28','19:24:26','::1','26225cbad482b135780327130219597098547f43',3600,'2020-10-01 07:24:26','Inactiva'),(231,'douglas','2020-09-28','19:36:01','192.168.0.42','dc19b7d9d07bde9850903f7082efef401cfe1761',3600,'2020-10-01 07:42:44','Inactiva'),(232,'douglas','2020-09-28','19:43:52','::1','c45f04d58807b2c6727900181b8461d680e5fa21',3600,'2020-10-01 07:48:53','Inactiva'),(233,'douglas','2020-09-28','19:53:59','::1','fba08e71e77137bc62202a422c95590a852ee9cb',3600,'2020-10-01 07:59:00','Inactiva'),(234,'douglas','2020-09-28','20:00:30','::1','cf5cb0ca68fddd311b37d5cc26dd8d2d22fdcf01',3600,'2020-10-01 08:05:31','Inactiva'),(235,'douglas','2020-10-27','19:38:46','::1','e4988db5ac41e9e267460b62003026730198f947',3600,'2020-10-30 08:03:47','Inactiva'),(236,'douglas','2021-01-07','19:09:36','127.0.0.1','67cc93989aec673d31707df1b5bc0a8a66d8d40e',3600,'2021-01-10 07:09:36','Inactiva'),(237,'douglas','2021-01-07','19:09:39','127.0.0.1','0e67786b9ff6cabf07237304eb2a6aec1b9914ce',3600,'2021-01-10 07:09:39','Inactiva'),(238,'douglas','2021-01-07','19:16:21','127.0.0.1','1d0bd7e31859cdd87d08ecd0ab6f8ea3a4db5105',3600,'2021-01-10 07:16:21','Inactiva'),(239,'douglas','2021-01-07','19:16:36','127.0.0.1','6700f1151af11ef99b2aa4697be4df3003c67799',3600,'2021-01-11 07:46:31','Inactiva'),(240,'douglas','2021-02-13','08:53:09','127.0.0.1','cbe9c8ca8ddfc526b3ecd5fe2ba751c9347202c0',3600,'2021-02-15 20:53:09','Inactiva'),(241,'douglas','2021-02-13','08:53:11','127.0.0.1','a97f0789f2a66c3a2f5bd9851aca0f9ea71122fb',3600,'2021-02-15 21:38:15','Inactiva'),(242,'douglas','2021-09-14','10:07:22','127.0.0.1','bec97019907e10b9f90aa18c560126b75c5c9df4',3600,'2021-09-16 22:07:22','Inactiva'),(243,'douglas','2021-09-14','10:08:07','127.0.0.1','52dbd45e819d7cb7cccc6492c196a33a760d3236',3600,'2021-09-16 22:18:15','Inactiva'),(244,'douglas','2021-09-16','09:44:46','127.0.0.1','6d247427bce35573018ed86bc7804433aa0accef',3600,'2021-09-18 21:49:47','Inactiva'),(245,'douglas','2021-09-16','09:50:28','127.0.0.1','d72d5d5169d12f9a8337fa97d1203bba5270a1a2',3600,'2021-09-18 21:50:28','Inactiva'),(246,'douglas','2021-09-16','10:18:12','127.0.0.1','d5a0d9586d3aacc3f97e420e17424fe5999d3e46',3600,'2021-09-18 22:18:12','Inactiva'),(247,'douglas','2021-09-22','15:22:01','127.0.0.1','4bf59c24b2af605b2304036934820ff50bb5ec3d',3600,'2021-09-25 03:22:01','Inactiva'),(248,'douglas','2021-09-22','15:41:39','127.0.0.1','049183ab2d69d7a44f4076ecaa39cbf2816d806e',3600,'2021-09-25 05:16:40','Inactiva'),(249,'douglas','2021-09-22','17:16:47','127.0.0.1','360432a2ea4a0a2c8caec39cb4cf0db2285ed21d',3600,'2021-09-25 05:31:48','Inactiva'),(250,'douglas','2021-09-23','16:08:19','127.0.0.1','d6b8b82fd17bafb794144526d3319f646ad7cf43',3600,'2021-09-26 04:48:20','Inactiva'),(251,'douglas','2021-09-23','16:14:21','192.168.0.36','61563ad3fbebd0fe431ff273f407b2d50af08c9f',3600,'2021-09-26 04:19:22','Inactiva'),(252,'douglas','2021-09-23','16:15:53','192.168.0.42','b8b1bd609f81ce3cbd825033f9b25478630902f4',3600,'2021-09-26 06:05:56','Inactiva'),(253,'douglas','2021-09-23','17:07:29','127.0.0.1','5af49ca78325ba4a57a98e30870e3092abfdec20',3600,'2021-09-26 05:07:29','Inactiva'),(254,'douglas','2021-09-23','17:08:09','127.0.0.1','21e5aa4adfc0a13f79b085ace4d04a50b80f7279',3600,'2021-09-26 05:28:09','Inactiva'),(255,'douglas','2021-09-23','17:28:20','127.0.0.1','d6789ca80b7fc16d094ead0373f6840b285ac117',3600,'2021-09-26 06:13:21','Inactiva'),(256,'douglas','2021-09-23','18:06:27','192.168.0.42','3c7233f455fb271f87c881a745f8fb56967ddbb0',3600,'2021-09-26 06:06:27','Inactiva'),(257,'douglas','2021-09-23','18:09:35','192.168.0.42','e3cf1e36057185095efa2491fc40bbd07a97d49d',3600,'2021-09-26 06:15:45','Inactiva'),(258,'douglas','2021-09-23','18:17:43','127.0.0.1','d8e8ad359c5605c5c7f43c021d53e34abcc6361f',3600,'2021-09-26 06:17:43','Inactiva'),(259,'douglas','2021-09-23','18:27:44','192.168.0.42','674b3aa1bfa7d77ab560ff25c93b14e70de3d0d2',3600,'2021-09-26 06:44:29','Inactiva'),(260,'douglas','2021-09-23','18:36:49','127.0.0.1','1f1dd3fca17639ff6944b79e1e8d9e85c56ecdcc',3600,'2021-09-26 06:41:49','Inactiva'),(261,'douglas','2021-09-28','16:42:24','127.0.0.1','5da235e28e90be3892d9fccafe846130c9a1b8d5',3600,'2021-10-01 04:57:25','Inactiva'),(262,'douglas','2021-09-28','16:58:13','127.0.0.1','7b22c7cb3db219015b6bbcf666ea6b019096bc10',3600,'2021-10-01 05:38:13','Inactiva'),(263,'douglas','2021-09-28','17:07:00','192.168.0.42','5f7d6676ace402af1054e7b941338657afaa0b6d',3600,'2021-10-01 05:07:00','Inactiva'),(264,'douglas','2021-09-28','17:07:24','192.168.0.42','514139fd762b9048dff7afc7f274ef818523eeae',3600,'2021-10-01 05:07:24','Inactiva'),(265,'douglas','2021-09-28','17:38:57','127.0.0.1','846655456efb3ff8b4d02cc60ea92258f069002c',3600,'2021-10-01 05:38:57','Inactiva'),(266,'douglas','2021-09-28','17:39:53','127.0.0.1','e48c6c9b96b74f69bd94101e36014fba37504517',3600,'2021-10-01 05:44:54','Inactiva'),(267,'douglas','2021-09-28','17:46:18','127.0.0.1','838515aaea9c0fc9ce53957d5d8221097f202bd1',3600,'2021-10-01 05:46:18','Inactiva'),(268,'douglas','2021-09-28','17:46:22','127.0.0.1','862a1da9c09bdd7415ce7be4ccbaac554e091530',3600,'2021-10-01 05:46:22','Inactiva'),(269,'douglas','2021-09-28','17:49:20','127.0.0.1','295898b1fe6440f78f12a8e650daae6de8da59d0',3600,'2021-10-01 06:06:19','Inactiva'),(270,'douglas','2021-09-28','18:07:28','127.0.0.1','2ca2b96f283b2e75e1074d7e023e0d2134d65e74',3600,'2021-10-03 02:24:33','Inactiva'),(271,'douglas','2021-09-30','14:20:37','192.168.0.42','fcf7780daa69aea048d7a9c6f3f59e67dd0803d2',3600,'2021-10-03 04:43:54','Inactiva'),(272,'douglas','2021-09-30','14:25:37','127.0.0.1','4006b2cc2b8890b7984addc66573dcffaf729ccd',3600,'2021-10-03 02:25:37','Inactiva'),(273,'douglas','2021-09-30','14:29:09','127.0.0.1','5d46b9989696ff37fa8658c0bf1caeed754ffccc',3600,'2021-10-03 03:49:10','Inactiva'),(274,'douglas','2021-09-30','15:52:13','127.0.0.1','41caa5f05516d47dc286f439e0938e2a9fa30f1f',3600,'2021-10-03 04:02:13','Inactiva'),(275,'douglas','2021-09-30','16:05:27','127.0.0.1','9f398a08f83fd73e9f80cde1132e161c0628d552',3600,'2021-10-03 04:05:27','Inactiva'),(276,'douglas','2021-09-30','16:06:38','127.0.0.1','db33d5c952fe1fdade3db695e59582fc94ac3c93',3600,'2021-10-03 04:06:38','Inactiva'),(277,'douglas','2021-09-30','16:07:32','127.0.0.1','a412409c7773e2684bb310065e356ac7b4aa017b',3600,'2021-10-03 04:42:33','Inactiva'),(278,'douglas','2021-09-30','16:44:04','192.168.0.42','c26901eafaae2a87e453ba3398605916580fad32',3600,'2021-10-03 04:44:04','Inactiva'),(279,'douglas','2021-09-30','16:56:24','192.168.0.42','bd08c53166875dc180a35edbf5daae2445a47a29',3600,'2021-10-03 04:56:24','Inactiva'),(280,'douglas','2021-09-30','16:57:06','127.0.0.1','8717b21eecbcc6065c0721dc025cda8b079fccc5',3600,'2021-10-03 05:02:06','Inactiva'),(281,'douglas','2021-09-30','17:03:37','192.168.0.42','14feabf8d5dcedfa2af037b2cce3c407498b5e73',3600,'2021-10-03 05:03:37','Inactiva'),(282,'douglas','2021-10-01','16:42:10','127.0.0.1','5bace05baa0e05e4a1c1ec65b768e8f8853883a9',3600,'2021-10-04 04:42:10','Inactiva'),(283,'douglas','2021-10-01','16:46:03','127.0.0.1','1e498e3f8a401cd0681dfc9ea36cf3ae09c72068',3600,'2021-10-04 04:51:03','Inactiva'),(284,'douglas','2021-10-01','17:04:35','127.0.0.1','6b75483e016bf6a87422b686c6c8349641c9b44a',3600,'2021-10-04 05:09:35','Inactiva'),(285,'douglas','2021-10-01','17:11:03','127.0.0.1','f8f2fed882450a13bf89daf9626aecb748d1b606',3600,'2021-10-04 05:11:03','Inactiva'),(286,'douglas','2021-10-01','17:11:15','127.0.0.1','735b7cac64284e4308c5450eb0aa2f8ad661d062',3600,'2021-10-04 05:17:14','Inactiva'),(287,'douglas','2021-10-01','17:20:37','127.0.0.1','04fcc9cadbc20f226ef0e8eb238b6af37e6836c3',3600,'2021-10-04 05:55:39','Inactiva'),(288,'douglas','2021-10-04','14:06:52','127.0.0.1','42e4b2db399ccad6fbbe14bc8aa03ab9b088460a',3600,'2021-10-07 02:06:52','Inactiva'),(289,'douglas','2021-10-04','14:08:00','127.0.0.1','b983b72f202d976f1466e2ef6be227eb63fade33',3600,'2021-10-07 02:08:00','Inactiva'),(290,'douglas','2021-10-04','14:09:54','127.0.0.1','f8f92f5ca9fd97d30a1c6b86f4e09b8a5b050f02',3600,'2021-10-07 02:13:00','Inactiva'),(291,'douglas','2021-10-04','14:13:43','127.0.0.1','96c79296d12c145a5c09af600645bad40e2e4c35',3600,'2021-10-07 02:14:55','Inactiva'),(292,'douglas','2021-10-04','14:18:05','127.0.0.1','f3603ad95565572f5691c0ba76f8a4abfe249c34',3600,'2021-10-07 02:33:06','Inactiva'),(293,'douglas','2021-10-04','14:36:21','127.0.0.1','1600d4778a9d502da7aa59b7c1e27ae67f908cc4',3600,'2021-10-07 03:46:23','Inactiva'),(294,'douglas','2021-10-04','15:59:17','127.0.0.1','038b232d30ba8e653507a5268f163c61c449033c',3600,'2021-10-07 03:59:17','Inactiva'),(295,'douglas','2021-10-04','16:01:53','127.0.0.1','600ac393c22bf0d2159225ddca19d6f5a4ac7959',3600,'2021-10-07 04:21:53','Inactiva'),(296,'douglas','2021-10-04','16:35:38','127.0.0.1','53a03a0f263adacc34ed15940cbdf1534ccc704c',3600,'2021-10-07 04:40:38','Inactiva'),(297,'douglas','2021-10-04','16:50:28','127.0.0.1','9e5dddc2713382c8b21441cfdb10aa7a92c14448',3600,'2021-10-07 04:55:28','Inactiva'),(298,'douglas','2021-10-04','17:00:23','127.0.0.1','c7205cb4a859905a5acdd52ba02cdf55dc3d2e32',3600,'2021-10-07 05:00:23','Inactiva'),(299,'douglas','2021-10-04','17:04:20','192.168.0.42','a71e1eca710f8179923dad39e47e4ae629248442',3600,'2021-10-07 05:09:48','Inactiva'),(300,'douglas','2021-10-04','17:11:04','192.168.0.42','9abaf5e3d333372dd02db2e348cdd4be3688ca3a',3600,'2021-10-07 05:11:04','Inactiva'),(301,'douglas','2021-10-04','17:16:34','127.0.0.1','29cb767bf52408a2193a9241be7650060f5619fe',3600,'2021-10-07 05:31:35','Inactiva'),(302,'douglas','2021-10-04','17:17:03','192.168.0.42','b21e7e6328f149a2b194f281c85eac74822a1caa',3600,'2021-10-07 05:17:03','Inactiva'),(303,'douglas','2021-10-04','17:21:30','192.168.0.42','9a065c2b0db8efa105385ae327e04b3217033747',3600,'2021-10-07 05:21:30','Inactiva'),(304,'douglas','2021-10-04','17:27:35','192.168.0.42','4da442a014acf8755071ca3d83057bfd0aec99b0',3600,'2021-10-07 05:27:35','Inactiva'),(305,'douglas','2021-10-04','17:29:06','192.168.0.42','2cde76e3404e8941fe689834e5be1e05824b56fc',3600,'2021-10-07 06:31:10','Inactiva'),(306,'douglas','2021-10-04','17:38:01','127.0.0.1','8347bf05b2e5c76e2ec58b5300390890743b9957',3600,'2021-10-07 05:48:02','Inactiva'),(307,'douglas','2021-10-05','15:56:08','127.0.0.1','57d8fe7852698ea78d40b4898756590524e50e84',3600,'2021-10-08 04:01:09','Inactiva'),(308,'douglas','2021-10-05','16:06:23','127.0.0.1','d480b85a66e7731467f997dd8cd327e69ec05013',3600,'2021-10-08 05:46:32','Inactiva'),(309,'douglas','2021-10-05','17:47:00','127.0.0.1','0dac92889c2544173fb522d7bccde07a15bf15a9',3600,'2021-10-08 05:47:00','Inactiva'),(310,'douglas','2021-10-05','17:49:18','127.0.0.1','c93174c5cbdb27e7c3c02c922fe333bee61694bb',3600,'2021-10-08 05:54:18','Inactiva'),(311,'douglas','2021-10-05','19:01:22','127.0.0.1','a70dbc7949d0f51accfdb3739bc12d734cd204c1',3600,'2021-10-08 07:01:22','Inactiva'),(312,'douglas','2021-10-05','19:03:03','127.0.0.1','084bfe65fb13b18e92213f4efb40bbcd6967febc',3600,'2021-10-08 07:08:04','Inactiva'),(313,'douglas','2021-10-05','19:17:13','127.0.0.1','36a6e1d5cdccf5da7ef3d70f5442c22954cf23c5',3600,'2021-10-08 07:22:13','Inactiva'),(314,'douglas','2021-10-05','19:26:59','127.0.0.1','57bf1596c5374068640464ce3ef728c6514aceea',3600,'2021-10-08 07:31:59','Inactiva'),(315,'douglas','2021-10-05','19:32:08','127.0.0.1','b501ea3b58ce2d90f8247011f463fe675a0a1848',3600,'2021-10-08 07:32:08','Inactiva'),(316,'douglas','2021-10-05','19:32:31','127.0.0.1','8d63b042ea856d4035c2f222cdc50eaaf22cc70f',3600,'2021-10-08 08:02:32','Inactiva'),(317,'douglas','2021-10-05','19:36:38','192.168.0.42','8c0dd012fa109eaa276897d6a0394bd891fe194f',3600,'2021-10-08 07:36:38','Inactiva'),(318,'douglas','2021-10-05','19:37:08','192.168.0.42','7720ff1f4faec4c1b1bd5d5f3d7006720f9e0e16',3600,'2021-10-08 07:37:08','Inactiva'),(319,'douglas','2021-10-05','19:37:34','192.168.0.42','5a0469f5c2db3ada55ab62f129e16116bfb64507',3600,'2021-10-08 07:37:34','Inactiva'),(320,'douglas','2021-10-05','19:37:44','192.168.0.42','a4f7e2c15280cc7b924aa2cd3d3b56887874d8d7',3600,'2021-10-08 07:37:44','Inactiva'),(321,'douglas','2021-10-05','20:09:07','127.0.0.1','db4f51a96c9d3909e6daef480cd908d3eaa5f9bd',3600,'2021-10-08 08:09:07','Inactiva'),(322,'douglas','2021-10-05','20:11:35','127.0.0.1','b6f1d07147bf31cfa254e725dc6a728a06827c1e',3600,'2021-10-08 08:11:35','Inactiva'),(323,'douglas','2021-10-05','20:14:21','127.0.0.1','4472c8d61432894aa48ee5174c2d8dd9736d6946',3600,'2021-10-08 08:14:21','Inactiva'),(324,'douglas','2021-10-05','20:15:04','127.0.0.1','58782088ac48f85ec987d4e6f0fbb60f5a79de2d',3600,'2021-10-08 08:25:04','Inactiva'),(325,'douglas','2021-10-05','20:27:34','127.0.0.1','a7e7573c3d32917f55e4b0ac800971084c8d629a',3600,'2021-10-08 08:27:34','Inactiva'),(326,'douglas','2021-10-05','20:28:14','127.0.0.1','16e3504f0fd189bdc9ee67f19c238ec507da7013',3600,'2021-10-08 08:48:14','Inactiva'),(327,'douglas','2021-10-05','20:50:57','127.0.0.1','e9dfa16fcb32515fdae0c5c721b93fdf4c3d6102',3600,'2021-10-08 08:50:57','Inactiva'),(328,'douglas','2021-10-05','20:53:50','127.0.0.1','3994de52565b2500e1fb915a58b15003cc8d7d03',3600,'2021-10-08 08:53:50','Inactiva'),(329,'douglas','2021-10-05','20:54:27','127.0.0.1','67b179743473b1f9032f3eaa454089c63cbc03ed',3600,'2021-10-08 08:54:27','Inactiva'),(330,'douglas','2021-10-06','16:31:58','127.0.0.1','d609714bc8fe946d744f26ed20279867ccb4b02f',3600,'2021-10-09 04:31:58','Inactiva'),(331,'douglas','2021-10-06','16:36:44','127.0.0.1','6b3c56e326e32a6549d1440ff772e7d7459ddc3f',3600,'2021-10-09 04:36:44','Inactiva'),(332,'douglas','2021-10-06','16:39:38','127.0.0.1','4dbb47c1eb4ed777e9579fc39d293dbb6c8f5e0d',3600,'2021-10-09 04:39:38','Inactiva'),(333,'douglas','2021-10-06','16:43:39','127.0.0.1','62c3e885932991298e034592e3de3979e69dc144',3600,'2021-10-09 04:48:39','Inactiva'),(334,'douglas','2021-10-06','16:50:36','127.0.0.1','a48d87c81cfb266ff2a75989e4b2daea8320ce20',3600,'2021-10-09 04:55:36','Inactiva'),(335,'douglas','2021-10-06','17:00:03','127.0.0.1','e27601e9d4633a89a999622765e8a28829ec20ca',3600,'2021-10-09 05:00:03','Inactiva'),(336,'douglas','2021-10-06','17:02:02','127.0.0.1','3ba8574b4d7eb9edbf27856fdd8ca05ff31de681',3600,'2021-10-09 05:02:02','Inactiva'),(337,'douglas','2021-10-06','17:03:58','127.0.0.1','f210002274e84f4ca890ce90aa7d5c7948f2788b',3600,'2021-10-09 05:13:59','Inactiva'),(338,'douglas','2021-10-06','17:16:48','127.0.0.1','2aaae77046e646b15a058abeb16b7898acb6e7ea',3600,'2021-10-09 05:21:48','Inactiva'),(339,'douglas','2021-10-06','17:26:19','127.0.0.1','af58e2321fa350330c0b5bc5a785e87750e7989b',3600,'2021-10-09 06:01:20','Inactiva'),(340,'douglas','2021-10-06','18:09:11','127.0.0.1','c5444329e6fb3337499ece16a681827d1e8023cd',3600,'2021-10-09 06:09:11','Inactiva'),(341,'douglas','2021-10-06','18:39:07','127.0.0.1','dea60294435cdc6c073be43bee376389d535478d',3600,'2021-10-09 06:39:07','Inactiva'),(342,'douglas','2021-10-06','18:42:25','127.0.0.1','7a2568e19efdaf048c5eb08c51b782a4410a8e3e',3600,'2021-10-09 06:42:25','Inactiva'),(343,'douglas','2021-10-06','18:43:26','127.0.0.1','b476de77b26f2fcfd152ae2dc46469afdd116c1c',3600,'2021-10-09 06:48:27','Inactiva'),(344,'douglas','2021-10-06','18:48:44','127.0.0.1','8da342dca6667ebd7b6e50190cb977c3a09ec562',3600,'2021-10-09 06:53:44','Inactiva'),(345,'douglas','2021-10-06','18:57:17','127.0.0.1','1bf9bd015a8a5d26ca6d751302ebd5ab7dd25886',3600,'2021-10-09 06:57:17','Inactiva'),(346,'douglas','2021-10-06','18:57:33','127.0.0.1','e7c74bd9bf69a90929e5f421479f30afd2012cf2',3600,'2021-10-09 07:02:33','Inactiva'),(347,'douglas','2021-10-06','19:06:12','127.0.0.1','8082ed20a0b4361961d275704154ccad23f59aab',3600,'2021-10-09 07:06:12','Inactiva'),(348,'douglas','2021-10-07','14:12:27','127.0.0.1','8765e2dbd2609b9ee26e6c3e033a0e6f45c33538',3600,'2021-10-10 02:17:28','Inactiva'),(349,'douglas','2021-10-07','14:14:03','192.168.0.42','7bee265721e3a4246445dd79050de50aaeda2863',3600,'2021-10-10 03:21:11','Inactiva'),(350,'douglas','2021-10-07','14:19:11','127.0.0.1','8a266a2e40fa7d11760132974676a2b328dd959a',3600,'2021-10-10 02:24:11','Inactiva'),(351,'douglas','2021-10-07','14:25:28','127.0.0.1','45b65f5b4c4e57bf2efdf197385a8133b3b17d64',3600,'2021-10-10 02:40:28','Inactiva'),(352,'douglas','2021-10-07','14:44:39','127.0.0.1','802bc571531c73c04dcb4768313b249ba581ba4f',3600,'2021-10-10 02:44:39','Inactiva'),(353,'douglas','2021-10-07','14:45:51','127.0.0.1','dca4798e77c05a7afff343aedec510a68275c4a9',3600,'2021-10-10 03:30:52','Inactiva'),(354,'douglas','2021-10-07','16:03:10','127.0.0.1','ab2e87a911ca3d0cc350338b647c78ec2d5ed861',3600,'2021-10-10 04:03:10','Inactiva'),(355,'douglas','2021-10-07','16:03:54','127.0.0.1','6180e28775b005c92a681404e55fdcdc6eca8946',3600,'2021-10-10 04:03:54','Inactiva'),(356,'douglas','2021-10-07','16:05:34','127.0.0.1','6b22c5ca356565a00b2bd116cda6bfd642ebc804',3600,'2021-10-10 04:05:34','Inactiva'),(357,'douglas','2021-10-07','16:08:53','127.0.0.1','edd6df1bf1b3ee9a2ef02e7ab8f7fd31a563e1cb',3600,'2021-10-10 04:48:54','Inactiva'),(358,'douglas','2021-10-07','16:36:30','192.168.0.42','a8456dc260fecf9e284104c5157947caa7fc58aa',3600,'2021-10-10 04:36:30','Inactiva'),(359,'douglas','2021-10-07','16:37:18','192.168.0.42','95c7a084d63621231dd49d8b703da80fd9d7aff6',3600,'2021-10-10 04:37:18','Inactiva'),(360,'douglas','2021-10-07','16:53:08','127.0.0.1','78193bdcb35c9a8345aef552a3ed804cd21f723d',3600,'2021-10-10 06:23:09','Inactiva'),(361,'douglas','2021-10-07','18:31:26','127.0.0.1','1aaaf39db238f2221fc44a93d7bb53d63ed7fcda',3600,'2021-10-10 06:46:27','Inactiva'),(362,'douglas','2021-10-08','17:31:47','127.0.0.1','b069a39c6ff681d70e8b487a90946d315d88b958',3600,'2021-10-11 05:41:49','Inactiva'),(363,'douglas','2021-10-08','17:44:59','127.0.0.1','4ab070e5a64902c1adf9c5d3ebb54676f8de3986',3600,'2021-10-11 05:49:59','Inactiva'),(364,'douglas','2021-10-08','17:50:28','127.0.0.1','8e8c5270290989410f6e61f4b478f6ff14e3770f',3600,'2021-10-11 06:25:29','Inactiva'),(365,'douglas','2021-10-08','18:40:15','127.0.0.1','e8cc2fc6fce9c8e3a4795d2a19bd6897dd6e57f3',3600,'2021-10-11 06:40:15','Inactiva'),(366,'douglas','2021-10-08','18:43:52','127.0.0.1','daa4594c259e586a2ce7563d8ec5adf8751235a7',3600,'2021-10-11 06:43:52','Inactiva'),(367,'douglas','2021-10-08','18:45:48','127.0.0.1','ce53a2ad293f77d4dbab1fc297705a3d63c2124b',3600,'2021-10-11 06:45:48','Inactiva'),(368,'douglas','2021-10-08','18:51:03','127.0.0.1','be617e653b5affb8e51a99d3b6b1e1a17c8db02c',3600,'2021-10-11 06:51:03','Inactiva'),(369,'douglas','2021-10-08','18:56:06','127.0.0.1','031f27c377bc1333952f2a8e57002bffe69d2c4a',3600,'2021-10-11 06:56:06','Inactiva'),(370,'douglas','2021-10-11','14:42:14','127.0.0.1','75e449935fa4289f080c2b2f175f6ac32482e2c3',3600,'2021-10-14 02:42:14','Inactiva'),(371,'douglas','2021-10-11','14:43:27','127.0.0.1','b3844228a0ff1afc3a92516819dcde06854417b9',3600,'2021-10-14 02:43:27','Inactiva'),(372,'douglas','2021-10-11','14:45:13','127.0.0.1','0a0c3ee24b71d22d9ae142961a54c70d2323c823',3600,'2021-10-14 03:40:15','Inactiva'),(373,'douglas','2021-10-11','15:42:20','127.0.0.1','fd3cd8696f5580632ac7161af59e4df929b4f32e',3600,'2021-10-14 03:42:20','Inactiva'),(374,'douglas','2021-10-11','15:48:21','127.0.0.1','a91fd3a5f078969a02ae83e050158ea709904f15',3600,'2021-10-14 03:52:20','Inactiva'),(375,'douglas','2021-10-11','15:53:13','127.0.0.1','a58c0e3985e289f863dd09ca0752615d873ce664',3600,'2021-10-14 03:53:13','Inactiva'),(376,'douglas','2021-10-11','15:55:57','127.0.0.1','0a0e1af2db6f4a2b7d0a5574ed1d04a10c4243f8',3600,'2021-10-14 03:55:57','Inactiva'),(377,'douglas','2021-10-11','15:56:38','127.0.0.1','8371ac5dc04abf5f7d3200c4f254f8b85e88df52',3600,'2021-10-14 06:16:39','Inactiva'),(378,'douglas','2021-10-11','18:20:50','127.0.0.1','4936ee4be142134ae152518fcd9af8d10bd6c7db',3600,'2021-10-14 06:25:51','Inactiva'),(379,'douglas','2021-10-11','18:27:46','127.0.0.1','f4b96c81d6394f5d7a5345bac2679db01f1723c4',3600,'2021-10-14 06:47:47','Inactiva'),(380,'douglas','2021-10-11','18:29:57','192.168.0.42','398e84c0790a210dcf3ceddd4d718e76a6427c68',3600,'2021-10-14 06:29:57','Inactiva'),(381,'douglas','2021-10-11','18:33:34','192.168.0.42','bf55b834510579090cdc0b91657e7aa2476129e1',3600,'2021-10-14 06:33:34','Inactiva'),(382,'douglas','2021-10-11','18:49:38','127.0.0.1','a8b3f74f88215252af3dcc67d0c7b0c06af39320',3600,'2021-10-14 06:54:39','Inactiva'),(383,'douglas','2021-10-11','18:50:30','192.168.0.42','240ab82ca18d72d9b66b80fb0ef375bb9bddb21d',3600,'2021-10-14 06:50:30','Inactiva'),(384,'douglas','2021-10-11','18:51:17','192.168.0.42','406eaa75c92d033ee9f76ebd7b3e965fa75c0a44',3600,'2021-10-14 06:51:17','Inactiva'),(385,'douglas','2021-10-11','18:52:05','192.168.0.42','05d8992621d875d10229cf795d8254c502050a5d',3600,'2021-10-14 06:52:05','Inactiva'),(386,'douglas','2021-10-12','14:26:30','127.0.0.1','23fa77d97144863acf1c11374d37cdffb5934e0e',3600,'2021-10-15 02:56:31','Inactiva'),(387,'douglas','2021-10-12','15:09:05','127.0.0.1','8e32f914f23d749e9a00b54090dac1e514bec339',3600,'2021-10-15 03:09:05','Inactiva'),(388,'douglas','2021-10-12','15:12:24','127.0.0.1','e52c200844c6479ea62b99d2e1d50dad13e21b33',3600,'2021-10-15 03:12:24','Inactiva'),(389,'douglas','2021-10-12','15:13:22','127.0.0.1','0b0c40bb262ade26fb8a26f3f00e404b9ad67970',3600,'2021-10-15 03:13:22','Inactiva'),(390,'douglas','2021-10-12','15:35:47','127.0.0.1','aace3071304937029a15f5ccb098d2735e7c6b6a',3600,'2021-10-15 03:55:48','Inactiva'),(391,'douglas','2021-10-12','16:09:16','127.0.0.1','cff1cbca69145415176d54702c1d26c6f23b6d9e',3600,'2021-10-15 04:24:16','Inactiva'),(392,'douglas','2021-10-12','16:31:03','127.0.0.1','de4a098e5ec425055f6940e45230eeba7ec18856',3600,'2021-10-15 04:31:03','Inactiva'),(393,'douglas','2021-10-12','16:31:12','127.0.0.1','b64dc3e1ab566a56800669a9a69b64914e3b1096',3600,'2021-10-15 04:31:12','Inactiva'),(394,'douglas','2021-10-12','16:33:42','127.0.0.1','0abb565b3cb3686daec186ad0e2bf5dd5e0c31a3',3600,'2021-10-15 04:58:42','Inactiva'),(395,'douglas','2021-10-12','17:03:09','127.0.0.1','f4e26676ee6f0ed815a6be873c2a98e83c97032e',3600,'2021-10-15 05:03:09','Inactiva'),(396,'douglas','2021-10-12','17:07:13','127.0.0.1','f66a7decf5dc5f0520aaf8653bbe50f5ac246ea8',3600,'2021-10-15 05:27:13','Inactiva'),(397,'douglas','2021-10-12','17:12:42','192.168.0.42','a0b34e49937a472a3799004fc56041cb14ea67bf',3600,'2021-10-15 05:18:11','Inactiva'),(398,'douglas','2021-10-12','17:20:15','192.168.0.42','e7dd466968263237f9c75b57549e640c025c25ab',3600,'2021-10-15 05:20:15','Inactiva'),(399,'douglas','2021-10-12','17:31:37','127.0.0.1','bf2de55f63c1e97e7e55d7fa1dc10daaac96a673',3600,'2021-10-15 05:56:38','Inactiva'),(400,'douglas','2021-10-13','14:39:28','127.0.0.1','536482c38c257fc8eb274012bc9090cb19dc5863',3600,'2021-10-16 03:54:31','Inactiva'),(401,'douglas','2021-10-13','15:54:59','127.0.0.1','d143bbdfb18b33ae88882c4ee09a3da0f5ff87bd',3600,'2021-10-16 04:24:59','Inactiva'),(402,'douglas','2021-10-13','16:35:49','127.0.0.1','badce8154ffdea73c716f83d51d00c0729a3276c',3600,'2021-10-16 04:45:00','Inactiva'),(403,'douglas','2021-10-14','15:47:33','127.0.0.1','ed5a638998580622477a5947d26fe9295844eb6f',3600,'2021-10-17 05:22:34','Inactiva'),(404,'douglas','2021-10-14','17:23:53','127.0.0.1','0965899f3be7232b9d504566d206b34122d6657f',3600,'2021-10-17 06:23:54','Inactiva'),(405,'douglas','2021-10-15','17:11:01','127.0.0.1','2331e66fe46c12340e8868a0588cf275fe421a09',3600,'2021-10-18 05:16:01','Inactiva'),(406,'douglas','2021-10-15','18:17:15','127.0.0.1','f4b3b232d0a21c0a8c90dc4c1781a73fbd381023',3600,'2021-10-18 06:17:15','Inactiva'),(407,'douglas','2021-10-15','18:18:45','127.0.0.1','27475676089518748cd48ab32ad26f62d380a45f',3600,'2021-10-18 06:18:45','Inactiva'),(408,'douglas','2021-10-15','18:37:28','127.0.0.1','fad6462b67e1b808e5a32cd59d99d1c1d600f181',3600,'2021-10-18 06:42:29','Inactiva'),(409,'douglas','2021-10-15','18:38:09','192.168.0.42','3b2b53e188acce3701dbd9a47c925b809bbacf72',3600,'2021-10-18 06:38:09','Inactiva'),(410,'douglas','2021-10-15','18:40:10','192.168.0.42','b150d58c502fa65b5d172597d1edd27eed60b467',3600,'2021-10-18 06:40:10','Inactiva'),(411,'douglas','2021-10-15','18:42:51','127.0.0.1','1aec614a7a94979c67530a33f1472fffa098ceee',3600,'2021-10-18 06:47:52','Inactiva'),(412,'douglas','2021-10-15','18:44:03','192.168.0.42','4a0af433e723cbf4fb79a9005568fdd27de60050',3600,'2021-10-18 06:44:03','Inactiva'),(413,'douglas','2021-10-15','18:53:55','127.0.0.1','a331d013b3f3979ff6a87b0341a4a37f7926a9cf',3600,'2021-10-18 06:53:55','Inactiva'),(414,'douglas','2021-10-15','18:54:54','127.0.0.1','8c132e1327b9ff6cf028bb9933e28883811e9fb3',3600,'2021-10-18 06:54:54','Inactiva'),(415,'douglas','2021-10-15','18:56:27','127.0.0.1','1aa30f815182b316c9562fad80909ea9703b975b',3600,'2021-10-18 06:56:27','Inactiva'),(416,'douglas','2021-10-15','18:59:36','127.0.0.1','666ccc30f0b463b549333f806d1a2f57a10cf247',3600,'2021-10-18 07:04:37','Inactiva'),(417,'douglas','2021-10-15','19:00:44','192.168.0.42','11cbd10404d02589790b363c276bf44d8f4289f4',3600,'2021-10-18 07:00:44','Inactiva'),(418,'douglas','2021-10-15','19:05:47','127.0.0.1','009ecc8be169a2c7a0ea0b6440500c20d1788952',3600,'2021-10-18 07:10:48','Inactiva'),(419,'douglas','2021-10-15','19:19:17','127.0.0.1','233eaf4070f78c9ba63bcaebda2bf643b2ad3e2f',3600,'2021-10-18 07:19:17','Inactiva'),(420,'douglas','2021-10-15','19:20:36','127.0.0.1','96c4346b52fcd51fe6da0d04740c6fb8cc29a0c5',3600,'2021-10-18 07:20:36','Inactiva'),(421,'douglas','2021-10-18','14:46:20','127.0.0.1','e1d8cabd3b51c99b6619b42e650cb922281f486c',3600,'2021-10-21 03:06:21','Inactiva'),(422,'douglas','2021-10-18','15:09:51','127.0.0.1','092fe0c463c43c639c1439bfa8817303e5214b26',3600,'2021-10-21 03:09:51','Inactiva'),(423,'douglas','2021-10-18','15:10:58','127.0.0.1','593e7a048c1e56edce27e374b288e5d53e7756ef',3600,'2021-10-21 03:10:58','Inactiva'),(424,'douglas','2021-10-18','15:13:00','127.0.0.1','543c2d63f9c2f783603b32311fbf881dc66ea314',3600,'2021-10-21 03:13:00','Inactiva'),(425,'douglas','2021-10-18','15:17:52','127.0.0.1','3616745e5dce43f25073ce2d41262f803dcc4238',3600,'2021-10-21 03:22:52','Inactiva'),(426,'douglas','2021-10-18','15:35:18','127.0.0.1','2f6c01dcbb8b00014c5f2e5780a3fa23fa4e7a3d',3600,'2021-10-21 03:35:18','Inactiva'),(427,'douglas','2021-10-18','15:36:29','127.0.0.1','dc79ead7b2d4273bb43809db95d53eb07f3043ce',3600,'2021-10-21 03:46:30','Inactiva'),(428,'douglas','2021-10-18','15:49:11','127.0.0.1','788aa12e0546cbc1d245c477a77764800aa05cce',3600,'2021-10-21 03:54:11','Inactiva'),(429,'douglas','2021-10-18','15:57:01','127.0.0.1','b1e30a324eef1e3c6635c56e800f25d98447d510',3600,'2021-10-21 04:02:01','Inactiva'),(430,'douglas','2021-10-18','16:12:02','127.0.0.1','175a64966ee52f1926ec0bd0962499d441a4794d',3600,'2021-10-21 04:12:02','Inactiva'),(431,'douglas','2021-10-18','16:15:56','127.0.0.1','1594616451727652f8403103591d0cab1219b03a',3600,'2021-10-21 04:15:56','Inactiva'),(432,'douglas','2021-10-18','16:17:19','127.0.0.1','0366b7f813b0aa6897e32ce7c9cc6afaca84c930',3600,'2021-10-21 04:17:19','Inactiva'),(433,'douglas','2021-10-18','16:18:46','127.0.0.1','1ec50c8d13536c02a5b74818b5a2f954cf79513e',3600,'2021-10-21 04:23:46','Inactiva'),(434,'douglas','2021-10-18','16:28:49','127.0.0.1','1e353fe1cea884dc518357c8826790a33b9d3801',3600,'2021-10-21 04:28:49','Inactiva'),(435,'douglas','2021-10-18','16:31:56','127.0.0.1','86cf045cb9c1ed9fa1128cde848970dba1427834',3600,'2021-10-21 05:56:56','Inactiva'),(436,'douglas','2021-10-18','19:43:19','127.0.0.1','e2b81c94634a836d02efe1d845ac5544d58cbda1',3600,'2021-10-21 07:58:19','Inactiva'),(437,'douglas','2021-10-19','14:11:36','127.0.0.1','8ba264d74e2360a364cb11b981ca3041e62d322f',3600,'2021-10-22 02:56:36','Inactiva'),(438,'douglas','2021-10-19','17:53:03','127.0.0.1','89800f1c75a9f0aa7aa0f7b7feabaf5b9b4929c4',3600,'2021-10-22 05:53:03','Inactiva'),(439,'douglas','2021-10-19','17:54:23','127.0.0.1','2c5164adccca86390e4821600f4aff2dd91e47c0',3600,'2021-10-22 05:59:24','Inactiva'),(440,'douglas','2021-10-19','18:03:21','127.0.0.1','0d467a48bf2f134c348de6a51eb634953bbdb176',3600,'2021-10-22 06:03:21','Inactiva'),(441,'douglas','2021-10-19','18:07:49','127.0.0.1','95b8ab8b56c6ce02f462633c6f95eb471279e786',3600,'2021-10-22 06:37:49','Inactiva'),(442,'douglas','2021-10-20','16:40:52','127.0.0.1','073aee59feb7e00b845053c338486c6b9141e198',3600,'2021-10-23 04:40:52','Inactiva'),(443,'douglas','2021-10-20','16:40:59','127.0.0.1','19acf1271c4ca773762fd95745111ea9c1fedd69',3600,'2021-10-23 07:26:03','Inactiva'),(444,'douglas','2021-10-20','18:25:12','192.168.0.42','c3a26fb209a2914105b59267f4ca28e2d6ff4a00',3600,'2021-10-23 06:25:12','Inactiva'),(445,'douglas','2021-10-21','14:21:28','127.0.0.1','865dc0760b81830da9e7181eb36502d06f96c46b',3600,'2021-10-24 02:26:30','Inactiva'),(446,'douglas','2021-10-21','14:32:20','127.0.0.1','89564e27b58fd60b034b6e4afe5141866f32f4ad',3600,'2021-10-24 02:37:21','Inactiva'),(447,'douglas','2021-10-21','14:39:07','127.0.0.1','27e55236aee1f5a2c1672b9bb4c1581436bb8fda',3600,'2021-10-24 02:44:07','Inactiva'),(448,'douglas','2021-10-21','14:49:29','127.0.0.1','37f7fefcc410c0754ecec31530c629386a5d5353',3600,'2021-10-24 02:59:30','Inactiva'),(449,'douglas','2021-10-21','15:04:06','127.0.0.1','7eec0582af513f30def14d77740ecaf4ebf73307',3600,'2021-10-24 04:19:08','Inactiva'),(450,'douglas','2021-10-21','16:23:59','127.0.0.1','cb7c9012410335389ccb6469d8f2cc259a784dbd',3600,'2021-10-24 04:29:00','Inactiva'),(451,'douglas','2021-10-21','16:33:37','127.0.0.1','625485ef1a5dc7b4082b0245734dfce5ff3eb204',3600,'2021-10-24 05:13:37','Inactiva'),(452,'douglas','2021-10-21','17:14:09','127.0.0.1','abc556e6934ce4d68ee0ce4f1c0c80f174da37f3',3600,'2021-10-24 05:14:09','Inactiva'),(453,'douglas','2021-10-21','17:18:48','127.0.0.1','673fc63139299de77e2f4235a68bb312015e89c6',3600,'2021-10-24 05:18:48','Inactiva'),(454,'douglas','2021-10-21','17:19:46','127.0.0.1','0f70e498bfc694c9696bf9baaef75cb39abd6b36',3600,'2021-10-24 05:19:46','Inactiva'),(455,'douglas','2021-10-21','17:20:44','127.0.0.1','2a72db20d25bf1c798dcf49d5c8bd42674622009',3600,'2021-10-24 05:40:45','Inactiva'),(456,'douglas','2021-10-21','17:28:59','192.168.0.42','e2475dbfc22509ba0fb65a3cfd67ca9fc0e54238',3600,'2021-10-24 05:28:59','Inactiva'),(457,'douglas','2021-10-21','17:30:25','192.168.0.42','dedab87a15a0df3302d803612b25725bf2673d16',3600,'2021-10-24 05:43:34','Inactiva'),(458,'douglas','2021-10-22','15:53:59','127.0.0.1','f3560dca80b613e229db82a3222d35ef0e84f47f',3600,'2021-10-25 03:59:00','Inactiva'),(459,'douglas','2021-10-22','16:03:34','127.0.0.1','dd7c12e418465271c27d931e62ae67f28480b343',3600,'2021-10-25 04:08:34','Inactiva'),(460,'douglas','2021-10-25','14:13:59','127.0.0.1','2fe0d4a3e54e5d9df747d3c27bc8c9027fee56b2',3600,'2021-10-28 02:13:59','Inactiva'),(461,'douglas','2021-10-25','14:14:21','127.0.0.1','07ece837e3be1445dbe1d0be732ef01668d959b4',3600,'2021-10-28 02:29:21','Inactiva'),(462,'douglas','2021-10-25','14:29:48','127.0.0.1','145af27137df179b13369ff7c8f4542f5884495e',3600,'2021-10-28 02:34:49','Inactiva'),(463,'douglas','2021-10-25','14:36:12','127.0.0.1','0c5f87ed59c7db0398e3efd354882a633f6e2357',3600,'2021-10-28 02:36:12','Inactiva'),(464,'douglas','2021-10-25','14:37:10','127.0.0.1','74e9f96d092e089f343319f9b7eb8435d9d02aac',3600,'2021-10-28 02:37:10','Inactiva'),(465,'douglas','2021-10-25','14:41:38','127.0.0.1','fd74b30ca0ad99d012adbadf57f0acd7ae5726c3',3600,'2021-10-28 02:41:38','Inactiva'),(466,'douglas','2021-10-25','14:42:20','127.0.0.1','7a58a2854cc271a45f74796e0543777e48a2856b',3600,'2021-10-28 02:42:20','Inactiva'),(467,'douglas','2021-10-25','14:42:57','127.0.0.1','b2d37d71d265f24db668b487d558bb541e15af9c',3600,'2021-10-28 02:47:57','Inactiva'),(468,'douglas','2021-10-25','14:48:15','127.0.0.1','8d1e2eeaa3d370f10a9375539b82624c55197a6b',3600,'2021-10-28 02:48:15','Inactiva'),(469,'douglas','2021-10-25','14:49:53','127.0.0.1','ba09125dab0535a1e497d3de52922b2960d0e428',3600,'2021-10-28 03:09:54','Inactiva'),(470,'douglas','2021-10-25','15:12:55','127.0.0.1','e7633dc82c9fa7a072c9293ff4133920038c3316',3600,'2021-10-28 03:12:55','Inactiva'),(471,'douglas','2021-10-25','15:16:30','127.0.0.1','5f5173a91287a75cf8dceb5d3dd18e3b3925f859',3600,'2021-10-28 03:26:31','Inactiva'),(472,'douglas','2021-10-25','15:27:18','127.0.0.1','127721e3a74cb89f548a01be230579a7213c5b73',3600,'2021-10-29 03:44:53','Inactiva'),(473,'douglas','2021-10-26','15:46:01','127.0.0.1','772698c41ec71b86c1fee5a1f4877babcde08bab',3600,'2021-10-29 03:46:01','Inactiva'),(474,'douglas','2021-10-26','15:49:06','127.0.0.1','6f695ba2f620c7677a281e7a3618caf035b84e12',3600,'2021-10-29 04:14:08','Inactiva'),(475,'douglas','2021-10-26','16:15:13','127.0.0.1','a28723406983cbfdfb608fd239d55be0c054e096',3600,'2021-10-29 04:15:13','Inactiva'),(476,'douglas','2021-10-26','16:16:53','127.0.0.1','c21b17ac930db5c695a8effffe061559e671c905',3600,'2021-10-29 04:16:53','Inactiva'),(477,'douglas','2021-10-26','16:17:16','127.0.0.1','44a1549e105c9f57483ca6a52e38b873e00235a7',3600,'2021-10-29 04:17:16','Inactiva'),(478,'douglas','2021-10-26','16:19:32','127.0.0.1','99e87bc169d256f437eda3783eb2404108d6bc50',3600,'2021-10-29 04:19:32','Inactiva'),(479,'douglas','2021-10-26','16:20:21','127.0.0.1','7a331f91697a47ca03e376d5baea354eb32410ca',3600,'2021-10-29 04:30:21','Inactiva'),(480,'douglas','2021-10-26','16:22:06','192.168.0.42','343ca0057c60bd8818e987366983b74ad42cf09f',3600,'2021-10-29 04:22:06','Inactiva'),(481,'douglas','2021-10-26','16:31:54','127.0.0.1','86f4df6111009ea003a0115691df5dd77cbc2992',3600,'2021-10-29 04:31:54','Inactiva'),(482,'douglas','2021-10-26','16:33:18','127.0.0.1','e56ee5d13b819bf267d55837a97dedaaa090d536',3600,'2021-10-29 04:38:19','Inactiva'),(483,'douglas','2021-10-26','16:38:38','127.0.0.1','f2a786b3b2460ab615b2b7cd1b8bff3fa5050a17',3600,'2021-10-30 02:41:05','Inactiva'),(484,'douglas','2021-10-26','17:09:37','192.168.0.42','6155b01ca7ca7bd67e5a73f433e3277920a37ef6',3600,'2021-10-29 05:09:37','Inactiva'),(485,'douglas','2021-10-27','14:43:00','127.0.0.1','7bf2ad4e258790d7899f10eb144d4ae9e1a3efe9',3600,'2021-10-30 02:48:01','Inactiva'),(486,'douglas','2021-10-27','14:52:34','127.0.0.1','e79d37118bef2b73050297c69f22a9eb30cf3a24',3600,'2021-10-30 02:52:34','Inactiva'),(487,'douglas','2021-10-27','14:53:42','127.0.0.1','bebb57c158cdf342053ca6d30ea4d74c768db362',3600,'2021-10-30 02:53:42','Inactiva'),(488,'douglas','2021-10-27','14:53:50','127.0.0.1','8b70119bb13d7e3f3f29090b593e4854521cbcab',3600,'2021-10-30 03:03:51','Inactiva'),(489,'douglas','2021-10-27','15:05:06','127.0.0.1','85085d3255a37ff6577345b96dad16f37055e258',3600,'2021-10-30 03:10:07','Inactiva'),(490,'douglas','2021-10-27','15:19:43','127.0.0.1','6248f2e101752a604cd37c33b2b4bf9423abb5b2',3600,'2021-10-30 03:44:43','Inactiva'),(491,'douglas','2021-10-27','15:49:34','127.0.0.1','fee4b03c37e7e3e33f74f18be7854db74007f0a4',3600,'2021-10-30 03:54:35','Inactiva'),(492,'douglas','2021-10-27','16:21:02','127.0.0.1','ac4ad4a9dbe16087c6d71ce00f10dc812c3dd2a7',3600,'2021-10-30 04:31:02','Inactiva'),(493,'douglas','2021-10-27','16:57:33','127.0.0.1','cf7c4117b197fa39aed4eeee23956502bbccf439',3600,'2021-10-30 05:02:34','Inactiva'),(494,'douglas','2021-10-27','17:03:28','127.0.0.1','4f64b7f38b46dfac930fea9eb4e25dee84987eaa',3600,'2021-10-30 05:03:28','Inactiva'),(495,'douglas','2021-10-27','17:07:06','127.0.0.1','6d3e50d385e94720d546917c5c66037ac66a2b06',3600,'2021-10-30 05:07:06','Inactiva'),(496,'douglas','2021-10-27','17:09:23','127.0.0.1','f245fcb94a5bcf8345a92ac9f20d11a29ba020d7',3600,'2021-10-30 05:09:23','Inactiva'),(497,'douglas','2021-10-27','17:11:04','127.0.0.1','462ec27ce6a8ff4e8c397f6eb18b5cb35c1b6a0a',3600,'2021-10-30 05:11:04','Inactiva'),(498,'douglas','2021-10-27','17:14:33','127.0.0.1','e848891f59c1570d414b341a6789c84a9b6b89e4',3600,'2021-10-30 05:44:34','Inactiva'),(499,'douglas','2021-10-27','17:50:47','127.0.0.1','1f885159ac75922a30c435c185b03ff91ea63dcf',3600,'2021-10-30 05:50:47','Inactiva'),(500,'douglas','2021-10-27','17:52:06','127.0.0.1','5d53c0cd6ddb6976edc6481adaaa35247552a63f',3600,'2021-10-30 05:52:06','Inactiva'),(501,'douglas','2021-10-27','17:53:38','127.0.0.1','6860af63a58b159fb7178a4e3fb81d0121a3366f',3600,'2021-10-30 06:03:38','Inactiva'),(502,'douglas','2021-10-29','17:06:24','127.0.0.1','1f45ddd160470980f2004b7d8ff15ec6fbad0866',3600,'2021-11-01 05:06:24','Inactiva'),(503,'douglas','2021-10-29','17:11:33','127.0.0.1','e0985268246dbe38c0141dedba2d416c0bd8a999',3600,'2021-11-01 05:11:33','Inactiva'),(504,'douglas','2021-10-29','17:11:39','127.0.0.1','e23e55505c6a854eb421d98aa010f514e8047a5d',3600,'2021-11-01 06:01:40','Inactiva'),(505,'douglas','2021-10-29','18:06:28','127.0.0.1','189aef24fb3dc609070074f7a4bbef315b138278',3600,'2021-11-01 06:06:28','Inactiva'),(506,'douglas','2021-10-29','18:09:26','127.0.0.1','d6d397471d9034aa5c18bba8cad828d602428aa2',3600,'2021-11-01 06:09:26','Inactiva'),(507,'douglas','2021-10-29','18:14:27','127.0.0.1','df894f878e66d874c5f67796d21e944db625263d',3600,'2021-11-01 06:19:28','Inactiva'),(508,'douglas','2021-10-29','18:22:07','127.0.0.1','1b76fa5ec20a694009ce1c6cda9e28d024405835',3600,'2021-11-01 06:22:07','Inactiva'),(509,'douglas','2021-10-29','18:29:01','127.0.0.1','4a1e93e0ca5b822aa8c240a4bc74dbfac1820dec',3600,'2021-11-01 06:29:01','Inactiva'),(510,'douglas','2021-10-29','18:30:28','127.0.0.1','4e607ed9d88a3d415da2eb02f17d6491b7fb0b60',3600,'2021-11-01 06:30:28','Inactiva'),(511,'douglas','2021-10-29','18:32:02','127.0.0.1','17b9e56d2a80db856f7989623e4242372d66f088',3600,'2021-11-01 06:37:02','Inactiva'),(512,'douglas','2021-10-29','18:38:12','127.0.0.1','91974323ebeeb97375fcd80bebb2353424d0e730',3600,'2021-11-01 06:38:12','Inactiva'),(513,'douglas','2021-10-29','18:38:58','127.0.0.1','4aaf34d7dc208a3ff9b2ecf9038e05f6c10ce5f8',3600,'2021-11-01 06:38:58','Inactiva'),(514,'douglas','2021-10-29','19:17:53','127.0.0.1','915d5150ca0b6d3d8e076a96c380149f76078417',3600,'2021-11-01 07:32:53','Inactiva'),(515,'douglas','2021-11-01','19:43:42','127.0.0.1','3b3946ce471e73be7a84a76b4179f94b63a16f1a',3600,'2021-11-04 07:43:42','Inactiva'),(516,'douglas','2021-11-01','20:07:27','127.0.0.1','a018937bd8fa0846dff56ce3dbb07c6aa84ecca7',3600,'2021-11-04 08:07:27','Inactiva'),(517,'douglas','2021-11-01','20:09:06','192.168.0.20','4327c6a49773cbb54cf89bbfb6ba165cd8a76d11',3600,'2021-11-04 08:14:07','Inactiva'),(518,'douglas','2021-11-01','20:19:09','192.168.0.20','9d81d31861326ae79b11f1dfd22b5669bc713fac',3600,'2021-11-04 09:34:09','Inactiva'),(519,'douglas','2021-11-01','20:44:21','127.0.0.1','d493b36daa2032c12a28fed95308db23de05258a',3600,'2021-11-04 08:54:21','Inactiva'),(520,'douglas','2021-11-01','21:02:21','127.0.0.1','6a6f9e94b6c0f19aa1c9cca430ac049311c9043f',3600,'2021-11-04 09:37:22','Inactiva'),(521,'douglas','2021-11-02','14:24:53','127.0.0.1','b2d6871506a5e7fc9c4d612ceca2bda7270695c8',3600,'2021-11-05 02:24:53','Inactiva'),(522,'douglas','2021-11-02','14:26:14','127.0.0.1','11b7fd713bda885c395d40808bd4f4171f8cd487',3600,'2021-11-05 02:26:14','Inactiva'),(523,'douglas','2021-11-02','14:28:55','127.0.0.1','c1d49889e999257bb1b3446039b804f85a55df63',3600,'2021-11-05 02:33:55','Inactiva'),(524,'douglas','2021-11-02','14:42:49','127.0.0.1','542266fe86498319ab427f0eef4166d7de1eb9be',3600,'2021-11-05 02:42:49','Inactiva'),(525,'douglas','2021-11-02','14:43:20','127.0.0.1','474bdeb2a8c9ee268bd2b6cd56ab162955e60b79',3600,'2021-11-05 02:48:20','Inactiva'),(526,'douglas','2021-11-02','14:55:55','127.0.0.1','6bdedd4f1db8a37b57272156fb1ebcf494efd77c',3600,'2021-11-05 02:55:55','Inactiva'),(527,'douglas','2021-11-02','14:58:40','127.0.0.1','11cec04340cbf82d15d7bc59e2627799866f1734',3600,'2021-11-05 02:58:40','Inactiva'),(528,'douglas','2021-11-02','14:59:07','127.0.0.1','c5449b27918fe30aa32a2201a12c47205e105317',3600,'2021-11-05 02:59:07','Inactiva'),(529,'douglas','2021-11-02','15:01:26','127.0.0.1','71538f60b566f46336243407e7deeaa499b7ec14',3600,'2021-11-05 03:01:26','Inactiva'),(530,'douglas','2021-11-02','15:02:15','127.0.0.1','9bfd6860f728f8e7e15fc9b5253c3e0eb3a35688',3600,'2021-11-05 03:02:15','Inactiva'),(531,'douglas','2021-11-02','15:05:11','127.0.0.1','565e83082a809616307fc9d0d414ea32ed193998',3600,'2021-11-05 03:10:11','Inactiva'),(532,'douglas','2021-11-02','15:15:14','127.0.0.1','1478d6827abd666858bb251383dece2b426ebb28',3600,'2021-11-05 03:30:15','Inactiva'),(533,'douglas','2021-11-02','15:30:54','127.0.0.1','47fe27ab38fdfcbbb8c4d9d11d50c87b631652d8',3600,'2021-11-05 03:30:54','Inactiva'),(534,'douglas','2021-11-02','15:32:46','127.0.0.1','4af9257b0d81e45345eb7228a1609f66d00df225',3600,'2021-11-05 03:32:46','Inactiva'),(535,'douglas','2021-11-02','15:33:50','127.0.0.1','bc467f4694e520c5b09bd36ff076dc175a7b0e24',3600,'2021-11-05 03:33:50','Inactiva'),(536,'douglas','2021-11-02','15:35:26','127.0.0.1','9b47f9cfef8a5bf37cae09d23204ccbc8051e2ff',3600,'2021-11-05 03:40:27','Inactiva'),(537,'douglas','2021-11-02','15:40:39','127.0.0.1','d0ecdd973005663b809ab182d96f64b6b90732e8',3600,'2021-11-05 03:50:40','Inactiva'),(538,'douglas','2021-11-02','15:51:18','127.0.0.1','ed5121324e60fccf5f0b3985fef821d83104c0ce',3600,'2021-11-05 03:56:18','Inactiva'),(539,'douglas','2021-11-02','16:03:04','127.0.0.1','2a57f4e26f07a4a434b4b4b7d233c00ade287742',3600,'2021-11-05 04:03:04','Inactiva'),(540,'douglas','2021-11-02','16:03:12','127.0.0.1','0f6c1b205eb494583267e5b2c1b7846ab4212940',3600,'2021-11-05 04:03:12','Inactiva'),(541,'douglas','2021-11-02','16:03:17','127.0.0.1','945d49b20d79306e1ab2acdbf7a811665ea9942f',3600,'2021-11-05 04:03:17','Inactiva'),(542,'douglas','2021-11-02','16:03:49','127.0.0.1','fb50c8f88f66d2d8da59d9d118f676e881919365',3600,'2021-11-05 04:03:49','Inactiva'),(543,'douglas','2021-11-02','16:04:36','192.168.0.42','9f98d89692975a5f012fdd9543700c37a9e735dc',3600,'2021-11-05 04:04:36','Inactiva'),(544,'douglas','2021-11-02','16:04:57','192.168.0.42','90a93c159bf0b266ebc6e407af6139b70e3b4ffc',3600,'2021-11-05 04:04:57','Inactiva'),(545,'douglas','2021-11-02','16:07:36','127.0.0.1','5b0b3d292950cd86da5a87db48cd734736dc98ee',3600,'2021-11-05 04:07:36','Inactiva'),(546,'douglas','2021-11-02','16:07:46','192.168.0.42','974cac24cb0ac227b4714b36532a71bc0f84f00c',3600,'2021-11-05 04:07:46','Inactiva'),(547,'douglas','2021-11-02','16:08:27','192.168.0.42','2368d2dfea493397533582a095168159e979c1dc',3600,'2021-11-05 04:08:27','Inactiva'),(548,'douglas','2021-11-02','16:13:52','127.0.0.1','d713bfb15e5b83f043421c51b25042d50ec1a85e',3600,'2021-11-05 04:13:52','Inactiva'),(549,'douglas','2021-11-02','16:14:32','192.168.0.42','af546b25031ca09fa6af86ff3ae936d4d9cf6986',3600,'2021-11-05 04:14:32','Inactiva'),(550,'douglas','2021-11-02','16:15:45','127.0.0.1','2337a188d2609fcd7b960792d0fe34662b93073e',3600,'2021-11-05 04:20:46','Inactiva'),(551,'douglas','2021-11-05','15:10:41','127.0.0.1','c433f4c1d3c67e91f20d8a9a83dddba4ec659597',3600,'2021-11-08 03:40:44','Inactiva'),(552,'douglas','2021-11-09','14:49:03','127.0.0.1','6a26c69e4ad9e335bc2ab95e52bd9117f855ed65',3600,'2021-11-12 02:49:03','Inactiva'),(553,'douglas','2021-11-09','15:10:16','127.0.0.1','28385a4451af802caaddf5679902b0bb629e7cd6',3600,'2021-11-12 03:10:16','Inactiva'),(554,'douglas','2021-11-09','15:10:57','127.0.0.1','45df7dc3533f3c465bb12efbe3c9d10c471567da',3600,'2021-11-12 03:15:57','Inactiva'),(555,'douglas','2021-11-09','15:18:58','127.0.0.1','aa5cf044bc3c1b8ff6edc939d8fd966673c2a71a',3600,'2021-11-12 03:18:58','Inactiva'),(556,'douglas','2021-11-09','15:19:06','127.0.0.1','22009ba03ae7028d8028b94b75ee4b75b92d331a',3600,'2021-11-12 03:24:07','Inactiva'),(557,'douglas','2021-11-09','15:26:43','127.0.0.1','905b58ca9166201992a4bbb2b71b3c07fcdeb1ef',3600,'2021-11-12 03:31:44','Inactiva'),(558,'douglas','2021-11-09','15:32:39','127.0.0.1','ca138f5788d629d6ffb4eb470f8defb2acf2aec7',3600,'2021-11-12 03:42:40','Inactiva'),(559,'douglas','2021-11-09','15:52:36','127.0.0.1','fd4d31cc4950c82876f0aeabbf8270f6ccb1afef',3600,'2021-11-12 04:02:37','Inactiva'),(560,'douglas','2021-11-09','16:06:10','127.0.0.1','36f3996bd51a078709b636c1ecf634b82069c25e',3600,'2021-11-12 04:11:10','Inactiva'),(561,'douglas','2021-11-09','16:11:44','127.0.0.1','ed3f30cfb690942253d12d3b4c64a8547e494daa',3600,'2021-11-12 04:11:44','Inactiva'),(562,'douglas','2021-11-09','16:14:52','127.0.0.1','6aba0cd992fc8d5f8dce90bcc905ed52bdd05c7d',3600,'2021-11-13 04:24:56','Inactiva'),(563,'douglas','2021-11-10','16:26:52','127.0.0.1','ec97a7b848a4431df18c2f4b46cc77e8ed7eee4f',3600,'2021-11-13 04:51:52','Inactiva'),(564,'douglas','2021-11-10','16:33:04','::1','5f6163f652fc0e76c69e0fa1f7819e8afcc34cca',3600,'2021-11-13 04:38:05','Inactiva'),(565,'douglas','2021-11-10','16:55:30','127.0.0.1','965d20fbf302025e63d185f0fd55340bbd463dcb',3600,'2021-11-13 04:55:30','Inactiva'),(566,'douglas','2021-11-10','16:56:13','127.0.0.1','b7fca7694fb11b7f3fe84944b339ad196eb7b62f',3600,'2021-11-13 04:56:13','Inactiva'),(567,'douglas','2021-11-10','17:01:18','127.0.0.1','ec443a48d800f6b3c2344d26330c96693c470e56',3600,'2021-11-13 05:11:19','Inactiva'),(568,'douglas','2021-11-11','15:30:46','127.0.0.1','7fa5f8bf91be0d22ab956da4722c4429d21f18be',3600,'2021-11-14 03:35:52','Inactiva'),(569,'douglas','2021-11-11','16:12:37','127.0.0.1','159a938d90296cd08c1858f5a2192079511aadbc',3600,'2021-11-14 04:12:37','Inactiva'),(570,'douglas','2021-11-11','16:13:22','127.0.0.1','4475d00860139db6c724918d31cdefcdad0deea7',3600,'2021-11-14 04:23:22','Inactiva'),(571,'douglas','2021-11-11','16:24:48','127.0.0.1','d8689e0a275ff1258a1987be4cc71e92c7d0b902',3600,'2021-11-14 04:24:48','Inactiva'),(572,'douglas','2021-11-11','16:25:49','127.0.0.1','3da30840a5bce045b38d5b3e9ac8980a145ffd52',3600,'2021-11-14 04:30:50','Inactiva'),(573,'douglas','2021-11-11','16:36:53','127.0.0.1','f828c77d3e86589d631dc9a913c2993aac91a588',3600,'2021-11-14 04:36:53','Inactiva'),(574,'douglas','2021-11-11','16:41:53','127.0.0.1','76cc746ee750ac1f21138d5007d0fb471957f811',3600,'2021-11-14 04:41:53','Inactiva'),(575,'douglas','2021-11-11','16:42:13','127.0.0.1','5a5a4f5b79c0762a376cb315b0ad9a76536ad6f1',3600,'2021-11-14 04:47:14','Inactiva'),(576,'douglas','2021-11-11','16:50:24','127.0.0.1','119e22934a0ee3d27aa3225520ee92bbed914128',3600,'2021-11-14 04:50:24','Inactiva'),(577,'douglas','2021-11-11','16:53:39','127.0.0.1','be0af2b114491a680250ae06702d68b128c5a11b',3600,'2021-11-14 04:58:40','Inactiva'),(578,'douglas','2021-11-11','17:03:42','127.0.0.1','5885556d524cd6efb0ffeea41493441f4e7dffd7',3600,'2021-11-14 05:03:42','Inactiva'),(579,'douglas','2021-11-11','17:08:56','127.0.0.1','0705811958421768c40e58dfad73e51775b90439',3600,'2021-11-14 05:13:56','Inactiva'),(580,'douglas','2021-11-15','15:45:44','127.0.0.1','b00da41dde80c0722e39d5a6c4266691f38c91cf',3600,'2021-11-18 03:50:45','Inactiva'),(581,'douglas','2021-11-15','16:03:02','127.0.0.1','9d590e5ae7b01f87b4d08bf538c0923d83c3fd24',3600,'2021-11-18 04:43:03','Inactiva'),(582,'douglas','2021-11-15','16:46:12','127.0.0.1','7321d0a39639d5753447289cb893e053927f3378',3600,'2021-11-18 04:56:12','Inactiva'),(583,'douglas','2021-11-15','17:00:44','127.0.0.1','42a5ebef6788dbae48498e9fdfeec822e655a835',3600,'2021-11-18 05:15:45','Inactiva'),(584,'douglas','2021-11-15','17:19:36','127.0.0.1','67ce661513e22d9d8d16da3d79e63a42ac382aaa',3600,'2021-11-18 05:19:36','Inactiva'),(585,'douglas','2021-11-15','17:25:48','127.0.0.1','194a66995d5736c320a81239836145c397544a46',3600,'2021-11-18 05:25:48','Inactiva'),(586,'douglas','2021-11-15','17:26:51','127.0.0.1','add5bedd16773e7b76595b0a38738bf3fe8f0add',3600,'2021-11-18 05:26:51','Inactiva'),(587,'douglas','2021-11-15','17:27:28','127.0.0.1','5885b34b8d55bacb3c5821813d2143ba5867f9aa',3600,'2021-11-18 05:27:28','Inactiva'),(588,'douglas','2021-11-15','17:28:12','127.0.0.1','43ffaf3b6eeee5b90bd3a0797ac1172663697774',3600,'2021-11-18 05:28:12','Inactiva'),(589,'douglas','2021-11-15','17:29:42','127.0.0.1','a9549528e79601c3d81ce09499e3967cc4b5c4de',3600,'2021-11-18 05:29:42','Inactiva'),(590,'douglas','2021-11-15','17:30:27','127.0.0.1','0ecae841861ef168cda40623385e6d27ef88a4f8',3600,'2021-11-18 05:30:27','Inactiva'),(591,'douglas','2021-11-15','17:31:31','127.0.0.1','e89fd15d7377c0cd6b67f132a43b225b93ea0805',3600,'2021-11-18 06:01:32','Inactiva'),(592,'douglas','2021-11-15','18:10:19','127.0.0.1','f1e4df2208bfe1fd0d8dcb5832ff3e3bc64c76c1',3600,'2021-11-18 06:15:20','Inactiva'),(593,'douglas','2021-11-17','15:13:18','127.0.0.1','e30ced10f7fb97711b96efdddfed41e0b5e1314d',3600,'2021-11-20 03:13:18','Inactiva'),(594,'douglas','2021-11-17','15:17:39','127.0.0.1','ef5ed9131f5b8e848a41489b20f46980047992b1',3600,'2021-11-20 03:22:40','Inactiva'),(595,'douglas','2021-11-17','15:23:07','127.0.0.1','88fcac4cf545373c7b8d1300b9953c095b10ae5d',3600,'2021-11-20 03:28:08','Inactiva'),(596,'douglas','2021-11-17','15:39:03','127.0.0.1','6864d7683faddc380ab540e9f82bd36fdba182b0',3600,'2021-11-20 04:09:04','Inactiva'),(597,'douglas','2021-11-17','16:24:38','127.0.0.1','760e5228a2abfc7d0b5df8e72f838a347647b21f',3600,'2021-11-20 04:24:38','Inactiva'),(598,'douglas','2021-11-17','16:25:11','127.0.0.1','40ed0c9569a8f141b5b6c6956e908011cd4ac233',3600,'2021-11-20 04:25:11','Inactiva'),(599,'douglas','2021-11-17','16:37:38','192.168.0.36','9cf34f0b4c169eae3a4a8a13bec6f3e2cd3b84fa',3600,'2021-11-20 05:42:38','Inactiva'),(600,'douglas','2021-11-17','17:14:24','127.0.0.1','5dd1dd9a1cfab0cc2ea3be88671963f190bbd319',3600,'2021-11-20 06:14:25','Inactiva'),(601,'douglas','2021-11-23','15:59:53','127.0.0.1','7f647596407e4bb70bcdd43c9d8547faba852280',3600,'2021-11-26 04:14:55','Inactiva'),(602,'douglas','2021-11-23','16:17:13','127.0.0.1','771ecbefbfa24c3d5683c6c156f8b8bb59b6d2cd',3600,'2021-11-26 04:17:13','Inactiva'),(603,'douglas','2021-11-23','16:18:23','127.0.0.1','4c94002f8e2237aee4ac840696eb7711dfb278e1',3600,'2021-11-26 04:28:23','Inactiva'),(604,'douglas','2021-11-29','16:22:56','127.0.0.1','a7addb8266dc2f6507cd0e806f37f1631f8011da',3600,'2021-12-03 04:59:42','Inactiva'),(605,'douglas','2021-11-30','17:45:22','127.0.0.1','13a7154990bc1221fdce9ada848c1c34d7cd3db1',3600,'2021-12-03 05:50:23','Inactiva'),(606,'douglas','2021-11-30','18:04:44','127.0.0.1','0672e06ffd9faf4ad11231eda0ede00cc38bdaa4',3600,'2021-12-03 06:04:44','Inactiva'),(607,'douglas','2021-11-30','18:08:19','127.0.0.1','7303fdebb0b98131e4a6cbc9b0376ed8c2b5b32d',3600,'2021-12-03 06:38:20','Inactiva'),(608,'douglas','2021-11-30','18:52:31','127.0.0.1','35ad0e15b090f1f8f700c17ec0cbcca624e7d365',3600,'2021-12-03 06:52:31','Inactiva'),(609,'douglas','2021-11-30','18:57:16','127.0.0.1','49b00c43f0bed291214f57b6be5679dc1bcadba9',3600,'2021-12-03 07:12:16','Inactiva'),(610,'douglas','2021-11-30','19:26:19','127.0.0.1','1ab8ff2dbaff3784dcd573e925b449c595a1750d',3600,'2021-12-03 07:36:19','Inactiva'),(611,'douglas','2021-11-30','19:39:06','127.0.0.1','e0afe9cc953e0d0d99075f49323a535f30c9985b',3600,'2021-12-03 07:54:07','Inactiva'),(612,'douglas','2021-11-30','19:57:20','127.0.0.1','e239ff97b8aefe263bd43f7fcf06e88433f8fbda',3600,'2021-12-03 07:57:20','Inactiva'),(613,'douglas','2021-11-30','20:00:37','127.0.0.1','4a80a9b453b23cd3615c6db76e4e3aa98e4f8072',3600,'2021-12-03 08:10:38','Inactiva'),(614,'douglas','2021-11-30','20:05:17','192.168.0.42','5cb21b6f9506bc0080821578abfdf674d254c35c',3600,'2021-12-03 08:54:23','Inactiva'),(615,'douglas','2021-12-01','20:25:38','127.0.0.1','c601ad0e24151c59386627d671a90aa376bb1599',3600,'2021-12-04 08:25:38','Inactiva'),(616,'douglas','2021-12-06','13:57:08','127.0.0.1','e2329f2c023c2671b25128c4ded00f4eeeeafd9d',3600,'2021-12-10 03:37:57','Inactiva'),(617,'douglas','2021-12-07','15:38:07','127.0.0.1','24bcd8ffe131c77c3439efa05b35260c323c60d6',3600,'2021-12-10 04:03:09','Inactiva'),(618,'douglas','2021-12-07','16:04:48','127.0.0.1','6223106936b6020087548b25b480ff8701f388de',3600,'2021-12-10 04:19:48','Inactiva'),(619,'douglas','2021-12-07','16:22:31','127.0.0.1','0066ea5de6c19de4a56422cc68a73b30a9515adf',3600,'2021-12-10 04:22:31','Inactiva'),(620,'douglas','2021-12-07','16:23:24','127.0.0.1','ebe94f70154947b5d813a1203268b96a28761a1f',3600,'2021-12-10 04:23:24','Inactiva'),(621,'douglas','2021-12-07','16:27:09','127.0.0.1','0067b8ed2eccbe2535895ea71a7e95ba23c1b834',3600,'2021-12-10 04:27:09','Inactiva'),(622,'douglas','2021-12-07','16:27:26','127.0.0.1','95818a8803ec63f16f4494897269d527aa542f2e',3600,'2021-12-10 04:27:26','Inactiva'),(623,'douglas','2021-12-07','16:28:04','127.0.0.1','340446ff9b4a9b35a642aa86424ed83e2473220b',3600,'2021-12-10 04:28:04','Inactiva'),(624,'douglas','2021-12-07','16:31:14','127.0.0.1','3e711190891746430674a4d2e857ddffd63bd6ac',3600,'2021-12-10 05:01:14','Inactiva'),(625,'douglas','2021-12-09','14:41:42','127.0.0.1','5a37c56747857f4aa7bc481c69b9c72f55d34914',3600,'2021-12-12 02:41:42','Inactiva'),(626,'douglas','2021-12-09','14:44:49','127.0.0.1','63a13f552893f00aff142e14aaba92bd7131411a',3600,'2021-12-12 02:44:49','Inactiva'),(627,'douglas','2021-12-09','15:35:11','127.0.0.1','065e4a59c5af68ebfa2fd7e43582ba016f616106',3600,'2021-12-12 04:00:11','Inactiva'),(628,'douglas','2021-12-10','17:29:09','127.0.0.1','2275c48445eb8e250ca2cf82c25ab23742bbde15',3600,'2021-12-13 06:24:11','Inactiva'),(629,'douglas','2021-12-10','18:27:03','127.0.0.1','751ec07e2fa69ec798d22037d4145af7a02766d1',3600,'2021-12-13 06:42:04','Inactiva'),(630,'douglas','2021-12-13','16:43:46','127.0.0.1','6aa23abff42f64680a5d9c9ff5e8b34acb90af3e',3600,'2021-12-16 04:48:48','Inactiva'),(631,'douglas','2021-12-14','17:04:21','127.0.0.1','38ddcaad045f6d7e1ed644320d860fec313da8f8',3600,'2021-12-17 05:04:21','Inactiva'),(632,'douglas','2021-12-14','17:07:02','127.0.0.1','14deaf604fc024d25300a3ab1f4b9efa5433cfd6',3600,'2021-12-17 05:32:04','Inactiva'),(633,'douglas','2021-12-14','17:12:59','192.168.0.36','350ee3b2da480fdb95b7058e59b2b6a18e89dede',3600,'2021-12-17 05:27:59','Inactiva'),(634,'douglas','2021-12-15','15:23:18','192.168.0.42','0671784170f5ac18adca22e6c5a2d07b2501c4d3',3600,'2021-12-18 03:28:20','Inactiva'),(635,'douglas','2021-12-21','15:44:07','127.0.0.1','7fbcb7adfc3dc95e1eef51afa673f43757df21d0',3600,'2021-12-25 02:50:36','Inactiva'),(636,'douglas','2021-12-21','15:46:26','::1','32639f974b3feea66cc3b7df80ddc7de003f264b',3600,'2021-12-25 02:56:31','Inactiva'),(637,'douglas','2021-12-22','14:51:35','127.0.0.1','5f54e611d86aa55c73625cfa826ce871e2f21f8f',3600,'2021-12-25 02:51:35','Inactiva'),(638,'douglas','2021-12-22','14:53:53','127.0.0.1','dd5be9a4b83953ef50923b84f8c37d3ad0e9741f',3600,'2021-12-25 02:53:53','Inactiva'),(639,'douglas','2021-12-22','14:57:15','127.0.0.1','5014c84049ac649e832d595852386ce5456c0ce4',3600,'2021-12-26 05:17:19','Inactiva'),(640,'douglas','2021-12-28','14:25:47','127.0.0.1','fd2eee3ca9f44aab7053b8c83d95a47a64a4886c',3600,'2021-12-31 03:30:48','Inactiva'),(641,'douglas','2022-01-05','17:43:40','127.0.0.1','b1c8d9752a84bd7ff24a286adb6dacb1e6ec1305',3600,'2022-01-08 05:48:42','Inactiva'),(642,'douglas','2022-01-05','17:53:15','127.0.0.1','dc59c4d6fc0adfe9b177d7a5600b3552df08d9d6',3600,'2022-01-08 05:53:15','Inactiva'),(643,'douglas','2022-01-05','17:56:58','127.0.0.1','da681bfc703ee9bec60be97ca0e3501a19e372cd',3600,'2022-01-08 06:01:59','Inactiva'),(644,'douglas','2022-01-07','16:41:13','127.0.0.1','66071689beb62391a955632adc5d48e03d700949',3600,'2022-01-10 04:43:04','Inactiva'),(645,'douglas','2022-01-07','16:43:18','127.0.0.1','5c2656ce2dfa48ada62e9e2bd059d11839ae09ad',3600,'2022-01-10 04:48:18','Inactiva'),(646,'douglas','2022-01-07','16:48:25','127.0.0.1','d965910ba4f15f8ede35f836209667d3646b45f7',3600,'2022-01-10 04:48:25','Inactiva'),(647,'douglas','2022-01-07','16:49:01','127.0.0.1','8256515f01bc5c2c78a0093d5cfd97d72bee39dc',3600,'2022-01-10 04:54:01','Inactiva'),(648,'douglas','2022-01-07','16:54:51','127.0.0.1','121de59e928a38ba0257563e1f87cd01417202d6',3600,'2022-01-10 04:54:51','Inactiva'),(649,'douglas','2022-01-07','17:00:37','127.0.0.1','636719911ca1a70a3921233f8eb70d65375c409c',3600,'2022-01-10 05:00:37','Inactiva'),(650,'douglas','2022-01-07','17:00:58','127.0.0.1','4ec3c3c9b537ce8847c91f2115f504626a77cdc0',3600,'2022-01-10 06:11:00','Inactiva'),(651,'douglas','2022-01-10','14:51:42','127.0.0.1','d4a4f85ab1def05b21524cb76fb3f15e7f6a170e',3600,'2022-01-13 02:51:42','Inactiva'),(652,'douglas','2022-01-10','14:56:31','127.0.0.1','0da64ca11c30f7456790b141b6d8a935298825c1',3600,'2022-01-13 02:56:31','Inactiva'),(653,'douglas','2022-01-10','14:56:48','127.0.0.1','ff549e058ad3e037c39ed95dcae4818a48d18bc9',3600,'2022-01-13 02:56:48','Inactiva'),(654,'douglas','2022-01-10','15:01:36','127.0.0.1','9bf14b8a2e91002c045810db0fc9317e4f5210bb',3600,'2022-01-13 03:01:36','Inactiva'),(655,'douglas','2022-01-10','15:07:02','127.0.0.1','9a4e3a574591320b8ba48c968ba0609c1ee1a445',3600,'2022-01-13 03:07:02','Inactiva'),(656,'douglas','2022-01-10','15:07:12','127.0.0.1','00fc7e71a71afa7868f2ffc2c939528faa71723a',3600,'2022-01-13 03:07:12','Inactiva'),(657,'douglas','2022-01-10','15:12:06','127.0.0.1','b52129d70b46aa3f02daa97daae9d96650fe299d',3600,'2022-01-13 03:12:06','Inactiva'),(658,'douglas','2022-01-10','15:14:28','127.0.0.1','c769fe8890d4455cd3611f54a05d61f28cb60da3',3600,'2022-01-13 03:29:28','Inactiva'),(659,'douglas','2022-01-10','15:30:36','127.0.0.1','61522d6753f7afdb9e33ed2d0a3ad629a3d57a04',3600,'2022-01-13 03:30:36','Inactiva'),(660,'douglas','2022-01-10','15:35:38','127.0.0.1','916277e912565993683f92c1dfde3cea4f73948b',3600,'2022-01-13 03:35:38','Inactiva'),(661,'douglas','2022-01-10','15:37:17','127.0.0.1','b763be5f457af3acd5be7f2c81b35f90f61feae3',3600,'2022-01-13 04:12:18','Inactiva'),(662,'douglas','2022-01-10','16:42:57','127.0.0.1','347fb1ad1230f081663f7b13843a6d0dcecb8562',3600,'2022-01-13 04:42:57','Inactiva'),(663,'douglas','2022-01-10','16:45:58','127.0.0.1','4b3295c8a05105852e4155e9a64d40154fcaa11e',3600,'2022-01-13 04:55:59','Inactiva'),(664,'douglas','2022-01-11','14:53:41','127.0.0.1','4a52e91a338a10b29a61cab5d49d53ab64ad6e59',3600,'2022-01-14 03:13:42','Inactiva'),(665,'douglas','2022-01-11','15:35:03','127.0.0.1','56d6935f2d709f687d5eb5d7ced71d9ffb99f85a',3600,'2022-01-14 03:40:04','Inactiva'),(666,'douglas','2022-01-11','15:40:10','127.0.0.1','ac57d8e62e13603d41656bfb5d077d94bc236302',3600,'2022-01-14 03:40:10','Inactiva'),(667,'douglas','2022-01-11','15:44:23','127.0.0.1','c813fa8ed4854af8008e15d40d3458851edb326e',3600,'2022-01-14 03:44:23','Inactiva'),(668,'douglas','2022-01-11','15:46:12','127.0.0.1','cfe0bf163afd9da5ff04165ca3789a720214d4c4',3600,'2022-01-14 03:46:12','Inactiva'),(669,'douglas','2022-01-11','15:46:17','127.0.0.1','fa2925825198a8e7c0abb03f2bff306fd429a14c',3600,'2022-01-14 04:06:18','Inactiva'),(670,'douglas','2022-01-11','15:54:02','::1','ff71ad8e52b862b291a47c67a89bd10bdf464581',3600,'2022-01-14 03:59:03','Inactiva'),(671,'douglas','2022-01-11','16:06:41','127.0.0.1','bec753c4ad8c9cefefb8f8eb8f5c4a22ae2b51da',3600,'2022-01-14 04:11:53','Inactiva'),(672,'douglas','2022-01-11','16:13:15','127.0.0.1','89e7319f11a231b4d23b4f781df33b8de9c7fa56',3600,'2022-01-14 04:13:15','Inactiva'),(673,'douglas','2022-01-11','16:14:01','127.0.0.1','f95598b3f28644cad15446a0b90ec1746409024c',3600,'2022-01-14 04:19:02','Inactiva'),(674,'douglas','2022-01-11','16:27:21','127.0.0.1','ddb5f21e5c0fe8cb98daf3b517fd8684cc34b702',3600,'2022-01-14 04:27:21','Inactiva'),(675,'douglas','2022-01-12','14:28:11','127.0.0.1','2e35a4c72f6ca54509d326403f43e491dcbf390b',3600,'2022-01-15 02:38:45','Inactiva'),(676,'douglas','2022-01-12','14:48:59','127.0.0.1','e36f534cfc695b8ae719bde7263e8f4c74520208',3600,'2022-01-15 02:48:59','Inactiva'),(677,'douglas','2022-01-12','14:58:13','127.0.0.1','f88264c6d1a97efa472fa4309a366d4420975d81',3600,'2022-01-15 02:58:13','Inactiva'),(678,'douglas','2022-01-12','15:01:12','127.0.0.1','7953aff5bdf194b1c23f8b547ce5587370a703c8',3600,'2022-01-15 03:01:12','Inactiva'),(679,'douglas','2022-01-12','15:01:54','127.0.0.1','6233751e5ac9e61fc6139b23e87c0a05f6699ef5',3600,'2022-01-15 03:01:54','Inactiva'),(680,'douglas','2022-01-12','15:09:29','127.0.0.1','5d3b48a137e425e1676d37f5267f40ed854c8d00',3600,'2022-01-15 03:09:29','Inactiva'),(681,'douglas','2022-01-12','15:09:54','127.0.0.1','508da8422e0c34cc5f91d80fad14c0f6c4efc306',3600,'2022-01-15 03:39:55','Inactiva'),(682,'douglas','2022-01-12','15:43:09','127.0.0.1','eb597260879be797d0f3e11dceef094010376d82',3600,'2022-01-15 03:43:09','Inactiva'),(683,'douglas','2022-01-12','15:44:25','127.0.0.1','00bc8b93a0e3e3bcf89808c75d3087662e0b0feb',3600,'2022-01-15 03:44:25','Inactiva'),(684,'douglas','2022-01-12','15:53:57','127.0.0.1','653672cf9f6f875080360d4726d147118ac300b8',3600,'2022-01-15 04:03:57','Inactiva'),(685,'douglas','2022-01-13','16:32:14','127.0.0.1','929afa438e8e74ba7a668a966c9dac89f5d26d9f',3600,'2022-01-16 04:37:14','Inactiva'),(686,'douglas','2022-01-13','16:57:05','127.0.0.1','38584834f562b75a73c1eb3fead5b5fa19c29208',3600,'2022-01-16 04:57:05','Inactiva'),(687,'douglas','2022-01-13','16:57:32','127.0.0.1','5b9e5ec9de36745a79d138d8a908cf4690208dca',3600,'2022-01-16 05:02:32','Inactiva'),(688,'douglas','2022-01-13','17:03:52','127.0.0.1','7b8f2e83e91bccd64d56d9e0fb598a830aac604f',3600,'2022-01-16 05:38:53','Inactiva'),(689,'douglas','2022-01-14','14:28:10','127.0.0.1','7eabd3dbee32c6ecc55a4ab19fee110fefa2e2af',3600,'2022-01-17 03:08:12','Inactiva'),(690,'douglas','2022-01-14','14:33:58','192.168.0.36','90c8fe39e5abbfac3f90e8cef45ffe67c423d624',3600,'2022-01-17 02:43:59','Inactiva'),(691,'douglas','2022-01-14','17:04:20','127.0.0.1','5e68eac96aebaedb28b70f003393967216962aa3',3600,'2022-01-17 05:44:22','Inactiva'),(692,'douglas','2022-01-20','17:08:06','127.0.0.1','a248b2b59767d6b4d283562ddc44f437de225fca',3600,'2022-01-23 05:53:07','Inactiva'),(693,'douglas','2022-01-21','16:08:21','127.0.0.1','d90ac1c0f4569efc9ce9859ed9b99f3fddb4c23e',3600,'2022-01-24 06:13:34','Inactiva'),(694,'douglas','2022-01-25','16:33:01','127.0.0.1','846f0a10f57c9e0c49a2d658f970e82ee532a822',3600,'2022-01-28 04:38:02','Inactiva'),(695,'douglas','2022-01-25','16:45:39','127.0.0.1','dacc74baaf56d80effb03877ffa64d2fd4cfbf1a',3600,'2022-01-28 04:45:39','Inactiva'),(696,'douglas','2022-01-25','16:45:44','127.0.0.1','859b3d4777e6a9bee125af10771c90430eb38b00',3600,'2022-01-28 04:45:44','Inactiva'),(697,'douglas','2022-01-25','16:50:23','127.0.0.1','70b4e40b723611a1e4a69ddef233fdceac3347ab',3600,'2022-01-28 05:00:23','Inactiva'),(698,'douglas','2022-01-25','17:01:43','127.0.0.1','df1375eb0ea334fb2e76d6da994081ae88c79037',3600,'2022-01-28 05:06:44','Inactiva'),(699,'douglas','2022-01-25','17:08:19','127.0.0.1','ddbf440d132c10b104cac11a2a7cda0b2b620fcb',3600,'2022-01-28 06:03:23','Inactiva'),(700,'douglas','2022-01-26','16:45:39','127.0.0.1','197d0f8672ebbd6f6c68c56e8950197db000ad23',3600,'2022-01-29 05:25:43','Inactiva'),(701,'douglas','2022-01-26','17:29:10','127.0.0.1','0930c0c08838541af6f6d2ceec212c0edb505a3c',3600,'2022-01-29 06:04:11','Inactiva'),(702,'douglas','2022-01-27','16:29:43','127.0.0.1','1af82db25322e182c42f6e99413ae41d1064e90c',3600,'2022-01-30 04:39:43','Inactiva'),(703,'douglas','2022-01-27','16:42:49','127.0.0.1','8a0919e4c903f937fbefeedf7dd1a8787ee1968d',3600,'2022-01-30 04:52:50','Inactiva'),(704,'douglas','2022-01-27','16:57:28','127.0.0.1','049742383158f8ec87051f08b9449a0e38e0957c',3600,'2022-01-30 04:57:28','Inactiva'),(705,'douglas','2022-01-27','17:02:18','127.0.0.1','142b8a5778ddcc17f6df6b3dcf11ef85332b3519',3600,'2022-01-30 05:07:19','Inactiva'),(706,'douglas','2022-01-27','17:14:49','127.0.0.1','773bc307c65cd62508186f5e9b4f75ddf6490bbc',3600,'2022-01-30 05:14:49','Inactiva'),(707,'douglas','2022-01-27','17:16:57','127.0.0.1','4b8b3f59061d6534d89eb4a2ea44c5d4b6a699df',3600,'2022-01-30 05:16:57','Inactiva'),(708,'douglas','2022-01-27','17:19:29','127.0.0.1','f98bc7986be10281e38d0d7bee77e7d178eb5985',3600,'2022-01-30 05:19:29','Inactiva'),(709,'douglas','2022-01-27','17:21:02','127.0.0.1','6022aac5b85e6cee09075f398232816c707cfdda',3600,'2022-01-30 05:26:03','Inactiva'),(710,'douglas','2022-01-27','17:26:09','127.0.0.1','e82595d9320f52fb5ecbba0fb2e576ead58dd9bd',3600,'2022-01-30 05:31:10','Inactiva'),(711,'douglas','2022-01-29','10:40:56','127.0.0.1','05bb348472f7e70da47a60ed0adb8ba6bd1ba81d',3600,'2022-01-31 22:45:59','Inactiva'),(712,'douglas','2022-01-31','15:43:02','127.0.0.1','d504887fb1ee1a320f1578e4809e0fffff63d7d1',3600,'2022-02-03 03:43:02','Inactiva'),(713,'douglas','2022-01-31','15:45:25','127.0.0.1','f310aa79600e01b0b5c9b9c17afa148a465d8f17',3600,'2022-02-03 04:00:25','Inactiva'),(714,'douglas','2022-02-07','16:19:57','127.0.0.1','1b881e6224f41ca23d44e5557460308100c95a03',3600,'2022-02-10 04:19:57','Inactiva'),(715,'douglas','2022-02-09','16:48:30','127.0.0.1','d6b885c3437f959e51161603095e61f3ac8296c4',3600,'2022-02-12 05:13:32','Inactiva'),(716,'douglas','2022-02-09','17:16:01','127.0.0.1','cd12d223144a5349260f3786976f5f639906e25b',3600,'2022-02-12 06:41:08','Inactiva'),(717,'douglas','2022-02-10','19:25:29','127.0.0.1','3bd7e3917e68b6b17fe3779c9f80348169dcf658',3600,'2022-02-13 07:55:35','Inactiva'),(718,'douglas','2022-02-10','19:59:18','127.0.0.1','68a0c030bef2fdecfbc089cb6012e3bff4554818',3600,'2022-02-13 07:59:18','Inactiva'),(719,'douglas','2022-02-10','20:01:56','127.0.0.1','ab11fc80edc338e70ac7aa0acc8dfd9e4f6c3901',3600,'2022-02-13 08:01:56','Inactiva'),(720,'douglas','2022-02-21','20:45:32','127.0.0.1','78f1cd4142e3819ea9c4c7ac4f12b5924f379a4d',3600,'2022-02-24 08:45:32','Inactiva'),(721,'douglas','2022-02-21','20:51:31','127.0.0.1','57a6e0464993921a375593a00f5759c5d92331b6',3600,'2022-02-24 08:56:32','Inactiva'),(722,'douglas','2022-02-21','22:57:12','127.0.0.1','1de6aab4913ccba743c1488f6130b6286a035054',3600,'2022-02-24 10:57:12','Inactiva'),(723,'douglas','2022-02-21','22:58:52','127.0.0.1','f99b6a54fe00705a968b74e23a869e659fd79774',3600,'2022-02-24 11:33:54','Inactiva'),(724,'douglas','2022-02-21','23:34:11','127.0.0.1','29f6d281d338dfa560722107b7d4fc96bf43c67b',3600,'2022-02-24 11:34:11','Inactiva'),(725,'douglas','2022-02-21','23:34:33','127.0.0.1','37cda53d2d0d5f704e4e1c6c8510a270bb2205ae',3600,'2022-02-24 11:34:33','Inactiva'),(726,'douglas','2022-02-21','23:35:14','127.0.0.1','254966f3023e7b6a3ea9c5ac7253f882ef276cc4',3600,'2022-02-24 11:47:15','Inactiva'),(727,'douglas','2022-02-21','23:47:20','127.0.0.1','a4a938bc94a283b049d60c39f3c352ab5214320d',3600,'2022-02-24 11:52:21','Inactiva'),(728,'douglas','2022-02-21','23:59:09','127.0.0.1','2ff516aa0edab0fdb0b972493fe5b7eaa377c40c',3600,'2022-02-25 08:53:08','Inactiva'),(729,'douglas','2022-02-23','15:25:49','127.0.0.1','3dab48c5d8ddce5b1cde2d4c3224ef714df322f8',3600,'2022-02-26 03:25:49','Inactiva'),(730,'douglas','2022-02-23','15:26:06','127.0.0.1','4cdbf8d26b2d37a0ffd95afbcc4af69841d42f44',3600,'2022-02-26 04:10:50','Inactiva'),(731,'douglas','2022-02-23','16:14:45','127.0.0.1','d2f3bd2aaade008b571eaf4982088bdf73d156ce',3600,'2022-02-26 04:14:45','Inactiva'),(732,'douglas','2022-02-23','16:18:50','127.0.0.1','b4709b76187fcdda1ae06106ec2ceb699467c6fd',3600,'2022-02-26 05:36:14','Inactiva'),(733,'douglas','2022-02-23','17:38:05','127.0.0.1','5f55c81123c56d599b83e7b8b3d08dfec57ea0aa',3600,'2022-02-26 05:38:05','Inactiva'),(734,'douglas','2022-02-23','17:41:25','127.0.0.1','62bf1e2ae98eb53e3fb57e45b4f46e85f19f3230',3600,'2022-02-26 05:41:25','Inactiva'),(735,'douglas','2022-02-23','17:41:30','127.0.0.1','14990d669b4c741338a85178dd20890116b505fe',3600,'2022-02-26 05:46:31','Inactiva'),(736,'douglas','2022-02-23','17:49:12','127.0.0.1','53221470c693d8c1ef7801da0da2299f7e6c8b88',3600,'2022-02-26 05:49:12','Inactiva'),(737,'douglas','2022-02-23','17:52:14','127.0.0.1','4592623624497a98eb9ab4dc45711fff813b1af1',3600,'2022-02-26 06:04:02','Inactiva'),(738,'douglas','2022-02-24','14:56:33','127.0.0.1','5e92a93ed787c747d787dde90c961ff300f757ca',3600,'2022-02-27 02:56:33','Inactiva'),(739,'douglas','2022-02-24','14:58:08','127.0.0.1','25597161bd25f587060bb0f7d3f319dafc1f6d3b',3600,'2022-02-27 03:21:36','Inactiva'),(740,'douglas','2022-02-24','15:24:55','::1','bec089def72bcae31a2ed0304cfc7d61a0438f94',3600,'2022-02-27 05:19:55','Inactiva'),(741,'douglas','2022-02-24','15:25:31','127.0.0.1','f77891b2b4e5336606f66dfb0602febb7be592bd',3600,'2022-02-27 05:20:42','Inactiva'),(742,'douglas','2022-03-02','14:24:02','127.0.0.1','948823bec827f2ffd739428fbebb880660d79906',3600,'2022-03-05 02:24:02','Inactiva'),(743,'douglas','2022-03-02','14:25:17','127.0.0.1','fc8f30d3a41960fb7947a62ea53e77070df5b4cb',3600,'2022-03-05 02:30:17','Inactiva'),(744,'douglas','2022-03-02','14:31:51','127.0.0.1','5de54517d06623e8e124c5de3e283acfc98d603f',3600,'2022-03-05 03:16:54','Inactiva'),(745,'douglas','2022-03-02','15:19:15','127.0.0.1','05a4bd40af0d4080ea24585f71c175d5e7e3cc84',3600,'2022-03-06 04:24:21','Inactiva'),(746,'douglas','2022-03-03','16:40:14','127.0.0.1','0a594a6d11072eecb22b02262629157f0cc845ec',3600,'2022-03-06 04:40:14','Inactiva'),(747,'douglas','2022-03-03','16:41:43','127.0.0.1','f8000a9fdb3c53cdc0138dce7d18ff303b097753',3600,'2022-03-06 04:49:24','Inactiva'),(748,'douglas','2022-03-03','16:50:16','127.0.0.1','36690dc15aaf403cb0c7e579190ebd70dd1737a4',3600,'2022-03-06 04:50:16','Inactiva'),(749,'douglas','2022-03-03','16:52:53','127.0.0.1','4deb230f93394d379a167bea01ff1c375e443847',3600,'2022-03-06 04:59:25','Inactiva'),(750,'douglas','2022-03-03','16:59:59','127.0.0.1','8c86069913e31fa7bbce4f931e5a655856ac4075',3600,'2022-03-06 05:09:59','Inactiva'),(751,'douglas','2022-03-03','17:22:18','127.0.0.1','d8376b65c796f59cd2f60775dd6330de8a8f1da2',3600,'2022-03-06 05:27:18','Inactiva'),(752,'douglas','2022-03-03','17:27:21','127.0.0.1','31958c0129d417ac6ccafbb054c93e0509e70f31',3600,'2022-03-06 06:04:31','Inactiva'),(753,'douglas','2022-03-03','18:05:16','127.0.0.1','569a2a577bf84f7c35236b85fdd57c91e8a721d2',3600,'2022-03-06 06:27:26','Inactiva'),(754,'douglas','2022-03-03','18:28:18','127.0.0.1','72e36b0227471e1f61bf3f1310a0bef20c2bc552',3600,'2022-03-06 06:33:19','Inactiva'),(755,'douglas','2022-03-04','14:51:15','127.0.0.1','983b1e2b3b77409032f97970691a82a7db349abf',3600,'2022-03-07 02:51:15','Inactiva'),(756,'douglas','2022-03-04','14:51:32','127.0.0.1','3b139e86026fd23021ec4217cfb8714b0323cb3c',3600,'2022-03-07 02:56:32','Inactiva'),(757,'douglas','2022-03-04','14:57:17','127.0.0.1','3ff6c89b4bd4b0f0ecc9e6da7b856c843cf848c9',3600,'2022-03-07 03:02:18','Inactiva'),(758,'douglas','2022-03-04','15:05:13','127.0.0.1','164519ce12e333ab98743cdddb43cf029d1b3566',3600,'2022-03-07 03:10:13','Inactiva'),(759,'douglas','2022-03-04','15:13:52','127.0.0.1','cb074bac0ec5cfe4088d958768c2fbd18063d45d',3600,'2022-03-07 03:53:53','Inactiva'),(760,'douglas','2022-03-07','14:44:11','127.0.0.1','94a036d322f39cd9632c6b04ef0904efe3651e0f',3600,'2022-03-10 02:44:11','Inactiva'),(761,'douglas','2022-03-07','14:46:27','127.0.0.1','ba8d2e1a09387fcf341188016f1e9ca85ad47f25',3600,'2022-03-10 02:46:27','Inactiva'),(762,'douglas','2022-03-07','14:48:29','127.0.0.1','be70afc799494941b20bc900bfc4694f9486fda6',3600,'2022-03-10 02:58:29','Inactiva'),(763,'douglas','2022-03-07','15:02:02','127.0.0.1','53bd8d2ddad99bc2de7a15a8981e05d9cb198531',3600,'2022-03-10 03:27:02','Inactiva'),(764,'douglas','2022-03-07','15:30:15','127.0.0.1','4339ae311483c5f71660f3effe39d9bf8e6c3a56',3600,'2022-03-10 03:45:15','Inactiva'),(765,'douglas','2022-03-07','15:46:25','127.0.0.1','c28da343fc6cde1a45beae5508a16ae39a3e3cb9',3600,'2022-03-10 03:55:15','Inactiva'),(766,'douglas','2022-03-07','15:57:32','127.0.0.1','38a5f5217d845864984a3a2c76df7fb0f0d62299',3600,'2022-03-10 04:02:34','Inactiva'),(767,'douglas','2022-03-11','18:33:46','127.0.0.1','4ceec58a22476eb88b3d74bd53d84cfbac311150',3600,'2022-03-14 06:43:47','Inactiva'),(768,'douglas','2022-03-11','18:48:31','127.0.0.1','36d0d7011900e4b5e2c0b60405ddfcd44a90cffd',3600,'2022-03-14 06:48:31','Inactiva'),(769,'douglas','2022-03-11','18:52:45','127.0.0.1','2b8b29ae1a78ee3737b1624546a951adaacd797e',3600,'2022-03-14 06:52:45','Inactiva'),(770,'douglas','2022-03-11','18:53:30','127.0.0.1','8b850d8c4760da5b1a80183fea8f31dab3c1b2c6',3600,'2022-03-14 07:28:30','Inactiva'),(771,'douglas','2022-03-16','14:03:58','127.0.0.1','0b055cc8a7497c0589466ddb1d9376718f4ab667',3600,'2022-03-19 02:03:58','Activa');

/*Table structure for table `stock` */

DROP TABLE IF EXISTS `stock`;

CREATE TABLE `stock` (
  `suc` varchar(10) NOT NULL,
  `codigo` varchar(30) NOT NULL,
  `lote` varchar(30) NOT NULL,
  `tipo_ent` varchar(4) NOT NULL,
  `nro_identif` int(11) NOT NULL,
  `linea` int(11) NOT NULL,
  `cant_ent` decimal(16,2) DEFAULT NULL,
  `kg_ent` decimal(16,2) DEFAULT NULL,
  `cantidad` decimal(16,2) NOT NULL,
  `ubicacion` varchar(100) DEFAULT NULL,
  `estado_venta` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`suc`,`codigo`,`lote`,`tipo_ent`,`nro_identif`,`linea`),
  KEY `Ref18201` (`suc`),
  KEY `Ref119312` (`codigo`,`suc`,`lote`),
  CONSTRAINT `Refarticulos312` FOREIGN KEY (`codigo`) REFERENCES `articulos` (`codigo`),
  CONSTRAINT `Refsucursales201` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `stock` */

/*Table structure for table `sucursales` */

DROP TABLE IF EXISTS `sucursales`;

CREATE TABLE `sucursales` (
  `suc` varchar(10) NOT NULL,
  `nombre` varchar(30) DEFAULT NULL,
  `direccion` varchar(200) DEFAULT NULL,
  `tel` varchar(30) DEFAULT NULL,
  `mail` varchar(30) DEFAULT NULL,
  `web` varchar(100) DEFAULT NULL,
  `ciudad` varchar(30) DEFAULT NULL,
  `departamento` varchar(30) DEFAULT NULL,
  `pais` varchar(30) DEFAULT NULL,
  `tipo` varchar(30) DEFAULT NULL,
  `estab_cont` varchar(6) DEFAULT NULL,
  `estado` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`suc`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `sucursales` */

insert  into `sucursales`(`suc`,`nombre`,`direccion`,`tel`,`mail`,`web`,`ciudad`,`departamento`,`pais`,`tipo`,`estab_cont`,`estado`) values ('01','Santa Maria','Completar','071-completar',NULL,NULL,'Encarnacion',NULL,'Paraguay','Sucursal','007','Activo');

/*Table structure for table `sueldos` */

DROP TABLE IF EXISTS `sueldos`;

CREATE TABLE `sueldos` (
  `nro_liquid` int(11) NOT NULL AUTO_INCREMENT,
  `usuario` varchar(30) NOT NULL,
  `funcionario` varchar(30) NOT NULL,
  `suc` varchar(10) NOT NULL,
  `fecha_ult_pago` date DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `sueldo` decimal(16,2) DEFAULT NULL,
  `anio` int(11) DEFAULT NULL,
  `desde` date DEFAULT NULL,
  `hasta` date DEFAULT NULL,
  `mes` varchar(2) DEFAULT NULL,
  `dias_trab` int(11) DEFAULT NULL,
  `comision` decimal(16,2) DEFAULT NULL,
  `aguinaldo` decimal(16,2) DEFAULT NULL,
  `ips` decimal(16,2) DEFAULT NULL,
  `preaviso` decimal(16,2) DEFAULT NULL,
  `permisos` decimal(16,2) DEFAULT NULL,
  `linea_credito` decimal(16,2) DEFAULT NULL,
  `vacaciones` decimal(16,2) DEFAULT NULL,
  `uniforme` decimal(16,2) DEFAULT NULL,
  `horas_extras` decimal(16,2) DEFAULT NULL,
  `ausencia` decimal(16,2) DEFAULT NULL,
  `reposo` decimal(16,2) DEFAULT NULL,
  `sanciones` decimal(16,2) DEFAULT NULL,
  `suspension` decimal(16,2) DEFAULT NULL,
  `planes_telef` decimal(16,2) DEFAULT NULL,
  `feriados` decimal(16,2) DEFAULT NULL,
  `aportes` decimal(16,2) DEFAULT NULL,
  `asociaciones` decimal(16,2) DEFAULT NULL,
  `otros` decimal(16,2) DEFAULT NULL,
  `total` decimal(16,2) DEFAULT NULL,
  `estado` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`nro_liquid`),
  KEY `Ref6262` (`usuario`),
  KEY `Ref6263` (`funcionario`),
  KEY `Ref18264` (`suc`),
  CONSTRAINT `Refsucursales264` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`),
  CONSTRAINT `Refusuarios262` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`),
  CONSTRAINT `Refusuarios263` FOREIGN KEY (`funcionario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `sueldos` */

/*Table structure for table `tarjetas` */

DROP TABLE IF EXISTS `tarjetas`;

CREATE TABLE `tarjetas` (
  `cod_tarjeta` varchar(30) NOT NULL,
  `cta_cont` varchar(30) NOT NULL,
  `nombre` varchar(60) DEFAULT NULL,
  `tipo` varchar(30) DEFAULT NULL,
  `estado` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`cod_tarjeta`),
  KEY `Ref138314` (`cta_cont`),
  CONSTRAINT `Refplan_cuentas314` FOREIGN KEY (`cta_cont`) REFERENCES `plan_cuentas` (`cuenta`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `tarjetas` */

insert  into `tarjetas`(`cod_tarjeta`,`cta_cont`,`nombre`,`tipo`,`estado`) values ('1','11232','AMERICAN EXPRESS','Tarjeta Credito','Activa'),('10','11232','ASOC. DE EDU. DE ENCARNACION','Asociacion','Activa'),('11','11232','ASOC. FUNC. DE LA UNI','Asociacion','Activa'),('12','11232','ASOC. FUNC. GOB.  ITAPUA','Asociacion','Activa'),('13','11232','ASOC. JUSTICIA ELECTORAL','Asociacion','Activa'),('14','11232','BANCARD','Tarjeta Credito','Activa'),('15','11232','CABAL','Tarjeta Credito','Activa'),('16','11232','CREDICARD','Tarjeta Credito','Activa'),('17','11232','RETENCION','Retencion','Activa'),('18','11232','DINELCO','Tarjeta Debito','Activa'),('19','11232','PROGRESAR','Tarjeta Credito','Activa'),('2','11232','CREDIFIELCO','Tarjeta Credito','Activa'),('20','11232','ONECOIN','Criptomoneda','Activa'),('3','11232','DINERS CLUB','Tarjeta Credito','Activa'),('4','11232','INFONET','Tarjeta Debito','Activa'),('5','11232','MASTERCARD','Tarjeta Credito','Activa'),('6','11232','PANAL','Tarjeta Credito','Activa'),('7','11232','TIGO CASH','Tarjeta Debito','Activa'),('8','11232','VISA','Tarjeta Credito','Activa'),('9','11232','ASOC. BANCO REGIONAL','Asociacion','Activa');

/*Table structure for table `temporadas` */

DROP TABLE IF EXISTS `temporadas`;

CREATE TABLE `temporadas` (
  `suc` varchar(10) NOT NULL,
  `estante` varchar(30) NOT NULL,
  `temporada` int(11) NOT NULL,
  `usuario` varchar(30) DEFAULT NULL,
  `desde` date DEFAULT NULL,
  `hasta` date DEFAULT NULL,
  `upt_date` date DEFAULT NULL,
  PRIMARY KEY (`suc`,`estante`,`temporada`),
  KEY `Ref6190` (`usuario`),
  KEY `Ref18191` (`suc`),
  KEY `Ref129299` (`estante`,`suc`),
  CONSTRAINT `Refsucursales191` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`),
  CONSTRAINT `Refusuarios190` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `temporadas` */

/*Table structure for table `tipo_vendedor` */

DROP TABLE IF EXISTS `tipo_vendedor`;

CREATE TABLE `tipo_vendedor` (
  `id_tipo` varchar(30) NOT NULL,
  `descrip` varchar(30) DEFAULT NULL,
  `nombre_grupo` varchar(30) DEFAULT NULL,
  `meta_base_coef` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_tipo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `tipo_vendedor` */

insert  into `tipo_vendedor`(`id_tipo`,`descrip`,`nombre_grupo`,`meta_base_coef`) values ('GV','GERENTE VENTAS','Gerente',0),('MJ-1','MINORISTA JUNIOR 1','Minorista',65800000),('MJ-2','MINORISTA JUNIOR 2','Minorista',65800000),('MS-1','MINORISTA SENIOR 1','Minorista',65800000),('MS-2','MINORISTA SENIOR 2','Minorista',65800000),('MY-3','MAYORISTA CAT 3','Mayorista-3',100000000),('MY-4-7','MAYORISTA CAT 4-7','Mayorista 4-7',250000000);

/*Table structure for table `tipos_gastos` */

DROP TABLE IF EXISTS `tipos_gastos`;

CREATE TABLE `tipos_gastos` (
  `cod_gasto` int(11) NOT NULL,
  `descrip` varchar(60) DEFAULT NULL,
  `cuenta_cont` varchar(30) NOT NULL,
  PRIMARY KEY (`cod_gasto`),
  KEY `Ref138322` (`cuenta_cont`),
  CONSTRAINT `Refplan_cuentas322` FOREIGN KEY (`cuenta_cont`) REFERENCES `plan_cuentas` (`cuenta`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `tipos_gastos` */

insert  into `tipos_gastos`(`cod_gasto`,`descrip`,`cuenta_cont`) values (1,'CARGOS PORTUARIOS EN ORIGEN','514113'),(2,'COMISION FORWARDER','514113'),(3,'COMISION DE REMESAS','514113'),(4,'DESPACHO DE IMPORTACION','514113'),(5,'FLETE INTERNACIONAL TERRESTRE','514113'),(6,'FLETE FLUVIAL INTERNACIONAL','514113'),(7,'FLETE NACIONAL TERRESTRE','514113'),(8,'GASTOS DE CONSOLIDACION EN ORIGEN','514113'),(9,'MANIPULEO DE CONTENEDOR','514113'),(10,'MULTAS EN ADUANAS','514113'),(11,'SEGURO DE RIESGOS','514113');

/*Table structure for table `tipos_moviles` */

DROP TABLE IF EXISTS `tipos_moviles`;

CREATE TABLE `tipos_moviles` (
  `tipo_movil` varchar(60) NOT NULL,
  `descrip` varchar(60) DEFAULT NULL,
  `hits` int(11) DEFAULT NULL,
  PRIMARY KEY (`tipo_movil`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `tipos_moviles` */

insert  into `tipos_moviles`(`tipo_movil`,`descrip`,`hits`) values ('BigTruck','Big Truck',20),('BUS','BUS',78),('Cabriolet','Cabriolet',80),('CamperVan','CamperVan',70),('Coupe','Coupe',82),('HatchBack','HatchBack',98),('Limousine','Limousine',30),('Micro','Micro',30),('MiniTruck','Mini Truck',60),('MiniVan','Mini Van',97),('MuscleCar','Muscle Car',74),('Pickup','Pickup',96),('Roadster','Roadster',83),('Sedan','Sedan',100),('SportCar','SportCar',84),('StationWagon','Station Wagon',95),('SuperCar','Super Car',85),('SUV','SUV',99),('Truck','Truck',30),('VAN','VAN',94);

/*Table structure for table `turnos` */

DROP TABLE IF EXISTS `turnos`;

CREATE TABLE `turnos` (
  `id_turno` int(11) NOT NULL,
  `fecha_hora` datetime DEFAULT NULL,
  `turno` int(11) DEFAULT NULL,
  `diff_ant` int(11) DEFAULT NULL,
  `hora_llamada` datetime DEFAULT NULL,
  `sync` tinyint(4) DEFAULT NULL,
  `suc` varchar(10) NOT NULL,
  PRIMARY KEY (`id_turno`),
  KEY `Ref18284` (`suc`),
  CONSTRAINT `Refsucursales284` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `turnos` */

/*Table structure for table `ubicaciones` */

DROP TABLE IF EXISTS `ubicaciones`;

CREATE TABLE `ubicaciones` (
  `ubic_nombre` varchar(30) NOT NULL,
  `suc` varchar(10) NOT NULL,
  `tipo` varchar(30) NOT NULL,
  `filas` int(11) NOT NULL,
  `cols` int(11) NOT NULL,
  `sentido` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`ubic_nombre`,`suc`),
  KEY `Ref18212` (`suc`),
  CONSTRAINT `Refsucursales212` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `ubicaciones` */

/*Table structure for table `unidades_medida` */

DROP TABLE IF EXISTS `unidades_medida`;

CREATE TABLE `unidades_medida` (
  `um_cod` varchar(10) NOT NULL,
  `um_descri` varchar(30) DEFAULT NULL,
  `um_ref` varchar(4) DEFAULT NULL,
  `um_mult` decimal(16,3) DEFAULT NULL,
  `um_prior` int(2) DEFAULT NULL,
  PRIMARY KEY (`um_cod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `unidades_medida` */

insert  into `unidades_medida`(`um_cod`,`um_descri`,`um_ref`,`um_mult`,`um_prior`) values ('CJ-10','Caja de 10','Unid',10.000,6),('CJ-5','Caja de 5','Unid',5.000,7),('Cm','Centimetros','Mts',0.010,5),('Gr','Gramos','Kg',0.001,4),('Kg','Kilogramos',NULL,1.000,2),('Mts','Metros',NULL,1.000,3),('Unid','Unidades',NULL,1.000,1);

/*Table structure for table `usos` */

DROP TABLE IF EXISTS `usos`;

CREATE TABLE `usos` (
  `cod_uso` int(11) NOT NULL AUTO_INCREMENT,
  `descrip` varchar(60) DEFAULT NULL,
  PRIMARY KEY (`cod_uso`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `usos` */

/*Table structure for table `usuarios` */

DROP TABLE IF EXISTS `usuarios`;

CREATE TABLE `usuarios` (
  `usuario` varchar(30) NOT NULL,
  `passw` varchar(80) NOT NULL,
  `hash` varchar(30) DEFAULT NULL,
  `doc` varchar(30) DEFAULT NULL,
  `nombre` varchar(30) DEFAULT NULL,
  `apellido` varchar(30) DEFAULT NULL,
  `tel` varchar(30) DEFAULT NULL,
  `email` varchar(60) DEFAULT NULL,
  `pais` varchar(60) DEFAULT NULL,
  `dir` varchar(120) DEFAULT NULL,
  `fecha_nac` date DEFAULT NULL,
  `fecha_cont` date DEFAULT NULL,
  `limite_sesion` int(11) DEFAULT NULL,
  `imagen` varchar(100) DEFAULT NULL,
  `suc` varchar(10) DEFAULT NULL,
  `suc_princ` varchar(10) DEFAULT NULL,
  `profesion` varchar(60) DEFAULT NULL,
  `cargo` varchar(60) DEFAULT NULL,
  `hora_entrada` varchar(6) DEFAULT NULL,
  `hora_salida` varchar(6) DEFAULT NULL,
  `id_tipo` varchar(30) DEFAULT NULL,
  `sueldo_fijo` double(18,0) DEFAULT NULL,
  `sueldo_contable` double(18,0) DEFAULT NULL,
  `cta_cont` varchar(30) DEFAULT NULL,
  `estado` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`usuario`),
  KEY `Ref80141` (`id_tipo`),
  KEY `Ref138261` (`cta_cont`),
  CONSTRAINT `Refplan_cuentas261` FOREIGN KEY (`cta_cont`) REFERENCES `plan_cuentas` (`cuenta`),
  CONSTRAINT `Reftipo_vendedor141` FOREIGN KEY (`id_tipo`) REFERENCES `tipo_vendedor` (`id_tipo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `usuarios` */

insert  into `usuarios`(`usuario`,`passw`,`hash`,`doc`,`nombre`,`apellido`,`tel`,`email`,`pais`,`dir`,`fecha_nac`,`fecha_cont`,`limite_sesion`,`imagen`,`suc`,`suc_princ`,`profesion`,`cargo`,`hora_entrada`,`hora_salida`,`id_tipo`,`sueldo_fijo`,`sueldo_contable`,`cta_cont`,`estado`) values ('*','*','*','N/A','generico','Usuario Generico','','','PARAGUAY','','2001-01-01','2001-01-01',0,'no_img','01',NULL,'N/A','N/A','N/A','N/A','GV',0,0,'1','Activo'),('douglas','2e6060b4c6b95c2ee886735b669eae29ab1d3113','94BA5ACF','4933243','Doglas Antonio','Dembogurski Feix','0983-593615','doublas@corporaciontextil.com.py','Paraguay','Encarnacion','0000-00-00','0000-00-00',3600,NULL,'01',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'Activo'),('Sistema','*','*','N/A','Sistema','Auto','','','PARAGUAY','','2001-01-01','2001-01-01',0,'no_img','01',NULL,'N/A','N/A','N/A','N/A','GV',0,0,'1','Activo'),('taller','b436b5a8341e3c40d71230db30b2dc4799a88d31','80f51b74',NULL,'HP','Proliant ML350',NULL,NULL,'Paraguay',NULL,NULL,NULL,NULL,NULL,'01',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);

/*Table structure for table `usuarios_x_grupo` */

DROP TABLE IF EXISTS `usuarios_x_grupo`;

CREATE TABLE `usuarios_x_grupo` (
  `usuario` varchar(30) NOT NULL,
  `id_grupo` int(11) NOT NULL,
  PRIMARY KEY (`usuario`,`id_grupo`),
  KEY `Ref63` (`usuario`),
  KEY `Ref54` (`id_grupo`),
  CONSTRAINT `Refgrupos4` FOREIGN KEY (`id_grupo`) REFERENCES `grupos` (`id_grupo`),
  CONSTRAINT `Refusuarios3` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `usuarios_x_grupo` */

insert  into `usuarios_x_grupo`(`usuario`,`id_grupo`) values ('douglas',5);

/*Table structure for table `usuarios_x_suc` */

DROP TABLE IF EXISTS `usuarios_x_suc`;

CREATE TABLE `usuarios_x_suc` (
  `suc` varchar(10) NOT NULL,
  `usuario` varchar(30) NOT NULL,
  PRIMARY KEY (`suc`,`usuario`),
  KEY `Ref1815` (`suc`),
  KEY `Ref616` (`usuario`),
  CONSTRAINT `Refsucursales15` FOREIGN KEY (`suc`) REFERENCES `sucursales` (`suc`),
  CONSTRAINT `Refusuarios16` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `usuarios_x_suc` */

insert  into `usuarios_x_suc`(`suc`,`usuario`) values ('01','douglas');

/* Trigger structure for table `entrada_det` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `upd_codigo_in_lotes_stock_hist_ubic_ordproc` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'plus'@'localhost' */ /*!50003 TRIGGER `upd_codigo_in_lotes_stock_hist_ubic_ordproc` AFTER UPDATE ON `entrada_det` FOR EACH ROW BEGIN
       if(old.codigo <> new.codigo or old.cod_pantone <> new.cod_pantone  or old.color_comb = new.color_comb or old.design = new.design or old.store_no = new.store_no or old.cod_catalogo = new.cod_catalogo 
       or old.fab_color_cod = new.fab_color_cod or old.bale = new.bale) then
                   
       
           update lotes set codigo =  new.codigo,pantone = new.cod_pantone, color_comb = new.color_comb, design = new.design,store = new.store_no,
           cod_catalogo = new.cod_catalogo  , color_cod_fabric = new.fab_color_cod,  bag  = new.bale
           where codigo = old.codigo and lote = old.lote and id_ent = old.id_ent and id_det = old.id_det; 
            
           
       end if;
       
       IF(old.codigo <> new.codigo) THEN
           UPDATE stock SET codigo =  new.codigo WHERE codigo = old.codigo AND lote = old.lote AND nro_identif = old.id_ent AND  linea = old.id_det AND tipo_ent = 'EM';     
           
           UPDATE historial SET codigo =  new.codigo WHERE codigo = old.codigo AND lote = old.lote AND nro_identif = old.id_ent AND  linea = old.id_det AND tipo_ent = 'EM';     
       
       END IF;
       
    END */$$


DELIMITER ;

/* Function  structure for function  `getFracLastTimeProc` */

/*!50003 DROP FUNCTION IF EXISTS `getFracLastTimeProc` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`plus`@`localhost` FUNCTION `getFracLastTimeProc`(padre_ INTEGER,id_ant INTEGER,hora_actual VARCHAR(14)) RETURNS int(11)
BEGIN
     
        DECLARE hora_ VARCHAR(14);
        DECLARE time_diff INTEGER;
        
	SELECT hora FROM fraccionamientos WHERE padre = padre_ AND id_frac < id_ant  AND fecha = CURRENT_DATE ORDER BY id_frac DESC LIMIT 1 INTO hora_   ; 
	
	IF(hora_ IS NULL)THEN 
           SELECT RIGHT(fecha_inicio,8) FROM orden_procesamiento WHERE lote = padre_ AND LEFT(fecha_inicio,10) = CURRENT_DATE LIMIT 1 INTO hora_   ; 
            	
	   IF(hora_ IS NULL)THEN 
	      SET hora_ = hora_actual;
	   END IF;
	END IF;
	
	SELECT TIME_TO_SEC(TIMEDIFF(hora_actual, hora_)) INTO time_diff;	
	
	RETURN time_diff;
    END */$$
DELIMITER ;

/* Function  structure for function  `promedio_frac` */

/*!50003 DROP FUNCTION IF EXISTS `promedio_frac` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`plus`@`%` FUNCTION `promedio_frac`(codigo_ VARCHAR(10)) RETURNS decimal(10,2)
BEGIN
        DECLARE PROM DECIMAL(10,2);
        SELECT AVG(tiempo_proc) FROM fraccionamientos WHERE codigo = codigo_ AND tiempo_proc  > 0  AND suc = '00' INTO PROM;
        RETURN PROM;
    END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
