<?php

/**
 * Description of Fraccionar
 * @author Ing.Douglas
 * @date 01/09/2016
 */
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_Template.class.php");
require_once("../Functions.class.php");
require_once("../Config.class.php");



class Fraccionar {

    function __construct() {
        $action = $_REQUEST['action'];
        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }
    }

    function main() {

        $t = new Y_Template("Fraccionar.html");
        $t->Show("header");
        
        $c = new Config();
        $host = $c->getNasHost();
        $path = $c->getNasFolder();
        $images_url = "http://$host/$path";
        $t->Set("images_url", $images_url);

        // Solo si es Toutch
        $suc = $_POST['suc'];

        $db = new My();

        $f = new Functions();
        $ip = $f->getIP();
        //echo $ip;
        $db->Query("select ip_alt from pcs where suc = '$suc' and tipo_periferico = 'Balanza' and local = 'No' and ip = '$ip' ");

        $alternativos = "";
        while ($db->NextRecord()) {
            $ip_alt = $db->Record['ip_alt'];
            $alternativos.="<option>$ip_alt</option>";
        }
        $t->Set("ips_balanzas_alternativas", $alternativos);

        // Metrador
        $db->Query("select ip_alt from pcs where suc = '$suc' and tipo_periferico = 'Metrador' and local = 'No' and ip = '$ip' ");

        $alternativos = "";
        while ($db->NextRecord()) {
            $ip_alt = $db->Record['ip_alt'];
            $alternativos.="<option>$ip_alt</option>";
        }
        $t->Set("ips_metradores_alternativos", $alternativos);        
        
		$touch = $_POST['touch']; 
        //if($touch=="true"){
           require_once("../utils/NumPad.class.php");
           new NumPad();        
        //}
		
		$t->Show("body");
    }

}

