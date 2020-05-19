<?php

/**
 * Description of ManejoLotes
 * @author Ing.Douglas
 * @date 16/06/2016
 */

require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_DB_MSSQL.class.php");    


class ManejoLotes {
   function __construct(){
       if(isset($_POST['action'])){
           call_user_func_array(array(&$this,$_POST['action']),array());
           //call_user_func($_POST['action']);
       }else{
           $t = new Y_Template("ManejoLotes.html");
           $verValMinPrecMinVent = ($this->verValMinPrecMinVent($_REQUEST['usuario']))?"":"style=display:none";
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
           $t->Show("headers");
           $hoy = date("d/m/Y");
           $t->Set("hoy", $hoy);
           $t->Set("verValMinPrecMinVent", $verValMinPrecMinVent);
           
           $my = new My();
           $sql = "SELECT suc,nombre FROM sucursales order by  suc asc";
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
       }
   }
   // Buscar Colores
   public function buscarColores(){
       $search = $_POST['search'];
       $ms_link = new MS();
       $colores = array();
       $ms_link->Query("SELECT Code,Name FROM [@EXX_COLOR_COMERCIAL] WHERE Name LIKE '$search%' ORDER BY Name ASC");
       while($ms_link->NextRecord()){
           $colores[$ms_link->Record['Code']] = utf8_encode($ms_link->Record['Name']);
       }
       echo  json_encode($colores);
   }
   // Actualizar Color
   public function actualizarColor(){
        $msj = array();
        $ms_link = new MS();
        $ColorCod = $_POST['ColorCod'];
        $padreEHijos = $_POST['padreEHijos'];
        $lotes = implode(',',json_decode($_POST['lotes']));
        if($padreEHijos == 'true'){
            $lotes = $this->lotesHYP(json_decode($_POST['lotes']));
        }
        $this->logColor($lotes, $ColorCod, $_POST['usuario']);
       // echo $lotes;

        $ms_link->Query("UPDATE OIBT  set U_color_comercial = '$ColorCod' WHERE BatchNum IN ($lotes)");
        $updated = (float)$ms_link->AffectedRows();
        $msj['msj'] = "Operacion Exitosa !";
        echo  json_encode($msj);
   }

   // Buscar hermanos y padre
   public function lotesHYP($lts){
       $ms = new MS();    
       $t_lts = $lts;   
       $lotes = implode(',',$lts);
       $ms->Query("SELECT r.DistNumber, r.U_padre, r.U_color_comercial, r.U_color_comb, r.U_color_cod_fabric FROM OBTN r INNER JOIN (SELECT DistNumber, ItemCode, U_color_comercial, U_design, U_padre, U_nro_lote_fab, U_color_cod_fabric, U_img FROM OBTN o where o.DistNumber in ($lotes)) AS ref ON ((r.DistNumber = ref.U_padre AND ref.U_padre <> '') OR r.U_padre = ref.DistNumber OR (r.DistNumber = ref.DistNumber OR (r.U_padre = ref.U_padre AND ref.U_padre <> ''))) AND r.ItemCode = ref.ItemCode AND r.U_color_cod_fabric = ref.U_color_cod_fabric GROUP BY r.DistNumber,r.U_padre,r.U_color_comercial,r.U_color_comb, r.U_color_cod_fabric");
       while($ms->NextRecord()){
           $l = $ms->Record['DistNumber'];
           if(!in_array($l,$t_lts)){
               array_push($t_lts,$ms->Record['DistNumber']);
           }
       }
       return implode(',',$t_lts);
   }

   public function logColor($lotes, $color, $usuario){
       $ms = new MS();
       $my = new My();
       $ms->Query("SELECT DistNumber, U_color_comercial FROM OBTN WHERE DistNumber IN ($lotes)");
       while($ms->NextRecord()){
           $old_color = $ms->Record['U_color_comercial'];
           $DistNumber = $ms->Record['DistNumber'];           
           $my->Query("INSERT INTO logs (usuario, fecha, hora, accion, tipo, doc_num, data) VALUES ('$usuario', date(now()), time(now()), 'Combio Color', 'Lote', '$DistNumber', 'De $old_color a $color')");
       }
   }

   public function actualizarFactorPrecio(){
        $msj = array();
        $ms_link = new MS();
        $FactorPrecio = $_POST['FactorPrecio'];
        $lotes = implode(',',json_decode($_POST['lotes']));

        $ms_link->Query("UPDATE OIBT  set U_factor_precio = '$FactorPrecio' WHERE BatchNum IN ($lotes)");
        $updated = (float)$ms_link->AffectedRows();
        $msj['msj'] = "Operacion Exitosa !";
        echo  json_encode($msj);    
   }

   function verValMinPrecMinVent($usuario){
       $y = new My();
       $y->Query("SELECT count(*) as permiso from usuarios u inner join usuarios_x_grupo g using(usuario) inner join permisos_x_grupo p using(id_grupo) where u.usuario = '$usuario' AND  p.id_permiso = '9.2.1' AND p.trustee <> '---'");
       $y->NextRecord();

       return (intval($y->Record['permiso'])>0);
   }
}
new ManejoLotes();
?>
