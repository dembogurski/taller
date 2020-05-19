<?php

/**
 * Description of SolicitudTraslado
 * @author Ing.Douglas
 * @date 09/12/2015
 */

require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");
require_once("../Config.class.php");
require_once("../utils/NumPad.class.php");   

class SolicitudTraslado {
    function __construct(){
        $usuario = $_POST['usuario'];  
        $suc = $_POST['suc'];  
        $sucs = $this->getSucs($suc);
        $sucursales = '';
        foreach($sucs as $cod=>$descri){
            $sucursales .= "<option value='$cod' data-informacion='$descri'>$cod</option>";
        }
        
        $t = new Y_Template("SolicitudTraslado.html");
        
        $c = new Config();
        $host = $c->getNasHost();
        $path = $c->getNasFolder();
        $images_url = "http://$host/$path";
        $t->Set("images_url",$images_url);
        
        $t->Set("sucursales",$sucursales);
        
        
        $t->Show("headers");
        $t->Show("area_carga_cab"); 
        $t->Show("mensaje"); 
        $t->Show("solicitudes_abiertas_cab");
        
        $db = new My();
        $db->Query("SELECT n_nro AS Nro,usuario AS Usuario,DATE_FORMAT(fecha,'%d-%m-%Y') AS Fecha,estado AS Estado,suc AS Origen,suc_d AS Destino FROM pedido_traslado WHERE estado = 'Abierta' AND usuario = '$usuario' and suc = '$suc'");
        
        $dbd = new My();
        
        while($db->NextRecord()){
            $Nro = $db->Record['Nro'];
            $Usuario = $db->Record['Usuario'];
            $Fecha = $db->Record['Fecha'];
            $Estado = $db->Record['Estado'];
            $Origen = $db->Record['Origen'];
            $Destino = $db->Record['Destino'];
            $t->Set("nro",$Nro); 
            $t->Set("usuario",$Usuario); 
            $t->Set("fecha",$Fecha); 
            $t->Set("origen",$Origen); 
            $t->Set("destino",$Destino); 
            $t->Set("estado",$Estado); 
            $t->Show("solicitudes_abiertas_data");
            $dbd->Query("SELECT lote,descrip,cantidad,color,mayorista,urge,obs FROM pedido_tras_det WHERE n_nro = $Nro;");
         
            while($dbd->NextRecord()){
              
                $lote = $dbd->Record['lote'];
                $descrip = $dbd->Record['descrip'];
                $color = $dbd->Record['color'];
                $cantidad = $dbd->Record['cantidad'];
                $mayorista = $dbd->Record['mayorista'];
                $urgente = $dbd->Record['urgente'];
                $obs = $dbd->Record['obs'];
                
                $t->Set("lote",$lote);
                $t->Set("descrip",$descrip);
                $t->Set("color",$color);
                $t->Set("cantidad",$cantidad);
                $t->Set("mayorista",$mayorista);
                $t->Set("urgente",$urgente);
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
        $db->Query("select suc, nombre from sucursales where suc <> '$currenSuc' and tipo != 'Sub-Deposito' order by left(suc,2)/1 asc");
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
new SolicitudTraslado();
?>

