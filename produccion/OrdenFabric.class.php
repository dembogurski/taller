<?php

/**
 * Description of OrdenFabric
 * @author Ing.Douglas
 * @date 21/09/2017
 */
require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_DB_MSSQL.class.php");
require_once("../Config.class.php");     

class OrdenFabric {

    function __construct() {
        $action = $_REQUEST['action'];
        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }
    }

    function main() {
        $t = new Y_Template("OrdenFabric.html");
        /**
         * Patrones de diseï¿½o         
         */
        $ms = new MS();
        $ms->Query("select Code as Carpeta,Name as Patron from [@DESIGN_PATTERNS] WHERE U_estado = 'Activo'");
        $patrones = "";
        $pattern_codes = "";
        //array_map('utf8_encode', $ms->Record);
        while ($ms->NextRecord()) {
            $carpeta = utf8_encode($ms->Record['Carpeta']);
            $patron = utf8_encode($ms->Record['Patron']);
            $patrones.="'$patron',";
            $pattern_codes.="'$carpeta',";
        }
        $patrones = substr($patrones, 0, -1);
        $t->Set("designs", "[" . $patrones . "]");
        
        $host = $_SERVER['HTTP_HOST'] != '190.128.150.70:8081'?'192.168.2.220':'190.128.150.70';       
        $url = "http://$host:8081";
        $t->Set("url",$url);
        
        $t->Show("headers");
        $t->Show("cabecera_nota_pedido");
        $t->Show("solicitudes_abiertas");
    }

}

function listarPendientes() {
    $t = new Y_Template("OrdenFabric.html");
    $sql = "SELECT e.nro_orden,cod_cli,cliente,e.usuario,CONCAT( DATE_FORMAT(e.fecha,'%d-%m-%Y') ,'  ' ,e.hora) AS fecha,e.estado,asignado_a, nro_emis , e.suc, e.obs FROM orden_fabric e  LEFT JOIN "
            . "emis_produc p ON e.nro_orden = p.nro_orden  WHERE   e.estado = 'Pendiente' and e.e_sap = 1 ";
    $db = new My();

    $usuarios = "SELECT usuario FROM usuarios WHERE suc = '00' AND estado = 'Activo' ORDER BY usuario ASC";
    $db->Query($usuarios);

    $users = '';

    while ($db->NextRecord()) {
        $us = $db->Record['usuario'];
        $users.="<option value='$us'>$us</option>";
    }

    $c = new Config();
    $host = $c->getNasHost();
    $path = $c->getNasFolder();
    $images_url = "http://$host/$path";
    $t->Set("images_url", $images_url);

    $dbd = new My();
    $db->Query($sql);
    $t->Set("designs", "[]");
    $t->Show("headers");
    $t->Show("ordenes_pendientes_head");

    $ms = new MS();
    
    while ($db->NextRecord()) {
        $nro_orden = $db->Record['nro_orden'];
        $cliente = $db->Record['cliente'];
        $usuario = $db->Record['usuario'];
        $suc = $db->Record['suc'];
        $fecha = $db->Record['fecha'];
        $nro_emis = $db->Record['nro_emis'];
        $obs = $db->Record['obs'];
        if ($nro_emis == null) {
            $nro_emis = "";
        }

        $t->Set("nro_orden", $nro_orden);
        $t->Set("nro_emis", $nro_emis);
        $t->Set("cliente", $cliente);
        $t->Set("usuario", "$usuario ($suc)");
        $t->Set("fecha", $fecha);

        $t->Set("usuarios", $users);

        $t->Show("ordenes_pendientes_cab");

        $dbd->Query("SELECT codigo,descrip,design,cantidad,largo,sap_doc FROM orden_det WHERE nro_orden = $nro_orden");
        while ($dbd->NextRecord()) {
            $codigo = $dbd->Record['codigo'];
            $descrip = $dbd->Record['descrip'];
            $design = $dbd->Record['design'];
            $cantidad = $dbd->Record['cantidad'];
            $largo = $dbd->Record['largo'];
            $sap_doc = $dbd->Record['sap_doc'];
            $calc_mts = $cantidad * $largo;
            
            $setObs = "";
            if($obs != null){
                $setObs = "<label style='color:red'> Obs: </label>($obs)";
            }

            $t->Set("codigo", $codigo);
            $t->Set("descrip", $descrip.$setObs);
            $t->Set("design", $design);
            $t->Set("cantidad", number_format($cantidad, 0, ',', '.'));
            $t->Set("medida", number_format($largo, 2, ',', '.'));
            $t->Set("mts", number_format($calc_mts, 0, ',', '.'));
            $t->Set("sap_doc", $sap_doc);
            
            $asign = "";
            if($sap_doc != null){
                $ms->Query("select PickRmrk as AsignadoA from OWOR o where o.DocNum = $sap_doc");
                if($ms->NumRows()>0){
                   $ms->NextRecord();
                   $asign = $ms->Record['AsignadoA'];
                }            
            }
            $t->Set("asign", $asign);
            
            
            $t->Show("ordenes_pendientes_det");
        }

        $t->Show("ordenes_pendientes_foot");
    }

    $db->Close();

    require_once("../utils/NumPad.class.php");
    new NumPad();
}

