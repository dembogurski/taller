<?php

 set_time_limit(0);

/**
 * Description of UpdatePrecioCostoFactura
 *
 * @author Doglas
 */
class UpdatePrecioCostoFactura {
    
    function __construct() {
         
        require_once("..\Y_DB_MSSQL.class.php");
        require_once("..\Y_DB_MySQL.class.php");
        
              
        $ms =new MS();
        $db =new My();
        $db2 =new My();
        $db->Query("select distinct( d.codigo) as codigo from factura_venta f, fact_vent_det d where f.f_nro = d.f_nro and  precio_costo is null and  f.estado = 'Cerrada'  order by codigo asc");
        
        while($db->NextRecord()){             
            $codigo = $db->Record['codigo'];             
            $ms->Query("SELECT  AvgPrice  FROM OITM o  WHERE  o.ItemCode = '$codigo'");
            $ms->NextRecord();
            $precio_costo = $ms->Record['AvgPrice'];
            $db2->Query("UPDATE fact_vent_det d SET precio_costo = $precio_costo WHERE  precio_costo IS NULL AND codigo = '$codigo'");    
        }
        
        
          
    }
}
new UpdatePrecioCostoFactura();
?>
