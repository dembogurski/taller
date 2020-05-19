<?php

/**
 * Description of CargarNotaCredito
 * @author Ing.Douglas
 * @date 30/06/2015
 */
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_Template.class.php");

class CargarNotaCredito {

    function __construct() {

        $nro_nota = $_POST['nro_nota'];
        $factura = $_POST['factura'];
        
        $db = new My();

        $t = new Y_Template("NotasCredito.html");
        $t->Set("fact_cont",$this->verif_fact_cont($factura));
        $t->Show("header");
        
        $t->Set("nro_nota", $nro_nota);
        $t->Set("factura", $factura);


        $db->Query("SELECT n.cod_cli,n.ruc_cli AS ruc,n.cliente, req_auth, f.fecha,autorizado_por,n.moneda FROM nota_credito n,factura_venta f  WHERE   n.f_nro = f.f_nro and n_nro = '$nro_nota' /*and n.e_sap IS NUll*/");
        if ($db->NumRows() > 0) {
            $db->NextRecord();
            $cod_cli = $db->Record['cod_cli'];
            $ruc = $db->Record['ruc'];
            $cliente = $db->Record['cliente'];
            $req_auth = $db->Record['req_auth'];
            $fecha_fact = $db->Record['fecha'];
            $autorizado_por = $db->Record['autorizado_por'];
            $moneda = $db->Record['moneda'];
            

            $t->Set("cod_cli", $cod_cli);
            $t->Set("ruc", $ruc);
            $t->Set("cliente", $cliente);
            $t->Set("moneda", $moneda);
           
            if($req_auth){  
               if( $autorizado_por != ""){     
                 $t->Set("fuera_rango", "false");  
               }else{   
                 $t->Set("fuera_rango", "true");
               }
            }else{  
                $t->Set("fuera_rango", "false");
            }
            
            
            $t->Set("fecha_factura", $fecha_fact);
            $t->Show("titulo_nota_credito");
            $t->Show("cabecera_nota_credito_existente");
            $t->Show("area_carga_cab");
            $t->Show("area_carga_foot");
        }
    }

    // Verifica si tiene factura contable asociada.-

    function verif_fact_cont($f_nro){
        $link = new My();
        $has_factura_cont = 'false';
        $link->Query("select count(*) as fact from factura_venta f inner join factura_cont c on f.fact_nro=c.fact_nro and f.suc=c.suc and f.estado=c.estado where c.tipo_doc='Factura' and f.estado = 'Cerrada' and f.f_nro = '$f_nro'");
        $link->NextRecord();
        if((int)$link->Record['fact']>0){
            $has_factura_cont = 'true';
        }
        $link->Close();
        return (String)$has_factura_cont;
    }

}

new CargarNotaCredito();
?>
