/*
SQLyog Ultimate v11.11 (32 bit)
MySQL - 5.5.5-10.4.13-MariaDB : Database - taller
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

/*Table structure for table `puntos` */

DROP TABLE IF EXISTS `puntos`;

CREATE TABLE `puntos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cod_cli` varchar(10) DEFAULT NULL,
  `puntos` int(11) DEFAULT NULL,
  `motivo` varchar(60) DEFAULT NULL,
  `fecha` date DEFAULT NULL,
  `usuario` varchar(30) DEFAULT NULL,
  `fecha_canje` date DEFAULT NULL,
  `estado` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `usuarios` (`usuario`),
  KEY `cliente` (`cod_cli`),
  CONSTRAINT `cliente` FOREIGN KEY (`cod_cli`) REFERENCES `clientes` (`cod_cli`),
  CONSTRAINT `usuarios` FOREIGN KEY (`usuario`) REFERENCES `usuarios` (`usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

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
