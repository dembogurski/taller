<?php

/**
 * Description of Imprimir
 *
 * @author Usuario
 */

require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");
require_once("../Functions.class.php");

class RecepPrint {
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
        
        $t = new Y_Template("RecepPrint.html");
        $t->Show("headers");
        $Qry = "SELECT id_diag AS nro,DATE_FORMAT(fecha,'%d-%m-%Y') AS fecha, c.nombre AS cliente,c.ci_ruc,c.tel,c.email,c.ciudad,c.dir,p.nombre as pais,d.chapa, d.descrip AS sintomas, porc_combustible,km_actual
        FROM recepcion d, moviles m, clientes c, paises p WHERE c.pais = p.codigo_pais and d.chapa = m.chapa AND d.cod_cli = c.cod_cli AND id_diag = $id_diag";
        
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
        $sintomas = $db->Get('sintomas');
        $porc_comb = $db->Get('porc_combustible');
        $km_actual = $db->Get('km_actual'); 
        
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
        
        $f = new Functions();
        $rec = "SELECT a.id_part,a.descrip, r.valor FROM aux_recep a LEFT JOIN movil_recep r ON a.id_part = r.id_part AND r.id_diag = $id_diag";
        $recep = $f->getResultArray($rec);
        //print_r($recep);
        
        $t->Set("porc_combustible",$porc_comb);
        $t->Set("km_actual", number_format($km_actual, 0, ',', '.')); 
        
        $t->Show("recep");
        
        for($i = 0;$i <18;$i++){
            $part_id = $recep[$i]['id_part'];
            $part_descrip = $recep[$i]['descrip'];
            $part_valor = $recep[$i]['valor'];
            
            $t->Set("part_id",$part_id);
            $t->Set("part_descrip",$part_descrip);
            $t->Set("part_valor",$part_valor);
            
            $k = $i+18;
            $part_id2 = $recep[$k]['id_part'];
            $part_descrip2 = $recep[$k]['descrip'];
            $part_valor2 = $recep[$k]['valor'];
            
            $t->Set("part_id2",$part_id2);
            $t->Set("part_descrip2",$part_descrip2);
            $t->Set("part_valor2",$part_valor2);
            $t->Show("recep_data");
        }
       
        $t->Show("recep_foot");
        
        $t->Set("sintomas",$sintomas);
        $t->Show("sintomas");
        
        $t->Show("foot");
        
        
    }
}
new RecepPrint();
?>
