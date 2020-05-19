<?php

/**
 * Description of CobroCuotas
 * @author Ing.Douglas
 * @date 06/08/2015
 */
require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_DB_MSSQL.class.php");

class CobroCuotas {
    function __construct(){
        $useragent=$_SERVER['HTTP_USER_AGENT'];
        $t = new Y_Template("CobroCuotas.html");
        $usuario = $_POST['usuario'];
        $suc = $_POST['suc'];
        
        //echo getcwd();
        
        $ruc_cli = ""; 
        if(isset($_POST['ruc_cli'])){
            $ruc_cli = $_POST['ruc_cli']; 
        }
        
        $t->Set('ruc_cli',$ruc_cli);
         
        
        
        $t->Set('is_mobile','false');
        // Detectar Dispositivos Android
        if(preg_match('/android/i',$useragent)){
            //echo 'Mobile';
            $t->Set('is_mobile','true');
            $t->Set("fecha_hoy",date("Y-m-d"));
        }else{
            //echo 'PC';
            $t->Set("fecha_hoy",date("d/m/Y"));
        }
        $t->Show("header"); 
         
        
        // Buscar Convenios
        $ms = new MS();
        $ms->Query("select CreditCard,CardName,Phone as Tipo from ocrc where CardName not like 'ASO%' order by CardName asc");
        $convenios = "";
        while ($ms->NextRecord()) {
            $conv_cod = $ms->Record['CreditCard'];
            $conv_nombre = $ms->Record['CardName'];
            $tipo_tarjeta_ret = $ms->Record['Tipo'];
            $convenios.="<option value='$conv_cod'>$conv_nombre</option>";
        }
        $t->Set("convenios", $convenios);

        $db = new My();
        $db2 = new My();
        
        $db->Query("SELECT m_descri AS m, m_cod AS moneda FROM monedas WHERE m_ref <> 'Si';");
        //echo $db->NumRows();
        while ($db->NextRecord()) {
            $moneda = $db->Record['moneda'];
            $mon_replaced = strtolower(str_replace("$", "s", $moneda));
            $db2->Query("SELECT compra,venta FROM cotizaciones WHERE suc = '$suc' AND m_cod = '$moneda' and fecha <= current_date ORDER BY id_cotiz DESC LIMIT 1;");
            if ($db2->NumRows() > 0) {
                $db2->NextRecord();
                $compra = $db2->Record['compra'];
                $t->Set("cotiz_$mon_replaced", number_format($compra, 2, ',', '.'));
            } else {
                $t->Set("cotiz_$mon_replaced", 0);
            }
        }
        
        $t->Show("cotizaciones");
        $t->Show("body"); 
        // Buscar Lista de Bancos
        $db->Query("SELECT id_banco,nombre FROM bancos order by nombre asc");
        $bancos = "";
        while ($db->NextRecord()) {
            $id_banco = $db->Record['id_banco'];
            $nombre = $db->Record['nombre'];
            $bancos.="<option value='$id_banco'>$nombre</option>";
        }
        $t->Set("bancos", $bancos);
        
        $db->QUERY("SELECT  b.id_banco,b.nombre,cuenta, c.m_cod as moneda FROM bancos b, bcos_ctas c WHERE b.id_banco = c.id_banco ORDER BY b.nombre ASC");
        $cuentas = "";
        $i = 0;
        while ($db->NextRecord()) {
            $id_banco = $db->Record['id_banco'];
            $nombre = $db->Record['nombre'];
            $cuenta = $db->Record['cuenta'];
            $moneda = $db->Record['moneda'];
            $cuentas.="<option value='$id_banco' data-cuenta='$cuenta' onchange='setCuenta()' >$nombre - $cuenta - $moneda</option>";
            if($i == 0){
                $t->Set("cuenta",$cuenta);
            }
            $i++;
        }
        $t->Set("cuentas", $cuentas);
        

        // Buscar Lista de Monedas
        $db->Query("SELECT m_cod AS moneda, m_descri FROM monedas ");
        $monedas = "";
        $monedas_cod = "";
        while ($db->NextRecord()) {
            $moneda = $db->Record['moneda'];
            $m_descri = $db->Record['m_descri'];
            if ($moneda != 'P$' && $moneda != 'R$' && $moneda != 'Y$') {
                $monedas.="<option value='$moneda'>$m_descri</option>";
            }
            $monedas_cod.="<option value='$moneda'>$moneda</option>";
        }
        $t->Set("monedas", $monedas);
        $t->Set("monedas_cod", $monedas_cod);
        $ncuotas = "";
        for ($i = 1; $i <= 60; $i++) {
            $ncuotas .= "<option>$i</option>";
        }
        $t->Set("n_cuotas", $ncuotas);

        $t->Show("ui");
        
        $t->Show("area_impresion");
        
    }
}
new CobroCuotas();
?>

