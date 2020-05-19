<?PHP
require_once("../Y_DB_MSSQL.class.php");
require_once("../utils\\tbs_class.php");

if(isset($_REQUEST['action'])){
   call_user_func($_REQUEST['action']);
}else{
  $suc = $_GET['suc'];
  $emp = $_GET['emp'];
  $usuario = $_GET['user'];
  $desde = flipDate($_GET['desde'],'/');
  $hasta =flipDate($_GET['hasta'],'/');
  $target_suc = $_GET['select_suc'];
  $sector = $_GET['select_sector'];
  $articulo = $_GET['select_articulos'];
  $codProveedor = $_GET['select_proveedor'];
  $agrupadoCodigo = $_GET['agrupadoCodigo'];
  $agrupadoSuc = $_GET['agrupadoSuc'];
  $agrupadoColor = $_GET['agrupadoColor'];
  $select_docentry = $_GET['select_docentry'];
  $proveedorNombre = nombreProveedor($codProveedor);
  $compras = comprasByDocEntry($select_docentry);
//print_r($compras);

  $TBS = new clsTinyButStrong;
  $TBS->LoadTemplate('stockXProveedor.html');
  $TBS->MergeBlock('compra','array',$compras);
  
  $TBS->Show();
}

/**
 * Funciones
 */

// Lista las sompras en area de criterio del reporte
function listarDeCompras(){
  require_once("../utils\\tbs_class.php");

  $tbs = new clsTinyButStrong;
  $tbs->LoadTemplate('listaDeCompras.html');
  $filas = array();
  $ms = new MS();
  $desde = flipDate($_GET['desde'],'/');
  $hasta =flipDate($_GET['hasta'],'/');
  $select_sector = $_GET['select_sector'];
  $select_articulos = $_GET['select_articulos'];
  $codProveedor = $_GET['select_proveedor'];
  $filtroFecha = '';
  
  if(strlen(trim(preg_replace('/\/|_/', "",$desde))) > 0 && strlen(trim(preg_replace('/\/|_/', "",$hasta))) > 0){
  $filtroFecha = "AND c.DocDate BETWEEN '$desde' AND '$hasta'";
  } 
    
  $qOPDN = "SELECT c.DocEntry, CONVERT(VARCHAR,c.DocDate,103) AS fecha,c.NumAtCard, c.DocCur, c.DocRate, c.DocTotal,c.DocTotalFC,c.Comments, c.CtlAccount, c.U_Pais_Origen, c.U_Estado FROM OPDN c INNER JOIN PDN1 cd ON c.DocEntry = cd.DocEntry INNER JOIN OITM a ON cd.ItemCode = a.ItemCode WHERE c.CANCELED = 'N' AND c.CardCode = '$codProveedor' AND a.ItmsGrpCod LIKE '$select_sector' AND a.ItmsGrpCod NOT IN (107,106) AND cd.ItemCode LIKE '$select_articulos' $filtroFecha GROUP BY c.DocEntry,c.DocDate,c.NumAtCard, c.DocCur, c.DocRate, c.DocTotal,c.DocTotalFC,c.Comments, c.CtlAccount, c.U_Pais_Origen, c.U_Estado";

  $qOPCH = "SELECT cd.BaseRef, CONVERT(VARCHAR,c.DocDate,103) AS fecha,c.NumAtCard, c.DocCur, c.DocRate, c.DocTotal,c.DocTotalFC,c.Comments, c.CtlAccount, c.U_Pais_Origen, c.U_Estado FROM OPCH c INNER JOIN PCH1 cd ON c.DocEntry = cd.DocEntry INNER JOIN OITM a ON cd.ItemCode = a.ItemCode WHERE c.CANCELED = 'N' AND c.CardCode = 'P000190' AND a.ItmsGrpCod LIKE '%' AND a.ItmsGrpCod NOT IN (107,106) AND cd.ItemCode LIKE '$select_articulos' $filtroFecha  GROUP BY cd.BaseRef,c.DocDate,c.NumAtCard, c.DocCur, c.DocRate, c.DocTotal,c.DocTotalFC,c.Comments, c.CtlAccount, c.U_Pais_Origen, c.U_Estado";
  // echo $q;
  $ms->Query("$qOPDN UNION $qOPCH");
  
  while($ms->NextRecord()){
    array_push($filas,array_map('utf8_encode', $ms->Record));
  }
  $ms->Close();
  $tbs->MergeBlock('fila',$filas);
  $tbs->Show();

}

