<?php

/**
 * Description of ReporteSolicitudesTactil
 * @author Ing.Douglas
 * @date 08/08/2017
 */
require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_DB_MSSQL.class.php");
require_once("../Config.class.php");

class ReporteSolicitudesTactil {
    
    function __construct() {
        $action = $_REQUEST['action'];
        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }
    }

    function main() {
        $origen = $_REQUEST['origen'];
        $destino = $_REQUEST['destino'];
        $operario = $_REQUEST['usuario'];
        $desde = $_REQUEST['desde'];
        $hasta = $_REQUEST['hasta'];
        $tipo = $_REQUEST['tipo'];
        $urge = $_REQUEST['urge'];
        $nivel = $_REQUEST['nivel'];
        $this->actualizarUbicacion($origen, $destino);
        $touch="true";
        $tipo_busqueda = $_REQUEST['tipo_filtro'];
        
        
        $filtro_tipo = "AND d.codigo NOT LIKE 'IN%'";  // tejidos o insumos
    
        if($tipo_busqueda == "insumos"){
            $filtro_tipo = "AND d.codigo LIKE 'IN%'";
        }
         

        $estado = $_REQUEST['estado'];
        $paper_size = $_REQUEST['paper_size'];

        $t = new Y_Template("ReporteSolicitudesTactil.html");
        
        $db = new My();
        $db2 = new My();
        $dba= new My();
        $ms = new MS();
        
        
        $c = new Config();
        $host = $c->getNasHost();
        $path = $c->getNasFolder();
        $images_url = "http://$host/$path";
        $t->Set("images_url",$images_url);
         
       
        $t->Set("paper_size", $paper_size);

        $desde_lat = new DateTime($desde);
        $hasta_lat = new DateTime($hasta);
        $t->Set("desde", $desde_lat->format('d-m-Y'));
        $t->Set("hasta", $hasta_lat->format('d-m-Y'));

        $t->Set("suc", $origen);
        $t->Set("suc_d", $destino);
        $t->Set("tipo_busqueda", $tipo_busqueda);

        if ($tipo == "%") {
            $t->Set("tipo", "Mayorista y Minorista");
        } else {
            $t->Set("tipo", $tipo == 'Si' ? 'Mayorista' : 'Minorista');
        }
        $fila = " > 3";

        if ($nivel == "Hombre") {
            $fila = " < 4 AND (d.ubic IS NOT NULL AND d.ubic != '')";
        } else if ($nivel == "Picker") {
            $fila = " > 3 AND (d.ubic IS NOT NULL AND d.ubic != '')";
        } else {
            $fila = "Sin Ubic";
        }

        if ($estado != 'Pendiente') {
            $fila = " > 0 ";
            $tipo = "%";
            $urge = "%";
            $t->Set("display_numpad","none");
        }else{
            $t->Set("display_numpad","inline");
        }


        $t->Set("operario", $operario);
        
        $db->Query('SELECT  DATE_FORMAT( CURRENT_TIMESTAMP,"%d%-%m-%Y %H:%i") AS fecha_hora');
                 
        $db->NextRecord();
        $fecha_hora = $db->Record['fecha_hora'];
        $t->Set("fecha_hora", $fecha_hora);
         
        
        $t->Set("fecha_hora", date("d-m-Y H:i"));
        $t->Set("nros", $pedidos);

        $t->Show("header");
        $t->Show("head");
        
        if ($fila != "Sin Ubic" && $origen == $destino && $destino == "00") { // Si son pedidos de vendedores mostrar todos
            $fila = " > 0  AND (d.ubic IS NOT NULL AND d.ubic != '') ";
        }

        $sql = "SELECT p.n_nro as nro,usuario,cod_cli,cliente,cat,precio_venta, concat(date_format(fecha_cierre,'%d/%m/%y'),' ',date_format(time(hora_cierre),'%H:%i')) as cierre, p.suc_d as destino,usuario,codigo,lote,lote_rem,descrip,cantidad,mayorista,urge,obs,d.ubic,d.nodo,prioridad,d.estado, LEFT(d.nodo,1) AS estante,REPLACE(SUBSTRING(ubic,3,2),'-', '')  AS fila,pallet,p.cod_cli,p.cliente,precio_venta  FROM pedido_traslado p INNER JOIN pedido_tras_det d on  p.n_nro = d.n_nro and  p.estado != 'Abierta' and d.estado = '$estado' and  fecha_cierre between '$desde' and '$hasta' and mayorista like '$tipo' and urge like '$urge' and p.suc = '$origen' and p.suc_d = '$destino' 
            and REPLACE(SUBSTRING(ubic,3,2),'-', '')  $fila $filtro_tipo"
                . "LEFT JOIN nodos n ON  d.nodo = n.nodo  ORDER BY n.prioridad ASC , REPLACE(SUBSTRING(ubic,3,2),'-', '') ASC ";
 
        if ($fila == "Sin Ubic") {
            $sql = "SELECT p.n_nro as nro,usuario,cod_cli,cliente,precio_venta, concat(date_format(fecha_cierre,'%d/%m/%y'),' ',date_format(time(hora_cierre),'%H:%i')) as cierre, p.suc_d as destino,usuario,codigo,lote,lote_rem,descrip,cantidad,mayorista,urge,obs,d.ubic,'' AS nodo,'' AS prioridad,d.estado, 
            '' AS estante,'' AS fila,'' as pallet  FROM pedido_traslado p  INNER JOIN pedido_tras_det d on  p.n_nro = d.n_nro and  p.estado != 'Abierta' and d.estado = '$estado' and  fecha_cierre between '$desde' and '$hasta' and mayorista like '$tipo' and urge like '$urge' and p.suc = '$origen' and p.suc_d = '$destino' 
            AND (d.ubic IS NULL or d.ubic = '') $filtro_tipo  ORDER BY descrip ASC ";
        }

        $db->Query($sql);


        $this->extraerDatos($db, $t,$origen);
        

        $t->Show("foot");
         
        
        if ($estado == 'Suspendido' || $estado == 'Pendiente') {    
            $t->Show("procesador_pedidos");
        }
        
        if($touch=="true" && $estado == 'Pendiente'){
            require_once("../utils/NumPad.class.php");               
            new NumPad(); 
        } 
    }

    function extraerDatos($db, $t,$origen) {
        while ($db->NextRecord()) {
            $nro = $db->Record['nro'];

            $destino = $db->Record['destino'];
            $usuario = $db->Record['usuario'];
            $codigo = $db->Record['codigo'];
            $cierre = $db->Record['cierre'];
            $lote = $db->Record['lote'];
            $lote_rem = $db->Record['lote_rem'];
            $descrip = $db->Record['descrip'];
            $descrip =  substr($descrip, strpos($descrip, '-')+1,120) ;
            $cantidad = $db->Record['cantidad'];
            $mayorista = $db->Record['mayorista'];
            $urge = $db->Record['urge'];
            $obs = $db->Record['obs'];
            $ubic = $db->Record['ubic'];
            $estante = $db->Record['estante'];
            $estado = $db->Record['estado'];
            $filae = $db->Record['fila'];
            $nodo = $db->Record['nodo'];    
            $pallet = $db->Record['pallet'];    
            $cod_cli = $db->Record['cod_cli'];   
            $cliente = $db->Record['cliente'];
            $cat = $db->Record['cat'];
            $precio_venta = $db->Record['precio_venta'];
            
            //if($origen == "03" ){   
                $ms = new MS();
                $ms->Query("SELECT U_color_cod_fabric FROM OBTN WHERE DistNumber = '$lote'");
                $ms->NextRecord();
                $U_color_cod_fabric = $ms->Record['U_color_cod_fabric'];
                $descrip.=' ('.$U_color_cod_fabric.')';
                $t->Set("fab_color_cod", "Codigo Color Fab.: $U_color_cod_fabric");
            //}
            if($pallet != ''){
                $pallet = ' P:'.$pallet;
            }
            $t->Set("nro", $nro);
            $t->Set("usuario", $usuario);
            //$t->Set("de_a",$origen."&rArr;".$destino);
            $t->Set("codigo", $codigo);
            $t->Set("cierre", $cierre);
            $t->Set("lote", $lote);
            $t->Set("lote_rem", $lote_rem);
            $t->Set("descrip", ucwords(strtolower(utf8_decode($descrip))));
            $t->Set("cantidad", $cantidad);
            $t->Set("mayorista", $mayorista);
            $t->Set("urge", $urge);
            $t->Set("estante", $estante);
            $t->Set("fila", $filae);
            $t->Set("ubic", $ubic."".$pallet);
            $t->Set("nodo", $nodo);
            $t->Set("estado", $estado);
            $t->Set("cod_cli", $cod_cli);
            $t->Set("cliente", $cliente);
            $t->Set("cat", $cat);
            $t->Set("precio_venta", $precio_venta);
            
            if ($estado != 'Pendiente') {
                $t->Set("readonly", "readonly='readonly'");
            }
            if ($obs != '') {
                $setObs = "<br><b>Obs:</b><span style='font-size:12px;color:blue'>" . utf8_decode($obs) . "</span>";
            } else {
                $setObs = "";
            }
            if ($urge == "Si") {
                $class_urge = "urge";
            } else {
                $class_urge = "";
            }
            $t->Set("color_urge", $class_urge);
            $t->Set("obs", $setObs);
            $t->Set("estado", $estado);
            $t->Set("verificar", ($estado === 'Pendiente') ? 'si' : 'no');
            $t->Show("line");
        }
    }

    // Actualizar ubicacion
    function actualizarUbicacion($suc, $suc_d){
        $ms = new MS();
        $my = new My();
        $lotes = '';
        $ubics = array();
        $n_nros = array();

        $my->Query("SELECT d.n_nro,d.lote FROM pedido_traslado p INNER JOIN pedido_tras_det d USING(n_nro) WHERE p.suc = '$suc' AND p.suc_d = '$suc_d' AND  d.estado = 'Pendiente' AND p.estado = 'Pendiente'");
        while($my->NextRecord()){
            $lote = $my->Record['lote'];
            $n_nro = $my->Record['n_nro'];
            if(!in_array($n_nro,$n_nros)){
                array_push($n_nros,$n_nro);
            }
            $lotes .= (strlen($lotes)>0)?", $lote":$lote;
        }
        if(strlen($lotes)>0){
            $ms->Query("SELECT DistNumber,U_ubic, U_pallet_no FROM OBTN WHERE DistNumber in ($lotes)");
            while($ms->NextRecord()){
                $pallet = $ms->Record['U_pallet_no'];
                if($pallet != "" && $pallet != null){
                    $pallet = "-".$pallet;
                }else{
                   $pallet = ""; 
                } 
                $ubic = trim($ms->Record['U_ubic'].$pallet);
                $ubic = (strlen($ubic)>0)?$ubic:'x';
                
                $lte = $ms->Record['DistNumber'];
                if(!isset($ubics[$ubic])){
                    $ubics[$ubic] = array();
                }
                array_push($ubics[$ubic], $lte);
            }
            $ms->Close();
        }
        if(count($ubics)>0){
            $_n_nros = implode(',',$n_nros);
            foreach($ubics as $key=>$value){
                $ubc = ($key == 'x')?'':$key;
                $nodo = ($key == 'x')?'': explode('-',$ubc)[0] . explode('-',$ubc)[2];
                $pallet = ($key == 'x')?'': explode('-',$ubc)[3] ;
                $lts = implode(',',$value);
                 
                $my->Query("UPDATE pedido_tras_det SET ubic='$ubc', nodo='$nodo', pallet = '$pallet' WHERE estado='Pendiente' AND n_nro IN ($_n_nros) AND lote IN ($lts)");
            }
        }
        $my->Close();
    }
}

