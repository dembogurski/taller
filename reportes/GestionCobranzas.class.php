<?php

/**
 * Description of GestionCobranzas
 * @author Ing.Douglas
 * @date 12/08/2017
 */
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_DB_MSSQL.class.php");
require_once("../Y_Template.class.php");

class GestionCobranzas {

    function __construct() {
        $action = $_REQUEST['action'];
        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }
    }

    function main() {
        $TASA_INTERES_PUNITORIA = 27.6;
        $t = new Y_Template("GestionCobranzas.html");


        $desde = $_REQUEST['desde'];
        $hasta = $_REQUEST['hasta'];
        $moneda = $_REQUEST['moneda'];
        $CardCode = $_REQUEST['cliente'];
        $suc = $_REQUEST['select_suc'];
        $tipo = $_REQUEST['tipo'];
        $vendedor = $_REQUEST['usuario'];
                
        
         
        
        if(strlen($desde) == 0){   
            $desde = "01/01/2010";
        }
        if(strlen($hasta) == 0){
            $hasta = "31/12/2030";
        }
        

        $t->Set("suc", $suc);
        $t->Set("desde", $desde);
        $t->Set("hasta", $hasta);
        $t->Set("vendedor", $vendedor);
        $t->Set("tipo", $tipo);

        $t->Show("header");
        $dias_calculo_interes_a_futuro = 0; // Por si las dudas quieren calcular a futuro los intereses 


        $campo_fecha = $_REQUEST['campo_fecha'];
        $usuario = $_REQUEST['user'];

        $hoy = date("d/m/Y");

        $t->Set('time', date("d-m-Y h:i"));
        $t->Set('user', $usuario);
 
        $cuotas = $this->getCuentas($CardCode, $suc, $desde, $hasta, $tipo, $vendedor, $dias_calculo_interes_a_futuro);
         
        $t->Show("head");

        $oldCardName = "";
        $TotalSaldoGeneral = 0;
        $TotalSaldoCliente = 0;
        $TotalInteresesCliente = 0;
        $TotalPagadoCliente = 0;
        
        $old_cli = "";
        
        foreach ($cuotas as $key => $arr) {
            $CardName = $arr['CardName'];
            $U_suc = $arr['U_suc'];
            $Interno = $arr['U_Nro_interno'];
            $DocEntry = $arr['DocEntry'];
            $InstlmntID = $arr['InstlmntID'];
            $DocDate = $arr['DocDate'];
            $DueDate = $arr['DueDate'];
            $DiasAtraso = $arr['DiasAtraso'];
            $InsTotal = $arr['InsTotal'];
            $FolioNum = $arr['FolioNum'];
            $Exonerada = $arr['Exonerada'];
            $pagado = $arr['Paid'];
            $U_vendedor = $arr['U_vendedor'];
            $Phone = $arr['Phone1'];
            $interes = 0;
            $saldo = 0;

            $saldo = $InsTotal - $pagado;
            if ($DiasAtraso > 0 && $Exonerada == "0") {
                $interes = ($saldo * $DiasAtraso * ($TASA_INTERES_PUNITORIA / 100) ) / 365;
            }
            $saldo += $interes;
            
            
            if ($oldCardName != $CardName && $oldCardName != "") {   
                $t->Set("t_intereses", number_format($TotalInteresesCliente, 0, ',', '.'));
                $t->Set("t_saldo", number_format($TotalSaldoCliente, 0, ',', '.'));
                $t->Set("t_pagado", number_format($TotalPagadoCliente, 0, ',', '.'));
                
                $t->Show("vacio");
                $TotalSaldoCliente = 0;
                $TotalInteresesCliente=0;
            }
            $TotalSaldoCliente += 0 + $saldo;
            $TotalInteresesCliente  +=0+ $interes;
            $TotalPagadoCliente  +=0+ $pagado;
            
            $TotalSaldoGeneral+= 0 + $saldo;
            
            $oldCardName = $CardName;



            if ($DiasAtraso > 0) {
                $t->Set("mora", "vencida");
            } else {
                $t->Set("mora", "");
            }
            if($old_cli != $CardName){
                $t->Set("identif_cli", "identif_cli"); 
            }else{
                $t->Set("identif_cli", ""); 
            }
                
            $t->Set("cliente", $CardName);
            $t->Set("phone", $Phone);
            $t->Set("factura", $FolioNum);
            $t->Set("ref", $DocEntry);
            $t->Set("cuota", $InstlmntID);
            $t->Set("suc", $U_suc);
            $t->Set("vendedor", $U_vendedor); 
            $t->Set("fecha", $DocDate);
            $t->Set("fecha_venc", $DueDate);
            $t->Set("dias_mora", $DiasAtraso);
            $t->Set("total_cuota", number_format($InsTotal, 0, ',', '.'));
            $t->Set("interes", number_format($interes, 0, ',', '.'));
            $t->Set("pagado", number_format($pagado, 0, ',', '.'));
            $t->Set("saldo", number_format($saldo, 0, ',', '.'));    
            $old_cli = $CardName;
            $t->Show("data");
        }
        $t->Set("t_intereses", number_format($TotalInteresesCliente, 0, ',', '.'));
                $t->Set("t_saldo", number_format($TotalSaldoCliente, 0, ',', '.'));
                $t->Set("t_pagado", number_format($TotalPagadoCliente, 0, ',', '.'));
        $t->Show("vacio");
        $t->Set("t_saldo_total", number_format($TotalSaldoGeneral, 0, ',', '.'));
        
        
        $t->Show("foot");
        
        $t->Show("historial");
    }

   

    function getCuentas($CardCode, $suc, $desde, $hasta, $tipo, $vendedor, $dias_calculo_interes_a_futuro) {

        $db = new MS();
        $date0 = DateTime::createFromFormat('d/m/Y',  $desde); 
        $desde =  $date0->format('Y-m-d');
        $date1 = DateTime::createFromFormat('d/m/Y',  $hasta); 
        $hasta =  $date1->format('Y-m-d');

        $codigo_vigente = "";
        if ($tipo == "Vencido") {
            $codigo_vigente = " and (DATEDIFF(day,DueDate,GETDATE()) + $dias_calculo_interes_a_futuro) > 0 ";
        } else if ($tipo == "Regular") {
            $codigo_vigente = " and (DATEDIFF(day,DueDate,GETDATE()) + $dias_calculo_interes_a_futuro) <= 0 ";
        } else {
            $codigo_vigente = "";
        }
        $extra_suc = "";
        if($suc == "%"){
            $extra_suc = " or o.U_suc is null";
        }
        
        $extra_vendedor = "";
        if($vendedor == "%"){
            $extra_vendedor = " or o.U_vendedor is null";
        }

        $sql = "SELECT  o.CardName,c.Phone1, o.U_suc,o.U_Nro_interno,o.DocEntry,o.DocNum,o.U_vendedor, InstlmntID,CONVERT(VARCHAR(10), DocDate, 103) DocDate,CONVERT(VARCHAR(10), DueDate, 103) DueDate,DATEDIFF(day,DueDate,GETDATE())  + $dias_calculo_interes_a_futuro AS DiasAtraso,InsTotal, InsTotalFC,Paid,i.PaidFC as PaidFC,FolioNum,DocCur 
        from oinv o, inv6 i, ocrd c where o.CardCode = c.CardCode and  o.DocEntry = i.DocEntry and o.GroupNum != -1 and   o.CardCode like  '$CardCode' and i.Status != 'C' and (o.U_suc like '$suc'  $extra_suc    ) and i.DueDate between '$desde' and '$hasta'  and (o.U_vendedor like '$vendedor'   $extra_vendedor )   $codigo_vigente order by o.CardName asc, i.DueDate asc "; // Solo Credito
          
        
        $cuotas = $this->getResultArrayMSSQL($sql);

        $my = new My();

        for ($i = 0; $i < sizeof($cuotas); $i++) {
            $DocEntry = $cuotas[$i]['DocEntry'];
            $DocNum = $cuotas[$i]['DocNum'];
            $InstlmntID = $cuotas[$i]['InstlmntID'];             
            $vencimiento = date('Y-m-d', strtotime(str_replace('/', '-', $cuotas[$i]['DueDate'])));  // DiasAtrasoFP Es por si pago adelantado 
            $DiasAtrasoInicial = $cuotas[$i]['DiasAtraso'];
            $ultimo_pago = "SELECT top 1 CONVERT(VARCHAR(10), o.DocDate, 103) DocDate,DATEDIFF(day,o.DocDate,GETDATE()) AS DiasAtraso ,DATEDIFF(day,'$vencimiento',o.DocDate) AS DiffPrimerPago  from ORCT o, RCT2 r where o.DocNum = r.DocNum  and r.DocEntry = $DocEntry AND InstId = $InstlmntID and o.Canceled != 'Y' order by r.DocNum desc";
 
            $db->Query($ultimo_pago);

            // Buscar pagos pendientes de sincronizacion

            $pend = "SELECT count(*) as PagosPendientes from pagos_recibidos p, pago_rec_det d where   p.id_pago = d.id_pago and d.sap_doc = $DocNum and id_cuota = $InstlmntID and p.e_sap is null";
            //echo $pend;
            $my->Query($pend);
            if ($my->NumRows() > 0) {
                $my->NextRecord();
                $pendientes = $my->Record['PagosPendientes'];
                $cuotas[$i]['PagosPendientes'] = $pendientes;
            } else {
                $cuotas[$i]['PagosPendientes'] = 0;
            }


            $my->Query("SELECT COUNT(*) AS Cant FROM exoneraciones WHERE DocNum = $DocNum AND InstallmentID = $InstlmntID");
            $my->NextRecord();
            $cant = $my->Record['Cant'];
            if ($cant > 0) {
                $cuotas[$i]['Exonerada'] = "1";
            } else {
                $cuotas[$i]['Exonerada'] = "0";
            }
            
            // Si tiene un Pago mas Reciente ese deber� ser el Ultimo Pago
            if ($db->NumRows() > 0) {
                $db->NextRecord();
                $f_ult_pago = $db->Record['DocDate'];
                $DiasAtraso = $db->Record['DiasAtraso'];
                $DiffPrimerPago = $db->Record['DiffPrimerPago'];


                $cuotas[$i]['DueDate'] = $vencimiento;
                $cuotas[$i]['DiasAtraso'] = $DiasAtraso;

                if ($DiffPrimerPago < 0) {
                    $DiasAtraso = $DiasAtrasoInicial;
                    $cuotas[$i]['DueDate'] = $vencimiento;
                    $cuotas[$i]['DiasAtraso'] = $DiasAtraso;
                }
            }
        }
  
        return $cuotas;
    }
 

    function getResultArrayMSSQL($sql) {
        $db = new MS();
        $array = array();
        $db->Query($sql);
        while ($db->NextRecord()) {
            array_push($array, array_map('utf8_encode', $db->Record));
        }
        $db->Close();
        return $array;
    }

}
 function getHistorial() {
    $DocEntry = $_REQUEST['DocEntry'];
    $InstallmentID = $_REQUEST['InstallmentID'];
    $sql = "SELECT id_hist,sap_doc,id_cuota,usuario,DATE_FORMAT(fecha ,'%d/%m/%y %h:%i') AS fecha,tipo_com,notas,estado FROM historial_seg WHERE sap_doc = $DocEntry AND id_cuota = $InstallmentID ORDER BY id_hist ASC";
    $db = new My();
    $array = array();
    $db->Query($sql);
    while ($db->NextRecord()) {
        array_push($array, $db->Record);
    }
    $db->Close();
    echo json_encode($array);
}
 function getHistorialNumber(){
    $DocEntry = $_REQUEST['DocEntry'];
    $InstallmentID = $_REQUEST['InstallmentID'];
    $sql = "SELECT  count(*) as cant FROM historial_seg WHERE sap_doc = $DocEntry AND id_cuota = $InstallmentID ORDER BY id_hist ASC";
    $db = new My();        
    $db->Query($sql);
    $db->NextRecord();
    $cant = $db->Record['cant'];
    echo $cant;    
 } 
 function guardarSeguimiento(){
     $DocEntry = $_REQUEST['DocEntry'];
     $InstallmentID = $_REQUEST['InstallmentID'];
     $tipo = $_REQUEST['tipo'];
     $usuario = $_REQUEST['usuario'];
     $nota = $_REQUEST['nota'];
     
     $db = new My();
     $sql = "INSERT INTO  historial_seg(sap_doc, id_cuota, usuario, fecha, tipo_com, notas, estado)
     VALUES ($DocEntry, $InstallmentID, '$usuario', CURRENT_TIMESTAMP, '$tipo', '$nota', 'Abierto');";    
     $db->Query($sql);
     echo "Ok";
 }
new GestionCobranzas();
?>