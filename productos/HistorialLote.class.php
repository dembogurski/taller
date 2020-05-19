<?php

require_once("../Y_Template.class.php");
require_once("../Config.class.php");
require_once("../Y_DB_MSSQL.class.php");
require_once("../Functions.class.php");

class HistorialLote {

    function __construct() {
        if (isset($_POST['action'])) {
            call_user_func_array(array(&$this, $_POST['action']), array());
        } else {
            $t = new Y_Template("HistorialLote.html");

            $t->Show("header");
            $c = new Config();
            $host = $c->getNasHost();
            $path = $c->getNasFolder();
            $images_url = "http://$host/$path";
            $suc = $_REQUEST['suc'];
            $t->Set("images_url", $images_url);
            $usuario = $_REQUEST['usuario'];
            
            $fn = new Functions();
            
            $trustee = $fn->chequearPermiso("6.6", $usuario); // Permiso para Cerrar una Nota de Pedido Internacional               
                
            $t->Set("display_audit","none");   
            if($trustee != '---'){
               $t->Set("display_audit","inline");   
            } 

            $t->Show("body");

            require_once("../utils/NumPad.class.php");
            new NumPad();
        }
    }

    function buscarDatosDeCodigo() {

        $ms = new MS();
        $lote = $_POST['lote'];
        $suc = $_POST['suc'];
        $cat = $_POST['categoria'];
        $datos = array();
        $datos['existe'] = $this->existeLote($lote);
        if ($datos['existe']) {
            $sucActual = $this->sucActual($lote);

            /* $query = "SELECT TOP 1 o.SysNumber, o.ItemCode AS Codigo, a.U_NOMBRE_COM +'-'+ c.Name AS Descrip, o.U_ancho AS Ancho, o.U_gramaje AS Gramaje, InvntryUom as UM, w.WhsCode AS Suc, o.U_img AS Img, o.U_padre AS Padre, o.U_ubic as ubic, o.U_color_cod_fabric AS fab_color_cod,cast(round(Price,2) as numeric(20,0)) as Precio,o.U_factor_precio, o.U_desc1 AS Descuento, CAST(ROUND(q.Quantity - ISNULL(q.CommitQty, 0), 2) AS NUMERIC(20, 2)) AS Stock FROM OBTN o INNER JOIN OITM a ON o.ItemCode = a.ItemCode INNER JOIN ITM1 t ON a.ItemCode = t.ItemCode INNER JOIN OBTW w ON o.SysNumber = w.SysNumber AND o.ItemCode = w.ItemCode  INNER JOIN OBTQ q ON o.SysNumber = q.SysNumber AND w.WhsCode = q.WhsCode AND q.ItemCode = w.ItemCode LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code WHERE o.DistNumber = '$lote' AND t.PriceList =$cat ORDER BY CASE w.WhsCode WHEN '$suc' THEN 0 ELSE 100 END,  CAST(ROUND(q.Quantity - ISNULL(q.CommitQty, 0), 2) AS NUMERIC(20, 2)) DESC, w.AbsEntry DESC"; */


            $query = "SELECT o.SysNumber, o.ItemCode AS Codigo, a.U_NOMBRE_COM +'-'+ c.Name AS Descrip, o.U_ancho AS Ancho, o.U_gramaje AS Gramaje, InvntryUom as UM, w.WhsCode AS Suc, o.U_img AS Img, o.U_padre AS Padre, o.U_ubic as ubic, o.U_pallet_no as pallet, o.U_color_cod_fabric AS fab_color_cod,cast(round(Price,2) as numeric(20,0)) as Precio,o.U_factor_precio, o.U_desc1 AS Descuento, CAST(ROUND(q.Quantity - ISNULL(q.CommitQty, 0), 2) AS NUMERIC(20, 2)) AS Stock FROM OBTN o INNER JOIN OITM a ON o.ItemCode = a.ItemCode INNER JOIN ITM1 t ON a.ItemCode = t.ItemCode INNER JOIN OBTW w ON o.SysNumber = w.SysNumber AND o.ItemCode = w.ItemCode  INNER JOIN OBTQ q ON o.SysNumber = q.SysNumber AND w.WhsCode = q.WhsCode AND q.ItemCode = w.ItemCode LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code WHERE o.DistNumber = '$lote' AND w.WhsCode='$suc' AND t.PriceList =$cat";
            $ms->Query($query);

            if ($ms->NumRows() == 0) {
                $query = "SELECT o.SysNumber, o.ItemCode AS Codigo, a.U_NOMBRE_COM +'-'+ c.Name AS Descrip, o.U_ancho AS Ancho, o.U_gramaje AS Gramaje, InvntryUom as UM, w.WhsCode AS Suc, o.U_img AS Img, o.U_padre AS Padre, o.U_ubic as ubic, o.U_pallet_no as pallet, o.U_color_cod_fabric AS fab_color_cod,cast(round(Price,2) as numeric(20,0)) as Precio,o.U_factor_precio, o.U_desc1 AS Descuento, CAST(ROUND(q.Quantity - ISNULL(q.CommitQty, 0), 2) AS NUMERIC(20, 2)) AS Stock FROM OBTN o INNER JOIN OITM a ON o.ItemCode = a.ItemCode INNER JOIN ITM1 t ON a.ItemCode = t.ItemCode INNER JOIN OBTW w ON o.SysNumber = w.SysNumber AND o.ItemCode = w.ItemCode  INNER JOIN OBTQ q ON o.SysNumber = q.SysNumber AND w.WhsCode = q.WhsCode AND q.ItemCode = w.ItemCode LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code WHERE o.DistNumber = '$lote' AND w.WhsCode='$sucActual' AND t.PriceList =$cat";
                $ms->Query($query);
            }

            while ($ms->NextRecord()) {
                $row = array_map('utf8_encode', $ms->Record);
                $datos = array_merge($datos, $row);
                $datos["mensaje"] = "Ok";
            }
        } else {
            $datos["mensaje"] = "Lote $lote no existe!";
        }
        echo json_encode($datos);
    }

    function existeLote($lote_nro) {
        $ms_link = new MS();
        $ms_link->Query("SELECT count(*) AS existe FROM OBTN WHERE DistNumber='$lote_nro'");
        $ms_link->NextRecord();
        return ((int) $ms_link->Record['existe'] > 0) ? true : false;
    }

    function sucActual($lote) {
        $ms_chsuc = new MS();
        $ms_chsuc->Query("SELECT TOP 1 h.LocCode  FROM OBTN o INNER JOIN OITL h ON o.ItemCode = h.ItemCode  INNER JOIN ITL1 hd ON h.LogEntry=hd.LogEntry AND o.SysNumber=hd.SysNumber  WHERE o.DistNumber = $lote  ORDER BY hd.LogEntry DESC");
        $ms_chsuc->NextRecord();
        return $ms_chsuc->Record['LocCode'];
    }

    function fracciones() {
        require_once("../Y_DB_MySQL.class.php");
        $lote = $_POST['lote'];

        $array = array();

        $db = new My();
        $sql = "SELECT usuario,DATE_FORMAT(fecha,'%d-%m-%Y') AS fecha,hora, codigo,lote,cantidad,um,motivo,tara,gramaje,ancho ,kg_desc FROM fraccionamientos WHERE padre = '$lote'";

        $db->Query($sql);
        while ($db->NextRecord()) {
            array_push($array, $db->Record);
        }        
        $db->Close();        
        echo json_encode($array);
    }

}

new HistorialLote();
?>
