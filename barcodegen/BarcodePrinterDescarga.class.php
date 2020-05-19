<?php

/**
 * Description of BarcodePrinterDescarga
 * @author Ing.Douglas
 * @date 02/06/2016
 */
require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_DB_MSSQL.class.php");
require_once("../barcodegen/RadPlusBarcodeNoFont.php");

class BarcodePrinterDescarga {
    function __construct(){
         
        $codes = $_REQUEST['codes'];   //$codes = "22222215,33333315,44444416,5555216,14562412";
        $usuario = $_REQUEST['usuario'];         
        
        $umc = $_REQUEST['umc'];
        $cant_c = $_REQUEST['cant_c'];
        
        $t = new Y_Template("BarcodePrinter.html");
        
        $etiqueta = "etiqueta_6x4";
        $tam = "6x4";
        if(isset($_REQUEST['etiqueta'])){
            $etiqueta = $_REQUEST['etiqueta'];
            $tam = substr($etiqueta,9,30);
        }
        $t->Set("tam",$tam);
        
        $my = new My();
        $my->Query("SELECT suc FROM usuarios WHERE usuario = '$usuario'");
        $my->NextRecord();
        $suc_user = $my->Record['suc'];
         
               
        $lotes = explode(",",$codes);
        foreach ($lotes as $lote) {
          
            $printer = $_REQUEST['printer'];
            $silent_print = $_REQUEST['silent_print'];

            
            $t->Set("printer",$printer);
            $t->Set("silent_print",$silent_print); 

            $t->Show("headers");
            /**
             * @todo split codes  
             */        

            $filename = new RadPlusBarcode();
            $barcode_image = $filename->parseCode($lote,6,3);  
            
            
            $ms = new MS();   
            $ms->Query("select p.ItemCode,p.InvntryUom, o.U_Pais_Origen,i.BaseEntry,p.U_COMPOSICION,i.U_ancho,p.U_NOMBRE_COM,c.Name as ColorComercial, i.U_design as Design, i.U_color_cod_fabric,cast(round(Quantity - ISNULL(i.IsCommited,0),2) as numeric(20,2))as Cant, U_equiv as CantCalc, i.WhsCode as Suc, 
                        cast(round(Price,2) as numeric(20,0))  as Precio
                        FROM OPDN o INNER JOIN OIBT i ON  o.DocEntry = i.BaseEntry AND i.BatchNum = '$lote' INNER JOIN OITM p ON i.ItemCode = p.ItemCode INNER JOIN ITM1 l ON p.ItemCode = l.ItemCode and l.PriceList = 1
						 left join [@EXX_COLOR_COMERCIAL] c on i.U_color_comercial = c.Code");
            
            
            /**
             * @todo Agregar OPCH y / o OIGE  si no existe en OPDN
             */
            
            if($ms->NumRows() > 0){
                $ms->NextRecord();
                
                $suc_lote = $ms->Record['Suc'];
                $um = $ms->Record['InvntryUom'];
                $articulo = $ms->Record['ItemCode'];
                if($um == NULL){
                    echo "Falta definir Unidad de Medida para el Articulo $articulo en SAP.";
                    echo "No se puede imprimir antes de que este definida la Unidad de Medida, contacte con compras...";
                    die();
                }

                $descrip = $ms->Record['U_NOMBRE_COM']."-".$ms->Record['ColorComercial']. "-".$ms->Record['Design'];
                
                if($etiqueta == "etiqueta_10x5"){
                    $descrip .= "-".$ms->Record['U_color_cod_fabric'];
                }
          
                $t->Set("user",$usuario);                
                $t->Set("origen",$ms->Record['U_Pais_Origen']);
                $t->Set("ref",$ms->Record['BaseEntry']);
                $t->Set("composicion",ucwords( strtolower($ms->Record['U_COMPOSICION'])) );
                $t->Set("ancho", number_format($ms->Record['U_ancho'],2,',','.'));       
                $t->Set("suc",$suc_lote);
                //$t->Set("cant",number_format($ms->Record['CantCalc'],2,',','.'));     // No se toma la cantidad calculada
                $t->Set("cant",number_format($cant_c,2,',','.'));  
                //$t->Set("descrip",ucwords( strtolower( $ms->Record['U_NOMBRE_COM']." - ".$ms->Record['ColorComercial'])));
                $t->Set("descrip",ucwords( strtolower( $descrip )));
                $t->Set("precio",number_format($ms->Record['Precio'],0,',','.'));       
                $t->Set("articulo",$articulo );
                $t->Set("unid",$umc );
                
                
                $t->Set("barcode_image",$barcode_image);
                $t->Set("lote",$lote);     

                $t->Show($etiqueta);
                                 
                $reg_impresion = "INSERT INTO  reg_impresion(usuario, lote, suc_user, suc_lote,fecha, obs)
                VALUES ('$usuario', '$lote', '$suc_user', '$suc_lote',current_timestamp, 'Impresion en Descarga');";
                $my->Query($reg_impresion);
            }else{
                echo "Error Codigo de Lote: $lote no existe...";
            }
        
        } 
     }
}

new BarcodePrinterDescarga();

?>
