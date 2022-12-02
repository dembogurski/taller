<?php

require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");

/**
 * Description of Audit
 *
 * @author Doglas
 */
class ABMClientes {

    private $table = 'clientes';
    private  $items = [array("column_name"=>"cod_cli","nullable"=>"NO","data_type"=>"varchar","max_length"=>"30","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Cod Cli=>","titulo_listado"=>"Cod Cli=>","type"=>"text","required"=>"required","inline"=>"false","editable"=>"readonly","insert"=>"Auto","default"=>"","pk"=>"PRI","extra"=>""),
 array("column_name"=>"tipo_doc","nullable"=>"YES","data_type"=>"varchar","max_length"=>"30","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Tipo Doc=>","titulo_listado"=>"","type"=>"select","required"=>"required","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"C.I.=>RUC,D.N.I.=>DNI Arg.,R.G.=>RG Brasil,Otro=>Otro","pk"=>"","extra"=>""),
 array("column_name"=>"cat","nullable"=>"YES","data_type"=>"varchar","max_length"=>"30","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Categoria=>","titulo_listado"=>"","type"=>"select","required"=>"required","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"1=>1,2=>2,3=>3,4=>4,5=>5","pk"=>"","extra"=>""),
 array("column_name"=>"ci_ruc","nullable"=>"YES","data_type"=>"varchar","max_length"=>"30","numeric_pres"=>"","dec"=>"","titulo_campo"=>"CI RUC=> ","titulo_listado"=>"CI RUC=> ","type"=>"text","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"","pk"=>"","extra"=>""),
 array("column_name"=>"nombre","nullable"=>"YES","data_type"=>"varchar","max_length"=>"60","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Nombre=>","titulo_listado"=>"Nombre","type"=>"text","required"=>"required","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"","pk"=>"","extra"=>""),
 array("column_name"=>"tel","nullable"=>"YES","data_type"=>"varchar","max_length"=>"30","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Tel=>","titulo_listado"=>"","type"=>"text","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"","pk"=>"","extra"=>""),
 array("column_name"=>"email","nullable"=>"YES","data_type"=>"varchar","max_length"=>"40","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Email=>","titulo_listado"=>"","type"=>"text","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"","pk"=>"","extra"=>""),
 array("column_name"=>"fecha_nac","nullable"=>"YES","data_type"=>"date","max_length"=>"","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Fecha Nac=>","titulo_listado"=>"","type"=>"date","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"","pk"=>"","extra"=>""),
 array("column_name"=>"pais","nullable"=>"YES","data_type"=>"varchar","max_length"=>"30","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Pais=>","titulo_listado"=>"","type"=>"db_select","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"paises=>codigo_pais,nombre","pk"=>"","extra"=>""),
 array("column_name"=>"ciudad","nullable"=>"YES","data_type"=>"varchar","max_length"=>"30","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Ciudad=>","titulo_listado"=>"","type"=>"text","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"","pk"=>"","extra"=>""),
 array("column_name"=>"dir","nullable"=>"YES","data_type"=>"varchar","max_length"=>"60","numeric_pres"=>"","dec"=>"","titulo_campo"=>"Dir=>","titulo_listado"=>"","type"=>"textarea","required"=>"","inline"=>"false","editable"=>"Yes","insert"=>"Yes","default"=>"","pk"=>"","extra"=>"")];    
    private $primary_key = 'cod_cli';
    private $limit = 10000;

    function __construct() {         
        if (isset($_REQUEST['action'])) {
            $this->{$_REQUEST['action']}();
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
          
		
        $t = new Y_Template("ABMClientes.html");
        $t->Show("headers");
	$t->Show("insert_edit_form");// Empty div to load here  formulary for edit or new register 	  
        $db = new My();     
        $Qry = "SELECT  $columns FROM  $this->table  LIMIT $this->limit"; 
        $db->Query($Qry);

        if ($db->NumRows() > 0) {
            $t->Show("data_header");
            while ($db->NextRecord()) {
                
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
        $t = new Y_Template("ABMClientes.html");
        $t->Show("add_form_cab");
         
           foreach ($this->items as $array => $arr) {           
             $column_name = $arr['column_name'];
             $insert = $arr['insert'];
             $type = $arr['type'];
             $dec = $arr['dec'];
             
             if($column_name == "cod_cli"){
                $ms = new My();
                $SQLCardCode = "SELECT CONCAT('C',LPAD((SUBSTRING(cod_cli,2) +1),6,'0')) as CardCode   FROM clientes ORDER BY cod_cli DESC LIMIT 1";
                $ms->Query($SQLCardCode);
                $ms->NextRecord();           
                $NewCardCode = $ms->Record['CardCode']; // Actual Max CardCode.
                $t->Set("posible_cod",$NewCardCode);
             }
             
             //echo "$column_name <br>";
             
             if($insert === 'Yes'){
                  
                if($type == "db_select"){
                    $db_options = "\n";
                    $default = $arr['default'];
                    list($tablename,$columns) = explode("=>",$default);        
                    $query = "SELECT $columns FROM $tablename order by hits desc"; 
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
		  
        $t = new Y_Template("ABMClientes.html");
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
                    $query = "SELECT $columns FROM $tablename"; 
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
                    
                    if($key == "fecha_nac" && $value == ''){
                        $update .=" $key = '1970-01-01',"; 
                    }else{
                        $update .=" $key = '$value',"; 
                    }
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
                   if($key == "cod_cli"){
                       $ms = new My();
                        $SQLCardCode = "SELECT CONCAT('C',LPAD((SUBSTRING(cod_cli,2) +1),6,'0')) as CardCode   FROM clientes ORDER BY cod_cli DESC LIMIT 1";
                        $ms->Query($SQLCardCode);
                        $ms->NextRecord();           
                        $NewCardCode = $ms->Record['CardCode']; // Actual Max CardCode.
                        $value = "$NewCardCode";
                   } 
                   if($key == "nombre"){
                       $value = strtoupper($value);
                   }
                   if($key == "fecha_nac" && $value == ""){
                       $value = "2000-01-01";
                   }
                   $insert_vlues .="'$value',";  
                 }
              }    
           }            
       }
       //112201
       $colnames.="suc,moneda,cta_cont,cat";
       $insert_vlues.="'01','G$','112201',1";
   
       
       //$colnames = substr($colnames, 0,-1);
       //$insert_vlues = substr($insert_vlues, 0,-1);
        
       
       $Qry = "INSERT INTO $table ($colnames) VALUES($insert_vlues);";
       
       //echo $Qry;
       
       $my = new My();
       $my->Query($Qry);
       if($my->AffectedRows() > 0){
           echo json_encode(array("mensaje"=>"Ok","cod_cli"=>$NewCardCode));
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
    function addMovil(){
       $id = $_POST['c_id'];
       $rua = strtoupper( $_POST['rua']);
       $chapa = strtoupper( $_POST['chapa']); 
       $marca =   $_POST['marca']  ; 
       $modelo = strtoupper( $_POST['modelo']); 
       $cod_ent = $_POST['cod_ent']; 
       $color = $_POST['color'];
       $otros = $_POST['otros'];
       
       $vim = strtoupper( $_POST['vim']); 
       $anio_fab =  $_POST['anio_fab']; 
       if(is_nan($anio_fab)){
           $anio_fab = 1900;
       }
       
       $my = new My();
       $my->Query(" INSERT INTO moviles( codigo_entidad, rua, chapa, marca,modelo,vim,anio_fab,color,otros)VALUES ('$cod_ent', '$rua', '$chapa', '$marca','$modelo','$vim',$anio_fab,'$color','$otros');");
       echo "Ok";
    }
    function getMoviles(){
       require_once("../Functions.class.php");
       $cod_ent = $_POST['cod_ent'];
       $fn = new Functions();       
       $contacts = $fn->getResultArray("SELECT id_movil as id, codigo_entidad,nombre as cliente, rua, chapa, marca,modelo,vim,anio_fab,color,otros FROM moviles m, clientes c WHERE m.codigo_entidad = cod_cli and codigo_entidad = '$cod_ent' ORDER BY id_movil ASC");
       echo json_encode($contacts);        
    }
    function getFacturas(){
       require_once("../Functions.class.php");
       $cod_cli = $_POST['cod_cli'];
       $filtro = $_POST['filtro'];
       $fn = new Functions();       
       $Qry = $fn->getResultArray("SELECT f_nro, DATE_FORMAT(fecha,'%d-%m-%Y') AS fecha,total,estado FROM factura_venta WHERE cod_cli = '$cod_cli' AND estado $filtro order by fecha desc");
       echo json_encode($Qry);    
    }
    function getPuntos(){
       require_once("../Functions.class.php");
       $cod_cli = $_POST['cod_cli'];
        
       $fn = new Functions();       
       $Qry = $fn->getResultArray("SELECT id, puntos, motivo, DATE_FORMAT( fecha,'%d-%m-%Y') as fecha, usuario, DATE_FORMAT( fecha_canje,'%d-%m-%Y') as fecha_canje , estado FROM  puntos WHERE cod_cli ='$cod_cli' ");
       echo json_encode($Qry);    
    }
    function agregarPuntos(){
        $cod_cli = $_POST['cod_cli'];
        $usuario = $_POST['usuario'];
        $puntos = $_POST['puntos'];
        $motivo = $_POST['motivo'];
        $my = new My();
        $my->Query("INSERT INTO puntos( cod_cli, puntos, motivo, fecha, usuario,  estado)VALUES ( '$cod_cli', $puntos, '$motivo', CURRENT_DATE, '$usuario', 'Pendiente');");
        echo json_encode(array("estado"=>"Ok"));    
    }
    function delMovil(){
        $cod_ent = $_POST['cod_ent'];
        $id = $_POST['id'];
        $my = new My();
        $my->Query("delete from moviles where id_movil = '$id' and codigo_entidad = '$cod_ent'");
        echo "Ok";
    }

}


new ABMClientes();
?>
