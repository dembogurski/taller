<?PHP
require_once("../Y_DB_MySQL.class.php"); 
require_once("../Y_DB_MSSQL.class.php"); 
require_once("../Y_Template.class.php");

if (isset($_POST['action'])) {
   call_user_func($_POST['action']); 
}else {
   $t = new Y_Template('reposicion.html');
   $suc=$_GET['suc'];
   $select_sector=$_GET['select_sector'];
   $select_articulos=$_GET['select_articulos'];
   $stockCrit_01=$_GET['stockCrit_01'];
   $val01_1=$_GET['val01_1'];
   $val01_2=$_GET['val01_2'];
   $user=$_GET['user'];
   $emp=$_GET['emp'];
   $fecha = date("d/m/Y");
   $grpXCodColFab = ($_GET['grpXCodColFab'] == 'true');
   $stockCrit="";
   $gprXCCF = "";
   $CCF = "";
   $pedidos = getPedidosAbiertor($suc,$user);
   $listaPedidos = '';
   $host = $_SERVER['HTTP_HOST'] != '190.128.150.70:2220'?'192.168.2.252':'190.128.150.70:2252';
   $images_url = "http://$host/prod_images/";
   

   $t->Set('select_articulos',$select_articulos);
   $t->Set('ItemName',ItemName($select_articulos));
   $t->Show("header");
   if($stockCrit_01 == 'Entre'){
      $stockCrit=" BETWEEN $val01_1 AND $val01_2";
   }else{
      $stockCrit=" $stockCrit_01 $val01_1";
   }

   if($grpXCodColFab){
      $CCF = ',U_color_cod_fabric';
      $gprXCCF = ',U_color_cod_fabric ASC';
   }else{
      $t->Set("showCCF","style='display:none;'");
   }

   foreach($pedidos as $pedido){
      $n_nro = $pedido['n_nro'];
      $suc_d = $pedido['suc_d'];
      $listaPedidos .= "<span onclick='pedidoDetListar($(this))' data-nro='$n_nro' class='pedido_$suc_d'>$n_nro a ($suc_d)</span>";
   }

   $ms = New MS(); 
   $link1 = New My(); 
   $datos = array();
   
   $t->Set('imgURI', $images_url);
   $t->Set('emp',$emp);
   $t->Set('stockCrit',$stockCrit);
   $t->Set('fecha',$fecha);
   $t->Set('user',$user);
   $t->Set('suc',$suc);
   $t->Set('listaPedidos',$listaPedidos);
   $t->Show("bodyTop");
   $sucs = getSucs();
   $sucs_list = '';
   $sucs_list_query = '';

   foreach($sucs as $suc){     
      $sucs_list .= "<th><div>$suc</div></th>";
      $sucs_list_query .= (strlen($sucs_list_query)==0)?"[$suc]":",[$suc]";
   }
   
   $t->Set('sucs',$sucs_list);
   
   $t->Show("dataHeader");

   $ms->Query("SELECT * FROM
   (SELECT c.Code,c.Name $CCF,w.WhsCode, SUM(CAST(ROUND(q.Quantity - ISNULL(q.CommitQty,0),2) AS NUMERIC(20,2))) AS Stock
   FROM OBTN o
   INNER JOIN OBTW w ON o.SysNumber=w.SysNumber AND o.ItemCode=w.ItemCode
   INNER JOIN OBTQ q ON o.SysNumber=q.SysNumber AND w.WhsCode=q.WhsCode AND q.ItemCode=w.ItemCode
   INNER JOIN OITM a ON o.ItemCode=a.ItemCode
   INNER JOIN OITB g ON a.ItmsGrpCod = g.ItmsGrpCod
   LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code
   WHERE o.ItemCode LIKE '$select_articulos' AND o.U_fin_pieza <> 'Si' AND w.WhsCode LIKE '%' AND CAST(ROUND(q.Quantity - ISNULL(q.CommitQty,0),2) AS NUMERIC(20,2)) $stockCrit
   GROUP BY w.WhsCode,c.Code,c.Name $CCF) as data
   PIVOT (AVG(Stock) FOR WhsCode in ($sucs_list_query)) as Pvt
   ORDER BY [00] DESC $gprXCCF");
   while($ms->NextRecord()){
      $Code = $ms->Record['Code'];
      $Name = utf8_encode($ms->Record['Name']);
      $U_color_cod_fabric = $ms->Record['U_color_cod_fabric'];
      
      $t->Set("Code",$Code);
      $t->Set("Name",$Name);
      $t->Set("U_color_cod_fabric", utf8_encode( $U_color_cod_fabric));
      
      $stockXSuc = '';
      foreach($sucs as $suc){
         $stk = $ms->Record[$suc];
         $exClass = '';
         if($stk > 0){
            $exClass = 'lotes';
         }
         $stk =  number_format($stk, 2, ',', '.');
         $stockXSuc .= "<td class='stock $exClass'>$stk</td>";
      }
      $t->Set("stockXSuc",$stockXSuc);
      $t->Show("dataBody");
   }
   $t->Show("EndReport");
}

function getSucs(){
   $ms = new MS();
   $sucs = array();
   
   $ms->Query("SELECT WhsCode FROM OWHS WHERE WhsCode NOT IN ('00.03','08','09','09.01','09.02','09.03','09.04','09.05','09.06','11','26','13')");
   while($ms->NextRecord()){
      array_push($sucs,$ms->Record['WhsCode']);
   }
   return $sucs;
}

function listarLotes(){
   $ms = new MS();
   $ItemCode = $_POST['ItemCode'];
   $suc = $_POST['suc'];
   $sucOrigen = $_POST['sucOrigen'];
   $color = $_POST['color'];
   $colorCodFab = $_POST['colorCodFab'];
   $stockCrit = $_POST['stockCrit'];
   $lotes = array();

   $ms->Query("SELECT o.DistNumber AS lote, o.U_padre as padre,o.U_design as disenho, o.U_img, o.U_F1 as f1, o.U_F2 as f2, o.U_F3 as f3, CAST(ROUND(q.Quantity - ISNULL(q.CommitQty,0),2) AS NUMERIC(20,2)) AS lStock FROM OBTN o 
   INNER JOIN OBTW w ON o.SysNumber=w.SysNumber AND o.ItemCode=w.ItemCode
   INNER JOIN OBTQ q ON o.SysNumber=q.SysNumber AND w.WhsCode=q.WhsCode AND q.ItemCode=w.ItemCode
   WHERE o.ItemCode = '$ItemCode' AND o.U_color_comercial = '$color' AND o.U_color_cod_fabric LIKE '$colorCodFab' AND o.U_fin_pieza <> 'Si' AND w.WhsCode = '$suc' AND CAST(ROUND(q.Quantity - ISNULL(q.CommitQty,0),2) AS NUMERIC(20,2)) $stockCrit ORDER BY right(o.DistNumber,2) ASC, CAST(ROUND(q.Quantity - ISNULL(q.CommitQty,0),2) AS NUMERIC(20,2)) ASC");

   while($ms->NextRecord()){
      $fila = array_map('utf8_encode',$ms->Record);
      $fila =  array_merge($fila, disponible($fila['lote'],$sucOrigen));
      array_push($lotes, $fila);
   }
   echo json_encode($lotes);
}

function disponible($lote,$suc){
   $my = new My();
   $estado = array("doc"=>'Libre',"n_nro"=>'',"suc"=>'');
      
   $pedido = "SELECT 'Pedido' as doc,p.n_nro,lote, suc from pedido_traslado p inner join pedido_tras_det d using(n_nro) where d.lote = '$lote' and(p.estado = 'Abierta' or d.estado='Pendiente')";
   $remision = "SELECT 'Remision',CONCAT(r.n_nro,', (',r.estado,'), '),lote,suc_d as suc from nota_remision r inner join nota_rem_det d using(n_nro) where d.lote = '$lote' and r.estado <> 'Cerrada'";
   $fraccionamiento = "SELECT 'Reserva' as doc,'',lote,suc from orden_procesamiento d where d.lote = '$lote' and suc not in  ('$suc', '00') and d.estado ='Pendiente'";

   $my->Query("$pedido union $remision  union $fraccionamiento ");

   if ($my->NextRecord()) {
      $estado = $my->Record;
   }
   return $estado;
}

function getPedidosAbiertor($suc,$usuario){
   $my = new My();
   $my->Query("SELECT n_nro, suc_d FROM pedido_traslado WHERE suc = '$suc' AND usuario = '$usuario' AND estado = 'Abierta'");
   $pedidos = array();
   while($my->NextRecord()){
      array_push($pedidos, $my->Record);
   }
   return $pedidos;
}

function getPedidosDetalle(){
   $my = new My();
   $n_nro = $_POST['n_nro'];
   $my->Query("SELECT id_det, lote, descrip, cantidad, mayorista, urge FROM pedido_tras_det d WHERE n_nro = $n_nro");
   $det = array();
   while($my->NextRecord()){
      array_push($det, $my->Record);
   }
   echo json_encode($det);
}

function ItemName($ItemCode){
   $ms = new MS();
   $ms->Query("SELECT ItemName FROM OITM WHERE ItemCode = '$ItemCode'");
   $ms->NextRecord();
   return $ms->Record['ItemName'];
}