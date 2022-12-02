<?php

/**
 * Description of Recepcion
 * @author Ing.Douglas
 * @date 05/11/2015
 */
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_Template.class.php");
require_once("../Functions.class.php");
 

class EntradaMercaderias {

    function __construct() {
        $action = $_REQUEST['action'];
        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }
    }

    function main() {
        $t = new Y_Template("EntradaMercaderias.html");
        $estado = 'Abierta';

        $suc = $_POST['suc'];

        $db = new My();

        $t->Set("checked_Abierta", "");
        $t->Set("checked_Cerrada", "");
        if (isset($_REQUEST['estado'])) {
            $estado = $_REQUEST['estado'];
            $t->Set("checked_$estado", "checked='checked'");
        } else {
            $estado = 'Abierta';
            $t->Set("checked_Abierta", "checked='checked'");
        }
        $ms = new My();
        $ms->Query("SELECT pantone,nombre_color AS COLOR FROM pantone WHERE estado = 'Activo' ORDER BY nombre_color ASC");
        $colores = "";
        //array_map('utf8_encode', $ms->Record);
        while ($ms->NextRecord()) {    
            $color = utf8_encode( $ms->Record['COLOR']);    
            $colores.="'$color',";
        }
        $colores = substr($colores, 0, -1);
        $t->Set("colores", "[" . $colores . "]");

        $t->Set("texto_eliminar", "Eliminar");
        $t->Set("width", "5%");
        if ($estado != "Abierta") {
            $t->Set("display_ent", "none");
            $t->Set("texto_eliminar", "");
            $t->Set("width", "0%");
        }
        $my = new My();
        $t->Set("gmonedas", "[]");
        

        /**
         * Patrones de dise�o         
         */
        
        $my->Query("SELECT design AS Carpeta,descrip AS Patron FROM designs WHERE  estado = 'Activo'  order by design asc");
        $patrones = "";
        $pattern_codes = "";
        //array_map('utf8_encode', $my->Record);
        while ($my->NextRecord()) {
            $carpeta = utf8_encode($my->Record['Carpeta']);
            $patron = utf8_encode($my->Record['Patron']);
            $patrones.="'$patron',";
            $pattern_codes.="'$carpeta',";
        }
        $patrones = substr($patrones, 0, -1);
        $t->Set("designs", "[" . $patrones . "]");


        $t->Show("headers");
        $t->Show("script_entrada_merc");  
        $t->Show("head");

        // Las facturas internacionales deben entrar con fecha de hoy
        $db->Query("UPDATE entrada_merc SET fecha_fact = CURRENT_DATE WHERE estado = 'Recibida' AND origen = 'Internacional' AND e_sap IS NULL");

        $sql = "select id_ent,suc,usuario,cod_prov,proveedor,DATE_FORMAT(fecha,'%d-%m-%Y') as fecha,moneda,invoice,folio_num,n_nro,origen,pais_origen,sap_doc,estado from entrada_merc where estado = '$estado' and suc = '$suc'";

        $db->Query($sql);
        while ($db->NextRecord()) {
            $id = $db->Record['id_ent'];
            $suc = $db->Record['suc'];
            $usuario = $db->Record['usuario'];
            $cod_prov = $db->Record['cod_prov'];
            $proveedor = $db->Record['proveedor'];
            $fecha = $db->Record['fecha'];
            $moneda = $db->Record['moneda'];
            $invoice = $db->Record['invoice'];
            $folio_num = $db->Record['folio_num'];
            $origen = $db->Record['origen'];
            $pais_origen = $db->Record['pais_origen'];
            $estado = $db->Record['estado'];
            $sap_doc = $db->Record['sap_doc'];
            $n_nro = $db->Record['n_nro'];

            $t->Set("id", $id);
            $t->Set("invoice", $invoice);
            $t->Set("suc", $suc);
            $t->Set("usuario", $usuario);
            $t->Set("cod_prov", $cod_prov);
            $t->Set("proveedor", $proveedor);
            $t->Set("fecha", $fecha);
            $t->Set("moneda", $moneda);
            $t->Set("origen", $origen);
            $t->Set("pais_origen", $pais_origen);
            $t->Set("estado", $estado);
            $t->Set("sap_doc", $sap_doc);
            $t->Set("n_nro", $n_nro);
            $t->Show("line");
        }
        $t->Show("foot");
    }

}

function cambiarEstado() {
    $ref = $_POST['ref'];
    $estado = $_REQUEST['estado'];
    $db = new My();
    $db->Query("update entrada_merc set estado = '$estado'  where id_ent = $ref;");
    echo "Ok";
}

