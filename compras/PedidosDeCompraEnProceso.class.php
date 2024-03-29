<?php

/**
 * Description of PedidosDeCompraEnProceso
 * @author Ing.Douglas
 * @date 02/03/2016
 */
require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_DB_MSSQL.class.php");

class PedidosDeCompraEnProceso {
    function __construct() {
        $t = new Y_Template("PedidosDeCompraEnProceso.html");
        $db = new My();       
        
        
        $ms = new MS();
        $ms->Query("SELECT Name AS COLOR FROM [@EXX_COLOR_COMERCIAL] ORDER BY NAME ASC");
        $colores = "";
        //array_map('utf8_encode', $ms->Record);
        while ($ms->NextRecord()) {    
            $color = utf8_encode( $ms->Record['COLOR']);    
            $colores.="'$color',";
        }
        $colores = substr($colores, 0, -1);
        $t->Set("colores", "[" . $colores . "]");
        
        /**
         * Patrones de dise�o         
         */
        $ms->Query("select Code as Carpeta,Name as Patron from [@DESIGN_PATTERNS] WHERE U_estado = 'Activo'");
        $patrones = "";
        $pattern_codes = "";
        //array_map('utf8_encode', $ms->Record);
        while ($ms->NextRecord()) {    
            $carpeta = utf8_encode( $ms->Record['Carpeta']); 
            $patron = utf8_encode( $ms->Record['Patron']);
            $patrones.="'$patron',";
            $pattern_codes.="'$carpeta',";
        }
        $patrones = substr($patrones, 0, -1);        
        $t->Set("patterns", "[" . $patrones . "]");
        $pattern_codes = substr($pattern_codes, 0, -1);
        $t->Set("pattern_codes", "[" . $pattern_codes . "]");
        
       
        $t->Show("header");
        $t->Show("titulo");
        
        $t->Show("formulario");
               
       
        $db->Query("SELECT n_nro,usuario,temporada,DATE_FORMAT(fecha_cierre,'%d-%m-%Y') AS fecha,estado FROM nota_pedido_compra WHERE nac_int = 'Internacional' AND estado = 'En Proceso'");
        while ($db->NextRecord()){
            $nro = $db->Record['n_nro'];
            $usuario = $db->Record['usuario'];
            $temporada = $db->Record['temporada'];
            $fecha = $db->Record['fecha'];
            $estado = $db->Record['estado'];
            $t->Set("nro",$nro); 
            $t->Set("usuario",$usuario); 
            $t->Set("temporada",$temporada); 
            $t->Set("fecha",$fecha); 
            $t->Set("estado",$estado); 
            $t->Show("pedidos");
        }
        $t->Show("pedidos_body");
        
       }
}
new PedidosDeCompraEnProceso();
?>
