<?php

/**
 * @author Jorge Armando Colina
 * @date 22/08/2017
 * @ultima modificacion 19-12-2019 Doglas A. Dembogurski
 */

require_once("../Y_DB_MySQL.class.php");
require_once("../utils/DocTypes.class.php");
require_once("../Y_Template.class.php");
 
class HistorialMovimiento {
    function __construct() {
        $action = $_REQUEST['action'];
        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }
    }

    function main() {
       $ms = new My();
       require_once("../Config.class.php");
        $c = new Config();
        $project = $c->getProjectName();
                    
        $path = "http://".$_SERVER['SERVER_NAME'].":".$_SERVER['SERVER_PORT']."/$project"; 
        
        $codigo = $_REQUEST['codigo'];
        $lote = $_REQUEST['lote'];
        $suc = $_REQUEST['suc'];
        
        
        $t = new Y_Template("HistorialMovimiento.html");
        
        $t->Set('fullpath', $path );
        
        $ms->Query("SELECT descrip, mnj_x_lotes, um FROM articulos WHERE codigo = '$codigo'");
        $ms->NextRecord();
        $descrip = $ms->Get('descrip');
        $mnj_x_lotes = $ms->Get('mnj_x_lotes');
        $um = $ms->Get('um');
        
        if($mnj_x_lotes === "No"){
           $t->Set('no_mnj_x_lotes', 'no_mnj_x_lotes' );  
        }
                    
        
        $DocType = new DocTypes();        
        
        $t->Set('codigo', $codigo );
        $t->Set('descrip', $descrip );
        $t->Set('lote', $lote );
        $t->Set('um', $um );
        
        $dt = new DocTypes();
                    
        $t->Show("header"); 
        
        
        $Qry ="SELECT id_hist,suc,tipo_doc, nro_doc,DATE_FORMAT(fecha_hora,'%d-%m-%Y %H:%i:%s') AS fecha,fecha_hora,usuario,direccion,cantidad,'' AS kg_desc, '' AS   gramaje,'' AS tara,h.ancho  FROM historial h, articulos l WHERE  h.codigo = l.codigo  AND  h.codigo ='$codigo'   AND suc LIKE '$suc'";
                    
        
        
        $ms->Query($Qry);
        $first = true;
        $curr_suc;
        $linea = "dos";
        $sucs = array();
        
        $saldo = 0;        
        $i = 0;
        
        
        
        
        while($ms->NextRecord()){ 
            $datos = array();       
            foreach($ms->Record as $key=>$value){
                $datos[$key] = $value;
                    
                switch($key){
                    case 'cantidad':
                        $t->Set($key,number_format((float)($value),2,',','.'));
                        if($i === 0){
                            $saldo = $value;
                            $t->Set("saldo",number_format((float)($saldo),2,',','.'));
                        }else{
                            $saldo = $saldo + $value;
                            $t->Set("saldo",number_format((float)($saldo),2,',','.'));
                        }   
                    
                        $Total = $Total + (float)($value);
                        
                        $i++;
                        break;
                    case 'suc':
                        if( $curr_suc !== $value ){
                            $curr_suc = $value;
                            $linea = ($linea == "uno")?"dos":"uno";
                            if(!in_array($value,$sucs)){
                                array_push($sucs,$value);
                            }
                        }
                        $t->Set($key,trim($value));
                        $t->Set("linea",trim($linea));
                        break;
                    
                    case 'direccion':
                        

                        if($value == 'S'){                
                            $t->Set("fondo","orangered");   
                            $t->Set("color","black");                               
                            $t->Set('direccion',"Salida");
                        }else{
                            $t->Set("fondo","green");   
                            $t->Set("color","white");  
                            $t->Set('direccion',"Entrada");
                        } 
                        break;
                    
                    case 'tipo_doc':
                        $t->Set('DocType',$DocType->getType($value));
                        $t->Set('tipo_doc', $value );
                        break;
                    
                    default: //echo  "$key --> $value  <br>";
                        $t->Set($key,trim($value));
                }                
            }
            //print_r($datos);        
            if($first){
                $first = false;
                $t->Show("head");
            }
            //$kg_calc = (($datos['gramaje'] * $saldo * $datos['ancho']) / 1000 ) + ($datos['tara'] / 1000);
            //$t->Set("kg_calc",number_format((float)($kg_calc),2,',','.'));
            $t->Set("kg_calc","");
            $t->Show("data");
        }
        $t->Set("QuantityTotal",  number_format($Total,2,',','.'));   
        $t->Show("total");
        
        $db = new My();
        $db->Query("SELECT  suc as suc_ev, estado_venta FROM stock WHERE codigo ='$codigo' AND lote = '$lote' and suc like '$suc'");
        while($db->NextRecord()){
            $suc_ev = $db->Get('suc_ev');
            $estado_venta = $db->Get('estado_venta');
            $t->Set("suc_ev", $suc_ev);   
            $t->Set("estado_venta", $estado_venta);  
            $t->Show("estado_venta"); 
        }          
        
        
        $t->Set("sucs", json_encode($sucs));   
        $t->Show("footer");
        $t->Show("script");
    }
    // Fin de pieza
    private function is_FP($lote){
                    
        $link = new My();
        $link->Query("SELECT id,usuario,CONCAT(DATE_FORMAT(fecha, '%d-%m-%Y'),' ', hora) AS fecha,suc FROM edicion_lotes WHERE lote = $lote and FP = 'Si' AND e_sap=1 ORDER By id DESC LIMIT 1");
        $link->NextRecord();
        return $link->Record;
    }
}

