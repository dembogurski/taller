<?php

/**
 * Description of Ubicar
 * @author Ing.Douglas
 * @date 10/10/2016
 */
require_once("../Y_Template.class.php");
require_once("../Config.class.php");
require_once("../utils/NumPad.class.php");
require_once("../Y_DB_MySQL.class.php");
require_once("../Functions.class.php");

class Ubicar {

    function __construct() {
        $action = $_REQUEST['action'];
        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }
    }

    function main() {

        $t = new Y_Template("Ubicar.html");

        $c = new Config();
        $host = $c->getNasHost();
        $path = $c->getNasFolder();
        $images_url = "http://$host/$path";
        $t->Set("images_url", $images_url);


        $t->Show("header");
        $t->Show("body");

        new NumPad();
    }

}
function buscarDatosDeCodigo(){
    $fn = new Functions();
    $code = $_POST['lote'];
    $suc = $_POST['suc'];
    $cat = $_POST['categoria'];
    
    $sql_lote = "SELECT l.codigo, b.barcode, l.lote,clase,descrip,um,costo_prom, composicion,mnj_x_lotes,gramaje,gramaje_m,tara, pantone, s.cantidad AS stock,l.img   FROM articulos a INNER JOIN lotes l INNER JOIN stock s   
    ON a.codigo = l.codigo AND l.codigo = s.codigo AND l.lote = s.lote  LEFT  JOIN codigos_barras b ON a.codigo = b.codigo WHERE (a.codigo ='$code' OR b.barcode = '$code' OR  l.lote = '$code') AND suc = '$suc' LIMIT 1";
    $datos  = $fn->getResultArray($sql_lote)[0];  //print_r($datos);
    
    //echo "sizeof():  ". sizeof( $datos);
    
    if(sizeof( $datos) > 0){ 
        $pantone = $datos['pantone'];
        $sql_color = $fn->getResultArray("SELECT nombre_color AS color FROM pantone WHERE pantone = '$pantone' AND estado ='Activo'")[0];
        $color = $sql_color['color'];
        $datos['color'] = $color;
        $datos['existe'] = "true";
        echo json_encode($datos);
    }else{ // No es manejado por lotes o no existe este lote buscar por Articulo y codigo de barras
        $sql_art = "SELECT a.codigo,clase,descrip,um,mnj_x_lotes, s.cantidad AS stock, img  FROM articulos a INNER JOIN stock s ON a.codigo = s.codigo  LEFT JOIN codigos_barras b ON a.codigo = b.codigo   WHERE (a.codigo ='$code' OR b.barcode = '$code') AND estado = 'Activo' LIMIT 1";
        $datos = $fn->getResultArray($sql_art)[0];
        //print_r($datos);
        if(sizeof( $datos) > 0){
           $datos['existe'] = "true";
           echo json_encode($datos);
        }else{
           $datos['existe'] = "false";
           echo json_encode($datos);
        } 
    } 
}

function getUbicaciones() {
    $suc = $_POST['suc'];
    $tipo = $_POST['tipo'];
    //require_once("../Y_DB_MSSQL.class.php");

    $sql = "SELECT ubic_nombre  as nombre, tipo  , filas,  cols, sentido FROM ubicaciones WHERE  tipo = '$tipo' AND  suc  = '$suc' ORDER BY  ubic_nombre ASC";
    // echo $sql;
    $db = new My();
    $db->Query($sql);
    $array = array();

    while ($db->NextRecord()) {
        array_push($array, $db->Record);
    }
    $db->Close();
    echo json_encode($array);
}

