<?php

/**
 * Description of Depositos
 * @author Ing.Douglas
 * @date 08/10/2015
 */
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_Template.class.php");

//require_once("../Functions.class.php");

class Depositos {

    function __construct() {
        $action = $_REQUEST['action'];
        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }
    }

    function main() {

        $t = new Y_Template("Depositos.html");
        $t->Show("header");

        $t->Set("hoy", date("d-m-Y"));
        $db = new My();

        $db->Query("SELECT id_concepto ,descrip ,tipo FROM conceptos WHERE tipo = 'S' ORDER BY descrip ASC");
        $conceptos = "";
        while($db->NextRecord()){
            $id = $db->Record['id_concepto'];
            $concepto = $db->Record['descrip'];
            $tipo = $db->Record['tipo'];
            $conceptos.="<option class='concepto' value='$id' data-tipo='$tipo' >$concepto</option>";                         
        }
        $t->Set("conceptos",$conceptos);
        
        
        $db->Query("SELECT distinct b.id_banco,b.nombre FROM bancos b, bcos_ctas c WHERE b.id_banco = c.id_banco ORDER BY b.nombre ASC");
        $bancos = "";
        while ($db->NextRecord()) {
            $id_banco = $db->Record['id_banco'];
            $nombre = $db->Record['nombre'];
            $bancos.="<option value='$id_banco' >$nombre</option>";
        }
        $t->Set("bancos", $bancos);
        
        
        

        $db->QUERY("SELECT  b.id_banco,b.nombre,cuenta,m_cod as moneda FROM bancos b, bcos_ctas c WHERE b.id_banco = c.id_banco ORDER BY b.nombre ASC");
        $cuentas = "";
        $i = 0;
        while ($db->NextRecord()) {
            $id_banco = $db->Record['id_banco'];
            $moneda = $db->Record['moneda'];
            $cuenta = $db->Record['cuenta'];
            $cuentas.="<option  class='cta_$id_banco' value='$cuenta' data-moneda='$moneda' >$cuenta - $moneda</option>";
            $i++;
        }
        $t->Set("cuentas", $cuentas);
        $t->Show("form");
    }

}
function getUltimoIdMov(){
    $sql = "SELECT MAX(id_mov) + 1 AS id_mov FROM  bcos_ctas_mov ";
    $db = new My();
    $db->Query($sql);
    $db->NextRecord();
    $id_mov = $db->Record['id_mov'];
    echo json_encode(array("id_mov"=>$id_mov));
}
function getEfectivo() {
    $suc = $_REQUEST['suc'];
    $fecha = $_REQUEST['fecha'];
    $moneda = $_REQUEST['moneda'];
    $sql = "select sum(entrada - salida) as Efectivo from efectivo where suc = '$suc'  and m_cod = '$moneda'";
    
    $db = new My();
    $db->Query($sql);
    $efectivo = 0;
    if ($db->NumRows() > 0) {
        $db->NextRecord();
        $efectivo = $db->Record['Efectivo'];
        if ($efectivo == null) {
            $efectivo = 0;
        }
    }
    echo json_encode(Array('Efectivo' => $efectivo));
}

function getSaldoCuenta() {
     
    $id_banco = $_REQUEST['id_banco'];
    $cuenta = $_REQUEST['cuenta'];
    $sql = "SELECT SUM(entrada - salida) AS saldo FROM bcos_ctas_mov WHERE id_banco = '$id_banco' AND cuenta = '$cuenta'";
    
    $db = new My();
    $db->Query($sql);
    $saldo = 0;
    if ($db->NumRows() > 0) {
        $db->NextRecord();
        $saldo = $db->Record['saldo'];
        if ($saldo == null) {
            $saldo = 0;
        }
    }
    echo json_encode(Array('saldo' => $saldo));
}

