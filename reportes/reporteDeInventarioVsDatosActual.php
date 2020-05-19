<?PHP
ini_set('max_execution_time', 18000);
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_DB_MSSQL.class.php");
require_once("../utils\\tbs_class.php");

$tbs = new clsTinyButStrong;
$tbs->LoadTemplate('reporteDeInventarioVsDatosActual.html');

$my = new My();
$ms = new MS();
$reporte = array();


$my->Query("SELECT lote, stock FROM inventario WHERE (suc = '00' and fecha between '2018-06-13' and date(now())) OR (suc = '25' and usuario = 'joseb')");
while($my->NextRecord()){
   $lote = $my->Record['lote'];
   $stock = $my->Record['stock'];
   $ms->Query("SELECT top 1 o.DistNumber,w.SysNumber,w.WhsCode,o.ItemCode,o.itemName, c.Name,o.U_ancho AS Ancho,  CAST(ROUND(q.Quantity - ISNULL(q.CommitQty,0),2) AS NUMERIC(20,2)) AS Stock,m.AvgPrice as Costo, (m.AvgPrice + ((m.AvgPrice * 25)/100)) as ValMin, cast(round(Price,2) as numeric(20,0)) - ((cast(round(Price,2) as numeric(20,0)) * cast(round(U_desc1,2) as numeric(20,0)))/100) as precio1, o.U_fin_pieza,o.U_ubic, o.U_F1 AS f1,o.U_F2 AS f2,o.U_F3 AS f3,o.U_estado_venta FROM OBTN o INNER JOIN OBTW w ON o.SysNumber=w.SysNumber AND o.ItemCode=w.ItemCode INNER JOIN OBTQ q ON o.SysNumber=q.SysNumber AND w.WhsCode=q.WhsCode AND q.ItemCode=w.ItemCode INNER JOIN OITM m ON o.ItemCode=m.ItemCode INNER JOIN ITM1 m1 ON m.ItemCode = m1.ItemCode AND m1.PriceList = 1 LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code WHERE  o.DistNumber = $lote ORDER BY CAST(ROUND(q.Quantity - ISNULL(q.CommitQty,0),2) AS NUMERIC(20,2)) desc");
   if($ms->NextRecord()){
      $fila = $ms->Record;
      $fila['stock_inv'] = $stock;
      array_push($reporte, $fila);
   }
   
}
$tbs->MergeBlock('data',$reporte);

$tbs->Show();

?>