<?php

/**
 * Description of ReporteSolicitudes
 * @author Ing.Douglas
 * @date 18/12/2015
 */

require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");

class ReporteSolicitudes {
    function __construct() {
        
       $origen = $_REQUEST['origen'];
       $destino = $_REQUEST['destino'];
       $operario = $_REQUEST['usuario'];
       $desde = $_REQUEST['desde'];
       $hasta = $_REQUEST['hasta'];
       $tipo = $_REQUEST['tipo'];
       $urge = $_REQUEST['urge'];
       $nivel = $_REQUEST['nivel'];
       
       $estado = $_REQUEST['estado'];  
       $paper_size = $_REQUEST['paper_size']; 
       
       $tipo_busqueda = $_REQUEST['tipo_filtro'];
        
        
       $filtro_tipo = "AND d.codigo NOT LIKE 'IN%'";  // tejidos o insumos

       if($tipo_busqueda == "insumos"){
           $filtro_tipo = "AND d.codigo LIKE 'IN%'";
       }

       
       $t = new Y_Template("ReporteSolicitudes.html");
       $db = new My();
       $db->Query("select distinct(p.n_nro) as nro from pedido_traslado p inner join pedido_tras_det d using(n_nro) where p.estado != 'Abierta' and d.estado = '$estado' and  fecha_cierre between '$desde' and '$hasta' and mayorista like '$tipo' and urge like '$urge' and p.suc = '$origen' and p.suc_d = '$destino' group by p.n_nro order by p.n_nro asc");
       $pedidos = "<li onclick='filtrar($(this))'>*</li>";

       while($db->NextRecord()){
           $pedido_numero = $db->Record['nro'];
           $pedidos .= "<li onclick='filtrar($(this))'>$pedido_numero</li>";
       }
       $t->Set("paper_size",$paper_size);
       
       $desde_lat = new DateTime($desde);
       $hasta_lat = new DateTime($hasta);
       $t->Set("desde",$desde_lat->format('d-m-Y'));
       $t->Set("hasta",$hasta_lat->format('d-m-Y'));
             
       $t->Set("suc",$origen);
       $t->Set("suc_d",$destino);
       
       if($tipo == "%"){
           $t->Set("tipo","Mayorista y Minorista");
       }else{
           $t->Set("tipo",$tipo=='Si'?'Mayorista':'Minorista');
       }
       
       $t->Set("operario",$operario);
       $t->Set("fecha_hora",date("d-m-Y H:i"));
       $t->Set("nros", $pedidos);
       
       $t->Show("header");
       $t->Show("head");
       
       
       $db->Query("select p.n_nro as nro,concat(date_format(fecha_cierre,'%d/%m/%y'),' ',date_format(time(hora_cierre),'%H:%i')) as cierre, p.suc_d as destino,usuario,codigo,lote,lote_rem,descrip,cantidad,mayorista,urge,obs from pedido_traslado p, pedido_tras_det d where p.n_nro = d.n_nro and  p.estado != 'Abierta' and d.estado = '$estado' and  fecha_cierre between '$desde' and '$hasta' and mayorista like '$tipo' and urge like '$urge' and p.suc = '$origen' and p.suc_d = '$destino' $filtro_tipo order by descrip asc");
       
       /*
       echo "select p.n_nro as nro, p.suc_d as destino,usuario,codigo,lote,lote_rem,descrip,cantidad,mayorista,urge,obs from pedido_traslado p, pedido_tras_det d 
       where p.n_nro = d.n_nro and  p.estado != 'Abierta' and d.estado = '$estado' and  fecha_cierre between '$desde' and '$hasta' and mayorista like '$maryorista' and urge like '$urge' 
       and p.suc = '$origen' and p.suc_d = '$destino' " ; */
       
       while($db->NextRecord()){
           $nro = $db->Record['nro'];
            
           $destino = $db->Record['destino'];
           $usuario = $db->Record['usuario'];
           $codigo = $db->Record['codigo'];
           $cierre = $db->Record['cierre'];
           $lote = $db->Record['lote'];
           $lote_rem = $db->Record['lote_rem'];
           $descrip = $db->Record['descrip'];
           $cantidad = $db->Record['cantidad'];
           $mayorista = $db->Record['mayorista'];
           $urge = $db->Record['urge'];
           $obs = $db->Record['obs'];
           $t->Set("nro",$nro);
           $t->Set("usuario",$usuario);
           //$t->Set("de_a",$origen."&rArr;".$destino);
           $t->Set("codigo",$codigo);
           $t->Set("cierre",$cierre);
           $t->Set("lote",$lote);
           $t->Set("lote_rem",$lote_rem);
           $t->Set("descrip", ucwords( strtolower(utf8_decode($descrip))));
           $t->Set("cantidad",$cantidad);
           $t->Set("mayorista",$mayorista);
           $t->Set("urge",$urge);
           $t->Set("ubic","XXX");
           if($obs != ""){ 
              $setObs = "Obs: ".utf8_decode($obs);
           }else{
               $setObs = "";
           }
           if($urge == "Si"){ 
              $class_urge = "urge";
           }else{
               $class_urge = "";
           }
           $t->Set("color_urge",$class_urge);
           $t->Set("obs",$setObs);
           $t->Set("estado",$estado);
           $t->Set("verificar",($estado==='Pendiente')?'si':'no');
           $t->Show("line");
       }
       $t->Show("foot");
        if($estado == 'Suspendido' || $estado == 'Pendiente'){
            $t->Show("procesador_pedidos");
        }
    }
    
}

new ReporteSolicitudes();
?>


  