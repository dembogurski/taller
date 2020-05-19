<?php

/**
 * Description of SolicitudesTraslado
 * @author Ing.Douglas
 * @date 16/12/2015
 */
require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_DB_MSSQL.class.php");
require_once("../Config.class.php");

class SolicitudesTraslado {

    function __construct() {
        $action = $_REQUEST['action'];
        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }
    }

    function main() {
        $usuario = $_POST['usuario'];
        $suc_ = $_REQUEST['suc'];
        $mobile = $_REQUEST['mobile'];
        $tipo_filtro = $_REQUEST['tipo_filtro'];  
        
        $filtro_tipo = " AND d.codigo  NOT  LIKE 'IN%' ";
        if($tipo_filtro == "insumos"){
            $filtro_tipo = " AND d.codigo  LIKE 'IN%' ";
        }
 
        $t = new Y_Template("SolicitudesTraslado.html");
        $t->Show("header");
        $t->Set("destino", $suc_);


        $hoy = date("d-m-Y");
        $fecha_nota_antigua = date("d-m-Y");
        $date = new DateTime('-5 day');
        $fecha_ini = $date->format('d-m-Y');
        $t->Set("hoy", $hoy);
 
        
        // Sucursales
        $my = new My();


        $sql = "SELECT suc,nombre FROM sucursales WHERE tipo != 'Sub-Deposito' order by  suc asc";
        $my->Query($sql);


        while ($my->NextRecord()) {
            $suc = $my->Record['suc'];
            $nombre = $my->Record['nombre'];
            $sucs.="<option value=" . $suc . ">" . $suc . " - " . $nombre . "</option>";
        }
        $t->Set("sucurs", $sucs);



        $sql = "SELECT s.suc,nombre,count(d.id_det) as Items, DATE_FORMAT(fecha_cierre,'%d-%m-%Y') AS fecha,DATE_FORMAT(fecha_cierre,'%d/%m') AS fechacorta, "
                . "SUM(  IF(   (REPLACE(SUBSTRING(ubic,3,2),'-','') < 4) AND (REPLACE(SUBSTRING(ubic,3,2),'-','') <> '')  ,1,0))  AS Hombre, SUM(IF(REPLACE(SUBSTRING(ubic,3,2),'-', '') > 3,1,0)) AS Picker, SUM(IF(d.ubic IS NULL, 1,0)) AS Indef  "
                . "FROM sucursales s,pedido_traslado p, pedido_tras_det d where p.n_nro = d.n_nro and  s.suc = p.suc and   p.suc_d = '$suc_' and d.estado = 'Pendiente' and p.estado = 'Pendiente' $filtro_tipo GROUP BY s.suc order by  s.suc asc ";
        $my->Query($sql);
        $sucs = "";
        while ($my->NextRecord()) {
            $suc = $my->Record['suc'];
            $nombre = $my->Record['nombre'];
            $items = $my->Record['Items'];
            $fecha = $my->Record['fecha'];
            $fechacorta = $my->Record['fechacorta'];
            $Hombre = $my->Record['Hombre'];
            $Picker = $my->Record['Picker'];
            $Indef = $my->Record['Indef'];


            $nom = 'Item';
            if ($items > 1) {
                $nom = 'Items';
            }
            if (strtotime($fecha) < strtotime($fecha_nota_antigua)) {
                $fecha_nota_antigua = $fecha;
                $fecha_ini = $fecha;
            }

            if ($mobile != "true") {
                $sucs.="<option value=" . $suc . ">" . $suc . "&nbsp;- $nombre &nbsp;&nbsp;   $items $nom  &nbsp;&nbsp;  [$fecha]</option>";
            } else {
                $sucs.="<option value=" . $suc . " style='letter-spacing:2;text-align: center'> $suc.&nbsp;-&nbsp;[$fechacorta]&nbsp; $Hombre | $Picker | $Indef</option>";
            }
        }
        $t->Set("fecha_ini", $fecha_ini);
        $t->Set("sucursales", $sucs);

        if ($mobile != "true") {
            $t->Show("body");
        } else {
            $c = new Config();
            $host = $c->getNasHost();
            $path = $c->getNasFolder();
            $images_url = "http://$host/$path";
            $t->Set("images_url", $images_url);
            $t->Show("mobile");
        }
    } 
}

