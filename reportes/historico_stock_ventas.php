<?PHP 
header('Content-Type: text/html; charset=utf-8');
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_DB_MSSQL.class.php");
require_once("../Y_Template.class.php");

$sector = $_REQUEST['select_sector'];
$articulo = $_REQUEST['select_articulos'];
$suc = $_REQUEST['select_suc'];
$gpr_color = ($_REQUEST['gpr_color']=='true')?true:false;
$desde = date('Y-m-d',strtotime(str_replace('/', '-', $_REQUEST['desde'])));// $_REQUEST['desde'];
$hasta = date('Y-m-d',strtotime(str_replace('/', '-', $_REQUEST['hasta'])));//$_REQUEST['hasta'];

$t = new Y_Template("historico_stock_ventas.html");
$t->Show('header');
foreach($_REQUEST as $key=>$value){
   $t->Set($key,$value);
}
$t->Set('now',date('d/m/Y H:i:s'));
$t->Set('fecha',date(date('d',strtotime($desde))));// Fecha del periodo

$t->Show('headerReport');
$cabXPie = cabXPie($desde,$hasta,$gpr_color); // Cabecera y pie de la tabla
$t->Set('tableh',$cabXPie['cab']);
$t->Show('tableh');

// Filtro Articulos            
if($articulo === '%' ){
   // Extrae solo los codigos de articulos   
   foreach(getArticulosInGrupo($sector) as $key=>$value){
      $art = "<td>$key</td><td>".$value['sector']."</td><td>".$value['articulo']."</td>";
      $historico = historico($desde, $hasta, $suc, $key,$gpr_color);
      
      
      if(count($historico) > 0){
         foreach($historico as $row){
            if(count($row['stock']) > 0){
               
               $t->Set('tableb_stock',$art.fila($row['stock'])); // .'<td class="num">'.implode('</td><td class="num">',$row['stock']).'</td>');
               $t->Set('tableb_ventas',$art.fila($row['ventas'])); //.'<td class="num">'.implode('</td><td class="num">',$row['ventas']).'</td>');
               $t->Show('tableb');
            }
         }
      }
   }
}else{
   //$filtro_articulos = "o.ItemCode like '$articulo'";  
   $art_data = getArticuloDatos($articulo);
   $art = "<td>$articulo</td><td>".$art_data['sector']."</td><td>".$art_data['articulo']."</td>";
   $historico = historico($desde, $hasta, $suc, $articulo,$gpr_color);
   //var_dump($historico);
   if(count($historico) > 0){
      foreach($historico as $row){
         if(count($row['stock']) > 0){
            //var_dump(array_keys($row['stock']));
            
            $t->Set('tableb_stock',$art.fila($row['stock']));//implode('</td><td class="'.((gettype($row['stock'])=="string")?'':'num').'">',$row['stock']).'</td>');
            $t->Set('tableb_ventas',$art.fila($row['ventas']));//.implode('</td><td class="'.((gettype($row['ventas'])=="string")?'':'num').'">',$row['ventas']).'</td>');
            $t->Show('tableb');
         }
      }
   }
}
$t->Set('tablef',$cabXPie['pie']);
$t->Show('footer');

// Funciones
// Genera las cabeceras y los pie de pagina
function cabXPie($desde, $hasta, $gpr_color){
   $cabs = '<th class="ItemCode">Codigo</th><th>Sector</th><th>Articulo</th>';
   $pie = '<td colspan="3"></td>';
   if($gpr_color){
      $cabs .= '<th class="ColorCod">CodColor</th><th>Color</th>';
      $pie = '<td colspan="5"></td>';
   }
   $ddate = date('d',strtotime($desde));
   $dmonth = date('m',strtotime($desde));
   $dyear = date('Y',strtotime($desde));
   $hmonth = date('m',strtotime($hasta));
   $hyear = date('Y',strtotime($hasta));
   $year = (int)$dyear;
   $month = (int)$dmonth;
   $datos = '';
   while($year <= (int)$hyear){
      //echo "$year <br>";
      while($month < 13 && !($month == (int)$hmonth+1 && $year == (int)$hyear) ){
         $m = ($month > 9)?$month:"0$month";
         $class = md5("$m-$year");
         $cabs .="<th class='$class'>$m-$year</th>";
         $pie .="<td class='$class num'></th>";
         $month ++;
      }
      $year ++;
      $month = 1;
   }
   return array("cab"=>$cabs,"pie"=>$pie);
}

/**
 * Historico de Stock y Ventas 
 * $gpr_color true o false para agrupar por color
 */
