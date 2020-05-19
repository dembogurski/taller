<?PHP
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_DB_MSSQL.class.php");
require_once("../utils/tbs_class.php");

if(isset($_POST['ex_action'])){
   call_user_func($_POST['ex_action']);
}else{
   $usuario = $_GET['usuario'];
   $CardCode = $_GET['CardCode'];
   $cliente = $_GET['cliente'];
   $ruc = $_GET['ruc_cliente'];
   $desde = $_GET['desde'];
   $hasta = $_GET['hasta'];
   $status = $_GET['estado'];
   $suc = $_GET['suc'];
   $order = "o.DocEntry";//$_GET['order'];
   $db = new MS();
   $det = new MS();
   $reporte = array();
   $sum_saldos = 0;
   $logoURL = ($suc === '00')?'../img/logotipo_corporacion.jpg':'../img/logo_small.png';
   $TBS = new clsTinyButStrong;
   $TBS->LoadTemplate('ExtractoRes.html');
   $h_link = new MS();
   //$h_query = "SELECT o.FolioPref as Tipo,o.FolioNum, o.DocEntry,o.DocNum,o.U_Nro_Interno,o.U_SUC, InstlmntID,i.DueDate,CONVERT(VARCHAR(10), DocDate, 103) DocDate,CONVERT(VARCHAR(10), DueDate, 103) AS DueDateFormat,DATEDIFF(day,DueDate,GETDATE()) AS DiasAtraso,InsTotal, InsTotalFC,Paid,i.PaidFC as PaidFC,FolioNum,DocCur,i.Status, pagos = STUFF((SELECT ' '+CONVERT(varchar(10), r.DocNum) FROM ORCT r INNER JOIN RCT2 r2 ON r.DocNum = r2.DocNum INNER JOIN OINV V ON r2.DocEntry = v.DocEntry WHERE v.DocNum =o.DocNum FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '') FROM OINV o INNER JOIN INV6 i ON o.DocEntry = i.DocEntry WHERE o.GroupNum != -1 and   o.CardCode =  '$CardCode' and i.Status like '$status' and i.DueDate between convert(datetime, '$desde', 103) and convert(datetime, '$hasta', 103) order by $order asc, InstlmntID asc ";
   $h_query = "SELECT o.FolioPref as Tipo,o.FolioNum, o.DocEntry,o.DocNum,o.U_Nro_Interno,o.U_SUC, InstlmntID,i.DueDate, DocDate,CONVERT(VARCHAR(10), DueDate, 103) AS DueDateFormat,DATEDIFF(day,DueDate,GETDATE()) AS DiasAtraso,InsTotal, InsTotalFC,Paid,i.PaidFC as PaidFC,FolioNum,DocCur,i.Status FROM OINV o INNER JOIN INV6 i ON o.DocEntry = i.DocEntry WHERE o.GroupNum != -1 and   o.CardCode =  '$CardCode' and i.Status like '$status' and i.DueDate between convert(datetime, '$desde', 103) and convert(datetime, '$hasta', 103) order by $order asc, InstlmntID asc ";
   
   $h_link->Query($h_query);
   while($h_link->NextRecord()){
      $linea = $h_link->Record;
      $linea['venc'] = ((int)$linea['DiasAtraso'] > 0 && $linea['Status'] == 'O') ? 'venc' : 'ok';
      $linea['pagos'] = listaDocNums($linea['DocNum']);
      $linea['diff'] = (double)$h_link->Record['InsTotal'] - (double)$h_link->Record['Paid'];
      $sum_saldos += $linea['diff']; 
      array_push($reporte,$linea);
   }
   $h_link->Close();
   $TBS->MergeBlock('data','array',$reporte);
   $TBS->Show();
}
function listaDocNums($DocNum){
   $ms = new MS();
   $pagos = "";
   $ms->Query("SELECT r.DocNum FROM ORCT r INNER JOIN RCT2 r2 ON r.DocNum = r2.DocNum INNER JOIN OINV V ON r2.DocEntry = v.DocEntry WHERE v.DocNum =$DocNum");
   while($ms->NextRecord()){
      $pagos .= ' '.$ms->Record['DocNum'];
   }
   $ms->Close();
   return trim($pagos);
}
function detalleMovimientos(){
   $ticket = $_POST['ticket'];
   $cuota = $_POST['cuota'];
   $ms = new MS();
   $reconciliacion = array();
   $reconciliacion_verif = array();

   //$ms->Query("SELECT r1.ReconNum, v.DocEntry, r1.SrcObjTyp,r1.SrcObjAbs,i.InstlmntID FROM OINV v INNER JOIN INV6 i ON v.DocEntry = i.DocEntry AND v.GroupNum != -1 LEFT JOIN OJDT t ON v.DocNum=t.BaseRef AND t.TransType=13 LEFT JOIN ITR1 r1 ON t.TransId = r1.TransId INNER JOIN OITR r ON r1.ReconNum=r.ReconNum WHERE v.U_Nro_Interno='$ticket'");
   $ms->Query("SELECT r1.ReconNum, r1.ShortName, r1.SrcObjTyp,r1.SrcObjAbs, r1.TransId,r1.TransRowId, rr.InstlmntID,rr.DocEntry
   FROM ITR1 r1 INNER JOIN (SELECT r1.ReconNum, i.InstlmntID,v.DocEntry FROM ITR1 r1 INNER JOIN OJDT t on t.TransId = r1.TransId INNER JOIN OINV v ON v.DocNum=t.BaseRef AND v.TransId=t.TransId AND t.TransType=13 INNER JOIN INV6 i ON v.DocEntry = i.DocEntry WHERE v.GroupNum != -1 AND v.U_Nro_Interno= '$ticket') as rr on r1.ReconNum = rr.ReconNum");

   while($ms->NextRecord()){      
      $linea = $ms->Record;
      switch($linea['SrcObjTyp']){
         case 13:// Pagos
         if($linea['SrcObjAbs'] === $linea['DocEntry'] && (int)$cuota === (int)$linea['InstlmntID']){
            $linea['det'] = pagos($linea['SrcObjAbs'],$linea['InstlmntID']);
            if( count($linea['det'])>0 && (!array_key_exists($linea['SrcObjAbs'],$reconciliacion_verif) || $reconciliacion_verif[$linea['SrcObjAbs']] != $linea['TransId']) )  {
               array_push($reconciliacion,$linea);
               $reconciliacion_verif[$linea['SrcObjAbs']] = $linea['TransId'];
            }
         }
         break;
         case 14:// Notas de Credito
         $linea['det'] = (notaCredito($linea['SrcObjAbs']));
         if(count($linea['det'])>0){
            array_push($reconciliacion,$linea);
         }
         break;
      }
   }

   $ms->Close();
   echo json_encode($reconciliacion,JSON_FORCE_OBJECT);
   //print_r($reconciliacion_verif);
   //print_r($reconciliacion);
}

function pagos($DocEntry, $InstlmntID){
   $ms_p = new MS();
   $pg = array();

   $ms_p->Query("SELECT o.DocNum,o.Comments,CONVERT(VARCHAR(10), o.DocDate, 103) DocDate,o.CashSum,o.CreditSum,o.CheckSum,o.TrsfrSum,o.DocTotal,SumApplied  FROM ORCT o, RCT2 r WHERE o.DocNum = r.DocNum AND r.DocEntry = $DocEntry AND r.InstId = $InstlmntID  and o.Canceled != 'Y'");
   while($ms_p->NextRecord()){
      $pago = $ms_p->Record;
      $pago['suc']='';
      $pago['id_pago'] = trim(explode(':',$pago['Comments'])[1]);
      if(strlen($pago['id_pago'])>0){
         $pago['suc'] = obtenerSuc($pago['id_pago']);
      }
      array_push($pg, $pago);
   }
   return $pg;
}

function notaCredito($DocEntry){
   $ms_n = new MS();
   $nc = array();

   $ms_n->Query("SELECT n.DocEntry, CONVERT(VARCHAR(10), n.DocDate, 103) as DocDate, n.DocCur, n.DocTotal, n.Comments, n.U_Nro_Interno, SUM(n1.LineTotal) as total,n1.WhsCode  FROM ORIN n INNER JOIN RIN1 n1 ON n.DocEntry=n1.DocEntry WHERE n.DocEntry = $DocEntry GROUP BY n.DocEntry, n.DocDate, n.DocCur, n.DocTotal, n.Comments, n.U_Nro_Interno,n1.WhsCode");
   while($ms_n->NextRecord()){
      array_push($nc, $ms_n->Record);
   }
   return $nc;
}
// Efectivo
function Cash(){
   $ms_n = new MS();
   $DocNum = $_POST['DocNum'];
   $cheques = array();

   $ms_n->Query("SELECT CONVERT(VARCHAR(10), DueDate, 103) as DueDate, CheckNum, CheckSum,Currency  FROM RCT1 WHERE DocNum=$DocNum");
   while($ms_n->NextRecord()){
      array_push($cheques, $ms_n->Record);
   }
   echo json_encode($cheques, JSON_FORCE_OBJECT);
}
// Tarjeta
function Credit(){
   $ms_n = new MS();
   $DocNum = $_POST['DocNum'];
   $convenio = array();

   $ms_n->Query("SELECT c.CardName as Convenio,r.VoucherNum as Voucher, r.CreditSum as Monto FROM RCT3 r INNER JOIN OCRC c on r.CreditCard = c.CreditCard WHERE r.DocNum = $DocNum");
   while($ms_n->NextRecord()){
      array_push($convenio, $ms_n->Record);
   }
   echo json_encode($convenio, JSON_FORCE_OBJECT);
}
// Cheques
function Check(){
   $ms_n = new MS();
   $DocNum = $_POST['DocNum'];
   $cheques = array();

   $ms_n->Query("SELECT CONVERT(VARCHAR(10), DueDate, 103) as Fecha, CheckNum as Numero, CheckSum as Monto,Currency as Moneda, Branch as Suc  FROM RCT1 WHERE DocNum=$DocNum");
   while($ms_n->NextRecord()){
      array_push($cheques, $ms_n->Record);
   }
   echo json_encode($cheques, JSON_FORCE_OBJECT);
}
// Transferenci bancaria
function Trsfr(){
   $ms_n = new MS();
   $DocNum = $_POST['DocNum'];
   $cheques = array();

   $ms_n->Query("SELECT CONVERT(VARCHAR(10), DueDate, 103) as DueDate, CheckNum, CheckSum,Currency  FROM RCT1 WHERE DocNum=$DocNum");
   while($ms_n->NextRecord()){
      array_push($cheques, $ms_n->Record);
   }
   echo json_encode($cheques, JSON_FORCE_OBJECT);
}

// Sucursal del pago
function obtenerSuc($id_pago){
   $my = new My();
   $suc = '';
   $my->Query("SELECT suc FROM pagos_recibidos WHERE id_pago='$id_pago'");
   if($my->NumRows()>0){
      $my->NextRecord();
      $suc = $my->Record['suc'];
   }else{
      $suc = 'No';
   }
   return $suc;
}

function pagosPorNro(){
   $DocNum = $_REQUEST['DocNum'];
   $ms = new MS();
   $pagos = array();
   $ms->Query("SELECT r2.DocEntry, (v.FolioPref+'-'+CONVERT(varchar(10), v.FolioNum)) as nfolio, CONVERT(VARCHAR(10),v.DocDate,103) as DocDate, v.DocTotal, r2.SumApplied FROM ORCT r INNER JOIN RCT2 r2 ON r.DocNum = r2.DocNum INNER JOIN OINV V ON r2.DocEntry = v.DocEntry WHERE r.DocNum = $DocNum");
   while($ms->NextRecord()){
      array_push($pagos,$ms->Record);
   }
}
?>