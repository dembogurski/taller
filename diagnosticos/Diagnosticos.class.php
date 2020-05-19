<?php


require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");

/**
 * Description of Diagnosticos
 *
 * @author Doglas
 */
class Diagnosticos {
    function __construct() {
        $action = $_REQUEST['action'];
        if (isset($action)) {
            $this->{$action}();
        } else {
            $this->main();
        }
    }

    function main() {
        
    }
    
    
}

new Diagnosticos();

?>