function buscarDatosDeLote() {
    $lote = $_POST['lote'];
    $suc = $_POST['suc'];
    $cat = $_POST['categoria'];

    require_once("../Y_DB_MSSQL.class.php");
    $ms = new MS();
    //$ms->Query("SELECT ItemCode,cast(round(Quantity - ISNULL(IsCommited,0),2) as numeric(20,2)) as Stock, U_gramaje,U_gramaje_m,U_kg_desc,U_ancho,U_factor_precio,U_img,c.Name as U_color_comercial, U_F1,U_F2,U_F3,Status,WhsCode AS Suc,U_img as Img,U_tara,o.U_desc$cat as Descuento FROM OIBT o LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code where  o.BatchNum = '$lote' and WhsCode LIKE '$suc' ;"); //Lote
    $ms->Query("SELECT o.ItemCode,cast(round(q.Quantity - ISNULL(q.CommitQty,0),2) as numeric(20,2)) as Stock,o.U_gramaje,o.U_gramaje_m,o.U_kg_desc,o.U_ancho,o.U_factor_precio,o.U_img,c.Name as U_color_comercial,o.U_F1,o.U_F2,o.U_F3,Status,q.WhsCode AS Suc,o.U_img as Img,o.U_tara,o.U_desc$cat as Descuento FROM OBTN o inner join OBTW w on o.SysNumber=w.SysNumber and o.ItemCode=w.ItemCode inner join OBTQ q on o.SysNumber=q.SysNumber and w.WhsCode=q.WhsCode and q.ItemCode=w.ItemCode inner join OITM m on o.ItemCode=m.ItemCode LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code where  o.DistNumber = '$lote' and q.WhsCode LIKE '$suc' "); //Lote

    /**
     * Quantity = Cantidad Fisica
     * IsCommited = Comprometido en Orden de Venta
     */
    $arr = array();

    if ($ms->NumRows() > 0) {
        $ms->NextRecord();
        $codigo = $ms->Record['ItemCode'];
        $stock = $ms->Record['Stock'];
        $ancho = $ms->Record['U_ancho'];
        $gramaje = $ms->Record['U_gramaje'];
        $gramaje_m = $ms->Record['U_gramaje_m'];
        $kg_desc = $ms->Record['U_kg_desc'];
        $color_comercial = utf8_decode($ms->Record['U_color_comercial']);
        $factor_precio = $ms->Record['U_factor_precio'];
        $F1 = $ms->Record['U_F1'];
        $F2 = $ms->Record['U_F2'];
        $F3 = $ms->Record['U_F3'];
        $Status = $ms->Record['Status'];
        $Suc = $ms->Record['Suc'];
        $Img = $ms->Record['Img'];
        $Tara = $ms->Record['U_tara'];
        $Descuento = $ms->Record['Descuento']; // Descuento para dicha categoria

        if ($ancho == null) {
            $ancho = 0;
        }
        if ($gramaje == null) {
            $gramaje = 0;
        }
        if ($factor_precio == null) {
            $factor_precio = 1;
        }

        // Busco la informacion del Codigo
        $info = new MS();
        $info->Query("SELECT  ItemName as Descrip,U_NOMBRE_COM as NombreComercial, InvntryUom as UM,cast(round(OnHand,2) as numeric(20,0)) as TotalGlobal,AvgPrice FROM OITM WHERE ItemCode = '$codigo'");
        $info->NextRecord();
        $NombreComercial = $info->Record['NombreComercial'];
        $AvgPrice = $info->Record['AvgPrice'];
        // Si tiene (debe tener) Nombre comercial uso este sino Uso la Descripcion
        if ($NombreComercial != null) {
            $descrip = $NombreComercial . "-" . $color_comercial;
        } else {
            $descrip = $info->Record['Descrip'] . "-" . $color_comercial;
        }


        $um = $info->Record['UM'];
        $TotalGlobal = $info->Record['TotalGlobal'];
        if ($um == "") {
            $um = "Mts";
        }

        $datos = array();
        $datos["Codigo"] = $codigo;
        $datos["Stock"] = $stock;
        $datos["Descrip"] = strtoupper(utf8_decode($descrip));
        $datos["UM"] = $um;
        $datos["Ancho"] = $ancho;
        $datos["Gramaje"] = $gramaje;
        $datos["GramajeM"] = $gramaje_m;
        $datos["Kg_desc"] = $kg_desc;
        $datos["FactorPrecio"] = $factor_precio;
        $datos["TotalGlobal"] = $TotalGlobal;
        $datos["F1"] = $F1;
        $datos["F2"] = $F2;
        $datos["F3"] = $F3;
        $datos["Estado"] = $Status;
        $datos["Suc"] = $Suc;
        $datos["Img"] = $Img;
        $datos["Tara"] = $Tara;
        $datos["PrecioCosto"] = $AvgPrice;

        // Buscar el Precio para esta Categoria
        $ms->Query("SELECT cast(round(Price,2) as numeric(20,0))  as Precio FROM ITM1 WHERE ItemCode = '$codigo' AND PriceList = $cat;");
        $ms->NextRecord();
        $precio = $ms->Record['Precio'];
        $datos["Precio"] = $precio;
        $datos["Descuento"] = $Descuento;

        /**
         * Obtener Cantidad de Compra
         * 20: Factura de Compra
         * 59: Entrada de Mercaderias
         * 67: Traslados de Mercaderias
         */
        $ms->Query("select top 1 Quantity as CantCompra from IBT1 where ItemCode = '$codigo' and BatchNum = '$lote'  and (BaseType = '20' or BaseType = '59' or BaseType = '67') AND WhsCode = '$suc' order by DocDate asc"); // 20 Entrada de Mercaderias, 59 Entrada Ajuste + o Fraccionamiento 
        if ($ms->NumRows() > 0) {
            $ms->NextRecord();
            $cant_compra = $ms->Record['CantCompra'];
            $datos["CantCompra"] = $cant_compra;
        } else { // Ver el base type para Productos Fraccionados 
            $datos["CantCompra"] = 0;
        }

        $datos["Mensaje"] = "Ok";
        array_push($arr, $datos);
    } else {
        $datos["Mensaje"] = "Codigo no encontrado...";
        array_push($arr, $datos);
    }

    echo json_encode($arr);
}

/**
 * En Sap No existe el Fraccionamiento solo existe Salida y Entrada en Operaciones de Stock, por lo tanto se saca de un Lote en una Salida
 * y se da entrada con un nuevo Lote generando el Nro de Lote antes
 */
