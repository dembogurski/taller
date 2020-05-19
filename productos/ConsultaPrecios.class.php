<?php

/**
 * Description of ListaPrecios
 * @author Ing.Douglas
 * @date 15/03/2017
 */

require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_DB_MSSQL.class.php");
require_once("../Functions.class.php");

class ListaPrecios {
    function __construct(){
       $t = new Y_Template("ConsultaPrecios.html");
       $usuario = $_REQUEST['usuario'];
       $ms = new MS();       
       $sql = "select U_valor as PORC_VAL_MIN from [@parametros] where Code = 'porc_valor_minimo'";      
       $ms->Query($sql);
       if($ms->NumRows() > 0){
          $ms->NextRecord();
          $PORC = number_format($ms->Record['PORC_VAL_MIN'],2,'.',',');     
          $t->Set("porc_val_min", $PORC);
       }else{
           $t->Set("err_msg", "ATENCION! Porcentaje de Valor Minimo no Establecido, contacte con el Administrador"); 
           $t->Show("err_msg");
           die();
       } 
       $hoy = date("d/m/Y");
       $t->Set("hoy", $hoy);
       $t->Show("headers");
       $f = new Functions();
       $permiso = $f->chequearPermiso("9.2.1", $usuario);    
       if($permiso != "---"){
           $t->Set("permisos_extras",""); 
       }else{
           $t->Set("permisos_extras","style='display:none'");   
       }
       
       $my = new My();
       $sql = "SELECT suc,nombre FROM sucursales where estado = 'Activo' order by  suc asc";     
       $my->Query($sql);
       $sucs = "";
       while ($my->NextRecord()) {
           $suc = $my->Record['suc'];
           $nombre = $my->Record['nombre'];
           $sucs.="<option value=" . $suc . ">" .$suc." - ".$nombre . "</option>";
       }
       $t->Set("sucursales", $sucs);
       
       
       $t->Show("filters");
       $t->Show("filters_result");       
       //$db = new My();
       
   }
}
new ListaPrecios();
?>