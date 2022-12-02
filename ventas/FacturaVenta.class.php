<?php

/**
 * Description of CargarVenta
 * @author Ing.Douglas
 * @date 13/03/2015
 */

require_once("../Y_DB_MySQL.class.php");
require_once("../Functions.class.php");
require_once("../Y_Template.class.php");
require_once("../Config.class.php");
 

class FacturaVenta {
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
        $factura = $_POST['factura']; 
        $touch = $_POST['touch']; 
        $suc = $_POST['suc'];
        $estado = $_POST['estado'];
        
        //echo $estado;
        
        $db = new My();
        $db2 = new My();
         $sql_permiso = "SELECT u.nombre AS usu,ug.usuario,g.nombre,p.id_permiso AS id_permiso,descripcion,trustee 
               FROM  usuarios u,grupos g, usuarios_x_grupo ug, permisos_x_grupo p, permisos pr 
               WHERE u.usuario = ug.usuario AND ug.id_grupo = p.id_grupo AND g.id_grupo = ug.id_grupo AND p.id_permiso = pr.id_permiso  AND ug.usuario = '$usuario'
               AND  p.id_permiso = '1.6.1'";
        
        $db->Query($sql_permiso);
        $puede_discriminar = false;
        if($db->NumRows() > 0){
            $db->NextRecord();
            $trustee = $db->Record['trustee'];
            if($trustee == "vem"){
               $puede_discriminar = true; 
            }
        }     
        
        
        $db->Query("SELECT valor FROM parametros WHERE clave = 'vent_det_limit' or clave = 'limite_stock_negativo' order by clave desc");
        $db->NextRecord();
        $limite_detalles = $db->Record['valor'];
        
        $db->NextRecord();
        $stock_negativo = $db->Record['valor'];
                
        $t = new Y_Template("FacturaVenta.html");
        $t->Set("limite_detalles",$limite_detalles);
        $t->Set("limite_stock_negativo",$stock_negativo);
        $t->Set("estado",$estado);
        
        
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
        $t->Set("fecha_hoy",date("d/m/Y"));
        
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
        
        
        
        if($touch=="true"){
           $t->Set("keypadtouch","inline"); 
        }else{
            $t->Set("keypadtouch","none");
        }
        
        
        
        
        $c = new Config();
        $host = $c->getNasHost();
        $path = $c->getNasFolder();
        $images_url = "http://$host/$path";
        $t->Set("images_url",$images_url);
        
         
        if($this->modPrecioBajoMinimo($usuario)){
            $t->Set("modPrecioBajoMinimo",'<label for="modPrecioBajoMinimo">Ignorar m&iacute;nimo:</label><input type="checkbox" id="modPrecioBajoMinimo"><br>');
        }
        $t->Show("header");
        $t->Show("titulo_factura");
        $t->Show("cotizaciones");
        $t->Set("factura",$factura);
        
