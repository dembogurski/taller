<?PHP
ini_set('max_execution_time', 1800);
require_once("../../Y_DB_MySQL.class.php");
require_once("../../Y_DB_MSSQL.class.php");
require_once("../../utils/PHPExcel\IOFactory.php");
require_once("phpmailer-gmail/class.phpmailer.php");
require_once("phpmailer-gmail/class.smtp.php");

/**
 * Schedule Windows Server
 * El primero de cada mes
 * Action
 * Programa/Script
 * powershell
 * Argumento
 * -command &{Invoke-WebRequest -URI http://localhost/marijoa_sap/utils/mail/StockMensual.php}
 */

$reporte = new PHPExcel();
$toExcelFile = array();
$link = new MS();
$query = "SELECT nn.ItmsGrpNam as Grupo, SUBSTRING(nn.ItemName, CHARINDEX('-',nn.ItemName)+1, len(nn.ItemName)) as Articulo,sum(nn.rollos) as rollos ,sum(nn.Stock) as MTS,AvgPrice as Costo,sum(nn.Stock) * AvgPrice as CostoSuma ,WhsCode as Suc from (SELECT o.DistNumber,b.ItmsGrpNam,m.ItemName,m.ItemCode,1 as rollos,cast(round(sum(q.Quantity - ISNULL(q.CommitQty,0)),2) as numeric(20,2)) as Stock,AvgPrice,cast(round(sum(q.Quantity - ISNULL(q.CommitQty,0)),2) as numeric(20,2)) * AvgPrice as CostoTotal ,w.WhsCode FROM OBTN o INNER JOIN OITM m on o.ItemCode=m.ItemCode INNER JOIN OITB b on m.ItmsGrpCod = b.ItmsGrpCod LEFT JOIN OBTQ q ON o.ItemCode = q.ItemCode AND o.SysNumber = q.SysNumber INNER JOIN OBTW w ON o.ItemCode = w.ItemCode AND o.SysNumber = w.SysNumber AND q.WhsCode = w.WhsCode left join [@EXX_COLOR_COMERCIAL] c on o.U_color_comercial = c.Code where w.WhsCode like '%' and U_fin_pieza like '%' group by m.ItemName,m.ItemCode,b.ItmsGrpNam,AvgPrice ,w.WhsCode ,o.DistNumber having( cast(round(sum(q.Quantity - ISNULL(q.CommitQty,0)),2) as numeric(20,2)) > 0 )) as nn group by nn.ItmsGrpNam,nn.ItemName,nn.ItemCode,AvgPrice ,WhsCode ORDER BY nn.ItmsGrpNam asc,nn.ItemName asc ,WhsCode ASC";

$filename = 'StockSuc_'. Date("d-m-Y") .'.xlsx';


$link->Query($query);
while($link->NextRecord()){
   array_push($toExcelFile,$link->Record);
}
$reporte->setActiveSheetIndex(0);

if(count($toExcelFile)>0){
   
   $reporte->getActiveSheet()->fromArray(array_keys(current($toExcelFile)), null, 'A1');
   $reporte->getActiveSheet()->fromArray($toExcelFile, null, 'A2');
   $writer = PHPExcel_IOFactory::createWriter($reporte, 'Excel2007');
   $writer->save("reporteStock/$filename");
   
   $mail = new PHPMailer();
   $mail->IsSMTP();
   $mail->SMTPAuth = true;
   $mail->SMTPSecure = "ssl";
   $mail->Host = "mail.marijoa.com";
   $mail->Port = 465;
   $mail->Username = "sistema@marijoa.com";
   $mail->Password = "rootdba";
   $mail->AddAttachment("reporteStock/$filename", $filename);
   $mail->From = "sistema@marijoa.com";
   $mail->FromName = "Sistema Marijoa";
   $mail->Subject = "Reporte de Stock por Sucursal generado ".Date("d-m-Y");
   $mail->MsgHTML("Reporte de Stock por Sucursal generado ".Date("d-m-Y"));
   $mail->AltBody = "Reporte de Stock por Sucursal generado ".Date("d-m-Y");

   $mail->AddAddress("arnaldoa@corporaciontextil.com.py", "arnaldoa@corporaciontextil.com.py");
   $mail->AddAddress("douglas@corporaciontextil.com.py", "douglas@corporaciontextil.com.py");
   $mail->AddAddress("ariel@corporaciontextil.com.py", "ariel@corporaciontextil.com.py");
   

   $mail->IsHTML($isHTML);

   if (!$mail->Send()) {
      print "Error: " . $mail->ErrorInfo;
   } else {
      print "Mensaje enviado correctamente.../n <br>";
   }
    
}
?>