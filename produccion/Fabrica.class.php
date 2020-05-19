<?php

/**
 * Description of EmisionProduccion
 * @author Ing.Douglas
 * @date 26/09/2017
 */
require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_DB_MSSQL.class.php");
 
class Fabrica {
    
    
    
    function __construct() {
        $action = $_REQUEST['action'];
         
        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }
    }

    function main() {

        $t = new Y_Template("Fabrica.html");

        $t->Show("headers");
        // Extrae los datos 
        $suc = $_REQUEST['suc'];
        
        $sql = "SELECT nro_emis, e.nro_orden,cod_cli,cliente,e.usuario,DATE_FORMAT(e.fecha,'%d-%m-%Y') AS fecha,obs,e.estado   FROM orden_fabric e  INNER JOIN emis_produc p ON e.nro_orden = p.nro_orden  WHERE   p.estado = 'En Proceso' and suc_d = '$suc' and p.e_sap = 1";
        $db = new My();
		
		$db->Query("SELECT lote,design from emis_det where design LIKE 'NAVIDE?O'");
        if($db->NumRows()> 0){
            $db->NextRecord();
            $lote_ = $db->Record['lote'];
            $design_ = $db->Record['design'];
            $new_design = utf8_encode('NAVIDEÑO');
            $db->Query("UPDATE emis_det SET design = '$new_design' WHERE design LIKE 'NAVIDE?O'"); //Parche para NAVIDEÑO 
        }
        
        $ms = new MS();
        
        $c = new Config();
        $host = $c->getNasHost();
        $path = $c->getNasFolder();
        $images_url = "http://$host/$path";
        $t->Set("images_url", $images_url);
        $t->Show("cabecera_emision");

        $dbd = new My();
        $db->Query($sql);

        while ($db->NextRecord()) {
            $nro_orden = $db->Record['nro_orden'];
            $cliente = $db->Record['cliente'];
            $usuario = $db->Record['usuario'];
            $fecha = $db->Record['fecha'];
            $nro_emis = $db->Record['nro_emis'];
            $obs = $db->Record['obs'];
            if ($nro_emis == null) {
                $nro_emis = "";
            }
            $t->Set("nro_orden", $nro_orden);
            $t->Set("nro_emis", $nro_emis);
            $t->Set("cliente", $cliente);
            $t->Set("usuario", $usuario);
            $t->Set("fecha", $fecha);
            $t->Set("obs", $obs);
            $t->Set("usuarios", $users);

            $t->Show("emision_cab");

            $dbd->Query("SELECT codigo,descrip,design,cantidad,largo,sap_doc FROM orden_det WHERE nro_orden = $nro_orden ");
            while ($dbd->NextRecord()) {
                $codigo = $dbd->Record['codigo'];
                $descrip = $dbd->Record['descrip'];
                $design = $dbd->Record['design'];
                $cantidad = $dbd->Record['cantidad'];
                $largo = $dbd->Record['largo'];
                $sap_doc = $dbd->Record['sap_doc'];
                $calc_mts = $cantidad * $largo;

                $t->Set("codigo", $codigo);
                $t->Set("descrip", $descrip);
                $t->Set("design", $design);
                $t->Set("cantidad", number_format($cantidad, 0, ',', '.'));
                $t->Set("medida", number_format($largo, 2, ',', '.'));
                $t->Set("mts", number_format($calc_mts, 0, ',', '.'));
                
                // Verifico si tiene asignado codigo de referencia de materia Prima
                $ms->Query("SELECT U_mat_pri_ref FROM OITT  WHERE Code = '$codigo'");
                if($ms->NumRows()>0){
                    $t->Set("display",'');
                    $t->Set("mensaje",'');
                }else{
                    $t->Set("display",'display:none');
                    $t->Set("mensaje",'Codigo de Referencia de Mat. Prima no Asignado');
                }
                
                $tipo_design = "%";
                
                $pos = stripos($descrip , "ESTAMPADO");
                
                if ($pos === false) {
                     $pos = stripos($descrip , "NAVIDAD");
                      if ($pos === false) {
                         $tipo_design = "%";
                      } else {
                         $tipo_design = "NAVIDAD";
                      }
                } else {
                    $tipo_design = "ESTAMPADO";
                }
                
                $t->Set("tipo_design", $tipo_design);

                //Buscar Ancho Importante para listar solo productos de ancho igual a este para articulos de otra medida, el ancho no puede variar
                
                $ms->Query("select BWidth1 as Anchor FROM OITM o WHERE ItemCode = '$codigo'");
                $ms->NextRecord();
                $Anchor = $ms->Record['Anchor'];
                
                $t->Set("anchor", number_format($Anchor, 2, '.', ','));
                $asign = "";
                if($sap_doc != null){
                    $ms->Query("select PickRmrk as AsignadoA from OWOR o where o.DocNum = $sap_doc");
                    if($ms->NumRows()>0){
                       $ms->NextRecord();
                       $asign = $ms->Record['AsignadoA'];
                    }            
                }
                $t->Set("asign", $asign);
                $t->Show("emision_det");
            }

            $t->Show("emision_foot");
        }
        $t->Show("area_emision");

        $db->Close();
        require_once("../utils/NumPad.class.php");
        new NumPad();
    }

}
function borrarCorte(){
    $nro_emision = $_REQUEST['nro_emision'];    
    $lote = $_REQUEST['lote'];
    $db = new My();
    $db->Query("DELETE FROM emis_det WHERE  nro_emis= $nro_emision AND lote = '$lote' AND fila_orig <> 1");
    $db->Query("update emis_det set saldo = null,cant_frac = null,tipo_saldo = null,diff = null  WHERE  nro_emis= $nro_emision AND lote = '$lote' AND fila_orig = 1");
    echo "Ok";
}
function agregarCortes(){
    $nro_emision = $_REQUEST['nro_emision'];
    $nro_orden = $_REQUEST['nro_orden'];
    $codigo = $_REQUEST['codigo'];
    $lote = $_REQUEST['lote'];
    $usuario = $_REQUEST['usuario'];
    $cortes = $_REQUEST['cortes'];
    $medida = $_REQUEST['medida'];
    $saldo = $_REQUEST['saldo'];
    $codigo_om = json_decode( $_REQUEST['codigo_om'],true);
    $ajuste = $_REQUEST['ajuste'];
    $tipo_saldo = $_REQUEST['tipo_saldo'];
    $suc = $_REQUEST['suc'];
    $stock = $_REQUEST['stock'];
    $codigo_ref = $_REQUEST['codigo_ref'];
    $um = 'Mts'; //Siempre es metros


    $db = new My();
    $sql = "UPDATE emis_det SET cant_frac = $cortes, largo = $medida,usuario = '$usuario',fecha = CURRENT_DATE,hora = CURRENT_TIME ,tipo_saldo = 'Articulo',saldo = 0 WHERE  nro_emis = $nro_emision AND  lote = '$lote';";
    $db->Query($sql);

    //require_once("../Y_DB_MSSQL.class.php");
    $ms = new MS();

    $ms->Query("SELECT  AvgPrice,cast(round(Quantity - isNull(i.IsCommited,0),2) as numeric(20,2)) as StockReal FROM OITM o, OIBT i WHERE  o.ItemCode = i.ItemCode and i.ItemCode = '$codigo' and i.BatchNum = '$lote' and WhsCode = '$suc'  ");
    $ms->NextRecord();
    $precio_costo = $ms->Record['AvgPrice'];
    //$StockReal = $ms->Record['StockReal'];

    
    foreach ($codigo_om as $arr) {
        $codigo_otm = $arr['codigo'];
        $largo = $arr['largo'];
        
        $db->Query("SELECT IF(MAX(id_det) IS NULL,0,MAX(id_det)) AS maxid  FROM emis_det WHERE nro_emis  = $nro_emision");
        $db->NextRecord();
        $max_id = $db->Record['maxid'];
        $max_id++;
        
        $db->Query("SELECT descrip,color,design  FROM emis_det WHERE nro_emis  = $nro_emision and codigo = '$codigo' and lote = '$lote'");
        $db->NextRecord();
        $descrip = $db->Record['descrip'];
        $color = $db->Record['color'];
        $design = $db->Record['design'];
        
        $ins = "INSERT INTO emis_det(nro_emis, nro_orden, id_det, codigo_ref, codigo, lote, descrip, color, design, cant_lote, usuario, cant_frac, largo, tipo_saldo, saldo, codigo_om, diff, fecha, hora, precio_costo, um,fila_orig)
        VALUES ($nro_emision, $nro_orden , $max_id, '$codigo_ref', '$codigo', '$lote', '$descrip', '$color', '$design', 1, '$usuario',1, $largo, 'Articulo', 0, '$codigo_otm', 0,CURRENT_DATE, CURRENT_TIME,$precio_costo, '$um',0);";
        $db->Query($ins);
    }
    

    $valor_ajuste = $precio_costo * $ajuste;
 

    // Si Ajuste es > a 0 (Ajuste Negativo) del valor del ajuste
    // Si Ajuste es Menor a 0 (Ajustar Positivamente) el valor del Ajuste

    if ($ajuste > 0) {
        
        $db->Query("SELECT IF(MAX(id_det) IS NULL,0,MAX(id_det)) AS maxid  FROM emis_det WHERE nro_emis  = $nro_emision");
        $db->NextRecord();
        $max_id = $db->Record['maxid'];
        $max_id++;
        $ins = "INSERT INTO emis_det(nro_emis, nro_orden, id_det, codigo_ref, codigo, lote, descrip, color, design, cant_lote, usuario, cant_frac, largo, tipo_saldo, saldo, codigo_om, diff, fecha, hora, precio_costo, um,fila_orig)
        VALUES ($nro_emision, $nro_orden , $max_id, '$codigo_ref', '$codigo', '$lote', '$descrip', '$color', '$design', $ajuste, '$usuario',1, $ajuste, 'Ajuste', $ajuste, null,$ajuste ,CURRENT_DATE, CURRENT_TIME,$precio_costo, '$um',0);";
        $db->Query($ins);
        
        $final = $stock - $ajuste;
        
        genAsiento($usuario,'6.1.4.1.17','Mermas en Stock','1.1.3.1.05','Fabricacion de Manteles',$valor_ajuste,"Faltante: $ajuste, Valor: $valor_ajuste PrecioCosto: $precio_costo");
        /*
        $db->Query("INSERT INTO ajustes( usuario,f_nro, codigo, lote, tipo,signo, inicial, ajuste, final, motivo, fecha, hora, um, estado,suc,p_costo,valor_ajuste, e_sap)
                    VALUES ('$usuario',0, '$codigo', '$lote', 'Disminucion en Produccion','-',$stock,$ajuste, $final, 'Fabrica Art.: $codigo_ref', CURRENT_DATE, CURRENT_TIME, '$um', 'Pendiente','$suc',$precio_costo,$valor_ajuste,0);");
        makeLog("$usuario", "Ajuste-", "Disminucion en Produccion | Fabrica Art.: $codigo_ref", 'Ajuste', 0);
        */
    } else if ($ajuste < 0) {
        $ajuste = $ajuste * -1;
        genAsiento($usuario,'1.1.3.1.05','Fabricacion de Manteles','4.1.2.1.07','Sobrante en Stock',$valor_ajuste,"Sobrante: $ajuste, Valor: $valor_ajuste PrecioCosto: $precio_costo");        
        
        /*
        if($tipo_saldo == "Retazo"){

           $final = $stock + $ajuste;
           $db->Query("INSERT INTO ajustes( usuario,f_nro, codigo, lote, tipo,signo, inicial, ajuste, final, motivo, fecha, hora, um, estado,suc,p_costo,valor_ajuste, e_sap)
           VALUES ('$usuario',0, '$codigo', '$lote', 'Aumento en Produccion','+',$stock,$ajuste, $final, 'Fabrica Art.: $codigo_ref', CURRENT_DATE, CURRENT_TIME, '$um', 'Pendiente','$suc',$precio_costo,$valor_ajuste,0);");
           makeLog("$usuario", "Ajuste+", "Aumento en Produccion | Fabrica Art.: $codigo_ref", 'Ajuste', 0);
          
        }*/
           
    }// Si 0 no ajustar
  
    if($saldo > 0){ // Aumentar el Lote Original porque ya salio todo
        $final = 0 + $saldo;
        $db->Query("INSERT INTO ajustes( usuario,f_nro, codigo, lote, tipo,signo, inicial, ajuste, final, motivo, fecha, hora, um, estado,suc,p_costo,valor_ajuste, e_sap)
        VALUES ('$usuario',0, '$codigo', '$lote', 'Aumento en Produccion','+',$stock,$saldo, $final, 'Saldo Retazo Fabrica Art.: $codigo_ref', CURRENT_DATE, CURRENT_TIME, '$um', 'Pendiente','$suc',$precio_costo,$valor_ajuste,5);");     
        makeLog("$usuario", "Ajuste+", "Aumento en Produccion | Retazo Fabrica Art.: $codigo_ref", 'Ajuste', 0);
        
        $db->Query("SELECT IF(MAX(id_det) IS NULL,0,MAX(id_det)) AS maxid  FROM emis_det WHERE nro_emis  = $nro_emision");
        $db->NextRecord();
        $max_id = $db->Record['maxid'];
        $max_id++;
        $ins = "INSERT INTO emis_det(nro_emis, nro_orden, id_det, codigo_ref, codigo, lote, descrip, color, design, cant_lote, usuario, cant_frac, largo, tipo_saldo, saldo, codigo_om, diff, fecha, hora, precio_costo, um,fila_orig)
        VALUES ($nro_emision, $nro_orden , $max_id, '$codigo_ref', '$codigo', '$lote', '$descrip', '$color', '$design', 0, '$usuario',1, $saldo, 'Retazo', $saldo, null,0 ,CURRENT_DATE, CURRENT_TIME,$precio_costo, '$um',0);";
        $db->Query($ins);
        // Cambiar Estado de Venta a Retazo
        
        //Calcular nuevos precios de Retazo, insertar en la Tabla HisPrecios
        
        $PORC_VALOR_MINIMO = 25;
        $PORC_MINIMO_RETAZO = 20;
         
        $MINIMO = "AvgPrice + AvgPrice * $PORC_VALOR_MINIMO / 100  ";
        
        $ms->Query("select AvgPrice, PriceList,Price, $MINIMO as Minimo,  ( AvgPrice + AvgPrice  *  25 / 100) + ((AvgPrice + AvgPrice  *  25 / 100)  *  20 / 100) as PrecioRetazo, 
        100 - (( $MINIMO ) + ($MINIMO) * $PORC_MINIMO_RETAZO / 100) * 100 / Price as Descuento  
        from oitm o, itm1 i where o.ItemCode = i.ItemCode and o.ItemCode = '$codigo' and PriceList < 8"); 
        
        while($ms->NextRecord()){
            $pl = $ms->Record['PriceList'];
            $Descuento = round($ms->Record['Descuento'],2);
            ${"desc".$pl} = $Descuento;
        }
        if($saldo < 3){
          $uptd = "update oibt set U_estado_venta = 'Retazo', U_desc1 = $desc1,U_desc2 = $desc2,U_desc3 = $desc3,U_desc4 = $desc4, U_desc5 = $desc5, U_desc6 = $desc6, U_desc7 = $desc7  where BatchNum = '$lote' and WhsCode = '$suc' and Quantity < 3";       
		  // $ms->Query($uptd);          
        }                                  
             
        
    }

    echo json_encode(array("estado" => "Ok"));
}
// Solo para Retazos menores a 3 metros
function setPrecioRetazo(){
    $codigo = $_REQUEST['codigo'];
    $lote = $_REQUEST['lote'];
    $usuario = $_REQUEST['usuario'];    
    $suc = $_REQUEST['suc'];
    $ms = new MS();
    
    $PORC_VALOR_MINIMO = 25;
    $PORC_MINIMO_RETAZO = 20;
         
    $MINIMO = "AvgPrice + AvgPrice * $PORC_VALOR_MINIMO / 100  ";
    
    $ms->Query("select AvgPrice, PriceList,Price, $MINIMO as Minimo,  ( AvgPrice + AvgPrice  *  25 / 100) + ((AvgPrice + AvgPrice  *  25 / 100)  *  20 / 100) as PrecioRetazo, 
    100 - (( $MINIMO ) + ($MINIMO) * $PORC_MINIMO_RETAZO / 100) * 100 / Price as Descuento  
    from oitm o, itm1 i where o.ItemCode = i.ItemCode and o.ItemCode = '$codigo' and PriceList < 8"); 
        
    while($ms->NextRecord()){
        $pl = $ms->Record['PriceList'];
        $Descuento = round($ms->Record['Descuento'],2);
        ${"desc".$pl} = $Descuento;
    }

    $uptd = "update oibt set U_estado_venta = 'Retazo', U_desc1 = $desc1,U_desc2 = $desc2,U_desc3 = $desc3,U_desc4 = $desc4, U_desc5 = $desc5, U_desc6 = $desc6, U_desc7 = $desc7  where BatchNum = '$lote' and WhsCode = '$suc' and Quantity < 3";
    $ms->Query($uptd);  
    echo "Ok";    
}
function genAsiento($usuario,$cuenta1,$cuenta1SN,$cuenta2,$cuenta2SN,$valor,$descrip){
    $my = new My();
    $my->Query("select id_frac from fraccionamientos order by id_frac desc limit 1");
    $my->NextRecord();
    $id_frac = $my->Record['id_frac'];  
    $my->Query("INSERT INTO  asientos(fecha, usuario, id_frac,descrip)VALUES (CURRENT_DATE, '$usuario', $id_frac,'$descrip');");
    
    $my->Query("select id_asiento from asientos  where usuario = '$usuario' order by id_asiento desc limit 1");
    $my->NextRecord();
    $id_asiento = $my->Record['id_asiento'];   
    
    // Detalle
    $my->Query("INSERT INTO asientos_det(id_asiento,id_det,cuenta, nombre_cuenta, debe, haber)
    VALUES ($id_asiento,1,'$cuenta1','$cuenta1SN', $valor, 0);");
    
    $my->Query("INSERT INTO asientos_det(id_asiento,id_det,cuenta, nombre_cuenta, debe, haber)
    VALUES ($id_asiento,2,'$cuenta2', '$cuenta2SN',0, $valor);");   
}
function finalizarEmision() {
    $nro_emision = $_REQUEST['nro_emision'];
    $usuario = $_REQUEST['usuario'];
    $db = new My();
    $dbi = new My();
    $ms = new MS();

    $sql = "SELECT codigo_ref,nro_orden, SUM(IF(fecha IS NOT NULL,1,0)) AS procesados,SUM(IF(fecha IS NULL,1,0)) AS no_procesados  FROM emis_det WHERE nro_emis = $nro_emision";
    $db->Query($sql);
    $db->NextRecord();

    $codigo_ref = $db->Record['codigo_ref'];
    $nro_orden = $db->Record['nro_orden'];
    $procesados = $db->Record['procesados'];
    $no_procesados = $db->Record['no_procesados'];
    $total = $procesados + $no_procesados;
    
    $ms->Query("SELECT U_mat_pri_ref FROM OITT  WHERE Code = '$codigo_ref'");
    $codigo_mat_prima_ref = "";
    if($ms->NumRows()<1){
        echo json_encode(array("estado" => "Error","msg"=>"Codigo Materia Prima Referencial no definido"));
        die();
    }else{
        $ms->NextRecord();
        $codigo_mat_prima_ref = $ms->Record['U_mat_pri_ref'];  
        
        
    if ($procesados < $total) {
        echo json_encode(array("estado" => "Error","msg"=>"DiffProc", "procesados" => $procesados, "no_procesados" => $no_procesados));
    } else {
        $db->Query("UPDATE emis_produc SET estado = 'Cerrada', fecha_cierre = CURRENT_DATE,hora_cierre = CURRENT_TIME WHERE nro_emis = $nro_emision");
        // Hacer resumen
        $db->Query("DELETE FROM prod_terminado WHERE nro_emis = $nro_emision");
        
        //Actualizar ajustes pendientes
        $db->Query("UPDATE emis_det d, ajustes a SET a.e_sap = 0 WHERE  d.lote = a.lote AND    a.e_sap = 5 AND nro_emis = $nro_emision");
        
        $db->Query("DELETE FROM prod_terminado WHERE   nro_emis = $nro_emision");

        $db->Query("SELECT codigo_ref,SUM(cant_frac) AS cortes,largo,tipo_saldo,descrip,color,design FROM emis_det WHERE nro_emis = $nro_emision  AND fila_orig = 1 AND codigo = '$codigo_mat_prima_ref'  GROUP BY codigo_ref");    
        
        $id = 1;
        while ($db->NextRecord()) {
            $codigo_ref = $db->Record['codigo_ref'];
            $cortes = $db->Record['cortes'];
            
            $descrip = getDescripProductoTerminado($codigo_om);
            
            $color = $db->Record['color'];
            $design = $db->Record['design'];
            $lote = generarLote();
            $ins = "INSERT INTO prod_terminado(nro_emis, nro_orden, id_res, codigo, lote, descrip, color, design, cant_frac,usuario,fecha)
                        VALUES ($nro_emision, $nro_orden,$id, '$codigo_ref', '$lote', '$descrip', '$color', '$design', '$cortes','$usuario',CURRENT_TIMESTAMP);";
            //echo $ins;
            $dbi->Query($ins);
            $id++;
        }
      
        //Procesar los Saldos de otros Articulos
        if($id > 1){    
            $db->Query("SELECT codigo_om,COUNT(codigo_om) AS cortes,tipo_saldo,descrip,color,design FROM emis_det WHERE nro_emis = $nro_emision  AND tipo_saldo = 'Articulo' AND codigo_om IS NOT NULL AND codigo <> 'IN030' AND fila_orig = 0  GROUP BY codigo_om ");
            while ($db->NextRecord()) {
                $codigo_om = $db->Record['codigo_om'];
                $cortes = $db->Record['cortes'];

                $descrip = getDescripProductoTerminado($codigo_om);
                $color = $db->Record['color'];
                $design = $db->Record['design'];
                $lote = generarLote();
                $dbi->Query("INSERT INTO prod_terminado(nro_emis, nro_orden, id_res, codigo, lote, descrip, color, design, cant_frac,usuario,fecha)
                            VALUES ($nro_emision, $nro_orden,$id, '$codigo_om', '$lote', '$descrip', '$color', '$design', '$cortes','$usuario',CURRENT_TIMESTAMP);");
                $id++;
            }
            // Cambiar tambien el estado de la Orden de Fabricacion
            $db->Query("UPDATE orden_fabric SET estado = 'Cerrada' WHERE nro_orden =  $nro_orden");

            echo json_encode(array("estado" => "Ok"));
        }
        }
    }
}
function getDescripProductoTerminado($codigo){
    require_once("../Y_DB_MSSQL.class.php");
    $ms = new MS();
    $ms->Query(" SELECT ItemName FROM OITM WHERE ItemCode = '$codigo'");
    $ms->NextRecord();
    $descrip = $ms->Record['ItemName'];
    return $descrip;
}

function generarLote() {
    require_once("../Y_DB_MSSQL.class.php");
    $ms = new MS();
    $year = date("Y");
    $ms->Query("select CONCAT(U_Serie,Name) as Lote from [@SERIES_LOTES] where Code = '$year';");
    $ms->NextRecord();
    $lote = $ms->Record['Lote'];
    $ms->Query("update [@SERIES_LOTES] set U_Serie = U_Serie + 1 where Code = '$year';");
    return $lote;
}

function reciboProduccionUI() {
    $t = new Y_Template("Fabrica.html");
    $t->Show("headers");
    $t->Show("recibo_produccion_ui");
}
function buscarDatosDeOrden(){
    $nro_emision = $_REQUEST['nro_emision'];
    $sql = "SELECT o.nro_orden,cod_cli,cliente,o.usuario,DATE_FORMAT(o.fecha,'%d-%m-%Y') AS fecha FROM orden_fabric o, emis_produc p WHERE o.nro_orden = p.nro_orden AND p.nro_emis = $nro_emision";
    $db = new My();
    $db->Query($sql);
    $array = array();

    while ($db->NextRecord()) {
        array_push($array, $db->Record);
    }
    $db->Close();

    echo json_encode($array);   
}
function planillaProduccion() {
    $nro_emision = $_REQUEST['nro_emision'];
    $sql = "SELECT id_res,codigo,lote,descrip,color,design,cant_frac AS unidades,usuario,DATE_FORMAT(fecha,'%d-%m-%Y %h:%i') AS fecha FROM prod_terminado WHERE nro_emis = $nro_emision";
    $db = new My();
    $db->Query($sql);
    $array = array();

    while ($db->NextRecord()) {
        array_push($array, $db->Record);
    }
    $db->Close();

    echo json_encode($array);
}

function imprimirCodigo() {
    $codigo = $_REQUEST['codigo'];
    $usuario = $_REQUEST['usuario'];
    $printer = $_REQUEST['printer'];
    $silent_print = $_REQUEST['silent_print'];
    
    $t = new Y_Template("Fabrica.html");
    
    $ms = new MS();
    $ms->Query("SELECT ItemCode,ItemName,BWidth1 as Ancho,BHeight1 as Largo  FROM OITM WHERE ItemCode = '$codigo' ");
    $ms->NextRecord();
    $ItemCode = $ms->Record['ItemCode'];
    $ItemName = $ms->Record['ItemName'];
    $Ancho =  number_format($ms->Record['Ancho'], 1, '.', ',') ;  
    $Largo =  number_format($ms->Record['Largo'], 1, '.', ',') ;       
    
    $t->Set("codigo", $ItemCode);
    $t->Set("descrip", $ItemName);
    $t->Set("medidas", "".$Largo."" );
    $t->Set("usuario", $usuario);


    $margin = 'Style="margin: 0;"';
    $marginTop = 0;
    $marginBottom = 0;
    $marginLeft = 0;
    $marginRight = 0;
    $scaling = 0;

    
    //$t->Set("printer",$printer);
    $t->Set("silent_print", false);
    $showFallas = false;
    $fallas = '';

    $etiqueta = "etiqueta_6x4";
    $tam = "6x4";
    if (isset($_REQUEST['etiqueta'])) {
        $etiqueta = $_REQUEST['etiqueta'];
        $tam = substr($etiqueta, 9, 30);
    }
    $t->Set("tam", $tam);

     $IPMargenCero = [
        '192.168.3.25',
        '192.168.3.48',
        '192.168.3.47',
        '192.168.3.27',
        '192.168.3.46',
        '177.222.15.163'
    ];

    if ($etiqueta == "etiqueta_6x4" && getOS() == 'Linux' && !in_array($_SERVER['REMOTE_ADDR'], $IPMargenCero)) {
	$marginTop = -5;
        $marginBottom = 0;
        $marginLeft = 30;
        $marginRight = 0;
        $showFallas = true;
        $scaling = 100;
        $margin = 'style="margin: -12px 0 0 16%;"'; 
        $t->Set("margin", $margin); 
    }
    $t->Set("marginTop", $marginTop);
    $t->Set("marginBottom", $marginBottom);
    $t->Set("marginLeft", $marginLeft);
    $t->Set("marginRight", $marginRight);
    $t->Set("scaling", $scaling);

    $my = new My();
    $my->Query("SELECT suc FROM usuarios WHERE usuario = '$usuario'");
    $my->NextRecord();
    $suc_user = $my->Record['suc'];

    $t->Show("barcode_headers");
    $t->Show($etiqueta);
}

function makeLog($usuario, $accion, $data, $tipo, $doc_num) {
    $db = new My();
    $db->Query("INSERT INTO logs(usuario, fecha, hora, accion,tipo,doc_num, DATA) VALUES ('$usuario', current_date, current_time, '$accion','$tipo', '$doc_num', '$data');");
    return true;
}

function getOS() {
    $agent = $_SERVER['HTTP_USER_AGENT'];
    if (preg_match('/Linux/', $agent))
        $os = 'Linux';
    elseif (preg_match('/Win/', $agent))
        $os = 'Windows';
    elseif (preg_match('/Mac/', $agent))
        $os = 'Mac';
    else
        $os = 'UnKnown';
    return $os;
}

function corregirDescripcionesProdTerminado(){
    $db = new My();
    $dbd = new My();
    
    $db->Query("select distinct codigo,descrip from prod_terminado");
    while($db->NextRecord()){
        $c = $db->Record['codigo'];
        $d = $db->Record['descrip'];
        $nd = getDescripProductoTerminado($c);
        $sq = "UPDATE prod_terminado SET descrip = '$nd' WHERE  codigo = '$c'";
        $dbd->Query($sq);
        echo $c." ".$d."   --> $nd <br>";
    }
}

function buscarMedida(){
    $ms = new MS();
    $Father = $_REQUEST['articulo'];
    $codigo = $_REQUEST['codigo'];
    $ms->Query("select Quantity from ITT1  WHERE Father = '$Father'  AND Code = '$codigo'");
    $ms->NextRecord();
    $Quantity = $ms->Record['Quantity'];
    echo json_encode(array("Cantidad"=>$Quantity));
}


new Fabrica();
?>