function cerrarEntradaMercaderias() {

    $ref = $_POST['ref'];
    $usuario = $_POST['usuario'];
    $tipo_doc = $_POST['tipo_doc'];  // OIGN = Entrada Directa
    
    //Llamo a esta funcion para corregir por las dudas, esta funcion se encuentra en Ajax y se llama al momento de tocar un gasto
    actualizarPorcentajeParticipacion($ref);
    
    $fn = new Functions();
    $db = new My();
        
    // Genero el Stock
    
    generarOActualizarStock( $ref );
    
    $db->Query("select count(*) as nulos from entrada_det where id_ent = $ref and precio_real is null");
    $db->NextRecord();
    $nulos = $db->get("nulos");
    if($nulos == 0){
    
        $dbu = new My();
        $dba = new My();

        $db->Query("SELECT origen FROM entrada_merc WHERE id_ent = $ref;");

        $db->NextRecord();

        $origen = $db->Record['origen'];
        if ($origen == "Nacional") {
            $db->Query("update entrada_merc set estado = 'Cerrada',usuario = '$usuario' where id_ent = $ref;");
        } else {
            $db->Query("update entrada_merc set estado = 'Cerrada',usuario = '$usuario',fecha_fact = current_date where id_ent = $ref;"); // Por pedido de Arnaldo Actualizar Fecha
        }
        $db->Query("UPDATE entrada_det SET printed=0 WHERE id_ent= $ref AND trim(printed)=''");

        // Desbloquear Stock

        //$db->Query("UPDATE stock SET estado_venta = 'Normal' WHERE tipo_ent = 'EM' and nro_identif = $ref;");

        // Buscar todos excepto los que se fabrican
        $db->Query("SELECT DISTINCT e.codigo FROM entrada_det e, articulos a WHERE e.codigo = a.codigo AND  e.id_ent = $ref");
        while($db->NextRecord()){
            $codigo = $db->Get("codigo");
            $PPP_CIF = $fn->calcPPP($codigo, $ref);
            $PPP = $PPP_CIF["PPP"];
            $PrecioCIF = $PPP_CIF["PrecioCIF"];
            if ($origen == "Nacional") { // Se mantiene el Precio CIF de la Ultima compra Internacional
              $dbu->Query("update articulos set costo_prom = $PPP where codigo ='$codigo'");
            }else{
                $dbu->Query("update articulos set costo_prom = $PPP, costo_cif = $PrecioCIF where codigo ='$codigo'");
            }
            if($dbu->AffectedRows() > 0){
                $dba->Query("INSERT INTO  historial_costos(  codigo, usuario, fecha, cuenta_aum, cuenta_dism, costo_prom, costo_cif, notas)
                VALUES ( '$codigo', '$usuario', current_date, '11317', '11317', $PPP, $PrecioCIF, 'Revalorizacion automatica por compra');");
            }
        }

        echo "Ok";
    }else{
        echo "Error: Cargar gastos: Precios Reales nulos";
    }
}


function generarOActualizarStock($id_ent){
    $db = new My();
    $db_l = new My();
    $datos = "SELECT d.id_ent, id_det, nro_pedido, id_pack, store_no, bale, piece, d.codigo, lote, d.descrip, d.um, cod_catalogo, fab_color_cod, precio, cantidad, subtotal, color, color_comb, design,   d.ancho, gramaje, obs, um_prod, cant_calc, cod_pantone, nro_lote_fab, quty_ticket, kg_desc, ancho_real, gramaje_m, tara,recibido, printed, notas, fraccion_de, d.img, initial_id,mnj_x_lotes,suc, usuario
    FROM  entrada_merc e, entrada_det d, articulos a WHERE e.id_ent = d.id_ent and d.codigo = a.codigo AND d.id_ent = $id_ent  ";
    $db->Query($datos);
    
    while($db->NextRecord()){
        $id_det= $db->Record['id_det']; 
        $usuario= $db->Record['usuario']; 
        $suc= $db->Record['suc']; 
        $nro_pedido= $db->Record['nro_pedido']; 
        $id_pack= $db->Record['id_pack']; 
        $store_no= $db->Record['store_no']; 
        $bale= $db->Record['bale']; 
        $piece= $db->Record['piece']; 
        $codigo= $db->Record['codigo']; 
        $lote= $db->Record['lote']; 
        $descrip= $db->Record['descrip']; 
        $umc= $db->Record['um']; 
        $cod_catalogo= $db->Record['cod_catalogo']; 
        $fab_color_cod= $db->Record['fab_color_cod']; 
        $precio= $db->Record['precio']; 
        $cantidad= $db->Record['cantidad']; 
        $subtotal= $db->Record['subtotal']; 
        $color= $db->Record['color']; 
        $color_comb= $db->Record['color_comb']; 
        $design= $db->Record['design'];  
        $ancho= $db->Record['ancho']; 
        $ancho_real= $db->Record['ancho_real']; 
        $gramaje= $db->Record['gramaje']; 
        $obs= $db->Record['obs']; 
        $um_prod= $db->Record['um_prod']; 
        $cant_calc= $db->Record['cant_calc']; 
        $pantone= $db->Record['cod_pantone']; 
        $nro_lote_fab= $db->Record['nro_lote_fab']; 
        $quty_ticket= $db->Record['quty_ticket']; 
        $kg_desc= $db->Record['kg_desc'];     
        $gramaje_m= $db->Record['gramaje_m']; 
        $tara= $db->Record['tara']; 

        $quty_c_um= $db->Record['cant_calc']; 
        $recibido= $db->Record['recibido']; 
        $printed= $db->Record['printed']; 
        $notas= $db->Record['notas']; 
        $fraccion_de= $db->Record['fraccion_de']; 
        $img= $db->Record['img']; 
        $initial_id= $db->Record['initial_id']; 
        $mnj_x_lotes = $db->Record['mnj_x_lotes']; 
        $cod_serie = substr($lote, -2);    
        
        if($kg_desc == null){ $kg_desc = 0; }
        if($ancho_real == null){ $ancho_real = 0; }
        if($gramaje == null){ $gramaje = 0; }
        if($tara == null){ $tara = 0; }

        if($mnj_x_lotes == "Si"){
            $db_l->Query("SELECT count(*) as cant FROM lotes WHERE codigo = '$codigo' and lote ='$lote'  ");   
            $db_l->NextRecord();
            $cant = $db_l->Record['cant'];
            if($cant > 0){ //Actualizar  // Se
                $upd_lotes_sql = "update lotes set  quty_ticket = $quty_ticket,quty_c_um = $cant_calc,  kg_desc = $kg_desc, ancho= $ancho_real, gramaje  = $gramaje_m, tara = $tara, notas = '$obs'  where id_ent = $id_ent AND id_det = $id_det and codigo = '$codigo' and lote = '$lote';";
                $db_l->Query($upd_lotes_sql);
            }else{ // Insertar
                $ins_lotes_sql = "INSERT INTO lotes
                (codigo, lote, cod_serie, pantone, umc, um_prod, nro_lote_fab, store, bag, nro_pieza, ancho, gramaje, gramaje_m, tara, kg_desc, quty_ticket, quty_c_um, color_comb, color_cod_fabric,design, cod_catalogo, notas, img, padre, rec, fecha_creacion, id_ent, id_det, id_frac, id_prod_ter)
                VALUES ('$codigo', '$lote', '$cod_serie', '$pantone', '$umc', '$um_prod', '$nro_lote_fab', '$store_no', '$bale', '$piece', $ancho_real, $gramaje_m, $gramaje_m, $tara, $kg_desc, $quty_ticket,"
                        . "  $quty_c_um , '$color_comb', '$fab_color_cod','$design', '$cod_catalogo', '$notas', '', '','$recibido', current_time, $id_ent, $id_det, null, null);"; 

                $db_l->Query($ins_lotes_sql);

            }
            verificarStock($suc,$id_ent,$id_det,$codigo,$lote,$quty_c_um,$kg_desc,$usuario,$ancho_real,$gramaje,$tara);
        }else{
            // Verificar Stock Crear una funcion
            verificarStock($suc,$id_ent,$id_det,$codigo,$lote,$quty_c_um,$kg_desc,$usuario,$ancho_real,$gramaje,$tara);
        }  
    }
}
function verificarStock($suc,$id_ent,$linea,$codigo,$lote,$cant_calc,$kg_desc,$usuario,$ancho_real,$gramaje,$tara){
    $db = new My();
    $db->Query("SELECT suc, codigo, lote,cant_ent,kg_ent,cantidad,ubicacion,estado_venta  from stock WHERE tipo_ent = 'EM' and codigo = '$codigo' and lote = '$lote' and suc = '$suc'");
    if($db->NumRows()>0){
        $db->NextRecord();
        $suc_ = $db->Get('suc');
        $codigo_ = $db->Get('codigo');
        $lote_ = $db->Get('lote');
        $db->Query("UPDATE stock SET cant_ent = cant_ent + $cant_calc,kg_ent = $kg_desc, cantidad = cantidad + $cant_calc   WHERE tipo_ent ='EM' and codigo ='$codigo_' and lote ='$lote_' and suc = '$suc_';");
        $db->Query("INSERT INTO historial( suc, codigo, lote, tipo_ent, nro_identif, linea, fecha_hora, usuario, direccion, cantidad,tipo_doc,nro_doc,ancho,gramaje,tara)
        VALUES (  '$suc_', '$codigo_', '$lote_', 'EM', $id_ent,$linea, current_timestamp, '$usuario', 'E', $cant_calc,'EM',$id_ent,$ancho_real,$gramaje,$tara);");
    }else{
        $db->Query("INSERT INTO stock(suc, codigo, lote, tipo_ent, nro_identif, linea, cant_ent, kg_ent, cantidad, ubicacion, estado_venta)
        VALUES ('$suc', '$codigo', '$lote', 'EM', $id_ent, $linea, $cant_calc, $kg_desc, $cant_calc, '', 'Normal');");
        $db->Query("INSERT INTO historial( suc, codigo, lote, tipo_ent, nro_identif, linea, fecha_hora, usuario, direccion, cantidad,tipo_doc,nro_doc,ancho,gramaje,tara)
        VALUES (  '$suc', '$codigo', '$lote', 'EM', $id_ent,$linea, current_timestamp, '$usuario', 'E', $cant_calc,'EM',$id_ent,$ancho_real,$gramaje,$tara);");
    }
    return true;
}


/*
 *  Calcula el % de Participacion*
 */
function actualizarPorcentajeParticipacion($id_ent){
    $db = new My();
    $dbd = new My();
    $db_g = new My();
    $db->Query("SELECT SUM(subtotal) * cotiz AS total_factura,cotiz as cotiz_factura FROM entrada_merc e, entrada_det d WHERE e.id_ent = d.id_ent and d.id_ent = $id_ent;");
    if ($db->NumRows() > 0) {
        $db->NextRecord();
        $total_factura = $db->Get("total_factura");
        $cotiz_factura = $db->Get("cotiz_factura");

        $total_gastos = 0;
        $db->Query("SELECT IF(SUM(valor_ref) IS NULL, 0, SUM(valor_ref)) AS total_gastos FROM ent_gastos WHERE id_ent =  $id_ent;");
        if ($db->NumRows() > 0) {
            $db->NextRecord();
            $total_gastos = $db->Get("total_gastos");
        }else{
            $total_gastos = 0;
        }

        $porc_recargo = round(($total_gastos * 100) / $total_factura, 4);

        $dbd->Query("update entrada_merc set porc_recargo = $porc_recargo where id_ent = $id_ent;");
         
        $dbd->Query("update entrada_det set precio_ms = (precio * $cotiz_factura)  where id_ent = $id_ent;");
        
        // Se Quita el % de valor del gasto respecto al % de participacion del articulo y se distribuye para todos los lotes
        /* Ej.:  Total Factura 100.000 
         * Total Gastos 15.000
         * Codigo C0001  % de participacion de 30%  --> 4500
         * 4500 distribuir entre todos los lotes
         */
        $c = 0;
        $dbd->Query("SELECT codigo,  porc_particip , (porc_particip * $total_gastos) / 100 AS gasto_a_distribuir,sum(cant_calc) AS suma_cant_calc FROM   entrada_det d WHERE  id_ent = $id_ent GROUP BY codigo");
        while($dbd->NextRecord()){
            $codigo = $dbd->Get('codigo');            
            $gasto_a_distribuir = $dbd->Get('gasto_a_distribuir');
            $suma_cant_calc = $dbd->Get('suma_cant_calc');
            $sobre_costo =  round(($gasto_a_distribuir / $suma_cant_calc),2);
            $db_g->Query("UPDATE entrada_det d, unidades_medida u SET sobre_costo = $sobre_costo, precio_real = (( precio  / um_mult) * $cotiz_factura ) + sobre_costo WHERE codigo = '$codigo' AND id_ent = $id_ent  AND d.um = u.um_cod ");
            $c++;
        }        
        return $c;
    }else{
        return 0;
    }    
}

function getImageColorPantoneLiso() {
    $codigo = $_POST['codigo'];
    $color = $_POST['color'];
    $sql = "SELECT pantone AS Pantone FROM  pantone  c WHERE nombre_color = '$color' AND  estado ='Activo'";
    $my = new My();
    $my->Query($sql);

    if ($my->NumRows() > 0) {
        $my->NextRecord();
        $Pantone = $my->Record['Pantone'];  

        $c = new Config();
        require_once("../Config.class.php");
        //$username = $c->getNasUser();
        //$password = $c->getNasPassw();
        $host = $c->getNasHost();
        //$path = $c->getNasPath();
        $folder = $c->getNasFolder();

        $nombre_imagen = "http://$host/$folder/$codigo/$Pantone.jpg";
        
        $thum =  "http://$host/$folder/$codigo/$Pantone.thum.jpg";
        
        
        $file_headers = @get_headers($nombre_imagen);
        
        $is_the_file_accessable = true;
        
        
        $pos = strpos($file_headers[0], '200 OK');
  
        if ($pos > -1) {
            $pos_thum = strpos($thum[0], '200 OK');
            if ($pos_thum > -1) {
               echo json_encode(array("color" => "$codigo/$Pantone","thumnail"=>$thum,"image"=>$nombre_imagen ));
            }else{
               echo json_encode(array("color" => "$codigo/$Pantone","thumnail"=>$nombre_imagen,"image"=>$nombre_imagen ));
            }
        }else{
            echo json_encode(array("color" =>"","thumnail"=>"","image"=>""));
        }
  
        
    } else {
        echo json_encode(array("color" => "","thumnail"=>"","image"=>""));
    }
}

function crearEntradaMercaderias() {
    $db = new My();
    $usuario = $_POST['usuario'];
    $invoice = strtoupper($_POST['invoice']);
    $pedidos = json_decode($_POST['pedidos']);
    $cod_prov = $_POST['cod_prov'];
    $suc = $_POST['suc'];
    $nombre_proveedor = $_POST['nombre'];
    $fecha_fact = $_POST['fecha'];
    $moneda = $_POST['moneda'];
    $cotiz = $_POST['cotiz'];
    $tipo = $_POST['tipo'];
    $pais_origen = $_POST['pais_origen'];
    $origen = 'Nacional';
    $timbrado = $_POST['timbrado'];
    if ($pais_origen != "PY") {
        $origen = 'Internacional';
    }
    if ($tipo != "OPCH") {
        $timbrado = '';
    }
    $primer_pedido = $pedidos[0];

    $sql = "insert into entrada_merc(suc, usuario, invoice,tipo_doc_sap,n_nro,  folio_num, cod_prov, proveedor, fecha, fecha_fact, moneda, cotiz, total, origen, pais_origen, coment, estado,timbrado)
                         values ('$suc','$usuario','$invoice','$tipo',0,'$invoice','$cod_prov','$nombre_proveedor',current_date,'$fecha_fact','$moneda','$cotiz',0,'$origen','$pais_origen','','Abierta','$timbrado');";
    $db->Query($sql);
    $db->Query("select id_ent from entrada_merc order by id_ent desc limit 1");
    if ($db->NumRows() > 0) {
        $db->NextRecord();
        $nro = $db->Record['id_ent'];
       
        echo $nro;
    } else {
        echo "Error";
    }
}

function buscarArticulos() {
    $articulo = $_POST['articulo'];    
     
    $moneda = $_POST['moneda'];
    
    $limit = 20;
    if (isset($_POST['limit'])) {
        $limit = $_POST['limit'];
    } else {
        $limit = 20;
    }
    require_once("../Functions.class.php");
    
    $fn = new Functions();
     
    $articulos = $fn->getResultArray("SELECT a.codigo, s.descrip AS sector, a.descrip,  a.um, a.costo_prom, a.img, GROUP_CONCAT( um_cod) AS umc, GROUP_CONCAT( u.um_prior) AS prior   FROM articulos a, sectores s, unidades_medida u  WHERE a.cod_sector = s.cod_sector AND   (u.um_cod  =  a.um OR a.um = u.um_ref ) AND (a.descrip LIKE '$articulo%' OR a.codigo LIKE '$articulo%') AND a.estado = 'Activo' and art_compra = 'true' GROUP BY a.codigo, a.um ORDER BY a.descrip ASC  limit $limit ");  // Agregar Estado
    echo json_encode($articulos);
}

function agregarDetalleEntrada() {
    
    $ref = $_POST['ref'];
    $store_no = $_POST['store_no'];
    $codigo = $_POST['codigo'];
    $um_art = $_POST['um_art'];
    $descrip = $_POST['descrip'];
    $color = trim($_POST['color']);
    $catalogo = $_POST['catalogo'];
    $cod_color = $_POST['cod_color'];
    $color_comb = trim($_POST['corlo_comb']);
    $design = trim($_POST['design']); 
    $umc = $_POST['umc'];
    $ancho = $_POST['ancho'];
    $gramaje = $_POST['gramaje'];
    $nro_lote_fab = $_POST['nro_lot_fab'];
    $nro_pedido = $_POST['nro_pedido'];
    $cantidad  = $_POST['cantidad'] ;
    $subtotal  = $_POST['subtotal'] ;
    $precio = $_POST['precio'];
    $bale_no = $_POST['bale_no'];
    $img = trim($_POST['img']);
    $correlativo = $_POST['correlativo'];
    $usuario =  $_POST['usuario'];
    
    if($img == "0/0"){
        $img= "'0/0'";
    }else if(strlen($img) > 3){
        $img= "'$img'";
    }else{
       $img = "NULL";
    }

    $desde_empaque = $_POST['desde_empaque'];
    $entrada_directa = $_POST['entrada_directa'];

    if (!isset($bale_no)) {
        $bale_no = 1;
    }
      

    $db = new My();
    $db->Query("SELECT  IF(MAX(id_det) IS NOT NULL,MAX(id_det),0)  AS maximo FROM entrada_det WHERE id_ent = $ref;");
    $db->NextRecord();
    $max = $db->Record['maximo'];
    $db->Query("SET @row_number:=$max;");
    $maximo = $max;

     

        $quty_ticket = 'null';
        $kg_desc = 'null';
        $ancho_real = 'null';
        $gramaje_m = 'null';
        $equiv = 'null';
        $recibido = null;
        $notas = "";
        $printed = 0;
 
        $max++;
         
        //$subtotal = $precio * $cantidad;


        if ($desde_empaque == "true" || $entrada_directa == "true") {
            $quty_ticket = $cantidad;
            $kg_desc = ($gramaje * $cantidad * $ancho ) / 1000;
            if($um_art == "Mts" && $umc == "Kg"){
                $kg_desc = $cantidad;
            }
            
            $ancho_real = $ancho;
            $gramaje_m = $gramaje;
            $equiv = $cantidad;
            $recibido = 'Si';
            $notas = "";
            $printed = 0;
        }


        $sql = "INSERT INTO entrada_det
        (id_ent, id_det, nro_pedido, id_pack,store_no, bale, piece, codigo, lote, descrip, um, cod_catalogo, fab_color_cod, precio, cantidad, subtotal, color, color_comb, design,  ancho, gramaje,um_prod,obs,nro_lote_fab,  quty_ticket,kg_desc,ancho_real,gramaje_m,equiv,recibido,notas,printed,img)values
        ($ref,$max,0, 0,NULL,NULL, $max, '$codigo','', '$descrip','$umc', NULL, NULL, $precio, $cantidad, $subtotal, NULL,"
                . " NULL, NULL,  NULL, NULL,'$um_art','',NULL, $quty_ticket,$kg_desc,NULL,NULL,$equiv,'$recibido','$notas','$printed',NULL);";
        $db->Query($sql);
        if ($correlativo == "true") {
            $bale_no++;
        }
     


    // Actualizo las cantidades calculadas en base a la unidad de Media
    corregirCantidadCalculadaEntradaMerc($ref);

    $sql = "SELECT  id_ent, id_det, nro_pedido, id_pack,store_no, bale, piece, codigo, lote, descrip, um, cod_catalogo, fab_color_cod, precio, cantidad, subtotal, color, color_comb, design, ancho, gramaje,obs,um_prod,cant_calc,nro_lote_fab FROM entrada_det "
            . "WHERE id_ent = $ref and id_det > $maximo ORDER BY store_no asc,bale asc,codigo asc,color asc;";
    $f = new Functions();
    echo json_encode($f->getResultArray($sql));
}


function corregirCantidadCalculadaEntradaMerc($ref) {
     
    $db = new My();
    $db2 = new My();
    // Calculo las cantidaddes para Unid y Mts
    $db->Query("UPDATE entrada_det SET cant_calc = cantidad   WHERE id_ent = $ref AND um = um_prod and (um = 'Unid' or um = 'Mts' or um = 'Kg')");
    // Para compras en cajas u otras unidades de medida
    $db->Query("UPDATE entrada_det d,  unidades_medida u  SET cant_calc = cantidad * u.um_mult   WHERE  d.um = u.um_cod AND id_ent = $ref");
    
    
    // Calculo las cantidaddes para Yardas
    $db->Query("UPDATE entrada_det SET cant_calc = cantidad * 0.9144   WHERE id_ent = $ref AND um = 'Yds' and um_prod = 'Mts'");

    //Calculo para pasar de Kgs a Metros
    //$db->Query("UPDATE entrada_det SET cant_calc = (cantidad * 1000)/(gramaje * ancho)   WHERE id_ent = $ref AND  um = 'Kg' and um_prod = 'Mts'");  
    // Esto es cuando recien se carga y todavia no tiene datos reales
    $db->Query("UPDATE entrada_det SET cant_calc = (cantidad * 1000)/(gramaje * ancho)   WHERE id_ent = $ref AND  um = 'Kg' and um_prod = 'Mts' and gramaje_m is null and kg_desc is  null and ancho_real is null");
	
    // Solo ejecutara esto si los datos de descarga no son nulos
    //Cuando ya tiene datos reales
    $db->Query("UPDATE entrada_det SET cant_calc = ((kg_desc*1000)/(gramaje_m*ancho_real))   WHERE um = 'Kg' and um_prod = 'Mts'  AND id_ent = $ref and gramaje_m is not null and kg_desc is not null and ancho_real is not null");

   
    
    
    
   
   // Actualiza precio Gs
   $db->Query("UPDATE  entrada_merc e, entrada_det d SET precio_ms = precio * cotiz  WHERE e.id_ent = d.id_ent AND e.id_ent = $ref;");
   
   // Calcula el % de participacion de cada Articulo  // , SUM(d.subtotal * cotiz) AS total_ms   
   $db->Query("SELECT cotiz, SUM(subtotal) AS total FROM  entrada_merc e, entrada_det d WHERE e.id_ent = d.id_ent AND e.id_ent = $ref;");
   $db->NextRecord();
   $total = $db->Get('total');
    
   $db->Query("update entrada_merc set total = $total WHERE  id_ent = $ref;");
   
   $db->Query("SELECT codigo,total,SUM(subtotal) AS subtotal,(SUM(subtotal) * 100  ) / total AS porc_particip FROM  entrada_merc e, entrada_det d WHERE e.id_ent = d.id_ent AND e.id_ent = $ref GROUP BY codigo");
   while($db->NextRecord()){
      $codigo = $db->Get('codigo');
      $porc_particip = $db->Get('porc_particip');       
      $db2->Query("update entrada_det set porc_particip = $porc_particip where id_ent = $ref and codigo = '$codigo'");
   }
   
}


function copiarPedidoEnEntrada() {
    $nros_pedidos = json_decode($_POST['nros_pedidos']);
    $ids = json_decode($_POST['ids']);
    $ref = $_POST['ref'];

    $db = new My();
    $db->Query("SELECT cod_prov FROM entrada_merc WHERE id_ent = $ref");
    $db->NextRecord();
    $cod_prov = $db->Record['cod_prov'];

    foreach ($nros_pedidos as $nro_pedido) {

        $ped_ids = "";

        foreach ($ids as $nro_id) {
            $p = explode('-', $nro_id);
            $nro = $p[0];
            $id = $p[1];
            if ($nro == $nro_pedido) {
                $ped_ids.="$id,";
            }
        }
        $ped_ids = substr($ped_ids, 0, -1);
        if (strlen($ped_ids) > 1) { 
            $sql = "INSERT INTO entrada_det
            (id_ent, id_det, nro_pedido, id_pack,store_no, bale, piece, codigo, lote, descrip, um, cod_catalogo, fab_color_cod, precio, cantidad, subtotal, color, color_comb, design,  ancho, gramaje, obs,nro_lote_fab)
            SELECT $ref,@row_number:=@row_number+1,$nro_pedido, 0,'$cod_prov', 1, @row_number, codigo,'',descrip,um_prod,c_catalogo, c_fab_color_cod, c_precio_compra, cantidad, c_precio_compra * cantidad, color, c_color_comb,  c_design,  0, 0, c_obs,'1'
            FROM nota_ped_comp_det WHERE   id_det in($ped_ids);"; // antes and (estado='Comprado' or estado='En Transito' or estado='En Deposito' or estado='Procesado') and
            copiarAEntrada($sql, $ref);
        }
    }

    echo "Ok";
}

function copiarPackingListEnEntrada() {
    $invoice = $_POST['invoice'];
    $ref = $_POST['ref'];

    $sql = "INSERT INTO entrada_det
   (id_ent, id_det, nro_pedido, id_pack,store_no, bale, piece, codigo, lote, descrip, um, cod_catalogo, fab_color_cod, precio, cantidad, subtotal, color, color_comb, design,  ancho, gramaje, obs,nro_lote_fab)
   SELECT $ref,@row_number:=@row_number+1,n_nro, id_pack,cod_prov, bale, piece, codigo, lote, descrip, um, cod_catalogo, fab_color_cod, precio, cantidad, subtotal, color, color_comb, design,  ancho, gramaje, obs,'1'
   FROM packing_list WHERE invoice = '$invoice';";
    copiarAEntrada($sql, $ref);

    echo "Ok";
}

function copiarAEntrada($sql, $ref) {
    $db = new My();
    $db->Query("SELECT IF(MAX(id_det) IS NULL,1,MAX(id_det)) FROM entrada_det INTO @row_number;");
    $db->Query($sql);
    // Buscar las unidades de medida
    $sql0 = stripslashes('SELECT  GROUP_CONCAT(DISTINCT CONCAT("\'",codigo,"\'")) as codigos , COUNT(codigo) AS cant FROM entrada_det WHERE id_ent = ' . $ref . ';');
    $db->Query($sql0);
    $db->NextRecord();
    $codigos = $db->Record['codigos'];
    $cant = $db->Record['cant'];
    
    if($cant > 0){
        $my = new My(); 
        $my->Query("select codigo,um,gramaje_prom,ancho from articulos where codigo  in($codigos);");    
        while ($my->NextRecord()) {
            $ItemCode = $my->Record['codigo'];
            $InvntryUom = $my->Record['um'];
            $GramajeProm = $my->Record['gramaje_prom'];
            $AnchoProm = $my->Record['ancho'];
            $db->Query("UPDATE entrada_det SET um_prod = '$InvntryUom' WHERE id_ent = $ref AND codigo = '$ItemCode'");
            $db->Query("UPDATE entrada_det SET ancho = '$AnchoProm' WHERE id_ent = $ref AND codigo = '$ItemCode' and ancho = 0");
            $db->Query("UPDATE entrada_det SET gramaje = '$GramajeProm' WHERE id_ent = $ref AND codigo = '$ItemCode' and gramaje = 0");
        } 
    }
   
    
    $db->Query("SET @row_number:=0;");

    $db->Query("insert into ent_gastos(id_ent, cod_gasto,  valor,cotiz,valor_ref) select  $ref,cod_gasto, valor,1,valor from inv_gastos where invoice = '$invoice';");
 

    corregirCantidadCalculadaEntradaMerc($ref);
    return true;
}

function modificarDetalleEntradaMercaderia() {
    $ref = $_POST['ref'];
    $id_det = $_POST['id_det'];
    $store_no = $_POST['store_no'];
    $codigo = $_POST['codigo'];
    $um_art = $_POST['um_art'];
    $descrip = $_POST['descrip'];
    $color = $_POST['color'];
    $catalogo = $_POST['catalogo'];
    $cod_color = $_POST['cod_color'];
    $color_comb = $_POST['corlo_comb'];
    $design = $_POST['design'];
    $umc = $_POST['umc'];
    $ancho = $_POST['ancho'];
    $gramaje = $_POST['gramaje'];
    $nro_lote_fab = $_POST['nro_lot_fab'];
    $cantidad = $_POST['cantidad'];
    $precio = $_POST['precio'];
    $bale = $_POST['bale'];
    $subtotal = $precio * $cantidad;
    $img = $_POST['img'];
    if ($img != "") {
        $img = "'$img'";
    } else {
        $img = "NULL";
    }

    $db = new My();

    $pantone = getCodigoPantone($color);

    $sql = "UPDATE entrada_det set codigo = '$codigo',descrip = '$descrip',um = '$umc', cod_catalogo= '$catalogo', fab_color_cod= '$cod_color',nro_lote_fab = '$nro_lote_fab', precio = $precio, cantidad = $cantidad,
    subtotal = $subtotal, color=  '$color', color_comb= '$color_comb', design= '$design',   ancho= $ancho, gramaje=$gramaje,um_prod= '$um_art', cod_pantone = '$pantone',bale = $bale, img = $img WHERE id_ent = $ref and id_det = $id_det; ";
    $db->Query($sql);

    // Actualizo las cantidades calculadas en base a la unidad de Media
    corregirCantidadCalculadaEntradaMerc($ref);

    $sql = "SELECT  id_ent, id_det, nro_pedido, id_pack,store_no, bale, piece, codigo, lote, descrip, um, cod_catalogo, fab_color_cod, precio, cantidad, subtotal, color, color_comb, design,  ancho, gramaje,obs,um_prod,cant_calc,nro_lote_fab,img FROM entrada_det "
            . "WHERE id_ent = $ref and id_det = $id_det ORDER BY store_no asc,bale asc,codigo asc,color asc;";
    $f = new Functions();
    
    echo json_encode($f->getResultArray($sql));
}
function getCodigoPantone($color) {
     
    $db = new My();
    $db->Query("SELECT pantone FROM pantone WHERE nombre_color = '$color' AND estado = 'Activo'");
    if ($db->NumRows() > 0) {
        $db->NextRecord();
        return $db->Record['pantone'];
    } else {
        return '';
    }
}
function getPreciosArticulo() {    
    $codigo = $_POST['codigo'];
    $f = new Functions();
    echo json_encode($f->getResultArray("SELECT num ,moneda,um,precio FROM lista_prec_x_art WHERE codigo = '$codigo' AND num < 8 ORDER BY moneda ASC, um DESC, num ASC"));
}    

function getDetalleEntradaMercaderias() {
    $id_ent = $_POST['id_ent'];
    $sql = "SELECT  id_ent, id_det, nro_pedido, id_pack,store_no, bale, piece, d.codigo, lote, d.descrip, d.um, cod_catalogo, fab_color_cod, precio, cantidad, subtotal, color, color_comb, design, d.ancho, d.gramaje,notas AS obs,
    um_prod,cant_calc,nro_lote_fab,d.img,a.mnj_x_lotes 
    FROM entrada_det d, articulos a WHERE d.codigo = a.codigo AND  id_ent = $id_ent ORDER BY store_no ASC ,bale ASC,codigo,color ASC;"; // ORDER BY bale ASC,codigo,color ASC,store_no ASC 
    $f = new Functions();
    echo json_encode($f->getResultArray($sql));
}

function generarLoteEntradaMercaderia() {
     
    $id_ent = $_POST['id_ent'];
    $ids = json_decode($_POST['ids']);
    $lotes = array();
    $db = new My();
    foreach ($ids as $id_det) {
        $db->Query("SELECT codigo from entrada_det WHERE id_ent = $id_ent AND id_det = $id_det; ");
        $db->NextRecord();
        $codigo = $db->Record['codigo'];
        $fn = new Functions();
        
        $lote = $fn->generarLote($codigo);
        
        $db->Query("UPDATE entrada_det SET lote = '$lote',initial_id = $id_det WHERE id_ent = $id_ent AND id_det = $id_det;");
        $lotes[$id_det] = $lote; 
    }
    echo json_encode($lotes);
}

function descargarExcel(){
    ini_set('memory_limit', '2048M');
    require_once '../utils/Excel.class.php';
    
    $db = new My();
     
    $id_ent = $_POST['id_ent'];
     
    $filename = "/www/pharmapy/files/excel/compras/$id_ent.xlsx";
    $filename_rel = "files/excel/compras/$id_ent.xlsx";
   
    $toExcelFile = array();
    
    $excel = new Excel();
     
     
    $headers  = array("ID","Suc","Usuario","Invoice","Nro Ped.","Factura","CodProv","Proveedor","Fecha","Fecha_Fact","Moneda","Cotiz","Total","Origen","Pais Origen","Coment","Estado","Sap Doc","porc_recargo");
    
    $db->Query("SELECT id_ent, suc, usuario, invoice, n_nro,folio_num, cod_prov, proveedor, fecha, fecha_fact, moneda, cotiz, total, origen, pais_origen, coment, estado, sap_doc, porc_recargo FROM  entrada_merc WHERE id_ent = $id_ent");
    while($db->NextRecord()){
       array_push($toExcelFile,$db->Record);              
    }
    
        
    // Detalle
    $det_cab = array("Id_Det", "Store","Bale","Piece","Codigo","Lote" ,"Descrip","UM","Cod.Cat","Cod.Color.Fab.","Precio","Cantidad","Subtotal","Precio Gs","Porc. Particip","Sobre Costo","Precio Real","Color","Color Comb","Design","Ancho","Gramaje","Obs","Um Prod","Cant Calc","Cod. Pantone","Nro. Lote Fab.","Quty Ticket","Kg Desc","Ancho Real","Gramaje_m","Tara","Equiv","Recibido","Printed","Notas","Fraccion De","Img");
    array_push($toExcelFile,$det_cab);              
    
   
    $db->Query("SELECT id_det,  store_no, bale, piece, codigo, lote,  descrip, um, cod_catalogo, fab_color_cod, precio, cantidad, subtotal, precio_ms,porc_particip, sobre_costo, precio_real, color, color_comb, design, ancho, gramaje, obs, um_prod, cant_calc, cod_pantone, nro_lote_fab, quty_ticket, kg_desc, ancho_real, gramaje_m, tara, equiv, recibido, printed, notas, fraccion_de, img FROM  entrada_det WHERE id_ent = $id_ent");
    
    while($db->NextRecord()){
       array_push($toExcelFile,$db->Record);              
    }
    $bold_rows = array(1,3); 
    $excel->createExcel($toExcelFile, $headers  , $filename,$bold_rows);
    //$excel->setActiveSheetIndex(0);
    //
    
    echo json_encode(array("mensaje"=>"Ok","url"=>$filename_rel));
    
}

function testPPP(){
    $codigo = $_REQUEST['codigo'];
    $id_compra = $_REQUEST['id_compra'];
     $db = new My();
        $db->Query("SELECT SUM(cantidad) AS stock_actual,a.costo_prom AS ppp,   SUM(cantidad) * a.costo_prom AS  valor_stock_actual FROM articulos a, stock s WHERE a.codigo = s.codigo AND s.codigo = '$codigo' AND tipo_ent = 'EM' AND nro_identif <> $id_compra AND s.estado_venta NOT IN( 'FP', 'Bloqueado') GROUP BY s.codigo");
        $stock_actual = 0;
        $precio_promedio_actual = 0;
        $valor_stock_actual = 0;
        
        if($db->NumRows()>0){
            $db->NextRecord();
            $stock_actual = $db->Get("stock_actual");
            $precio_promedio_actual = $db->Get("ppp");
            $valor_stock_actual = $db->Get("valor_stock_actual");
        }    
        
        echo "stock_actual  $stock_actual<br>";
        
        echo "valor_stock_actual  $valor_stock_actual<br>";
        
        $db->Query("SELECT SUM(cant_calc) AS cant_compra , SUM(cant_calc *  precio_real )   AS  valor_stock_comprado,cotiz, sum(d.sobre_costo) as total_gastos FROM articulos a, entrada_merc e, entrada_det d 
        WHERE  e.id_ent = d.id_ent AND a.codigo = d.codigo AND d.codigo = '$codigo'  AND e.id_ent = $id_compra and e.estado = 'Cerrada'  GROUP BY d.codigo ");
        $cant_compra = 0;
        $valor_stock_comprado = 0;
        
        
        $total_gastos = 0;
        if($db->NumRows()>0){
            $db->NextRecord();
            $cant_compra = $db->Get("cant_compra");
            $valor_stock_comprado = $db->Get("valor_stock_comprado");     
            $total_gastos = $db->Get("total_gastos");
        }   
        
         echo "cant_compra  $cant_compra<br>";
         
         echo "valor_stock_comprado:     ".  number_format($valor_stock_comprado, 2, ".", ".")." <br>";
         
         echo " total_gastos  $total_gastos<br>";
         
        
        $valor_stock_comprado += $total_gastos;
        
        echo "valor stock + gastos  $valor_stock_comprado<br>";
         
         
        $nuevo_ppp = ($valor_stock_actual + $valor_stock_comprado) / ($stock_actual + $cant_compra);
        
        
        echo " nuevo_ppp $nuevo_ppp<br>";
}
 

new EntradaMercaderias();
?>


