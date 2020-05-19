<?PHP
ini_set('max_execution_time', 0);
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_DB_MSSQL.class.php");
require_once("../utils\\tbs_class.php");
if(!isset($_REQUEST['action'])){
   $ms_link = New MS();
   $fecha_limite = $_GET['fecha_limite'];
   $suc = $_GET['suc'];
   $TBS = new clsTinyButStrong;
   $TBS->LoadTemplate('InventarioReportes.html');
   
   $grupos_query = "SELECT gpr.ItmsGrpCod,gpr.ItmsGrpNam FROM OITB gpr WHERE ItmsGrpNam not in ('ACTIVOS','INSUMOS')";
   $ms_link->Query($grupos_query);
   $grupos = array();
   while($ms_link->NextRecord()){
      $current = $ms_link->Record;      
      array_push($grupos,array_map('utf8_encode',$current));
      
   }
   $TBS->MergeBlock('grupo',$grupos);

   $articulos_query = "SELECT art.ItmsGrpCod,art.ItemCode, LTRIM(SUBSTRING (art.ItemName,(CHARINDEX('-',art.ItemName)+1),LEN(art.ItemName))) as ItemName FROM OITM art WHERE ItmsGrpCod not in (106,107) ORDER BY LTRIM(SUBSTRING (art.ItemName,(CHARINDEX('-',art.ItemName)+1),LEN(art.ItemName))) asc";
   
   $ms_link->Query($articulos_query);
   $articulos = array();
   while($ms_link->NextRecord()){
      $current = $ms_link->Record;      
      array_push($articulos,array_map('utf8_encode',$current));
      
   }
   $TBS->MergeBlock('articulo',$articulos);


   $TBS->Show();
}else{
   $action = $_REQUEST['action'];
   switch($action){
      case 'lostesXSucXArticulo':
         $suc = $_REQUEST['suc'];
         $codigo = $_REQUEST['codigo'];
         $todos = ($_REQUEST['todos'] == 'true')?true:false;
         $fecha_limite = $_REQUEST['fecha_limite'];
         $filtro_stock = $_REQUEST['filtro_stock'];
         
         lostesXSucXArticulo($suc,$codigo,$fecha_limite,$todos,$filtro_stock);
      break;
      case 'avance':
         $suc = $_REQUEST['suc']; 
         $fecha_limite = $_REQUEST['fecha_limite'];        
         avance($suc,$fecha_limite );
      break;
      case 'codigosXCodXSuc':
         $suc = $_REQUEST['suc'];
         $codigo = $_REQUEST['articulo'];         
         codigosXCodXSuc($suc,$codigo);
      break;      
      case 'piezasInventariadasXRangoFecha':
         $user = $_REQUEST['user'];
         $suc = $_REQUEST['suc'];
         $desde = $_REQUEST['desde'];         
         $hasta = $_REQUEST['hasta'];         
         piezasInventariadasXRangoFecha($user,$suc,$desde,$hasta);
      break;
      case 'ponerNFDP':
         $suc = $_REQUEST['suc'];
         $user = $_REQUEST['user'];
         $lotes = json_decode($_REQUEST['lotes']);

         ponerNFDP($suc,$lotes,$user);
      break;
      case 'lotesPendientesDeInventario':
         $suc = $_REQUEST['suc'];
         $ItmsGrpCod = $_REQUEST['ItmsGrpCod'];
         $fecha_limite = $_REQUEST['fecha_limite'];
         lotesPendientesDeInventario($suc,$ItmsGrpCod,$fecha_limite);
      break;
      default:
         //echo json_encode(array("error"=>"No existe opcion $action"));
         echo "No existe opcion $action";
      break;
   }
}



function inventariadosXCod($codigo,$suc,$fecha_limite,$todos){
   $inv = 0;
   $link = new My();
   $filtro_todos = "";
   if(!$todos){
      $filtro_todos = " AND fecha > '$fecha_limite' ";
   }
   $link->Query("SELECT count(distinct lote) as inv from inventario where codigo = '$codigo' and suc = '$suc' $filtro_todos");
   $link->NextRecord();
   $inv = $link->Record['inv'];
   $link->Close();
   return $inv;
}