function misOrdenes() {
    $usuario = $_REQUEST['usuario'];
    $t = new Y_Template("OrdenFabric.html");
    $sql = "SELECT e.nro_orden,cod_cli,cliente,e.usuario,DATE_FORMAT(e.fecha,'%d-%m-%Y') AS fecha,e.estado,asignado_a, nro_emis FROM orden_fabric e  LEFT JOIN emis_produc p ON e.nro_orden = p.nro_orden  WHERE   e.estado != 'Abierta' and e.e_sap = 1  AND e.usuario = '$usuario'";
    $db = new My();
 
    $users = '';
 
    $c = new Config();
    $host = $c->getNasHost();
    $path = $c->getNasFolder();
    $images_url = "http://$host/$path";
    $t->Set("images_url", $images_url);

    $dbd = new My();
    $db->Query($sql);
    $t->Set("designs", "[]");
    $t->Show("headers");
    $t->Show("mis_ordenes_titulo");

    $ms = new MS();
    
    while ($db->NextRecord()) {
        $nro_orden = $db->Record['nro_orden'];
        $cliente = $db->Record['cliente'];
        $usuario = $db->Record['usuario'];
        $fecha = $db->Record['fecha'];
        $nro_emis = $db->Record['nro_emis'];
        $estado = $db->Record['estado'];
        if ($nro_emis == null) {
            $nro_emis = "";
        }

        $t->Set("nro_orden", $nro_orden);
        $t->Set("nro_emis", $nro_emis);
        $t->Set("cliente", $cliente);
        $t->Set("usuario", $usuario);
        $t->Set("fecha", $fecha);
        $t->Set("estado", $estado);
        $t->Set("usuarios", $users);
        $fondo = 'orange';
        if($estado == "Pendiente"){
            $fondo = 'orange';
        }elseif($estado == "En Proceso"){
            $fondo = 'blue';
        }elseif($estado == "Cerrada"){
            $fondo = 'green';
        }else{
           $fondo = 'white'; 
        }
        $t->Set("fondo", $fondo);

        $t->Show("mis_ordenes_cab");

        $dbd->Query("SELECT codigo,descrip,design,cantidad,largo,sap_doc FROM orden_det WHERE nro_orden = $nro_orden");
        while ($dbd->NextRecord()) {
            $codigo = $dbd->Record['codigo'];
            $descrip = $dbd->Record['descrip'];
            $design = $dbd->Record['design'];
            $cantidad = $dbd->Record['cantidad'];
            $largo = $dbd->Record['largo'];
            $sap_doc = $dbd->Record['sap_doc'];
            $calc_mts = $cantidad * $largo;

            $t->Set("codigo", $codigo);
            $t->Set("descrip", $descrip);
            $t->Set("design", $design);
            $t->Set("cantidad", number_format($cantidad, 0, ',', '.'));
            $t->Set("medida", number_format($largo, 2, ',', '.'));
            $t->Set("mts", number_format($calc_mts, 0, ',', '.'));
            $t->Set("sap_doc", $sap_doc);
            
            $asign = "";
            if($sap_doc != null){
                $ms->Query("select PickRmrk as AsignadoA from OWOR o where o.DocNum = $sap_doc");
                if($ms->NumRows()>0){
                   $ms->NextRecord();
                   $asign = $ms->Record['AsignadoA'];
                }
            }
            $t->Set("asign", $asign);
            
            
            $t->Show("mis_ordenes_det");
        }

        $t->Show("mis_ordenes_foot");
    }

    $db->Close();

    require_once("../utils/NumPad.class.php");
    new NumPad();
}