function getPedidosFiltrados(){
    $destino = $_POST['destino'];
    $nivel = $_POST['nivel']; 
    $desde =$_POST['desde'];
    $hasta =$_POST['hasta'];
    $tipo_busqueda = $_POST['tipo_busqueda'];
    
    $filtro_tipo = "AND d.codigo NOT LIKE 'IN%'";  // tejidos o insumos
    
    if($tipo_busqueda == "insumos"){
        $filtro_tipo = "AND d.codigo LIKE 'IN%'";
    }
    
    $fila = " > 3";

    if ($nivel == "Hombre") {
        $fila = " REPLACE(SUBSTRING(ubic,3,2),'-','') < 4  AND ubic <> ''  ";
    } else if ($nivel == "Picker") {
       $fila = " REPLACE(SUBSTRING(ubic,3,2),'-','') > 3 ";
    } else {
        $fila = " (d.ubic = '' or d.ubic is null ) ";
    }
      
    $sql = "SELECT s.suc,nombre,COUNT(d.id_det) AS Items, DATE_FORMAT(fecha_cierre,'%d-%m-%Y') AS fecha 
  
                FROM sucursales s,pedido_traslado p, pedido_tras_det d WHERE p.n_nro = d.n_nro AND  s.suc = p.suc AND   p.suc_d = '$destino' AND d.estado = 'Pendiente' AND p.estado = 'Pendiente' 
                AND $fila  AND p.fecha_cierre BETWEEN '$desde' AND '$hasta'  $filtro_tipo
                GROUP BY s.suc ORDER BY  s.suc ASC ";
    
    
    
    echo json_encode(getResultArray($sql));
}

