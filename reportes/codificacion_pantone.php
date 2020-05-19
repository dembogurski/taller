<?PHP
require_once("../Y_DB_MySQL.class.php"); 
require_once("../Y_DB_MSSQL.class.php"); 
require_once("../utils\\tbs_class.php"); 

if(isset($_POST['action'])){
   call_user_func($_POST['action']);
}else{
   $db_lite = new SQLite3('codificacion_pantone.db');
   
   $ms = New MS(); 
   $link1 = New My(); 
   $datos = array(); 
   
   
   $desde = isset($_GET['desde'])?flipDate($_GET['desde'], '/'):false;
   $hasta = isset($_GET['hasta'])?flipDate($_GET['hasta'], '/'):false;
   $lotes_pedidos = $_GET['lotes_pedidos'];
   $usuario = $_GET['user'];
   $suc = $_GET['select_suc'];
   $grupo = $_GET['select_sector'];
   $articulo = $_GET['select_articulos'];
   $stocDiff = 100 - (float)$_GET['stocDiff'];
   $mtsPrefMuestra = (float)$_GET['mtsPrefMuestra'];
   $puedeModificarLista = puedeModificarLista($usuario)?'':"disabled";
   
   $cri_stock_total = $_GET['stock_total']; 
   $ref_stock_total_1 = $_GET['valtotal_1']; 
   $ref_stock_total_2 = $_GET['valtotal_2']; 
   $cri_stock_Xlote = $_GET['stock_Xlote']; 
   $ref_stock_Xlote_1 = $_GET['valXlote_1']; 
   $ref_stock_Xlote_2 = $_GET['valXlote_2']; 
   
   $cri_Xtotal = "SUM(CAST(ROUND(q.Quantity - ISNULL(q.CommitQty,0),2) AS NUMERIC(20,2))) $cri_stock_total $ref_stock_total_1"; 
   $cri_Xlote = "CAST(ROUND(q.Quantity - ISNULL(q.CommitQty,0),2) AS NUMERIC(20,2)) $cri_stock_Xlote $ref_stock_Xlote_1"; 
   
   if ($cri_stock_total == 'Entre') {
      $cri_Xtotal = "SUM(CAST(ROUND(q.Quantity - ISNULL(q.CommitQty,0),2) AS NUMERIC(20,2))) BETWEEN $ref_stock_total_1 AND $ref_stock_total_2"; 
   }
   
   if ($cri_stock_Xlote == 'Entre') {
      $cri_Xtotal = "CAST(ROUND(q.Quantity - ISNULL(q.CommitQty,0),2) AS NUMERIC(20,2)) BETWEEN $ref_stock_Xlote_1 AND $ref_stock_Xlote_2"; 
   }
   $cri = "o.ItemCode LIKE '$articulo' AND a.ItmsGrpCod = $grupo";
   $sql_ok = true; 
   
   $tbs = new clsTinyButStrong; 
   $tbs -> LoadTemplate('codificacion_pantone.html'); 

   /* if($lotes_pedidos == 'true'){
      $arts = $db_lite->query("SELECT distinct articulo FROM muestras WHERE suc LIKE '$suc'");
      $articulos = '';
      while ($row = $arts->fetchArray(SQLITE3_ASSOC)) {
         $articulos .= (strlen($articulos)==0)?"'".$row['articulo']."'":",'".$row['articulo']."'";
      }
      if(strlen(trim($articulos)) > 0){
         $grupo = '%';
         $cri = "o.ItemCode IN ($articulos)";
      }
   } */
   
   $query = "SELECT o.ItemCode, a.ItemName,c.Code,c.Name,o.U_color_cod_fabric,w.WhsCode,SUM(CAST(ROUND(q.Quantity - ISNULL(q.CommitQty,0),2) AS NUMERIC(20,2))) AS Stock FROM OBTN o INNER JOIN OBTW w ON o.SysNumber=w.SysNumber AND o.ItemCode=w.ItemCode INNER JOIN OBTQ q ON o.SysNumber=q.SysNumber AND w.WhsCode=q.WhsCode AND q.ItemCode=w.ItemCode INNER JOIN OITM a ON o.ItemCode=a.ItemCode INNER JOIN OITB g ON a.ItmsGrpCod = g.ItmsGrpCod LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code WHERE $cri AND o.U_fin_pieza <> 'Si' AND w.WhsCode LIKE '$suc' AND $cri_Xlote GROUP BY o.ItemCode, a.ItemName,c.Code,c.Name,o.U_color_cod_fabric,w.WhsCode HAVING($cri_Xtotal) ORDER BY a.ItemName ASC,c.Name ASC,SUM(CAST(ROUND(q.Quantity - ISNULL(q.CommitQty,0),2) AS NUMERIC(20,2))) DESC,o.U_color_cod_fabric ASC,w.WhsCode ASC"; 
   // echo $query;
   $ms -> Query($query); 
   $color_actual = ''; 
   $gpr = 'u'; 
   $stock_ref = 0; 
   while ($ms -> NextRecord()) {
      $fila = $ms -> Record; 
      $fila['id']='';
      $fila['estado'] = '';
      $articulo = $fila['ItemCode'];
      $res_suc = $fila['WhsCode'];
      $ColorCod = $fila['Code'];
      $ColorCodFab = $fila['U_color_cod_fabric'];

      $q_res = $db_lite->query("SELECT id, estado FROM muestras WHERE articulo='$articulo' AND suc='$res_suc' AND ColorCod ='$ColorCod' AND ColorCodFab = '$ColorCodFab'");
      $res = $q_res->fetchArray(SQLITE3_ASSOC);
      
      if(gettype($res) == 'array'){
         $fila['id'] = $res['id'];
         $fila['estado'] = $res['estado'];
      }
      if($lotes_pedidos == 'false' || ($lotes_pedidos == 'true' && $fila['id'] != '')){
         if ($color_actual != $fila['Code']) {
            $gpr = ($gpr == 'u')?'d':'u'; 
            $stock_ref = (float)$fila['Stock']; 
            $color_actual = $fila['Code']; 
            $fila['gpr'] = $gpr; 
            $fila = $fila + getLote($fila['ItemCode'], $grupo, $fila['WhsCode'], $fila['U_color_cod_fabric'], $fila['Code'], $cri_Xlote, $mtsPrefMuestra, 'ASC'); 
            array_push($datos, $fila); 
         }else {
            $fila['gpr'] = $gpr; 
            if ($color_actual == $fila['Code'] && ((((float)$fila['Stock'])/$stock_ref) * 100) >= $stocDiff) {
               $fila = $fila + getLote($fila['ItemCode'], $grupo, $fila['WhsCode'], $fila['U_color_cod_fabric'], $fila['Code'], $cri_Xlote, $mtsPrefMuestra, 'ASC'); 
               array_push($datos, $fila); 
            }
         }
      }

   }
   //print_r($reporte);
   
   $tbs -> MergeBlock('data', $datos); 
   $tbs -> Show(); 
}

