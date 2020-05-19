<?php

/**
 * Description of SolicitudTrasladoMobile
 * @author Ing.Douglas
 * @date 24/08/2017
 */
require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");
require_once("../Config.class.php");
require_once("../utils/NumPad.class.php");      

class SolicitudTrasladoMobile {
  function __construct() {
        $action = $_REQUEST['action'];
        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }
    }

    function main() {  
     
        $usuario = $_POST['usuario'];  
        $suc = $_POST['suc'];  
        $sucs = $this->getSucs($suc);
        $sucursales = '';
        foreach($sucs as $cod=>$descri){
            $selected = '';
            if($cod == '00'){
                $selected = 'selected';
            }
            $sucursales .= "<option value='$cod' $selected data-informacion='$descri'>$cod</option>";
        }
        
        $t = new Y_Template("SolicitudTrasladoMobile.html");
        //echo $_SERVER['REMOTE_ADDR'];
        $c = new Config();
        $host = $c->getNasHost();
        $path = $c->getNasFolder();
        $images_url = "http://$host/$path";
        $t->Set("images_url",$images_url);
        $t->Set("sucursales",$sucursales);
        
        
        $t->Show("headers");
        $t->Show("cabecera_nota_pedido"); 
        $t->Show("area_carga_cab"); 
        $t->Show("mensaje"); 
        $t->Show("solicitudes_abiertas_cab");
        
        $db = new My();
        $db->Query("SELECT n_nro AS Nro,usuario AS Usuario,DATE_FORMAT(fecha,'%d-%m-%Y') AS Fecha,cod_cli, cliente,estado AS Estado,suc AS Origen,suc_d AS Destino FROM pedido_traslado WHERE estado = 'Abierta' AND usuario = '$usuario' and suc = '$suc'");
        
        $dbd = new My();
        
        while($db->NextRecord()){
            $Nro = $db->Record['Nro'];
            $Usuario = $db->Record['Usuario'];
            $Fecha = $db->Record['Fecha'];
            $Cod_cli = $db->Record['cod_cli'];
            $Cliente = $db->Record['cliente'];
            $Estado = $db->Record['Estado'];
            $Origen = $db->Record['Origen'];
            $Destino = $db->Record['Destino'];
            $t->Set("nro",$Nro); 
            $t->Set("usuario",$Usuario); 
            $t->Set("fecha",$Fecha); 
            $t->Set("origen",$Origen); 
            $t->Set("destino",$Destino); 
            $t->Set("cod_cli",$Cod_cli); 
            $t->Set("cliente",$Cliente); 
            $t->Set("estado",$Estado); 
            $t->Show("solicitudes_abiertas_data");
            $dbd->Query("SELECT lote,descrip,cantidad,precio_venta,ROUND((cantidad*precio_venta),2) as subtotal,color,mayorista,urge,obs FROM pedido_tras_det WHERE n_nro = $Nro");
         
            while($dbd->NextRecord()){
              
                $lote = $dbd->Record['lote'];
                $descrip = $dbd->Record['descrip'];
                $color = $dbd->Record['color'];
                $cantidad = $dbd->Record['cantidad'];
                $mayorista = $dbd->Record['mayorista'];
                $urgente = $dbd->Record['urgente'];
                $precio_venta = $dbd->Record['precio_venta'];
                $subtotal = $dbd->Record['subtotal'];
                $obs = $dbd->Record['obs'];
                
                $t->Set("lote",$lote);
                $t->Set("descrip",$descrip);
                $t->Set("color",$color);
                $t->Set("cantidad",$cantidad);
                $t->Set("subtotal",$subtotal);
                $t->Set("mayorista",$mayorista);
                $t->Set("urgente",$urgente);
                $t->Set("precio",$precio_venta);
                $t->Set("obs",$obs);
                $t->Show("solicitudes_abiertas_detalle"); 
            }
            $t->Show("solicitudes_abiertas_fin_data"); 
            
        }
        
        $t->Show("solicitudes_abiertas_foot");
        $this->updateEstadoPedido();
        new NumPad();
    }
    function getSucs($currenSuc){
        $db = new My();
        $db->Query("select suc, nombre from sucursales where tipo != 'Sub-Deposito' order by left(suc,2)/1 asc");
        $sucs = array();
        while($db->NextRecord()){
            $sucs[$db->Record['suc']]=$db->Record['nombre'];
        }
        return $sucs;
    }

    function updateEstadoPedido(){
        $db = new My();
        $db->Query("UPDATE pedido_traslado p inner join (select n_nro,sum(if(estado in ('En Proceso','Pendiente'),1,0)) as pendientes from pedido_tras_det group by n_nro having(pendientes=0)) e on p.n_nro=e.n_nro set p.estado='Cerrada' where p.estado in ('Pendiente','Abierta')");
        $db->Close();
    }
    
}