function getFacturasAbiertasDeCliente(){
    $cod_cli_ = $_POST['cod_cli'];
    $cliente_post = $_POST['cliente'];
    $vendedor = $_POST['vendedor'];
    $suc_  = $_POST['suc'];
    
    $sql = "SELECT f.f_nro,cliente,cod_cli,DATE_FORMAT(fecha,'%d-%m-%Y') AS fecha, usuario AS vendedor, COUNT(d.codigo) AS Items ,notas, COUNT(DISTINCT CONCAT( d.codigo,precio_venta) ) AS Articulos
    FROM  factura_venta f LEFT JOIN fact_vent_det d ON f.f_nro = d.f_nro WHERE  usuario = '$vendedor' AND cod_cli = '$cod_cli_' AND f.estado='Abierta' GROUP BY f.f_nro ";
    
  
    $db = new My();

    $db->Query($sql);

    echo"<table border='1' style='border:1px solid gray;border-collapse: collapse;background: white; width:auto'> 
        <tr><th colspan='7'>Facturas Abiertas</th></tr>
        <tr class='titulo'><th>N&deg;</th><th>Cliente</th><th>Fecha</th><th>Vendedor</th><th>Items</th><th>Notas</th><th>&nbsp;</th></tr>";

    while ($db->NextRecord()) {
        $nro = $db->Record['f_nro'];
        $cliente = $db->Record['cliente'];
        $cod_cli = $db->Record['cod_cli'];
        $fecha = $db->Record['fecha'];
        $usuario = $db->Record['vendedor'];
        $items = $db->Record['Items'];
        $notas = $db->Record['notas'];
        $articulos = $db->Record['Articulos'];
        if ($nro != null) {
            $onclick = "onclick='insertarEnFactura($nro)'";
            $button_val = "Insertar aqu&iacute;";
            if($articulos >= 15){
                $onclick = "";
                $button_val = "Factura llego al limite de 15 Articulos.";
            }
            echo "<tr><td class='itemc'>$nro</td><td  class='itemc'>$cliente</td><td  class='itemc'>$fecha</td><td  class='itemc'>$usuario</td><td class='itemc items_$nro'>$items / $articulos</td><td class='item'>$notas</td>"
            . "<td class='itemc btn_$nro'><input type='button' class='insertar' value='$button_val' $onclick style='height: 24px;font-size: 10px;font-weight: bold' ></td>"
            . "</tr>";
        } else {
            echo "<tr><td class='itemc' style='height:36px' colspan='7'>No hay Facturas Abiertas para $cliente_post</td></tr>";
        }
    }
    echo "<tr style='border-width:1 0 1 1'><td class='itemc' ><img src='../img/arrow-up.png' onclick='minimizar()' title='Minimizar' style='cursor:pointer'></td> "
    . " <td class='itemc' colspan='5'><input type='button' value='Generar Factura' onclick=generarFactura('$cod_cli_','$suc_','$vendedor')></td></tr>";

    echo "</table>";    
}
function getExtraDatosLote(){
    $lote = $_POST['lote']; 
    $suc = $_POST['suc']; 
    
    // $sql = "SELECT i.ItemName,  i.U_ancho,i.U_gramaje,o.InvntryUom as UM_prod, U_color_comercial,c.Name as Color  from oibt i inner join OITM o on o.ItemCode = i.ItemCode left  JOIN [@EXX_COLOR_COMERCIAL] c ON i.U_color_comercial = c.Code  where BatchNum = '$lote' and WhsCode = '$suc'";
    $sql = "SELECT  LTRIM(SUBSTRING(o.ItemName,CHARINDEX('-',o.ItemName)+1,LEN(o.ItemName))) AS ItemName,  i.U_ancho,i.U_gramaje,o.InvntryUom as UM_prod, U_color_comercial,c.Name as Color  from oibt i inner join OITM o on o.ItemCode = i.ItemCode left  JOIN [@EXX_COLOR_COMERCIAL] c ON i.U_color_comercial = c.Code  where BatchNum = '$lote' and WhsCode = '$suc'";
    
    $ms = new MS();
    $ms->Query($sql);
    
    $ms = new MS();
    $array = array();
    $ms->Query($sql);
    while ($ms->NextRecord()) {
        array_push($array, array_map('utf8_encode', $ms->Record));
    }
    $ms->Close();
    
    echo json_encode($array);
}
function cambiarEstadoPedido(){
    $lote = $_POST['lote']; 
    $codigo = $_POST['codigo'];
    $nro_pedido = $_POST['nro_pedido']; 
    $db = new My();
    $db->Query("UPDATE pedido_tras_det set estado = 'En Proceso' WHERE n_nro = $nro_pedido AND codigo = '$codigo' AND (lote = '$lote' OR lote_rem = '$lote')");
    echo "Ok";
}
new ReporteSolicitudesTactil();
?>
