<?php

/**
 * Description of CambioPreciosPorLotes
 * @author Ing.Douglas
 * @date 07/06/2019
 */
/**
 * Description of Ajusteses
 * @author Ing.Douglas
 * @date 14/09/2018
 */
set_time_limit(0);

require_once ("PHPExcel/IOFactory.php");
require_once ("../Y_DB_MySQL.class.php");
require_once ("../Y_DB_MSSQL.class.php");

class CambioPreciosPorLotes {

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

        $inputFileName = '../files/Excel/EstructuraCambioPrecios.xlsx';
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
            for ($row = 20; $row <= 4022; $row++) {     
                //  Read a row of data into an array
                $arr = $sheet->rangeToArray('A' . $row . ':' . $highestColumn . $row, NULL, TRUE, FALSE);


                echo "Row: $row <br><br>";

                $ItemCode = $arr[0][0];
                $Descrip = $arr[0][1];
                $BatchNum = $arr[0][2];
                $Suc = $arr[0][4];
                $estado_venta = $arr[0][9];

                $pf1 = round($arr[0][19], 0);
                $pf2 = round($arr[0][19], 0);
                $pf3 = round($arr[0][19], 0);
                $pf4 = round($arr[0][19], 0);
                $pf5 = round($arr[0][19], 0);
                $pf6 = round($arr[0][19], 0);
                $pf7 = round($arr[0][19], 0);



                $descs = "SELECT  * from ( SELECT  i.ItemCode as Codigo,it.ItemName as Articulo,i.BatchNum as Lote,i.WhsCode as Suc, i.U_ancho as Ancho, cast(round(Quantity - ISNULL(i.IsCommited,0),2) as numeric(20,2)) as Stock, AvgPrice as PrecioCosto,Price,PriceList, CONVERT(DECIMAL(10,2),U_desc1) as U_desc1,U_desc2,U_desc3,U_desc4,U_desc5,U_desc6,U_desc7   
                FROM OIGN o,OIBT i, OITM it, ITM1 p WHERE     o.DocEntry = i.BaseNum and Quantity > 0 and i.ItemCode = it.ItemCode and i.ItemCode = p.ItemCode  
                AND o.ObjType = i.BaseType     and  BatchNum = '$BatchNum'  ) as src PIVOT (  avg(Price) FOR PriceList in ([1],[2],[3],[4],[5],[6],[7])) as Pvt";

                $ms->Query($descs);
                $ms->NextRecord();

                $stock = $ms->Record["Stock"];

                if ($stock > 0) {
                    echo "Codigo | Descrip  | BatchNum | Suc | Est. Venta  |  Precio 1-7 Oferta   <br>";
                    echo "$ItemCode | $Descrip | $BatchNum | $Suc | $estado_venta  |  $pf1   <br>";


                    for ($i = 1; $i <= 7; $i++) {
                        $desc = $ms->Record["U_desc$i"];
                        $precio = $ms->Record["$i"];
                        ${"U_desc" . $i} = $desc;
                        ${"Precio" . $i} = round($precio); // El Precio x en el Articulo
                        ${"p" . $i} = round($precio - ($precio * $desc / 100)); // Precios actuales
                    }


                    // Nuevos descuentos
                    $desc1 = 100 - ($pf1 * 100 / $Precio1);
                    $desc2 = 100 - ($pf2 * 100 / $Precio2);
                    $desc3 = 100 - ($pf3 * 100 / $Precio3);
                    $desc4 = 100 - ($pf4 * 100 / $Precio4);
                    $desc5 = 100 - ($pf5 * 100 / $Precio5);
                    $desc6 = 100 - ($pf6 * 100 / $Precio6);
                    $desc7 = 100 - ($pf7 * 100 / $Precio7);
                    echo "PActual  |   PrecioArt |   Nuevo Desc   |  Precio Final<br>";
                    echo "$p1  |  $Precio1  |  $desc1    |   $pf1<br>";
                    if($p1 >= $pf1){
                        $sql = "INSERT INTO hist_precios( usuario, estado_venta, fecha, hora, codigo, lote, suc, p1, p2, p3, p4, p5, p6, p7, desc1, desc2, desc3, desc4, desc5, desc6, desc7, pf1, pf2, pf3, pf4, pf5, pf6, pf7, fecha_impresion, cant_impresiones,e_sap)
                                VALUES ( 'douglas', 'Oferta',CURRENT_DATE,CURRENT_TIME, '$ItemCode', '$BatchNum', '$Suc', $p1, $p2, $p3, $p4, $p5, $p6, $p7, $desc1, $desc2, $desc3, $desc4, $desc5, $desc6, $desc7, $pf1, $pf2, $pf3, $pf4, $pf5, $pf6, $pf7,'',0,10);";
                        $db->Query($sql);
                    }else{
                        echo "<label style='color:red'>Lote $BatchNum      $Descrip ignorar Precio actual $p1 <  a nuevo precio $pf1</label><br>";
                    }
                } else {
                    echo "<label style='color:orange'>Lote $BatchNum      $Descrip con stock 0</label><br>";
                }
            }
        } catch (Exception $e) {
            die('Error loading file "' . pathinfo($inputFileName, PATHINFO_BASENAME) . '": ' . $e->getMessage());
        }
    }

}

function cambiarEstado() {
    $db = new My();
    $db2 = new My();
    $ms = new MS();
    $db->Query("SELECT id_hist,codigo,lote,desc1,desc2,desc3,desc4,desc5,desc6,desc7,estado_venta FROM hist_precios WHERE e_sap = 10 LIMIT 3");
    if ($db->NumRows() > 0) {
        
        while ($db->NextRecord()) {
            $id = $db->Record['id_hist'];
            $codigo = $db->Record['codigo'];
            $lote = $db->Record['lote'];
            $desc1 = $db->Record['desc1'];
            $desc2 = $db->Record['desc2'];
            $desc3 = $db->Record['desc3'];
            $desc4 = $db->Record['desc4'];
            $desc5 = $db->Record['desc5'];
            $desc6 = $db->Record['desc6'];
            $desc7 = $db->Record['desc7'];
            $estado_venta = $db->Record['estado_venta'];
             
            
            $update = "UPDATE OIBT SET U_desc1 = $desc1,U_desc2 = $desc2,U_desc3 = $desc3,U_desc4 = $desc4,U_desc5 = $desc5,U_desc6 = $desc6,U_desc7 = $desc7,"
                    . "U_estado_venta = '$estado_venta'  WHERE ItemCode = '$codigo' AND BatchNum = '$lote'";
             
            $ms->Query($update);
            $db2->Query("update hist_precios set e_sap = 1 where id_hist = $id;");
            
        }
        $db2->Close(); 
        $db->Close(); 
        $ms->Close(); 
        echo "Ok";
    } else {
        echo "Fin";
    }
}

function iniciar() {
    echo '<html>
    <head>
        <script type="text/javascript" src="../js/jquery-2.1.3.min.js?_=213216565" ></script> 
        <script>
            function start(){
                $.ajax({
                type: "POST",
                url: "CambioPreciosPorLotes.class.php",
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
                                        setTimeout("start()",6000);
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

new CambioPreciosPorLotes();
?>