function listarLotes(){
  $suc = $_GET['suc'];
  $emp = $_GET['emp'];
  $usuario = $_GET['user'];
  $desde = flipDate($_GET['desde'],'/');
  $hasta =flipDate($_GET['hasta'],'/');
  $target_suc = $_GET['select_suc'];
  $sector = $_GET['sector'];
  $articulo = $_GET['articulo'];
  $codProveedor = $_GET['select_proveedor'];
  $select_docentry = $_GET['select_docentry'];
  $proveedorNombre = nombreProveedor($codProveedor);
  $TBS = new clsTinyButStrong;
  $TBS->LoadTemplate('stockXProveedor_lotes.html');
  
  // Lotes en compras
  $qry = "SELECT o.DistNumber AS lote,h.DocEntry FROM OITL h INNER JOIN ITL1 hd ON h.LogEntry=hd.LogEntry INNER JOIN OBTN o ON o.ItemCode=h.ItemCode AND o.SysNumber=hd.SysNumber INNER JOIN OITM m ON h.ItemCode = m.ItemCode WHERE h.DocType=20 AND h.DocEntry IN ($select_docentry) AND o.ItemCode LIKE '$articulo' AND m.ItmsGrpCod LIKE '$sector' GROUP BY h.DocEntry,o.DistNumber";
  
  
  //echo $qry.'<br>';
  $resultado = array();
  $ms = new MS();
  $ms->Query($qry);
  $padres = '';
  $lotes = '';
  $cantidadPadres = $ms->NumRows();
  if($cantidadPadres  > 0 ){
    while($ms->NextRecord()){
        $lote = $ms->Record['lote'];
        $padres .= (strlen($padres) > 0)?",'$lote'":"'$lote'";
    }
    $lotes = $padres;
    $hijos = descendientesDe($padres);
    if(strlen($hijos)>0){
        $lotes .= ",$hijos";
    }
  }

  
  $datosSelect = "o.DistNumber as Lote, o.ItemCode as Codigo, o.U_padre as Padre,SUBSTRING(o.itemName,CHARINDEX('-',o.itemName)+1,LEN(o.itemName)) AS Articulo,w.WhsCode as Suc,c.Code as ColorCod,c.Name as Color, cast(round(q.Quantity - ISNULL(q.CommitQty,0),2) as numeric(20,2)) as Stock";
  
  $groupBy = "";
  $TBS->VarRef['colspan'] = 0;
  $TBS->VarRef['showlote'] = '';
  $TBS->VarRef['showsuc'] = '';
  $TBS->VarRef['showcolor'] = '';

  $qry2 = "SELECT $datosSelect FROM OBTN o inner join OBTW w on o.SysNumber=w.SysNumber and o.ItemCode=w.ItemCode inner join OBTQ q on o.SysNumber=q.SysNumber and w.WhsCode=q.WhsCode and q.ItemCode=w.ItemCode inner join OITM m on o.ItemCode=m.ItemCode LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code  WHERE w.WhsCode LIKE '$target_suc' AND cast(round(q.Quantity - ISNULL(q.CommitQty,0),2) as numeric(20,2))>0 AND o.DistNumber IN ($lotes) $groupBy";
  $TBS->VarRef['totalMTS'] = 0;
  // echo $qry2;
  $ms->Query($qry2);
  while($ms->NextRecord()){
    $line = array_map('utf8_encode',$ms->Record);;
    // Calcula el colspand de la sumatoria
    if($TBS->VarRef['colspan'] == 0){
      $TBS->VarRef['colspan'] = count($line);
      if($agrupadoColor == 'true'){
        $TBS->VarRef['colspan'] --;
      }
      if($sinagrupar){
        $TBS->VarRef['colspan'] -= 2;
      }
    }
    // Completa espacios vacio para evitar errores en el templater - Inicio
    if($agrupar){
      $line['lote'] = "";
      $line['padre'] = "";
    }
    if($agrupadoSuc == 'false' && !$sinagrupar){
      $line['suc'] = "";
    }
    if($agrupadoColor == 'false' && !$sinagrupar){
      $line['Code'] = "";
      $line['color'] = "";
    }
    // Completa espacios vacio para evitar errores en el templater - Fin

    $TBS->VarRef['totalMTS'] += $ms->Record['stock'];
    
    array_push($resultado,$line);
   }
   // print_r($resultado);
   echo json_encode($resultado);
   /*
   $TBS->MergeBlock('fila','array',$resultado);
   
   $TBS->Show(); */
}
// Lista de compras por DocEntry String separado por coma
function comprasByDocEntry($dosEntrys){
  $ms_link = new MS();
  $compras = array();
  $ms_link->Query("SELECT c.DocEntry, CONVERT(VARCHAR,c.DocDate,103) AS fecha,c.NumAtCard, c.DocCur, c.DocRate, c.DocTotal,c.DocTotalFC,c.Comments, c.CtlAccount, c.U_Pais_Origen, c.U_Estado FROM OPDN c  WHERE c.DocEntry IN ($dosEntrys)");
  while($ms_link->NextRecord()){
    array_push($compras, array_map('utf8_encode',$ms_link->Record));
  }
  $ms_link->Close();
  return $compras;
}

// Busca descendientes de los lotes 
function descendientesDe($padres){
   $_ms = new MS();
   $_hijos = '';
   $_ms->Query("SELECT o.DistNumber as lote FROM OBTN o WHERE o.U_padre IN ($padres)");

   if( $_ms->NumRows() > 0 ){
      while($_ms->NextRecord()){
         $hijo = $_ms->Record['lote'];
         $_hijos .= (strlen($_hijos) > 0)?",'$hijo'":"'$hijo'";
      }
            
      $_hs = descendientesDe($_hijos);
      if( strlen($_hs) > 0 ){
         $_hijos .= ",$_hs";
      }
   }
   return $_hijos;
}

function flipDate($date,$separator){
   $date = explode($separator,$date);
   return $date[2].$separator.$date[1].$separator.$date[0];
} 

function nombreProveedor($codigoProveedor){
   $ms = new MS();
   $proveedor = '';
   $ms->Query("SELECT c.CardName FROM OCRD c WHERE c.CardCode = '$codigoProveedor'");
   if($ms->NextRecord()){
      $proveedor = utf8_encode($ms->Record['CardName']);
   }
   return $proveedor;
}
?>