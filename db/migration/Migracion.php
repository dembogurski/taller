<?php

ini_set('max_execution_time', 5600);

/**
 * Description of Migracion
 *
 * @author Doglas
 */

require_once("Y_DB_MySQL.class.php");   
require_once("Y_DB_MSSQL.class.php"); 
require_once("../../Y_Template.class.php");

class Migracion {
    
    function __construct() {
        $action = $_REQUEST['action'];
        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }
    }

    function main() {   
        $t = new Y_Template("Migracion.html");
        $t->Show("header");
        $t->Show("body");
    }
}
function checkMigratedTables(){
    $table = $_REQUEST['tabla'];
    $mig = new My();
    $mig->Database = "marijoa";
   
    if( $table == "migrarTablasBasiscas"){      
        echo 1;
    }else{
        $mig->Query("SELECT count(*) as Items FROM marijoa.$table  ");   

        $mig->NextRecord();
        $Items = $mig->Record['Items'];
        echo $Items;
    }
    
}

function migrarTablasBasiscas(){
    $tables = array("tipo_vendedor","sucursales","grupos","usuarios","usuarios_x_grupo","usuarios_x_suc", "usuarios","bancos","bcos_ctas","cotizaciones","nodos","lista_adyacencias",
                    "monedas","mon_subdiv","permisos","permisos_x_grupo","unidades_medida","descuentos");
    $db = new My();
    
    $usuarios_query = "INSERT INTO marijoa.usuarios(usuario, passw, HASH, doc, nombre, apellido, tel, email, pais, dir, fecha_nac, fecha_cont, limite_sesion, imagen, suc, estado, id_tipo, sueldo_fijo, sueldo_contable)
    SELECT usuario, passw, HASH, doc, nombre, apellido, tel, email, pais, dir, fecha_nac, fecha_cont, limite_sesion, imagen, suc, estado, id_tipo, sueldo_fijo, sueldo_contable
    FROM marijoa_sap.usuarios;";
    
    $bcos_ctas_query = " INSERT INTO marijoa.bcos_ctas(id_banco, cuenta, nombre, tipo, m_cod, cta_cont, estado)   SELECT id_banco, cuenta, nombre, tipo, m_cod, cta_cont, estado FROM marijoa_sap.bcos_ctas;";
    
    foreach ($tables as $table) {
        
        $db->Query("SELECT count(*) as Items FROM marijoa.$table  ");   
        $db->NextRecord();
        $Items = $db->Record['Items'];
        if($Items == 0){
          $Qry = "INSERT INTO marijoa.$table SELECT * from marijoa_sap.$table;";
          
          if($table == "usuarios"){   
              $Qry = $usuarios_query;    
              // Extras necesarios
              $db->Query(" INSERT INTO marijoa.usuarios(usuario, passw, HASH, doc, nombre, apellido, tel, email, pais, dir, fecha_nac, fecha_cont, limite_sesion, imagen, suc, profesion, cargo, hora_entrada, hora_salida, id_tipo, sueldo_fijo, sueldo_contable, cta_cont, estado)
              VALUES ('*', '*', '*', 'N/A', 'generico', 'Usuario Generico', '', '', 'PARAGUAY', '', '2001-01-01', '2001-01-01',0, 'no_img', '00', 'N/A', 'N/A', 'N/A', 'N/A', 'GV', 0, 0, 1, 'Activo');");
              
          }
          if($table == "bcos_ctas"){   $Qry = $bcos_ctas_query;     }
          
          $db->Query($Qry);
          echo "Ok $table<br>";
        }else{
            echo "Ok <b>'$table'</b> Pre Migrada...<br>";
        }        
    }
    
    
    // Tablas Especiales
    
    
    
}

function monedas(){
    $db = new My();
    $my = new My();
    $db->Database = "marijoa_sap";
    $my->Database = "marijoa";
    $Qry = "select m_cod, m_descri, m_ref from marijoa_sap.monedas ";
    $db->Query($Qry);
    while ($db->NextRecord()){
        $m_cod = $db->Record['m_cod'];
        $m_descri = $db->Record['m_descri'];
        $m_ref  = $db->Record['m_ref'];
        $my->Query("insert into marijoa.monedas(m_cod, m_descri, m_ref)values ('$m_cod', '$m_descri', '$m_ref');");
    }
    echo "Ok";
}

 
function plan_cuentas(){
    $ms = new MS();
    $db = new My();
    $db->Database = "marijoa";
    
    /*
    $db->Query("SET FOREIGN_KEY_CHECKS=0;");
        
    
    $db->Query("SET FOREIGN_KEY_CHECKS=1;");    
     * 
     *  
    */
    
    require_once("../../lib/phpspreadsheet/vendor/autoload.php");
    
      
    $inputFileName = 'PLAN_DE_CUENTAS_2019.xlsx';

/** Create a new Xls Reader  **/
$reader = new \PhpOffice\PhpSpreadsheet\Reader\Xlsx();
 $reader->setReadDataOnly(true);
$spreadsheet = $reader->load($inputFileName);
  $schdeules = $spreadsheet->getActiveSheet()->toArray();
    
     
    
  foreach ($schdeules as $key => $value) { 
        $cuenta = $value[0];
        $nombre = $value[1];
        $nivel = $value[2];
        $AD = $value[3];
        $NS = $value[4];
        $padre = $value[5];
        $moneda = 'G$';
        
        if($NS === "N"){
            $NS = 'No';
        }else{
            $NS = 'Si';
        }
                
        $pos = strpos($nombre, "U$");
        if($pos !== false){
            $moneda = 'U$';
        }
        $db->Query("INSERT INTO marijoa.plan_cuentas(cuenta, nombre_cuenta, moneda, padre, tipo, asentable, nivel, saldo, saldoMS, suc, estado)
        VALUES ('$cuenta', '$nombre', '$moneda', '$padre', '$AD', '$NS', $nivel, 0, 0, '*', 'Activa');");   
  } 
    
    
    
    /*
    
    require_once("../../utils/PHPExcel/IOFactory.php");
    $inputFileName = 'PLAN_DE_CUENTAS_2019.xlsx';
        try {
            $inputFileType = PHPExcel_IOFactory::identify($inputFileName);
            $objReader = PHPExcel_IOFactory::createReader($inputFileType);
            $objPHPExcel = $objReader->load($inputFileName);
            //  Get worksheet dimensions
            $sheet = $objPHPExcel->getSheet(0);
            $highestRow = $sheet->getHighestRow();
            $highestColumn = $sheet->getHighestColumn();
     
            
            $db = new My();
            //  Loop through each row of the worksheet in turn  $highestRow
            for ($row = 2; $row <= 179; $row++) {         
                //  Read a row of data into an array
                $arr = $sheet->rangeToArray('A' . $row . ':' . $highestColumn . $row, NULL, TRUE, FALSE);
                 
                $cuenta = $arr[0][0];
                $nombre = $arr[0][1];
                $nivel = $arr[0][2];
                $dec_ac = $arr[0][3];
                $NS = $arr[0][4];                
                $padre = $arr[0][5]; 
                
                $moneda = 'G$';
                
                $pos = strpos($nombre, "U$");
                if($pos !== false){
                    $moneda = 'U$';
                }
                
                echo "$cuenta -  $padre  $nombre   $nivel  $dec_ac  $NS      $moneda<br>";
                  /*
                $db->Query("INSERT INTO marijoa.plan_cuentas  (cuenta, nombre_cuenta, moneda, padre, nivel, saldo, saldoMS, suc, estado)
                VALUES ('$cuenta', '$nombre', '$moneda', '$padre', '$nivel', 0, 0, '*', 'Activa');");   
            }
        
        } catch (Exception $e) {
            die('Error loading file "' . pathinfo($inputFileName, PATHINFO_BASENAME) . '": ' . $e->getMessage());
        }
        */
    
    echo "Ok";
}
function paises(){
    $db = new My();
    $ms = new MS();
    $sql = "SELECT  Code,Name  FROM OCRY";
    $ms->Query($sql);
    
    while($ms->NextRecord()){
        $Code = $ms->Record['Code']; 
        $Name = $ms->Record['Name']; 
        $db->Query("INSERT INTO marijoa.paises(codigo_pais, nombre)VALUES ('$Code', '$Name');");
    }  
    echo "Ok";
}

function clientes(){
    $sql = "SELECT DISTINCT TOP 10000000   c.CardCode,c.CardName,c.LicTradNum,c.StreetNo, c.Address,c.Phone1,c.City,c.Country,p.Name AS Pais, c.GlblLocNum,c.ListNum,c.CreditLine,
           c.U_POR_ANTICI,c.U_CUOTAS,c.U_PLAZO, c.U_RUBRO, c.U_tipo_doc, c.U_usuario, c.U_suc, c.AddID AS Ocupacion,c.VatIdUnCmp AS Situacion,c.IntrstRate AS CuotasAtrasadas 
    FROM OCRD c, OINV o, OCRY p WHERE c.CardCode = o.CardCode AND CardType = 'C' AND c.Country = p.Code ORDER BY c.CardCode ASC ";
    $ms = new MS();
    $db = new My();
    $db->Database = "marijoa";
    $db->Query("SET FOREIGN_KEY_CHECKS=0;");
    
    
    $ms->Query($sql);
    
    
     while($ms->NextRecord()){
        $CardCode = $ms->Record['CardCode']; 
        $CardName =  purify($ms->Record['CardName']) ;
        $RUC = $ms->Record['LicTradNum'];
        $tipo_doc = $ms->Record['U_tipo_doc'];
        $StreetNo = purify($ms->Record['StreetNo']);
        $Phone1= $ms->Record['Phone1'];
        $City = strtoupper( purify($ms->Record['City']) );
        $Country = $ms->Record['Country'];
        $Pais = $ms->Record['Pais'];
        $GeoLoc = $ms->Record['GlblLocNum']; 
        if(is_null($GeoLoc )){
            $GeoLoc = '';
        }
        $cat = $ms->Record['ListNum'];
        $CreditLine = round($ms->Record['CreditLine']);
        $porc_antic = round($ms->Record['U_POR_ANTICI']);
        $max_cuotas = getNumeric($ms->Record['U_CUOTAS']);
        $plazo_max = getNumeric($ms->Record['U_PLAZO']);
        $CuotasAtrasadas = round(getNumeric($ms->Record['CuotasAtrasadas']));
        $rubro = $ms->Record['U_RUBRO'];
        $usuario_reg = $ms->Record['U_usuario']; 
        $suc = $ms->Record['U_suc'];
        if($suc == ''){
          $suc = '00';  
        }
        $Ocupacion = purify($ms->Record['Ocupacion']);
        $Situacion = $ms->Record['Situacion'];
        $cta_cont = '1.1.2.2.01';
        if($Country !== 'PY'){
            $cta_cont = '1.1.2.2.02';
        }
        $db->Database = "marijoa"; 
         
        $insert = "INSERT INTO marijoa.clientes(cod_cli, cta_cont, tipo_doc, ci_ruc, nombre, cat, suc, tel, email, fecha_nac, pais, estado, ciudad, dir, geoloc, ocupacion, situacion, tipo, usuario, fecha_reg, fecha_ins, plazo_maximo, cant_cuotas, cuotas_atrasadas,limite_credito)
        values ('$CardCode', '$cta_cont', '$tipo_doc', '$RUC', '$CardName', '$cat', '$suc', '$Phone1', '', CURRENT_DATE, '$Pais', 'Activo', '$City', '$StreetNo', '$GeoLoc', '$Ocupacion', '$Situacion','', '$usuario_reg', CURRENT_DATE, CURRENT_DATE,$plazo_max,$max_cuotas, $CuotasAtrasadas,$CreditLine);";
       
        
        $db->Query($insert);
     }
    echo "Ok";
}

function contactos(){
    $sql = "SELECT CardCode,Name as ID,  Title as CI,FirstName as Nombre, LastName as Apellido FROM OCPR WHERE Title IS NOT null";
    $ms = new MS();
    $db = new My();
    $db->Database = "marijoa";
     
    $ms->Query($sql);
        
    while($ms->NextRecord()){
        $CardCode = $ms->Record['CardCode']; 
        $ID =  purify($ms->Record['ID']) ;
        $FirstName = purify($ms->Record['Nombre']);
        $LastName = purify($ms->Record['Apellido']);
        $doc =  purify($ms->Record['CI']) ;
        $db->Query("INSERT INTO marijoa.contactos(id_contacto, codigo_entidad, nombre, doc, tel)
        VALUES ('$ID', '$CardCode', '$FirstName $LastName', '$doc', '');");
    }
     
     
     echo "Ok";
}

function proveedores(){
    $sql = "SELECT   c.CardCode,c.CardName,c.LicTradNum,c.StreetNo, c.Address,c.Phone1,c.City,c.Country,p.Name AS Pais, c.GlblLocNum,c.ListNum,c.CreditLine,
           c.U_POR_ANTICI,c.U_CUOTAS,c.U_PLAZO, c.U_RUBRO, c.U_tipo_doc, c.U_usuario, c.U_suc, c.AddID AS Ocupacion,c.VatIdUnCmp AS Situacion,c.IntrstRate AS CuotasAtrasadas 
    FROM OCRD c , OCRY p WHERE   CardType = 'S' AND c.Country = p.Code AND FrozenFor = 'N' ORDER BY c.CardCode ASC";
    $ms = new MS();
    $db = new My();
    $db->Database = "marijoa";
    $db->Query("SET FOREIGN_KEY_CHECKS=0;");
    
    
    $ms->Query($sql);
    
    
     while($ms->NextRecord()){
        $CardCode = $ms->Record['CardCode']; 
        $CardName =  purify($ms->Record['CardName']) ;
        $RUC = $ms->Record['LicTradNum'];
        $tipo_doc = $ms->Record['U_tipo_doc'];
        $StreetNo = purify($ms->Record['StreetNo']);
        $Phone1= $ms->Record['Phone1'];
        $City = strtoupper( purify($ms->Record['City']) );
        $Country = $ms->Record['Country'];
        $Pais = $ms->Record['Pais'];
        $CountryCode = $ms->Record['Country'];
        $GeoLoc = $ms->Record['GlblLocNum']; 
        if(is_null($GeoLoc )){
            $GeoLoc = '';
        }
        $cat = $ms->Record['ListNum'];
        $CreditLine = round($ms->Record['CreditLine']);
        $porc_antic = round($ms->Record['U_POR_ANTICI']);
        $max_cuotas = getNumeric($ms->Record['U_CUOTAS']);
        $plazo_max = getNumeric($ms->Record['U_PLAZO']);
        $CuotasAtrasadas = round(getNumeric($ms->Record['CuotasAtrasadas']));
        $rubro = $ms->Record['U_RUBRO'];
        $usuario_reg = $ms->Record['U_usuario']; 
        $tipo = 'Local';
        
        $moneda = 'G$';
        
        if($Pais !== 'PY'){
          $tipo = 'Extranjero';           
        }
        
        if($Pais == "Brazil"){
            $moneda = 'R$';
        }else if($Pais == "China"){
            $moneda = 'U$';
        }else if($Pais != "Paraguay"){
            $moneda = 'U$';
        }
        
        
        
        $Ocupacion = purify($ms->Record['Ocupacion']);
        $Situacion = $ms->Record['Situacion'];
        
        $cta_cont = '21111';
        if($Country !== 'PY'){
            $cta_cont = '21112';
        }
        $db->Database = "marijoa"; 
        
        $db->Query("SET FOREIGN_KEY_CHECKS=0;");
        
        $insert = "INSERT INTO marijoa.proveedores(cod_prov, cta_cont, tipo_doc, ci_ruc, nombre, tel, email, fecha_nac, pais, ciudad, dir, ocupacion, situacion, tipo, usuario, fecha_reg,moneda, estado)
        VALUES ('$CardCode', '$cta_cont', 'C.I', '$RUC', '$CardName', '$Phone1', '', '2000-01-01', '$CountryCode', '$City', '$StreetNo', '$Ocupacion', '$Situacion', '$tipo', 'douglas', CURRENT_DATE,'$moneda', 'Activo');";
               
        $db->Query($insert);
     }
    echo "Ok";
}

function pdvs(){
    $Qry = "SELECT pdv_cod, suc, pdv_ubic, tipo, moneda, sub_tipo FROM  marijoa_sap.pdvs";
    $db = new My();
    $my = new My();
    $db->Database = "marijoa_sap";
    $my->Database = "marijoa";
    $db->Query($Qry);
    while ($db->NextRecord()){
        $pdv_cod = $db->Record['pdv_cod'];
        $suc= $db->Record['suc'];
        $pdv_ubic= $db->Record['pdv_ubic'];
        $tipo= $db->Record['tipo'];
        $moneda= $db->Record['moneda'];
        $sub_tipo= $db->Record['sub_tipo'];
        $my->Query("INSERT INTO marijoa.pdvs (pdv_cod, suc, pdv_ubic, tipo, moneda, sub_tipo)VALUES ('$pdv_cod', '$suc', '$pdv_ubic', '$tipo', '$moneda', '$sub_tipo');");
    }
    echo "Ok";
     
}

function pantone(){
    $db = new My();
    $ms = new MS();
    $sql = "SELECT Code,Name,U_estado FROM  [@EXX_COLOR_COMERCIAL] WHERE U_estado = 'Activo'";
    $ms->Query($sql);
    
    while($ms->NextRecord()){
        $Code = $ms->Record['Code']; 
        $Name = purify($ms->Record['Name']);
        $Estado = 'Activo';
        $db->Query("insert into marijoa.pantone(pantone, nombre_color, rgb, estado)values ('$Code', '$Name', '', '$Estado');");
    }  
    echo "Ok";      
}
function usos(){
    
    $ms = new MS();
    $db = new My();
    $ms->Database = "marijoa_sap";
    $db->Database = "marijoa";
    
    $Qry = "SELECT distinct U_usos FROM oitm WHERE U_usos  IS NOT NULL ";
    $ms->Query($Qry);
    
    while($ms->NextRecord()){
        $U_usos = $ms->Record['U_usos']; 
        $usos = explode("/", $U_usos);
        foreach ($usos as $value) {
           $uso =  trim($value); 
           echo "$uso<br>";
           $db->Query("insert into marijoa.usos(descrip)values ('$uso');");
        }        
    }  
    echo "Ok";      
}
function art_propiedades(){
   $ms = new MS();
    $db = new My();
    $ms->Database = "marijoa_sap";
    $db->Database = "marijoa";
    
    $Qry = "SELECT ItmsTypCod, ItmsGrpNam  FROM oitg WHERE ItmsTypCod < 6";
    $ms->Query($Qry);
    
    while($ms->NextRecord()){
        $ItmsTypCod = $ms->Record['ItmsTypCod']; 
        $ItmsGrpNam = $ms->Record['ItmsGrpNam'];         
        $db->Query("INSERT INTO marijoa.art_propiedades(cod_prop,  descrip , tipo, valor_def, estado)VALUES ($ItmsTypCod, '$ItmsGrpNam', null,'Si,No', 'Activo');");              
    }  
    echo "Ok";         
}
function sectores(){
    $ms = new MS();
    $db = new My();
    
    $db->Database = "marijoa";
    
    $Qry = " SELECT ItmsGrpCod, ItmsGrpNam FROM  OITB";
    $ms->Query($Qry);
    
    while($ms->NextRecord()){
        $cod_sector = $ms->Record['ItmsGrpCod']; 
        $descrip = $ms->Record['ItmsGrpNam'];       
        $prefijo = substr($descrip, 0,1);
        $long = 1;
        $longitud = 4;
        if($cod_sector > 105 && $cod_sector < 108 ){
            $long = 2; 
            $longitud = 3;
            $longitud = 3;
        }
        $prefijo = substr($descrip, 0,$long);
        if($cod_sector == 108){
            $prefijo = 'TX';
            $longitud = 3;
        }
         
        $db->Query("INSERT INTO marijoa.sectores (cod_sector, descrip, prefijo, longitud, serie) VALUES ($cod_sector, '$descrip', '$prefijo', $longitud, 0  );");              
    }  
    echo "Ok";    
}

function articulos(){
    
    $ms = new MS();
    $db = new My();
    $ms->Database = "marijoa_sap";
    $db->Database = "marijoa";
    
    $db->Query("SELECT codigo FROM marijoa.articulos;");
    
    $codigos = "";
    while($db->NextRecord()){
        $cod = $db->Record['codigo'];
        $codigos .="'$cod',";
    }
    
    $codigos = substr($codigos, 0,-1);
    if($codigos == ""){
        $codigos = "''";
    }
     
    //$db->Query("DELETE FROM prop_x_art; ");
    //$db->Query("DELETE FROM articulos;");
    
    $Qry = "SELECT ItemCode,ItemName,o.U_NOMBRE_COM,ItmsGrpCod,QryGroup1,QryGroup2,QryGroup3,QryGroup4,QryGroup5,AvgPrice,InvntryUom, U_COMPOSICION, o.U_TEMPORADA, o.U_LIGAMENTO,
    o.U_ANCHO,o.U_GRAMAJE_PROM,  U_ESPESOR,U_RENDIMIENTO, U_COMBINACION,U_ESPECIFICA,U_ACABADO,U_TIPO,o.U_ESTETITCA, ManBtchNum, InvntItem,SellItem,PrchSeItem,BHeight1 as Alto,BWidth1 as Ancho_prod,BLength1 as LargoProd
	 FROM oitm  o WHERE  FrozenFor = 'N'   and ItemCode NOT IN($codigos)"; // 
    
    //echo "$Qry<br>";
    $ms->Query($Qry);
    
    while($ms->NextRecord()){
        $ItemCode = strtoupper( $ms->Record['ItemCode']); 
        //$ItemName = strtoupper( $ms->Record['ItemName']); 
        $U_NOMBRE_COM =   purify($ms->Record['U_NOMBRE_COM']) ; 
        $ItmsGrpCod = $ms->Record['ItmsGrpCod']; 
        $QryGroup1 = $ms->Record['QryGroup1']; 
        $QryGroup2 = $ms->Record['QryGroup2']; 
        $QryGroup3 = $ms->Record['QryGroup3']; 
        $QryGroup4 = $ms->Record['QryGroup4']; 
        $QryGroup5 = $ms->Record['QryGroup5']; 
        
        
        $AvgPrice = round($ms->Record['AvgPrice'],0); 
        $InvntryUom = $ms->Record['InvntryUom']; 
        $composicion = purify($ms->Record['U_COMPOSICION']); 
        $temporada = purify($ms->Record['U_TEMPORADA']); 
        $ligamento = $ms->Record['U_LIGAMENTO']; 
        $ancho = $ms->Record['U_ANCHO']; 
        $gramaje = $ms->Record['U_GRAMAJE_PROM']; 
        $espesor = $ms->Record['U_ESPESOR']  += 0; 
        $rendimiento = $ms->Record['U_RENDIMIENTO'] += 0; 
        $combinacion = purify($ms->Record['U_COMBINACION']); 
        $especificaciones = purify($ms->Record['U_ESPECIFICA']); 
        $acabado = $ms->Record['U_ACABADO']; 
        $tipo = $ms->Record['U_TIPO']; 
        $estetica = $ms->Record['U_ESTETITCA']; 
        $ManBtchNum = $ms->Record['ManBtchNum']; 
        if($ManBtchNum  == "Y"){
            $ManBtchNum = 'Si';
        }else{
            $ManBtchNum = 'No';
        }
        $InvntItem = $ms->Record['InvntItem']; 
        if($InvntItem  == "Y"){
            $InvntItem = 'true';
        }else{
            $InvntItem = 'false';
        }
       
        $SellItem = $ms->Record['SellItem']; 
        if($SellItem  == "Y"){
            $SellItem = 'true';
        }else{
            $SellItem = 'false';
        }
        
        $PrchSeItem = $ms->Record['PrchSeItem']; 
        if($PrchSeItem  == "Y"){
            $PrchSeItem = 'true';
        }else{
            $PrchSeItem = 'false';
        }
        $AltoProd = $ms->Record['Alto'] += 0; 
        $AnchoProd = $ms->Record['Ancho_prod']+= 0; 
        $LargoProd = $ms->Record['LargoProd']+= 0; 
       
        if($gramaje == null || $gramaje == ''){
            $gramaje = 0;
        }
        
        $db->Query("INSERT INTO marijoa.articulos(codigo, clase, descrip, cod_sector, um, costo_prom, art_venta, art_inv, art_compra, img, estado_venta, composicion, temporada, ligamento, combinacion, especificaciones, acabado, tipo, estetica, ancho, espesor, gramaje_prom, rendimiento, produc_ancho, produc_largo, produc_alto, mnj_x_lotes, estado)
        VALUES ('$ItemCode', 'Articulo', '$U_NOMBRE_COM', $ItmsGrpCod, '$InvntryUom',$AvgPrice, '$SellItem', '$InvntItem', '$PrchSeItem', '', 'Normal', '$composicion', '$temporada', '$ligamento', '$combinacion', '$especificaciones', '$acabado', '$tipo', '$estetica',  $ancho , $espesor ,  $gramaje , $rendimiento , $AnchoProd, $LargoProd, $AltoProd, '$ManBtchNum', 'Activo');");
        
        genProp($ItemCode,1,$QryGroup1);
        genProp($ItemCode,2,$QryGroup2);
        genProp($ItemCode,3,$QryGroup3);
        genProp($ItemCode,4,$QryGroup4);
        genProp($ItemCode,5,$QryGroup5);
        
    }  
    $db->Query("update marijoa.articulos SET cod_sector = 108 where codigo like 'TX%'");
    $db->Query(" UPDATE sectores s  SET s.serie = ( SELECT   MAX( SUBSTRING(codigo, 3, 6) + 0   )  FROM articulos a  WHERE s.cod_sector = a.cod_sector) ");
    echo "Ok";      
}


function lista_precios(){
    $db = new My();     
    $db->Database = "marijoa";
    // Agregar G$ Metros

    $factor_array = array(1=>1,2=>0.98,3=>0.95,4=>0.92,5=>0.90,6=>0.85,7=>0.80);
    
    $factor = 1;
    
    //G$  Mts 
    for($i =1;$i <= 7 ;$i++){
       $factor = $factor_array[$i];
       $db->Query("INSERT INTO marijoa.lista_precios(num, moneda, um, descrip, ref_num, ref_moneda, ref_um, factor, regla_redondeo)
       VALUES ($i, 'G$', 'Mts', '$i-Gs-Mts', 1, 'G$', 'Mts', $factor, 'SEDECO');");
    }
    
     //G$  Kilos
    for($i =1;$i <= 7 ;$i++){
        $factor = $factor_array[$i];
       $db->Query("INSERT INTO marijoa.lista_precios(num, moneda, um, descrip, ref_num, ref_moneda, ref_um, factor, regla_redondeo)
       VALUES ($i, 'G$', 'Kg', '$i-Gs-Kg', 1, 'G$', 'Kg', $factor, 'SEDECO');");
    }
    
     //U$  Kilos
    for($i =1;$i <= 7 ;$i++){
        $factor = $factor_array[$i];
       $db->Query("INSERT INTO marijoa.lista_precios(num, moneda, um, descrip, ref_num, ref_moneda, ref_um, factor, regla_redondeo)
       VALUES ($i, 'U$', 'Kg', '$i-Us-Kg', 1, 'U$', 'Kg', $factor, '2_DEC_ARRIBA');");
    }
    
    
    //U$  Metros
    for($i =1;$i <= 7 ;$i++){
       $factor = $factor_array[$i]; 
       $db->Query("INSERT INTO marijoa.lista_precios(num, moneda, um, descrip, ref_num, ref_moneda, ref_um, factor, regla_redondeo)
       VALUES ($i, 'U$', 'Mts', '$i-Us-Mts', 1, 'U$', 'Mts', $factor, '2_DEC_ARRIBA');");
    }
    
    //G$  Unid
    for($i =1;$i <= 7 ;$i++){
       $factor = $factor_array[$i]; 
       $db->Query("INSERT INTO marijoa.lista_precios(num, moneda, um, descrip, ref_num, ref_moneda, ref_um, factor, regla_redondeo)
       VALUES ($i, 'G$', 'Unid', '$i-Gs-Unid', 1, 'G$', 'Unid', $factor, 'SEDECO');");
    }
    echo "Ok";
    
}

function series_lotes(){
    $ms = new MS();
    $db = new My(); 
    $db->Database = "marijoa";
    
    for($i = 1;$i <= 30;$i++){
        $term = $i;
        if($i < 10){
            $term= "0$i";
        }
        $ms->Query("SELECT TOP 1 DistNumber FROM obtn WHERE RIGHT(DistNumber,2) = '$term' ORDER BY sysnumber desc");
        if($ms->NumRows()>0){
            $ms->NextRecord();
            $DistNumber = $ms->Record['DistNumber'];
            $serie = substr($DistNumber, 0,-2);
            if($term < 20){
              $serie += 1000;  
            } 
        }else{
            $serie  = 1;  
        }
        $db->Query("insert into marijoa.series_lotes(cod_serie, anio, serie)values ('$term', 20$term, $serie);");
    }
    echo "Ok";
}

function lista_prec_x_art(){
    
    $ms = new MS();
    $db = new My(); 
    $db_ins = new My();
    
    $ms->Database = "marijoa_sap";
    $db->Database = "marijoa";
    $db_ins->Database = "marijoa";
    
    $db->Query("SELECT codigo,um FROM marijoa.articulos ");
    
    while($db->NextRecord()){
       $codigo = $db->Record['codigo'];
       $um = $db->Record['um'];
       $ms->Query(" SELECT  PriceList,Price,Currency FROM  ITM1 WHERE ItemCode = '$codigo' AND PriceList < 8");
       while($ms->NextRecord()){
           $num = $ms->Record['PriceList'];
           $precio = $ms->Record['Price'];
           $moneda = $ms->Record['Currency'];
           $db_ins->Query("INSERT INTO marijoa.lista_prec_x_art(num, moneda, um, codigo, precio, usuario, fecha)VALUES ($num, '$moneda', '$um', '$codigo', $precio, 'douglas', CURRENT_DATE);");
       }
       
    }   
   
    echo "Ok";    
}

function politica_cortes(){
    $Qry = 'SELECT U_codigo AS codigo,U_suc AS suc,U_politica AS politica,U_presentacion AS presentacion FROM  dbo."@POLITICA_CORTES"  ORDER BY U_suc ASC, U_codigo asc';
    $ms = new MS();
    $db = new My();
    $ms->Database = "marijoa_sap";
    $db->Database = "marijoa";
    
    $ms->Query($Qry);
    
    
    while($ms->NextRecord()){
        $codigo = $ms->Record['codigo'];
        $suc = $ms->Record['suc'];
        $politica = $ms->Record['politica'];
        $presentacion = $ms->Record['presentacion'];
        $db->Query("INSERT INTO marijoa.politica_cortes(codigo, suc, politica, presentacion, estado)VALUES ('$codigo', '$suc', '$politica', '$presentacion', 'Activo');"); 
    }
    echo "Ok";
}

function ubicaciones(){
    $ms = new Ms();
    $db = new My();
    $db->Database = "marijoa";
    $ms->Query('SELECT U_sucursal,U_nombre,U_tipo,U_filas,U_cols,U_sentido FROM dbo."@UBICACIONES"');
     while($ms->NextRecord()){
        $suc = $ms->Record['U_sucursal'];
        $nombre = $ms->Record['U_nombre'];
        $tipo = $ms->Record['U_tipo'];
        $filas = $ms->Record['U_filas'];
        $cols = $ms->Record['U_cols'];
        $sentido = $ms->Record['U_sentido'];
        if($sentido == ""){
            $sentido = "Normal";
        }
        $db->Query("INSERT INTO marijoa.ubicaciones(ubic_nombre, suc, tipo, filas, cols, sentido)VALUES ('$nombre', '$suc', '$tipo', $filas, $cols, '$sentido');");
     }
     echo "Ok";
}


function temporadas(){
    require_once("Y_DB_MySQL220.class.php");
    $ms = new My220();
    $db = new My();
    $ms->Database = "marijoa_sap";
    $ms->host = "192.168.2.220";
    $db->Database = "marijoa";
    
    $ms->Query("SELECT suc, estante, temporada, usuario, desde, hasta, upt_date FROM marijoa_sap.temporadas");
    
    
    while($ms->NextRecord()){
        $estante = $ms->Record['estante'];
        $suc = $ms->Record['suc'];
        $temporada = $ms->Record['temporada'];
        $usuario = $ms->Record['usuario'];
        $desde = $ms->Record['desde'];
        $hasta = $ms->Record['hasta'];
        $upt_date = $ms->Record['upt_date'];
        //echo "$estante $suc $temporada $usuario<br>";
        $db->Query("INSERT INTO marijoa.temporadas(suc, temporada, usuario, estante, desde, hasta, upt_date)VALUES ('$suc', '$temporada', '$usuario', '$estante', '$desde', '$hasta', '$upt_date');"); 
    }
    echo "Temporadas Migradas Ok";
}

function articulos_x_temp(){
    require_once("Y_DB_MySQL220.class.php");
    $ms = new My220();
    $db = new My();
    $ms->Database = "marijoa_sap";
    $db->Database = "marijoa";
    
    $ms->Query("SELECT suc, estante, temporada, codigo, fila, col, um, capacidad, piezas, usuario, fecha FROM marijoa_sap.articulos_x_temp  ");
    
    
    while($ms->NextRecord()){
        $estante = $ms->Record['estante'];
        $suc = $ms->Record['suc'];
        $temporada = $ms->Record['temporada'];
        $usuario = $ms->Record['usuario'];
        $col = $ms->Record['col'];        
        $fila = $ms->Record['fila'];
        $codigo = $ms->Record['codigo'];
        $um = $ms->Record['um'];
        $capacidad = $ms->Record['capacidad'];
        $piezas = $ms->Record['piezas'];
        $fecha = $ms->Record['fecha'];
        
        
        $db->Query("INSERT INTO marijoa.articulos_x_temp(suc, temporada, estante, codigo, fila, col, um, capacidad, piezas, usuario, fecha)
        VALUES ('$suc', '$temporada', '$estante', '$codigo',  $fila ,  $col , '$um', '$capacidad',  $piezas , '$usuario', '$fecha');"); 
    }
    echo "Ok";
}

function designs(){
    $ms = new Ms();
    $db = new My();
    $db->Database = "marijoa";
    $ms->Query(' SELECT Code,Name,U_estado FROM dbo."@DESIGN_PATTERNS" ORDER BY Code ASC');
     while($ms->NextRecord()){
        $Code = $ms->Record['Code'];
        $Name = utf8_encode( $ms->Record['Name'] );
        $estado = $ms->Record['U_estado']; 
        $db->Query("INSERT INTO marijoa.designs(design, descrip, estado)VALUES ('$Code', '$Name', '$estado');");
     }
     echo "Ok";    
}

function parametros(){
    $ms = new My();
    $db = new My();
    $ms->Database = "marijoa_sap";
    $db->Database = "marijoa";
    
    $ms->Query("SELECT clave, usuario, valor, descrip FROM marijoa_sap.parametros");
    
    
    while($ms->NextRecord()){
        $clave = $ms->Record['clave'];
        $suc = $ms->Record['suc'];
        $valor = $ms->Record['valor'];
        $usuario = $ms->Record['usuario'];
        $descrip = $ms->Record['descrip'];
        if($usuario == ''){
            $usuario = '*';
        }
        
        $db->Query("INSERT INTO marijoa.parametros(clave, usuario, valor, descrip) VALUES ('$clave', '$usuario', '$valor', '$descrip');"); 
    }
    echo "Ok";    
}

function tarjetas(){
    $ms = new Ms();
    $db = new My();
    $db->Database = "marijoa";
    $ms->Query(' SELECT CreditCard,CardName,Phone AS Tipo   FROM  OCRC');
     while($ms->NextRecord()){
        $cod_tarjeta = $ms->Record['CreditCard'];
        $CardName = utf8_encode( $ms->Record['CardName'] );
        $Tipo = $ms->Record['Tipo']; 
        $db->Query("insert into marijoa.tarjetas(cod_tarjeta, cta_cont, nombre, tipo, estado)values ($cod_tarjeta, '11232', '$CardName', '$Tipo', 'Activa');");
     }
     echo "Ok";        
}

function tipos_gastos(){
    $ms = new Ms();
    $db = new My();
    $db->Database = "marijoa";
    $ms->Query('SELECT AlcCode, AlcName, LaCallcAcc FROM oalc');
     while($ms->NextRecord()){
        $cod  = $ms->Record['AlcCode'];
        $descrip = utf8_encode( $ms->Record['AlcName'] );
        
        $db->Query("INSERT INTO marijoa.tipos_gastos (cod_gasto, descrip, cuenta_cont)VALUES ($cod, '$descrip', '514113');");
     }
     
     $db->Query("UPDATE marijoa.tipos_gastos SET descrip = 'GASTOS DE CONSOLIDACION EN ORIGEN' WHERE cod_gasto = 8;");
     echo "Ok";    
}

function lotes(){
    
}

function conceptos(){
    $Qry = "SELECT id_concepto,descrip,tipo,autom,compl FROM marijoa_sap.conceptos";
    $db = new My();
    $my = new My();
    $db->Database = "marijoa_sap";
    $my->Database = "marijoa";
    $db->Query($Qry);
    while ($db->NextRecord()){
        $id_concepto = $db->Record['id_concepto'];
        $descrip= $db->Record['descrip'];
        $autom= $db->Record['autom'];
        $tipo= $db->Record['tipo'];
        $compl= $db->Record['compl'];        
        $my->Query("INSERT INTO marijoa.conceptos(id_concepto, descrip, tipo, autom, compl)VALUES ($id_concepto, '$descrip', '$tipo', '$autom', '$compl');");
    }
    echo "Ok";     
}


function genProp($codigo,$prop_cod, $prop_val){
    $db = new My();     
    $db->Database = "marijoa";
    if($prop_val == 'Y'){
        $prop_val = 'Si';
    }else{
        $prop_val = 'No';
    }
    
    $db->Query("INSERT INTO marijoa.prop_x_art (codigo, cod_prop, valor)VALUES ('$codigo', '$prop_cod', '$prop_val');");
}

function purify($cadena){
      
    //Codificamos la cadena en formato utf8 en caso de que nos de errores
    $cadena = utf8_encode($cadena);
   // echo "$cadena<br>"; 

    //Ahora reemplazamos las letras
    $cadena = str_replace(
        array('á', 'à', 'ä', 'â', 'ª', 'Á', 'À', 'Ä'),
        array('1', '2', '3', '4', '5', '6', '7', '9'),
        $cadena
    );
     //echo "$cadena   1<br>"; 
    $cadena = str_replace(
        array('é', 'è', 'ë', 'ê', 'É', 'È', 'Ê', 'Ë'),
        array('e', 'e', 'e', 'e', 'E', 'E', 'E', 'E'),
        $cadena );
     
    $cadena = str_replace(
        array('í', 'ì', 'ï', 'î', 'Í', 'Ì', 'Ï', 'Î'),
        array('i', 'i', 'i', 'i', 'I', 'I', 'I', 'I'),
        $cadena );
      //echo "$cadena   2<br>"; 
    $cadena = str_replace(
        array('ó', 'ò', 'ö', 'ô', 'Ó', 'Ò', 'Ö', 'Ô'),
        array('o', 'o', 'o', 'o', 'O', 'O', 'O', 'O'),
        $cadena );
     // echo "$cadena   3<br>"; 
    $cadena = str_replace(
        array('ú','ú', 'ù', 'ü', 'û', 'Ú', 'Ù', 'Û', 'Ü'),
        array('u','u', 'u', 'u', 'u', 'U', 'U', 'U', 'U'),
        $cadena );
     
    $cadena = str_replace(
        array('ñ', 'Ñ', 'ç', 'Ç','?'),
        array('n', 'N', 'c', 'C','o'),
        $cadena
    );
  //echo "$cadena   4<br>"; 
    return $cadena;
}

function getNumeric($var){
    if(!is_numeric($var)){
        return 0;
    }else{
        return $var;
    }
}

function createStoredProcedures(){
    $getLastFracTimeProc = "DELIMITER $$

USE marijoa$$

DROP FUNCTION IF EXISTS getFracLastTimeProc$$

CREATE DEFINER=plus@localhost FUNCTION getFracLastTimeProc(padre_ INTEGER,id_ant INTEGER,hora_actual VARCHAR(14)) RETURNS INT(11)
BEGIN
     
        DECLARE hora_ VARCHAR(14);
        DECLARE time_diff INTEGER;
        
	SELECT hora FROM fraccionamientos WHERE padre = padre_ AND id_frac < id_ant  AND fecha = CURRENT_DATE ORDER BY id_frac DESC LIMIT 1 INTO hora_   ; 
	
	IF(hora_ IS NULL)THEN 
           SELECT RIGHT(fecha_inicio,8) FROM orden_procesamiento WHERE lote = padre_ AND LEFT(fecha_inicio,10) = CURRENT_DATE LIMIT 1 INTO hora_   ; 
            	
	   IF(hora_ IS NULL)THEN 
	      SET hora_ = hora_actual;
	   END IF;
	END IF;
	
	SELECT TIME_TO_SEC(TIMEDIFF(hora_actual, hora_)) INTO time_diff;	
	
	RETURN time_diff;
    END$$

DELIMITER ;";
    
    
    $promedio_frac = "DELIMITER $$

USE marijoa$$

DROP FUNCTION IF EXISTS promedio_frac$$

CREATE DEFINER=plus@% FUNCTION promedio_frac(codigo_ VARCHAR(10)) RETURNS DECIMAL(10,2)
BEGIN
        DECLARE PROM DECIMAL(10,2);
        SELECT AVG(tiempo_proc) FROM fraccionamientos WHERE codigo = codigo_ AND tiempo_proc  > 0  AND suc = '00' INTO PROM;
        RETURN PROM;
    END$$

DELIMITER ;";
    
    $db = new My();
    $db->Database = "marijoa";
    $db->Query($getLastFracTimeProc);
    
    $db->Query($promedio_frac);
    
}

new Migracion();

?>