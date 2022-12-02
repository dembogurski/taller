<?php

set_time_limit(0);
        
require_once 'SimpleXLS.php';
require_once '../Y_DB_MySQL.class.php';
$i = 0;
echo '<h1>Parse ProductosPuntoDiesel.xls</h1><pre>';
if ( $xls = SimpleXLS::parse('ProductosPuntoDiesel.xls') ) {
   $header_values = $rows = array();

	foreach ( $xls->rows() as $k => $r ) {
		if ( $k === 0 ) {
			$header_values = $r;
			continue;
		}
		$rows[] = array_combine( $header_values, $r );  
	}
            
        $db = new My();
        $db_p = new My();
        
        $db->Query("DELETE FROM historial_costos");
        
        $db->Query("DELETE FROM lista_prec_x_art;");

        $db->Query("DELETE FROM codigos_barras;");

        $db->Query("DELETE FROM articulos WHERE codigo <> 'SR001';");

        $db->Query("UPDATE sectores SET serie = 1 WHERE cod_sector <> 101");
        
        
        
        foreach ($rows as $key => $a) {
            $i++;
            $cod_sector = $a['COD_GRUPO'];
            $codigo_ant = $a['COD_PROD'];
            $descrip = $a['DETALLE'];
            $especificaciones =  sanitize($a['DESCRIPCION'],'string');
            $costo_prom = $a['PRECIO_COMPRA'];
             
            $codigo_barras = $a['CODIGO_BARRA']; 
            
            $precio_1 = $a['PRE_MINORISTA']; 
            $precio_2 = $a['PRE_MAYORISTA']; 
            $precio_3 = $a['PRE_DISTRIB']; 
             
            $codigo = getProximoCodigo($cod_sector);
            
            $q = "INSERT INTO taller.articulos(codigo, clase, descrip, cod_sector, um, costo_prom, costo_cif, costo_fob, art_venta, art_inv, art_compra, img, estado_venta,  especificaciones,    tipo, ancho, espesor, gramaje_prom, rendimiento, produc_ancho, produc_largo, produc_alto, produc_costo, mnj_x_lotes, estado)
            VALUES ('$codigo', 'Articulo', '$descrip', '$cod_sector', 'Unid', $costo_prom, $costo_prom, $costo_prom, 'true', 'true', 'true', '0/0', 'Normal',  '$especificaciones',  'tipo',0, 0, 0, 0, 0, 0, 0, 0, 'No', 'Activo');";
            
            echo "#$i Registrando:  $codigo $descrip  $costo_prom<br>";
            $db->Query($q);
            
            if($db->AffectedRows()>0){
                $db->Query("update sectores set serie = serie + 1 where cod_sector = $cod_sector;");
                $db_p->Query("INSERT INTO taller.lista_prec_x_art(num, moneda, um, codigo, precio, usuario, fecha)VALUES (1, 'G$', 'Unid', '$codigo', $precio_1, 'Sistema', current_date);");
                $db_p->Query("INSERT INTO taller.lista_prec_x_art(num, moneda, um, codigo, precio, usuario, fecha)VALUES (2, 'G$', 'Unid', '$codigo', $precio_2, 'Sistema', current_date);");
                $db_p->Query("INSERT INTO taller.lista_prec_x_art(num, moneda, um, codigo, precio, usuario, fecha)VALUES (3, 'G$', 'Unid', '$codigo', $precio_3, 'Sistema', current_date);");
                $db_p->Query("INSERT INTO taller.lista_prec_x_art(num, moneda, um, codigo, precio, usuario, fecha)VALUES (4, 'G$', 'Unid', '$codigo', $precio_3, 'Sistema', current_date);");
                $db_p->Query("INSERT INTO taller.lista_prec_x_art(num, moneda, um, codigo, precio, usuario, fecha)VALUES (5, 'G$', 'Unid', '$codigo', $precio_3, 'Sistema', current_date);");
                
                $db_p->Query("INSERT INTO taller.historial_costos ( codigo, usuario, fecha, cuenta_aum, cuenta_dism, costo_prom, costo_cif, notas)
                VALUES ( '$codigo', 'Sistema', CURRENT_DATE, '10001', '10001', $costo_prom, $costo_prom, 'Precio costo inicial');");
                
                if($codigo_barras != ""){
                    $db_p->Query("INSERT INTO taller.codigos_barras(codigo, barcode)VALUES ('$codigo', '$codigo_barras');");
                }
                
            }
        }
        
	echo "<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>><br>";
        print_r($rows);
    
} else {
	echo SimpleXLS::parseError();
}

function sanitize($var, $type)    {
        $flags = NULL;
        switch($type)
        {
            case 'url':
                $filter = FILTER_SANITIZE_URL;
            break;
            case 'int':
                $filter = FILTER_SANITIZE_NUMBER_INT;
            break;
            case 'float':
                $filter = FILTER_SANITIZE_NUMBER_FLOAT;
                $flags = FILTER_FLAG_ALLOW_FRACTION | FILTER_FLAG_ALLOW_THOUSAND;
            break;
            case 'email':
                $var = substr($var, 0, 254);
                $filter = FILTER_SANITIZE_EMAIL;
            break;
            case 'string':
            default:
                $filter = FILTER_SANITIZE_STRING;
                $flags = FILTER_FLAG_NO_ENCODE_QUOTES;
            break;
             
        }
        $output = filter_var($var, $filter, $flags);        
        return($output);
    }

function getResultArray($sql) {
    $db = new My();
    $array = array();
    $db->Query($sql);
    while ($db->NextRecord()) {
        array_push($array, $db->Record);
    }
    $db->Close();
    return $array;
}

function getProximoCodigo($cod_sector){
    $sql = "SELECT CONCAT(prefijo, LPAD(serie + 1,longitud,'0')) AS codigo, serie FROM sectores WHERE cod_sector = $cod_sector";   
    return  getResultArray($sql)[0]['codigo'];
 }

echo '<pre>';

?>
