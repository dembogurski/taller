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

        //$session = $_POST['session'];
        $usuario = $_POST['usuario'];
        $touch = $_POST['touch'];
        $suc = $_POST['suc'];


        $db = new My();
        $db2 = new My();
        $db->Query("SELECT valor FROM parametros WHERE clave = 'vent_det_limit'");
        $db->NextRecord();
        $limite_detalles = $db->Record['valor'];

        $t = new Y_Template("FacturaVenta.html");
        $t->Set("limite_detalles", $limite_detalles);


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
    require_once("../Y_DB_MSSQL.class.php");
    $lote = $_POST['lote'];
    $suc = $_POST['suc'];
    $cantidad = $_POST['cantidad']; // Cantidad a vender
    $ms = new MS();
    $ms2 = new MS();
    $ms->Query("select ItemCode,BatchNum,Quantity,U_img from oibt  where WhsCode = '$suc' and BatchNum = '$lote'   and U_img <> '0/0' and U_img <> '' ");
    $arr = array();
    if ($ms->NumRows() > 0) {
        $ms->NextRecord();
        $ItemCode = $ms->Record['ItemCode'];
        $Img = $ms->Record['U_img'];
        $Quantity = $ms->Record['Quantity'];
        $ms2->Query("select BatchNum,Quantity,U_img from oibt  where WhsCode = '$suc' and ItemCode = '$ItemCode'  and U_img = '$Img' and Quantity >= $cantidad  and Quantity < $Quantity order by Quantity asc;  ");
        while ($ms2->NextRecord()) {
            array_push($arr, $ms2->Record);
        }
    }
    echo json_encode($arr);
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
     
    $moneda = $_POST['moneda'];
    $cotiz = $_POST['cotiz'];
     
    $turno = $_POST['turno'];
    $turno_id = $_POST['id'];
    $turno_fecha = $_POST['fecha'];
    $turno_llamada = $_POST['llamada'];

    if (!isset($_POST['turno'])) {
        $turno = 100;
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
    
    $db->Query("INSERT INTO factura_venta(cod_cli,cliente,usuario,fecha,hora,turno,ruc_cli,tipo_doc_cli,suc,cat,total,total_desc,total_bruto,estado,cod_desc,moneda,cotiz,turno_id, turno_fecha, turno_llamada,empaque,nro_reserva)
    VALUES ('$cod_cli','$cliente','$usuario',current_date,'$hora',$turno,'$ruc','$tipo_doc','$suc',$cat,0,0,0,'Abierta',0,'$moneda',$cotiz,$turno_id, $turno_fecha, $turno_llamada,'No',NULL);");
    
    
    $db->Query("SELECT f_nro AS NRO FROM factura_venta WHERE estado = 'Abierta' AND usuario = '$usuario'  ORDER BY f_nro DESC LIMIT 1");
    $db->NextRecord();
    $nro = $db->Record['NRO'];
    echo $nro;
}

new NuevaVenta();
?>