function getPedidos() {
    $origen = $_POST['origen'];
    $destino = $_POST['destino'];
    $estado = $_POST['estado'];
    $desde = $_POST['desde'];
    $hasta = $_POST['hasta'];
    $hora = $_POST['hora'];
    $mayorista = $_POST['mayorista'];
    $urge = $_POST['urge'];
    $nivel = $_POST['nivel'];
    $estado = $_POST['estado'];

    $fila = " > 3";

    if ($nivel == "Hombre") {
        $fila = " < 4 ";
    } else if ($nivel == "Picker") {
        $fila = " > 3 ";
    } else {
        $fila = "Sin Ubic";
    }
    $db2 = new My();

    $sqla = "SELECT   p.n_nro AS nro, codigo,lote,suc_d  FROM pedido_traslado p INNER JOIN pedido_tras_det d ON p.n_nro = d.n_nro AND  p.estado != 'Abierta' AND 
    d.estado LIKE '$estado' AND  fecha_cierre BETWEEN '$desde' AND '$hasta' AND hora_cierre < '$hora' and mayorista LIKE '$mayorista' AND urge LIKE '$urge' AND p.suc = '$origen' AND p.suc_d = '$destino' 
    and   REPLACE(SUBSTRING(ubic,3,2),'-', '') and ubic is null";

    $db2->Query($sqla);

    while ($db2->NextRecord()) {
        $codigo = $db2->Record['codigo'];
        $lote = $db2->Record['lote'];
        $suc_d = $db2->Record['suc_d'];
        $ub = "select CONCAT(U_nombre,'-',U_fila,'-',U_col) as U_ubic, CONCAT(U_nombre,U_col) as Nodo  from [@REG_UBIC] where  U_codigo = '$codigo' and U_lote = '$lote' and U_suc = '$destino'";
        $ms = new MS();
        
        $ms->Query($ub);
        if ($ms->NumRows() > 0) {
            $ms->NextRecord();
            $ubic = $ms->Record['U_ubic'];
            $nodo = $ms->Record['Nodo'];
            $dba->Query("update pedido_tras_det set ubic = '$ubic',nodo = '$nodo' where n_nro = $pedido_numero and codigo = '$codigo' and lote = '$lote' ");
        } else {
            $ms->Query("select U_ubic   from oibt where  ItemCode = '$codigo' and  BatchNum = '$lote' and WhsCode = '$destino'");
            if ($ms->NumRows() > 0) {
                $ms->NextRecord();
                $ubic = $ms->Record['U_ubic'];
                $a = explode("-", $ubic);
                $estante = $a[0];
                $col = $a[2];
                $nodo = $estante . $col;
                $dba->Query("update pedido_tras_det set ubic = '$ubic',nodo = '$nodo' where n_nro = $pedido_numero and codigo = '$codigo' and lote = '$lote' ");
            }
        }
    }




    $sql = "SELECT '' as id, d.nodo,IF(prioridad IS NULL,0,prioridad) AS prioridad,ubic, p.n_nro AS nro,CONCAT(DATE_FORMAT(fecha_cierre,'%d/%m/%y'),' ',DATE_FORMAT(TIME(hora_cierre),'%H:%i')) AS cierre,p.suc, p.suc_d AS destino,usuario,codigo,lote,lote_rem,descrip,cantidad,mayorista,urge,obs,
    d.estado   FROM pedido_traslado p INNER JOIN pedido_tras_det d ON p.n_nro = d.n_nro AND  p.estado != 'Abierta' AND 
    d.estado LIKE '$estado' AND  fecha_cierre BETWEEN '$desde' AND '$hasta' AND hora_cierre < '$hora' and mayorista LIKE '$mayorista' AND urge LIKE '$urge' AND p.suc = '$origen' AND p.suc_d = '$destino' 
    and   REPLACE(SUBSTRING(ubic,3,2),'-', '')  $fila  INNER JOIN nodos n ON  d.nodo = n.nodo  ORDER BY n.prioridad ASC , REPLACE(SUBSTRING(ubic,3,2),'-', '') ASC";

    if ($fila == "Sin Ubic") {
        $sql = "SELECT '' AS id, '' AS nodo,'' AS prioridad,'' AS ubic, p.n_nro AS nro,CONCAT(DATE_FORMAT(fecha_cierre,'%d/%m/%y'),' ',DATE_FORMAT(TIME(hora_cierre),'%H:%i')) AS cierre,p.suc, p.suc_d AS destino,usuario,codigo,lote,lote_rem,descrip,cantidad,mayorista,urge,obs,
       d.estado   FROM pedido_traslado p INNER JOIN pedido_tras_det d ON p.n_nro = d.n_nro AND  p.estado != 'Abierta' 
       AND  d.estado  LIKE '$estado' AND  fecha_cierre BETWEEN '$desde' AND '$hasta' AND hora_cierre < '$hora' AND mayorista LIKE '$mayorista' AND urge LIKE '$urge' AND p.suc = '$origen' AND p.suc_d = '$destino' 
           AND (ubic IS NULL OR ubic = '')
       ORDER BY d.descrip ASC ";
        //echo $sql;
    }

     

    $array = getResultArray($sql);
    $array_a = array();
    $i = 0;
    foreach ($array as $arr) {
        $id = $arr['id'];
        $arr['id'] = $i;
        array_push($array_a, $arr);
        $i++;
    }
    
    echo json_encode($array_a);
}

function getResultArray($sql) {
    $db = new My();
    $array = array();
    $db->Query($sql);
    while ($db->NextRecord()) {
        array_push($array, $db->Record);
    }
    return $array;
}