function eliminarLote() {
    $nro_emision = $_POST['nro_emision'];
    $lote = $_POST['lote'];
    $db = new My();
    $db->Query("DELETE FROM emis_det WHERE nro_emis = $nro_emision AND lote = '$lote'");
    $db->Close();
    echo "Ok";
}

function ponerEnProduccion() {
    $nro_emision = $_POST['nro_emision'];
    $nro_orden = $_POST['nro_orden'];
    $usuario = $_POST['usuario'];
    $db = new My();

    $db->Query("UPDATE emis_produc SET fecha_proc = CURRENT_DATE, hora_proc = CURRENT_TIME, estado = 'En Proceso' WHERE nro_emis = $nro_emision");
    $db->Query("UPDATE orden_fabric SET  estado = 'En Proceso' WHERE nro_orden = $nro_orden");

    $db->Close();
    echo "Ok";
}
function ponerEnPendiente() {
    $nro_emision = $_POST['nro_emision'];
    $nro_orden = $_POST['nro_orden'];
    $usuario = $_POST['usuario'];
    $db = new My();

    $db->Query("UPDATE emis_produc SET fecha_proc = CURRENT_DATE, hora_proc = CURRENT_TIME, estado = 'Pendiente' WHERE nro_emis = $nro_emision");
    $db->Query("UPDATE orden_fabric SET  estado = 'Pendiente' WHERE nro_orden = $nro_orden");

    $db->Close();
    echo "Ok";
}

function emisionProduccion() {
    $usuario = $_POST['usuario'];
    $t = new Y_Template("OrdenFabric.html");
    $sql = "SELECT nro_orden,cod_cli,cliente,usuario,DATE_FORMAT(fecha,'%d-%m-%Y') AS fecha,estado,asignado_a FROM orden_fabric WHERE   estado = 'En Proceso' and asignado_a = '$usuario'";
    $db = new My();


    $dbd = new My();
    $db->Query($sql);
    $t->Set("designs", "[]");
    $t->Show("headers");
    $t->Show("ordenes_asignadas_head");


    while ($db->NextRecord()) {
        $nro_orden = $db->Record['nro_orden'];
        $cliente = $db->Record['cliente'];
        $usuario = $db->Record['usuario'];
        $fecha = $db->Record['fecha'];

        $t->Set("nro_orden", $nro_orden);
        $t->Set("cliente", $cliente);
        $t->Set("usuario", $usuario);
        $t->Set("fecha", $fecha);

        $t->Show("ordenes_asignadas_cab");

        $dbd->Query("SELECT codigo,descrip,design,cantidad FROM orden_det WHERE nro_orden = $nro_orden");
        while ($dbd->NextRecord()) {
            $codigo = $dbd->Record['codigo'];
            $descrip = $dbd->Record['descrip'];
            $design = $dbd->Record['design'];
            $cantidad = $dbd->Record['cantidad'];
            $t->Set("codigo", $codigo);
            $t->Set("descrip", $descrip);
            $t->Set("design", $design);
            $t->Set("cantidad", number_format($cantidad, 0, ',', '.'));

            $t->Show("ordenes_asignadas_det");
        }

        $t->Show("ordenes_asignadas_foot");
    }

    $dbd->Close();
    $db->Close();
}

function listarOrdenes() {
    $usuario = $_POST['usuario'];
    $cod_cli = $_POST['cod_cli'];
    $sql = "SELECT nro_orden,cod_cli,cliente,usuario,DATE_FORMAT(fecha,'%d-%m-%Y') AS fecha,estado FROM orden_fabric WHERE cod_cli = '$cod_cli' and usuario = '$usuario' and estado = 'Abierta'";
    $db = new My();
    $db->Query($sql);

    $array = array();
    while ($db->NextRecord()) {
        array_push($array, $db->Record);
    }
    $db->Close();
    echo json_encode($array);
}

