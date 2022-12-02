<?php

 

/**
 * Description of Stock
 *
 * @author Doglas A. Dembogurski Feix
 */

require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php"); 

class Stock {
    function __construct() {
        $action = $_REQUEST['action'];          
        if (function_exists($action)) {
            call_user_func($action);
        } else {   
            $this->main();
        }        
    }     
    function main(){
        $t = new Y_Template("Stock.html");
        $t->Show("header");

        $t->Set("user", $_GET['user']);
        $t->Set("time",date('d-m-Y H:i'));
        
        $suc_ = $_REQUEST['select_suc'];  
        $sector_ = $_REQUEST['select_sector'];  
        $art_ = $_REQUEST['select_articulos'];  
        $criterio = $_REQUEST['criterio'];  
        $umbral = $_REQUEST['umbral'];  
        
        $t->Show("head");

       
        $link = new My();
         
        
        
        $Qry = "SELECT s.suc, a.codigo,a.descrip,a.um, a.costo_prom, cantidad, a.costo_prom * cantidad AS valor_stock ,img FROM  articulos a, stock s "
                . "WHERE a.codigo = s.codigo AND s.cantidad $criterio $umbral AND a.cod_sector LIKE '$sector_'  AND a.codigo LIKE '$art_' AND s.suc LIKE '$suc_'";
         
        // die();
        $link->Query($Qry);
        $t->Show("data_cab");
        $$total_valor_stock = 0;
        
        while($link->NextRecord()){
            $suc =  $link->Record['suc'];
            $codigo =  $link->Record['codigo'];
            $descrip =  $link->Record['descrip'];
            $um =  $link->Record['um']; 
            $costo_prom = $link->Record['costo_prom'];
            $cantidad = $link->Record['cantidad'];
            $valor_stock =  $link->Record['valor_stock'];
            $img =  $link->Record['img'];
            
            $total_valor_stock += 0+ $valor_stock;
              
            $t->Set("suc",$suc);   
            $t->Set("codigo",$codigo);
            $t->Set("descrip",$descrip);
            $t->Set("um",$um);
 
            $t->Set("costo_prom",number_format($costo_prom,2, ',', '.'));
            $t->Set("cantidad",number_format($cantidad,2, ',', '.'));
            $t->Set("valor_stock",number_format($valor_stock,2, ',', '.'));
            
            
            $t->Set("img",$img);                      

            $t->Show("data");
        }
        $t->Set("total_valor_stock",number_format($total_valor_stock,2, ',', '.'));            
        
        $t->Show("footer");
    }
}
 
new Stock();
?>
