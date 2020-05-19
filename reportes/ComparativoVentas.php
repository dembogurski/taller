<?php

ini_set('max_execution_time', 0);

require_once("../Y_DB_MySQL.class.php");
require_once("../Y_DB_MSSQL.class.php");
require_once("../utils/tbs_class.php");

$desde = isset($_GET['desde'])?flipDate($_GET['desde'],'/'):false;
$hasta = isset($_GET['hasta'])?flipDate($_GET['hasta'],'/'):false;
$suc = $_GET['select_suc'];
$usuario = $_GET['user'];
$articulo = $_GET['select_articulos'];
$sector = $_GET['select_sector'];
$agrup_suc = $_GET['agrup_suc'];
$agrup_color = $_GET['agrup_color'];
$url = array();

foreach($_GET as $key=>$value){
    array_push($url,array("name"=>$key,"value"=>$value));
}
//print_r($url);
$datos = array();
$groupBySuc = "";
$groupByColor = "";
$orderBySuc = "";
$orderByColor = "";
$displaySuc = 'hide';
$displayColor = 'hide'; 
$clicEvent = ''; 
$ColspanHeader = 7;
$ColspanFooter = 2;

if($agrup_suc == "true"){
    $groupBySuc = ",stock.WhsCode";
    $orderBySuc = ",stock.WhsCode ASC";
    $displaySuc = "";
    $ColspanHeader += 1;
    $ColspanFooter += 1;
}

if($agrup_color == "true"){
    $groupByColor = ",stock.Code, stock.Name";
    $orderByColor = ", stock.Name ASC";
    $displayColor = "";
    $ColspanHeader += 1;
    $ColspanFooter += 1;
}else{
    $clicEvent = "onclick='mostrarPorColor($(this))'";
}

$color = $colorGroup = ",c.Code,c.Name";
$colorOrder = ", c.Name asc";
// Filtro Articulos            
if($articulo === '%' ){   
   $filtro_articulos = "m.ItmsGrpCod = $sector";
}else{
   $filtro_articulos = "o.ItemCode like '$articulo'";
}

$queryStock = "SELECT o.ItemCode, m.ItemName , c.Code, c.Name,w.WhsCode,SUM(CASE WHEN o.U_fin_pieza <> 'Si' THEN CAST(ROUND(q.Quantity - ISNULL(q.CommitQty,0),2) as numeric(20,2)) ELSE 0 END ) as Stock FROM OBTN o INNER JOIN OITM m ON o.ItemCode = m.ItemCode INNER JOIN OBTW w ON o.SysNumber=w.SysNumber AND o.ItemCode=w.ItemCode INNER JOIN OBTQ q ON o.SysNumber=q.SysNumber AND w.WhsCode=q.WhsCode AND q.ItemCode=w.ItemCode LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code WHERE $filtro_articulos and w.WhsCode like '$suc'   group by o.ItemCode, m.itemName, c.Code, c.Name,w.WhsCode";

 
$queryVentasDevolucion = "SELECT i.ItemCode,i.LocCode,o.U_color_comercial, SUM(CASE WHEN i.DocType=13 THEN -i1.Quantity ELSE 0 END) as Venta, SUM(CASE WHEN i.DocType=14 THEN i1.Quantity ELSE 0 END) as Devolucion FROM OBTN o INNER JOIN OITL i ON o.ItemCode = i.ItemCode INNER JOIN ITL1 i1 ON i.LogEntry=i1.LogEntry AND o.SysNumber=i1.SysNumber WHERE i.DocDate BETWEEN CONVERT(VARCHAR(10), '$desde', 103) AND CONVERT(VARCHAR(10), '$hasta', 103) GROUP BY i.ItemCode,i.LocCode,o.U_color_comercial";


$query = "SELECT stock.ItemCode, stock.ItemName $groupBySuc $groupByColor, SUM(stock.Stock) as Stock, SUM(ISNULL(ventas.Venta,0)) as Venta, SUM(ISNULL(ventas.Devolucion,0)) as Devolucion FROM  ($queryStock) AS stock LEFT JOIN  ($queryVentasDevolucion) AS ventas  ON stock.ItemCode = ventas.ItemCode AND stock.WhsCode = ventas.LocCode AND stock.Code = ventas.U_color_comercial GROUP BY stock.ItemCode, stock.ItemName $groupBySuc $groupByColor ORDER BY stock.ItemName ASC $orderBySuc $orderByColor";


$ms = new MS();
 //echo $query;

$ms->Query($query);
$ventas_total = 0;
$devoluciones_total = 0;
$mov_total = 0;
$stock_total = 0;
//$rotaciona_total = 0;

while($ms->NextRecord()){
     
    
   $line = array_map('utf8_encode',$ms->Record);
   $line['mov'] = (float)$line['Venta'] - (float)$line['Devolucion'];
   $ventas_total += (float)$line['Venta'];
   $devoluciones_total += (float)$line['Devolucion'];
   $mov_total += (float)$line['mov'];
   $stock_total += (float)$line['Stock'];
   $line['Rotacion'] = ((float)$line['Venta'] == 0)?0:(float)$line['Stock'] / (float)$line['Venta'];
   //$rotaciona_total += $line['Rotacion'];
      
   
   if($agrup_suc == "false"){
       $line['WhsCode'] = "$suc";
   }
   if($agrup_color == "false"){
       $line['Code'] = $line['Name'] = '';
   }
   if( $line['Stock'] > 0){
       array_push($datos,$line);
   }
}
$rotaciona_total = ($ventas_total == 0)?0:$stock_total / $ventas_total;
$ms->Close();
$tbs = new clsTinyButStrong;
$tbs->LoadTemplate('ComparativoVentas.html');
$tbs->MergeBlock('url','array',$url);
$tbs->MergeBlock('data','array',$datos);
$tbs->Show();

function flipDate($date,$separator){
   $date = explode($separator,$date);
   return $date[2].$separator.$date[1].$separator.$date[0];
}    

function comillas($st){
   return "'".$st."'";
}
?>