function generarOrden() {
    $usuario = $_POST['usuario'];
    $cod_cli = $_POST['cod_cli'];
    $suc = $_POST['suc'];
    $cliente = $_POST['cliente'];

    $sql = "INSERT INTO orden_fabric (cod_cli, cliente, usuario, fecha, hora, suc, suc_d, estado, e_sap)
    VALUES ('$cod_cli', '$cliente', '$usuario', CURRENT_DATE, CURRENT_TIME, '$suc', '00', 'Abierta', 0);";

    $db = new My();
    $db->Query($sql);
    echo "Ok";
}

function getResultArrayMSSQL($sql) {
    require_once("../Y_DB_MSSQL.class.php");
    $db = new MS();
    $array = array();
    $db->Query($sql);
    while ($db->NextRecord()) {
        array_push($array, array_map('utf8_encode', $db->Record));
    }
    $db->Close();
    return $array;
}

function buscarArticulos() {
    $articulo = $_POST['articulo'];
    if(isset($_POST['disenho'])){
        $articulo = ($_POST['disenho'] != '%LISO')?'%ESTAMPADO':'%LISO';   
        $corte = substr($_POST['disenho'],0, -3);
         
        if($corte  === '%NAVIDE' ){
            $articulo = '%NAVID';
        }
    }
   
    $cat = $_POST['cat'];
    
    $filtro_anchor = "";
    $limit = 30;
    if (isset($_POST['limit'])) {     
        $limit = $_POST['limit'];
    } else {
        $limit = 30;
    }
    if (isset($_POST['anchor'])) {
        $anchor = $_POST['anchor'];
        $filtro_anchor = " and BWidth1 = $anchor"; 
    } else {
        $filtro_anchor = "";
    }
 
    $articulos = getResultArrayMSSQL("SELECT TOP $limit o.ItemCode,ItmsGrpNam as Sector, U_NOMBRE_COM as NombreComercial,cast(round(Price,2) as numeric(20,0)) as Precio,o.AvgPrice as PrecioCosto ,o.InvntryUom as UM,cast(round(U_ANCHO,2) as numeric(20,0)) as U_ANCHO,cast(round(U_GRAMAJE_PROM,0) as numeric(20,0)) as U_GRAMAJE,  BHeight1 as Largo,BWidth1 as Anchor,o.U_ESPECIFICA  FROM OITM o  INNER JOIN OITB i ON  o.ItmsGrpCod = i.ItmsGrpCod 
    INNER JOIN OITT t on o.ItemCode = t.Code
    left join ITM1 p on o.ItemCode = p.ItemCode and p.PriceList = '$cat' where    (U_NOMBRE_COM   like '$articulo%' or o.ItemCode  like '$articulo%' ) and o.ItemCode like 'TX%' and o.frozenFor = 'N'  $filtro_anchor ");  // Agregar Estado

    echo json_encode($articulos);
}

function insertarEnOrdenFabric() {
    $nro_orden = $_POST['nro_orden'];
    $codigo = $_POST['codigo'];
    $descrip = $_POST['descrip'];
    $cantidad = $_POST['cantidad'];
    $design = $_POST['design'];
    $largo = $_POST['largo'];
     
    $cons = "SELECT IF(id_det IS NOT NULL,MAX( id_det),0) AS maximo FROM orden_det WHERE nro_orden = $nro_orden";

    $db = new My();
    $db->Query($cons);
    $db->NextRecord();
    $id = $db->Record['maximo'];
    
    if($id == 0){
   // $id++; 
    
       $id = 1; // No debe haber mas de 1
       $sql = "INSERT INTO orden_det(nro_orden, id_det, codigo, descrip, cantidad, design,largo, obs)VALUES ($nro_orden, $id, '$codigo', '$descrip', $cantidad, '$design',$largo, '');";
       $db->Query($sql);
    }
    echo "Ok";
}

function getDetalleOrden() {
    $nro_orden = $_POST['nro_orden'];
    $db = new My();
    $array = array();
    $sql = "SELECT  id_det, codigo, descrip, cantidad, design  FROM orden_det WHERE nro_orden = $nro_orden";
    $db->Query($sql);
    while ($db->NextRecord()) {
        array_push($array, $db->Record);
    }
    $db->Close();
    echo json_encode($array);
}

function eliminarOrden() {
    $nro_orden = $_POST['nro_orden'];
    $db = new My();
    $db->Query("DELETE FROM orden_det WHERE nro_orden = $nro_orden;");
    $db->Query("DELETE FROM orden_fabric WHERE nro_orden = $nro_orden;");
    echo "Ok";
}

function cambiarEstadoOrden() {
    $nro_orden = $_POST['nro_orden'];
    $estado = $_POST['estado'];
    $obs = $_POST['obs'];
    $db = new My();
    if ($estado == "Pendiente") {
        $db->Query("update orden_fabric set estado = '$estado' ,fecha = current_date,hora = current_time, obs = '$obs' WHERE nro_orden = $nro_orden;");
    } else {
        $db->Query("update orden_fabric set estado = '$estado' WHERE nro_orden = $nro_orden;");
    }
    echo "Ok";
}

function generarEmision() {
    $nro_orden = $_POST['nro_orden'];
    $usuario = $_POST['usuario'];
    $suc = $_POST['suc'];

    $db = new My();
    $db->Query("SELECT nro_emis FROM emis_produc WHERE nro_orden = $nro_orden");
    $nro_emision = 0;
    if ($db->NumRows() > 0) {
        $db->NextRecord();
        $nro_emision = $db->Record['nro_emis'];
    } else {
        $db->Query("INSERT INTO  emis_produc ( nro_orden, suc, usuario, fecha, hora,estado, e_sap)VALUES ($nro_orden, '$suc', '$usuario',CURRENT_DATE,CURRENT_TIME,'Abierta', 0);");
        $db->Query("SELECT nro_emis FROM emis_produc WHERE nro_orden = $nro_orden");
        $db->NextRecord();
        $nro_emision = $db->Record['nro_emis'];
    }
    echo $nro_emision;
}

function asignarLote() {
    $nro_orden = $_POST['nro_orden'];
    $nro_emision = $_POST['nro_emision'];
    $usuario = $_POST['usuario'];
    $suc = $_POST['suc'];
    $codigo = $_POST['codigo'];
    $codigo_ref = $_POST['codigo_ref'];
    $lote = $_POST['lote'];
    $descrip = $_POST['descrip'];
    $color = $_POST['color'];
    $design = $_POST['design'];
    $cant_lote = $_POST['cantidad'];
    $multiplicador = $_POST['multiplicador'];
    if(!isset($_POST['multiplicador'])){
        $multiplicador = 1;
    }
    
    $ms = new MS();
    $qp = "SELECT AvgPrice  From  OITM WHERE ItemCode = '$codigo_ref'";  
    $ms->Query($qp);
    $ms->NextRecord();
    $AvgPriceRef = $ms->Record['AvgPrice'];
    
    $qp = "SELECT AvgPrice,InvntryUom From  OITM WHERE ItemCode = '$codigo'";  
    $ms->Query($qp);
    $ms->NextRecord();
    $AvgPrice = $ms->Record['AvgPrice'];
    $InvntryUom = $ms->Record['InvntryUom'];
    
    $db = new My();
    $db->Query("SELECT IF(MAX(id_det) IS NULL,0,MAX(id_det)) AS maxid  FROM emis_det WHERE nro_emis  = $nro_emision");
    $db->NextRecord();
    $max_id = $db->Record['maxid'];
    $max_id++;
    if($AvgPriceRef > 0 ){
        $sql = "INSERT INTO emis_det (nro_emis, nro_orden, id_det,codigo_ref, codigo, lote, descrip, color, design, cant_lote, usuario, cant_frac, fecha, hora,precio_costo,um,fila_orig,multiplicador)
        VALUES ( $nro_emision , $nro_orden , $max_id ,'$codigo_ref', '$codigo', '$lote', '$descrip', '$color', '$design', $cant_lote, '$usuario', 0, NULL, NULL,$AvgPrice,'$InvntryUom',1,$multiplicador);";
        $db->Query($sql);
        
        // Parche para 'NAVIDE?O'
        $db->Query("UPDATE emis_det SET design = 'NAVIDEÑO' WHERE design LIKE 'NAVIDE?O'");
        
        echo json_encode(array("Estado" => "Ok"));
    }else{
        echo json_encode(array("Estado" => "Error","Mensaje"=>"Codigo $codigo_ref Precio Costo = $AvgPriceRef"));
    }
}

function buscarResumenAsignados() {
    $nro_emision = $_POST['nro_emision'];
    $codigo = $_POST['codigo'];
    //$sql = "SELECT  IF( SUM(cant_lote) IS NULL,0,SUM(cant_lote * multiplicador)) AS asignado  FROM emis_det WHERE codigo_ref = '$codigo' AND nro_emis = $nro_emision";
    $sql = "SELECT sum(cant_lote) AS asignado  FROM emis_det WHERE codigo_ref = '$codigo' AND nro_emis = $nro_emision";
    $db = new My();
    $db->Query($sql);
    $db->NextRecord();
    $asignado = $db->Record['asignado'];
    echo json_encode(array("asignado" => $asignado));
}

function listarLotesAsignados() {
    $nro_emision = $_POST['nro_emision'];
    $codigo = $_POST['codigo'];
    $sql = "SELECT  codigo,lote,descrip,cant_lote,color,design,cant_frac as cortes,tipo_saldo,codigo_om,saldo,diff,largo,fila_orig FROM emis_det WHERE codigo_ref = '$codigo' AND nro_emis = $nro_emision order by lote asc,fila_orig DESC";
    $db = new My();

    $array = array();
    $db->Query($sql);
    while ($db->NextRecord()) {
        $linea = $db->Record;
        $linea['img'] = getImg($linea['lote']);
        array_push($array, $linea);
    }
    $db->Close();
    echo json_encode($array);
}

function ferificarEstadoOrdenSAP() {
     $estado = 'Cancelado';
     $sap_doc = $_POST['nro_doc_sap'];
    
    if (  $_POST['nro_doc_sap'] != "") {
        
        $ms = new MS();
        $ms->Query("select Status  from OWOR where DocEntry = $sap_doc");
        $ms->NextRecord();
        $Status = $ms->Record['Status'];

        $estado = '';
        if ($Status == "L") { //Locked = Cerrado
            $estado = 'Cerrado';
        } else if ($Status == "C") { //Canceled = Cancelado
            $estado = 'Cancelado';
            $db = new My();
            $db->Query("UPDATE orden_fabric f, orden_det d SET f.estado = 'Cancelado' WHERE f.nro_orden = d.nro_orden AND sap_doc = $sap_doc");
        } else if ($Status == "R") { //Relesed = Liberado
            $estado = 'Liberado';
        } else { // P = Planed = Planificado
            $estado = 'Planificado';
        }
    }  
    echo $estado;
}

function getArticulosPermitidos(){
    $ItemCodePadre = $_POST['ItemCodePadre'];
    $ms = new MS();
    $ms->Query("SELECT Code,ItemName,t.Quantity FROM ITT1 t, OITM o WHERE o.ItemCode = t.Code and Father = '$ItemCodePadre'");
    $array = array();
    while($ms->NextRecord()){        
       array_push($array, $ms->Record);
    }   
     
    $ms->Close();
    echo json_encode($array);
}

function getImg($lote){
    $ms = new MS();
    $ms->Query("SELECT U_img FROM OBTN WHERE DistNumber = $lote");
    $ms->NextRecord();
    return $ms->Record['U_img'];
}
 
function buscarDatosDeCodigo() {
    $producto_final  = $_POST['producto_final'];
    $lote = $_POST['lote'];
    $suc = $_POST['suc'];
    $cat = $_POST['categoria'];
    $datos = array();
    $datos['existe'] = existeLote($lote);

     
    $ms = new MS();
    //$ms->Query("SELECT ItemCode,cast(round(Quantity - ISNULL(IsCommited,0),2) as numeric(20,2)) as Stock, U_gramaje,U_ancho,U_factor_precio,U_img,c.Name as U_color_comercial, U_F1,U_F2,U_F3,ISNULL(U_fin_pieza,'No') as U_fin_pieza,Status,WhsCode AS Suc,U_img as Img,ISNULL(U_tara,0) AS U_tara ,o.U_desc$cat as Descuento,U_padre FROM OIBT o LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code where  o.BatchNum = '$lote' and WhsCode LIKE '$suc' ;"); //Lote
    $ms->Query("SELECT o.SysNumber,o.ItemCode,cast(round(q.Quantity - ISNULL(q.CommitQty,0),2) as numeric(20,2)) as Stock, U_gramaje,U_ancho,U_factor_precio,U_img,c.Name as U_color_comercial,ISNULL(U_Design,'') as U_Design, U_F1,U_F2,U_F3,ISNULL(U_fin_pieza,'No') as U_fin_pieza,Status,w.WhsCode AS Suc,U_img as Img,ISNULL(U_tara,0) AS U_tara ,o.U_desc$cat as Descuento,U_padre,U_estado_venta,U_kg_desc,o.U_ubic, U_color_cod_fabric FROM OBTN o inner join OBTW w on o.SysNumber=w.SysNumber and o.ItemCode=w.ItemCode inner join OBTQ q on o.SysNumber=q.SysNumber and w.WhsCode=q.WhsCode and q.ItemCode=w.ItemCode LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code where  o.DistNumber = '$lote' and w.WhsCode LIKE '$suc'");
    /**
     * Quantity = Cantidad Fisica
     * IsCommited = Comprometido en Orden de Venta
     */
    $arr = array();

    if ($ms->NumRows() > 0) {
        $ms->NextRecord();
        $codigo = $ms->Record['ItemCode'];
        $stock = $ms->Record['Stock'];
        $ancho = $ms->Record['U_ancho'];
        $gramaje = $ms->Record['U_gramaje'];
        $color_comercial = utf8_decode($ms->Record['U_color_comercial']);
        $U_Design = utf8_decode($ms->Record['U_Design']);
        $factor_precio = $ms->Record['U_factor_precio'];
        $F1 = $ms->Record['U_F1'];
        $F2 = $ms->Record['U_F2'];
        $F3 = $ms->Record['U_F3'];
        $FP = $ms->Record['U_fin_pieza'];
        $Status = $ms->Record['Status'];
        $Suc = $ms->Record['Suc'];
        $Img = $ms->Record['Img'];
        $Tara = $ms->Record['U_tara'];
        $Descuento = $ms->Record['Descuento']; // Descuento para dicha categoria
        $padre = $ms->Record['U_padre'];
        $EstadoVenta = $ms->Record['U_estado_venta'];
        $U_kg_desc = $ms->Record['U_kg_desc'];
        $U_ubic = $ms->Record['U_ubic'];
        $U_color_cod_fabric = utf8_decode($ms->Record['U_color_cod_fabric']);


        if ($ancho == null) {
            $ancho = 0;
        }
        if ($gramaje == null) {
            $gramaje = 0;
        }
        if ($factor_precio == null) {
            $factor_precio = 1;
        }

        // Busco la informacion del Codigo
        $info = new MS();
        $info->Query("SELECT  ItemName as Descrip,U_NOMBRE_COM as NombreComercial,BHeight1 as Largo,BWidth1 as Anchor, InvntryUom as UM,cast(round(OnHand,2) as numeric(20,0)) as TotalGlobal FROM OITM WHERE ItemCode = '$codigo'");
        $info->NextRecord();
        $NombreComercial = $info->Record['NombreComercial'];
        $Largo = $info->Record['Largo'];
        $Anchor = $info->Record['Anchor'];
        // Si tiene (debe tener) Nombre comercial uso este sino Uso la Descripcion
        if ($NombreComercial != null) {
            $descrip = $NombreComercial . "-" . $color_comercial;
        } else {
            $descrip = $info->Record['Descrip'] . "-" . $color_comercial;
        }

        $um = $info->Record['UM'];
        $TotalGlobal = $info->Record['TotalGlobal'];
        if ($um == "") {
            $um = "Mts";
        }

        $datos["Codigo"] = $codigo;
        $datos["Stock"] = $stock;
        $datos["Descrip"] = strtoupper(utf8_decode($descrip));
        $datos["UM"] = $um;
        $datos["Ancho"] = $ancho;
        $datos["Anchor"] = $Anchor; // Solo Para Manteles
        $datos["Largo"] = $Largo;   // Solo para Manteles
        $datos["Gramaje"] = $gramaje;
        $datos["FactorPrecio"] = $factor_precio;
        $datos["TotalGlobal"] = $TotalGlobal;
        $datos["F1"] = $F1;
        $datos["F2"] = $F2;
        $datos["F3"] = $F3;
        $datos["FP"] = $FP;
        $datos["Estado"] = $Status;
        $datos["Suc"] = $Suc;
        $datos["Img"] = $Img;
        $datos["Tara"] = $Tara;
        $datos["Padre"] = $padre;
        $datos["EstadoVenta"] = $EstadoVenta;
        $datos["U_kg_desc"] = $U_kg_desc;
        $datos["U_ubic"] = $U_ubic;
        $datos["U_color_cod_fabric"] = $U_color_cod_fabric;
        $datos["U_Design"] = $U_Design;

        // Buscar el Precio para esta Categoria
        $ms->Query("SELECT cast(round(Price,2) as numeric(20,0)) as Precio FROM ITM1 WHERE ItemCode = '$codigo' AND PriceList = $cat;");
        $ms->NextRecord();
        $precio = $ms->Record['Precio'];
        $datos["Precio"] = $precio;

        if ($cat > 1) {
            $ms->Query("SELECT cast(round(Price,2) as numeric(20,0)) as Precio1 FROM ITM1 WHERE ItemCode = '$codigo' AND PriceList = $cat;");
            $ms->NextRecord();
            $precio1 = $ms->Record['Precio1'];
            $datos["Precio1"] = $precio1;
        } else {
            $datos["Precio1"] = $precio;
        }
        $datos["Descuento"] = $Descuento;

        /**
         * Obtener Cantidad de Compra
         * 20: Factura de Compra
         * 18: Entrada de Mercaderias (Compras)
         * 59: Entrada de Mercaderias
         * 67: Traslados de Mercaderias
         */
        //$ms->Query("select top 1 Quantity as CantCompra from IBT1 where ItemCode = '$codigo' and BatchNum = '$lote'  and (BaseType = '18' or BaseType = '20' or BaseType = '59' or BaseType = '67') AND WhsCode = '$suc' order by DocDate asc"); // 20 Entrada de Mercaderias, 59 Entrada Ajuste + o Fraccionamiento 
        $ms->Query("select ll.Quantity as CantCompra from OBTN o INNER JOIN OBTW w on o.SysNumber=w.SysNumber and o.ItemCode=w.ItemCode inner join OITL l on o.ItemCode=l.ItemCode and w.WhsCode=l.LocCode and o.CreateDate=l.CreateDate inner join ITL1 ll on l.LogEntry=ll.LogEntry and o.SysNumber=ll.SysNumber   where  DistNumber = '$lote' and  l.ApplyType in ('18','20','59','67')"); // 20 Entrada de Mercaderias, 59 Entrada Ajuste + o Fraccionamiento 
        if ($ms->NumRows() > 0) {
            $ms->NextRecord();
            $cant_compra = $ms->Record['CantCompra'];
            $datos["CantCompra"] = $cant_compra;
        } else { // Ver el base type para Productos Fraccionados 
            $datos["CantCompra"] = 0;
        }

        $datos["CantCompra"] = 0;
        
        $mat = "select i.Quantity as MateriaPrima from OITT o, ITT1 i where o.Code = i.Father and o.Code = '$producto_final' and i.Code = '$codigo'";
        $ms->Query($mat);
        if ($ms->NumRows() > 0) {
            $ms->NextRecord();
            $MateriaPrima = $ms->Record['MateriaPrima'];
            $datos["MateriaPrima"] = $MateriaPrima;
        } else { // Ver el base type para Productos Fraccionados 
            $datos["MateriaPrima"] = 0;
        }

        $datos["Mensaje"] = "Ok";
        //array_push($arr, array_map('utf8_string', $datos));
        array_push($arr,   $datos );
    } else {
        if (!$datos['existe']) {
            $datos["Mensaje"] = "Codigo no existe";
        } else {
            $datos["Mensaje"] = "Codigo no paso por su sucursal";
        }
        array_push($arr, $datos);
    }

    echo json_encode($arr);
}

function existeLote($lote_nro) { 
    $ms_link = new MS();
    $ms_link->Query("SELECT count(*) AS existe FROM OBTN WHERE DistNumber='$lote_nro'");
    $ms_link->NextRecord();
    return ((int) $ms_link->Record['existe'] > 0) ? true : false;
}


new OrdenFabric();
?>