function getRutaMasCorta() {
    require_once("../utils\Disjktra.class.php");

    $origen = $_POST['origen'];
    $destino = $_POST['destino'];

    $db = new My();
    $db->Query("SELECT nodo,adya,costo FROM lista_adyacencias WHERE suc = '00'");
    $graph_array = array();
    while ($db->NextRecord()) {
        $nodo = $db->Record['nodo'];
        $adya = $db->Record['adya'];
        $costo = $db->Record['costo'];
        $arr = array($nodo, $adya, $costo);
        array_push($graph_array, $arr);
    }

    $dj = new Disjktra();
    $path = $dj->dijkstra($graph_array, $origen, $destino);

    echo "Ruta: " . implode(", ", $path) . "\n";
}

function getImage() {
    require_once("../Y_DB_MSSQL.class.php");
    $codigo = $_POST['codigo'];
    $lote = $_POST['lote'];
    $suc = $_POST['suc'];
    $img = "select U_img,Quantity from oibt where ItemCode = '$codigo' and BatchNum = '$lote' and Whscode = '$suc'";
    $ms = new MS();
    $ms->Query($img);
    $ms->NextRecord();
    $image = $ms->Record['U_img'];
    $stock = round($ms->Record['Quantity']);
    $arr = array("image" => $image, "stock" => $stock);
    echo json_encode($arr);
}

function agregarCodigoRemplazoSolicitud() {
    $db = new My();
    $lote = $_POST['lote'];
    $lote_rem = $_POST['lote_rem'];
    $nro = $_POST['nro'];
    $usuario = $_POST['usuario'];
    $suc = $_POST['suc'];

    if ($lote_rem == "") {
        $db->Query("UPDATE pedido_tras_det SET lote_rem = '$lote_rem' WHERE n_nro = $nro AND lote = '$lote';");
        echo "Ok";
        return;
    }

    /**
     *  @todo: Verificar si el Lote de Remplazo no esta en alguna otra nota de Remision Abierta o en proceso de envio.
     */
    // Controlar si el Lote es correcto
    require_once("../Y_DB_MSSQL.class.php");
    $ms = new MS();

    // Buscar Primero datos del Codigo de Remplazo
    $ms->Query("select TOP 1 o.ItemCode,BatchNum,U_color_comercial, i.U_NOMBRE_COM from OIBT o INNER JOIN OITM i ON o.ItemCode = I.ItemCode WHERE BatchNum = '$lote_rem' and WhsCode = '$suc'");
    if ($ms->NumRows() > 0) {
        $ms->NextRecord();
        $ItemCodeR = $ms->Record['ItemCode'];
        $BatchNumR = $ms->Record['BatchNum'];
        $U_NOMBRE_COMR = $ms->Record['U_NOMBRE_COM'];
        $U_color_comercialR = $ms->Record['U_color_comercial'];

        $encontro = false;
        $ms->Query("select TOP 1 o.ItemCode,BatchNum,U_color_comercial, i.U_NOMBRE_COM from OIBT o INNER JOIN OITM i ON o.ItemCode = I.ItemCode WHERE BatchNum = '$lote' and WhsCode = '$suc';");
        while ($ms->NextRecord()) {
            $ItemCode = $ms->Record['ItemCode'];
            $BatchNum = $ms->Record['BatchNum'];
            $U_NOMBRE_COM = $ms->Record['U_NOMBRE_COM'];
            $U_color_comercial = $ms->Record['U_color_comercial'];

            if ($ItemCodeR != $ItemCode) {
                echo "Error: Articulos diferentes, Lote $lote: $U_NOMBRE_COM  Remplazo $lote_rem: $U_NOMBRE_COMR";
                return;
            } else {
                if ($U_color_comercialR != $U_color_comercial) {
                    echo "Error: Colores no coinciden...";
                    return;
                } else {
                    $db->Query("UPDATE pedido_tras_det SET lote_rem = '$lote_rem' WHERE n_nro = $nro AND lote = '$lote';");
                    echo "Ok";
                }
            }
        }
    } else {
        echo "Error: Lote no existe...";
    }
}

