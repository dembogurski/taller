<?php
require_once 'SimpleXLS.php';
require_once '../Y_DB_MySQL.class.php';

echo '<h1>Parse books.xsl</h1><pre>';
if ( $xls = SimpleXLS::parse('clientes_puntodiesel.xls') ) {
   $header_values = $rows = array();

	foreach ( $xls->rows() as $k => $r ) {
		if ( $k === 0 ) {
			$header_values = $r;
			continue;
		}
		$rows[] = array_combine( $header_values, $r );  
	}
        
        $db = new My();
        
        foreach ($rows as $key => $a) {
            $cod_cli = getCodCli();
            $cat = $a['ID_CATEGORIA'];
            $doc = $a['DI'];
            $nombre = $a['NOMBRE']." ".$a['APELLIDO'];
            $email = $a['E_MAIL'];
            $fecha_reg = $a['FECHA_ENTRADA'];
            $tel = $a['TELEFONOS'];
            $dir = $a['DIRECCION'];
            $ciudad = $a['LOCALIDAD'];
            
            $q = " INSERT INTO taller.clientes(cod_cli, cta_cont, tipo_doc, ci_ruc, nombre, cat, suc, moneda, tel, email,   pais,  ciudad, dir, usuario,  fecha_reg, fecha_ins, limite_credito, plazo_maximo, cant_cuotas, cuotas_atrasadas, e_sap)
            VALUES ('$cod_cli', '100001', 'C.I.', '$doc', '$nombre', $cat , '01', 'G$', '$tel', '$email',  'PY',  '$ciudad', '$dir', 'sistema', '$fecha_reg', CURRENT_DATE, 0, 0, 0, 0, 1);";
            
            
            $db->Query($q);
        }
        
	echo "<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>><br>";
        print_r($rows);
    
} else {
	echo SimpleXLS::parseError();
}

function getCodCli(){
        $ms = new My();
        $SQLCardCode = "SELECT CONCAT('C',LPAD((SUBSTRING(cod_cli,2) +1),6,'0')) as CardCode   FROM clientes ORDER BY cod_cli DESC LIMIT 1";
        $ms->Query($SQLCardCode);
        if($ms->NumRows()>0){
            $ms->NextRecord();           
            $NewCardCode = $ms->Record['CardCode']; // Actual Max CardCode. 
            return $NewCardCode;
        }else{
           return  "C000001";
        }
}

echo '<pre>';

?>