function getLote($codigo, $grupo, $suc, $codColFab, $colorCod, $stockCrit, $mtsPrefMuestra, $order = 'ASC') {
   $ms = new MS(); 
   $respuesta = array("lote" => '', "l_stock" => 0); 

   $query0 = "SELECT TOP 1 o.DistNumber AS lote,CAST(ROUND(q.Quantity - ISNULL(q.CommitQty,0),2) AS NUMERIC(20,2)) AS l_stock FROM OBTN o INNER JOIN OBTW w ON o.SysNumber=w.SysNumber AND o.ItemCode=w.ItemCode INNER JOIN OBTQ q ON o.SysNumber=q.SysNumber AND w.WhsCode=q.WhsCode AND q.ItemCode=w.ItemCode INNER JOIN OITM a ON o.ItemCode=a.ItemCode where o.ItemCode LIKE '$codigo' AND a.ItmsGrpCod like '$grupo' AND o.U_fin_pieza <> 'Si' AND w.WhsCode LIKE '$suc' AND RTRIM(LTRIM(o.U_color_cod_fabric))='$codColFab' AND o.U_color_comercial = '$colorCod' AND CAST(ROUND(q.Quantity - ISNULL(q.CommitQty,0),2) AS NUMERIC(20,2)) >= $mtsPrefMuestra ORDER BY CAST(ROUND(q.Quantity - ISNULL(q.CommitQty,0),2) AS NUMERIC(20,2)) $order"; 

   $query1 = "SELECT TOP 1 o.DistNumber AS lote,CAST(ROUND(q.Quantity - ISNULL(q.CommitQty,0),2) AS NUMERIC(20,2)) AS l_stock FROM OBTN o INNER JOIN OBTW w ON o.SysNumber=w.SysNumber AND o.ItemCode=w.ItemCode INNER JOIN OBTQ q ON o.SysNumber=q.SysNumber AND w.WhsCode=q.WhsCode AND q.ItemCode=w.ItemCode INNER JOIN OITM a ON o.ItemCode=a.ItemCode where o.ItemCode LIKE '$codigo' AND a.ItmsGrpCod like '$grupo' AND o.U_fin_pieza <> 'Si' AND w.WhsCode LIKE '$suc' AND RTRIM(LTRIM(o.U_color_cod_fabric))='$codColFab' AND o.U_color_comercial = '$colorCod' AND $stockCrit   ORDER BY CAST(ROUND(q.Quantity - ISNULL(q.CommitQty,0),2) AS NUMERIC(20,2)) $order"; 

   $ms -> Query($query0); 
   if ($ms -> NumRows() > 0) {
      $ms -> NextRecord();
      $respuesta = $ms -> Record;
   }else {
      $ms -> Query($query1); 
      if ($ms -> NumRows() > 0) {
         $ms -> NextRecord();
         $respuesta = $ms -> Record;
      }
   }
   return $respuesta; 
}

