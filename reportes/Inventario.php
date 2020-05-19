<?php
ini_set('max_execution_time', 0);
require_once("../Y_DB_MSSQL.class.php");
require_once("../utils\\tbs_class.php");
require_once("../Y_DB_MySQL.class.php");

if(isset($_REQUEST['action']) && function_exists($_REQUEST['action'])){
   call_user_func($_REQUEST['action']);
}else{
   $desde = flipDate($_REQUEST['desde']);
   $hasta = flipDate($_REQUEST['hasta']);
   $suc = $_REQUEST['select_suc'];
   $inv_usu = $_REQUEST['inv_usu'];
   $select_sector = $_REQUEST['select_sector'];
   $select_articulos = $_REQUEST['select_articulos'];
   $user = $_REQUEST['user'];
   $emp = $_REQUEST['emp'];
   $ArtColor = $_REQUEST['ArtColor'];
   $tipoReporte = $_REQUEST['tipoReporte'];

   $criterio_articulos = "";
   if($select_articulos == '%'){
      if($select_sector != '%'){
         $lista_codigos = artOnGroup($select_sector);
         $criterio_articulos = "AND codigo IN ($lista_codigos)";
      }
   }else{
      $criterio_articulos = "AND codigo = '$select_articulos'";
   }
   $reporte = array();
   $tbs = new clsTinyButStrong;
   if($tipoReporte == 'inventario'){
      $tbs->LoadTemplate('Inventario.html');

      $my = new My();
      $query = "SELECT * FROM inventario WHERE usuario LIKE '$inv_usu' AND  suc LIKE '$suc' AND DATE(fecha) BETWEEN '$desde' AND '$hasta' $criterio_articulos ORDER BY fecha ASC, lote ASC";
      
      $my->Query($query);
      while($my->NextRecord()){
         $line = array_map('utf8_encode',$my->Record);
         array_push($reporte,$line);
      }
      
      $tbs->MergeBlock('inv','array',$reporte);
   }else if($tipoReporte == 'fdp'){
      $tbs->LoadTemplate('InventarioFDP.html');

      $my = new My();
      $query = "SELECT codigo,lote,CONCAT(signo,ajuste) AS ajuste,fecha,DATE_FORMAT(fecha,'%d/%m/%Y') AS fFecha FROM ajustes WHERE suc LIKE '$suc' AND DATE(fecha) BETWEEN '$desde' AND '$hasta' $criterio_articulos AND  motivo='Actualizacion de Inventario FDP'";
      $my->Query($query);
      while($my->NextRecord()){
         $line = array_map('utf8_encode',$my->Record);
         array_push($reporte,$line);
      }
      
      $tbs->MergeBlock('inv','array',$reporte);
   }
   $tbs->Show();
}

// Lista de articulos en un grupo
function artOnGroup($GrpCod){
   $codigos ="";
   $ms = new MS();
   $ms->Query("SELECT ItemCode FROM OITM WHERE itmsGrpCod = $GrpCod");
   while($ms->NextRecord()){
      $cod = $ms->Record['ItemCode'];
      $codigos .= ",'$cod'";
   }
   return trim($codigos,',');
}
// Información extra de los lotes
function loteInfo(){
   $lote = $_REQUEST['lote'];
   $respuesta = array();
   $m = new MS();
   $m->Query("SELECT itemName,c.Name FROM OBTN o LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code WHERE o.DistNumber = $lote");
   if($m->NextRecord()){
      $respuesta = array_map('utf8_encode', $m->Record);
   }else{
      $respuesta['error'] = "No se encontraron datos del lote $lote";
   }
   echo json_encode($respuesta);
}

function periodos(){
   $suc = $_REQUEST['suc'];
   $rep = array();
   $my = new My();
   $my->Query("SELECT c.id_inv,c.usuario,c.suc,DATE_FORMAT(c.inicio,'%d/%m/%Y') AS mInicio,DATE_FORMAT(IF(c.fin IS NULL,DATE(NOW()),c.fin),'%d/%m/%Y') AS mFin,c.inicio,c.fin,c.estado FROM inventario_cab c INNER JOIN inventario i USING(id_inv) WHERE c.suc LIKE '$suc' GROUP BY c.id_inv,c.usuario,c.suc,c.inicio,c.fin,c.estado HAVING (COUNT(id)>0) ORDER BY DATE(c.inicio) ASC");
   while($my->NextRecord()){
      array_push($rep,array_map('utf8_encode',$my->Record));
   }
   echo json_encode($rep);
}

function flipDate($date){
   $dt = explode('/',$date);
   return $dt[2].'-'.$dt[1].'-'.$dt[0];
}
?>