function buscarLotes(){
    require_once("../Y_DB_MSSQL.class.php");
    $articulo = trim($_POST['articulo']);
    $color = $_POST['color']; 
    $campo = $_POST['tipo_busqueda'];
    $mi_suc = $_POST['mi_suc'];
    $suc = $_POST['suc']; 
    $sucDestino = $_POST['sucDestino'];
    $disponibles = $_POST['disponibles'];
    
    $tipo_busqueda = $_POST['tipo'];
    if($tipo_busqueda == "insumos"){
        $suc ='00';
        $color = "";
    }
    
    if(isset($_POST['cat'])){
        $cat = $_POST['cat'];
    }else{
        $cat = 1;
    }
     
    $orderby = 'ORDER BY i.U_NOMBRE_COM ASC,c.Name ASC,Stock DESC';    
    $ex_filter = '';
    $filter = '';
    // Verificar Notas de Pedidos y Remisiones
    $MyLink = new My();
    $arr_codigos = getItemCodeLikeName($articulo);
    $codigos = trim(implode(',', $arr_codigos  ),',');
    //echo " sizeof ".   sizeof( $arr_codigos) ;
    
    
    $criterio = " d.codigo in (".$codigos.") ";
    if(is_numeric($articulo)){
       $ItemName = getNombreArticulo($lote);
       $arr_codigos = getItemCodeLikeName($ItemName);
       $codigos = trim(implode(',', $arr_codigos  ),',');
       $criterio = " d.codigo in (".$codigos.") ";
    }   
    
    if(sizeof( $arr_codigos) == 0 && !is_numeric($articulo)){
        echo json_encode(array()); 
        return;
    }  
    
    $n_articulos = array();
    
    $ex_criterio = is_numeric($articulo)?" or d.padre = '$articulo' ":"";

    $pedido = "SELECT 'Pedido' as doc,p.n_nro,lote, suc, concat('Cant.: ',d.cantidad,' ', d.obs) as obs, d.cantidad   from pedido_traslado p inner join pedido_tras_det d using(n_nro) where $criterio and(p.estado = 'Abierta' or d.estado='Pendiente')";
    
     
    $remision = "SELECT 'Remision' as doc,r.n_nro,lote,suc_d as suc, r.obs as obs,d.cantidad from nota_remision r inner join nota_rem_det d using(n_nro) where $criterio and r.estado <> 'Cerrada'";
    //$fraccionamiento = "SELECT 'Reserva' as doc,CONCAT('id:',id_frac),lote,suc_destino as suc, '' as obs from fraccionamientos d where ($criterio $ex_criterio) and suc_destino not in  ('$suc','00')";
    $filtro_reservas_mayoristas = "";
    if($suc == $sucDestino && $suc == '00'){
        $filtro_reservas_mayoristas = "AND p.suc != '00'  AND suc_destino  != '00'";
    }
    $fraccionamiento = "SELECT 'Reserva' as doc,p.id_orden,p.lote, suc_destino as suc, '' as obs , p.cantidad FROM  orden_procesamiento p INNER JOIN  fraccionamientos d  ON p.lote=d.padre WHERE p.estado='Pendiente' AND ($criterio $ex_criterio) $filtro_reservas_mayoristas";
    //echo    $fraccionamiento; 
    $ventas = "SELECT 'Venta' AS doc,f.f_nro AS n_nro,lote,suc,'' as obs ,d.cantidad FROM factura_venta f INNER JOIN fact_vent_det d USING(f_nro) WHERE $criterio AND f.estado <> 'Cerrada'";
    //echo $criterio;
    //echo "$pedido union $remision  union $fraccionamiento ";
    
    $MyLink->Query("$pedido union $remision  union $fraccionamiento union $ventas");
    while($MyLink->NextRecord()){
        $l = $MyLink->Record['lote'];
        $n_nro = $MyLink->Record['n_nro'];
        if(!array_key_exists($l,$n_articulos) && trim($n_nro) != ''){
            $n_articulos[$l]=$MyLink->Record;
        }
    }
    // Filtros
    if(isset($_POST['sucOrigen']) && isset($_POST['sucDestino']) && isset($_POST['filtroStock'])){
        $sucOrigen = $_POST['sucOrigen'];        
        $filtroStock = $_POST['filtroStock'];
        $ex_filter = " AND round(q.Quantity - isnull(q.CommitQty,0),2) > $filtroStock";
        $orderby ="ORDER BY RIGHT(o.DistNumber,2) ASC, Stock desc";        
    }
    $filtro_suc = "";
    //Solo se permite autopedir a 00 otras sucursales no se pueden autopedir 
    if($suc != '00'){
        $filtro_suc = " and w.WhsCode != '$suc'";
    }else{
        $filtro_suc = " and (w.WhsCode = '$suc' or w.WhsCode = '$sucDestino' )";
    }
     
    $filter = "(o.ItemCode LIKE '$articulo%' or   i.U_NOMBRE_COM LIKE '$articulo%' or o.DistNumber like '$articulo%') AND c.Name LIKE '%$color%' $filtro_suc  $ex_filter $orderby";
    if(is_numeric($articulo)){
       
       $ms = new Ms();
       $ms->Query("select ItemCode, U_color_comercial,U_design,U_color_cod_fabric from OBTN where DistNumber = '$articulo'");
       if($ms->NumRows()){
           $ms->NextRecord();
           $ItemCode = $ms->Record['ItemCode'];
           $U_color_comercial = $ms->Record['U_color_comercial'];
           $U_design = $ms->Record['U_design'];
           $U_color_cod_fabric = $ms->Record['U_color_cod_fabric'];
           $filter = " round(q.Quantity - isnull(q.CommitQty,0),2)>0 and o.ItemCode = '$ItemCode' and o.U_color_comercial = '$U_color_comercial' and U_design = '$U_design' and U_color_cod_fabric = '$U_color_cod_fabric'  $filtro_suc or (o.DistNumber = '$articulo' and  w.WhsCode =  '$sucDestino' ) ";
       }else{
           $filter = " round(q.Quantity - isnull(q.CommitQty,0),2)>0 and (o.DistNumber = '$articulo' or o.U_padre  = '$articulo' )  $filtro_suc and  w.WhsCode =  '$sucDestino'";
       }
       
    }
    
    if($tipo_busqueda === "insumos"){
        $filter = "(o.ItemCode LIKE 'IN%' AND i.U_NOMBRE_COM LIKE '$articulo%' )   $ex_filter  and w.WhsCode = '$suc' $orderby";
    }
     
    $query = "SELECT TOP 350 o.ItemCode,o.DistNumber as Lote,ItmsGrpNam as Sector,i.U_NOMBRE_COM as NombreComercial,U_design, cast(round(q.Quantity - isnull(q.CommitQty,0),2) as numeric(20,2)) as Stock,o.U_ancho as Ancho,ISNULL(c.Name,o.U_color_comercial) as Color,Status,w.WhsCode AS Suc,U_img as Img,l.Price - (( l.Price * o.U_desc1 ) / 100) as Precio1, m.AvgPrice as PrecioCosto,U_F1,U_F2,U_F3 "
            . " FROM OBTN o INNER JOIN OITM i ON i.ItemCode = o.ItemCode INNER JOIN OITB t ON  i.ItmsGrpCod = t.ItmsGrpCod LEFT JOIN OBTQ q ON o.ItemCode = q.ItemCode AND o.SysNumber = q.SysNumber INNER JOIN	OBTW w ON o.ItemCode = w.ItemCode AND o.SysNumber = w.SysNumber and q.AbsEntry=w.AbsEntry  left JOIN [@EXX_COLOR_COMERCIAL] c ON replace(o.U_color_comercial,'*','-') = c.Code "
            . " INNER JOIN ITM1 l on o.ItemCode = l.ItemCode and l.PriceList = $cat"
            . " INNER JOIN OITM m ON i.ItemCode = m.ItemCode WHERE   $filter ";
    
    if(is_numeric($articulo)){
        $query0 = "SELECT TOP 1 o.ItemCode,o.DistNumber as Lote,ItmsGrpNam as Sector,i.U_NOMBRE_COM as NombreComercial,U_design, cast(round(q.Quantity - isnull(q.CommitQty,0),2) as numeric(20,2)) as Stock,o.U_ancho as Ancho,ISNULL(c.Name,o.U_color_comercial) as Color,Status,w.WhsCode AS Suc,U_img as Img,l.Price - (( l.Price * o.U_desc1 ) / 100) as Precio1, m.AvgPrice as PrecioCosto,U_F1,U_F2,U_F3 "
            . " FROM OBTN o INNER JOIN OITM i ON i.ItemCode = o.ItemCode INNER JOIN OITB t ON  i.ItmsGrpCod = t.ItmsGrpCod LEFT JOIN OBTQ q ON o.ItemCode = q.ItemCode AND o.SysNumber = q.SysNumber INNER JOIN	OBTW w ON o.ItemCode = w.ItemCode AND o.SysNumber = w.SysNumber and q.AbsEntry=w.AbsEntry  left JOIN [@EXX_COLOR_COMERCIAL] c ON replace(o.U_color_comercial,'*','-') = c.Code "
            . "inner join ITM1 l on o.ItemCode = l.ItemCode and l.PriceList = $cat"
            . " INNER JOIN OITM m ON i.ItemCode = m.ItemCode WHERE o.DistNumber = '$articulo'";
        
        $query = "$query0 union $query"; 
    }
    
   //echo $query;
      
    $articulos = array();
    $MsLink = new Ms();
    $MsLink->Query($query);
    while($MsLink->NextRecord()){
        $lote = array_map('utf8_encode',$MsLink->Record);
        $f1 = number_format((float)$lote['U_F1'],2,',','.');
        $f2 = number_format((float)$lote['U_F2'],2,',','.');
        $f3 = number_format((float)$lote['U_F3'],2,',','.');
        $falla = ($f1 == '0,00')?'':"F1:$f1%";
        $falla .= ($f2 == '0,00')?'':((strlen($falla)>0)?','."F2:$f2%":"F2:$f2%");
        $falla .= ($f3 == '0,00')?'':((strlen($falla)>0)?','."F3:$f3%":"F3:$f3%");

        $lote['NombreComercial'] .= (strlen(trim($falla))==0)?'':", ($falla)";
        $in_doc = false;
        if(array_key_exists($lote['Lote'],$n_articulos)){
            if($n_articulos[$lote['Lote']]['doc'] === 'Reserva' ){
                if( $lote['Suc'] === '00'){
                    $lote['doc'] = $n_articulos[$lote['Lote']];                    
                }else{
                    $lote['doc'] = array();                    
                }
            }else{
                if($n_articulos[$lote['Lote']]['doc'] === 'Pedido' ){  // Si esta en un pedido anterior se le resta el pedido anterior al stock actual
                    //print_r($n_articulos[$lote['Lote']]);
                    $stock = $lote['Stock'];
                    $pedido_ant = $n_articulos[$lote['Lote']]['cantidad']; 
                    
                    $stock_real = $stock - $pedido_ant;
                    
                    $lote['Stock'] = $stock_real;
                    if($stock_real <= 0){
                      $lote['doc'] = $n_articulos[$lote['Lote']];  
                    }else{
                        $lote['doc'] = array(); 
                    }
                    //echo "<br>";
                    //print_r($lote);
                    
                }else{                             
                   $lote['doc'] = $n_articulos[$lote['Lote']];               
                }
            } 
        }else{
            $lote['doc'] = array(); 
        }
         
        $doc = $n_articulos[$lote['Lote']]['doc'];
        
        //array_push($articulos,array_map('utf8_string',$lote));
        if($disponibles == "true" ){            
            if($doc == ""){
                array_push($articulos, $lote );                
            }            
        }else{
            array_push($articulos, $lote );
            //echo  ">>>>>>>>>>>>>>>>>>>|$disponibles|      $in_doc Lote $lote<br>" ;
        }
    }
     
    
    // $articulos = getResultArrayMSSQL($query);    
    echo json_encode($articulos);    
}
function getItemCodeLikeName($nameSearch){
    require_once("../Y_DB_MSSQL.class.php");
    $link = new MS();
    $ItemCodes = array();
     
    $link->Query("SELECT ItemCode FROM OITM where ItemName like '%$nameSearch%'");
    while($link->NextRecord()){
        array_push($ItemCodes, "'". $link->Record['ItemCode']."'");
    }
    return $ItemCodes;
}
function getNombreArticulo($lote){
    require_once("../Y_DB_MSSQL.class.php");
    $link = new MS();
    $ItemCodes = array();
     
    $link->Query("SELECT ItemName FROM OBTN where DistNumber = '$lote'");
    if($link->NumRows()>0){
        $link->NextRecord();
        return $link->Record['ItemName'];
    }
}

function eliminarNotaPedidoVacia(){
   $nro_nota = $_POST['nro_nota'];   
   $db = new My();
   $db->Query("DELETE FROM pedido_traslado WHERE n_nro = $nro_nota;");
   echo "Ok";
}

function getPrecioVentaAnterior(){
    $codigo = $_POST['codigo'];
    $cod_cli = $_POST['cod_cli'];
     
    $dbd = new My();
     
    $array = array();
     
        
    $dbd->Query("SELECT d.precio_venta  FROM  factura_venta f,fact_vent_det  d WHERE f.f_nro = d.f_nro AND f.estado ='Cerrada'  AND f.cod_cli = '$cod_cli' AND codigo = '$codigo' ORDER BY id_det DESC LIMIT 1");
    if($dbd->NumRows()>0){
        $dbd->NextRecord();
        $u_precio = $dbd->Record['precio_venta'];
        array_push($array,array('codigo'=>$codigo,'precio'=>number_format($u_precio, 0, ',', '.')));  
    }            
    
    echo json_encode($array);
}

function ping(){
   $pong = time();
   echo $pong; // The pong is a unix time_stamp
}

new SolicitudTrasladoMobile();
?>