function registrar(){
   $db_lite = new SQLite3('codificacion_pantone.db');
   $respuesta = array();
   $id = $_POST['id'];
   if(strlen($id) > 0){
      if($db_lite->exec("DELETE FROM muestras WHERE id=$id")){
         $respuesta["msj"] = "Se elimino el registro correctamente";
         $respuesta["id"] = "";
         $respuesta["query"] = "DELETE FROM muestras WHERE id=$id";
      }else{
         $respuesta["error"] = "No se elimino el registro correctamente";
      }
   }else {
      $datos = '';
      $valores = '';
      foreach($_POST as $key=>$value){
         if($key !=='id' && $key != 'action'){
            $datos .= (strlen($datos) == 0)?$key:",$key";
            $valores .= (strlen($valores) == 0)?"'$value'":",'$value'";
         }
      }
      if($db_lite->exec("INSERT INTO muestras ($datos) VALUES ($valores)")){
         $respuesta["msj"] = "Se agrego el registro";
         $respuesta["id"] = $db_lite->lastInsertRowID();
      }else{
         $respuesta["query"] = "INSERT INTO muestras ($datos) VALUES ($valores)";
         $respuesta["error"] = "No se agrego el registro";
      }
   }
   echo json_encode($respuesta);
}
function listarLotes(){
   $articulo = $_POST['articulo'];
   $ColorCod = $_POST['ColorCod'];
   $ColorCodFab = $_POST['ColorCodFab'];
   $suc = $_POST['suc'];
   $ex_data = 

   $lotes = array();
   $ms = new MS();
   $ms->Query("SELECT o.DistNumber AS lote,o.U_ubic, CAST(ROUND(q.Quantity - ISNULL(q.CommitQty,0),2) AS NUMERIC(20,2)) AS Stock FROM OBTN o INNER JOIN OBTW w ON o.SysNumber=w.SysNumber AND o.ItemCode=w.ItemCode INNER JOIN OBTQ q ON o.SysNumber=q.SysNumber AND w.WhsCode=q.WhsCode AND q.ItemCode=w.ItemCode INNER JOIN OITM a ON o.ItemCode=a.ItemCode WHERE o.ItemCode LIKE '$articulo' AND o.U_fin_pieza <> 'Si' AND w.WhsCode = '$suc' AND o.U_color_cod_fabric='$ColorCodFab' AND o.U_color_comercial = '$ColorCod' AND CAST(ROUND(q.Quantity - ISNULL(q.CommitQty,0),2) AS NUMERIC(20,2)) > 0 ORDER BY CAST(ROUND(q.Quantity - ISNULL(q.CommitQty,0),2) AS NUMERIC(20,2)) ASC");
   while($ms->NextRecord()){
      array_push($lotes,$ms->Record);
   }
   echo json_encode($lotes);
   
}
function enviado(){
   $db_lite = new SQLite3('codificacion_pantone.db');
   $respuesta = array();
   $id = $_POST['id'];
   $estado = $db_lite->querySingle("SELECT estado FROM muestras WHERE id=$id");
   $estado = (trim($estado)=='')?'enviado':'';
   if($db_lite->exec("UPDATE muestras SET estado = '$estado' WHERE id=$id")){
      $respuesta["msj"] = "OK";
      $respuesta["estado"] = $estado;
   }else{
      $respuesta["error"] = "No se pudo efectual la operacion requerida";
   }
   
   echo json_encode($respuesta);
}
function puedeModificarLista($usuario){
   $_my = new My();
   // Solo grupo administración puede modificar lista
   $_my->Query("SELECT * FROM grupos g INNER JOIN usuarios_x_grupo u ON g.id_grupo=u.id_grupo WHERE g.id_grupo = 14 AND u.usuario='$usuario'");
   if($_my->NumRows()>0){
      return true;
   }
   return false;
}

function flipDate($date, $separator) {
   $date = explode($separator, $date); 
   return $date[2] . '-' . $date[1] . '-' . $date[0]; 
}


?>