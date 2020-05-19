


<?php
/**
 * Description of RedondeoPrecios
 * @author Ing.Douglas
 * @date 13/04/2018
 */
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_DB_MSSQL.class.php");

class RedondeoPrecios {

    function __construct() {

        //echo getcwd();
        $action = $_REQUEST['action'];

        if (!isset($_REQUEST['action'])) {
            $this->listarCodigos();
        } else if ($action == "getLotes") {
            $this->listarLotes();
        } else if ($action == "actualizar") {

            $codigo = $_REQUEST['codigo'];
            $lote = $_REQUEST['lote'];
            $ms = new MS();
            $ms_update = new MS();

            // echo '<table border="1" style="border-collpase:collapse;font-size:11px;border:solid gray 1px" cellpadding="0" cellspacing="0" >'; 
            // echo "<tr><td>LP</td><td>Lote</td> <td>Descrip</td>  <td>Precio</td>    <td>Descuento</td>   <td>PrecioFinal</td>   <td>Resto</td><td>NuevoPrecio</td><td>NuevoDescuento</td><td>Prueba</td><td>PruebaFinal</td></tr>";

            $ms->Query("select   BatchNum,o.ItemCode,o.ItemName,o.WhsCode as Suc, Price,PriceList,U_desc1,U_desc2,U_desc3,U_desc4,U_desc5,U_desc6,U_desc7,U_estado_venta from  OIBT o, ITM1 i where Quantity > 0 and o.ItemCode = i.ItemCode and o.ItemCode not like 'A%' and PriceList < 8 and o.ItemCode = '$codigo' and BatchNum = '$lote' order by o.ItemCode asc");

            $suma_actual = 0;
            $suma_calc = 0;

            while ($ms->NextRecord()) {
                $ItemCode = $ms->Record['ItemCode'];
                $BatchNum = $ms->Record['BatchNum'];
                $ItemName = $ms->Record['ItemName'];
                $estado_venta = $ms->Record['U_estado_venta'];
                $Suc = $ms->Record['Suc'];
                $Price = $ms->Record['Price'];
                $i = $ms->Record['PriceList'];
                $Descuento = $ms->Record["U_desc$i"];

                $PrecioActual = round($Price - (($Price * $Descuento) / 100));
                ${"p" . $i} =  $Price;
                $Resto = $PrecioActual % 50;

                $suma_actual + 0 + $PrecioActual;

                $PriceF = number_format($Price, 2, ',', '.');
                $PrecioF = number_format($PrecioActual, 2, ',', '.');
                $np = $this->redondeo50($PrecioActual);
                 
                //echo $np."<br>";
                
                $NuevoPrecio = number_format($np, 2, ',', '.');

                $NuevoDesc = round(100 - ($np * 100) / $Price,6);
                
                //echo $NuevoDesc." php. <br>";
                
                $d  = new My();
                $d->Query("SELECT 100 -(($np * 100) / $Price) as calc_desc");
                $d->NextRecord();
                $calc = $d->Record['calc_desc'];
                //echo $calc." MySQL <br>";                
                //die();
                
                ${"desc" . $i} = $NuevoDesc;

                $Prueba = $Price - (($Price * $NuevoDesc) / 100);
                
                
                $PrecioFinal = round($Prueba);
                
                
                
                $suma_calc += 0 + $PrecioFinal;

                ${"pf" . $i} = $PrecioFinal;

                //echo "<tr><td>$i</td> <td>$BatchNum</td> <td>$ItemName</td>  <td>$PriceF</td>  <td>$Descuento</td>   <td>$PrecioF</td>   <td>$Resto</td> <td>$NuevoPrecio</td><td>$NuevoDesc</td><td>$Prueba</td><td>$PrecioFinal</td></tr>"; 
                if ($i == 7) {
                    if ($suma_actual != $suma_calc) {
                        $db = new My();
                        $db->Query("SELECT COUNT(*) AS CANT FROM hist_precios WHERE usuario = 'Sistema' AND codigo = '$ItemCode' AND lote = '$BatchNum'");
                        $db->NextRecord();
                        $cant = $db->Record['CANT'];
                        if ($cant == 0) {
                            $update = "UPDATE OIBT SET U_desc1 = $desc1,U_desc2 = $desc2,U_desc3 = $desc3,U_desc4 = $desc4,U_desc5 = $desc5,U_desc6 = $desc6,U_desc7 = $desc7  WHERE ItemCode = '$ItemCode' AND BatchNum = '$BatchNum'";
                            $ms_update->Query($update);    
                            $sql = "INSERT INTO hist_precios( usuario, estado_venta, fecha, hora, codigo, lote, suc, p1, p2, p3, p4, p5, p6, p7, desc1, desc2, desc3, desc4, desc5, desc6, desc7, pf1, pf2, pf3, pf4, pf5, pf6, pf7, fecha_impresion, cant_impresiones)
                                    VALUES ( 'Sistema', '$estado_venta', 'fecha', 'hora', '$ItemCode', '$BatchNum', '$Suc', $p1, $p2, $p3, $p4, $p5, $p6, $p7, $desc1, $desc2, $desc3, $desc4, $desc5, $desc6, $desc7, $pf1, $pf2, $pf3, $pf4, $pf5, $pf6, $pf7,'',0);";
                            //echo "<tr><td colspan='10'>$sql</td></tr>";
                            
                            $db->Query($sql);
                            echo "Ok";
                        }else{
                            echo "Ya";
                        }                        
                    }else{
                        echo "==";
                    }
                    $suma_actual = 0;
                    $suma_calc = 0;
                }
            }
            //echo "</table>";
        }
    }

