<?php

/**
 * Description of SetParser
 * @author Ing.Douglas
 * @date 31/03/2017
 */

require_once("../../Y_DB_MSSQL.class.php");

class SetParser {
    function __construct(){
       $content = $_REQUEST['content'];
       //$arr = explode("|",$content);
        
       //echo "Recibido: $content";
       
       $ms = new MS();
       
       $rates = json_decode($content);
       
       foreach ($rates as $mon => $val) {
           $ms->Query("SELECT Currency,Rate  FROM ORTT WHERE Currency = '$mon' and RateDate = CONVERT (date, SYSDATETIME())  ");
           //$ms->Query("SELECT Currency,Rate  FROM ORTT WHERE Currency = '$mon' and RateDate = '07-08-2018'  ");
                
           $today = date("d-m-Y");
           //$today = date("07-08-2018");
              
           if($ms->NumRows() > 0){
               $ms->NextRecord();
               $cotiz = number_format($ms->Record['Rate'], 2, ',', '.') ;  
                
               if($cotiz != $val){//Update
                   echo "Cotizacion $mon $val  != a establecida: $cotiz  \n  ";
                   
                   $params = "?action=setTipoCambio&moneda=$mon&fecha=$today&cotiz=$val";
                   $comlete_url = "http://192.168.2.220:8081/$params";                 
                   $get =  file_get_contents($comlete_url );
                   echo $get;
                   sleep(2);
               }else{// No hacer nada cotizacion establecida e igual a la actual 
                   echo "Cotizacion $mon $val  == a establecida: $cotiz  \n  ";
               }
           }else{//Insertar cotizacion no establecida
               echo "Cotizacion $mon $val  no establecida \n  ";
           }
       } 
       
       file_put_contents("cotizaciones.txt", $rates);
       
      
    }
}
new SetParser();
?>
