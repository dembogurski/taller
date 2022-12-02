<?php

 
/**
 * Description of Estadisticas
 *
 * @author DELL I5
 */
require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php"); 
require_once("../Functions.class.php"); 

class Estadisticas {
    function __construct() {
        $action = $_REQUEST['action'];          
        if (function_exists($action)) {
            call_user_func($action);
        } else {   
            $this->main();
        }        
    }     
    function main(){
        $t = new Y_Template("Estadisticas.html");
        $t->Show("header");

        $t->Set("user", $_GET['user']);
        $t->Set("time",date('d-m-Y H:i')); 
        
        $t->Show("head"); 
        $t->Show("body"); 
    }
     
}

function getTotalVentas(){
    $suc = $_REQUEST['suc'];
    $usuario = $_REQUEST['usuario'];
    $desde = $_REQUEST['desde'];
    $hasta = $_REQUEST['hasta'];
    $moneda = $_REQUEST['moneda'];
    
    // Al multiplicar el total por la cotizacion ya no hace falta filtrar por moneda todo convierte a la moneda del sistema.
    $f = new Functions();
    $sql = "SELECT SUM(total * cotiz) AS total FROM factura_venta WHERE fecha_cierre BETWEEN '$desde' AND '$hasta' AND estado = 'Cerrada' and suc = '$suc';";
    echo json_encode($f->getResultArray($sql));        
}
    
function getTotalGastos(){
    $suc = $_REQUEST['suc'];
    $usuario = $_REQUEST['usuario'];
    $desde = $_REQUEST['desde'];
    $hasta = $_REQUEST['hasta'];
    $moneda = $_REQUEST['moneda'];
    
    // Al multiplicar el total por la cotizacion ya no hace falta filtrar por moneda todo convierte a la moneda del sistema.
    $f = new Functions();
    $sql = "SELECT SUM(valor) AS total FROM gastos WHERE fecha  BETWEEN'$desde' AND '$hasta'  AND suc = '$suc'  ;";
    echo json_encode($f->getResultArray($sql)); 
}

function getDatosVentas(){
    $suc = $_REQUEST['suc'];
    $usuario = $_REQUEST['usuario'];
    $desde = $_REQUEST['desde'];
    $hasta = $_REQUEST['hasta'];
    $moneda = $_REQUEST['moneda'];
    $id_menu = $_REQUEST['id_menu'];
    
    // Al multiplicar el total por la cotizacion ya no hace falta filtrar por moneda todo convierte a la moneda del sistema.
    $f = new Functions();
    
    
    switch ($id_menu) {
    case "diario":
        $sql = "SELECT LEFT(hora_cierre,2) AS label, SUM(total) AS valor   FROM factura_venta WHERE fecha_cierre BETWEEN '$desde' AND '$hasta'  AND suc = '$suc' and estado = 'Cerrada' GROUP BY fecha_cierre, label ORDER BY fecha_cierre ASC, label ASC  ;";
        break;
    case "semanal":
        $sql = "SELECT DATE_FORMAT(fecha_cierre,'%d') AS label, SUM(total) AS valor   FROM factura_venta WHERE fecha_cierre BETWEEN '$desde' AND '$hasta'  AND suc = '$suc' and estado = 'Cerrada' GROUP BY label ORDER BY  label ASC  ;";
        break;
    case "mensual":
        $sql = "SELECT DATE_FORMAT(fecha_cierre,'%d-%M') AS label, SUM(total) AS valor   FROM factura_venta WHERE fecha_cierre BETWEEN '$desde' AND '$hasta'  AND suc = '$suc' and estado = 'Cerrada' GROUP BY label ORDER BY  label ASC  ;";
        break;
    case "anual":
        $sql = "SELECT DATE_FORMAT(fecha_cierre,'%d-%M') AS label, SUM(total) AS valor   FROM factura_venta WHERE fecha_cierre BETWEEN '$desde' AND '$hasta'  AND suc = '$suc' and estado = 'Cerrada' GROUP BY label ORDER BY label ASC  ;";
        break;
    default :
        $sql = "SELECT DATE_FORMAT(fecha_cierre,'%M') AS label, SUM(total) AS valor   FROM factura_venta WHERE fecha_cierre BETWEEN '$desde' AND '$hasta'  AND suc = '$suc' and estado = 'Cerrada' GROUP BY   label ORDER BY label ASC  ;";
        break;
    }
    echo json_encode($f->getResultArray($sql)); 
}

