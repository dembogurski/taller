<?php

/**
 * @author Jorge Armando Colina
 * @date 22/08/2017
 */

class HistorialMovimiento {
    function __construct(){
        require_once("../Y_Template.class.php");
        require_once("../Y_DB_MSSQL.class.php");
        require_once("../utils\SapDocTypes.class.php");
        
        $DocType = new SapDocTypes();        
        $t = new Y_Template("HistorialMovimientoArticuloXFecha.html");
        $dt = new SapDocTypes();
        
        $articulo = $_REQUEST['codigo'];
        $color = $_REQUEST['color'];
        $suc = $_REQUEST['suc'];        
        $desde = date('Y-m-d',strtotime($_REQUEST['desde']));
        
        $ddate = date('d',strtotime($desde));
        $month = (int)date('m',strtotime($desde)); //-1;
        $dmonth = ($month == 0)?'12':(($month<10)?'0'.$month:$month);
        $dyear = ($month == 0)?(int)date('Y',strtotime($desde))-1:date('Y',strtotime($desde));
        
        
        $hmonth = ($month+1 > 12)?'01':((($month+1) > 9) ?($month+1):'0'.($month+1));
        $hdyear = (($month+1) > 12) ?(int)date('Y',strtotime($desde))+1:date('Y',strtotime($desde));

        $desde = date('Y-m-d',strtotime("$dyear-$dmonth-$ddate"));
        $hasta = date('Y-m-d',strtotime("$hdyear-$hmonth-$ddate"));

        $t->Set("desde",date('d/m/Y',strtotime($_REQUEST['desde'])));
        //$t->Set("desde",date('d/m/Y',strtotime("$dyear-$dmonth-$ddate")));
        $t->Set("hasta",date('d/m/Y',strtotime("$hdyear-$hmonth-$ddate")));
        // echo "Desde: $desde, Hasta: $hasta";

        $fp = 'No';
        $t->Show("header");
        $ms = new MS();
        
        $Qry = "SELECT i.DocEntry,o.ItemCode, o.DistNumber,i.LocCode, (o.itemName + '-' + c.Name) as ItemName, i.DocType, i.ApplyEntry,o.U_fin_pieza,
        CONVERT(VARCHAR(10),i.DocDate,105) as DocDate, 
		  CASE WHEN ( i.DocType = 17 ) THEN -i1.AllocQty ELSE i1.Quantity END AS Quantity, i.CardCode,i.CardName, 
        CASE WHEN ( i1.Quantity > 0 or  i1.AllocQty < 0 ) THEN 'Entrada' else 'Salida' end as Direction,        
        case i.DocType 
        when 20 then (Select LEFT(t1.DocTime,case len(t1.doctime) when 4 then 2 else 1 end)+':'+right(t1.DocTime,2)+'|'+ ISNULL ( t1.U_Usuario , '' )+'|'+t1.Comments  FROM OPDN t1 where t1.docentry=i.DocEntry) 
        when 18 then (Select LEFT(t2.DocTime,case len(t2.doctime) when 4 then 2 else 1 end)+':'+right(t2.DocTime,2)+'|'+ISNULL ( t2.U_Usuario , '' )+'|'+t2.Comments  FROM OPCH t2 where t2.docentry=i.DocEntry) 
        when 59 then (Select LEFT(t3.DocTime,case len(t3.doctime) when 4 then 2 else 1 end)+':'+right(t3.DocTime,2)+'|'+ISNULL ( t3.U_Usuario , '' )+'|'+t3.Comments  FROM OIGN t3 where t3.docentry=i.DocEntry) 
        when 60 then (Select LEFT(t4.DocTime,case len(t4.doctime) when 4 then 2 else 1 end)+':'+right(t4.DocTime,2)+'|'+ISNULL ( t4.U_Usuario , '' )+'|'+t4.Comments  FROM OIGE t4 where t4.docentry=i.DocEntry)
        when 13 then (Select LEFT(t5.DocTime,case len(t5.doctime) when 4 then 2 else 1 end)+':'+right(t5.DocTime,2)+'|'+ISNULL ( t5.U_vendedor + '|'+'Ticket:' + CAST(t5.U_nro_interno as varchar), '' )  FROM OINV t5 where t5.docentry=i.DocEntry)
        when 67 then (Select LEFT(t6.DocTime,case len(t6.doctime) when 4 then 2 else 1 end)+':'+right(t6.DocTime,2)+'|'+ISNULL ( t6.U_Usuario , '' )+'| Rem: '+CAST(t6.U_Nro_Interno as VARCHAR) FROM OWTR t6 where t6.docentry=i.DocEntry)
        when 14 then (Select LEFT(t7.DocTime,case len(t7.doctime) when 4 then 2 else 1 end)+':'+right(t7.DocTime,2)+'|'+ISNULL ( t7.U_Usuario , '' )+'|'+t7.Comments FROM ORIN t7 where t7.docentry=i.DocEntry)
		  when 17 then (Select LEFT(t8.DocTime,case len(t8.doctime) when 4 then 2 else 1 end)+':'+right(t8.DocTime,2)+'|'+ISNULL ( t8.U_vendedor , '' )+'| Interno: '+CAST(t8.U_Nro_Interno as VARCHAR) FROM ORDR t8 where t8.docentry=i.DocEntry)
		  when 21 then (Select LEFT(t9.DocTime,case len(t9.doctime) when 4 then 2 else 1 end)+':'+right(t9.DocTime,2)+'|'+ISNULL ( t9.U_Usuario , '' )+'|'+t9.Comments FROM ORPD t9 where t9.docentry=i.DocEntry) else NULL end AS 'MovData'
        FROM OBTN o INNER JOIN OITL i ON o.ItemCode = i.ItemCode INNER JOIN ITL1 i1 ON i.LogEntry=i1.LogEntry AND o.SysNumber=i1.SysNumber LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code  WHERE o.ItemCode = '$articulo' and i.LocCode LIKE '$suc' AND o.U_color_comercial LIKE '$color' AND i.CreateDate BETWEEN Convert(varchar(10),'$desde',103) AND DATEADD(DAY,-1,Convert(varchar(10),'$hasta',103)) order by i.CreateDate asc, i.CreateTime asc";   
        
        //echo "$desde, $hasta <br>";
        // echo "$Qry <br>";
        $ms->Query($Qry);
        $first = true;
        $curr_suc;
        $linea = "dos";
        $sucs = array();
        $Total = 0;
        while($ms->NextRecord()){
            $fp = $ms->Record['U_fin_pieza'];
            $hora = ''; 
            $usuario =  ''; 
            $comments = '';
            foreach($ms->Record as $key=>$value){
                switch($key){
                    case 'Quantity':
                        $t->Set($key,number_format((float)($value),2,',','.'));
                        $Total = $Total + (float)($value);
                        break;
                    case 'LocCode':
                        if( $curr_suc !== $value ){
                            $curr_suc = $value;
                            $linea = ($linea == "uno")?"dos":"uno";
                            if(!in_array($value,$sucs)){
                                array_push($sucs,$value);
                            }
                        }
                        $t->Set($key,trim($value));
                        $t->Set("linea",trim($linea));
                        break;
                    case 'DocDate':
                        $fecha = $value;
                        break;
                    case 'Direction':
                        $t->Set('Direction',$value);

                        if($value == 'Salida'){                
                            $t->Set("fondo","#FF6666");                            
                        }else{
                            $t->Set("fondo","#339999");                            
                        } 
                        break;
                    case 'DocEntry':
                    case 'DocType':
                        $t->Set('DocType',$DocType->getType($value));
                        break;
                    case 'MovData':
                        $arr = explode("|",$value);                
                        $hora = $arr[0]; 
                        $usuario =  $arr[1]; 
                        $comments = $arr[2];
                        if(strlen($hora) == 4){            
                            $hora = "0".$hora;   
                        }                        
                        break;
                    default:
                        $t->Set($key,trim($value));
                }                
            }
            $t->Set('MovData',$comments);
            $t->Set('DocDate',$usuario);
            $t->Set('Usuario',$fecha." ".$hora);
            if($first){
                $first = false;
                $t->Show("head");
            }
            $t->Show("data");
        }
        
        $t->Set("QuantityTotal",  number_format($Total,2,',','.'));   
        $t->Show("total");
        $t->Set("sucs", json_encode($sucs));   
        $t->Show("footer");
       // $t->Show("script");
    }
    // Fin de pieza
    private function is_FP($lote){
        require_once("../Y_DB_MySQL.class.php");
        $link = new My();
        $link->Query("SELECT id,usuario,CONCAT(DATE_FORMAT(fecha, '%d-%m-%Y'),' ', hora) AS fecha,suc FROM edicion_lotes WHERE lote = $lote and FP = 'Si' AND e_sap=1 ORDER By id DESC LIMIT 1");
        $link->NextRecord();
        return $link->Record;
    }
}
new HistorialMovimiento();
?>


