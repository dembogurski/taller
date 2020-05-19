<?php

/**
 * Description of MercaderiasEnTransito
 * @author Ing.Douglas
 * @date 19/09/2015
 */

require_once("../Y_DB_MSSQL.class.php");
require_once("../Y_Template.class.php");
                   

class MercaderiasEnTransito {
   function __construct(){
       $estado = $_POST['estado'];
       $t = new Y_Template("MercaderiasEnTransito.html");
       $t->Show("headers");
       $t->Show("head");
       $this->listar("OPDN",$t,$estado);
       $this->listar("OPCH",$t,$estado);
       $t->Show("foot");       
   } 
   function listar($tipo_doc_sap,$t,$estado){
       $ms = new MS();       
       $ms->Query("select DocEntry,U_SUC as Suc, CardCode,LicTradNum,CardName,NumAtCard,CONVERT(VARCHAR(10), DocDate, 103) DocDate,CONVERT(VARCHAR(10), DocDueDate, 103) DocDueDate,DocTotal,DocCur,DocTotalFC, Comments  from $tipo_doc_sap where U_estado = '$estado'"); // 
         
       while($ms->NextRecord()){
           $DocEntry = $ms->Record['DocEntry'];
           $Suc = $ms->Record['Suc'];
           $CardCode = $ms->Record['CardCode'];
           $LicTradNum = $ms->Record['LicTradNum'];
           $NumAtCard = $ms->Record['NumAtCard'];           
           $CardName = $ms->Record['CardName'];
           $DocDate = $ms->Record['DocDate'];
           $DocDueDate = $ms->Record['DocDueDate'];
           $DocTotal = $ms->Record['DocTotal'];
           $DocCur = $ms->Record['DocCur'];
           $DocTotalFC = $ms->Record['DocTotalFC'];
           $Comments = $ms->Record['Comments'];
           
           $t->Set("DocEntry",$DocEntry);
           $t->Set("Suc",$Suc);
           $t->Set("CardCode",$CardCode);
           $t->Set("LicTradNum",$LicTradNum);
           $t->Set("NumAdCard",$NumAtCard); 
           $t->Set("CardName",$CardName);
           $t->Set("DocDate",$DocDate);
           $t->Set("DocDueDate",$DocDueDate);
           $t->Set("DocCur",$DocCur);
           $t->Set("DocTotal", number_format($DocTotal,2,',','.'));    
           $t->Set("DocCur",$DocCur);
           $t->Set("DocTotalFC", number_format($DocTotalFC,2,',','.'));    
           $t->Set("Comments",$Comments);
           $t->Set("CommentsShort",  substr( $Comments,0,20)."...");
           $t->Set("tipo",$tipo_doc_sap);
             
           $t->Show("line");
       } 
       
   }
}
new MercaderiasEnTransito();

?>
