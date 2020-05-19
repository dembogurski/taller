
<?php

/**
 * Description of Ajusteses
 * @author Ing.Douglas
 * @date 14/09/2018
 */

set_time_limit(0);

require_once ("PHPExcel/IOFactory.php");
require_once ("../Y_DB_MySQL.class.php");
require_once ("../Y_DB_MSSQL.class.php");

class AjusteEnExcel {

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

        $inputFileName = '../files/Excel/AjustesFibranaEstampadaContenedor3.xlsx';
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
            for ($row = 2; $row <= 179; $row++) {         
                //  Read a row of data into an array
                $arr = $sheet->rangeToArray('A' . $row . ':' . $highestColumn . $row, NULL, TRUE, FALSE);
                 
                $ItemCode = $arr[0][0];
                $BatchNum = $arr[0][1];
                $Ancho = $arr[0][2];
                $Gramaje = $arr[0][3];    
                
                $Ajuste = round($arr[0][4],2);
                $suc = $arr[0][5];
                
                if($BatchNum == ""){ 
                    echo "BatchNum = $BatchNum  $ItemCode $Ancho   $Gramaje   $Ajuste  $suc"; 
                    break;
                }
                
                $flag = 0;
                
                $rem = "SELECT COUNT(*) as cant, r.n_nro , r.suc_d FROM nota_remision r , nota_rem_det d WHERE r.n_nro = d.n_nro AND lote = '$BatchNum' AND r.suc = '$suc' and r.estado = 'Abierta'";
                $db->Query($rem);
                $db->NextRecord();
                $cant_en_rem = $db->Record['cant'];
                if($cant_en_rem > 0){
                    $n_nro = $db->Record['n_nro'];
                    $suc_d = $db->Record['suc_d'];                    
                    echo ">>>>>>>>>>>>>>>>>>>>>>Lote $BatchNum en Remision Nro: $n_nro   Destino: $suc_d<br>";
                    $flag++;
                }
                
                $fac = "SELECT COUNT(*) as cant, r.f_nro   FROM factura_venta r , fact_vent_det d WHERE r.f_nro = d.f_nro AND lote = '$BatchNum' AND r.suc = '$suc' and r.estado = 'Abierta'";
                $db->Query($fac);
                $db->NextRecord();
                $cant_en_f = $db->Record['cant'];
                if($cant_en_f > 0){
                    $n_nro = $db->Record['f_nro'];                                    
                    echo ">>>>>>>>>>>>>>>>>>>>>>,Lote $BatchNum en Factura Abierta Nro: $n_nro <br>";
                    $flag++;
                }
                
                $stock = "SELECT Quantity,AvgPrice FROM OIBT o,OITM t WHERE o.ItemCode = t.ItemCode and  o.ItemCode = '$ItemCode' and BatchNum = '$BatchNum' and WhsCode = '$suc'; ";
                
                //echo $stock;
                
                //echo "<br>BatchNum = $BatchNum  $ItemCode $Ancho   $Gramaje   $Ajuste  $suc";
                //die();
                $ms->Query($stock);
                $ms->NextRecord();
                $Quantity = round($ms->Record['Quantity'],2);
                $p_costo = $ms->Record['AvgPrice'];
                $valor_ajuste = abs($Ajuste) * $p_costo;
                $final = $Quantity + $Ajuste;
               // $final = 0  ;
               //echo "$BatchNum, $p_costo, $valor_ajuste <br>";     
                
                //$Ajuste = $Quantity  ;
                $signo = "-";     
                          // $ms->Query("update OIBT SET U_gramaje = $Gramaje, U_ancho = $Ancho where ItemCode = '$ItemCode' and BatchNum ='$BatchNum'; ");
                                                      
                 
                if($Ajuste < 0){     
               // if(true){                    
                    if($Quantity > 0){
                        if($flag == 0){
                           $signo = "-";
                           //$Ajuste = $Ajuste * -1;
                           
                          // $ms->Query("update OIBT SET U_gramaje = $Gramaje, U_ancho = $Ancho where ItemCode = '$ItemCode' and BatchNum ='$BatchNum'; ");
                                                      
                           $db->Query("INSERT INTO ajustes( usuario, f_nro, codigo, lote, tipo, signo, inicial, ajuste, final, p_costo, motivo, fecha, hora, um, estado, verificado_por, verif_hora, valor_ajuste, suc, e_sap)
                           VALUES ( 'Rosaura', 0, '$ItemCode', '$BatchNum', 'Disminucion por Informacion Viciada', '$signo',$Quantity ,$Ajuste ,$final, $p_costo, 'Diferencia s/ descarga Factura 19ZLFS03, Cantidad ticket', CURRENT_DATE, CURRENT_TIME, 'Mts', 'Pendiente', 'douglas', CURRENT_TIME, $valor_ajuste , '$suc', 10);");
                           echo "Lote $BatchNum, Stock:, $Quantity a $final   (-$Ajuste),costo,$p_costo, valor,$valor_ajuste <br>"; 
                        }
                    }else{
                        echo ">>>>>>>>>>>>>>>>>>>>>>(-), No se puede Ajustar $BatchNum Stock: $Quantity :      Ajuste - $Ajuste<br>";
                    }
                }else{
                    if($flag == 0){
                        $signo = "+";
                        
                        //$ms->Query("update OIBT SET U_gramaje = $Gramaje, U_ancho = $Ancho where ItemCode = '$ItemCode' and BatchNum ='$BatchNum'; ");
                        
                        $db->Query("INSERT INTO ajustes( usuario, f_nro, codigo, lote, tipo, signo, inicial, ajuste, final, p_costo, motivo, fecha, hora, um, estado, verificado_por, verif_hora, valor_ajuste, suc, e_sap)
                        VALUES ( 'rosaura', 0, '$ItemCode', '$BatchNum', 'Aumento por Informacion Viciada', '$signo',$Quantity ,$Ajuste ,$final, $p_costo, 'Diferencia s/ descarga Factura 19ZLFS03, Cantidad ticket', CURRENT_DATE, CURRENT_TIME, 'Mts', 'Pendiente', 'douglas', CURRENT_TIME, $valor_ajuste , '$suc', 10);");
                        echo "Lote $BatchNum, Stock:, $Quantity a $final   (+$Ajuste),costo,$p_costo, valor,$valor_ajuste <br>"; 
                    }
                }
                 
                
            }
        } catch (Exception $e) {
            die('Error loading file "' . pathinfo($inputFileName, PATHINFO_BASENAME) . '": ' . $e->getMessage());
        }
    }

}

function cambiarEstado(){
    $db = new My();
    $db->Query("SELECT id_ajuste FROM ajustes WHERE e_sap = 10 LIMIT 1");
    if($db->NumRows()>0 ){
        $db->NextRecord();
        $id = $db->Record['id_ajuste'];
        $db->Query("update ajustes set e_sap = 0 where id_ajuste = $id;");
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
                url: "AjustesEnExcel.class.php",
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
                                        setTimeout("start()",4000);
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
 
new AjusteEnExcel();
?>