function getRemitosAbiertos() {
    $suc = $_REQUEST['suc'];
    $suc_d = $_REQUEST['suc_d'];
    $db = new My();

    $db->Query("SELECT n.n_nro,suc,suc_d,DATE_FORMAT(n.fecha,'%d-%m-%Y') AS fecha, usuario, COUNT(d.lote) AS items FROM nota_remision n left JOIN nota_rem_det d ON n.n_nro = d.n_nro  WHERE  suc = '$suc' and suc_d = '$suc_d' AND n.estado = 'Abierta' and d.codigo not like 'IN%' GROUP BY n.n_nro limit 5");

    echo"<table border='1' id='tabla_remisiones' style='border:1px solid gray;border-collapse: collapse;background: white; width:98%;margin:10% auto'> 
         <tr><th colspan='6' style='text-align: center;background-color: #2c3e50;color:white;height: 26px;letter-spacing:2px;font-size: 16px'>Remisiones Abiertas</th></tr>
         <tr class='titulo'><th>N&deg;</th><th>Usuario</th><th>Lotes</th><th>&nbsp;</th></tr>";

    while ($db->NextRecord()) {
        $nro = $db->Record['n_nro'];
        $origen = $db->Record['suc'];
        $destino = $db->Record['suc_d'];
        $fecha = $db->Record['fecha'];
        $usuario = $db->Record['usuario'];
        $items = $db->Record['items'];
        if ($nro != null) {
            echo "<tr><td class='itemc' style='height:42px' >$nro</td><td  class='itemc'>$usuario</td><td class='itemc items_$nro'>$items</td>"
            . "<td class='itemc btn_$nro'><input type='button' class='insertar' value='Insertar aqu&iacute;' onclick='insertarAqui($nro)' style='height: 24px;font-size: 10px;font-weight: bold' ></td>"
            . "</tr>";
        } else {
            echo "<tr><td class='itemc' colspan='4'>No hay remisiones Abiertas a $suc_d</td></tr>";
        }
    }
    echo "<tr style='border-width:1 0 1 1'><td class='itemc' ><img src='img/arrow-up.png' onclick='minimizar()' title='Minimizar' style='cursor:pointer'></td> "
    . " <td class='itemc' colspan='3'><input type='button' value='Generar Nota Remision de: $suc a $suc_d' onclick=generarRemito('$suc','$suc_d')></td></tr>";

    echo "</table>";
}

