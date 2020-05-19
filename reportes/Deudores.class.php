<?php

/**
 * Description of Deudores
 * @author Ing.Douglas
 * @date 13/07/2017
 */
require_once("..\Y_Template.class.php");
require_once("..\Y_DB_MSSQL.class.php"); 

class OrdenesCompra {
    function __construct() {
        $action = $_REQUEST['action'];          
        if (function_exists($action)) {
            call_user_func($action);
        } else {   
            $this->main();
        }        
    }     
    function main(){
        $t = new Y_Template("Deudores.html");
        $t->Show("header");

        $t->Set("user", $_GET['user']);
        $t->Set("time",date('d-m-Y H:i'));
        
        
        $t->Show("head");

       
        $ms = new MS();
       
        $dia = date("d");
         
        $mess = $arrmeses[date("m")-1];
        $anio = date("Y");
        $fecha = "$dia de $mess del $anio";
        $t->Set("fecha",$fecha);
        $t->Show("cabecera");
        $t->Show("body");

      
        $codigo_cliente = $_REQUEST['codigo_cliente'];
        // echo $codigo_cliente;
        
        $Qry = "SELECT DISTINCT 'FV' as Tipo, o.CardName, o.LicTradNum as RUC, o.DocEntry,o.DocNum,o.U_Nro_Interno as Ticket,o.U_SUC as Suc, InstlmntID as NroCuota,CONVERT(VARCHAR(10), DocDate, 103) FechaFactura,CONVERT(VARCHAR(10),DueDate  , 103) Vencimiento, DATEDIFF(day,DueDate,GETDATE()) AS DiasAtraso, i.InsTotal  as TotalCuota, Paid as Pagado,FolioNum,DocCur,i.Status FROM OINV o, INV6 i WHERE o.CardCode like '$codigo_cliente' and o.DocEntry = i.DocEntry and o.GroupNum != -1  and i.Status like 'O' and i.DueDate between convert(datetime, '01/01/2009', 103) and convert(datetime, '01/01/2020', 103) and DATEDIFF(day,DueDate,GETDATE()) > 0  order by  DiasAtraso asc";
        // echo "$Qry";
        // die();
        $ms->Query($Qry);
        $t->Show("data_cab");
        $total = 0;
        while($ms->NextRecord()){
            $Tipo =  $ms->Record['Tipo'];
            $Nombre =  $ms->Record['CardName'];
            $RUC =  $ms->Record['RUC'];
            $DocEntry =  $ms->Record['DocEntry'];
            $DocNum =  $ms->Record['DocNum'];
            $Ticket = $ms->Record['Ticket'];
            $Suc = $ms->Record['Suc'];
            $NroCuota =  $ms->Record['NroCuota'];
            $FechaFactura =  $ms->Record['FechaFactura'];
            $Vencimiento =  $ms->Record['Vencimiento'];
            $DiasAtraso =  $ms->Record['DiasAtraso'];
            $TotalCuota =  $ms->Record['TotalCuota'];
            $Pagado =  $ms->Record['Pagado'];
            $FolioNum =  $ms->Record['FolioNum'];
            $DocCur =  $ms->Record['DocCur'];
            $Status =  $ms->Record['Status'];
                
           
           
            $t->Set("Tipo",$Tipo);
            $t->Set("Nombre",$Nombre);
            $t->Set("RUC",$RUC);   
            $t->Set("DocEntry",$DocEntry);
            $t->Set("DocNum",$DocNum);
            $t->Set("Ticket",number_format($Ticket,0, ',', '.'));
            $t->Set("Suc", $Suc);
            $t->Set("Suc", $Suc);
            $t->Set("NroCuota",$NroCuota);
            $t->Set("fecha",$FechaFactura);
            $t->Set("Vencimiento",$Vencimiento);
            $t->Set("DiasAtraso",$DiasAtraso);
            $t->Set("TotalCuota",number_format($TotalCuota,0, ',', '.'));
            $t->Set("Pagado",number_format($Pagado,0, ',', '.'));
            $t->Set("FolioNum",$FolioNum);
            $t->Set("DocCur",$DocCur);
            $t->Set("Status",'Pendiente');

            $t->Show("data");
        }

        $t->Show("data_foot");
    }
}

function ultimoPago(){
   $DocNum = $_REQUEST['DocNum'];
   $ultimo  = "SELECT TOP 1 o.DocDate as Fecha,DATEDIFF(day,o.DocDate,GETDATE()) AS dias  FROM ORCT o, RCT2 d WHERE  o.DocNum = d.DocNum AND d.DocNum = $DocNum ORDER BY o.DocDate desc";  
   $ms = new MS();
   $ms->Query($ultimo);       
   if($ms->NumRows()>0){
       $ms->NextRecord();
       $dias = $ms->Record['dias'];
       echo $dias;
   }else{
       echo "---";
   }
}   

new OrdenesCompra();
?>
