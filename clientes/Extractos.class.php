<?php

/**
 * Description of Extractos
 * @author Ing.Douglas
 * @date 09/02/2017
 */
require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_DB_MSSQL.class.php");

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
    $vista_cliente = $_GET['vista_cliente'];  
    
    
    $db = new MS();
    $det = new MS();
    $rec = new MS();
    $sub = new MS();
    
    $sql = "SELECT DISTINCT 'FV' as Tipo, o.DocEntry,o.DocNum,o.U_Nro_Interno,o.U_SUC, InstlmntID,i.DueDate,CONVERT(VARCHAR(10), DocDate, 103) DocDate,CONVERT(VARCHAR(10), DueDate, 103) DueDate,DATEDIFF(day,DueDate,GETDATE()) AS DiasAtraso,InsTotal, InsTotalFC,Paid,i.PaidFC as PaidFC,FolioNum,DocCur,i.Status 
    FROM OINV o, INV6 i WHERE o.DocEntry = i.DocEntry and o.GroupNum != -1 and   o.CardCode =  '$CardCode' and i.Status like '$status' and i.DueDate between convert(datetime, '$desde', 103) and convert(datetime, '$hasta', 103) order by $order asc, InstlmntID asc "; // Solo Credito
    
    
    $db->Query($sql);
      
    $t = new Y_Template("Extractos.html");
    //$t->Show("header");
    $t->Set("tipo_vista","vista_normal");
    if($vista_cliente == "true"){
        $t->Set("tipo_vista","vista_cliente");
    }  
    
    
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
        $Saldo = $InsTotal - $Paid;
        $FolioNum = $db->Record['FolioNum'];
        $Status = $db->Record['Status'];
        $U_SUC = $db->Record['U_SUC']; 
        if($Status == "O"){
            $Status = "P";
        }else{
            $Status = "C";
            $DiasAtraso = 0;            
        }
        if($DiasAtraso > 0){
            $t->Set("atrasado","atrasado");
        }else{
            $t->Set("atrasado","");
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
        $t->Set("Saldo",number_format($Saldo, 0, ',', '.'));   
        $t->Set("Status",$Status ); 
               
        // Detalle de Pagos
        $TOTAL_SUM_APPL_DET = 0;
        $det->Query("SELECT o.DocNum,o.Comments,CONVERT(VARCHAR(10), o.DocDate, 103) DocDate,o.CashSum,o.CreditSum,o.CheckSum,o.TrsfrSum,o.DocTotal,SumApplied,CounterRef as Recibo  FROM ORCT o, RCT2 r WHERE o.DocNum = r.DocNum AND r.DocEntry = $DocEntry AND r.InstId = $InstlmntID  and o.Canceled != 'Y' ORDER BY o.DocDate ASC");
        $filas = $det->NumRows();
        if($filas > 0){
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
               $Recibo= $det->Record['Recibo'];
               
               $suc = '';
               $id_pago = trim(explode(':',$det->Record['Comments'])[1]);
               if(strlen($id_pago)>0){
                   $suc = obtenerSuc($id_pago);
               }
                
               $TOTAL_PAGADO_DET += 0 + $SumApplied;
               
               $t->Set("PaimNum",$PaimNum);
               $t->Set("suc",$suc);
               $t->Set("Recibo",$Recibo);
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
         
        $nc = "SELECT distinct r1.ReconNum,r1.SrcObjAbs as OrinNo,  rr.DocEntry, CONVERT(VARCHAR(10), rr.DocDate, 103) DocDate , r1.ShortName as CardCode, r1.SrcObjTyp, r1.TransId,  rr.InstlmntID as Cuota,rr.DocTotal,rr.ReconSum
                  FROM ITR1 r1 INNER JOIN (SELECT r1.ReconNum, i.InstlmntID,v.DocEntry,v.DocDate,v.DocTotal,r1.ReconSum FROM ITR1 r1 INNER JOIN OJDT t on t.TransId = r1.TransId INNER JOIN OINV
                  v ON v.DocNum=t.BaseRef AND v.TransId=t.TransId AND t.TransType=13 INNER JOIN INV6 i ON v.DocEntry = i.DocEntry WHERE v.GroupNum != -1 AND  v.DocEntry = $DocEntry  ) as rr 
                  on r1.ReconNum = rr.ReconNum and rr.InstlmntID = $InstlmntID and r1.SrcObjTyp = 14";
        
          $rec->Query($nc);
           /*
          if($U_Nro_Interno == 77987  && $InstlmntID == 1){  
             echo "$DocNum -$U_Nro_Interno  <br><br>$nc<br><br>";
          } */
        
         if($rec->NumRows() > 0){
             
            $show_cab = false; 
              
            while($rec->NextRecord()){
               $ReconNum = $rec->Record['ReconNum']; 
               $OrinNo = $rec->Record['OrinNo']; 
               $DocDate = $rec->Record['DocDate']; 
               $ReconSum = $rec->Record['ReconSum']; 
               
               // Verifico si le corresponde a esta cuota
               $subq = "SELECT   o.Total ,o.ReconDate,i.TransId,i.TransRowId,i.SrcObjTyp,i.SrcObjAbs, i.ReconSum,j.SourceLine AS Cuota FROM   OITR o  INNER join ITR1 i on o.ReconNum = i.ReconNum
               LEFT JOIN JDT1 j ON i.TransId = j.TransId AND j.Line_ID = i.TransRowId 
               WHERE i.SrcObjAbs = $DocEntry AND i.SrcObjTyp = 13 AND j.SourceLine = $InstlmntID AND o.ReconNum = $ReconNum";
               
                /*
               if($U_Nro_Interno == 77987 && $InstlmntID == 1){
                   echo "$DocNum -$U_Nro_Interno  <br><br>$subq<br><br>";
               } 
               */
               $sub->Query($subq);
               
               if($sub->NumRows()> 0){
                   $sub->NextRecord(); 
                   $DocTotal = $sub->Record['Total']; 
                   $t->Set("visible","" ); 
                   $t->Set("info_nc","");
                   if($ReconSum < 0){
                       $t->Set("info_nc","Anulacion de la anterior");
                   }
                   
                   if(!$show_cab){
                       $t->Show("extracto_data_nc"); 
                       $show_cab= true;
                   }
                   $t->Set("OrinNo",$OrinNo);
                   $t->Set("OrinDate",$DocDate);               
                   $t->Set("total_nc",number_format($DocTotal, 0, ',', '.')); 
                   $t->Set("reconciliado",number_format($ReconSum, 0, ',', '.')); 
                   $t->Show("nc_det_pago"); 
                }
               
            }
         }else{
            $t->Set("visible","style='display:none'" );
            //$t->Show("extracto_data"); 
        }
        $t->Show("separador"); 
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
    $q = "SELECT suc FROM pagos_recibidos WHERE id_pago= '$id_pago';";
    $my->Query($q);
    if($my->NumRows()>0){
       $my->NextRecord();
       $suc = $my->Record['suc'];
    }else{
       $suc = 'No'; 
    }
    $my->Close();
    return $suc;
 }
new Extractos();
?>
