<?php

/**
 * Description of EntradaMercaderias
 * @author Ing.Douglas
 * @date 18/09/2015
 */
require_once("../Y_DB_MSSQL.class.php");
require_once("../Y_Template.class.php");

class RecepcionMercaderias {

    function __construct() {
        $action = $_REQUEST['action'];
        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }
    }

    function main() {
        $DocEntry = $_POST['DocEntry'];
        $tipo_doc = $_POST['tipo_doc'];
        $t = new Y_Template("RecepcionMercaderias.html");
        $t->Set("DocEntry", $DocEntry);
        $t->Set("tipo_doc", $tipo_doc);

        $ms = new MS();
        // Datos de la compra

        $ms->Query(" SELECT CardName,NumAtCard,U_estado  FROM OPDN  WHERE DocEntry = $DocEntry");
        if ($ms->NumRows() > 0) {
            $ms->NextRecord();
        } else {
            $ms->Query(" SELECT CardName,NumAtCard,U_estado  FROM OPCH  WHERE DocEntry = $DocEntry");
            $ms->NextRecord();
        }
        $CardName = $ms->Record['CardName'];
        $Invoice = $ms->Record['NumAtCard'];
        $U_estado = $ms->Record['U_estado'];
        $t->Set("invoice", $Invoice);
        $t->Set("cardname", $CardName);
        $t->Set("estado", $U_estado);
        if ($U_estado == "En Transito") {
            $t->Set("color", "green");
        } else {
            $t->Set("color", "red");
        }

        // Articulos  Nombres Comerciales

        $filtro_base_type = ' and (BaseType = 20 or BaseType = 18) ';

        //$ms->Query("select distinct ItemCode,Dscription as U_NOMBRE_COM from PDN1 where DocEntry = $DocEntry ORDER BY  Dscription ASC");
        $ms->Query("select p.ItemCode,o.ItemName as U_NOMBRE_COM from PDN1 p inner join OITM o on p.ItemCode=o.ItemCode where p.DocEntry = $DocEntry GROUP BY p.ItemCode,o.ItemName ORDER BY  o.ItemName ASC");
        $articulos = "";

        while ($ms->NextRecord()) {
            $ItemCode = $ms->Record['ItemCode'];
            $descrip = $ms->Record['U_NOMBRE_COM'];
            $arr = explode("-", $descrip);
            $articulo = $arr[1];
            $articulos.="<option value='$ItemCode' class='touch_filter'>$articulo</option>";
        }

        $t->Set("option_articulos", $articulos);



        
        $ms->Query("select  DISTINCT  U_color, Name as Color  from PDN1 p,[@EXX_COLOR_COMERCIAL] c where DocEntry = $DocEntry and p.U_color = c.Code  ORDER BY c.Name ASC");
        $colores_comerciales = "";

        while($ms->NextRecord()){
            $color_com =  $ms->Record['Color'];
            $U_color =  $ms->Record['U_color']; 
            $colores_comerciales.="<option value='$U_color' class='touch_filter'>$color_com</option>";
        }          

        $t->Set("colores_comerciales",$colores_comerciales);
         


        // Proveedor / Mar
        /*
          $ms->Query("SELECT DISTINCT i.U_prov_mar as Mar from OIBT i  where i.BaseNum = $DocEntry   $filtro_base_type    ORDER BY U_prov_mar ASC");
          $mares = "";

          while($ms->NextRecord()){
          $mar =  $ms->Record['Mar'];
          $mares.="'$mar',";
          }
          $mares = substr($mares,0,-1);

          $t->Set("mares","[".$mares."]");
         */


        // Colores de Fabrica o Color description
        /*
          $ms->Query("SELECT DISTINCT U_color_cod_fabric as ColorFabrica from OIBT i  where i.BaseNum = $DocEntry $filtro_base_type  ORDER BY U_color_cod_fabric ASC ");
          $fabric_colors = "";

          while($ms->NextRecord()){
          $cf =  $ms->Record['ColorFabrica'];
          $fabric_colors.="'$cf',";
          }
          $fabric_colors = substr($fabric_colors,0,-1);

          $t->Set("colores_fabrica","[".$fabric_colors."]");
         */


        $t->Show("headers");

        $t->Show("search_bar");

        $t->Show("rolls");
    }

}

function getDesigns() {
    $DocEntry = $_POST['DocEntry'];
    $ItemCode = $_POST['ItemCode'];
    $ms = new MS();

    $ms->Query("SELECT DISTINCT i.U_design as U_design from OIBT i  where i.BaseNum = $DocEntry    ORDER BY i.U_design ASC");
    $designs = "";

    while ($ms->NextRecord()) {
        $design = $ms->Record['U_design'];
        $designs.="'$design',";
    }
    $designs = substr($designs, 0, -1);
}

new RecepcionMercaderias();
?>

