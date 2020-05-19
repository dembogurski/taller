<?php

/**
 * Description of ResumenPaquetes
 * @author Ing.Douglas
 * @date 03/08/2018
 */

require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");
require_once '../Y_DB_MSSQL.class.php';
class ResumenPaquetes {
    function __construct() {
        $t =  new Y_Template("ResumenPaquetes.html");
        $t->Show("header");
        
        $factura = $_REQUEST['factura'];
        $user = $_REQUEST['usuario'];
        $t->Set("user",$user);
        $t->Set("time",date("m-d-Y H:i"));
        $db = new My();
        $db->Query("SELECT DATE_FORMAT(CURRENT_DATE,'%d-%m-%Y') AS fecha,suc,cat,tipo_doc_cli,ruc_cli,cliente,moneda  FROM factura_venta WHERE f_nro = $factura");
        if($db->NumRows() > 0){
           $db->NextRecord();
           $fecha = $db->Record['fecha'];
           $suc = $db->Record['suc'];
           $cat = $db->Record['cat'];
           $tipo_doc_cli = $db->Record['tipo_doc_cli'];
           $ruc_cli = $db->Record['ruc_cli'];
           $cliente = $db->Record['cliente'];
           $moneda = $db->Record['moneda'];
           $pos = strpos($ruc_cli,'-');

           $ms = new MS();
              $sql_addr ="select Address,City,Country, Phone1 from OCRD o where LicTradNum = '$ruc_cli'";
              $ms->Query($sql_addr);
              $dir = "";
              if($ms->NumRows() > 0){
                  $ms->NextRecord();
                  $Address = $ms->Record['Address'];
                  $City = $ms->Record['City'];
                  $Country = $ms->Record['Country'];
                  $Phone1 = $ms->Record['Phone1'];
                  $dir = "$Address - $City - $Country"; 
              }
              $t->Set('Phone1', $Phone1);
              $t->Set('dir', $dir);  
           
           if($pos != false){
               $tipo_doc_cli = "RUC";
           }
           $t->Set("factura",$factura); 
           $t->Set("tipo_doc",$tipo_doc_cli);
           $t->Set("fecha",$fecha);
           $t->Set("suc",$suc);
           $t->Set("cat",$cat);
           $t->Set("cliente",$cliente);
           $t->Set("ruc",$ruc_cli);
           $t->Set("moneda",$moneda);
           $t->Show("head");
        }
        $det = "SELECT paquete,COUNT(*) as cant from fact_vent_det where f_nro = $factura GROUP BY paquete ORDER BY paquete ASC";
        $db->Query($det);
        $TOTAL = 0;
        
        while($db->NextRecord()){
            $paquete = $db->Record['paquete'];
            $cant = $db->Record['cant'];
              $TOTAL+=0+$cant;          
            $t->Set("paquete",$paquete);
            $t->Set("cant",$cant);
                       
             
            $t->Show("data");
            
        }
        
        $t->Set("TOTAL",number_format($TOTAL,0,',','.'));     
         
        $t->Show("foot");
    }
}
new ResumenPaquetes();
?>