function ubicar() {
    try {
        $codigo = trim($_POST['codigo']);
        $lote = trim($_POST['lote']);
        $suc = $_POST['suc'];
        $ubicacion = $_POST['ubicacion'];
        $tipo = $_POST['tipo'];
        $fila = $_POST['fila'];
        $col = $_POST['col'];
        $pallet = $_POST['pallet'];
        $obs = $_POST['obs'];
        $usuario = $_POST['usuario'];
        $stock  = $_POST['stock'];
        
        $array = array();
        $db = new My();
        
        
        $db->Query("SELECT r.n_nro,CONCAT(r.suc,'->',r.suc_d) as direccion,r.usuario, r.estado FROM nota_remision r, nota_rem_det d WHERE   r.n_nro = d.n_nro AND r.estado <> 'Cerrada' AND d.lote = '$lote'");
        if ($db->NumRows() > 0) {
            $db->NextRecord();
            $n_nro = $db->Record['n_nro'];
            $direccion = $db->Record['direccion'];
            $user = $db->Record['usuario'];
            $estado = $db->Record['estado'];
            $array['mensaje'] = "Error: Lote en Remision $estado  Nro: $n_nro [$direccion] por: $user";
        } else {
             $fn = new Functions();
              
            // Actualizo la Ubicacion en el Lote

            
                $ms = new My();  
                $ant = "select   nombre ,suc, fila, col, nro_pallet as pallet,obs  from  reg_ubic  where codigo = '$codigo' and lote = '$lote' and  suc = '$suc' limit 1 ";
                $ms->Query($ant);
                if($ms->NumRows() > 0){
                    $ms->NextRecord();   
                    $nombre_ant = $ms->Record['nombre'];
                    $suc_ant = $ms->Record['suc'];
                    //$tipo_ant = $ms->Record['tipo'];
                    $fila_ant = $ms->Record['fila'];
                    $col_ant = $ms->Record['col'];
                    $pallet_ant = $ms->Record['pallet'];
                    $obs_ant = $ms->Record['obs'];
                            
                    $array['ubicacion_ant'] = $nombre_ant;
                    //$array['tipo_ant'] = $tipo_ant;
                    $array['fila_ant'] = $fila_ant;
                    $array['col_ant'] = $col_ant;
                    $array['pallet_ant'] = $pallet_ant;
                    $array['obs_ant'] = $obs_ant;
                    
                    $ms->Query("UPDATE reg_ubic SET  fecha_salida = CURRENT_TIMESTAMP, estado = 'Inactivo', usuario_salida = '$usuario' WHERE nombre = '$nombre_ant' and suc = '$suc_ant' and fila = $fila_ant and col = $col_ant and codigo = '$codigo' and lote ='$lote';");
                    
                    //Registrar la Nueva Ubicacion
                    $ins = "INSERT INTO reg_ubic (codigo,lote,suc,nombre,nro_pallet,fila,col, fecha_hora,usuario,hits,obs,cantidad,estado)
                    values('$codigo','$lote','$suc','$ubicacion','$pallet',$fila,$col, CURRENT_TIMESTAMP,'$usuario',1,'$obs',$stock,'Activo' )";
                    $ms->Query($ins);
                    
                    $fn->makeLog($usuario,"Ubicar" ,"Actualizar ubicacion Codigo:$codigo  Lote:$lote Ubic. Ant.: $suc_ant-$nombre_ant-$tipo_ant-$fila_ant-$col_ant P:$pallet_ant  --> $suc-$ubicacion-$tipo-$fila-$col P:$pallet  ");
                     
                }else{
                     //Registrar la Nueva Ubicacion
                    $ins = "INSERT INTO reg_ubic (codigo,lote,suc,nombre,nro_pallet,fila,col, fecha_hora,usuario,hits,obs,cantidad,estado)
                    values('$codigo','$lote','$suc','$ubicacion','$pallet',$fila,$col, CURRENT_TIMESTAMP,'$usuario',1,'$obs' ,$stock,'Activo')";
                    $ms->Query($ins);
                    
                    $fn->makeLog($usuario,"Ubicar" ,"Registrar ubicacion Codigo:$codigo  Lote:$lote    $suc-$ubicacion-$fila-$col P:$pallet  ");
                }
                $pallet_identif = "";
                if( strlen($pallet) > 0){
                    $pallet_identif = "P:$pallet";
                }
                $update = "UPDATE stock SET ubicacion = '$ubicacion-$fila-$col $pallet_identif' WHERE codigo = '$codigo' and lote = '$lote' and suc = '$suc'";
                $ms->Query($update);
                
                
                // Actualizar Ubicación en Notas de Pedido de traslados no cerradas en 00
                $my = new My();
                $nodo = $ubicacion . $col;
                $my->Query("UPDATE pedido_tras_det d INNER JOIN pedido_traslado p ON p.n_nro = d.n_nro SET d.ubic = '$ubicacion-$fila-$col', nodo = '$nodo' WHERE p.estado != 'Cerrada' AND p.suc_d='00' AND d.lote = '$lote'");
                if ($my->AffectedRows() > 0) {
                    $array['nota_pedido'] = "Ok";
                }
                $array['mensaje'] = "Ok";
             
        }
    } catch (Exception $e) {
        $array['mensaje'] = "Error: " . $e->getTrace();
    }
    echo json_encode($array);
}

