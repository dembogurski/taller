<?php

require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");
require_once("../Clientes/Clientes.class.php");

/**
 * Description of Audit
 *
 * @author Doglas
 */
class Diagnosticos {

    private $table = 'diagnosticos';
    private $items = [array("column_name" => "id_diag", "nullable" => "NO", "data_type" => "int", "max_length" => "", "numeric_pres" => "10", "dec" => "0", "titulo_campo" => "Id Diag=>", "titulo_listado" => "Id Diag", "type" => "number", "required" => "required", "inline" => "false", "editable" => "readonly", "insert" => "Auto", "default" => "", "pk" => "PRI", "extra" => "auto_increment"), array("column_name" => "cod_cli", "nullable" => "YES", "data_type" => "varchar", "max_length" => "30", "numeric_pres" => "", "dec" => "", "titulo_campo" => "Cod Cli=>", "titulo_listado" => "Cliente", "type" => "db_select", "required" => "", "inline" => "false", "editable" => "Yes", "insert" => "Yes", "default" => "clientes=>cod_cli,nombre", "pk" => "MUL", "extra" => ""), array("column_name" => "usuario", "nullable" => "NO", "data_type" => "varchar", "max_length" => "30", "numeric_pres" => "", "dec" => "", "titulo_campo" => "Usuario=>", "titulo_listado" => "", "type" => "text", "required" => "", "inline" => "false", "editable" => "No", "insert" => "Auto", "default" => "", "pk" => "MUL", "extra" => ""), array("column_name" => "chapa", "nullable" => "YES", "data_type" => "varchar", "max_length" => "30", "numeric_pres" => "", "dec" => "", "titulo_campo" => "Chapa=>", "titulo_listado" => "Chapa", "type" => "text", "required" => "required", "inline" => "false", "editable" => "Yes", "insert" => "Yes", "default" => "", "pk" => "MUL", "extra" => ""), array("column_name" => "marca", "nullable" => "YES", "data_type" => "varchar", "max_length" => "100", "numeric_pres" => "", "dec" => "", "titulo_campo" => "Marca=>", "titulo_listado" => "Marca", "type" => "db_select", "required" => "", "inline" => "false", "editable" => "Yes", "insert" => "Yes", "default" => "marcas=>marca,marca", "pk" => "MUL", "extra" => ""), array("column_name" => "fecha", "nullable" => "YES", "data_type" => "datetime", "max_length" => "", "numeric_pres" => "", "dec" => "", "titulo_campo" => "Fecha", "titulo_listado" => "", "type" => "date", "required" => "", "inline" => "false", "editable" => "Yes", "insert" => "Auto", "default" => "", "pk" => "", "extra" => ""), array("column_name" => "descrip", "nullable" => "YES", "data_type" => "varchar", "max_length" => "10000", "numeric_pres" => "", "dec" => "", "titulo_campo" => "Descrip=>", "titulo_listado" => "", "type" => "textarea", "required" => "", "inline" => "false", "editable" => "Yes", "insert" => "Yes", "default" => "", "pk" => "", "extra" => ""), array("column_name" => "url_img0", "nullable" => "YES", "data_type" => "varchar", "max_length" => "200", "numeric_pres" => "", "dec" => "", "titulo_campo" => "Url Img0=>", "titulo_listado" => "", "type" => "textarea", "required" => "", "inline" => "false", "editable" => "Yes", "insert" => "Yes", "default" => "", "pk" => "", "extra" => ""), array("column_name" => "url_img1", "nullable" => "YES", "data_type" => "varchar", "max_length" => "200", "numeric_pres" => "", "dec" => "", "titulo_campo" => "Url Img1=>", "titulo_listado" => "", "type" => "textarea", "required" => "", "inline" => "false", "editable" => "Yes", "insert" => "Yes", "default" => "", "pk" => "", "extra" => ""), array("column_name" => "url_img2", "nullable" => "YES", "data_type" => "varchar", "max_length" => "200", "numeric_pres" => "", "dec" => "", "titulo_campo" => "Url Img3=>", "titulo_listado" => "", "type" => "textarea", "required" => "", "inline" => "false", "editable" => "Yes", "insert" => "Yes", "default" => "", "pk" => "", "extra" => "")];
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
        foreach ($this->items as $array) {
            $titulo_listado = $array['titulo_listado'];

            if ($titulo_listado !== '') {
                $data_type = $array['data_type'];
                if ($data_type == "date") {
                    $colname = $array['column_name'];
                    $columns .= "DATE_FORMAT($colname,'%d-%m-%Y') as $colname,";
                } else {
                    $columns .= $array['column_name'] . ",";
                }
            }
        }