function getDatosGastos(){
    $suc = $_REQUEST['suc'];
    $usuario = $_REQUEST['usuario'];
    $desde = $_REQUEST['desde'];
    $hasta = $_REQUEST['hasta'];
    $moneda = $_REQUEST['moneda'];
    $id_menu = $_REQUEST['id_menu'];
    
    // Al multiplicar el total por la cotizacion ya no hace falta filtrar por moneda todo convierte a la moneda del sistema.
    $f = new Functions();
    
    
    switch ($id_menu) {
    case "diario":
        $sql = "SELECT LEFT(hora,2) AS label, SUM(valor) AS valor   FROM gastos WHERE fecha BETWEEN '$desde' AND '$hasta'  AND suc = '$suc'   GROUP BY fecha, label ORDER BY fecha ASC, label ASC  ;";
        break;
    case "semanal":
        $sql = "SELECT DATE_FORMAT(fecha,'%d') AS label, SUM(valor) AS valor   FROM gastos WHERE fecha BETWEEN '$desde' AND '$hasta'  AND suc = '$suc'   GROUP BY label ORDER BY  label ASC  ;";
        break;
    case "mensual":
        $sql = "SELECT DATE_FORMAT(fecha,'%d-%M') AS label, SUM(valor) AS valor   FROM gastos WHERE fecha BETWEEN '$desde' AND '$hasta'  AND suc = '$suc'   GROUP BY label ORDER BY  label ASC  ;";
        break;
    case "anual":
        $sql = "SELECT DATE_FORMAT(fecha,'%d-%M') AS label, SUM(valor) AS valor   FROM gastos WHERE fecha BETWEEN '$desde' AND '$hasta'  AND suc = '$suc'   GROUP BY label ORDER BY  label ASC  ;";
        break;
    default :
        $sql = "SELECT DATE_FORMAT(fecha,'%M') AS label, SUM(valor) AS valor   FROM gastos WHERE fecha BETWEEN '$desde' AND '$hasta'  AND suc = '$suc'   GROUP BY fecha, label ORDER BY label ASC  ;";
        break;
    }
    echo json_encode($f->getResultArray($sql)); 
}

function getCuentasPorCobrar(){
    $suc = $_REQUEST['suc'];
    $usuario = $_REQUEST['usuario'];
    $desde = $_REQUEST['desde'];
    $hasta = $_REQUEST['hasta'];
    $Qry = "SELECT SUM(valor_total) AS valor_total,SUM(saldo) as saldo, SUM(valor_total - saldo) AS pagado FROM factura_venta f, cuotas c WHERE f.f_nro = c.f_nro AND vencimiento BETWEEN '$desde' AND '$hasta' and f.suc = '$suc'";
    $f = new Functions();
    echo json_encode($f->getResultArray($Qry)); 
}

function getClientesPorCobrar(){
    $suc = $_REQUEST['suc'];
    $usuario = $_REQUEST['usuario'];
    $desde = $_REQUEST['desde'];
    $hasta = $_REQUEST['hasta'];
    $Qry = "SELECT COUNT(DISTINCT f.cod_cli) AS clientes_deudores FROM factura_venta f INNER JOIN cuotas c ON f.f_nro = c.f_nro AND vencimiento BETWEEN '$desde' AND '$hasta' and f.suc = '$suc'";
    $f = new Functions();
    
    $clientes_deudores = $f->getResultArray($Qry)[0]['clientes_deudores'];
    
    $Qry = "SELECT COUNT(DISTINCT  cod_cli) AS clientes_cobrados FROM pagos_recibidos p, pago_rec_det d, cuotas c WHERE p.id_pago = d.id_pago AND p.fecha  BETWEEN '$desde' AND '$hasta' AND  p.suc = '$suc' AND d.factura  AND d.factura = c.f_nro AND d.id_cuota = c.id_cuota";
    $f = new Functions();
    
    $clientes_cobrados = $f->getResultArray($Qry)[0]['clientes_cobrados'];
    
       
    echo json_encode(array("clientes_deudores"=>$clientes_deudores,"clientes_cobrados"=>$clientes_cobrados)); 
}

function getProductosMasVendidos(){
    $suc = $_REQUEST['suc'];
    $usuario = $_REQUEST['usuario'];
    $desde = $_REQUEST['desde'];
    $hasta = $_REQUEST['hasta'];
    $Qry = "SELECT a.descrip AS producto,SUM(d.cantidad) AS cantidad, a.img FROM factura_venta f INNER JOIN fact_vent_det d ON f.f_nro = d.f_nro INNER JOIN  articulos a ON d.codigo = a.codigo   AND f.fecha_cierre 
    BETWEEN '$desde' AND '$hasta' and f.suc = '$suc' GROUP BY d.codigo ORDER BY cantidad DESC limit 10";
    $f = new Functions();
    echo json_encode($f->getResultArray($Qry)); 
}
function getProductosMasMargen(){
    $suc = $_REQUEST['suc'];
    $usuario = $_REQUEST['usuario'];
    $desde = $_REQUEST['desde'];
    $hasta = $_REQUEST['hasta'];
    $Qry = "SELECT a.descrip AS producto , SUM(d.subtotal) - SUM( precio_costo)  AS margen  FROM factura_venta f INNER JOIN fact_vent_det d ON f.f_nro = d.f_nro INNER JOIN  articulos a ON d.codigo = a.codigo   AND f.fecha_cierre   BETWEEN '$desde' AND '$hasta' and f.suc = '$suc' GROUP BY d.codigo ORDER BY margen DESC limit 10";
    $f = new Functions();
    echo json_encode($f->getResultArray($Qry)); 
}
 
new Estadisticas();
?>