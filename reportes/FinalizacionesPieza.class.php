<?php

/**
 * Description of FinalizacionesPieza
 * @author Ing.Douglas
 * @date 29/05/2017
 */
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_DB_MSSQL.class.php");
require_once("../Y_Template.class.php");

set_time_limit(2000);

class FinalizacionesPieza {
    
    function __construct() {
        $action = $_REQUEST['action'];
        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }
    }

    function main() {
        $master_historial = array();
        $TOLERANCIA = 0.02;
        
        $desde = $_REQUEST['desde'];
        $desde_eng = substr($desde, 6, 4) . '-' . substr($desde, 3, 2) . '-' . substr($desde, 0, 2);
        $hasta = $_REQUEST['hasta'];
        $hasta_eng = substr($hasta, 6, 4) . '-' . substr($hasta, 3, 2) . '-' . substr($hasta, 0, 2);
        $usuario = $_REQUEST['usuario'];
        $incluir_desc_0 =   $_REQUEST['incluir_desc_0'];  
        if($usuario == "null"){
            $usuario = "%";
        }
        $user = $_REQUEST['user'];
        $suc = $_REQUEST['select_suc'];

        $t = new Y_Template("FinalizacionesPieza.html");
        $t->Show("header");

        $t->Set("desde", $desde);
        $t->Set("hasta", $hasta);
        $t->Set("desde_eng", $desde_eng);
        $t->Set("hasta_eng", $hasta_eng);
        $t->Set("vendedor", $usuario);
        
        $t->Set("suc_d", $suc);
        $t->Set("user", $user);
        $t->Set("time", date("d-m-Y H:i"));
        
        $t->Show("head");
        $db = new My();
        $dbd = new My();
        $Qry = "SELECT MAX(id) AS id,suc, usuario,codigo,lote,SUM(IF(FP = 'Si',1,0)) AS CantFP,descrip,DATE_FORMAT(fecha,'%d-%m-%Y') AS fecha,hora,FP FROM edicion_lotes WHERE  fecha BETWEEN '$desde_eng' AND '$hasta_eng' AND suc = '$suc' AND (FP = 'Si' OR FP = 'No') AND usuario LIKE '$usuario' AND usuario <> 'Sistema' GROUP BY id,lote  HAVING  SUM(IF(FP = 'Si',1,0)) > 0 ORDER BY fecha ASC, usuario ASC";
        
        //echo $Qry;  die();
        $db->Query($Qry); 
        $t->Show("cabecera");
        
        $count = 0;
        
        while($db->NextRecord()){
            
            $id = $db->Record['id'];
            $usuario= $db->Record['usuario'];
            $codigo= $db->Record['codigo'];
            $lote= $db->Record['lote'];
            $descrip= $db->Record['descrip'];
            $fecha= $db->Record['fecha'];
            $hora= $db->Record['hora'];
            $FP= $db->Record['FP'];
            $CantFP = $db->Record['CantFP'];
            
            if($CantFP > 0){
            
            $t->Set("usuario",$usuario);
            $t->Set("codigo",$codigo);
            $t->Set("usuario",$usuario);
            $t->Set("lote",$lote);
            $t->Set("descrip",$descrip);
            $t->Set("fecha",$fecha);
            $t->Set("hora",$hora);
            $FPA = "No";
            $hist_array = getHistorialLote($codigo,$lote,$suc); 
            
            
            
            $k = 0;
            foreach ($hist_array as $key => $data) {
                $p_costo =  $data['AvgPrice']; 
                $FPA =  $data['FP']; 
                $StockActual =  $data['StockActual']; 
                $Quantity =  $data['Quantity'];  
                $TipoDoc =  $data['TipoDoc']; 
                
                //Buscar en la Tabla mnt_prod Primero
                
                if($FPA == 'Si'){
                   $dbd->Query("SELECT p_cant_compra,p_cant FROM mnt_prod WHERE p_cod = '$lote' and p_local = '$suc'");  
                   if($dbd->NumRows()>0){
                       $dbd->NextRecord();
                       $p_cant_compra = $dbd->Record['p_cant'];
                       if($p_cant_compra > $Quantity){
                           $Quantity = $p_cant_compra;
                       }
                   }
                }
                                
                $toler  = $Quantity * $TOLERANCIA;
                
                                
                $exceso =  round(  0  + $StockActual - $toler,2);
                $descuento = $exceso * $p_costo;
                
                
                $t->Set("tipo_doc",$TipoDoc);
                $t->Set("cant_ini",number_format($Quantity,2,',','.'));   
                $t->Set('tol', number_format($toler,2,',','.')); 
                $t->Set("cant_final",number_format($StockActual,2,',','.'));  
                $t->Set('exceso', number_format($exceso,2,',','.'));  
                $t->Set('costo', number_format($p_costo,0,',','.'));  
                if($exceso <= 0){
                    $descuento = 0;
                }
                if($FPA == 'Si' && $descuento > 0){ 
                   $total +=0+$descuento;
                }
                $t->Set('descuento', number_format($descuento,0,',','.'));  
                
                break; // No interesan los demas datos
            } 
            $flag = true;
            if($incluir_desc_0 == "false"){
                $descuento > 0?$flag = true:$flag = false;
            }else{
                $flag = true;
            }
            if($FPA == 'Si' && $flag ){ 

               $trs = ""; 
               $FinalQuantity = 0;
               foreach ($hist_array as $key => $arr) {
                   $Direction = $arr['Direction'];    
                   $ItemName = $arr['ItemName'];                       
                   $TipoDoc = $arr['TipoDoc'];                       
                   $BaseNum = $arr['BaseNum'];                       
                   $DocDate = $arr['DocDate'];                       
                   $Quantity =number_format($arr['Quantity'],2,',','.') ;                        
                   $CardCode = $arr['CardCode'];  
                   $CardName = $arr['CardName'];
                   $Info = $arr['Info'];   
                   $FinalQuantity += $arr['Quantity'];
                   $user = $arr['User'];   
                   
                   $class = 'entrada';
                   $dir = '&#8658;';
                   if($Direction > 0){
                       $class = 'salida';
                       $dir = '&#8656;';
                   }
                   
                   $trs .= "<tr><td class='$class' >$dir </td><td class='item'>$lote</td><td class='item'>$ItemName</td><td class='item'>$TipoDoc</td><td class='item'>$BaseNum</td><td class='itemc'>$DocDate</td><td class='itemc'>$user</td><td class='num'>$Quantity</td><td class='item'>$CardCode</td><td class='item'>$CardName</td><td class='item'>$Info</td></tr>";                       
                    
               }
               $FinalQuantity =number_format($FinalQuantity,2,',','.') ;                        
               $trs .= "<tr><td colspan='6'></td> <td  class='num' style='font-weight:bolder'>$FinalQuantity</td><td class='item' colspan='3'> </td></tr>";                       
               
               $t->Set("historial_data",$trs);
               $count++; 
               $t->Show("data");            
            }else{
                //echo "Lote: $lote No esta con Fin de Pieza [$FPA]<br>"; Si no esta con Fin de Pieza en SAP no mostrar nada
            }
           }
        }
        $t->Set('count', number_format($count,0,',','.'));  
        $t->Set('total', number_format($total,0,',','.'));  
          
        $t->Show("footer");               
        
    }   
}