        $columns = substr($columns, 0, -1);


        $t = new Y_Template("Diagnosticos.html");
        $t->Show("headers");
        $t->Show("insert_edit_form"); // Empty div to load here  formulary for edit or new register 	  
        $db = new My();
        //$Qry = "SELECT  $columns FROM  $this->table LIMIT $this->limit"; 
        $Qry = "SELECT id_diag,IF( LENGTH(c.nombre) > 20, CONCAT(LEFT(c.nombre,20),'..'),c.nombre)  AS cod_cli,chapa,marca FROM diagnosticos g, clientes c WHERE g.cod_cli = c.cod_cli ORDER BY id_diag DESC";


        $db->Query($Qry);

        if ($db->NumRows() > 0) {
            $t->Show("data_header");
            while ($db->NextRecord()) {

                foreach ($this->items as $array) {
                    $column_name = $array['column_name'];
                    $dec = $array['dec'];

                    $value = $db->Record[$column_name];

                    if ($dec > 0) {
                        $t->Set($column_name, number_format($value, $dec, ',', '.'));
                    } else {
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

    function getDatos() {
        require_once '../Functions.class.php';
        $f = new Functions();
        $chapa = $_REQUEST['chapa'];
        $arr = $f->getResultArray("SELECT marca, c.cod_cli FROM  clientes c, moviles m WHERE c.cod_cli = codigo_entidad AND chapa = '$chapa'");
        echo json_encode($arr);
    }

    function addUI() {
        $tmp_con = new My();
        $t = new Y_Template("Diagnosticos.html");
        $t->Show("add_form_cab");

        foreach ($this->items as $array => $arr) {
            $column_name = $arr['column_name'];
            $insert = $arr['insert'];
            $type = $arr['type'];
            $dec = $arr['dec'];


            if ($insert === 'Yes') {

                if ($type == "db_select") {
                    $db_options = "\n";
                    $default = $arr['default'];
                    list($tablename, $columns) = explode("=>", $default);
                    $order_by = "";
                    if ($tablename == "marcas") {
                        $order_by = " order by hits desc";
                    }
                    $query = "SELECT $columns FROM $tablename $order_by";

                    $tmp_con->Query($query);
                    $col_array = explode(",", $columns);
                    while ($tmp_con->NextRecord()) {
                        $key = "";
                        $values = "";
                        for ($i = 0; $i < sizeof($col_array); $i++) {
                            if ($i == 0) {
                                $key = $tmp_con->Record[$col_array[$i]];
                            } else {
                                $values .= $tmp_con->Record[$col_array[$i]] . " ";
                            }
                        }
                        $values = trim($values);
                        $db_options .= '<option value="' . $key . '">' . $values . '</option>' . "\n";
                    }
                    $t->Set("value_of_" . $column_name, $db_options);
                }
            }
            if ($insert === "Auto") {
                if ($type === "date") {
                    $current_date = date("Y-m-d");
                    $t->Set("value_of_" . $column_name, $current_date);
                }
            }
        }

        $t->Show("add_form_data");
        $t->Show("add_form_foot");
        $c = new Clientes();
        $c->getABM();
    }

    /**
     * Edit current line
     */
    function editUI() {
        $pk = $_REQUEST['pk'];

        $columns = "";

        foreach ($this->items as $array => $arr) {
            $columns .= $arr['column_name'] . ",";
        }
        $columns = substr($columns, 0, -1);

        $db = new My();
        $tmp_con = new My();

        $t = new Y_Template("Diagnosticos.html");
        //$t->Show("headers");        
        $columns = str_replace("fecha", "date_format(fecha,'%Y-%m-%d') as fecha", $columns);
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

                if ($editable !== 'No') {
                    $value = $db->Record[$column_name];

                    if ($type == "db_select") {
                        $db_options = "\n";
                        $default = $arr['default'];
                        list($tablename, $columns) = explode("=>", $default);
                        $order_by = "";
                        if ($tablename == "marcas") {
                            $order_by = " order by hits desc";
                        }
                        $query = "SELECT $columns FROM $tablename $order_by";
                        $tmp_con->Query($query);
                        $col_array = explode(",", $columns);
                        while ($tmp_con->NextRecord()) {
                            $key = "";
                            $values = "";
                            $selected = "";
                            for ($i = 0; $i < sizeof($col_array); $i++) {
                                if ($i == 0) {
                                    $key = $tmp_con->Record[$col_array[$i]];
                                    if ($key == $value) {
                                        $selected = 'selected="selected"';
                                    }
                                } else {
                                    $values .= $tmp_con->Record[$col_array[$i]] . " ";
                                }
                            }
                            $values = trim($values);
                            $db_options .= '<option value="' . $key . '"  ' . $selected . '  >' . $values . '</option>' . "\n";
                        }
                        $t->Set("value_of_" . $column_name, $db_options);
                    } else if ($type == "select") {
                        $value = $db->Record[$column_name];
                        $def_options = $arr['default'];
                        $items = explode(",", $def_options);
                        $options = "";

                        foreach ($items as $item) {
                            list($val, $opt) = explode("=>", $item);
                            $selected = "";
                            if ($val == $value) {
                                $selected = 'selected="selected"';
                            }
                            $options .= '<option value="' . $val . '" ' . $selected . ' >' . $opt . '</option>';
                        }
                        $t->Set("value_of_" . $column_name, $options);
                    } else {
                        if ($dec > 0) {
                            $t->Set("value_of_" . $column_name, number_format($value, $dec, ',', '.'));
                        } else {
                            $t->Set("value_of_" . $column_name, $value);
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
                if ($arr["column_name"] == $key) {
                    if ($this->isCharOrNumber($arr["data_type"]) == "number") {
                        if ($value != '') {
                            $update .= " $key = $value,";
                        }
                    } else {
                        $update .= " $key = '$value',";
                    }
                }
            }
        }
        $update = substr($update, 0, -1);

        $where = " ";
        foreach ($primary_keys as $key => $value) {
            $where .= " $key = '$value' AND";
        }
        $where = substr($where, 0, -4);

        $Qry = "UPDATE $table SET $update WHERE $where;";

        //echo $Qry;

        $my = new My();
        $my->Query($Qry);
        if ($my->AffectedRows() > 0) {
            echo json_encode(array("mensaje" => "Ok"));
        } else {
            echo json_encode(array("mensaje" => "Error", "query" => $Qry));
        }
        $my->Close();
    }

    function addData() {

        $db = new My();
        $db->Query("SELECT AUTO_INCREMENT FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'sistema' AND TABLE_NAME = 'diagnosticos'");
        $db->NextRecord();
        $next_id = $db->Record['AUTO_INCREMENT'];

        $master = $_REQUEST['master'];
        $table = $this->table;

        $data = $master['data'];
        $colnames = "";
        $insert_vlues = "";
        
        $path = "../files/diagnosticos/$next_id";
        
        @mkdir($path);

        for($i = 0;$i < 3;$i++){
           ${"img_".$i}  = $data["url_img_$i"];
           ${"filename_".$i} = "$path/diag_$i.jpg";
           $this->base64ToImage(${"img_".$i}, ${"filename_".$i});
        }
        
        

        $my = new My();

        foreach ($data as $key => $value) {

            if ($key == "marca") {
                $my->Query("update marcas set hits = hits + 1 where marca = '$value'");
            }
            foreach ($this->items as $arr) {
                if ($arr["column_name"] == $key) {

                    $colnames .= "$key,";
                    if ($this->isCharOrNumber($arr["data_type"]) == "number") {
                        if ($value != '') {
                            $insert_vlues .= "$value,";
                        } else {
                            $insert_vlues .= "null,";
                        }
                    } else {
                        $insert_vlues .= "'$value',";
                    }
                }
            }
        }
        $colnames = substr($colnames, 0, -1);
        $insert_vlues = substr($insert_vlues, 0, -1);


        $Qry = "INSERT INTO $table ($colnames) VALUES($insert_vlues);";

        //echo $Qry;


        $my->Query($Qry);
        if ($my->AffectedRows() > 0) {
            echo json_encode(array("mensaje" => "Ok"));
        }
        $my->Close();
    }

    function isCharOrNumber($data_type) {
        $numerics = array("int", "decimal", "double", "float", "smallint", "tinyint", "bigint");
        if (in_array($data_type, $numerics)) {
            return "number";
        } else {
            return "char";
        }
    }

    function base64ToImage($base64_string, $output_file) {
        $file = fopen($output_file, "wb");

        $data = explode(',', $base64_string);

        fwrite($file, base64_decode($data[1]));
        fclose($file);

        return $output_file;
    }

}

new Diagnosticos();
?>
