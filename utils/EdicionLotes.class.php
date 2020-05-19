<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of EdicionLotes
 *
 * @author Doglas
 */

set_time_limit(0);

require_once ("PHPExcel/IOFactory.php");
require_once ("../Y_DB_MySQL.class.php");
require_once ("../Y_DB_MSSQL.class.php");

 


class EdicionLotes {

    function __construct() {
        $action = $_REQUEST['action'];
        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }
    }

    function main() {
         
        
        // Formato del Excel
        //ItemCode BatchNum Ancho Gramaje Cant.Aajustar

        $inputFileName = '../files/Excel/ActualizacionGramajeEntrada3319.xlsx';
        try {
            $inputFileType = PHPExcel_IOFactory::identify($inputFileName);
            $objReader = PHPExcel_IOFactory::createReader($inputFileType);
            $objPHPExcel = $objReader->load($inputFileName);
            //  Get worksheet dimensions
            $sheet = $objPHPExcel->getSheet(0);
            $highestRow = $sheet->getHighestRow();
            $highestColumn = $sheet->getHighestColumn();
     
            $ms = new MS();
            $db = new My();
            //  Loop through each row of the worksheet in turn  $highestRow
            for ($row = 2; $row <= 696; $row++) {         
                //  Read a row of data into an array
                $arr = $sheet->rangeToArray('A' . $row . ':' . $highestColumn . $row, NULL, TRUE, FALSE);
                 
                $ItemCode = $arr[0][0];
                $ItemName = $arr[0][1];
                $BatchNum = $arr[0][2];
                $Ancho = $arr[0][3];
                $Gramaje = $arr[0][4];    
                $Tara = $arr[0][5];    
                $Kg = $arr[0][6];    
                $Mts = $arr[0][7];    
                
                
                 echo "$ItemCode         $ItemName          $BatchNum        $Ancho            $Gramaje            $Tara            $Kg           $Mts<br>"; 
                
                 
                $usuario = "AliciaC";
                $suc = "00";               
                
                if($BatchNum == ""){ 
                    echo "BatchNum = $BatchNum  $ItemCode $Ancho   $Gramaje   $suc<br>"; 
                    break;
                }
                
                $db->Query("INSERT INTO edicion_lotes(  usuario, codigo, lote, descrip, fecha, hora, suc, tara, ancho, kg, gramaje,obs, e_sap)
                VALUES (  '$usuario', '$ItemCode', '$BatchNum', '$ItemName', CURRENT_DATE, CURRENT_TIME, '$suc', '$Tara', '$Ancho', '$Kg', '$Gramaje','A pedido de Victor y AliciaC',10);");                                   
               
                 
                
            }
        } catch (Exception $e) {
            die('Error loading file "' . pathinfo($inputFileName, PATHINFO_BASENAME) . '": ' . $e->getMessage());
        }
    }

}

function cambiarEstado(){
    $db = new My();
    $db->Query("SELECT id  FROM edicion_lotes WHERE e_sap = 10 LIMIT 1");
    if($db->NumRows()>0 ){
        $db->NextRecord();
        $id = $db->Record['id'];
        $db->Query("update edicion_lotes set e_sap = 0 where id  = $id;");
        echo "Ok";
    }else{
        echo "Fin";
    }
    
}
function iniciar(){
    echo '<html>
    <head>
        <script type="text/javascript" src="../js/jquery-2.1.3.min.js?_=213216565" ></script> 
        <script>
            function start(){
                $.ajax({
                type: "POST",
                url: "EdicionLotes.class.php",
                            data: {"action": "cambiarEstado" },
                            async: true,
                            dataType: "html",
                            beforeSend: function () {
                                $("#msg").html("Cambiando..."); 
                            },
                            complete: function (objeto, exito) {
                                if (exito == "success") {                          
                                    var result = $.trim(objeto.responseText); 
                                    if(result == "Ok"){
                                        setTimeout("start()",7000);    
                                    }
                                    $("#msg").html("..."); 
                                }
                            },
                            error: function () {
                                $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
                            }
                        }); 
            }
        </script>    
    </head>   
    
    <body>
        <span id="msg"></span>
    </body>
</html>'
    . '<input type="button" value="Iniciar" onclick="start()" >';
}
 
new EdicionLotes();
?>



