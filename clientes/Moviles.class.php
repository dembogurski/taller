<?php

require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");

/**
 * Description of Audit
 *
 * @author Doglas
 */
class Moviles {

    private $table = 'moviles';
    private  $items = [
 array("column_name"=>"codigo_entidad","nullable"=>"NO","data_type"=>"varchar","max_length"=>"10","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Cod. Ent=>","titulo_listado"=>"","type"=>"text","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"","pk"=>"PRI","extra"=>""),
 array("column_name"=>"chapa","nullable"=>"NO","data_type"=>"varchar","max_length"=>"30","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Chapa=>","titulo_listado"=>"Chapa","type"=>"text","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"","pk"=>"PRI","extra"=>""),
 array("column_name"=>"marca","nullable"=>"YES","data_type"=>"varchar","max_length"=>"30","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Marca=>","titulo_listado"=>"Marca","type"=>"db_select","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"marcas=>marca,marca","pk"=>"","extra"=>""),
 array("column_name"=>"tipo","nullable"=>"YES","data_type"=>"varchar","max_length"=>"60","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Tipo=>","titulo_listado"=>"","type"=>"db_select","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"tipos_moviles=>tipo_movil,descrip","pk"=>"","extra"=>""),
 array("column_name"=>"modelo","nullable"=>"YES","data_type"=>"varchar","max_length"=>"100","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Modelo=>","titulo_listado"=>"Modelo","type"=>"text","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"","pk"=>"","extra"=>""),
 array("column_name"=>"vim","nullable"=>"YES","data_type"=>"varchar","max_length"=>"200","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Vim=>","titulo_listado"=>"","type"=>"text","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"","pk"=>"","extra"=>""),
 array("column_name"=>"anio_fab","nullable"=>"YES","data_type"=>"int","max_length"=>"","numeric_pres"=>"10","dec"=>"0","titulo_campo"=>"A\u00f1o Fab=>","titulo_listado"=>"","type"=>"number","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"","pk"=>"","extra"=>""),
 array("column_name"=>"color","nullable"=>"YES","data_type"=>"varchar","max_length"=>"100","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Color=>","titulo_listado"=>"Color","type"=>"text","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"","pk"=>"","extra"=>""),
 array("column_name"=>"combustible","nullable"=>"YES","data_type"=>"varchar","max_length"=>"30","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Combustible=>","titulo_listado"=>"","type"=>"select","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"Nafta=>Nafta,Diesel=>Disel,Flex=>Flex,GLP=>GLP,Otro=>Otro","pk"=>"","extra"=>""),
 array("column_name"=>"motor","nullable"=>"YES","data_type"=>"varchar","max_length"=>"20","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Motor=>","titulo_listado"=>"","type"=>"text","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"","pk"=>"","extra"=>""),
 array("column_name"=>"otros","nullable"=>"YES","data_type"=>"varchar","max_length"=>"300","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Otros=>","titulo_listado"=>"","type"=>"textarea","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"","pk"=>"","extra"=>"")];    
    private $primary_key = 'id_movil';
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
        $columns = "id_movil,nombre as cliente, $columns";  
		
        $t = new Y_Template("Moviles.html");
        $t->Show("headers");
	$t->Show("insert_edit_form");// Empty div to load here  formulary for edit or new register 	  
        $db = new My();     
        $Qry = "SELECT  $columns FROM  $this->table m, clientes c WHERE m.codigo_entidad = cod_cli LIMIT $this->limit"; 
        //echo $Qry;
        $db->Query($Qry);

        if ($db->NumRows() > 0) {
            $t->Show("data_header");
            while ($db->NextRecord()) {
               $id_movil = $db->Get('id_movil'); 
               $cliente = $db->Get('cliente'); 
               $t->Set('id_movil', $id_movil);    
               $t->Set('cliente', "$cliente");   
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
    
    function addMovilUI(){
        $cod_cli = $_REQUEST['cod_cli'];
        $cliente = $_REQUEST['cliente'];
         
        $tmp_con = new My();
        $t = new Y_Template("Moviles.html");
        if($cod_cli == ""){
           $t->Set("prop_readonly","");
           $cod_cli = "C000001"; // Sin Nombre o Anonimo
        }else{
            $t->Set("prop_readonly","readonly='readonly'");
        }
        $t->Show("add_form_cab");
         $t->Set("value_of_propietario",$cliente);
           foreach ($this->items as $array => $arr) {           
             $column_name = $arr['column_name'];
             $insert = $arr['insert'];
             $type = $arr['type'];
             $dec = $arr['dec'];
             
             $t->Set("value_of_cod_ent",$cod_cli);
             
             //echo "$column_name <br>";
             
             if($insert === 'Yes'){
                  
                if($type == "db_select"){
                    $db_options = "\n";
                    $default = $arr['default'];
                    list($tablename,$columns) = explode("=>",$default);   
                    $order = "";
                    if($tablename == "marcas" || $tablename == "tipos_moviles"){
                       $order = " order by hits desc"; 
                    }
                    $query = "SELECT $columns FROM $tablename $order"; 
                    $tmp_con->Query($query);
                    $col_array = explode(",",$columns);
                    while($tmp_con->NextRecord()){ 
                        $key = "";
                        $values = "";
                        for($i = 0; $i < sizeof($col_array); $i++){
                          if($i == 0){
                             $key = $tmp_con->Record[ $col_array[$i] ];
                          }else{ 
                              $values .= $tmp_con->Record[ $col_array[$i] ]." ";
                          } 
                        }
                        $values = trim($values);
                        $db_options.='<option value="'.$key.'">'.$values.'</option>'."\n";
                         
                    } 
                    $t->Set("img_value_of_tipo","Sedan"); 
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
    function editMovilUI(){
        $pk = $_REQUEST['pk'];
        
        $columns = "";
          
        foreach ($this->items as $array => $arr) {           
           $columns .= $arr['column_name'].",";          
        }        
        $columns = substr($columns,0, -1);
        $columns.=",nombre";
        $columns = str_replace(",tipo", ",m.tipo", $columns);
        
        $db = new My(); 
        $tmp_con = new My();
		  
        $t = new Y_Template("Moviles.html");
        $t->Set("id_movil",$pk);
        //$t->Show("headers");     
        
        $Qry = "SELECT $columns FROM $this->table m,clientes c WHERE c.cod_cli = m.codigo_entidad and  $this->primary_key = '$pk'";
        
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
                 //echo "$column_name <br>";
                if($type == "db_select" && $column_name != 'marca'){
                    $db_options = "\n";
                    $default = $arr['default'];
                    list($tablename,$columns) = explode("=>",$default);   
                    $order = "";
                    if($tablename == "tipos_moviles"){
                        $order = " order by hits desc";
                    }
                    $query = "SELECT $columns FROM $tablename $order";  
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
                                  if($column_name == 'tipo'){
                                     $t->Set("img_value_of_".$column_name,$value); 
                                  }
                                           
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
           $cliente = $db->Get('nombre');
           $t->Set("value_of_cliente" ,$cliente);
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
           echo json_encode(array("mensaje"=>"Sin Modificaciones"));
       }           
       $my->Close();      
       
    }
    
    function addData(){
       $master = $_REQUEST['master'];        
       $table = $this->table;        
       
       $data = $master['data'];
       $colnames = "";
       $insert_vlues = "";
       
       $chapa = $data['chapa'];
        
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
           $my->Query("SELECT id_movil FROM moviles WHERE chapa = '$chapa' ORDER BY id_movil DESC LIMIT 1");
           $my->NextRecord();
           $id = $my->Get('id_movil');
           echo json_encode(array("mensaje"=>"Ok","id_movil"=>$id));
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
    
    function uploadCarImage(){
        $id_movil = $_REQUEST['id_movil'];        
        $imgData  = $_REQUEST['imgData'];  
        $db = new My();
        $db->Query("SELECT IF( MAX(id_img) IS NULL ,0,MAX(id_img) ) AS max_id FROM moviles_img WHERE id_movil = $id_movil");
        $db->NextRecord();
        $max_id = $db->Get("max_id");
        $max_id++;
        
        $path = "../img/vehiculos/$id_movil";
        $img_name = "img/vehiculos/$id_movil/$max_id.jpg";
        @mkdir($path);
        
        $output_file = "$path/$max_id.jpg";
        $db->Query("INSERT INTO  moviles_img(id_movil, id_img, url_img) VALUES ($id_movil, $max_id, '$img_name');");        
        $this->base64ToImage($imgData, $output_file);
        echo json_encode(array("mensaje"=>"Ok"));
    }
    
    function base64ToImage($base64_string, $output_file) {
        $file = fopen($output_file, "wb");

        $data = explode(',', $base64_string);

        fwrite($file, base64_decode($data[1]));
        fclose($file);

        return $output_file;
    }
    
    function getImagenesVehiculo(){
        require_once("../Functions.class.php");
        $f  = new Functions(); 
        $usuario = $_POST['usuario'];
        $id_movil = $_POST['id_movil'];
        $sql = "SELECT id_img,  url_img, principal FROM moviles_img WHERE id_movil = '$id_movil'";
        echo json_encode($f->getResultArray($sql));
    }
    function setPrincipalImage(){
        $db = new My(); 
        $id = $_POST['id'];
        $id_movil = $_POST['id_movil'];
        $sql = "update moviles_img set principal = 'No' where id_movil = '$id_movil'"; 
        $db->Query($sql); 
    }
    function eliminarFoto(){
        $db = new My(); 
        $id = $_POST['id'];
        $id_movil = $_POST['id_movil'];
        $sql = " DELETE FROM moviles_img WHERE id_movil = '$id_movil' AND id_img = $id;"; 
        $db->Query($sql);
    }
    function cambiarPropietario(){
        $db = new My(); 
        $chapa = $_POST['chapa'];
        $id_movil = $_POST['id_movil'];
        $cod_cli = $_POST['cod_cli'];
        $sql = "UPDATE moviles SET codigo_entidad = '$cod_cli' WHERE chapa = '$chapa';"; 
        $db->Query($sql);
        echo "";
    }

}


new Moviles();
?>