function quitar(){
    $codigo = trim($_POST['codigo']);
    $lote = trim($_POST['lote']);
    $suc = $_POST['suc'];
    $ubicacion = $_POST['ubicacion'];
    $tipo = $_POST['tipo'];
    $fila = $_POST['fila'];
    $col = $_POST['col'];
    $pallet = $_POST['pallet']; 
    $usuario = $_POST['usuario'];
    $stock  = $_POST['stock'];  
    $mnj_x_lotes  = $_POST['mnj_x_lotes'];
    
    $db = new My();
    
    if($mnj_x_lotes == "Si"){
        $db->Query("update reg_ubic set estado ='Inactivo' , fecha_salida = current_timestamp, usuario_salida = '$usuario' where suc ='$suc' and codigo ='$codigo' and lote ='$lote' and estado = 'Activo'");
        if($db->AffectedRows() == 0){
            
            $qry = "SELECT CONCAT(usuario_salida,' de ',nombre,'-',fila,'-',col,'  en fecha: ', fecha_salida ) AS ultimo_reg FROM reg_ubic WHERE lote = '$lote' AND estado = 'Inactivo' ORDER BY id_ubic DESC LIMIT 1";
            $fn = new Functions();
            $arr = $fn->getResultArray($qry)[0]['ultimo_reg'];
          echo json_encode(array("mensaje"=>"No Ubicado","ultimo_reg"=>$arr));  
        }else{
          echo json_encode(array("mensaje"=>"Ok"));
        }
    }else{
        $db->Query("update reg_ubic set estado ='Inactivo' , fecha_salida = current_timestamp, usuario_salida = '$usuario' where suc ='$suc' and codigo ='$codigo' and lote ='' and estado = 'Activo' and nombre = '$ubicacion' and fila = '$fila' and col = '$col' ");
        if($db->AffectedRows() == 0){
            $qry = "SELECT nombre, fila,col,cantidad FROM reg_ubic WHERE estado = 'Activo' AND codigo = '$codigo'";
            $fn = new Functions();
            $arr = $fn->getResultArray($qry);
            echo json_encode(array("mensaje"=>"Articulo no se encuentra en este Cuadrante","cuadrantes"=>$arr));
        }else{
            echo json_encode(array("mensaje"=>"Ok"));
        }
    }
    
}

function loteExiste($codigo,$lote) {
    
    $ms = new My();
    $ms->Query("SELECT COUNT(*) AS existe FROM lotes WHERE codigo = '$codigo' and lote = '$lote'");
    $ms->NextRecord();
    if ((int) $ms->Record['existe'] > 0) {
        return true;
    } else {
        return false;
    }
}

function buscarCodigoEnDocumentos() {
    $codigo = $_POST['codigo'];
    $lote = $_POST['lote'];
    $suc = $_POST['suc'];
    require_once("../Y_DB_MySQL.class.php");

    //Buscar en Solicitudes de Traslado y en Remisiones
    $sql_remisiones = "SELECT 'NotaRemision' AS TipoDocumento ,n.n_nro AS Nro,usuario,DATE_FORMAT(fecha,'%d-%m-%Y') AS fecha,suc,n.estado,cantidad FROM nota_remision  n, nota_rem_det d WHERE n.n_nro = d.n_nro and d.codigo = '$codigo' AND d.lote = '$lote' AND n.suc = '$suc' AND n.estado != 'Cerrada'  ";

    $db = new My();
    $array = array();
    $db->Query($sql_remisiones);
    if($db->NumRows()> 0){
        while ($db->NextRecord()) {
           array_push($array, $db->Record);
        }
        $array["mensaje"] = "En Documentos";
    }else{
        $array["mensaje"] = "Ok";
    }
    

    $db->Close();
    echo json_encode($array);
}

function getPalletUbic() {
    $pallet = $_POST['pallet'];
 
    $sql = "SELECT   suc, nombre, fila,  col FROM  reg_ubic  WHERE  nro_pallet = '$pallet'  limit 1";
    $ms = new My();
    $ms->Query($sql);
    $array = array();
    if ($ms->NumRows() > 0) {
        $ms->NextRecord();
        array_push($array, $ms->Record);
    } else {
        $array[0] = array("suc" => "");
    }

    $ms->Close();
    echo json_encode($array);
}

