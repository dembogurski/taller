<?php

/**
 * Description of Extractos
 * @author Ing.Douglas
 * @date 09/02/2017
 */
require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");


class ExtractoCliente {

    function __construct() {
        $action = $_REQUEST['action'];
        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }
    }

    function main() {
        $t = new Y_Template("ExtractoCliente.html");
        $t->Show("header");


        $hoy = date("d-m-Y");
        $t->Set("hoy", $hoy);
        $t->Show("body");
    }

}

function verExtracto() {
    $usuario = $_GET['usuario'];
    $CardCode = $_GET['CardCode'];
    $Cliente = $_GET['cliente'];
    $ruc = $_GET['ruc_cliente'];
    $desde = $_GET['desde'];
    $hasta = $_GET['hasta'];
    $moneda = $_GET['moneda'];
    $status = $_GET['estado'];
    $order = $_GET['order'];
    $vista_cliente = $_GET['vista_cliente'];

    $desde_unformat = DateTime::createFromFormat('d-m-Y', $desde);
    $desde_eng = $desde_unformat->format('Y-m-d');

    $hasta_unformat = DateTime::createFromFormat('d-m-Y', $hasta);
    $hasta_eng = $hasta_unformat->format('Y-m-d');


    $db = new My();
    $pi = new My();
    $det = new My();
    $rec = new My();
    $sub = new My();

    $sql = "SELECT 'FV' AS Tipo, f.f_nro AS TicketInterno,c.id_cuota,f.fact_nro AS Factura, f.suc,DATE_FORMAT(c.vencimiento,'%d/%m/%Y') AS vencimiento,DATE_FORMAT(f.fecha_cierre,'%d/%m/%Y') AS fecha_fac, DATEDIFF(CURRENT_DATE, IF( c.fecha_ult_pago >= c.vencimiento ,c.fecha_ult_pago, c.vencimiento) ) AS DiasAtraso, c.monto,c.moneda, c.cotiz,c.monto_ref,c.saldo,c.estado  FROM factura_venta f, cuotas c WHERE f.f_nro = c.f_nro AND f.cod_cli = '$CardCode' AND f.moneda = '$moneda' AND c.estado LIKE '$status'  AND c.vencimiento BETWEEN '$desde_eng' AND '$hasta_eng'";

    //echo $sql;
    $db->Query($sql);

    $t = new Y_Template("ExtractoCliente.html");
    //$t->Show("header");
    $t->Set("tipo_vista", "vista_normal");
    if ($vista_cliente == "true") {
        $t->Set("tipo_vista", "vista_cliente");
    }


    $t->Set("cliente", $Cliente);
    $t->Set("ruc", $ruc);
    $t->Set("desde", $desde);
    $t->Set("hasta", $hasta);


    $t->Set("usuario", $usuario);

    $ahora = date("d-m-Y H:i");
    $t->Set("hora", $ahora);

    $t->Show("extracto_cab");

    $TOTAL_CUOTAS = 0;
    $TOTAL_PAGADO = 0;
    $TOTAL_PAGADO_DET = 0;
    $TOTAL_SUM_APPL_DET = 0;


    $filas = $db->NumRows();

    //echo "Filas $filas<br>";


    while ($db->NextRecord()) {
        //$Tipo = $db->Record['Tipo']; 

        $TicketInterno = $db->Record['TicketInterno'];
        $Cuota = $db->Record['id_cuota'];
        $Fecha_Fac = $db->Record['fecha_fac'];
        $Vencimiento = $db->Record['vencimiento'];
        $DiasAtraso = $db->Record['DiasAtraso'];
        $Moneda = $db->Record['moneda'];
        $Monto = $db->Record['monto'];
        $Saldo = $db->Record['saldo'];
        $Estado = $db->Record['estado'];
        
        
        
        $entrega_inmediata = 0;
        
        
        
        if($Cuota == 1){        
            $pagos_inmediatos = "SELECT SUM( IF(entrada-salida IS NULL, 0, entrada-salida )) + SUM( IF(monto IS NULL,0, monto)) + SUM( IF(t.valor IS NULL,0, t.valor)) AS entrega_inmediata FROM factura_venta p LEFT JOIN efectivo e ON e.f_nro = p.f_nro    LEFT JOIN convenios c ON c.f_nro = p.f_nro    LEFT JOIN cheques_ter t ON t.f_nro = p.f_nro WHERE p.f_nro =  $TicketInterno;";

            $pi->Query($pagos_inmediatos); 
            $pi->NextRecord();
            $entrega_inmediata = $pi->Get('entrega_inmediata');
                       
        }

        $Pagado = ($Monto + $entrega_inmediata) - $Saldo;

        $Factura = $db->Record['Factura'];
        $estado = $db->Record['estado'];
        $suc = $db->Record['suc'];
        if ($Estado == "Cancelada") {
            $DiasAtraso = 0;
        }
        if ($DiasAtraso > 0) {
            $t->Set("atrasado", "atrasado");
        } else {
            $t->Set("atrasado", "");
        }
        
        $InsTotal = $Monto + $entrega_inmediata;
        
        $TOTAL_CUOTAS += 0 + $InsTotal;
        $TOTAL_PAGADO += 0 + $Pagado;
        
        

        $t->Set("DocEntry", $TicketInterno);
        $t->Set("U_SUC", $suc);
        $t->Set("InstlmntID", $Cuota);
        $t->Set("FolioNum", $Factura);
        $t->Set("DocDate", $Fecha_Fac);
        $t->Set("DueDate", $Vencimiento);
        $t->Set("DiasAtraso", $DiasAtraso);
        $t->Set("DocCur", $Moneda);
        $t->Set("InsTotal", number_format($InsTotal, 0, ',', '.'));
        $t->Set("Paid", number_format($Pagado, 0, ',', '.'));
        $t->Set("Saldo", number_format($Saldo, 0, ',', '.'));
        $t->Set("Estado", $Estado);

        // Detalle de Pagos
        $TOTAL_SUM_APPL_DET = 0;
        
         
 
        
        $t->Show("extracto_data");
         
 
        }
        $t->Set("total_cuotas", number_format($TOTAL_CUOTAS, 0, ',', '.'));
        $t->Set("total_pagado", number_format($TOTAL_PAGADO, 0, ',', '.'));
        $t->Set("saldo", number_format($TOTAL_CUOTAS - $TOTAL_PAGADO, 0, ',', '.'));
        $t->Set("total_pagado_det", number_format($TOTAL_PAGADO_DET, 0, ',', '.'));
        $t->Show("totales");
        $t->Show("extracto_foot");
    
}

    new ExtractoCliente();
?>
