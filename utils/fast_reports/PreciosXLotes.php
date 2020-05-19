<?php

/**
 * Description of PreciosXLotes
 * @author Ing.Douglas
 * @date 03/06/2019
 */
set_time_limit(0);

require_once ("../../Y_DB_MySQL.class.php");
require_once ("../../Y_DB_MSSQL.class.php");

class PreciosXLotes {
    function __construct() {
        $db = new My();
        $ms = new MS();
        $lotes_fabrica = "SELECT lote FROM emis_det d WHERE tipo_saldo <> 'Articulo'";
        
        $db->Query($lotes_fabrica);
        
        
        echo "Lote  ;  Stock ;  PrecioCosto  ;  Precio1  ; Minimo<br>";
        
        $i = 1;
        $lotes = "";
        while ($db->NextRecord()){
            $lote = $db->Record['lote'];
            $lotes .= "'$lote',";
            $ix50 = $i % 50;
            
             if($i % 25 == 0){
                 $lotes = substr($lotes,0, -1);
                // echo "$i  -  $ix50  -->   $lotes <br>";
                 
                $batch_price = "  select  o.ItemCode, o.ItemName,BatchNum as Lote, Price,U_desc1,  cast(round(Quantity - ISNULL(t.IsCommited,0),2) as numeric(20,2)) as Stock, 
                AvgPrice as PrecioCosto,
                cast(round(Price - (Price * U_desc1 / 100),0) as  numeric(20,2)) as Precio1,
                AvgPrice + AvgPrice  *  25 / 100 as Minimo,  
                AvgPrice * cast(round(Quantity - ISNULL(t.IsCommited,0),2) as numeric(20,2)) as ValorCosto,
                cast(round(Price - (Price * U_desc1 / 100),0) as  numeric(20,2)) * cast(round(Quantity - ISNULL(t.IsCommited,0),2) as numeric(20,2)) as StockXPV1  

                from OITM o, OIBT t, ITM1 i
                 where o.ItemCode = t.ItemCode and i.ItemCode = t.ItemCode    
                and i.PriceList = 1 and ( Price - (Price * U_desc1 / 100)) <=  (AvgPrice + AvgPrice  *  25 / 100)  
                and Quantity > 0 and U_fin_pieza <> 'Si' and BatchNum in ($lotes)  order by o.ItemName asc  ";


                   

                $ms->Query($batch_price);
                while ($ms->NextRecord()){
                    $ItemCode = $ms->Record['ItemCode'];
                    $BatchNum = $ms->Record['Lote'];
                    $ItemName = $ms->Record['ItemName'];
                    $Stock = $ms->Record['Stock'];
                    $PrecioCosto = number_format($ms->Record['PrecioCosto'],2,',','');    
                    $Precio1 = number_format($ms->Record['Precio1'],2,',','');    
                    $Minimo= number_format($ms->Record['Minimo'],2,',','');    
   
                    echo "$ItemCode;$ItemName;$BatchNum;$Stock;$PrecioCosto;$Precio1;$Minimo<br>";
                } 
                $lotes = "";
            }
             $i++;
        }
       
    }  
}

new PreciosXLotes();
?>