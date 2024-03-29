<?php

/**
 * Description of NuevaVenta
 * @author Ing.Douglas A. Dembogurski
 * @date 20-02-2015
 */

require_once("../Y_DB_MySQL.class.php");
require_once("../Y_Template.class.php");
require_once("../Config.class.php");
require_once("../Clientes/Clientes.class.php");

class NuevaVenta {

    function __construct() {
        $action = $_REQUEST['action'];
        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }
    }

    function main() {
        $t = new Y_Template("FacturaVenta.html");
        $db = new My();
        
        if( isset($_GET['cod_cli'])){ 
            $cod_cli = $_GET['cod_cli'];
            $nro_diag = $_GET['nro_diag'];
            $db->Query("SELECT nombre FROM clientes WHERE cod_cli = '$cod_cli'");
            $db->NextRecord();
            $nombre = $db->Record['nombre'];   
            $t->Set("cliente",$nombre);
            $t->Set("nro_diag",$nro_diag);
            $t->Set("auto_buscar_cliente","true");    
            
        }
        
        
        $usuario = $_POST['usuario'];
        $touch = $_POST['touch'];
        $suc = $_POST['suc'];
        $estado = "Abierta";
        $tipo_doc = "Factura";
        if(isset($_GET['estado'])){
           $estado = $_GET['estado'];
           $tipo_doc = "Presupuesto";
        }
        
        

        
        $db2 = new My();
        
        $db->Query("SELECT valor FROM parametros WHERE clave = 'vent_det_limit' or clave = 'limite_stock_negativo' order by clave desc");
        $db->NextRecord();
        $limite_detalles = $db->Record['valor'];

        $db->NextRecord();
        $stock_negativo = $db->Record['valor'];
                
        
        
        $t->Set("tipo_doc",$tipo_doc);
        
        $t->Set("limite_detalles",$limite_detalles);
        $t->Set("limite_stock_negativo",$stock_negativo);
        $t->Set("estado",$estado);


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


        if ($touch == "true") {
            $t->Set("keypadtouch", "inline");
        } else {
            $t->Set("keypadtouch", "none");
        }

        $t->Show("header");

        $c = new Config();
        $host = $c->getNasHost();
        $path = $c->getNasFolder();
        $images_url = "http://$host/$path";
        $t->Set("images_url", $images_url);

        $t->Show("titulo_factura");
        $t->Show("cotizaciones");

        $c = new Clientes();
        $c->getABM();
        $t->Set("cod_desc", "0");
        $t->Show("cabecera_nueva_venta");


        $t->Show("area_carga_cab");
        //$t->Show("area_carga_data");
        //$t->Set("codigo_venta_discriminada", "");
        $t->Set("codigo_venta_discriminada", ' <input type="button" id="imprimir_detalle" onclick="imprimirDetalle()"  style="font-weight: bolder" value=" Imprimir " >');             
        $t->Show("area_carga_foot");
        $t->Show("config");



        // Solo si es Toutch
        if ($touch == "true") {
            require_once("../utils/NumPad.class.php");
            require_once("../utils/Keyboard.class.php");
            new NumPad();
            $keyboard = new Keyboard();
            $keyboard->show();
        }
    }

}

function getLotesMenores() { 
    echo json_encode(array());
}

function verifTurnoNFactura() {
    $turno_id = $_POST['turno_id'];
    $suc = $_POST['suc'];
    $my = new My();
    $datos = array("f_nro" => "", "usuario" => "");
    $my->Query("SELECT f_nro,usuario AS turno FROM factura_venta WHERE turno_id=$turno_id AND suc='$suc'");
    if ($my->NextRecord()) {
        $datos = $my->Record;
    }
    echo json_encode($datos);
}

function crearFactura() {
    $cod_cli = $_POST['cod_cli']; 
    
     
    $usuario = $_POST['usuario'];
    $suc = $_POST['suc'];
    $estado = $_POST['estado'];
     
    $moneda = $_POST['moneda'];
    $cotiz = $_POST['cotiz'];
     
    $turno = $_POST['turno'];
    $turno_id = $_POST['id'];
    $turno_fecha = $_POST['fecha'];
    $turno_llamada = $_POST['llamada'];

    if (!isset($_POST['turno'])) {
        $turno = 100;
    }
    $nro_diag = 'null';
    $notas = "";
    if ( $_POST['nro_diag'] != "" ) {
        $nro_diag = $_POST['nro_diag'];
        $notas = "Basado en Diagnostico Nro: $nro_diag";
    }
    
    if($turno_id === ""){  
        $turno_id = 0;
        $turno_fecha = "NULL";
        $turno_llamada = "NULL";
    }else{
        $turno_fecha = "'$turno_fecha'";   
        $turno_llamada ="'$turno_llamada'";   
    }
     
    $db = new My();
    $sql = "select nombre,ci_ruc, cat, tipo_doc from clientes WHERE cod_cli = '$cod_cli'";
    $db->Query($sql);
    $db->NextRecord();
    $ruc = $db->Record['ci_ruc'];
    $cliente = utf8_encode($db->Record['nombre']);
    $cat = $db->Record['cat'];
    $tipo_doc = $db->Record['tipo_doc'];
    
    $hora = date('H:i');
    
    $db->Query("INSERT INTO factura_venta(cod_cli,cliente,usuario,fecha,hora,turno,ruc_cli,tipo_doc_cli,suc,cat,total,total_desc,total_bruto,estado,cod_desc,moneda,cotiz,turno_id, turno_fecha, turno_llamada,empaque,nro_reserva,nro_diag,notas)
    VALUES ('$cod_cli','$cliente','$usuario',current_date,'$hora',$turno,'$ruc','$tipo_doc','$suc',$cat,0,0,0,'$estado',0,'$moneda',$cotiz,$turno_id, $turno_fecha, $turno_llamada,'No',NULL,$nro_diag,'$notas');");
    
    
    $db->Query("SELECT f_nro AS NRO FROM factura_venta WHERE estado = '$estado' AND usuario = '$usuario'  ORDER BY f_nro DESC LIMIT 1");
    $db->NextRecord();
    $nro = $db->Record['NRO'];
    echo $nro;
}

new NuevaVenta();
?>




