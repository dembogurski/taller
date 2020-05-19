<?php

/**
 * Description of Usos
 * @author Ing.Douglas
 * @date 03/06/2019
 */
require_once ("../PHPExcel/IOFactory.php");
require_once ("../../ConfigSAP.class.php");

//require_once ("../../Y_DB_MSSQL.class.php");

class Usos {

    function __construct() {
        /*
          try {
          $c = new ConfigSAP();

          $conn = $c->connectToSAP(); // Me conecto solo si hay registros
          $oitm = $conn->GetBusinessObject(20); // Payment Object  OITM
          $RetVal = $oitm->GetByKey("B0001");

          echo "--> <br> $conn ". $RetBoll;

          //echo "<br>". $oItem->ItemName;

          //$oitm->UserFields->Fields->Item("U_USOS")->Value = "Prueba";
          //$err = $oitm->update();
          /*
          if ($err == 0) {

          echo "OK B0001" . date("H:i:s");
          } else {
          $lErrCode = 0;
          $sErrMsg = "";
          $vCmp->GetLastError($lErrCode, $sErrMsg);
          echo "ERROR: (" . $lErrCode . ") " . $sErrMsg;
          }
          } catch (Exception $e) {
          die('Error   "' . $e->getMessage());
          }
         */
        $inputFileName = '../../files/Excel/EstructuraUsosSistema.xlsx';
        try {



            $inputFileType = PHPExcel_IOFactory::identify($inputFileName);
            $objReader = PHPExcel_IOFactory::createReader($inputFileType);
            $objPHPExcel = $objReader->load($inputFileName);
            //  Get worksheet dimensions
            $sheet = $objPHPExcel->getSheet(0);
            $highestRow = $sheet->getHighestRow();
            $highestColumn = $sheet->getHighestColumn();

            $codigos = array();
            $articulos = array();

            //$db = new My();
            //  Loop through each row of the worksheet in turn  $highestRow
            for ($row = 2; $row <= 1329; $row++) {
                //  Read a row of data into an array
                $arr = $sheet->rangeToArray('A' . $row . ':' . $highestColumn . $row, NULL, TRUE, FALSE);

                $Uso = $arr[0][0];
                $Descrip = $arr[0][1];
                $codigo = $arr[0][2];
                $articulos[$codigo] = $Descrip;

                $usos = $codigos[$codigo];

                if ($usos == null) {
                    $codigos[$codigo] = array($Uso);
                    //$usos = $codigos[$codigo];
                    //print_r($usos);
                } else {
                    array_push($usos, $Uso);
                    $codigos[$codigo] = $usos;
                }

                //echo "$codigo-----------$Descrip-----------$Uso <br>";
                //var_dump($usos);
                //echo "--------------------------------------------------------------<br><br><br><br>";
            }

            foreach ($codigos as $codigo => $arr) {
                $art = $articulos[$codigo];
                echo "<b>$codigo:  &nbsp;&nbsp;   $art </b><br>";
                $long = 0;
                $cadena = "";
                foreach ($arr as $value) {
                    
                    $value = trim(str_replace("/", ",", $value));
                    $value = trim(str_replace("/", ",", $value));
                    $value = str_replace("REPASADO,TOALLA", "REPASADOR,TOALLA", $value);
                    $value = str_replace("ETIQUETA O", "", $value);
                    $value = str_replace("CAPAS", "CAPA", $value);
                    $value = str_replace(", Y", ",", $value);
                    $value = str_replace("VESTIDO FORMAL O COCTEL", "VESTIDO FORMAL,COCTEL", $value);
                    $value = str_replace("ALMOHADAS, Y ACCESORIOS DE CUNA", "ALMOHADAS,ACCESORIOS DE CUNA", $value);
                    $value = str_replace("BLUSAS Y VESTIDOS LIVIANOS", "BLUSAS,VESTIDOS LIVIANOS", $value);
                    $cadena .="$value,";
                    //echo "<span style='margin-left:120px;font-size:12px;'><i>$value</i></span><br>";
                }
                $long += strlen($cadena);
                $cadena = substr($cadena, 0,-1);
                echo "<span style='margin-left:80px;font-size:12px;'><i>$cadena</i></span><br>";
                //echo "Longitud:   $long caracteres-------------------------------------<br><br><br><br>";
                if ($long > 255) {
                    echo "DEFCON 5 ALERTA ROJA!<br><br><br>";
                }
            }
        } catch (Exception $e) {
            die('Error loading file "' . pathinfo($inputFileName, PATHINFO_BASENAME) . '": ' . $e->getMessage());
        }
    }

}

new Usos();







