/*
SQLyog Ultimate v11.11 (64 bit)
MySQL - 5.6.17 : Database - marijoa_sap
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`marijoa_sap` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `marijoa_sap`;

/*Table structure for table `mon_subdiv` */

DROP TABLE IF EXISTS `mon_subdiv`;

CREATE TABLE `mon_subdiv` (
  `m_cod` varchar(4) NOT NULL,
  `identif` varchar(30) NOT NULL,
  `valor` decimal(16,2) DEFAULT NULL,
  `estado` varchar(50) NOT NULL DEFAULT 'Activo',
  PRIMARY KEY (`m_cod`,`identif`),
  CONSTRAINT `CodigoMoneda` FOREIGN KEY (`m_cod`) REFERENCES `monedas` (`m_cod`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Data for the table `mon_subdiv` */

insert  into `mon_subdiv`(`m_cod`,`identif`,`valor`,`estado`) values ('G$','b_10000',10000.00,'Activo'),('G$','b_100000',100000.00,'Activo'),('G$','b_2000',2000.00,'Activo'),('G$','b_20000',20000.00,'Activo'),('G$','b_5000',5000.00,'Activo'),('G$','b_50000',50000.00,'Activo'),('G$','m_100',100.00,'Activo'),('G$','m_1000',1000.00,'Activo'),('G$','m_50',50.00,'Activo'),('G$','m_500',500.00,'Activo'),('P$','b_1',1.00,'Inactivo'),('P$','b_10',10.00,'Activo'),('P$','b_100',100.00,'Activo'),('P$','b_1000',1000.00,'Activo'),('P$','b_2',2.00,'Inactivo'),('P$','b_20',20.00,'Activo'),('P$','b_200',200.00,'Activo'),('P$','b_5',5.00,'Activo'),('P$','b_50',50.00,'Activo'),('P$','b_500',500.00,'Activo'),('P$','m_0_05',0.05,'Activo'),('P$','m_0_10',0.10,'Activo'),('P$','m_0_25',0.25,'Activo'),('P$','m_0_50',0.50,'Activo'),('P$','m_1',1.00,'Activo'),('P$','m_2',2.00,'Activo'),('R$','b_1',1.00,'Activo'),('R$','b_10',10.00,'Activo'),('R$','b_100',100.00,'Activo'),('R$','b_2',2.00,'Activo'),('R$','b_20',20.00,'Activo'),('R$','b_5',5.00,'Activo'),('R$','b_50',50.00,'Activo'),('R$','m_0_05',0.05,'Activo'),('R$','m_0_10',0.10,'Activo'),('R$','m_0_25',0.25,'Activo'),('R$','m_0_50',0.50,'Activo'),('R$','m_1',1.00,'Activo'),('U$','b_1',1.00,'Activo'),('U$','b_10',10.00,'Activo'),('U$','b_100',100.00,'Activo'),('U$','b_2',2.00,'Activo'),('U$','b_20',20.00,'Activo'),('U$','b_5',5.00,'Activo'),('U$','b_50',50.00,'Activo'),('U$','m_0_05',0.05,'Activo'),('U$','m_0_10',0.10,'Activo'),('U$','m_0_25',0.25,'Activo'),('U$','m_0_50',0.50,'Activo'),('U$','m_1',1.00,'Activo');

/* Trigger structure for table `factura_venta` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `estado_sap` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'plus'@'%' */ /*!50003 TRIGGER `estado_sap` BEFORE UPDATE ON `factura_venta` FOR EACH ROW BEGIN
	IF old.e_sap = 1 AND new.estado <> 'Cerrada' THEN
	SET new.estado = "Cerrada";
	 END IF;
    END */$$


DELIMITER ;

/* Trigger structure for table `factura_venta` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `corregir_fechas` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'plus'@'%' */ /*!50003 TRIGGER `corregir_fechas` AFTER UPDATE ON `factura_venta` FOR EACH ROW BEGIN
     IF (NEW.fecha_cierre != OLD.fecha_cierre) THEN
	  UPDATE efectivo e SET fecha = NEW.fecha_cierre WHERE e.f_nro = NEW.f_nro;         
	  UPDATE convenios e SET fecha = NEW.fecha_cierre WHERE e.f_nro = NEW.f_nro; 
	  UPDATE cheques_ter e SET fecha_ins = NEW.fecha_cierre WHERE e.f_nro = NEW.f_nro; 
	  UPDATE cuotas e SET fecha  = NEW.fecha_cierre WHERE e.f_nro = NEW.f_nro;  
     END IF; 
    END */$$


DELIMITER ;

/* Trigger structure for table `fraccionamientos` */

DELIMITER $$

/*!50003 DROP TRIGGER*//*!50032 IF EXISTS */ /*!50003 `calc_time_diff` */$$

/*!50003 CREATE */ /*!50017 DEFINER = 'plus'@'localhost' */ /*!50003 TRIGGER `calc_time_diff` BEFORE UPDATE ON `fraccionamientos` FOR EACH ROW BEGIN
        
        SET new.tiempo_proc = getFracLastTimeProc(old.padre,old.id_frac,old.hora);
        
       
    END */$$


DELIMITER ;

/* Function  structure for function  `getFracLastTimeProc` */

/*!50003 DROP FUNCTION IF EXISTS `getFracLastTimeProc` */;
DELIMITER $$

/*!50003 CREATE DEFINER=`plus`@`localhost` FUNCTION `getFracLastTimeProc`(padre_ INTEGER,id_ant INTEGER,hora_actual VARCHAR(14)) RETURNS int(11)
BEGIN
     
        DECLARE hora_ VARCHAR(14);
        DECLARE time_diff INTEGER;
        
	SELECT hora FROM fraccionamientos WHERE padre = padre_ AND id_frac < id_ant  and fecha = current_date ORDER BY id_frac DESC LIMIT 1 INTO hora_   ; 
	
	IF(hora_ IS NULL)THEN 
           SELECT RIGHT(fecha_inicio,8) FROM orden_procesamiento WHERE lote = padre_ and LEFT(fecha_inicio,10) = CURRENT_DATE LIMIT 1 INTO hora_   ; 
            	
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

/*Table structure for table `devoluciones` */

DROP TABLE IF EXISTS `devoluciones`;

/*!50001 DROP VIEW IF EXISTS `devoluciones` */;
/*!50001 DROP TABLE IF EXISTS `devoluciones` */;

/*!50001 CREATE TABLE  `devoluciones`(
 `n_nro` int(11) ,
 `cod_cli` varchar(30) ,
 `f_nro` int(11) ,
 `codigo` varchar(30) ,
 `lote` varchar(30) ,
 `cantidad` decimal(16,2) 
)*/;

/*View structure for view devoluciones */

/*!50001 DROP TABLE IF EXISTS `devoluciones` */;
/*!50001 DROP VIEW IF EXISTS `devoluciones` */;

/*!50001 CREATE ALGORITHM=UNDEFINED DEFINER=`douglas`@`%` SQL SECURITY DEFINER VIEW `devoluciones` AS select `n`.`n_nro` AS `n_nro`,`n`.`cod_cli` AS `cod_cli`,`n`.`f_nro` AS `f_nro`,`d`.`codigo` AS `codigo`,`d`.`lote` AS `lote`,`d`.`cantidad` AS `cantidad` from (`nota_credito` `n` join `nota_credito_det` `d` on(((`n`.`n_nro` = `d`.`n_nro`) and (`n`.`estado` = 'Cerrada')))) */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
