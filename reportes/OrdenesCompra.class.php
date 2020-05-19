<?php

/**
 * Description of OrdenesCompra
 * @author Ing.Douglas
 * @date 13/07/2017
 */
require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php"); 
require_once("../Y_DB_MSSQL.class.php"); 
require_once("../Functions.class.php");

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
        $t = new Y_Template("OrdenesCompra.html");
        $t->Show("header");

        $desde = $_REQUEST['desde'];
        $hasta = $_REQUEST['hasta'];
        $venc= $_REQUEST['venc'];
        $mes = $_REQUEST['mes'];
        $anio = $_REQUEST['anio'];
        $asoc = $_REQUEST['asoc'];
         
        
        $t->Set("mes",  strtoupper($mes));
        $t->Set("anio", $anio);
        $t->Set("vencimiento",$venc);
        $t->Set("desde",$desde);
        $t->Set("hasta",$hasta);
       
        $arrmeses = array("Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre");
       
        $ms = new MS();
        $ms->Query("select CardCode, LicTradNum,CardName from OCRD WHERE CreditCard = $asoc");
        
        if($ms->NumRows()>0){
            $ms->NextRecord();
            $CardCode = $ms->Record['CardCode'];
            $asociacion = $ms->Record['CardName'];
            $ruc = $ms->Record['LicTradNum'];
            $t->Set("ruc",$ruc);
            $t->Set("asoc",$asociacion);
        }else{            
            $t->Set("error","Asociacion No relacionada a Cliente, Busque el Cliente en SAP y asocicie la Tarjeta de Credito con este Convenio en la Pesta&ntilde;a Condiciones de Pago");
            $t->Show("error");
            die();
        }        
        $dia = date("d");
         
        $mess = $arrmeses[date("m")-1];
        $anio = date("Y");
        $fecha = "$dia de $mess del $anio";
        $t->Set("fecha",$fecha);
        $t->Show("cabecera");
        $t->Show("body");
        
        $Qry = "SELECT ImportEnt, U_ord_cliente,U_ord_valor, o.DocEntry,o.DocNum,o.U_Nro_Interno,o.U_SUC, InstlmntID,(select count(InstlmntID) from INV6 in6 where  in6.DocEntry = i.DocEntry ) as CantCuotas,
               (select sum(InsTotal) from INV6 in6 where  in6.DocEntry = i.DocEntry and in6.Status like 'O') as Saldo,
               i.DueDate,CONVERT(VARCHAR(10), DocDate, 103) DocDate,CONVERT(VARCHAR(10), DueDate, 103) DueDate,DATEDIFF(day,DueDate,GETDATE()) AS DiasAtraso,
               InsTotal - Paid as InsTotal, InsTotalFC,Paid  
               FROM OINV o, INV6 i WHERE o.DocEntry = i.DocEntry and o.GroupNum != -1 and   o.CardCode =  '$CardCode' and i.Status like 'O' and i.DueDate between '$desde' and '$hasta' order by o.DocNum, InstlmntID asc";
        
        $ms->Query($Qry);
        $t->Show("data_cab");
        $total = 0;
        while($ms->NextRecord()){
            $Nro_orden =  $ms->Record['ImportEnt'];
            $Cliente =  $ms->Record['U_ord_cliente'];
            $Valor_orden =  $ms->Record['U_ord_valor'];
            $Nro_cuota =  $ms->Record['InstlmntID'];
            $DueDate =  $ms->Record['DueDate'];
            $Cant_cuotas =  $ms->Record['CantCuotas'];
            $cuota = "$Nro_cuota de $Cant_cuotas";
            $InsTotal =  $ms->Record['InsTotal'];
            $Saldo =  $ms->Record['Saldo'];
            $SaldoReal = $Saldo - $InsTotal; 
            $total +=0 + $InsTotal;
            $t->Set("Nro_orden",$Nro_orden);
            $t->Set("Cliente",$Cliente);
            $t->Set("Valor_orden",number_format($Valor_orden, 0, ',', '.'));   
            $t->Set("cuota",$cuota);
            $t->Set("fecha_venc",$DueDate);
            $t->Set("importe",number_format($InsTotal, 0, ',', '.')); 
            $t->Set("saldo",number_format($SaldoReal, 0, ',', '.')); 
            $t->Show("data");
        }
        $comision = $total * 5 / 100;
        $t->Set("total_bruto",number_format($total, 0, ',', '.')); 
        $t->Set("comision",number_format($comision, 0, ',', '.')); 
        $t->Set("total_pagar",number_format($total - $comision, 0, ',', '.')); 
        
        $t->Show("data_foot");
    }
}

function x(){
    
}   

new OrdenesCompra();
?>
