<?php

/**
 * Description of Reportes
 * @author Ing.Douglas
 * @date 02/03/2017
 */

require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");
//require_once("../Y_DB_MSSQL.class.php");

$proto = "http";
if(isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == "on") { 
    $proto = "https";
} 
 
define('path',"$proto://".$_SERVER['SERVER_NAME'].":".$_SERVER['SERVER_PORT']."/qubit"); 
 

class ReportesUI {
    
   function __construct() {
        $action = $_REQUEST['action']; 
        if (function_exists($action)) {            
            call_user_func($action);
        } else {            
            $this->main();
        }
    }
    function main() {
        $t = new Y_Template("ReportesUI.html");
        $t->Show("header");
        $t->Show("filters");
         
        // Clases posibles:   ventas caja empaque funcionarios    gerencia rrhh stock administracion 
             

        // Reporte de Facturas Legales Star Soft
        createReportButton("10.1", $t, "Margen de Ganancias", "administracion");                
        createReportButton("10.2", $t, "Reporte de Stock", "administracion");
        
         
        $t->Show("footer");
    }
}

function margen_de_ganancias(){
    $usuario = $_POST['usuario'];
    $suc = $_POST['suc'];
    $t = new Y_Template("ReportesUI.html");
    $t->Set("titulo_filtro","Reporte de Stock");
    $t->Set("action",path."/reportes/Margen.class.php"); 
    $t->Show("filter_header");   
    
    trFechaDesdeHasta($t);   
    
    $sucursales = getSucursales(" where estado  = 'Activo'","suc asc",true);    
    $contado_credito = createSelect(array( ">=0"=>"Contado/Credito","=0"=>"Contado",">0"=>"Credito") , "tipo");
    showHtml($t,"<tr><td>Sucursal:</td><td>$sucursales</td> <td>Tipo:</td> <td>$contado_credito</td> </tr>");  
    
    botonGenerarReporte($t);    
}

function reporte_de_stock(){
    $usuario = $_POST['usuario'];
    $suc = $_POST['suc'];
    $t = new Y_Template("ReportesUI.html");
    $t->Set("titulo_filtro","Reporte de Stock");
    $t->Set("action",path."/reportes/Stock.class.php"); 
    $t->Show("filter_header");   
     
    $sectores = getSectores("'ACTIVOS','SERVICIOS'",true);
    showHtml($t,"<style>div.selector {position:relative;}div.selector ul {display:none;position:absolute;top: 100%;left: 5%;background-color: wheat;}div.selector ul li {list-style: none;}div.selector ul li:hover {cursor: pointer;border: dotted 1px black;}div.selector ul li:before {content: '* -';color: red;}li.selected {background-color: lightcoral;}div.selector ul li.selected:before {content: '* -';color: green;}</style>");
 
    
    $sucursales = getSucursales(" where estado  = 'Activo'","suc asc",true);    
    showHtml($t,"<tr><td>Sucursal:</td><td>$sucursales</td> </tr>");  
       
    //$ums = createSelect(array("%"=>"* - Todos","Mts"=>"Mts","Kg"=>"Kg","Unid"=>"Unid"), "um_art");
    
    showHtml($t,"<tr><td>Sector: </td><td>$sectores</td><td>Articulo: </td><td> <select id='select_articulos'><option value='%'> * - Todos </option></select></td></tr>");

    $simbolos = createSelect(array(">"=>">","<"=>"<",">="=>">=","<="=>"<="), "criterio");
    
    $criterio="<td>Criterio Stock</td><td>  $simbolos  <input id='umbral' value='0' type='text' size='4' class='itemc' ></td>";     
     
    showHtml($t,"<tr>$criterio</tr>");
 
    showHtml($t,"<script>getArticulos();</script>");
    botonGenerarReporte($t);         
    $t->Show("filter_footer");    
}


/** Macros */
function getResultArray($sql) {
    $db = new My();
    $array = array();
    $db->Query($sql);
    while ($db->NextRecord()) {
        array_push($array, $db->Record);
    }
    $db->Close();
    return $array;
}
/**
 * Metodo generico para devolver un array en MSSQL
 * @param type $sql
 * @return array
 */
function getResultArrayMSSQL($sql) {     
    $db = new MS();
    $array = array();
    $db->Query($sql);
    while ($db->NextRecord()) {
        array_push($array, array_map('utf8_encode', $db->Record));
    }
    $db->Close();
    return $array;
}
function getUsuarios(){
    $suc = $_REQUEST['suc']; 
    $usuario = $_REQUEST['usuario']; 
    $my = new My();
    $sql = "SELECT usuario,nombre,apellido,tel,doc,imagen,suc FROM usuarios WHERE suc LIKE '$suc' AND (usuario LIKE '$usuario%' OR nombre LIKE '$usuario%')";         
    echo json_encode(getResultArray($sql));
}