        $decimales = 0;
                                                                                                                               // AND usuario = '$usuario'
        $db->Query("SELECT   cod_cli ,ruc_cli AS ruc,tipo_doc_cli, cliente, cat,moneda,cotiz,cod_desc,pref_pago,desc_sedeco,notas,nro_diag FROM factura_venta WHERE    f_nro  = '$factura'");
        if($db->NumRows()>0){
            $db->NextRecord();
            $cli_cod = $db->Record['cod_cli'];
            $ruc = $db->Record['ruc'];
            $tipo_doc_cli = $db->Record['tipo_doc_cli'];
            $cliente = $db->Record['cliente'];
            $cat = $db->Record['cat'];
            $moneda = $db->Record['moneda'];
            $cotiz = $db->Record['cotiz'];
            $cod_desc = $db->Record['cod_desc'];
            $pref_pago = $db->Record['pref_pago'];
            $desc_sedeco = round($db->Record['desc_sedeco'],0);
            $notas = $db->Record['notas'];
            $nro_diag = $db->Record['nro_diag'];
            
            $t->Set("cli_cod",$cli_cod);
            $t->Set("ruc",$ruc);
            $t->Set("cliente",$cliente);
            $t->Set("cat",$cat);
            $t->Set("moneda",$moneda);
            $t->Set("cotiz",$cotiz);
            $t->Set("cod_desc",$cod_desc);
            $t->Set("pref_pago",$pref_pago);
            $t->Set("desc_sedeco",$desc_sedeco);
            $t->Set("notas",$notas);
            $t->Set("nro_diag",$nro_diag);
            
            if($moneda != 'G$'){
                $decimales = 2;
            }
            if($tipo_doc_cli != null){             
                $t->Set("tipo_doc",$tipo_doc_cli);
            }else{
                $t->Set("tipo_doc","C.I.");
            }
            $t->Show("cabecera_venta_existente");
                  
            if($estado != "Cerrada"){
                $t->Show("area_carga_cab");
            }
            
            $t->Show("area_carga_cab_det_factura");
            
            $t->Set("finalizar_state","disabled"); 
            
            $db = new My();
            $db->Query("SELECT codigo,lote,descrip,um_cod,cantidad, precio_venta,descuento,subtotal,cod_falla,cant_falla,estado_venta from fact_vent_det where f_nro =  $factura");
            $TOTAL = 0;
            $TOTAL_DESCUENTO= 0;
            while($db->NextRecord()){
               $codigo = $db->Record['codigo']; 
               $lote = $db->Record['lote']; 
               $descrip = $db->Record['descrip']; 
               $um_cod = $db->Record['um_cod']; 
               $cantidad = $db->Record['cantidad']; 
               $precio_venta = $db->Record['precio_venta']; 
               $descuento = $db->Record['descuento']; 
               $subtotal = $db->Record['subtotal']; 
               $cod_falla = $db->Record['cod_falla']; 
               $cant_falla = $db->Record['cant_falla']; 
               $estado_venta = $db->Record['estado_venta']; 
               $falla = "";
               if($cod_falla != ""){
                  $falla = "$cant_falla/$cod_falla"; 
               }       
               $h = str_replace(".", "", $precio_venta);
               $hash = "".$codigo."_".$h;
               $t->Set("hash",$hash);
               $TOTAL+=0+$subtotal;
               $TOTAL_DESCUENTO+=0+$descuento;
               $t->Set("codigo",$codigo);
               $t->Set("lote",$lote);
               $t->Set("descrip",$descrip);
               $t->Set("um",$um_cod);
               $t->Set("falla",$falla);
               $t->Set("cant", number_format($cantidad,2,',','.'));   
               $t->Set("precio", number_format($precio_venta,$decimales,',','.')); 
               $t->Set("descuento", number_format($descuento,1,',','.'));   
               $t->Set("subtotal",number_format($subtotal,$decimales,',','.'));    
               $t->Set("estado_venta",$estado_venta);
               
               $t->Set("finalizar_state",""); 
               $t->Show("area_carga_data");
            } 
            $t->Set("TOTAL",number_format($TOTAL,$decimales,',','.'));
            if($puede_discriminar){
               $t->Set("codigo_venta_discriminada",'<input type="button" id="mayorista" onclick="ventaMayorista()"  style="font-weight: bolder" value=" Venta Mayorista " >  <input type="button" id="discriminar" onclick="discriminarPrecios()"  style="font-weight: bolder" value=" Discriminar Precios " > <input type="button" id="proforma" onclick="facturaProforma()"  style="font-weight: bolder" value=" Proforma " > <input type="button" id="imprimir_detalle" onclick="imprimirDetalle()"  style="font-weight: bolder" value=" Imprimir " >');  
            }else{
              $t->Set("codigo_venta_discriminada", ' <input type="button" id="imprimir_detalle" onclick="imprimirDetalle()"  style="font-weight: bolder" value=" Imprimir Presupuesto " >    <input type="button" id="imprimir_detalle" onclick="imprimirFactura()"  style="font-weight: bolder" value=" Imprimir Factura " >');             
            }
            
            $t->Show("area_carga_foot");    
            $t->Show("config");
            // Solo si es Toutch
            if($touch=="true"){
                //require_once("../utils/NumPad.class.php");               
                //new NumPad();
            }
            
            /*****************Caja********************/
            $date = date_create(date("Y-m-d"));
            date_add($date, date_interval_create_from_date_string("30 days"));
            $treinta_dias = date_format($date, "d-m-Y");

            $t->Set("inicio_cuota", $treinta_dias);

            $t->Set("fecha_hoy", date("d/m/Y"));

            // Buscar Tarjetas
            $ms = new My();
            $ms->Query("SELECT cod_tarjeta AS CreditCard,nombre AS CardName,tipo AS Tipo FROM tarjetas WHERE tipo != 'Asociacion' ORDER BY nombre ASC");
            $tarjetas = "";
            while ($ms->NextRecord()) {
                $conv_cod = $ms->Record['CreditCard'];
                $conv_nombre = $ms->Record['CardName'];
                $tipo = $ms->Record['Tipo'];
                $tarjetas.="<option value='$conv_cod' data-tipo='$tipo' >$conv_nombre</option>";
            }
            $t->Set("tarjetas", $tarjetas);

            // Buscar Lista de Bancos
            $db->Query("SELECT id_banco,nombre FROM bancos order by nombre asc");
            $bancos = "";
            while ($db->NextRecord()) {
                $id_banco = $db->Record['id_banco'];
                $nombre = $db->Record['nombre'];
                $bancos.="<option value='$id_banco'>$nombre</option>";
            }
            $t->Set("bancos", $bancos);

            // Buscar Lista de Monedas
            $db->Query("SELECT m_cod AS moneda, m_descri FROM monedas where m_cod != 'Y$' ");
            $monedas = "";
            $monedas_cod = "";
            while ($db->NextRecord()) {
                $moneda = $db->Record['moneda'];
                $m_descri = $db->Record['m_descri'];
                if (($moneda != 'P$' && $moneda != 'R$')) {
                    $monedas.="<option value='$moneda'>$m_descri</option>";
                }
                $monedas_cod.="<option value='$moneda'>$moneda</option>";
            }
            $t->Set("monedas", $monedas);
            $t->Set("monedas_cod", $monedas_cod);
            $ncuotas = "";
            for ($i = 1; $i <= 60; $i++) {
                $ncuotas .= "<option class='n_cuota_$i cuota_x' >$i</option>";
            }
            $t->Set("n_cuotas", $ncuotas);

            $t->Show("ui_factura");
                        
        }else{
            echo "Ocurrio un Error con respecto a la Factura Nro: $factura, Contacte con el Administrador";
            die();
        }
        
    }
    // Permiso para modificar precio por debajo del  mimimo.
    function modPrecioBajoMinimo($user){
        $my = new My();
        $my->Query("SELECT count(*) as permiso from usuarios u inner join usuarios_x_grupo g using(usuario) inner join permisos_x_grupo p using(id_grupo) where u.usuario = '$user' AND  p.id_permiso = '1.6.2'");
        $my->NextRecord();
        if((int)$my->Record['permiso'] > 0){
            return true;
        }
        return false;
    }
}