    function listarCodigos() {
        ?>
        <html>
            <head>    
                <script type="text/javascript" src="../js/jquery-2.1.3.min.js" ></script>
                <script>
                    var lotes = new Array();
                    var current_id = 0;
                    function getLotes(codigo) {
                        $.ajax({
                            type: "POST",
                            url: "RedondeoPrecios.php",
                            data: {"action": "getLotes", codigo: codigo},
                            async: true,
                            dataType: "json",
                            beforeSend: function () {
                                $("#img_" + codigo).attr("src", "../img/TxRx500.gif");
                                $("#td_" + codigo).html("Cargando lotes esto podria tardar unos minutos...");
                                lotes.splice(0, lotes.length);
                            },
                            success: function (data) {
                                var t = "<table  style='font-size:10px border='1' width='100%'><tr><td>";
                                for (var i in data) {
                                    var lote = data[i].lote;
                                    lotes.push(lote);
                                    t += "<span style='font-size:10px'>" + lote + "</span> <span id='msg_" + lote + "'> </span>&nbsp;";
                                }
                                t += "</td></tr><table width='100%'>";
                                $("#td_" + codigo).append(t);
                                $("#img_" + codigo).attr("src", "../img/ok.png");
                                procesarLotes(0);
                            }
                        });
                    }
                    function iniciar() {
                        current_id = $("#ini").val();
                        var codigo = $("#td_" + current_id).parent().find(".codigo").text();
                        getLotes(codigo);
                    }
                    function procesarLotes(i) {
                        var tam = lotes.length;
                        var codigo = $("#td_" + current_id).parent().find(".codigo").text();
                        if (i < tam) {
                            var lote = lotes[i];
                            $.ajax({
                                type: "POST",
                                url: "RedondeoPrecios.php",
                                data: {"action": "actualizar", "codigo": codigo, "lote": lote},
                                async: true,
                                dataType: "html",
                                beforeSend: function () {
                                    $("#msg_" + lote).html("<img src='../img/loading_fast.gif' width='16px' height='16px' >");
                                },
                                complete: function (objeto, exito) {
                                    if (exito == "success") {
                                        var result = $.trim(objeto.responseText);
                                        if (result == "Ok") {
                                            $("#msg_" + lote).html("<img src='../img/ok.png' width='16px' height='16px' >");                                                                                     
                                        }else if (result == "Ya") {
                                            $("#msg_" + lote).html("<img src='../img/l_arrow.png' width='16px' height='12px' >");
                                        }else if (result == "==") {
                                            $("#msg_" + lote).html("<img src='../img/money.png' width='16px' height='16px' >");
                                        }
                                        i++;   
                                        procesarLotes(i);
                                    }
                                },
                                error: function () {
                                    $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
                                }
                            });
                        } else {
                            var codigo_ant = $("#td_"+current_id).parent().find(".codigo").text();
                            $("#td_"+codigo_ant).html("Completo...");
                            current_id++;
                            var codigo = $("#td_" + current_id).parent().find(".codigo").text();
                            getLotes(codigo);
                        }
                    }
                </script>
            </head>
            <body>
                <div style="text-align: center">
                    <input type="text" value="" id="ini">
                    <input type="button" value="Iniciar -->" onclick="iniciar()">
                </div>
            </body>
        </html>
        <?php
        $ms = new MS();
        $ms->Query("select top 100 o.ItemCode,count(*) / 7 as Cant from  OIBT o, ITM1 i where Quantity > 0 and o.ItemCode = i.ItemCode  and PriceList < 8   group by o.ItemCode order by count(*) desc ");
        echo '<table border="1" style="border-collpase:collapse;font-size:11px;border:solid gray 1px" cellpadding="0" cellspacing="0" >';
        echo "<tr><td>ID</td><td>Codigo</td><td>Cant</td>   <td>*</td> <td>Lotes</td> </tr>";
        $i = 0;
        while ($ms->NextRecord()) {
            $ItemCode = $ms->Record['ItemCode'];
            $Cant = $ms->Record['Cant'];
            echo "<tr><td id='td_$i'>$i</td><td class='codigo'>$ItemCode</td> <td>$Cant</td> <td> <img id='img_$ItemCode' src='../img/icon-arrow-right-b-32.png' width='16px' onclick=getLotes('$ItemCode')>  </td> </tr>";
            echo "<tr><td colspan='4' > </td> <td style='width:100%' id='td_$ItemCode'  >  </td> </tr>";
            $i++;
        }
        echo "</table>";
    }

    function listarLotes() {
        set_time_limit(0);
        $codigo = $_REQUEST['codigo'];
        $ms = new MS();
        $ms->Query("select distinct BatchNum as Lote from OIBT o where Quantity > 0 and ItemCode  = '$codigo' ");
        $arr = array();
        while ($ms->NextRecord()) {
            array_push($arr, array("lote" => $ms->Record['Lote']));
        }
        echo json_encode($arr);
    }

    function redondeo50($valor) {
        $resto = $valor % 50;
        //echo " valor $valor  Resto ".$resto."<br>";
        $valor_redondear = 0;
        if ($resto >= 49) {
            $valor_redondear = 50 - $resto;
        } else {
            $valor_redondear = $resto * -1;
        }
        
        //echo " valor_redondear ".$valor_redondear."<br>";
        
        $valor_redondeado = $valor + $valor_redondear;
        return $valor_redondeado;
    }

}

new RedondeoPrecios();
?>

        
        
        
        