<?php

/**
 * Description of Test
 * @author Ing.Douglas
 * @date 06/12/2016
 */

set_time_limit(0);

class ClientesSync {

    function __construct() {
         
        require_once("..\Y_DB_MSSQL.class.php");
        require_once("..\Y_DB_MySQL.class.php");
        
        require_once("..\Functions.class.php");
        //$f = new Functions();
        
        $my =new My();
        $db =new My();
        $my->Query("select distinct ci_ruc,nombre from clientes where e_sap = 0 LIMIT 200");
        
        while($my->NextRecord()){
            $ruc = $my->Record['ci_ruc']; 
            $params = "?action=registrarCliente&ruc=$ruc";
            $comlete_url = "http://192.168.2.220:8081/$params";
           
            $get =  file_get_contents($comlete_url );
              
            echo  $get."<br><br>" ;
            $pos = strpos($get,"registrado anteriormente");     
            
            
            
            if($pos !== false){
               $rpos = strpos($get,"RUC"); 
               $rucp = trim( substr( $get, $rpos+4 , 12 ) );
               $r = explode(" ", $rucp);
               
               $r1 = $r[0];
               
               
               $up = "update clientes set e_sap = 1 where ci_ruc ='$r1'";
               echo $up."<br>";
               $db->Query($up);
            }
           
           sleep(1);
        }
        
        
          
    }
}

new ClientesSync();
?>