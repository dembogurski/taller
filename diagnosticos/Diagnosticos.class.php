<?php

require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");

/**
 * Description of Audit
 *
 * @author Doglas
 */
class Diagnosticos {

    private $table = 'diagnosticos';
    private  $items = [array("column_name"=>"id_diag","nullable"=>"NO","data_type"=>"int","max_length"=>"","numeric_pres"=>"10","dec"=>"0","titulo_campo"=>"Id Diag=>","titulo_listado"=>"Id Diag","type"=>"number","required"=>"required","inline"=>"false","editable"=>"readonly","insert"=>"Auto","default"=>"","pk"=>"PRI","extra"=>"auto_increment"),
 array("column_name"=>"id_rec","nullable"=>"YES","data_type"=>"int","max_length"=>"","numeric_pres"=>"10","dec"=>"0","titulo_campo"=>"N&oacute; Recepcion=>","titulo_listado"=>"","type"=>"db_select","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"recepcion=>id_diag,id_diag,concat('[',chapa,']') as chapa,usuario,fecha","pk"=>"","extra"=>""),
 array("column_name"=>"chapa","nullable"=>"YES","data_type"=>"varchar","max_length"=>"30","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Chapa=>","titulo_listado"=>"Chapa","type"=>"text","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"","pk"=>"","extra"=>""),
 array("column_name"=>"fecha","nullable"=>"YES","data_type"=>"date","max_length"=>"","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Fecha=>","titulo_listado"=>"Fecha","type"=>"date","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"","pk"=>"","extra"=>""),
 array("column_name"=>"usuario","nullable"=>"YES","data_type"=>"varchar","max_length"=>"30","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Usuario=>","titulo_listado"=>"Usuario","type"=>"text","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Auto","default"=>"","pk"=>"MUL","extra"=>""),
 array("column_name"=>"tecnico_autoriz","nullable"=>"YES","data_type"=>"varchar","max_length"=>"30","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Tecnico Autoriz=>","titulo_listado"=>"Tecnico Autoriz","type"=>"db_select","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"usuarios=>usuario,usuario","pk"=>"","extra"=>""),
 array("column_name"=>"fecha_ingreso","nullable"=>"YES","data_type"=>"datetime","max_length"=>"","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Fecha Ingreso=>","titulo_listado"=>"Fecha Ingreso","type"=>"datetime-local","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"No","default"=>"","pk"=>"","extra"=>""),
 array("column_name"=>"fecha_salida","nullable"=>"YES","data_type"=>"datetime","max_length"=>"","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Fecha Salida=>","titulo_listado"=>"","type"=>"datetime-local","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"","pk"=>"","extra"=>""),
 array("column_name"=>"estado","nullable"=>"YES","data_type"=>"varchar","max_length"=>"30","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Estado=>","titulo_listado"=>"Estado","type"=>"select","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"Abierto=>Abierto,Cerrado=>Cerrado","pk"=>"","extra"=>"")];    
    private $primary_key = 'id_diag';
    private $limit = 100;

    function __construct() {
        $action = $_REQUEST['action'];
        if (isset($action)) {
            $this->{$action}();
        } else {
            $this->main();
        }
    }

    function main() {
        
	$columns = "";
        foreach ($this->items as $array){ 
            $titulo_listado = $array['titulo_listado'];
            
            if($titulo_listado !== ''){ 
                $data_type =  $array['data_type'];
                if($data_type == "date"){
                    $colname = $array['column_name'];
                    $columns .= "DATE_FORMAT($colname,'%d-%m-%Y') as $colname,";
                }else{
                    $columns .= $array['column_name'].",";   
                }                
            }
        }
        
        $columns = substr($columns,0, -1);
          
		
        $t = new Y_Template("Diagnosticos.html");
        $t->Show("headers");
	$t->Show("insert_edit_form");// Empty div to load here  formulary for edit or new register 	  
        $db = new My();     
        //$Qry = "SELECT  $columns FROM  $this->table LIMIT $this->limit"; 
        
        $Qry = "SELECT id_diag,a.chapa,DATE_FORMAT(fecha,'%d-%m-%Y') AS fecha,a.usuario,tecnico_autoriz,fecha_ingreso,a.estado, c.nombre FROM diagnosticos a, moviles m , clientes c
        WHERE a.chapa = m.chapa AND m.codigo_entidad = c.cod_cli ORDER BY a.fecha DESC LIMIT $this->limit";
         
        $db->Query($Qry);

        if ($db->NumRows() > 0) {
            $t->Show("data_header");
            while ($db->NextRecord()) {
               $cliente = $db->Get('nombre');
               $t->Set('cliente', $cliente);      
               foreach ($this->items as $array){
                  $column_name = $array['column_name'];
                  $dec = $array['dec'];
                  
                  $value = $db->Record[$column_name];
                  
                  if($dec > 0 ){
                      $t->Set($column_name, number_format($value, $dec, ',', '.'));
                  }else{
                     $t->Set($column_name, $value);             
                  }
               }                

               $t->Show("data_line");
            }
            $t->Show("data_foot");
		 
            
	    $t->Show("script");
        } else {
			$t->Show("headers");
			$t->Show("data_header");
			$t->Show("data_foot");
			$t->Show("script");
            $t->Show("no_result");
        }
    }
    
    function addUI(){
        $tmp_con = new My();
        $t = new Y_Template("Diagnosticos.html");
        $t->Show("add_form_cab");
        
        $fecha_hoy = date("Y-m-d");
        $fecha_hora_hoy = date("Y-m-d h:i:s");
        $usuario = $_REQUEST['usuario'];
        $t->Set("fecha_hoy",$fecha_hoy);
        $t->Set("fecha_hora_hoy",$fecha_hora_hoy);
        $t->Set("usuario",$usuario);
         
           foreach ($this->items as $array => $arr) {           
             $column_name = $arr['column_name'];
             $insert = $arr['insert'];
             $type = $arr['type'];
             $dec = $arr['dec'];
             
                          
             //echo "$column_name $insert<br>";
             
             if($insert === 'Yes'){
                  
                if($type == "db_select"){
                    $db_options = "\n";
                    $default = $arr['default'];
                    list($tablename,$columns) = explode("=>",$default);  
                    
                    $order = "";
                    if($tablename == "recepcion"){
                        $order = "ORDER BY id_diag DESC";
                    }
                    
                    $query = "SELECT $columns FROM $tablename $order"; 
                    //echo $query;
                    $tmp_con->Query($query);
                    $col_array = explode(",",$columns);
                    while($tmp_con->NextRecord()){ 
                        $key = "";
                        $values = "";
                        $chapa = "";
                        for($i = 0; $i < sizeof($col_array); $i++){
                          if($i == 0){
                             $key = $tmp_con->Record[ $col_array[$i] ];
                          }else{ 
                              $valor = $tmp_con->Record[ $col_array[$i] ];
                              if($col_array[$i] == "chapa"){
                                 $chapa = substr($valor, 1,-1);
                              }
                              $values .= $valor." ";
                          } 
                        }
                        $values = trim($values);
                        $db_options.='<option class="chapa" data-chapa="'.$chapa.'" value="'.$key.'">'.$values.'</option>'."\n";
                    }                        
                    $t->Set("value_of_".$column_name,$db_options);
                }                
                
             }
           }
               
        $t->Show("add_form_data");
        $t->Show("add_form_foot");         
    }
    

    /**
     * Edit current line
     */
    function editUI(){
        $pk = $_REQUEST['pk'];
        
        $columns = "";
          
        foreach ($this->items as $array => $arr) {           
           $columns .= $arr['column_name'].",";          
        }        
        $columns = substr($columns,0, -1);
        
        $db = new My(); 
        $tmp_con = new My();
		  
        $t = new Y_Template("Diagnosticos.html");
        //$t->Show("headers");        
        $Qry = "SELECT $columns FROM $this->table WHERE  $this->primary_key = '$pk'";
        $db->Query($Qry);
       
        $t->Show("edit_form_cab");
        while ($db->NextRecord()) { 
           foreach ($this->items as $array => $arr) {           
             $column_name = $arr['column_name'];
             $editable = $arr['editable'];
             $type = $arr['type'];
             $dec = $arr['dec'];
             //$sub_pk = $arr['pk'];
             
             if($editable !== 'No'){
                $value = $db->Record[$column_name]; 
                 
                if($type == "db_select"){
                    $db_options = "\n";
                    $default = $arr['default'];
                    list($tablename,$columns) = explode("=>",$default);        
                    $query = "SELECT $columns FROM $tablename  "; 
                    $tmp_con->Query($query);
                    $col_array = explode(",",$columns);
                    while($tmp_con->NextRecord()){ 
                        $key = "";
                        $values = "";
                        $selected = "";
                        for($i = 0; $i < sizeof($col_array); $i++){
                          if($i == 0){
                             $key = $tmp_con->Record[ $col_array[$i] ];
                             if($key == $value){
                                  $selected = 'selected="selected"';
                             }
                                 
                          }else{  
                              $values .= $tmp_con->Record[ $col_array[$i] ]." ";
                          } 
                        }
                        $values = trim($values);
                        $db_options.='<option value="'.$key.'"  '.$selected.'  >'.$values.'</option>'."\n";
                    }                        
                    $t->Set("value_of_".$column_name,$db_options);
                }else if($type == "select"){
                    $value = $db->Record[$column_name];  
                    $def_options= $arr['default'];   
                    $items = explode(",",$def_options);
                    $options = "";
                   
                    foreach($items as $item){
                       list($val,$opt) = explode("=>",$item);
                       $selected = "";
                       if($val == $value){    
                           $selected = 'selected="selected"';
                       }
                       $options .= '<option value="'.$val.'" '.$selected.' >'.$opt.'</option>';
                    }
                    $t->Set("value_of_".$column_name,$options);
                    
                }else{
                   if($dec > 0){
                       $t->Set("value_of_".$column_name,number_format($value, $dec, ',', '.'));
                   }else{
                       $t->Set("value_of_".$column_name,$value);
                   }                        
                }
                                
                
             }
           }
        }         
        $t->Show("edit_form_data");
        $t->Show("edit_form_foot");  
 
    }


    function updateData() {
       $master = $_REQUEST['master'];        
       $table = $this->table;        
       
       $primary_keys = $master['primary_keys'];
       $update_data = $master['update_data'];
       
       $update = "";
        
       foreach ($update_data as $key => $value) {
           foreach ($this->items as $arr) {
              if($arr["column_name"] == $key){
                 if($this->isCharOrNumber( $arr["data_type"]) == "number" ){
                     if($value != ''){
                        $update .=" $key = $value,";       
                     }
                 }else{
                    $update .=" $key = '$value',";      
                 }
              }    
           }            
       }
       $update = substr($update, 0,-1);
       
       $where = " ";
       foreach ($primary_keys as $key => $value) {
           $where .=" $key = '$value' AND";       
       }
       $where = substr($where, 0,-4);
       
       $Qry = "UPDATE $table SET $update WHERE $where;";
       
       //echo $Qry;
       
       $my = new My();
       $my->Query($Qry);
       if($my->AffectedRows() > 0){
           echo json_encode(array("mensaje"=>"Ok"));
       }else{
           echo json_encode(array("mensaje"=>"Error","query"=>$Qry));
       }           
       $my->Close();      
       
    }
    
    function addData(){
       $master = $_REQUEST['master'];        
       $table = $this->table;        
       
       $data = $master['data'];
       $usuario = $data['usuario'];
       $colnames = "";
       $insert_vlues = "";
        
       foreach ($data as $key => $value) {
           foreach ($this->items as $arr) {
              if($arr["column_name"] == $key){
                 $colnames .="$key,";   
                 if($this->isCharOrNumber( $arr["data_type"]) == "number" ){
                     if($value != ''){    
                        $insert_vlues .="$value,";  
                     }else{
                        $insert_vlues .="null,";
                     }
                 }else{
                   $insert_vlues .="'$value',";  
                 }
              }    
           }            
       }
       $colnames = substr($colnames, 0,-1);
       $insert_vlues = substr($insert_vlues, 0,-1);
        
       
       $Qry = "INSERT INTO $table ($colnames) VALUES($insert_vlues);";
       
       //echo $Qry;
       
       $my = new My();
       $my->Query($Qry);
       if($my->AffectedRows() > 0){
           $my->Query("select id_diag from $table where usuario = '$usuario' order by id_diag desc limit 1;");
           $my->NextRecord();
           $id_diag = $my->Get('id_diag');
           echo json_encode(array("mensaje"=>"Ok","id_diag"=>$id_diag));
       }           
       $my->Close();         
    }
    
    function isCharOrNumber($data_type){
        $numerics = array("int","decimal","double","float","smallint","tinyint","bigint");
        if (in_array($data_type, $numerics)) {
            return "number";
        }else{
            return "char";
        }        
    }

}


new Diagnosticos();
?>
