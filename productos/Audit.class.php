<?php

require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_DB_MSSQL.class.php");

/**
 * Description of Audit
 *
 * @author Doglas
 */
class Audit {

    function __construct() {
        $action = $_REQUEST['action'];
        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }
    }

    function main() {
        $t = new Y_Template("Audit.html");

        $lote = $_REQUEST['lote'];
        $suc = $_REQUEST['suc'];

        $t->Show("header");


        $db = new My();
        $rem = "SELECT  n.n_nro,DATE_FORMAT(fecha_cierre,'%d-%m-%Y') AS fecha , CONCAT( n.suc,'->', n.suc_d) AS orig_des, CONCAT(usuario,'->',recepcionista) AS de_a ,gramaje,ancho,tara,kg_env,kg_rec,cantidad,"
                . " cant_calc_env,cant_calc_rec FROM nota_remision n, nota_rem_det d WHERE n.n_nro = d.n_nro AND lote = '$lote' and suc_d = '$suc'";
        $db->Query($rem);

        if ($db->NumRows() > 0) {
            $t->Show("rem_head");
            while ($db->NextRecord()) {
                $nro = $db->Record['n_nro'];
                $fecha = $db->Record['fecha'];
                $orig_des = $db->Record['orig_des'];
                $de_a = $db->Record['de_a'];
                $gramajer = $db->Record['gramaje'];
                $anchor = $db->Record['ancho'];
                $tarar = $db->Record['tara'];
                $kg_env = $db->Record['kg_env'];
                $kg_rec = $db->Record['kg_rec'];
                $cantidad = $db->Record['cantidad'];
                $cant_calc_env = $db->Record['cant_calc_env'];
                $cant_calc_rec = $db->Record['cant_calc_rec'];

                $t->Set("nro", $nro);
                $t->Set("fecha", $fecha);
                $t->Set("orig_des", $orig_des);
                $t->Set("de_a", $de_a);
                $t->Set("anchor", number_format($anchor, 2, ',', '.'));
                $t->Set("gramajer", number_format($gramajer, 1, ',', '.'));
                $t->Set("tarar", number_format($tarar, 1, ',', '.'));
                $t->Set("kg_env", number_format($kg_env, 2, ',', '.'));
                $t->Set("kg_rec", number_format($kg_rec, 2, ',', '.'));
                $t->Set("cantidad", number_format($cantidad, 2, ',', '.'));
                $t->Set("cant_calc_env", number_format($cant_calc_env, 2, ',', '.'));
                $t->Set("cant_calc_rec", number_format($cant_calc_rec, 2, ',', '.'));

                $t->Show("rem_data");
            }
            $t->Show("rem_foot");
        } else {
            $frac = "SELECT id_frac AS n_nro,DATE_FORMAT(fecha,'%d-%m-%Y') AS fecha,CONCAT( suc,'->', suc_destino) AS orig_des,usuario,ancho,tara,gramaje,cantidad  FROM fraccionamientos WHERE lote = '$lote' AND signo = '+' and suc = '$suc'";
            $db->Query($frac);
            if ($db->NumRows() > 0) {
                $t->Show("frac_head");
                while ($db->NextRecord()) {
                    $nro = $db->Record['n_nro'];
                    $fecha = $db->Record['fecha'];
                    $orig_des = $db->Record['orig_des'];
                    $operario = $db->Record['usuario'];
                    $gramajer = $db->Record['gramaje'];
                    $anchor = $db->Record['ancho'];
                    $tarar = $db->Record['tara'];
                    $cantidad = $db->Record['cantidad'];

                    $t->Set("nro", $nro);
                    $t->Set("fecha", $fecha);
                    $t->Set("orig_des", $orig_des);
                    $t->Set("operario", $operario);
                    $t->Set("anchor", number_format($anchor, 2, ',', '.'));
                    $t->Set("gramajer", number_format($gramajer, 1, ',', '.'));
                    $t->Set("tarar", number_format($tarar, 1, ',', '.'));
                    $t->Set("cantidad", number_format($cantidad, 2, ',', '.'));
                    $t->Show("frac_data");
                }
                $t->Show("frac_foot");
            }else{
                $ent = "SELECT m.id_ent AS n_nro,DATE_FORMAT(fecha,'%d-%m-%Y') AS fecha, suc,usuario,ancho,tara,gramaje_m,kg_desc,cant_calc AS cantidad  FROM entrada_det d, entrada_merc m WHERE m.id_ent = d.id_ent  AND m.e_sap = 1 AND lote = $lote";
                $db->Query($ent);
                if ($db->NumRows() > 0) {
                $t->Show("ent_head");
                while ($db->NextRecord()) {
                    $nro = $db->Record['n_nro'];
                    $fecha = $db->Record['fecha'];
                    $orig_des = $db->Record['orig_des'];
                    $operario = $db->Record['usuario'];
                    $gramajer = $db->Record['gramaje_m'];
                    $anchor = $db->Record['ancho'];
                    $tarar = $db->Record['tara'];
                    $kg_desc = $db->Record['kg_desc'];
                    $cantidad = $db->Record['cantidad'];

                    $t->Set("nro", $nro);
                    $t->Set("fecha", $fecha);
                    $t->Set("orig_des", $suc);
                    $t->Set("operario", $operario);
                    $t->Set("anchor", number_format($anchor, 2, ',', '.'));
                    $t->Set("gramajer", number_format($gramajer, 1, ',', '.'));
                    $t->Set("tarar", number_format($tarar, 1, ',', '.'));
                    $t->Set("cantidad", number_format($cantidad, 2, ',', '.'));
                    $t->Set("kg_desc", number_format($kg_desc, 2, ',', '.'));
                    $t->Show("ent_data");
                }
                $t->Show("ent_foot");
                }
                
            }
        }


        $ms = new MS();
        $ms->Query("SELECT BatchNum,U_padre,BaseEntry,WhsCode,Quantity,U_ancho,U_gramaje,U_gramaje_m,U_ubic,U_kg_desc,U_img,U_fin_pieza,U_tara FROM oibt WHERE BatchNum = '$lote' AND WhsCode = '$suc'");
        $t->Show("head");


        $array = extraer($ms, "Principal", $t);
        $padre = $array['Padre'];
        // Buscar Hermano

        $ms->Query("SELECT BatchNum,U_padre,BaseEntry,WhsCode,Quantity,U_ancho,U_gramaje,U_gramaje_m,U_ubic,U_kg_desc,U_img,U_fin_pieza,U_tara FROM oibt WHERE BatchNum != '$lote' AND U_padre = '$padre' and U_padre != '' ORDER BY U_fin_pieza DESC, Quantity asc");
        if ($ms->NumRows() > 0) {
            extraer($ms, "Hermano", $t);
        } else {
            $BaseEntry = $array['BaseEntry'];
            $Img = $array['Img'];
            $ms->Query("SELECT top 20 BatchNum,U_padre,BaseEntry,WhsCode,Quantity,U_ancho,U_gramaje,U_gramaje_m,U_ubic,U_kg_desc,U_img,U_fin_pieza,U_tara FROM oibt WHERE BatchNum != '$lote' AND U_img = '$Img' AND BaseEntry = $BaseEntry ORDER BY U_fin_pieza DESC, Quantity asc");
            extraer($ms, "Similar", $t);
        }

        $t->Show("foot");
        $t->Show("calc");
    }

}

