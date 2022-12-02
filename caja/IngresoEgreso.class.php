<?php

/**
 * Description of IngresoEgreso
 * @author Ing.Douglas
 * @date 28/04/2017
 */

require_once("../Y_DB_MySQL.class.php");
require_once("../Y_Template.class.php");

class IngresoEgreso {
    function __construct() {
        $action = $_REQUEST['action'];
        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }
    }
    function main(){
        $t = new Y_Template("IngresoEgreso.html");
        $t->Show("header");
        $hoy = date("d/m/Y");
        $t->Set("hoy", $hoy);
        
        $suc =  $_REQUEST['suc'];
        
        $db = new My();
        
        $db->Query("SELECT m_cod AS moneda, m_descri FROM monedas where m_cod != 'Y$'");

        $monedas = "";
        while ($db->NextRecord()) {
            $moneda = $db->Record['moneda'];
            $m_descri = $db->Record['m_descri'];
            $monedas .="<option value='$moneda'>$moneda</option>";
        }
        $t->Set("monedas", $monedas);
        // Sucursales
        
        $db->Query("SELECT id_concepto ,descrip ,tipo FROM conceptos ");
        $conceptos = "";
        while($db->NextRecord()){
            $id = $db->Record['id_concepto'];
            $concepto = $db->Record['descrip'];
            $tipo = $db->Record['tipo'];
            $conceptos.="<option class='concepto' value='$id' data-tipo='$tipo' >$concepto</option>";                         
        }
        $t->Set("conceptos",$conceptos);
        $t->Show("body");
    }
}

function getSaldoSucursal(){
    $suc = $_REQUEST['suc'];
    $moneda = $_REQUEST['moneda'];
    $db = new My();
    $mov = "SELECT SUM(entrada  - salida ) AS saldo FROM efectivo WHERE suc = '$suc' AND m_cod = '$moneda'";
    $db->Query($mov);
    $saldo = 0;
     
    $db->NextRecord();
    $saldo = $db->Get('saldo');
    if(is_null($saldo)){
        $saldo = 0;
    }
     
     
    echo json_encode(array("saldo"=>$saldo));
}

function generarMovimiento(){
    $usuario  = $_REQUEST['usuario'];
    $moneda = $_REQUEST['moneda'];
    $id_concepto = $_REQUEST['concepto'];
    $tipo = $_REQUEST['tipo'];
    $monto = $_REQUEST['monto'];
    $cotiz = $_REQUEST['cotiz'];
    $monto_ref = $_REQUEST['monto_ref'];
    $suc = $_REQUEST['suc'];
    $fecha = $_REQUEST['fecha'];
    $obs = $_REQUEST['obs'];
    $entrada = 0;
    $salida = 0;
    $entrada_ref = 0;
    $salida_ref = 0;
    
    if($tipo == "E"){
        $entrada = $monto;
        $entrada_ref = $monto_ref;
    }else{
        $salida = $monto;
        $salida_ref = $monto_ref;
    }        
    
    $db = new My();
    
    $mov = "INSERT INTO  efectivo( id_concepto,  m_cod, usuario, entrada, salida, cotiz, entrada_ref, salida_ref, fecha_reg, fecha, hora, suc, estado,obs, e_sap)
    VALUES ($id_concepto, '$moneda', '$usuario', $entrada, $salida, $cotiz, $entrada_ref, $salida_ref, CURRENT_DATE, '$fecha', CURRENT_TIME, '$suc', 'Pendiente','$obs', NULL);";
            
    $db->Query($mov);
    
    $db->Query("select id_pago from efectivo where usuario = '$usuario' and id_concepto = $id_concepto order by id_pago desc limit 1");
    if($db->NumRows()>0){
        $db->NextRecord();
        $id_pago = $db->Get('id_pago');
    }
    registrarGasto($id_concepto,$obs,$fecha,$usuario,$salida,$moneda,$suc,$id_pago);
    
    
    echo "Ok";
}

function registrarGasto($id_concepto,$obs,$fecha,$usuario,$valor,$moneda,$suc,$id_pago){
    $db = new My();
    $db->Query("SELECT gasto FROM conceptos WHERE tipo = 'S' AND id_concepto = $id_concepto");
    if($db->NumRows()>0){
        $db->NextRecord();
        $gasto = $db->Get('gasto');
        if($gasto == "Si"){
            $db->Query("INSERT INTO gastos(fecha,hora, suc, usuario, id_concepto, descrip, moneda, valor, tabla_prov, id_tabla)VALUES ( '$fecha', CURRENT_TIME, '$suc', '$usuario', $id_concepto, '$obs', '$moneda', $valor, 'efectivo', $id_pago);");
        }
    }
}


new IngresoEgreso();
?>
