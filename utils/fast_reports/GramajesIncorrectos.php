

<?php
/**
 * Description of PreciosXLotes
 * @author Ing.Douglas
 * @date 03/06/2019
 */
set_time_limit(0);

require_once ("../../Y_DB_MySQL.class.php");
require_once ("../../Y_DB_MSSQL.class.php");

class Gramajes {

    function __construct() {
        $action = $_REQUEST['action'];

        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }
    }

    function main() {
        filtros();
    }

}

function filtros() {
    ?>
    <html>
        <meta charset="utf-8">
        <head>
            <link rel='stylesheet' type='text/css'  href='../../css/reportes.css'  >
            <link rel='stylesheet' type='text/css'  href='../../js/jquery-ui/jquery-ui.css'  >
            <script lang="javascript" src="../../js/jquery-2.1.3.min.js"></script>
            <script lang="javascript" src="../../js/functions.js"></script>
            <script lang="javascript" src="../../js/jquery-ui/jquery-ui.min.js"></script>
            <script>
                
                var articulos = new Array();
                $(function () {
                    configurar();

                    setTimeout("start()", 1000);
                });

                function configurar(){
                    $(".BatchNum").click(function () {
                        var lote = $.trim($(this).text());
                        var url = "../../productos/HistorialMovimiento.class.php?lote=" + lote + "&suc=00";
                        var title = "Historial de Movimiento de Lote";
                        var params = "width=980,height=480,scrollbars=yes,menubar=yes,alwaysRaised = yes,modal=yes,location=no";
                        ventana = window.open(url, title, params);
                    });
                    
                    $("#buscar").click(function(){
                        getCantLotes();
                    });
                    
                    $("#codigo").change(function(){
                       var codigo = $(this).val();
                       if(codigo !== ""){
                           buscarArticulos(codigo);
                       }
                    }); 
                    
                    $(".BatchNum").hover(function () {
                        var img = $(this).parent().attr("data-img");
                        if(img !== ""){
                            var image_path = "http://192.168.2.252/prod_images";
                            var image_url = image_path + "/" + img + ".thum.jpg";
                            $("#image_container").html("<img src='" + image_url + "' width='140px' alt=''>");
                            $("#image_container").fadeIn();


                            var w = $(this).parent().width();
                            var pos = $(this).parent().position();
                            var left = pos.left;
                            var top = pos.top;
                            var izq = (left + w) - $("#image_container").width();
                            $("#image_container").css({ top: top, left: izq });
                        }else{
                            $("#image_container").fadeOut();
                        }
                    });   
                } 
                
                function getCantLotes(){
                   var minimo = $("#minimo").val();
                   var codigo = $("#codigo").val();
                   var nombre = $("#nombre").val();
                     
                    $.ajax({
                        type: "POST",
                        url: "GramajesIncorrectos.php",
                        data: {action: "getCantLotes",minimo:minimo,codigo:codigo,nombre:nombre},
                        async: true,
                        dataType: "json",
                        beforeSend: function () {
                            $("#msg").html("<img class='search' src='../../img/loading_fast.gif' width='16px' height='16px' >"); 
                        },
                        success: function (data) {   
                            $("#msg").html("");
                            $("#buscar").val(data.lotes);
                        }
                    });                 
                }
               
                var i = 0;
               
                
                function start() {
 
                    if($(".BatchNum").length > 0){
                        var BaseNum = $("#tr_" + i).attr("data-base_num");
                        var BaseType = $("#tr_" + i).attr("data-base_type");

                        var lote = $(".lote_" + i).text();
                        var padre = $(".padre_" + i).text();
                        var gramaje = $(".gramaje_" + i).text().replace(",",".");
                        var porc = $("#porc").val();
                        var img = $("#tr_" + i).attr("data-img");
                        //console.log(img);
                        if(img === ""){
                           img = "0/0";
                        }
                        if(lote !== ""){
                        $.ajax({
                            type: "POST",
                            url: "GramajesIncorrectos.php",
                            data: {"action": "getHermanos", BaseNum: BaseNum, BaseType: BaseType, lote: lote, padre: padre, gramaje: gramaje, porc: porc, img: img},
                            async: true,
                            dataType: "json",
                            beforeSend: function () {
                                $("#msg_" + i).html("<img src='../../img/loading_fast.gif' width='16px' height='16px' > analizando...");
                            },
                            success: function (data) {
                                //dat = data;
                                console.log(i);
                                if(data.length > 0){
                                    for (var j in data) {
                                        var tipo = data[j].Tipo;
                                        var BatchNum = data[j].BatchNum;
                                        var U_padre = data[j].U_padre;
                                        var U_gramaje = parseFloat(data[j].U_gramaje).format(2, 3, '.', ',') ; 
                                        var U_gramaje_m= parseFloat(data[j].U_gramaje_m).format(2, 3, '.', ',') ; 
                                        var U_kg_desc  = parseFloat(data[j].U_kg_desc).format(2, 3, '.', ',') ; 
                                        var U_tara  = parseFloat(data[j].U_tara).format(2, 3, '.', ',') ;
                                        var U_ancho = parseFloat(data[j].U_ancho).format(2, 3, '.', ',') ;
                                        var U_quty_ticket = parseFloat(data[j].U_quty_ticket).format(2, 3, '.', ',') ;
                                        var U_equiv = parseFloat(data[j].U_equiv).format(2, 3, '.', ',');
                                        var U_cant_inicial   = parseFloat(data[j].U_cant_inicial).format(2, 3, '.', ',');
                                        var Quantity  = parseFloat(data[j].Quantity).format(2, 3, '.', ',');
                                        var cant_calc = parseFloat(data[j].cant_calc).format(2, 3, '.', ',');
                                        var U_ubic = data[j].U_ubic;
                                        var U_img = data[j].U_img;
                                        
                                        $("#tr_" + i).after("<tr data-img='"+U_img+"'><td></td><td class='item "+tipo+"'>"+tipo+"</td><td class='item BatchNum'>"+BatchNum+"</td><td  class='item'>"+U_padre+"</td>\n\
                                        <td class='num'>"+U_gramaje+"</td><td class='num'>"+U_gramaje_m+"</td><td class='num'>"+U_kg_desc+"</td>\n\
                                        <td class='num'>"+U_ancho+"</td>\n\
                                        <td class='num'>"+U_tara+"</td>\n\
                                        <td class='num'>"+U_quty_ticket+"</td>\n\
                                        <td class='num'>"+U_equiv+"</td>\n\
                                        <td class='num'>"+Quantity+"</td>\n\
                                        <td class='num'>"+cant_calc+"</td>\n\
                                        <td class='num'>"+U_ubic+"</td></tr>"); 
                                    } 
                                    $("#msg_" + i).html("<img src='../../img/warning_red_16.png' width='16px' height='16px' title='Inconsistencias' >");
                                }else{
                                   $("#msg_" + i).html("<img src='../../img/ok.png' width='16px' height='16px' >");
                                  setTimeout("eliminar("+i+")",5000);
                                }

                                i++;                                   
                                setTimeout("start()", 50);

                            }
                        });
                    
                     }else{
                       configurar();
                     }
                     
                     }else{
                        configurar();
                     }
                } 
                  
                function eliminar(i){
                    $("#tr_" + i).slideUp();
                    setTimeout(function(){
                       $("#tr_" + i).remove();  
                    },2000);
                     
                }
                
                function  buscarArticulos(codigo){
                    $.ajax({
                        type: "POST",
                        url: "GramajesIncorrectos.php",
                         data: {"action": "getNombresArticulos", codigo: codigo},
                        async: true,
                        dataType: "json",
                        beforeSend: function () { 
                            articulos.splice(0,articulos.length);
                            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
                        },
                        success: function (data) {                        
                            if(data.length > 0){
                                for(var i in data){
                                    var art = data[i].Articulo;
                                    articulos.push(art);
                                    console.log(art);
                                } 
                                $("#nombre").autocomplete({source:articulos});
                            }
                            $("#msg").html(""); 
                        }
                    }); 
                }

            </script>    
            <style>
                .BatchNum:hover{
                    font-weight: bolder;
                    cursor: pointer;
                }
                .Similar{
                    color: black;
                    font-weight: bolder;
                }
                .Hermano{
                    color: green;
                    font-weight: bolder; 
                }
                .image_container{
                    position: absolute;
                    width: 140px;    
                    z-index: 10;
                    border: solid gray 1px;
                    text-align: center;
                }
                #buscar:hover{
                    background: orange;
                    cursor: pointer
                }
            </style>
        </head>
        <body> 
            <div id="image_container" class="image_container"  style="display: none"></div>
            <?php
            $minimo = isset($_REQUEST['minimo']) ? $_REQUEST['minimo'] : 5;
            $codigo = isset($_REQUEST['codigo']) ? $_REQUEST['codigo'] : "B";
            $nombre = isset($_REQUEST['nombre']) ? $_REQUEST['nombre'] : "";
            $porc = isset($_REQUEST['porc']) ? $_REQUEST['porc'] : 5;
            $buscar = isset($_REQUEST['buscar']) ? $_REQUEST['buscar'] : 50;

            echo '<form method="post" action="GramajesIncorrectos.php">
                        <input type="hidden" name="action" value="listar">
                        <label>Metraje > a:</label><input type="number" value="' . $minimo . '" min="0" max="100" id="minimo" name="minimo" size="3" >  
                        <label>% Desviacion Gramaje:</label><input type="number" value="' . $porc . '" min="0" max="100" id="porc" name="porc" size="3" >  
                        <label>Codigo:</label><input class="buscar" type="text" value="' . $codigo . '"  id="codigo"  name="codigo" size="8" >             
                        <label>Nombre Articulo:</label><input  class="buscar" type="text" value="' . $nombre . '" id="nombre" name="nombre" size="30" >    
                        <label>Buscar:</label><input type="text" id="buscar" value="' . $buscar . '"  name="buscar" size="4" >    
                        <input type="submit" value="Generar">
                        <span id="msg"></span>
                    </form>';
        }

        function listar() {
            filtros();
            $db = new My();
            $ms = new MS();

            $minimo = $_REQUEST['minimo'];
            $codigo = $_REQUEST['codigo'];
            $nombre = $_REQUEST['nombre'];
            $porc = $_REQUEST['porc'];
            $buscar = $_REQUEST['buscar'];

            $master = array();

            $fecha = date("d-m-Y H:i");

            echo "<div style='margin:10 auto;font-size:20px;width:100%;text-align:center;font-weight:bolder'>Lista de Lotes con Gramajes Fuera de Rango:  $fecha</div>";

            echo "<table border='1' style='border-collapse:collapse'>";

            echo "<tr><th>Codigo</th><th>Articulo</th><th>Lote</th><th>Padre</th><th>Gramaje</th><th>Gramaje_m</th><th>KG Desc</th><th>Ancho</th><th>Tara</th><th>Quty Ticket</th><th>Equiv</th><th>Stock</th><th>Cant.Calc.</th><th>Ubic</th><th style='width:120px'>*</th></tr>";


            $batches = "SELECT TOP $buscar BaseNum,BaseType,ItemCode, BatchNum,U_padre,ItemName,Quantity,U_gramaje,U_gramaje_m,U_kg_desc,U_tara,U_ancho,U_ubic,U_quty_ticket,U_equiv,U_cant_inicial, U_notas,U_img "
                    . "FROM oibt o WHERE  ItemCode NOT LIKE 'IN%' AND  ItemCode NOT LIKE 'AC%' AND U_fin_pieza != 'Si' AND Quantity > $minimo AND WhsCode = '00'  AND U_notas NOT like 'Migrado%'  and ItemCode like '$codigo%' and ItemName like '%$nombre%' ";

            $i = 0;

            $ms->Query($batches);
            while ($ms->NextRecord()) {
                $BaseNum = $ms->Record['BaseNum'];
                $BaseType = $ms->Record['BaseType'];

                $ItemCode = $ms->Record['ItemCode'];
                $BatchNum = $ms->Record['BatchNum'];
                $ItemName = $ms->Record['ItemName'];
                $U_padre = $ms->Record['U_padre'];
                $U_img = $ms->Record['U_img'];
                $Quantity = number_format($ms->Record['Quantity'], 2, ',', '.');

                $Ancho = $ms->Record['U_ancho'];
                $U_ancho = number_format($Ancho, 2, ',', '.');
                $Gramaje = $ms->Record['U_gramaje'];
                $U_gramaje = number_format($Gramaje, 2, ',', '.');

                $U_gramaje_m = number_format($ms->Record['U_gramaje_m'], 2, ',', '.');
                $kg_desc = $ms->Record['U_kg_desc'];
                $U_kg_desc = number_format($kg_desc, 2, ',', '.');
                $Tara = $ms->Record['U_tara'];
                $U_tara = number_format($Tara, 2, ',', '.');
                $U_quty_ticket = number_format($ms->Record['U_quty_ticket'], 2, ',', '.');
                $U_equiv = number_format($ms->Record['U_equiv'], 2, ',', '.');
                $U_cant_inicial = number_format($ms->Record['U_cant_inicial'], 2, ',', '.');
                //$U_notas = $ms->Record['U_notas'];
                $U_ubic = $ms->Record['U_ubic'];

                $cant_calc_actual = number_format(cantCalc($kg_desc, $Tara, $Gramaje, $Ancho), 2, ',', '.');

                echo "<tr id='tr_$i' data-img='$U_img' data-base_num='$BaseNum'  data-base_type='$BaseType'><td class='item'>$ItemCode</td><td class='item'>$ItemName</td><td class='item BatchNum lote_$i'>$BatchNum</td><td class='item padre_$i'>$U_padre</td><td class='num gramaje_$i'>$U_gramaje</td><td class='num'>$U_gramaje_m</td><td class='num'>$U_kg_desc</td><td class='num'>$U_ancho</td> <td class='num'>$U_tara</td><td class='num'>$U_quty_ticket</td><td class='num'>$U_equiv</td> <td class='num'>$Quantity</td><td class='num'>$cant_calc_actual</td><td class='itemc'>$U_ubic</td><td id='msg_$i'></td> </tr>";

                $i++;
                
            }
            echo "</table></body></html>";
            //print_r($this->master);
            $ms->Close();
        }

        function getHermanos() {

            $BaseNum = $_REQUEST['BaseNum'];
            $BaseType = $_REQUEST['BaseType'];
            $lote = $_REQUEST['lote'];
            $padre = $_REQUEST['padre'];
            $gramaje = $_REQUEST['gramaje'];
            $porc = $_REQUEST['porc'];
            $U_img = $_REQUEST['img'];

            //echo "Lote $lote";
 
            
            if(strlen($padre) > 2  ){
                $batches = "SELECT 'Hermano' as Tipo, ItemCode, BatchNum,U_padre,ItemName,Quantity,U_gramaje,U_gramaje_m,U_kg_desc,U_tara,U_ancho,U_ubic,U_quty_ticket,U_equiv,U_cant_inicial, U_notas,U_img "
                . "FROM oibt o WHERE  U_fin_pieza != 'Si' AND Quantity > 0 AND WhsCode = '00'  AND U_notas NOT like 'Migrado%' and BatchNum != '$lote' and U_padre = '$padre'  ";
              
                execute($batches,$gramaje,$porc);
                
            }else if(strlen($padre) < 3   ){ // Rollos con Imagen
                if(strlen( $U_img ) > 4){
                   $batches = "SELECT 'Similar' as Tipo, ItemCode, BatchNum,U_padre,ItemName,Quantity,U_gramaje,U_gramaje_m,U_kg_desc,U_tara,U_ancho,U_ubic,U_quty_ticket,U_equiv,U_cant_inicial, U_notas,U_img "
                   . "FROM oibt o WHERE  U_fin_pieza != 'Si' AND Quantity > 0 AND WhsCode = '00'  AND U_notas NOT like 'Migrado%' and  BatchNum != '$lote' and U_img = '$U_img' and BaseNum =  $BaseNum  and BaseType =  $BaseType    ";                 
                  execute($batches,$gramaje,$porc);
                }else{
                    echo json_encode(array());
                }
            } 
            
        }
 
        function execute($batches,$gramaje,$porc){
            $hermanos = array();
            $ms2 = new MS();
            $ms2->Query($batches);
            if ($ms2->NumRows() > 0 ) {
                while ($ms2->NextRecord()) {
                    $rec = $ms2->Record;

                    $ItemCode = $ms2->Record['ItemCode'];
                    $BatchNum = $ms2->Record['BatchNum'];
                    $ItemName = $ms2->Record['ItemName'];
                    $U_padre = $ms2->Record['U_padre'];
                    $Quantity = $ms2->Record['Quantity'];

                    $U_gramaje = $ms2->Record['U_gramaje'];
                    $U_gramaje_m = $ms2->Record['U_gramaje_m'];
                    
                    

                    $rango_bajo = $gramaje - (($gramaje * $porc) / 100);
                    $rango_alto = $gramaje + (($gramaje * $porc) / 100);

                    

                    if ($U_gramaje < $rango_bajo || $U_gramaje > $rango_alto) {
                        $U_ancho = $ms2->Record['U_ancho'];
                        $U_kg_desc = $ms2->Record['U_kg_desc'];
                        $U_tara = $ms2->Record['U_tara'];
                        
                        $cant_calc_actual_h = number_format(cantCalc($U_kg_desc, $U_tara, $U_gramaje,$U_ancho), 2, ',', '.');
                        $rec['cant_calc'] = $cant_calc_actual_h;
                        array_push($hermanos, $rec);
                    } else {
                        // echo " $BatchNum in Range    $rango_bajo > $U_gramaje < $rango_alto<br>";
                    }

                    //array_push($master, $BatchNum);
                }
                $ms2->Close();
                echo json_encode($hermanos);
            } else {                 
                echo json_encode($hermanos);
            }
        }

        function cantCalc($kg, $tara, $gr, $ancho) {
            return (($kg - ($tara / 1000)) * 1000) / ($gr * $ancho);
        }
        
        function getCantLotes(){
            $minimo = $_REQUEST['minimo'];
            $codigo = $_REQUEST['codigo'];
            $nombre = $_REQUEST['nombre'];
            $ms = new MS();
            $sql = "SELECT  count(*) as lotes FROM oibt o WHERE  ItemCode NOT LIKE 'IN%' AND  ItemCode NOT LIKE 'AC%' AND U_fin_pieza != 'Si' AND Quantity > $minimo AND WhsCode = '00'  AND U_notas NOT like 'Migrado%'  and ItemCode like '$codigo%' and ItemName like '%$nombre%'"; 
            $ms->Query($sql);
            
            $lotes = 0;
            
            if($ms->NumRows()>0){
               $ms->NextRecord();
               $lotes = $ms->Record['lotes'];               
            }
        
            echo json_encode(array("lotes"=>$lotes));
        }
        
        function getNombresArticulos(){
             
            $codigo = $_REQUEST['codigo'];
             
            $ms = new MS();
            $sql = "SELECT DISTINCT U_nombre_com as Articulo  FROM OITM WHERE ItemCode LIKE '$codigo%'  AND U_nombre_com IS NOT NULL ORDER BY U_nombre_com ASC"; 
            $ms->Query($sql);
             
            $articulos = array();
            
            if($ms->NumRows()>0){
               while($ms->NextRecord()){                  
                  array_push($articulos, $ms->Record);
               }
            }
        
            echo json_encode($articulos);
        }

        new Gramajes();
        ?>