function getFallas() {
    require_once("../Functions.class.php");
    $f = new Functions();
    $codigo = $_POST['codigo'];
    $lote = $_POST['lote'];
    $vender = $_POST['vender'];
    // Primero obtengo lo vendido
    $sql = "SELECT cant_ent - cantidad AS vendido,cantidad AS stock FROM stock WHERE codigo ='$codigo' and  lote = '$lote'";
    $vendido = $f->getResultArray($sql)[0]['vendido'];
     
    $rango_max =  $vendido + $vender;
    
    $fallas = "SELECT tipo_falla, mts_inv AS ubic_falla, mts_inv - $vendido as ubic_real,usuario,date_format(fecha,'%d-%m-%Y %h:%i') as fecha FROM fallas WHERE codigo ='$codigo' and  lote = '$lote' AND mts_inv BETWEEN $vendido AND $rango_max ORDER BY mts_inv ASC";
    //echo $fallas;
    echo json_encode($f->getResultArray($fallas));
}

function buscarArticulos() {
    $articulo = $_POST['articulo'];
       
    $limit = 30;
    if (isset($_POST['limit'])) {     
        $limit = $_POST['limit'];
    } else {
        $limit = 30;
    }
    $fn = new Functions(); 
    $articulos = $fn->getResultArray("SELECT codigo,descrip,um,img FROM articulos WHERE mnj_x_lotes = 'No' and (codigo like '$articulo' or descrip like '$articulo%')");
    echo json_encode($articulos);
}
function getPuntos(){
       require_once("../Functions.class.php");
       $cod_cli = $_POST['cod_cli'];
        
       $fn = new Functions();       
       $Qry = $fn->getResultArray("SELECT id, puntos, motivo, DATE_FORMAT( fecha,'%d-%m-%Y') as fecha, p.usuario, DATE_FORMAT( fecha_canje,'%d-%m-%Y') as fecha_canje , estado, valor FROM  puntos p, parametros pr WHERE cod_cli ='$cod_cli' and estado = 'Pendiente' and pr.clave = 'valor_puntos' ");
       echo json_encode($Qry);    
    }

new FacturaVenta();
?>