// Pasar lotes a Fin de Pieza
function ponerNFDP($_suc,$_lotes,$user){
    $ms = new MS();
    $my = new My();
    $lotes = implode(',',$_lotes);
    $exLotes = array();
    $FDP = array();
    $FDPData = '';
    $AjusteData = '';
    $respuesta = array();

    // Genera LIsta de Exclusion
    $ms->Query("SELECT o.DistNumber FROM OBTN o inner join OBTW w on o.SysNumber=w.SysNumber and o.ItemCode=w.ItemCode inner join OBTQ q on o.SysNumber=q.SysNumber and w.WhsCode=q.WhsCode and q.ItemCode=w.ItemCode inner join OITM m on o.ItemCode=m.ItemCode LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code where o.DistNumber in ($lotes) and w.WhsCode <> '$_suc' and cast(round(q.Quantity - ISNULL(q.CommitQty,0),2) as numeric(20,2))>0");
    while($ms->NextRecord()){
        array_push($exLotes,$ms->Record['DistNumber']);
    }
    
    // Por las dudas si ya cargo antes
    $my->Query("SELECT lote as DistNumber from ajustes where e_sap = 0 and lote in ($lotes) and suc = '$suc'");
    while($my->NextRecord()){
        array_push($exLotes,$my->Record['DistNumber']);
    }
    
    $FDP = implode(',',array_diff($_lotes,$exLotes));

    $ms->Query("SELECT o.DistNumber,m.ItemCode,(m.ItemName+'-'+c.Name) as descrip,m.InvntryUom,m.AvgPrice,cast(round(q.Quantity - ISNULL(q.CommitQty,0),2) as numeric(20,2)) as Stock FROM OBTN o inner join OBTW w on o.SysNumber=w.SysNumber and o.ItemCode=w.ItemCode inner join OBTQ q on o.SysNumber=q.SysNumber and w.WhsCode=q.WhsCode and q.ItemCode=w.ItemCode inner join OITM m on o.ItemCode=m.ItemCode LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code where w.WhsCode = '$_suc' AND
    o.DistNumber in ($FDP) ");

    while($ms->NextRecord()){
        $FDPData .= "('$user','".$ms->Record['ItemCode']."','".$ms->Record['DistNumber']."','".$ms->Record['descrip']."',date(now()),time(now()),'$_suc','Si',0),";
        if((float)$ms->Record['Stock'] != 0){
            $AjusteData .= "('$user',0,'".$ms->Record['ItemCode']."','".$ms->Record['DistNumber']."','Correccion de Stock','".(((float)$ms->Record['Stock']>0)?'-':'+')."',".$ms->Record['Stock'].",".$ms->Record['Stock'].",0,'Actualizacion de Inventario FDP',date(now()),time(now()),'".$ms->Record['InvntryUom']."','Pendiente','$_suc',".((float)$ms->Record['AvgPrice']).",".((float)$ms->Record['AvgPrice']*(float)$ms->Record['Stock']).",0),";
        }
    }

    $my_ajuste = "INSERT INTO ajustes( usuario,f_nro, codigo, lote, tipo,signo, inicial, ajuste, final, motivo, fecha, hora, um, estado,suc,p_costo,valor_ajuste, e_sap) VALUES " . trim($AjusteData,',');
//('$usuario',0, '$codigo', '$lote', '$oper','$signo',$stock,$ajuste, $final, '$motivo', CURRENT_DATE, CURRENT_TIME, '$um', 'Pendiente','$suc',$precio_costo,$valor_ajuste,$e_sap);
    $my_edicion = "INSERT INTO edicion_lotes (usuario, codigo, lote, descrip, fecha, hora, suc, FP, e_sap) VALUES " . trim($FDPData,',');
    
    $my->Query($my_ajuste);
    if($my->AffectedRows() > 0){
        $my->Query($my_edicion);
        if($my->AffectedRows() > 0){
            
        }
    }

    echo json_encode(array("FDP"=>array_diff($_lotes,$exLotes), "lotesEX"=>$exLotes));
}


function codigosXCodXSuc($suc,$codigo){
   $ms_link = New MS();   
   $suc = $_POST['suc'];
   $todos = ($_POST['todos'] == 'true')?true:false;
   $articulo = $_POST['articulo'];
   $fecha_limite = $_POST['fecha_limite'];
   $ItmsGrpCod = $_POST['ItmsGrpCod'];
   
   $articulosXSuc = "SELECT o.ItemCode,m.ItemName,COUNT(*) as lotes,SUM(CASE WHEN o.U_fin_pieza = 'Si' THEN 1 ELSE 0 END) AS fdp FROM OBTN o INNER JOIN  (SELECT i.ItemCode,i1.SysNumber,i.LocCode,min(i.DocDate) as entDate,sum(i1.Quantity) as Stock FROM OITL i INNER JOIN ITL1 i1 ON i.LogEntry=i1.LogEntry group by i.ItemCode,i1.SysNumber,i.LocCode) as mov on o.ItemCode=mov.ItemCode and o.SysNumber = mov.Sysnumber INNER JOIN OITM m on o.ItemCode=m.ItemCode LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code WHERE m.ItmsGrpCod = $ItmsGrpCod and o.ItemCode like '$articulo' and mov.LocCode like '$suc' AND Stock > 0 and mov.entDate < CONVERT(DATETIME, '$fecha_limite', 111) group by o.ItemCode,m.ItemName order by m.ItemName asc";
   
   //echo $articulosXSuc;
   $ms_link->Query($articulosXSuc);
   $datos = array();
   while($ms_link->NextRecord()){
      $current = $ms_link->Record;
      $current['inv'] = inventariadosXCod($current['ItemCode'],$suc,$fecha_limite,$todos);
      array_push($datos,array_map("utf8_encode", $current));
      
   }
   echo json_encode($datos);
}

function lostesXSucXArticulo($suc,$codigo,$fecha_limite,$todos,$filtro_stock){
   $ms_link = new MS();
   $respuesta = array();   
   $invLotes = inventariadosXArticuloXsuc($suc,$codigo,$fecha_limite,$todos);
   $lotesEnListaDeAjuste = lotesEnListaDeAjuste($suc,$codigo);
   //$includeDistNumber = (count($invLotes) > 0)?" or o.DistNumber in (" . implode(',',$invLotes) . ")" : "";
   $includeDistNumber = (count($invLotes) > 0)?" or (Stock > 0 and o.DistNumber in (" . implode(',',$invLotes) . "))" : "";
   
   // Buscar Lotes Remitidos hacia la Sucursal posterior al Inicio del Inventario
   
   $remitidos = "";
   if(!$todos){
        $rems = "SELECT GROUP_CONCAT(d.lote) AS remitidos FROM nota_remision r, nota_rem_det d WHERE  d.n_nro = r.n_nro AND suc_d = '$suc' and r.estado = 'Cerrada' and r.e_sap = 1 "
                . " AND CONCAT(fecha_cierre,' ',hora_cierre) > '$fecha_limite' AND codigo='$codigo' "; 
        $db = new My();
        $db->Query($rems);
        if($db->NumRows()>0){
           $db->NextRecord();
           $remitidos = $db->Record['remitidos'];      
           $remitidos = str_replace(",","','", $remitidos);
           $remitidos = "'$remitidos'";
        }
   }

   $query = "SELECT o.DistNumber,o.ItemCode,m.ItemName,c.Name,mov.Stock,o.U_fin_pieza,o.U_img, o.U_estado_venta,U_ubic FROM OBTN o INNER JOIN (SELECT i.ItemCode,i1.SysNumber,i.LocCode,min(i.DocDate) as entDate,sum(i1.Quantity) as Stock FROM OITL i INNER JOIN ITL1 i1 ON i.LogEntry=i1.LogEntry group by i.ItemCode,i1.SysNumber,i.LocCode) as mov on o.ItemCode=mov.ItemCode and o.SysNumber = mov.Sysnumber INNER JOIN OITM m on o.ItemCode=m.ItemCode LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code WHERE mov.LocCode like '$suc' AND ((Stock > $filtro_stock) $includeDistNumber ) and o.ItemCode='$codigo' and mov.entDate < CONVERT(DATETIME, '$fecha_limite', 111) and o.DistNumber not in($remitidos)";
   $ms_link->Query($query);
      
   while($ms_link->NextRecord()){
      $line = $ms_link->Record;
      $line['inv'] = in_array($line['DistNumber'],$invLotes)?'Si':'No';
      if($line['U_fin_pieza'] == 'No'){
         $line['U_fin_pieza'] = in_array($line['DistNumber'],$lotesEnListaDeAjuste)?'Si':'No';
      }
      $line = array_map("utf8_encode",$line);
      array_push($respuesta,$line);
   }
   
   
  // array_push($respuesta,array("query"=>$query));
   echo json_encode($respuesta);
}
function avance($suc,$fecha_limite){
   $ms = new MS();
   $db = new My();
   
   $grupos = [
       "A"=>array("grupo"=>"ACTIVOS","invent"=>"","total"=>""),
       "B"=>array("grupo"=>"BASICOS","invent"=>"","total"=>""),
       "C"=>array("grupo"=>"CRUCERO","invent"=>"","total"=>""),
       "H"=>array("grupo"=>"HOGAR","invent"=>"","total"=>""),
       "I"=>array("grupo"=>"INSUMOS","invent"=>"","total"=>""),
       "S"=>array("grupo"=>"SASTRERIA","invent"=>"","total"=>""),
       "T"=>array("grupo"=>"FABRICA","invent"=>"","total"=>"")
    ];   
      
      
   $mysql = "SELECT LEFT(codigo,1) AS grupo, COUNT(DISTINCT lote) AS invent FROM inventario WHERE  suc='$suc'  AND fecha > '$fecha_limite'  GROUP BY grupo";
   $db->Query($mysql);
   while($db->NextRecord()){
       $g = $db->Record['grupo'];
       $invent = $db->Record['invent'];       
       $grupos[$g]["invent"] = $invent;
   }
   
  
   $sql_server = "SELECT left(o.ItemCode,1) as grupo, COUNT(*) as lotes FROM OBTN o INNER JOIN (SELECT i.ItemCode,i1.SysNumber,i.LocCode,min(i.DocDate) as entDate,sum(i1.Quantity) as Stock 
   FROM OITL i INNER JOIN ITL1 i1 ON i.LogEntry=i1.LogEntry group by i.ItemCode,i1.SysNumber,i.LocCode) as mov on o.ItemCode=mov.ItemCode and o.SysNumber = mov.Sysnumber 
   INNER JOIN OITM m on o.ItemCode=m.ItemCode  
   WHERE mov.LocCode like '$suc' AND o.U_fin_pieza <> 'Si' and Stock > 0 
   and o.ItemCode like '%' and mov.entDate < CONVERT(DATETIME, '$fecha_limite', 111) group by left(o.ItemCode,1) ";
   
   $ms->Query($sql_server);
   while($ms->NextRecord()){  
      $g = $ms->Record['grupo'];
      $lotes = $ms->Record['lotes'];       
      $grupos[$g]["total"] = $lotes;
   }
      
   echo json_encode($grupos);
}
// Lotes Pendientes de Inventario
function lotesPendientesDeInventario($suc,$ItmsGrpCod,$fecha_limite){     
   $ms_link = new MS();
   $respuesta = array();   
   $invLotes = lotesInvXFechaLim($suc,listaArticulos($ItmsGrpCod),$fecha_limite);
   
   $includeDistNumber = (count($invLotes) > 0)?" AND (Stock > 0 and o.DistNumber not in (" . implode(',',$invLotes) . "))" : "";

   $query = "SELECT o.DistNumber,o.ItemCode,m.ItemName,c.Name,mov.Stock,o.U_fin_pieza,o.U_img, o.U_estado_venta FROM OBTN o INNER JOIN (SELECT i.ItemCode,i1.SysNumber,i.LocCode,min(i.DocDate) as entDate,sum(i1.Quantity) as Stock FROM OITL i INNER JOIN ITL1 i1 ON i.LogEntry=i1.LogEntry group by i.ItemCode,i1.SysNumber,i.LocCode) as mov on o.ItemCode=mov.ItemCode and o.SysNumber = mov.Sysnumber INNER JOIN OITM m on o.ItemCode=m.ItemCode LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code WHERE mov.LocCode like '$suc' AND o.U_fin_pieza <> 'Si' $includeDistNumber and m.ItmsGrpCod='$ItmsGrpCod' and mov.entDate < CONVERT(DATETIME, '$fecha_limite', 111)";
  //  echo $query;          
   $ms_link->Query($query);

   while($ms_link->NextRecord()){
      $line = $ms_link->Record;
      $line['inv'] = in_array($line['DistNumber'],$invLotes)?'Si':'No';
      if($line['U_fin_pieza'] == 'No'){
         $line['U_fin_pieza'] = in_array($line['DistNumber'],lotesEnListaDeAjuste($suc,$line['ItemCode']))?'Si':'No';
      }
      $line = array_map("utf8_encode",$line);
      array_push($respuesta,$line);
   }
   
   
  // array_push($respuesta,array("query"=>$query));
  echo json_encode($respuesta);
}
// Articulos por codigo de grupo
function listaArticulos($codGrupo){
   $ms = new MS();
   $articulos = array();
   $ms->Query("SELECT ItemCode FROM OITM WHERE ItmsGrpCod = '$codGrupo'");
   while($ms->NextRecord()){
      array_push($articulos, $ms->Record['ItemCode']);
   }
   $articulos = array_map('comillas',$articulos);
   return implode(',',$articulos);
}
function comillas($text){
   return "'$text'";
}