function getCli(){
    $suc = $_REQUEST['suc']; 
    $search = $_REQUEST['search'];
    $filtroFecha = '';
    if(isset($_REQUEST["desde"]) && isset($_REQUEST["desde"])){
        $desde = $_REQUEST["desde"];
        $hasta = $_REQUEST["hasta"];
        $filtroFecha = " AND fecha_cierre BETWEEN '$desde' AND '$hasta'";
    }
    
    $my = new My();
    $sql = "SELECT f.cod_cli,f.tipo_doc,f.ruc_cli,f.cliente,cod_cli,cat from factura_venta f where f.estado ='Cerrada' and (ruc_cli ='$search' or cliente regexp '$search') $filtroFecha group by f.cod_cli";         
    echo json_encode(getResultArray($sql));
}

function getSucursales($filtro = "",$order_by = "suc asc",$include_all=false,$callback="",$id = 'select_suc'){
    $my = new My();
    $sql = "SELECT suc,nombre FROM sucursales $filtro order by  $order_by";
    $my->Query($sql);

    $sucs = "<select id='$id' $callback>";
    if($include_all){
       $sucs.="<option value='%'>* - Todas</option>"; 
    }
    while ($my->NextRecord()) {
        $suc = $my->Record['suc'];
        $nombre = $my->Record['nombre'];
        $sucs.="<option value=" . $suc . ">" . $suc . " - " . $nombre . "</option>";
    }
    $sucs.="</select>"; 
    return $sucs;
}
function getProveedores($order_by = "CardName ASC",$include_all=false,$callback=""){
    $ms = new MS();
    $sql = "SELECT h.CardCode, h.CardName FROM OITL h INNER JOIN OCRD c ON h.CardCode = c.CardCode WHERE c.CardType='S' AND LEFT(c.CardCode,1) = 'P' GROUP BY h.CardCode, h.CardName ORDER BY $order_by";
    $ms->Query($sql);

    $proveedores  = "<select id='select_proveedor' $callback>";
    if($include_all){
       $proveedores .="<option value='%'>* - Todas</option>"; 
    }
    while ($ms->NextRecord()) {
        $CardCode = $ms->Record['CardCode'];
        $CardName = utf8_encode($ms->Record['CardName']);
        $proveedores .="<option value=" . $CardCode . ">$CardName</option>";
    }
    $proveedores .="</select>"; 
    return $proveedores ;
}
// Usuarios en que tienen notas de pedidos en estado Pendiente
function getUserNotaPedido($suc){
    $my = new My();
    $sql = "SELECT u.usuario, CONCAT(u.nombre,' - ',u.apellido) AS np FROM pedido_traslado p INNER JOIN usuarios u USING(usuario) WHERE p.estado = 'Pendiente' AND p.suc = '$suc' GROUP BY u.usuario ORDER BY np ASC";
    $my->Query($sql);

    $usuarios = "<select id='select_user'>";
    $usuarios.="<option value='%'>* - Todos</option>"; 
    
    while ($my->NextRecord()) {
        $usuario = $my->Record['usuario'];
        $np = $my->Record['np'];
        $usuarios.="<option value='$usuario'>$np</option>";
    }
    $usuarios.="</select>"; 
    $my->Close();
    return $usuarios;
}

function canModSuc($user){
    $my = new My();
    $my->Query("SELECT count(*) as permiso from usuarios u inner join usuarios_x_grupo g using(usuario) inner join permisos_x_grupo p using(id_grupo) where u.usuario = '$user' AND  p.id_permiso = '3.8.1'");
    $my->NextRecord();
    
    $permiso = $my->Record['permiso'];
    
    if( $permiso > 0){
        return true;
    }else{
        return false;
    }
    
}
function canModUser($user){
    $my = new My();
    $my->Query("SELECT count(*) as permiso from usuarios u inner join usuarios_x_grupo g using(usuario) inner join permisos_x_grupo p using(id_grupo) where u.usuario = '$user' AND  p.id_permiso = '10.0.1'");
    $my->NextRecord();
    if((int)$my->Record['permiso'] > 0){
        return true;
    }
    return false;
}
function verMargen($usuario){
    $link = new My();
    // 14 Administracion
    $link->Query("SELECT count(*) as ok FROM usuarios_x_grupo WHERE id_grupo=14 AND usuario = '$usuario'");
    $link->NextRecord();
    $ok = (int)$link->Record['ok'];
    $link->Close();

    if($ok>0){            
        return true;
    }else{
        return false;
    }
}
// Lista de Sectores
function getSectores($excludes='',$include_all=false){
    $ms = new My();
    $ex ='';
    if(strlen(trim($excludes))>0){
        $ex = " WHERE descrip NOT IN($excludes)";
    }
    $sql = " SELECT cod_sector,descrip FROM sectores $ex ORDER BY descrip asc";
    $ms->Query($sql);

    $sectores = "<select id='select_sector' onchange='getArticulos()' >";
    if($include_all){
       $sectores.="<option value='%'>* - Todas</option>"; 
    }
    while ($ms->NextRecord()) {
        $cod_sector = $ms->Record['cod_sector'];
        $descrip = $ms->Record['descrip'];
        $sectores.="<option value= '$cod_sector'>$descrip</option>";
    }
    $sectores.="</select>"; 
    return $sectores;
}
// Lista de articulos por Sector
function getArticulos(){
    $codigo_grupo = $_REQUEST['codigo_grupo'];
    $ms = new My();
    $articulos = array();
    $sql = "SELECT codigo,descrip FROM articulos WHERE cod_sector = $codigo_grupo AND estado = 'Activo' order by descrip asc";
    $ms->Query($sql);

    while ($ms->NextRecord()) {
        $articulos[$ms->Record['codigo']]=utf8_encode($ms->Record['descrip']);
    }
    echo json_encode($articulos);
}