function generarRemito() {
    $usuario = $_POST['usuario'];
    $suc = $_POST['origen'];
    $suc_d = $_POST['destino'];
    $db = new My();
    $db->Query("INSERT INTO nota_remision( fecha, hora, usuario, recepcionista, suc, suc_d, fecha_cierre, hora_cierre, obs, estado, e_sap)
                VALUES ( CURRENT_DATE, CURRENT_TIME, '$usuario', '', '$suc', '$suc_d', '', '', '', 'Abierta', 0);");

    $db->Query("SELECT n_nro FROM nota_remision WHERE suc = '$suc' and suc_d = '$suc_d' ORDER BY n_nro DESC limit 1");
    $db->NextRecord();
    $nro = $db->Record['n_nro'];
    echo $nro;
}

/** Desde una Pedido de Traslado */
function insertarLotesEnRemito() {

    $time_start = microtime(true);
    $nro = $_REQUEST['nro'];
    $suc = $_REQUEST['suc'];
    $db = new My();
    $db->Query("SELECT estado from nota_remision where n_nro=$nro");
    $db->NextRecord();
    $estado = $db->Record['estado'];
    $usuario = $_REQUEST['usuario'];
    
    if ($estado == 'Abierta') {
        $lotes = json_decode($_REQUEST['lotes']);
        $insertados = array();
        //debug("insertarLotesEnRemito: Rem: $nro, suc $suc");
        require_once("../Y_DB_MSSQL.class.php");
        $ms = new MS();

        // Buscar Primero datos del Codigo de Remplazo     
        //debug("insertarLotesEnRemito: suc:$suc, Lotes: ".count($lotes));

        foreach ($lotes as $key => $val) {

            $nro_pedido = $lotes[$key]->nro_pedido;
            $codigo = trim($lotes[$key]->codigo);
            $lote = $lotes[$key]->lote;

            $control = verificarLoteEnRemito($nro, $lote);
            if ($control < 1) {
                //debug("insertarLotesEnRemito: Proc Pedido:$nro_pedido, Lote: $lote");
                //$descrip = $lotes[$key]->descrip;
                //$cant = $lotes[$key]->cant;
                // Busco la Unidad de Medida 
                //$ms->Query("select InvntryUom as UM,U_tara as Tara,U_gramaje as Gramaje,o.U_ancho as Ancho  from OITM i, OIBT o WHERE i.ItemCode = o.ItemCode and o.BatchNum =  '$lote' and o.WhsCode = '$suc'");
                $ms->Query("SELECT InvntryUom as UM,CONCAT( m.ItemName,'-',c.Name) as descrip,U_tara as Tara,U_gramaje as Gramaje,o.U_ancho as Ancho,cast(round(q.Quantity - ISNULL(q.CommitQty,0),2) as numeric(20,2)) as Stock FROM OBTN o inner join OBTW w on o.SysNumber=w.SysNumber and o.ItemCode=w.ItemCode inner join OBTQ q on o.SysNumber=q.SysNumber and w.WhsCode=q.WhsCode and q.ItemCode=w.ItemCode inner join OITM m on o.ItemCode=m.ItemCode LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code where o.ItemCode='$codigo' and o.DistNumber = '$lote' and w.WhsCode = '$suc'");
                // echo "SELECT InvntryUom as UM,CONCAT( m.ItemName,'-',c.Name) as descrip,U_tara as Tara,U_gramaje as Gramaje,o.U_ancho as Ancho,cast(round(q.Quantity - ISNULL(q.CommitQty,0),2) as numeric(20,2)) as Stock FROM OBTN o inner join OBTW w on o.SysNumber=w.SysNumber and o.ItemCode=w.ItemCode inner join OBTQ q on o.SysNumber=q.SysNumber and w.WhsCode=q.WhsCode and q.ItemCode=w.ItemCode inner join OITM m on o.ItemCode=m.ItemCode LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code where o.ItemCode='$codigo' and o.DistNumber = '$lote' and w.WhsCode = '$suc'";
                $ms->NextRecord();
                $um = $ms->Record['UM'];
                $tara = $ms->Record['Tara'];
                $gramaje = $ms->Record['Gramaje'];
                $ancho = $ms->Record['Ancho'];
                $cant = $ms->Record['Stock'];
                $descrip = ucfirst(strtolower($ms->Record['descrip']));
                //debug("insertarLotesEnRemito: Obtenido datos de lote");
                if ($um == "") {
                    $um = "Mts";
                }
                if ($tara == null) {
                    $tara = 0;
                }

                // Buscar Cantidad Inicial Requerida para Porcentaje de Tolerancia en Remisiones
                //$ms->Query("select top 1 Quantity as CantCompra from IBT1 where ItemCode = '$codigo' and BatchNum = '$lote'  and (BaseType = '20' or BaseType = '59') AND WhsCode = '$suc' order by DocDate asc"); // 20 Entrada de Mercaderias, 59 Entrada Ajuste + o Fraccionamiento 
                $ms->Query("SELECT (CASE WHEN ABS(SUM(a.Quantity)) = 0 THEN SUM(a.AllocQty) ELSE ABS(SUM(a.Quantity)) END) as CantCompra FROM ITL1 a INNER JOIN	OITL b ON a.LogEntry = b.LogEntry INNER JOIN	OBTN c ON a.ItemCode = c.ItemCode and a.SysNumber = c.SysNumber where b.ItemCode = '$codigo' and c.DistNumber = '$lote'  and (b.ApplyType = '20' or b.ApplyType = '59') AND b.LocCode = '$suc'"); // 20 Entrada de Mercaderias, 59 Entrada Ajuste + o Fraccionamiento 
                $cant_compra = 0;
                if ($ms->NumRows() > 0) {
                    $ms->NextRecord();
                    $cant_compra = (strlen(trim($ms->Record['CantCompra'])) > 0) ? $ms->Record['CantCompra'] : 0;
                    //debug("insertarLotesEnRemito: Obtenido Cantidad Comprada");
                }

                //$control = verificarLoteEnRemito($nro,$lote);
                //if($control < 1){
                $tipo_control_ch = (verifRollo($lote, $codigo)) ? 'Rollo' : 'Pieza';
                $db->Query("insert into nota_rem_det( n_nro, codigo, lote, um_prod, descrip, cantidad,cant_inicial,gramaje,ancho, kg_env, kg_rec, cant_calc_env, cant_calc_rec, tara, procesado, estado,tipo_control, e_sap, usuario_ins,fecha_ins)
                    values ($nro, '$codigo', '$lote', '$um', '$descrip', $cant,$cant_compra,$gramaje,$ancho,0, 0, 0, 0, $tara,0, 'Pendiente','$tipo_control_ch', 0,'$usuario',CURRENT_TIMESTAMP);");
                array_push($insertados, $lote);
                //debug("insertarLotesEnRemito: Insertado lote");
                //}

                $db->Query("UPDATE pedido_tras_det set estado = 'En Proceso' WHERE n_nro = $nro_pedido AND codigo = '$codigo' AND (lote = '$lote' OR lote_rem = '$lote')");
                //debug("insertarLotesEnRemito: Actualizado Estado");
            } else {
                array_push($insertados, $lote);
                //debug("insertarLotesEnRemito: Ya existe lote:$lote en Rem: $nro");
            }
        }

        echo json_encode($insertados);
    } else {
        echo '{"error":"La remision ' . $nro . ' esta ' . $estado . '"}';
    }
    $time_end = microtime(true);
    // //debug("Fin $nro, tiempo: ".(($time_end - $time_start)/60));
}

function verificarLoteEnRemito($n_nro, $lote) {
    $db = new My();
    $db->Query("SELECT COUNT(*) AS cant FROM nota_rem_det WHERE n_nro = $n_nro AND lote = '$lote'");
    $db->NextRecord();
    $cant = $db->Record['cant'];
    return $cant;
}

function verifRollo($lote, $codigo) {
    require_once("../Y_DB_MSSQL.class.php");
    $ms_link = new MS();
    $my_link = new My();
    $fracciones = 0;
    $ventas = 0;
    $esRollo = true;

    $ms_link->Query("SELECT U_padre,InvntryUom as UM from OBTN o inner join OITM m on o.ItemCode=m.ItemCode where o.ItemCode = '$codigo' and DistNumber =  '$lote'");
    $ms_link->NextRecord();
    if (trim($ms_link->Record['U_padre']) == '' || trim($ms_link->Record['UM']) == 'Unid') {
        $esRollo = false;
    } else {
        $ms_link->Query("SELECT count(*) as fracciones from OBTN o where ItemCode = '$codigo' and U_padre =  '$lote'");
        $ms_link->NextRecord();
        $fracciones = (int) $ms_link->Record['fracciones'];
        $ms_link->Close();

        if ($fracciones > 0) {
            $esRollo = false;
        } else {
            $my_link->Query("SELECT count(*) as ventas from factura_venta f inner join fact_vent_det d using(f_nro) where codigo = '$codigo' and lote =  '$lote' and f.estado='Cerrada'");
            $ventas = (int) $my_link->Record['ventas'];
            $my_link->Close();

            if ($ventas > 0) {
                $esRollo = false;
            }
        }
    }
    return $esRollo;
}

new SolicitudesTraslado();
?>