//Lotes Inventariados
function lotesInvXFechaLim($suc,$articulos,$fecha_limite){
   $lotesInventariados = array();
   $my = new My();
   $my->Query("SELECT lote FROM inventario WHERE suc='$suc' AND codigo IN ($articulos) AND fecha >= '$fecha_limite'");
   
   while($my->NextRecord()){
      array_push($lotesInventariados,$my->Record['lote']);
   }
   return $lotesInventariados;
}

function inventariadosXArticuloXsuc($suc,$codigo,$fecha_limite,$todos){
   $link = new My();
   $lotes = array();
   $filtro_todos = "";
   if(!$todos){
      $filtro_todos = " AND fecha > '$fecha_limite' ";
   }
   $link->Query("SELECT distinct(lote) as l from inventario where codigo='$codigo' and suc='$suc' $filtro_todos");
   while($link->NextRecord()){
      array_push($lotes,$link->Record['l']);
   }
   return $lotes;
}



function piezasInventariadasXRangoFecha($user,$suc,$desde,$hasta){
   $link = new My();
   $datos = array();
   $link->Query("SELECT usuario,DATE_FORMAT(date(fecha),'%d-%m-%Y') as fecha,COUNT(*) as inv FROM inventario WHERE usuario='$user' AND suc='$suc' and date(fecha) between '$desde' AND '$hasta' group by suc,year(fecha), month(fecha),day(fecha),usuario");
   while($link->NextRecord()){
       array_push($datos,array_map("utf8_encode",$link->Record));
   }
   echo json_encode($datos);
}


function lotesEnListaDeAjuste($suc, $codigo){
   $link = new My();
   $lotes = array();
   $link->Query("SELECT lote FROM ajustes WHERE e_sap=0 AND f_nro = 0 AND motivo = 'Actualizacion de Inventario FDP' AND tipo = 'Correccion de Stock' AND codigo='$codigo' AND suc='$suc'");
   while($link->NextRecord()){
      array_push($lotes,$link->Record['lote']);
   }
   return $lotes;
}


?>