function extraer($ms, $tipo, $t) {


    while ($ms->NextRecord()) {
        $_lote = $ms->Record['BatchNum'];
        $padre = $ms->Record['U_padre'];
        $BaseEntry = $ms->Record['BaseEntry'];
        $_suc = $ms->Record['WhsCode'];
        $cant = $ms->Record['Quantity'];
        $ancho = $ms->Record['U_ancho'];
        $gramaje = $ms->Record['U_gramaje'];
        $gramaje_m = $ms->Record['U_gramaje_m'];
        $ubic = $ms->Record['U_ubic'];
        $tara = $ms->Record['U_tara'];
        $kg_desc = $ms->Record['U_kg_desc'];
        $img = $ms->Record['U_img'];
        $FP = $ms->Record['U_fin_pieza'];
        
        if ($tipo === "Principal"){
            $t->Set("ancho_a", number_format($ancho, 2, '.', ','));
            $t->Set("gramaje_a", number_format($gramaje, 1, '.', ','));             
            $t->Set("tara_a", number_format($tara, 2, '.', ','));
        }

        if ($tipo != "Principal" && $cant == 0 && $FP == "No") {
            
        } else {
            $t->Set("tipo", $tipo); 
            if ($tipo == "Principal") {
                $t->Set("tipo", "Datos Actuales"); 
            } 
            $t->Set("_tipo", $tipo);
            $t->Set("lote", $_lote);
            $t->Set("padre", $padre);
            $t->Set("suc", $_suc);
            $t->Set("cant", number_format($cant, 2, ',', '.'));

            $t->Set("ancho", number_format($ancho, 2, ',', '.'));
            $t->Set("gramaje", number_format($gramaje, 1, ',', '.'));
            $t->Set("gramaje_m", number_format($gramaje_m, 1, ',', '.'));
            $t->Set("tara", number_format($tara, 2, ',', '.'));

            $t->Set("kg_desc", number_format($kg_desc, 2, ',', '.'));
            $t->Set("ubic", $ubic);
            $t->Set("FP", $FP);
            $cant_inicial = getCantIni($_lote);
            $t->Set("cantidad_inicial", number_format($cant_inicial, 2, ',', '.'));

            $t->Set("negrita", "");
            if ($tipo === "Principal") {
                $t->Set("indicador", "bolder");
                $t->Set("check", "");
            } else {
                $t->Set("check", '<input type="checkbox" class="check" checked="checked">');

                $myv = new My();
                $myv->Query("SELECT suc,COUNT(*) AS ventas  FROM factura_venta f, fact_vent_det d WHERE f.f_nro = d.f_nro AND d.lote = '$_lote' AND f.estado ='Cerrada'  and suc = '$_suc'");
                $ventas = 0;

                if ($myv->NumRows() > 0) {
                    $myv->NextRecord();
                    $ventas = $myv->Record['ventas'];
                }
                $t->Set("ventas", "$ventas");
                $vstars = "";

                if ($ventas > 0) {
                    for ($i = 0; $i < $ventas; $i++) {
                        $vstars.= "<img class='star' src='../img/red_yellow_star.png' title='Venta'>";
                    }
                    $t->Set("starv", "$vstars");
                } else {
                    $t->Set("starv", "");
                }

                $t->Set("indicador", "normal");
                $t->Set("star", "");
                if ($FP === "Si") {
                    $t->Set("star", "<img class='star' src='../img/green_star.png' title='Fin de Pieza'>");
                    $t->Set("negrita", "negrita");
                }
            }

            $t->Show("data");
        }
    }

    return array("Padre" => $padre, "BaseEntry" => $BaseEntry, "Img" => $img);
}

function getCantIni($_lote) {
    $my = new My();
    $cant_inicial = 0;
    $my->Query("SELECT cantidad  FROM fraccionamientos WHERE lote = '$_lote' AND signo = '+'");
    if ($my->NumRows() > 0) {
        $my->NextRecord();
        $cant_inicial = $my->Record['cantidad'];
    } else {
        $my->Query("SELECT cant_calc AS cantidad FROM entrada_det  WHERE lote  ='$_lote' ");
        if ($my->NumRows() > 0) {
            $my->NextRecord();
            $cant_inicial = $my->Record['cantidad'];
        }
    }
    $my->Close();
    return $cant_inicial;
}

new Audit();
?>