function getDepositos() {
    $suc = $_REQUEST['suc'];
    $desde = $_REQUEST['desde'];
    $hasta = $_REQUEST['hasta'];
    $moneda  = $_REQUEST['moneda'];
    $banco = $_REQUEST['banco'];
    $cuenta = $_REQUEST['cuenta'];
    
    $sql = "SELECT m.id_banco,b.nombre,m.cuenta,DATE_FORMAT(fecha,'%d-%m-%Y') AS fecha,hora,suc,m.id_concepto,c.descrip AS concepto, entrada,salida,m.estado 
        FROM bancos b, bcos_ctas_mov m, conceptos c, bcos_ctas bc WHERE b.id_banco  = '$banco' and bc.cuenta = '$cuenta' and b.id_banco = m.id_banco AND m.id_concepto = c.id_concepto AND fecha between '$desde' and '$hasta'
        AND suc = '$suc' and bc.m_cod = '$moneda' and bc.cuenta = m.cuenta";
    $db = new My();
    $array = array();
    $db->Query($sql);
    while ($db->NextRecord()) {
        array_push($array, $db->Record);
    }
    echo json_encode($array);
}
//id_banco:id_banco,cuenta:cuenta, fecha: fecha,moneda:moneda,efectivo:efectivo,nro_dep:nro_dep,fecha_dep:fecha_dep
function registrarDeposito(){
    $id_banco = $_REQUEST['id_banco'];
    $cuenta = $_REQUEST['cuenta'];
    $suc = $_REQUEST['suc'];
    $fecha = $_REQUEST['fecha'];
    $moneda = $_REQUEST['moneda'];
    $deposito = $_REQUEST['deposito'];
    $cotiz = $_REQUEST['cotiz'];
    $nro_dep = $_REQUEST['nro_dep'];
    $fecha_dep = $_REQUEST['fecha_dep'];
    $usuario = $_REQUEST['usuario'];
    $obs = $_REQUEST['obs'];    
    
    $monto_moneda_ref = round($deposito * $cotiz,2);
    $db = new My();
    $db->Query("insert into efectivo( id_concepto, f_nro, nro_reserva, nro_deposito, m_cod,usuario, trans_num, entrada, salida, cotiz, entrada_ref, salida_ref,fecha_reg, fecha, hora, suc, estado, e_sap)
    values (9, null, null,'$nro_dep', '$moneda','$usuario', 0, 0, $deposito, $cotiz, null, " . ((float)$deposito*(float)$cotiz) . ",current_date, '$fecha', current_time, '$suc', 'Pendiente', 0);");
        
    $db->Query("insert into bcos_ctas_mov ( nro_deposito, trans_num, id_banco, cuenta,fecha_reg, fecha, hora, entrada, salida, suc, estado, id_concepto, usuario,obs,e_sap)
    values ( '$nro_dep',null, '$id_banco', '$cuenta',current_date,'$fecha',current_time,$deposito, 0, '$suc', 'Pendiente', 9, '$usuario','$obs', 0);");
    echo "Ok";
}

function registrarExtraccion(){
    $id_banco = $_REQUEST['id_banco'];
    $cuenta = $_REQUEST['cuenta'];
    $suc = $_REQUEST['suc'];
    $fecha = $_REQUEST['fecha'];
    $moneda = $_REQUEST['moneda'];
    $valor  = $_REQUEST['extraccion'];
    $cotiz = $_REQUEST['cotiz'];
    $nro_dep = $_REQUEST['nro_dep'];
    $fecha_dep = $_REQUEST['fecha_dep'];
    $usuario = $_REQUEST['usuario'];
    $obs = $_REQUEST['obs'];
    $id_concepto = $_REQUEST['concepto'];
     
    $db = new My();
   
    $db->Query("insert into bcos_ctas_mov ( nro_deposito, trans_num, id_banco, cuenta,fecha_reg, fecha, hora, entrada, salida, suc, estado, id_concepto, usuario,obs,e_sap)
    values ( null,null, '$id_banco', '$cuenta',current_date,'$fecha',current_time,0, $valor, '$suc', 'Pendiente', $id_concepto , '$usuario','$obs', 0);");
    
    $db->Query("select id_mov from bcos_ctas_mov where usuario = '$usuario' and id_concepto = $id_concepto order by id_mov desc limit 1");
    $id_mov = 0;
    if($db->NumRows()>0){
        $db->NextRecord();
        $id_mov = $db->Get('id_mov');
    }
    
    registrarGasto($id_concepto,$obs,$fecha,$usuario,$valor,$moneda,$suc,$id_mov);
    
    echo "Ok";
}

function registrarGasto($id_concepto,$obs,$fecha,$usuario,$valor,$moneda,$suc,$id_pago){
    $db = new My();
    $db->Query("SELECT gasto FROM conceptos WHERE tipo = 'S' AND id_concepto = $id_concepto");
    if($db->NumRows()>0){
        $db->NextRecord();
        $gasto = $db->Get('gasto');
        if($gasto == "Si"){
            $db->Query("INSERT INTO gastos(fecha,hora, suc, usuario, id_concepto, descrip, moneda, valor, tabla_prov, id_tabla)VALUES ( '$fecha',CURRENT_TIME; '$suc', '$usuario', $id_concepto, '$obs', '$moneda', $valor, 'bcos_ctas_mov', $id_pago);");
        }
    }
}

function getCotiz(){
    $suc = $_REQUEST['suc'];
    $moneda = $_REQUEST['moneda'];
            
    $sql = "select compra,venta from cotizaciones where m_cod = '$moneda' and suc = '$suc' order by id_cotiz desc limit 1";
    $db = new My();
    $array = array();
    $db->Query($sql);
    while ($db->NextRecord()) {
        array_push($array, $db->Record);
    }
    echo json_encode($array);
}

new Depositos();
?>
