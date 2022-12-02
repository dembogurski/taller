<?php

/**
 * Description of Imprimir
 *
 * @author Usuario
 */

require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");
require_once("../Functions.class.php");

class DiagPrint {
    function __construct() {
        $action = $_REQUEST['action'];
        if (isset($action)) {
            $this->{$action}();
        } else {
            $this->main();
        }
    }

    function main() {
        $db = new My();
        $id_diag = $_REQUEST['id_diag'];
        $user = $_REQUEST['usuario'];
        
        $t = new Y_Template("DiagPrint.html");
        $t->Show("headers");
        $Qry = "SELECT id_diag AS nro,DATE_FORMAT(fecha,'%d-%m-%Y') AS fecha, c.nombre AS cliente,c.ci_ruc,c.tel,c.email,c.ciudad,c.dir,p.nombre AS pais,d.chapa   
        FROM diagnosticos d, moviles m, clientes c, paises p WHERE c.pais = p.codigo_pais AND d.chapa = m.chapa AND m.codigo_entidad = c.cod_cli AND id_diag =$id_diag";
        
        $db->Query($Qry);
        $db->NextRecord();
        $nro = $db->Get('nro');
        $fecha = $db->Get('fecha');
        $cliente = $db->Get('cliente');
        $ruc = $db->Get('ci_ruc');
        $tel = $db->Get('tel');
        $email = $db->Get('email');
        $dir = $db->Get('dir');
        $ciudad = $db->Get('ciudad');
        $pais = $db->Get('pais');
        $chapa = $db->Get('chapa');
          
        
        $t->Set("nro",$nro);
        $t->Set("fecha",$fecha);
        $t->Set("user",$user);
        $t->Set("time",date("d-m-Y H:i"));
        
        
        $t->Show("head");
        
        $t->Set("cliente",$cliente);
        $t->Set("ruc",$ruc);
        $t->Set("tel",$tel);
        $t->Set("email",$email);
        $t->Set("dir", ucwords( strtolower("$dir - $ciudad - $pais")));
        $t->Show("cliente");
        
        $sql = "SELECT marca,modelo,vim,anio_fab,color,combustible,tipo,otros FROM moviles WHERE chapa = '$chapa'";
        $db->Query($sql);
        $db->NextRecord();
        
        $marca = $db->Get('marca');
        $modelo = $db->Get('modelo');
        $vin = $db->Get('vim');
        $anio_fab = $db->Get('anio_fab');
        $color = $db->Get('color');
        $combustible = $db->Get('combustible');
        $tipo = $db->Get('tipo');
        $otros = $db->Get('otros');
        
        $t->Set("chapa",$chapa);
        $t->Set("marca",$marca);
        $t->Set("modelo",$modelo);
        $t->Set("vin",$vin);
        $t->Set("anio_fab",$anio_fab);
        $t->Set("color",$color);
        $t->Set("combustible",$combustible);
        $t->Set("tipo",$tipo);
        
        $t->Show("vechiculo");
         
        $rec = "SELECT id_det,descrip,precio,cant,subtotal FROM diag_det WHERE id_diag = $id_diag";
        $db->Query($rec);
        $t->Show("recep");
        
        $total = 0;
        while($db->NextRecord()){
           $id_det = $db->Get('id_det');
           $descrip = $db->Get('descrip');
           $precio = $db->Get('precio');
           $cant = $db->Get('cant');
           $subtotal = $db->Get('subtotal');
           $total+=0+$subtotal;
           $t->Set("id_det",$id_det);  
           $t->Set("descrip",$descrip);  
           $t->Set("id_det",$id_det);  
           $t->Set("precio",number_format($precio, 2, ',', '.')); 
           $t->Set("cant",number_format($cant, 2, ',', '.')); 
           $t->Set("subtotal",number_format($subtotal, 2, ',', '.')); 
           $t->Show("recep_data");
        }
        $t->Set("total",number_format($total, 2, ',', '.'));  
         
       
        $t->Show("recep_foot");
        
         
        $t->Show("sintomas");
        
        $t->Show("foot");
        
        
    }
}
new DiagPrint();
?>