function reubicarPallet() {
    $pallet = $_POST['pallet'];
    $suc = $_POST['suc'];
    $tipo = $_POST['tipo'];
    $ubicacion = $_POST['nombre'];
    $fila = $_POST['fila'];
    $col = $_POST['col'];
    $usuario = $_POST['usuario'];

     
    $ms = new MS();
    $ms2 = new MS();

    $lotes = "select nombre, fila,col, codigo,lote  from reg_ubic where nro_pallet = '$pallet' and suc = '$suc'";

    $ms->Query($lotes);
   $fn = new Functions();    

    while ($ms->NextRecord()) {
        $codigo = $ms->Record['codigo'];
        $lote = $ms->Record['lote'];
        
        $ubic_ant = $ms->Record['nombre'];
        $fila_ant = $ms->Record['fila'];
        $col_ant = $ms->Record['col'];
          
        $update = "UPDATE stock SET ubicacion = '$ubicacion-$fila-$col Pallet:$pallet' WHERE codigo = '$codigo' and lote = '$lote' and suc = '$suc'";
        $ms2->Query($update);
        
        $fn->makeLog($usuario,"Ubicar" ,"Mover Pallet $pallet de Ubicacion $ubic_ant-$fila_ant-$col_ant -->  $ubicacion-$fila-$col  Codigo:$codigo Lote:$lote  ");
    }

    $sql = "UPDATE reg_ubic SET  suc = '$suc', tipo = '$tipo', nombre = '$ubicacion', fila = $fila, col = $col, usuario = '$usuario', fecha_hora = CURRENT_TIMESTAMP, hits = hits + 1  WHERE  nro_pallet = '$pallet'";

    $ms->Query($sql);
     
    
    echo "Ok";
}

function verContenidoUbicacion() {

    $suc = $_POST['suc'];
    $tipo = $_POST['tipo'];
    $ubicacion = $_POST['ubicacion'];
    $fila = $_POST['fila'];
    $col = $_POST['col'];
    $pallet = $_POST['pallet'];
    if ($pallet == "") {
        $pallet = "%";
    }
    $db = new My();
     
    $fn = new Functions();
    
    $pallets = array();
    
    
    $db->Query("SELECT DISTINCT nro_pallet  FROM reg_ubic WHERE estado = 'Activo'  AND nro_pallet LIKE '$pallet' and nombre ='$ubicacion' and fila = $fila and col = $col ");
    while($db->NextRecord()){
        $nro_pallet = $db->Get("nro_pallet");
        
        $sql = "SELECT   r.codigo , r.lote, a.descrip,p.nombre_color AS color, r.cantidad AS almacenado, SUM(s.cantidad) AS StockActual  FROM reg_ubic r INNER JOIN articulos a ON r.codigo = a.codigo 
        INNER JOIN stock s ON r.codigo = s.codigo AND r.lote = s.lote INNER JOIN lotes l ON r.codigo =l.codigo AND r.lote = l.lote LEFT JOIN pantone p ON l.pantone =  p.pantone
        WHERE r.suc = s.suc  AND s.suc = '$suc' AND r.estado ='Activo' AND nro_pallet LIKE '$nro_pallet' and nombre ='$ubicacion' and fila = $fila and col = $col   AND r.lote <> '' GROUP BY r.codigo , r.lote  
        UNION
        SELECT   r.codigo , r.lote, a.descrip,'' AS color, r.cantidad AS almacenado, SUM(s.cantidad) AS StockActual  FROM reg_ubic r INNER JOIN articulos a ON r.codigo = a.codigo 
        INNER JOIN stock s ON r.codigo = s.codigo AND r.lote = s.lote
        WHERE r.suc = s.suc  AND s.suc = '$suc'  AND r.estado ='Activo' AND nro_pallet LIKE '$nro_pallet' and nombre ='$ubicacion' and fila = $fila and col = $col  AND r.lote = ''  GROUP BY r.codigo , r.lote,r.cantidad  ORDER BY lote DESC, descrip  ASC, color ASC ";
        $articulos = $fn->getResultArray($sql);
        array_push($pallets,array("pallet"=>$nro_pallet,"articulos"=>$articulos));
        
        //$pallets[$nro_pallet] = $articulos;
    }    
    
    $db->Close();
    echo json_encode($pallets);
}

function getPorcentajeUtilizado() {
    $suc = $_POST['suc'];
    $estante = $_POST['estante'];
    $sql = "select  fila, col, count(lote) as Piezas from  reg_ubic  u  where nombre = '$estante' and suc = '$suc'   group by  fila, col order by Piezas desc";
    $db = new My();
    $array = array();
    $db->Query($sql);
    while ($db->NextRecord()) {
        array_push($array, array_map('utf8_encode', $db->Record));
    }
    $db->Close();
    echo json_encode($array);
}

new Ubicar();
?>