function getModificacionesLote(){
    $codigo = $_REQUEST['codigo'];
    $lote = $_REQUEST['lote'];
    $desde = $_REQUEST['desde'];
    $hasta = $_REQUEST['hasta'];
    require_once("../Functions.class.php");
    
    $f = new Functions();
    $sql = "SELECT suc,usuario, CONCAT( DATE_FORMAT(fecha,'%d-%m-%Y'),' ',hora) AS fecha ,ancho,tara,gramaje,kg, estado_venta, obs FROM edicion_lotes WHERE codigo = '$codigo' AND lote = '$lote'
    AND CONCAT(  fecha ,' ',hora) >= '$desde' AND CONCAT(  fecha ,' ',hora) < '$hasta'";
    
    echo json_encode($f->getResultArray($sql));
    
    
    //codigo:codigo,lote:lote, id :id,fecha:fecha
}

function getExtraInfo(){
    $usuario = $_REQUEST['usuario'];
    $id_linea = $_REQUEST['id_linea'];
    $tipo_doc = $_REQUEST['tipo_doc'];
    $nro_doc = $_REQUEST['nro_doc'];
    $codigo = $_REQUEST['codigo'];    
    $lote = $_REQUEST['lote'];
    
                    
    $data = array("id"=>$id_linea);
    require_once("../Functions.class.php");
    
    $f = new Functions();
    
    switch ($tipo_doc) {
        case "EM":
            
            $trustee = $f->chequearPermiso("9.1.1", $usuario); // Permiso para ver proveedor de donde se compro la pieza          
            $info_extra = "";
            if($trustee != '---'){
               $info_extra = ", ',    ', proveedor ";
            }
            
            $data["info"]  = $f->getResultArray("SELECT CONCAT( IF(tipo_doc_sap ='OIGN','Entrada Directa','Compra '),IF(tipo_doc_sap ='OPCH','Nacional',origen) ,' Factura: ',invoice,'',''  $info_extra) AS info  FROM entrada_merc e, entrada_det d WHERE e.id_ent = d.id_ent AND  e.id_ent = $nro_doc")[0]['info'];  
            break;
        case "RM":            
            $data["info"]  = $f->getResultArray("SELECT CONCAT(usuario,'->',recepcionista,'  ',suc,'->',suc_d) as info  from nota_remision where n_nro = $nro_doc")[0]['info'];                        
            break;
        case "FV":            
            $data["info"] = $f->getResultArray("SELECT CONCAT(cliente,' ',cantidad,' ',um_cod) AS info FROM factura_venta f, fact_vent_det d WHERE f.f_nro = d.f_nro AND f.f_nro = $nro_doc AND codigo = '$codigo'   ")[0]['info'];        
            break;
        case "FV+Fx":            
            $data["info"] = $f->getResultArray("SELECT CONCAT('Descuento x Falla ',falla_real,'') AS info  FROM factura_venta f, fact_vent_det d WHERE f.f_nro = d.f_nro AND f.f_nro = $nro_doc AND codigo = '$codigo'   ")[0]['info'];        
            break;
        case "FV+DE":            
            $data["info"] = $f->getResultArray("SELECT concat('Ctrl.Emp. Corte Real: ',cant_med,' ',sis_med) as info   FROM factura_venta f, fact_vent_det d WHERE f.f_nro = d.f_nro AND f.f_nro = $nro_doc AND codigo = '$codigo'   ")[0]['info'];  //, '  Equiv.: ', cant_med      
            break;
        case "AJ":            
            $data["info"] = $f->getResultArray("SELECT motivo AS info FROM ajustes WHERE id_ajuste = $nro_doc AND codigo ='$codigo'  ")[0]['info'];   
            break;
        case "PT":            
            $data["info"] = $f->getResultArray("SELECT CONCAT ('Nro Emision: ', nro_emis ) AS info FROM prod_terminado WHERE id_res = $nro_doc")[0]['info'];   
            break;
        case "NC":            
            $data["info"] = $f->getResultArray("SELECT CONCAT( notas,', Dev.: ',cantidad,' ',um_venta,'.') AS info FROM nota_credito n,nota_credito_det d WHERE n.n_nro = d.n_nro AND n.n_nro = $nro_doc AND d.codigo ='$codigo'  ")[0]['info'];   
            break;
        case "FR":            
            $data["info"] = $f->getResultArray("SELECT   motivo  AS info FROM fraccionamientos WHERE id_frac = $nro_doc AND codigo ='$codigo' ")[0]['info'];   
            break;
        default:
        $data["info"] = "";
            break;
    }
    echo json_encode($data);                
}

new HistorialMovimiento();
?>


