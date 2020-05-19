<?php

/**
 * Description of AsignarImagenLote
 * @author Ing.Douglas
 * @date 28/09/2018
 */

set_time_limit(0);

require_once ("PHPExcel/IOFactory.php");
require_once ("../Y_DB_MySQL.class.php");
require_once ("../Y_DB_MSSQL.class.php");

class AsignarImagenLote {
   function __construct() {
        $action = $_REQUEST['action'];
        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }
    }

    function main() {
         
        
        // Formato del Excel
        //ItemCode BatchNum Ancho Gramaje Cant.Aajustar

        $inputFileName = '../files/Excel/imagenes_antes_y_despues2.xlsx';
        try {
            $inputFileType = PHPExcel_IOFactory::identify($inputFileName);
            $objReader = PHPExcel_IOFactory::createReader($inputFileType);
            $objPHPExcel = $objReader->load($inputFileName);
            //  Get worksheet dimensions
            $sheet = $objPHPExcel->getSheet(0);
            $highestRow = $sheet->getHighestRow();
            $highestColumn = $sheet->getHighestColumn();

            $ms = new MS();
            $db = new My();
            //  Loop through each row of the worksheet in turn  $highestRow
            for ($row = 1; $row <= 98; $row++) {
                //  Read a row of data into an array
                $arr = $sheet->rangeToArray('A' . $row . ':' . $highestColumn . $row, NULL, TRUE, FALSE);
                 
                $BatchNumNuevo = $arr[0][1];
                $BatchNumViejo = $arr[0][0];
               
                 
                if($BatchNumViejo == ""){
                    break;
                }                    
                $flag = 0;
                
                $sql = "SELECT  top 1 U_img FROM OIBT   t WHERE   BatchNum = '$BatchNumViejo'; ";
                $ms->Query($sql);
                $ms->NextRecord();
                $U_img =  $ms->Record['U_img'] ; 
                                    
                $ms->Query("UPDATE OIBT SET U_img = '$U_img' WHERE BatchNum = '$BatchNumNuevo';");
                
                echo   "$BatchNumViejo   --> $U_img  --> $BatchNumNuevo <br>";           
                
            }
        } catch (Exception $e) {
            die('Error loading file "' . pathinfo($inputFileName, PATHINFO_BASENAME) . '": ' . $e->getMessage());
        }
    }

}

new AsignarImagenLote()
?>