function getMonedas($filtro="",$include_all=true){
    $my = new My();
    $sql = "SELECT m_cod,m_descri FROM monedas $filtro";
    $my->Query($sql);

    $mon = "<select id='moneda'>";
    if($include_all){
       $mon.="<option value='%'>* - Todas</option>"; 
    }
    while ($my->NextRecord()) {
        $m_cod = $my->Record['m_cod'];
        $m_descri = $my->Record['m_descri'];
        $mon.="<option value=" . $m_cod . ">" . $m_cod . " - " . $m_descri . "</option>";
    }
    $mon.="</select>"; 
    return $mon;
}
// Bancos
function getBancos($attr=''){
    $my = new My();
    $sql = "SELECT id_banco,nombre from bancos order by nombre asc";
    $my->Query($sql);

    $bancos = "<select id='id_banco' $attr >";
    if($include_all){
       $bancos.="<option value='%'>* - Todas</option>"; 
    }
    while ($my->NextRecord()) {
        $id_banco = $my->Record['id_banco'];
        $nombre = $my->Record['nombre'];
        $bancos.="<option value=" . $id_banco . ">" . $id_banco . " - " . $nombre . "</option>";
    }
    $bancos.="</select>"; 
    return $bancos;
}
// Cuentas Bancarias
function getCtasBancarias(){
    $id_banco = $_REQUEST['id_banco']; 
    $my = new My();
    $sql = "select cuenta,m_cod,cta_cont from bcos_ctas where id_banco='$id_banco' order by cuenta*1 asc,m_cod asc";
    echo json_encode(getResultArray($sql));
}
// Usuarios que realizaron Inventario
function inventarioUsuarios(){
    $my = new My();
    $my->Query("SELECT DISTINCT(i.usuario), u.apellido,u.nombre FROM inventario i INNER JOIN usuarios u USING(usuario) ORDER BY u.usuario ASC");
    $usuarios = "<option value='%' style='text-align:center;'>Todos</option>";
    while($my->NextRecord()){
        $inv_usu = $my->Record['usuario'];
        $nombre = utf8_encode($my->Record['nombre']);
        $apellido = utf8_encode($my->Record['apellido']);
        $usuarios .= "<option value='$inv_usu'>$nombre - $apellido</option>";
    }
    return "<select id='inv_usu'>$usuarios</select>";
}
function showHtml($t,$html){
    $t->Set("html",$html);
    $t->Show("html");  
}
function text($id,$value="",$placeholder="",$size=10){
   return "<input  id='$id' type='text' value='$value' size='$size' placeholder='$placeholder'>";    
}
function createSelect($values,$id){
    $s = "<select id='$id' >";
    foreach ($values as $key => $value) {
       if(is_numeric($key)){ // Si no se envia key=>val  toma key como val
          $key = $value;
       }
       $s.="<option value='" . $key . "'>" . $value. "</option>";
    }    
    $s.="</select>"; 
    return $s;
}
function trFechaDesdeHasta($t,$incluir_boton_hoy=true){
   showHtml($t,"<tr>");   
   $t->Set("label_fecha","Desde");
   $t->Set("id_fecha","desde");
   $t->Show("fecha");  
   
   $t->Set("label_fecha","Hasta");
   $t->Set("id_fecha","hasta");
   if($incluir_boton_hoy){
       $t->Set("display_set_now","inline");
   }else{
       $t->Set("display_set_now","none");
   }
   $t->Show("fecha");  
   showHtml($t,"</tr>");
}

function botonGenerarReporte($t){
   showHtml($t,"<tr><td colspan='4' style='text-align:center'>");   
   $t->Set("call_func","sendForm()");
   $t->Set("value","Generar Reporte");
   $t->Show("button");   
   showHtml($t,"</td></tr>");
}
/**End Macros */ 

function createReportButton($perm_id, $template, $name, $clases){
    $usuario = $_POST['usuario'];  
    $db = new My();

    $sql_permiso = "SELECT u.nombre AS usu,ug.usuario,g.nombre,p.id_permiso AS id_permiso,descripcion,trustee 
        FROM  usuarios u,grupos g, usuarios_x_grupo ug, permisos_x_grupo p, permisos pr 
        WHERE u.usuario = ug.usuario AND ug.id_grupo = p.id_grupo AND g.id_grupo = ug.id_grupo AND p.id_permiso = pr.id_permiso  AND ug.usuario = '$usuario'
        AND  p.id_permiso = '$perm_id'";

    $db->Query($sql_permiso);

    if($db->NumRows() > 0){
        $template->Set("classes",$clases);
        $template->Set("nombre",$name);        
        $template->Show("button_factory");
    }        
}
 
 

new ReportesUI();
?>
   