function historico($desde, $hasta, $suc, $ItemCode, $gpr_color){
   $ms = new MS();
   $fila = array();
   $ddate = date('d',strtotime($desde));
   $dmonth = date('m',strtotime($desde));
   $dyear = date('Y',strtotime($desde));
   $hmonth = date('m',strtotime($hasta));
   $hyear = date('Y',strtotime($hasta));
  // echo date('d/m/Y',strtotime($desde)), "<br>";
   $year = (int)$dyear;
   $month = (int)$dmonth;
   //echo "$dmonth <br>";
   $datos = '';
   $ex_data = '';
   if($gpr_color){
      $ex_data .= ',c.Code, c.Name';
   }
   while($year <= (int)$hyear){
      //echo "$year <br>";
      while($month < 13 && !($month == (int)$hmonth+1 && $year == (int)$hyear) ){
         $m = ($month > 9)?$month:"0$month";
         $mn = ($month-1 > 9)?$month:((($month-1) == 0) ?"12":"0".($month-1));
         $yearm = (($month-1) == 0) ?$year - 1:$year;

         $mh = ($month+1 > 12)?'01':((($month+1) > 9) ?($month+1):"0".($month+1));
         $yearh = (($month+1) > 12) ?$year + 1:$year;

         $datos .= "SUM(CASE WHEN (i.CreateDate) < CONVERT(DATETIME,'$year-$m-$ddate') THEN (i1.Quantity) ELSE 0 END) AS \"s-$m-$year\", ";
         //$datos .= "SUM(CASE WHEN ((i.CreateDate) BETWEEN CONVERT(DATETIME,'$yearm-$mn-$ddate') AND CONVERT(DATETIME,'$year-$m-$ddate') AND i.DocType in (13,14))  THEN (-i1.Quantity) ELSE 0 END) AS \"v-$m-$year\", ";
         $datos .= "SUM(CASE WHEN ((i.CreateDate) BETWEEN CONVERT(DATETIME,'$year-$m-$ddate') AND CONVERT(DATETIME,'$yearh-$mh-$ddate') AND i.DocType in (13,14))  THEN (-i1.Quantity) ELSE 0 END) AS \"v-$m-$year\", ";
         $month ++;
      }
      $year ++;
      $month = 1;
   }
   $datos = trim($datos,', ');
   
   $query = "SELECT o.ItemCode $ex_data,
   $datos
   FROM OBTN o INNER JOIN OITL i ON o.ItemCode = i.ItemCode 
   INNER JOIN ITL1 i1 ON i.LogEntry=i1.LogEntry AND o.SysNumber=i1.SysNumber 
   LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code  
   WHERE i.LocCode LIKE '$suc' AND i.CreateDate <= Convert(varchar(10),'$hasta',103) AND o.ItemCode = '$ItemCode'
   GROUP BY o.ItemCode $ex_data";
  // echo $query;
   $ms->Query($query);

   while($ms->NextRecord()){
      $stock = array();
      $ventas = array();
      foreach($ms->Record as $key=>$value){
         if(preg_match('/^s/',$key)){
            $stock[substr($key,2,strlen($key))] = number_format($value, 2, ',', '.');
         }else if($key != 'ItemCode'){
            if(preg_match('/^v/',$key)){
               $ventas[substr($key,2,strlen($key))] = number_format($value, 2, ',', '.');
            }else{
               $stock[$key] = utf8_encode($value);
               $ventas[$key] = utf8_encode($value);
            }
         }
      }
      array_push($fila,array('stock'=>$stock, 'ventas'=>$ventas));
   }
   //return array('stock'=>$stock, 'ventas'=>$ventas);
   return $fila;
}
// Datos de Articulos
function getArticuloDatos($articulo){
   $link = new MS();
   $link->Query("SELECT ItemCode, ItemName FROM OITM where ItemCode like '$articulo'");//106:INSUMOS, 107:ACTIVOS
   if($link->NextRecord()){
      $d = explode('-', $link->Record['ItemName']);
      return array("sector"=>$d[0],"articulo"=>$d[1]);
   }else{
      return array();
   }
}
// Lista de articulos por codigo de grupo
function getArticulosInGrupo($grupo){
   $link = new MS();
   $articulos = array();
   $link->Query("SELECT ItemCode,ItemName,LTRIM(SUBSTRING(ItemName,CHARINDEX('-',ItemName)+1,LEN(ItemName))) as nombre FROM OITM where ItmsGrpCod like '$grupo' and ItmsGrpCod not in (106,107) order by nombre asc, ItemName asc");//106:INSUMOS, 107:ACTIVOS
   while($link->NextRecord()){
      $d = explode('-', $link->Record['ItemName']);      
      $articulos[$link->Record['ItemCode']] = array("sector"=>utf8_encode($d[0]),"articulo"=>utf8_encode($d[1]));;
      //$articulos[$link->Record['ItemCode']] = $link->Record['ArticuloNombre'];
   }
   return $articulos;
}
// Genera una fila para la tabla
function fila($datos){
   $fila = '';
   foreach($datos as $key=>$value){
      $fila .= "<td class='".((preg_match('/-/',$key))?'num':'')."'>$value</td>";
   }
   return $fila;
}
// Envuelve en comillas
function comillas($st){
   return "'".$st."'";
}
?>