function getHistorialLote($codigo,$lote,$suc){
   $ms = new MS(); 
   $my = new My(); 
   
   $sql="SELECT  a.ItemCode, c.DistNumber,q.Quantity as StockActual , o.AvgPrice,c.U_fin_pieza, q.SysNumber, d.WhsCode,A.LocCode, a.DocEntry, a.ItemName, a.DocType,  CONVERT(VARCHAR(10), DocDate, 105) as DocDate,  a.DocNum, b.Quantity,a.CardCode,(CASE WHEN  (b.Quantity) > 0 THEN 0 WHEN (b.Quantity) < 0 THEN 1 ELSE 2 END )	as Direction, a.CardName, 
	case when a.DocType=20 then (Select LEFT(t1.DocTime,case len(t1.doctime) when 4 then 2 else 1 end)+':'+right(t1.DocTime,2)+'|'+ISNULL ( t1.U_Usuario , '' )+'|'+t1.Comments  FROM OPDN t1 where t1.docentry=a.DocEntry) else NULL end AS 'OPDN',
        case when a.DocType=18 then (Select LEFT(t2.DocTime,case len(t2.doctime) when 4 then 2 else 1 end)+':'+right(t2.DocTime,2)+'|'+ISNULL ( t2.U_Usuario , '' )+'|'+t2.Comments  FROM OPCH t2 where t2.docentry=a.DocEntry) else NULL end AS 'OPCH',
        case when a.DocType=59 then (Select LEFT(t3.DocTime,case len(t3.doctime) when 4 then 2 else 1 end)+':'+right(t3.DocTime,2)+'|'+ISNULL ( t3.U_Usuario , '' )+'|'+t3.Comments  FROM OIGN t3 where t3.docentry=a.DocEntry) else NULL end AS 'OIGN',
        case when a.DocType=60 then (Select LEFT(t4.DocTime,case len(t4.doctime) when 4 then 2 else 1 end)+':'+right(t4.DocTime,2)+'|'+ISNULL ( t4.U_Usuario , '' )+'|'+t4.Comments  FROM OIGE t4 where t4.docentry=a.DocEntry) else NULL end AS 'OIGE',
        case when a.DocType=13 then (Select LEFT(t5.DocTime,case len(t5.doctime) when 4 then 2 else 1 end)+':'+right(t5.DocTime,2)+'|'+ISNULL ( t5.U_vendedor + ' Ticket:' + CAST(t5.U_nro_interno as varchar), '' )+'|'+t5.Comments  FROM OINV t5 where t5.docentry=a.DocEntry) else NULL end AS 'OINV',
        case when a.DocType=67 then (Select LEFT(t6.DocTime,case len(t6.doctime) when 4 then 2 else 1 end)+':'+right(t6.DocTime,2)+'|'+ISNULL ( t6.U_Usuario , '' )+'|'+t6.Comments  FROM OWTR t6 where t6.docentry=a.DocEntry) else NULL end AS 'OWTR' 
        FROM OITL a 
        INNER JOIN ITL1 b on a.ItemCode=b.ItemCode and a.LogEntry=b.LogEntry 
        INNER JOIN OBTN c on b.MdAbsEntry=c.AbsEntry 
        INNER JOIN OBTW d on b.MdAbsEntry=d.MdAbsEntry and b.ItemCode = d.ItemCode and b.SysNumber = d.SysNumber
        INNER JOIN OBTQ q on c.SysNumber = q.SysNumber and q.ItemCode = c.ItemCode and d.WhsCode = q.WhsCode  
        INNER JOIN OITM o on o.ItemCode = c.ItemCode 
        where  a.ItemCode = '$codigo' AND c.DistNumber =  '$lote' 				
        and a.LocCode  =  d.WhsCode and d.WhsCode = '$suc'"; 
   
        $master =  array();
        
        $ms->Query($sql);
         
        $U_fin_pieza = "";
        $StockActual = 0;
        $AvgPrice = 1;
        $i = 0;
        while($ms->NextRecord()){
            $i++;
            $ItemCode = $ms->Record['ItemCode'];
            $BatchNum = $ms->Record['DistNumber'];//$ms->Record['BatchNum'];
            $StockActual = $ms->Record['StockActual'];
            $AvgPrice = $ms->Record['AvgPrice'];
            $WhsCode = $ms->Record['WhsCode'];
            $LocCode = $ms->Record['LocCode'];
            $U_fin_pieza = $ms->Record['U_fin_pieza'];
            $ItemName = $ms->Record['ItemName'];
            $BaseType = $ms->Record['DocType']; //$ms->Record['BaseType']; 
            $BaseNum = $ms->Record['DocNum'];//$ms->Record['BaseNum'];
            $DocDate = $ms->Record['DocDate'];
            
            $Quantity = $ms->Record['Quantity'];
            $CardCode = $ms->Record['CardCode'];
            $CardName = $ms->Record['CardName'];
            $Direction = $ms->Record['Direction'];
              
            $OPDN = $ms->Record['OPDN'];
            $OPCH = $ms->Record['OPCH'];
            $OIGN = $ms->Record['OIGN'];
            $OIGE = $ms->Record['OIGE'];
            $OINV = $ms->Record['OINV'];
            $OWTR = $ms->Record['OWTR'];
            
            $fecha = $DocDate; 
            $hora = "";
            $usuario = "";
            if($OPDN != null){
                $arr = explode("|",$OPDN);                
                $hora = $arr[0]; 
                $usuario =  $arr[1]; 
                $comments = $arr[2];
            }else if($OPCH != null){ 
                $arr = explode("|",$OPCH);                
                $hora = $arr[0]; 
                $usuario =  $arr[1]; 
                $comments = $arr[2];
            }else if($OIGN != null){ 
                $arr = explode("|",$OIGN);                
                $hora = $arr[0]; 
                $usuario =  $arr[1]; 
                $comments = $arr[2];
            }else if($OIGE != null){ 
                $arr = explode("|",$OIGE);                
                $hora = $arr[0]; 
                $usuario =  $arr[1]; 
                $comments = $arr[2];
            }else if($OINV != null){ 
                $arr = explode("|",$OINV);                
                $hora = $arr[0]; 
                $usuario =  $arr[1]; 
                $comments = $arr[2];
            }else if($OWTR != null){ 
                $arr = explode("|",$OWTR);                
                $hora = $arr[0]; 
                $usuario =  $arr[1]; 
                $comments = $arr[2];
            }
             
            $arr_tipos = array(
                13 => 'Factura Venta',
                14 => 'NC Clientes',
                15 => 'Entrega',
                16 => 'Devolucion',
                18 => 'Factura Proveedor',
                19 => 'NC Proveedores',
                20 => 'Entrada mercaderia OP',
                21 => 'Devolucion mercaderias',
                59 => 'Entrada mercaderias',
                60 => 'Salida de mercaderias',
                67 => 'Traslado stock');
            
            $TipoDoc = $arr_tipos[$BaseType];
             
            if(strlen($hora) == 4){            
                $hora = "0".$hora;   
            }
            
            $data = array(
                'ItemCode'=>$ItemCode,
                'BatchNum'=>$BatchNum,
                'Suc'=>$LocCode,
                'AvgPrice'=>$AvgPrice,
                'FP'=>$U_fin_pieza,
                'StockActual'=>$StockActual,
                'ItemName'=>$ItemName,
                'BaseType'=>$BaseType,
                'TipoDoc'=>$TipoDoc,
                'Info'=>$comments,
                'BaseNum'=>$BaseNum,
                'DocDate'=>$fecha." ".$hora,
                'Quantity'=>$Quantity,
                'CardCode'=>$CardCode,
                'CardName'=>$CardName,
                'Direction'=>$Direction,
                'User'=>$usuario    
            );
            
            
            $hora = str_replace(":","",$hora);
            
            $master[$i] = $data;           
        } 
        $ventas_no_sinc = "SELECT f.f_nro,descrip ,cantidad,fecha,hora,f.estado,cod_cli,cliente,usuario FROM factura_venta f, fact_vent_det d WHERE f.f_nro = d.f_nro AND f.e_sap IS NULL  AND codigo = '$codigo' AND lote =  '$lote' AND suc = '$suc' ";
        $my->Query($ventas_no_sinc);
        while($my->NextRecord()){
            $data = array(
                'ItemCode'=>$codigo,
                'BatchNum'=>$lote,
                'Suc'=>$suc,
                'AvgPrice'=>$AvgPrice,
                'FP'=>$U_fin_pieza,
                'StockActual'=>$StockActual,
                'ItemName'=>$my->Record['descrip'],
                'BaseType'=>$BaseType,
                'TipoDoc'=>"Factura Venta ".$my->Record['estado'],
                'Info'=>'Venta Pendiente de Sincronizacion',
                'BaseNum'=>$my->Record['f_nro'],
                'DocDate'=>$my->Record['fecha']." ".$my->Record['hora'],
                'Quantity'=>$my->Record['cantidad'],
                'CardCode'=>$my->Record['cod_cli'],
                'CardName'=>$my->Record['cliente'],
                'Direction'=>"1",
                'User'=>$my->Record['usuario']    
            );
              
            $master[$i] = $data;          
        }
        return $master;
}

new FinalizacionesPieza();

?>