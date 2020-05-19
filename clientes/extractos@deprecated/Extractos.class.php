<?php

/**
 * Description of Extractos
 * @author Ing.Douglas
 * @date 09/02/2017
 */
require_once("..\Y_Template.class.php");
require_once("..\Y_DB_MySQL.class.php");
require_once("..\Y_DB_MSSQL.class.php");

class Extractos {
    function __construct(){
        $action = $_REQUEST['action'];
        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }         
   }
   function main(){
        $t = new Y_Template("Extractos.html");        
        $t->Show("header");
    
        
        $hoy = date("d-m-Y");
        $t->Set("hoy",$hoy);
        $t->Show("body");     
         
   }
}
function verExtracto(){
    $usuario = $_GET['usuario'];
    $CardCode = $_GET['CardCode'];
    $Cliente = $_GET['cliente'];
    $ruc = $_GET['ruc_cliente'];
    $desde = $_GET['desde'];
    $hasta = $_GET['hasta'];
    $status = $_GET['estado'];
    $order = $_GET['order'];
    
    $db = new MS();
    $det = new MS();
    
    
    $sql = "SELECT DISTINCT 'FV' as Tipo, o.DocEntry,o.DocNum,o.U_Nro_Interno,o.U_SUC, InstlmntID,i.DueDate,CONVERT(VARCHAR(10), DocDate, 103) DocDate,CONVERT(VARCHAR(10), DueDate, 103) DueDate,DATEDIFF(day,DueDate,GETDATE()) AS DiasAtraso,InsTotal, InsTotalFC,Paid,i.PaidFC as PaidFC,FolioNum,DocCur,i.Status 
    FROM OINV o, INV6 i WHERE o.DocEntry = i.DocEntry and o.GroupNum != -1 and   o.CardCode =  '$CardCode' and i.Status like '$status' and i.DueDate between convert(datetime, '$desde', 103) and convert(datetime, '$hasta', 103) order by $order asc, InstlmntID asc "; // Solo Credito
    
    
    $db->Query($sql);
      
    $t = new Y_Template("Extractos.html");   
     
    
    
    $t->Set("cliente",$Cliente); 
    $t->Set("ruc",$ruc);
    $t->Set("desde",$desde);
    $t->Set("hasta",$hasta);
    
    
    $t->Set("usuario",$usuario);
    
    $ahora = date("d-m-Y H:i");
    $t->Set("hora",$ahora);
    
    $t->Show("extracto_cab");
    
    $TOTAL_CUOTAS = 0;
    $TOTAL_PAGADO = 0;
    $TOTAL_PAGADO_DET = 0;
    $TOTAL_SUM_APPL_DET = 0;
    
    while($db->NextRecord()){
        $Tipo = $db->Record['Tipo']; 
        $DocEntry = $db->Record['DocEntry']; // No usar este para mostrar
        $U_Nro_Interno = $db->Record['U_Nro_Interno'];
        $DocNum = $db->Record['DocNum'];
        $InstlmntID = $db->Record['InstlmntID'];
        $DocDate = $db->Record['DocDate'];
        $DueDate = $db->Record['DueDate'];
        $DiasAtraso = $db->Record['DiasAtraso'];
        $DocCur = $db->Record['DocCur'];
        $InsTotal = $db->Record['InsTotal'];
        $Paid = $db->Record['Paid'];
        $FolioNum = $db->Record['FolioNum'];
        $Status = $db->Record['Status'];
        $U_SUC = $db->Record['U_SUC']; 
        if($Status == "O"){
            $Status = "Pendiente";
        }else{
            $Status = "Cancelada";
        }
        
        $TOTAL_CUOTAS += 0 + $InsTotal;
        $TOTAL_PAGADO += 0 + $Paid;
        
        $t->Set("Tipo",$Tipo);
        $t->Set("DocEntry",$DocNum."/".$U_Nro_Interno);
        $t->Set("U_SUC",$U_SUC);
        $t->Set("InstlmntID",$InstlmntID);
        $t->Set("FolioNum",$FolioNum);
        $t->Set("DocDate",$DocDate);
        $t->Set("DueDate",$DueDate);
        $t->Set("DiasAtraso",$DiasAtraso);
        $t->Set("DocCur",$DocCur);
        $t->Set("InsTotal",number_format($InsTotal, 0, ',', '.')); 
        $t->Set("Paid",number_format($Paid, 0, ',', '.'));   
        $t->Set("Status",$Status ); 
               
        // Detalle de Pagos
        $TOTAL_SUM_APPL_DET = 0;
        $det->Query("SELECT o.DocNum,o.Comments,CONVERT(VARCHAR(10), o.DocDate, 103) DocDate,o.CashSum,o.CreditSum,o.CheckSum,o.TrsfrSum,o.DocTotal,SumApplied  FROM ORCT o, RCT2 r WHERE o.DocNum = r.DocNum AND r.DocEntry = $DocEntry AND r.InstId = $InstlmntID  and o.Canceled != 'Y' ORDER BY o.DocDate ASC");
        if($det->NumRows() > 0){
            $t->Set("visible","" ); 
            $t->Show("extracto_data"); 
            while($det->NextRecord()){
               $PaimNum = $det->Record['DocNum']; 
               $PaimDate = $det->Record['DocDate'];
               $CashSum = $det->Record['CashSum'];
               $CreditSum = $det->Record['CreditSum'];
               $CheckSum = $det->Record['CheckSum'];
               $TrsfrSum= $det->Record['TrsfrSum'];

               $DocTotal = $det->Record['DocTotal']; 
               $SumApplied = $det->Record['SumApplied'];
               $suc = '';
               $id_pago = trim(explode(':',$det->Record['Comments'])[1]);
               if(strlen($id_pago)>0){
                   $suc = obtenerSuc($id_pago);
               }
               
               $TOTAL_PAGADO_DET += 0 + $SumApplied;
               
               $t->Set("PaimNum",$PaimNum);
               $t->Set("suc",$suc);
               $t->Set("PaimDate",$PaimDate);
               $t->Set("CashSum",number_format($CashSum, 0, ',', '.')); 
               $t->Set("CreditSum",number_format($CreditSum, 0, ',', '.')); 
               $t->Set("CheckSum",number_format($CheckSum, 0, ',', '.')); 
               $t->Set("TrsfrSum",number_format($TrsfrSum, 0, ',', '.')); 
               $t->Set("DocTotal",number_format($DocTotal, 0, ',', '.')); 
               $t->Set("SumApplied",number_format($SumApplied, 0, ',', '.')); 
               $t->Show("extracto_det_pago"); 
            }        
        }else{
            $t->Set("visible","style='display:none'" );
            $t->Show("extracto_data"); 
        }   
        
    }
    $t->Set("total_cuotas",number_format($TOTAL_CUOTAS, 0, ',', '.')); 
    $t->Set("total_pagado",number_format($TOTAL_PAGADO, 0, ',', '.')); 
    $t->Set("saldo",number_format($TOTAL_CUOTAS-$TOTAL_PAGADO, 0, ',', '.')); 
    $t->Set("total_pagado_det",number_format($TOTAL_PAGADO_DET, 0, ',', '.')); 
    $t->Show("totales");
    $t->Show("extracto_foot");
    
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
new Extractos();
?>