function fraccionar() {
    $codigo = $_POST['codigo'];
    $lote = $_POST['lote'];
    $suc = $_POST['suc'];
    $fraccion = $_POST['fraccion'];
    $um = $_POST['um'];
    $tara = $_POST['tara'];
    $usuario = $_POST['usuario'];
    $kg = $_POST['kg'];
    $kg_desc = $_POST['kg_desc'];
    $ancho = $_POST['ancho'];
    $gramaje_rollo = $_POST['gramaje_rollo'];
    $gramaje = $_POST['gramaje'];
    $destino = $_POST['destino'];
    $presentacion = $_POST['presentacion'];
    $total_fraccionado = $_POST['total_fraccionado'];

    try {
        require_once("../Y_DB_MSSQL.class.php");
        $ms = new MS();

        $ms->Query("SELECT  AvgPrice FROM OITM WHERE ItemCode = '$codigo'"); // En Productivo 
         
        $ms->NextRecord();
        $precio_costo = $ms->Record['AvgPrice'];
        if($precio_costo == null || $precio_costo == 0){
            echo "Precio costo no definido";
            die();
        }
        
        $terminacion = substr($lote,-2);
        $nuevo_lote = generarLote($terminacion);
        if($nuevo_lote > 1){

            $ms->Query("SELECT ItemCode,cast(round(Quantity - ISNULL(IsCommited,0),2) as numeric(20,2)) as Stock FROM OIBT o where  o.BatchNum = '$lote' and WhsCode LIKE '$suc' ;"); //Lote
            $ms->NextRecord();

            $stock = $ms->Record['Stock'] - $total_fraccionado;

            $valor = $fraccion * $precio_costo;
            $final = $stock - $fraccion;


            if($final < 0){
                echo  "Error Stock Insuficiente";
                return;
            }

            $db = new My();
            // Salida
            $db->Query("insert into fraccionamientos( usuario, codigo, lote, tipo, signo, inicial, cantidad, final, um, p_costo, motivo, fecha, tara, kg_desc, gramaje, hora, estado, valor, suc,suc_destino,presentacion, padre,ancho, e_sap,cta_cont)
            values ('$usuario', '$codigo', '$lote', 'Salida', '-', $stock, $fraccion, $final, '$um', $precio_costo, 'Fracccionamiento Normal', CURRENT_DATE, 0, $kg_desc, "
                    . "$gramaje_rollo, CURRENT_TIME, 'Pendiente',$valor, '$suc','$destino','$presentacion',null,$ancho, 0,'1.1.3.1.05');");

            //sapGenExit($codigo, $lote, $usuario);

            $fraccion = $_POST['fraccion'];
            $valor = $fraccion * $precio_costo;
            $final = $fraccion;

            // Entrada

            $db->Query("insert into fraccionamientos( usuario, codigo, lote, tipo, signo, inicial, cantidad, final, um, p_costo, motivo, fecha, tara, kg_desc, gramaje, hora, estado, valor, suc,suc_destino,presentacion, padre, ancho,e_sap,cta_cont)
            values ('$usuario', '$codigo', '$nuevo_lote', 'Entrada', '+', 0, $fraccion, $final, '$um', $precio_costo, 'Fracccionamiento Normal', CURRENT_DATE, $tara, $kg, "
                    . "$gramaje, CURRENT_TIME, 'Pendiente',$valor, '$suc','$destino','$presentacion','$lote',$ancho, 0,'1.1.3.1.05');");

            //sapGenEntry($codigo, $nuevo_lote,$lote, $usuario);

            //makeLog("$usuario", "Ajuste$signo", "$oper | $motivo",'Ajuste',0);
            echo $nuevo_lote;
        }else{
            echo "Error no se pudo generar el Lote intenten nuevamente, si el problema persiste contacte con el administrador";
        }
    } catch (Exception $e) {
        echo  "Error ".$e->getMessage();
    }
    
}

function sapGenEntry($codigo, $lote,$padre,$usuario) {
      
    require_once("../ConfigSAP.class.php");
    $c = new ConfigSAP();
    $conn = $c->connectToSAP();
    $entrada = $conn->GetBusinessObject(59);  // ObjType 59 = OIGN 
 
    //echo "SELECT id_frac,cantidad,um,p_costo,motivo,date_format(fecha,'%d-%m-%Y') as fecha,valor,suc FROM fraccionamientos WHERE codigo = '$codigo' AND lote = '$lote' AND signo = '-' and cantidad > 0 and e_sap = 0 LIMIT 1";

    $clone_data = "select U_img,U_F1,U_F2,U_F3,U_factor_precio,U_ubic,U_color_comercial,U_color_comb,U_color_cod_fabric,U_prov_mar,U_bag,U_umc,U_ancho,U_gramaje_m,U_design,U_rec,U_estado_venta,U_desc1,U_desc2,U_desc3,U_desc4,U_desc5,U_desc6,U_desc7
    from OIBT where ItemCode = '$codigo' and BatchNum = '$padre'";
    
    require_once("../Y_DB_MSSQL.class.php");
    
    // Extraigo el Pais de Origen del Padre
    $ms0 = new MS();
    $ms0->Query("select o.U_origen, o.U_Pais_Origen FROM OPDN o INNER JOIN OIBT i ON  o.DocEntry = i.BaseEntry AND i.BatchNum = '$padre'");
    $U_origen = 'Internacional';
    $U_pais_origen = 'China';
    if( $ms0->NumRows() > 0 ){
       $ms0->NextRecord();       
       $U_pais_origen = $ms0->Record['U_Pais_Origen']; 
    }
    if($U_pais_origen == 'Paraguay'){
        $U_origen = 'Nacional';
    }else{
        $U_origen = 'Internacional';
    }
    if($U_pais_origen == null){
        $U_pais_origen = 'China';
    }
    
    
    $ms = new MS();
     
    $ms->Query($clone_data);
    $ms->NextRecord();
    
    $U_img = $ms->Record['U_img'];
    $U_F1 = $ms->Record['U_F1'];
    $U_F2 = $ms->Record['U_F2'];
    $U_F3 = $ms->Record['U_F3'];
    $U_factor_precio = $ms->Record['U_factor_precio'];
    $U_ubic = $ms->Record['U_ubic'];
    $U_color_comercial = $ms->Record['U_color_comercial'];
    $U_color_comb = $ms->Record['U_color_comb'];
    $U_color_cod_fabric = $ms->Record['U_color_cod_fabric'];
    $U_prov_mar = $ms->Record['U_prov_mar'];
    $U_bag = $ms->Record['U_bag'];
    $U_umc = $ms->Record['U_umc'];
    $U_gramaje_m = $ms->Record['U_gramaje_m'];
//$U_ancho = $ms->Record['U_ancho'];
    $U_design = $ms->Record['U_design'];
    $U_rec = $ms->Record['U_rec'];
    $U_estado_venta = $ms->Record['U_estado_venta'];
    $U_desc1 = $ms->Record['U_desc1']; if($U_desc1 == '.000000'){$U_desc1 = 0;}
    $U_desc2 = $ms->Record['U_desc2']; if($U_desc1 == '.000000'){$U_desc1 = 0;}
    $U_desc3 = $ms->Record['U_desc3']; if($U_desc1 == '.000000'){$U_desc1 = 0;}
    $U_desc4 = $ms->Record['U_desc4']; if($U_desc1 == '.000000'){$U_desc1 = 0;}
    $U_desc5 = $ms->Record['U_desc5']; if($U_desc1 == '.000000'){$U_desc1 = 0;}
    $U_desc6 = $ms->Record['U_desc6']; if($U_desc1 == '.000000'){$U_desc1 = 0;}
    $U_desc7 = $ms->Record['U_desc7']; if($U_desc1 == '.000000'){$U_desc1 = 0;}
    
        
    $db = new My();
    
    $db->Query("SELECT id_frac,cantidad,um,p_costo,motivo,date_format(fecha,'%d-%m-%Y') as fecha,valor,suc,tara,gramaje,kg_desc,ancho "
            . "FROM fraccionamientos WHERE codigo = '$codigo' AND lote = '$lote' and padre = '$padre' AND signo = '+' and cantidad > 0 and e_sap = 0 LIMIT 1");
    if ($db->NumRows() > 0) {
        $db->NextRecord();
                
        
        $id_fracc = $db->Record['id_frac'];
        $cantidad = str_replace(".",",",$db->Record['cantidad']);
        $cantidad_american = $db->Record['cantidad'];
        
        $precio_neto = $db->Record['p_costo'];
        //$um = $db->Record['um');
        $suc = $db->Record['suc'];
        $motivo = $db->Record['motivo'];
        $fecha = $db->Record['fecha'];
        $valor = $db->Record['valor'];
        $tara = $db->Record['tara'];
        $gramaje = $db->Record['gramaje'];
        $kg_desc =     $db->Record['kg_desc'];
        $ancho =     $db->Record['ancho'];
        // echo "$id_fracc-$cantidad-$codigo-$lote-$suc-$precio_neto-$motivo-$fecha-$valor-$usuario";
        
        $entrada->Reference2 = $id_fracc;
        $entrada->Series = 25;  // NNM1

        $entrada->UserFields->Fields->Item("U_Nro_Interno")->Value = $id_fracc;
        $entrada->UserFields->Fields->Item("U_Usuario")->Value = $usuario;
        $entrada->UserFields->Fields->Item("U_SUC")->Value = $suc;
        $entrada->UserFields->Fields->Item("U_Origen")->Value = $U_origen;
        $entrada->UserFields->Fields->Item("U_Pais_Origen")->Value = $U_pais_origen;

        $entrada->DocCurrency = "G$";
        //$entrada->DocRate = Cotiz

        $entrada->GroupNumber = -1; //Ultimo Precio
        $entrada->DocDate = $fecha;
        $entrada->DocDueDate = $fecha;
        $entrada->JournalMemo = substr($motivo, 0, 50); // Max Length 50
        $entrada->Comments = substr($motivo, 0, 254); // Max Length 254


        $entrada->Lines->ItemCode = $codigo;
        $entrada->Lines->Quantity = $cantidad;
        $entrada->Lines->Price = $precio_neto;
        $entrada->Lines->LineTotal = $valor; //Total de la Linea
        $entrada->Lines->WarehouseCode = $suc;

        $entrada->Lines->AccountCode = "6.1.4.1.17";  //Cuenta del Mayor Mermas en Stock
        //Lote
        
        $entrada->Lines->BatchNumbers->BatchNumber = $lote;
        $entrada->Lines->BatchNumbers->Quantity = $cantidad;
        $entrada->Lines->BatchNumbers->UserFields->Fields->Item("U_quty_c_um")->Value= $cantidad_american;  
        
        
        $err = $entrada->add();

        if ($err == 0) {
                
            $db->Query("UPDATE fraccionamientos SET e_sap = 1 WHERE id_frac = $id_fracc;");
            $cantidad = $db->Record['cantidad'];
            $ms->Query("UPDATE OIBT SET U_img = '$U_img',U_F1= '$U_F1',U_F2= '$U_F2',U_F3= '$U_F3',U_factor_precio= '$U_factor_precio',U_ubic= '$U_ubic',U_color_comercial= '$U_color_comercial',"
                    . "U_color_comb= '$U_color_comb',U_color_cod_fabric= '$U_color_cod_fabric',U_prov_mar= '$U_prov_mar',U_bag= '$U_bag',U_umc= '$U_umc', U_ancho = $ancho,U_gramaje = $gramaje,U_gramaje_m= $U_gramaje_m,U_design= '$U_design',"
                    . "U_rec= '$U_rec',U_estado_venta= '$U_estado_venta',U_desc1= '$U_desc1',U_desc2= '$U_desc2',U_desc3= '$U_desc3',U_desc4= '$U_desc4',U_desc5= '$U_desc5',U_desc6= '$U_desc6',U_desc7 = '$U_desc7',"
                    . "U_padre = '$padre',U_tara = $tara,U_kg_desc = $kg_desc, U_quty_ticket = 0,U_equiv = $cantidad WHERE BatchNum = '$lote';  ");
            
             return "true";
        } else {

            $lErrCode = 0;
            $sErrMsg = "";
            $conn->GetLastError($lErrCode, $sErrMsg);

            echo "Error al Registrar Entrada de Mercaderias ErrCode: $lErrCode   ErrMsg: $sErrMsg";
            //require_once("../Log.class.php");
            //$l = new Log();
            //$l->error("Error al Registrar Cliente ErrCode: $lErrCode   ErrMsg: $sErrMsg");

            return "false";
        }
    }
    //$conn->Disconnect();
}


function sapGenExit($codigo, $lote, $usuario) {
      
    require_once("../ConfigSAP.class.php");
    $c = new ConfigSAP();
    $conn = $c->connectToSAP();
    $salida = $conn->GetBusinessObject(60);  // ObjType 60 = OIGE 
 
   //echo "SELECT id_frac,cantidad,um,p_costo,motivo,date_format(fecha,'%d-%m-%Y') as fecha,valor,suc FROM fraccionamientos WHERE codigo = '$codigo' AND lote = '$lote' AND signo = '-' and cantidad > 0 and e_sap = 0 LIMIT 1";

    $db = new My();
    
    $db->Query("SELECT id_frac,cantidad,um,p_costo,motivo,date_format(fecha,'%d-%m-%Y') as fecha,valor,suc FROM fraccionamientos WHERE codigo = '$codigo' AND lote = '$lote' AND signo = '-' and cantidad > 0 AND final >= 0 AND e_sap = 0 LIMIT 1");
    if ($db->NumRows() > 0) {
        $db->NextRecord();
                
        
        $id_fracc = $db->Record['id_frac'];
        $cantidad = str_replace(".",",",$db->Record['cantidad']);
        $precio_neto = $db->Record['p_costo'];
        //$um = $db->Record['um');
        $suc = $db->Record['suc'];
        $motivo = $db->Record['motivo'];
        $fecha = $db->Record['fecha'];
        $valor = $db->Record['valor'];
            
        // echo "$id_fracc-$cantidad-$codigo-$lote-$suc-$precio_neto-$motivo-$fecha-$valor-$usuario";
        
        $salida->Reference2 = $id_fracc;
        $salida->Series = 26;  // NNM1

        $salida->UserFields->Fields->Item("U_Nro_Interno")->Value = $id_fracc;
        $salida->UserFields->Fields->Item("U_Usuario")->Value = $usuario;
        $salida->UserFields->Fields->Item("U_SUC")->Value = $suc;

        $salida->DocCurrency = "G$";
        //$salida->DocRate = Cotiz

        $salida->GroupNumber = -1; //Ultimo Precio
        $salida->DocDate = $fecha;
        $salida->DocDueDate = $fecha;
        $salida->JournalMemo = substr($motivo, 0, 50); // Max Length 50
        $salida->Comments = substr($motivo, 0, 254); // Max Length 254


        $salida->Lines->ItemCode = $codigo;
        $salida->Lines->Quantity = $cantidad;
        $salida->Lines->Price = $precio_neto;
        $salida->Lines->LineTotal = $valor; //Total de la Linea
        $salida->Lines->WarehouseCode = $suc;

        $salida->Lines->AccountCode = "6.1.4.1.17";  //Cuenta del Mayor Mermas en Stock
        //Lote
        $salida->Lines->BatchNumbers->BatchNumber = $lote;
        $salida->Lines->BatchNumbers->Quantity = $cantidad;

        $err = $salida->add();

        if ($err == 0) {           
            $db->Query("update fraccionamientos set e_sap = 1 where id_frac = $id_fracc;");
            return "true";
        } else {

            $lErrCode = 0;
            $sErrMsg = "";
            $conn->GetLastError($lErrCode, $sErrMsg);

            echo "Error al Registrar Salida de Mercaderias ErrCode: $lErrCode   ErrMsg: $sErrMsg";
            //require_once("../Log.class.php");
            //$l = new Log();
            //$l->error("Error al Registrar Cliente ErrCode: $lErrCode   ErrMsg: $sErrMsg");

            return "false";
        }
    }
    //$conn->Disconnect();
}

function chequearFraccionesPendientes(){
    $codigo = $_POST['codigo'];
    $lote = $_POST['lote'];
    $suc = $_POST['suc'];    
    $db = new My();
    $sql = "SELECT COUNT(*) AS Pendientes FROM fraccionamientos WHERE codigo = '$codigo' AND lote = '$lote' AND signo = '-' AND (e_sap = 0 OR e_sap = 3)";
    
    $db->Query($sql);
    $db->NextRecord();
    $Pendientes = $db->Record['Pendientes'];
    echo $Pendientes;
}
function getResultArray($sql) {
    $db = new My();
    $array = array();
    $db->Query($sql);
    while ($db->NextRecord()) {
        array_push($array, $db->Record);
    }
    return $array;
}     
/**
 * @todo: Agregar filtro Articulo para No Manejados por Lotes
 */
function getFraccionados() {
    $lote = $_POST['lote'];
    $sql = "SELECT lote,cantidad,suc_destino,presentacion FROM fraccionamientos WHERE padre = '$lote'";
    echo json_encode(getResultArray($sql));
}
/**
 * @todo: Apuntar a Functions
 */
function generarLote($terminacion) {
    require_once("../Y_DB_MSSQL.class.php");
    $ms = new MS();
    $year = date("Y");
    $ms->Query("select CONCAT(U_Serie,Name) as Lote from [@SERIES_LOTES] where Name = '$terminacion';");
    $ms->NextRecord();
    $lote = $ms->Record['Lote'];
    $ms->Query("update [@SERIES_LOTES] set U_Serie = U_Serie + 1 where Name = '$terminacion';");
    return $lote;
}
new Fraccionar();
?>
