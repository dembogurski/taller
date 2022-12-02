<?php

 

/**
 * Description of PermisosXGrupo
 *
 * @author Doglas
 */
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_Template.class.php");


class PermisosXGrupo {
     function __construct() {
        $action = $_REQUEST['action'];  
        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }
    }

    function main() {
    
        $db = new My();
        $db_g = new My();
        
        $t = new Y_Template("PermisosXGrupo.html");
         
        
        $permisos = "SELECT  p.id_permiso AS id,descripcion AS permiso,SUBSTRING_INDEX(id_permiso,'.' ,1 ) AS pri,  SUBSTRING_INDEX(id_permiso,'.' ,-1 )   AS sub  FROM permisos p   ORDER BY pri + 0 ASC, id_permiso   ASC, sub   ASC";    
        
        $db->Query($permisos);
        
        $t->Show("header");
        
        $db_g->Query("SELECT id_grupo,nombre FROM grupos order by id_grupo asc");
        
        $arr_grupos = array();
        $grupos = "";
        $grupos_visibles  = "";
        $c = 0;
        while($db_g->NextRecord()){
            $id_grupo = $db_g->Get('id_grupo');
            $grupo = $db_g->Get('nombre');
            array_push($arr_grupos, $id_grupo);
            $grupos.='<th class="grupo_'.$id_grupo.' col_grupo" onclick="resaltarColumna('.$id_grupo.')"  >'.$grupo.'</th>';
            $grupos_visibles.='<div class="grupo_selector_'.$id_grupo.' selectable unselected" onclick="toggleGrupo('.$id_grupo.')">'.$grupo.' </div>';
            $c++;
        }
        $t->Set('grupos',$grupos);
        $t->Set('grupos_visibles',$grupos_visibles);
        $t->Set('columnas',$c);
        
        
        $t->Show("permisos_cab");
        
        $permisos_x_grupo = array();
     
        $db_g->Query("SELECT id_permiso,id_grupo,trustee FROM permisos_x_grupo");        
        while($db_g->NextRecord()){
            $pg_id = $db_g->Get('id_permiso');
            $pg_gr = $db_g->Get('id_grupo');
            $trustee = $db_g->Get('trustee');
            $permisos_x_grupo["$pg_id-$pg_gr"] = $trustee;
        }    
        
        while($db->NextRecord()){
            $id = $db->Get('id');
            $permiso = $db->Get('permiso');
            $t->Set('id',$id);
            
            $count = substr_count($id, '.');
            $espacios = "";
            for($j= 1;$j <= $count;$j++){   
                $espacios .="....";
            }
            $t->Set('id_sp',"$espacios"."$id");
            $t->Set('permiso_sp',"$espacios"."$permiso");  
            
            $permiso_x_grupo = "";
            for($i = 0; $i < count($arr_grupos);$i++){
                $pg_gr = $arr_grupos[$i]; 
                $trustee = $permisos_x_grupo["$id-$pg_gr"];
                $v = substr($trustee, 0,1);
                $e = substr($trustee, 1,1);
                $m = substr($trustee, 2,1);
                
                $v_checked= "";
                $v_clase = "class='check_permiso oculto v'";
                if($v == "v"){
                    $v_checked= "checked='checked'";
                    $v_clase =  "class='check_permiso v'";
                }
                $v = '<input type="checkbox" data-name="v" '.$v_checked.' '.$v_clase.' ><div title="Ver" class="chv"></div>';     
                
                $e_checked= "";
                $e_clase = "class='check_permiso oculto e'";
                if($e == "e"){
                    $e_checked=  "checked='checked'";
                    $e_clase = "class='check_permiso e'";
                }
                $e = '<input type="checkbox" data-name="e"  '.$e_checked.' '.$e_clase.' ><div title="Ejecutar" class="che"></div>';
                
                $m_checked= "";
                $m_clase = "class='check_permiso oculto m'";
                if($m == "m"){
                    $m_checked=  "checked='checked'";
                    $m_clase = "class='check_permiso m'";
                }
                $m = '<input type="checkbox"   data-name="m"  '.$m_checked.' '.$m_clase.' ><div title="Modificar" class="chm"></div>';
                
                $permiso_x_grupo .= "<td class='itemc mate grupo_$pg_gr' data-permiso='$id' data-grupo='$pg_gr'>$v$e$m</td>";
            }
            $t->Set('permiso_x_grupo',$permiso_x_grupo);
            $t->Show("permisos_data");
        }
         $t->Show("permisos_foot");
    }    
}

function guardarPermiso(){
    $permiso = $_POST['permiso'];         
    $grupo = $_POST['grupo'];         
    $trustee = $_POST['trustee'];     
    $db = new My();
    $db->Query("SELECT trustee FROM permisos_x_grupo WHERE id_permiso = '$permiso' AND id_grupo = '$grupo'");
    if($db->NumRows() > 0){
       $db->Query("UPDATE permisos_x_grupo SET trustee = '$trustee' WHERE id_permiso = '$permiso' AND id_grupo = '$grupo'");  
    }else{
       $db->Query("INSERT INTO  permisos_x_grupo(id_permiso, id_grupo, trustee)VALUES ('$permiso', '$grupo', '$trustee');"); 
    }
    echo json_encode(array("mensaje"=>"Ok"));
}

function getGruposUsuario(){
    require_once("../Functions.class.php");
    $usuario = $_POST['usuario'];         
    $sql = "SELECT id_grupo FROM usuarios_x_grupo WHERE usuario = '$usuario'";
    $f = new Functions();
    echo json_encode($f->getResultArray($sql));
}



new PermisosXGrupo();
?>
