<?php



/**
 * Description of Margen
 *
 * @author Ing. Doglas A. Dembogurski Feix
 */

require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php"); 


class Margen {
    function __construct() {
        $action = $_REQUEST['action'];          
        if (function_exists($action)) {
            call_user_func($action);
        } else {   
            $this->main();
        }        
    }     
    function main(){
        $t = new Y_Template("Margen.html");
        $t->Show("header");

        $t->Set("user", $_GET['user']);
        $t->Set("time",date('d-m-Y H:i'));
        
        $suc = $_REQUEST['select_suc'];          
        $desde = $_REQUEST['desde'];  
        $hasta = $_REQUEST['hasta'];  
        $tipo = $_REQUEST['tipo'];  
        
        $desde_eng = substr($desde, 6, 4) . '-' . substr($desde, 3, 2) . '-' . substr($desde, 0, 2);        
        $hasta_eng = substr($hasta, 6, 4) . '-' . substr($hasta, 3, 2) . '-' . substr($hasta, 0, 2);
                 
        if($tipo == ">=0"){
            $t->Set("tipo", 'Contado y Credito');
        }elseif($tipo == ">0"){
            $t->Set("tipo", 'Credito');
        }else{
            $t->Set("tipo", 'Contado');
        }
         
        
        $t->Set("suc", $suc== "%" ? "Todas" : $suc   );
        $t->Set("desde", $_GET['desde']);
        $t->Set("hasta", $_GET['hasta']);
        
        
        $t->Show("head");
 
        $link = new My();
         
        
        
        $Qry = "SELECT f.f_nro, f.fact_nro AS folio, DATE_FORMAT(fecha_cierre,'%d-%m-%Y') AS fecha_cierre,cliente, SUM(d.precio_costo) AS precio_costo, SUM(d.precio_venta) AS precio_venta,SUM(d.subtotal) AS subtotal,SUM(d.subtotal - d.precio_costo) AS margen
        FROM factura_venta f, fact_vent_det d , articulos a  WHERE f.f_nro = d.f_nro AND d.codigo = a.codigo AND f.estado = 'Cerrada'   AND f.fecha_cierre BETWEEN '$desde_eng' AND '$hasta_eng' AND f.suc like '$suc' and f.cant_cuotas $tipo GROUP BY f.f_nro";
         
 
        $link->Query($Qry);
        $t->Show("data_cab");
        $total_margen = 0;
        
        while($link->NextRecord()){
            $f_nro =  $link->Record['f_nro'];
            $folio =  $link->Record['folio'];
            $fecha_cierre =  $link->Record['fecha_cierre']; 
            $cliente = $link->Record['cliente'];
            $precio_costo =  $link->Record['precio_costo'];
            $subtotal =  $link->Record['subtotal']; 
            
            $margen = $link->Record['margen']; 
            
            $total_margen += 0+ $margen;
              
            $t->Set("f_nro",$f_nro);   
            $t->Set("folio",$folio);
            $t->Set("fecha",$fecha_cierre);   
            $t->Set("cliente",$cliente);
            $t->Set("precio_costo",number_format($precio_costo,2, ',', '.'));
            $t->Set("subtotal",number_format($subtotal,2, ',', '.'));
            $t->Set("margen",number_format($margen,2, ',', '.'));
            
            $t->Show("data");
        }
        $t->Set("total_margen",number_format($total_margen,2, ',', '.'));            
        
        $t->Show("footer");
    }
}
 
new Margen();
?>
