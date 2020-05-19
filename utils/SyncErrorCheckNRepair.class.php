<?PHP
require_once '../Y_DB_MySQL.class.php';
require_once '../Y_DB_MSSQL.class.php';
include_once 'tbs_class.php';

class SyncErrorCheckNRepair{
   private $factura;
   private $TBS;
   function __construct(){
   }
   public function start(){
      $this->factura = $this->getSyncErrorTickets();
      $this->TBS = new clsTinyButStrong;
      $this->TBS->LoadTemplate('SyncError.html');
      $this->TBS->MergeBlock('ticket',$this->factura);
      $this->TBS->Show();
   }
   private function getSyncErrorTickets(){
      $link = new My();
      $link->Query("SELECT f_nro, suc, fecha_cierre FROM factura_venta WHERE e_sap=3");
      $facturas = array();
      while($link->NextRecord()){
         $factura = array();
         $f_nro = $link->Record['f_nro'];
         $suc = $link->Record['suc'];
         if(!$this->checkSync($f_nro)){
            $factura['suc'] = $suc;
            $factura['fecha_cierre'] = $link->Record['fecha_cierre'];
            $factura['f_nro'] = $f_nro;
            $factura['det'] = $this->getTicketDet($f_nro,$suc);

            array_push($facturas, $factura);
         }
      }
      $link->Close();
      return $facturas;
   }

   private function getTicketDet($f_nro,$suc){
      $link = new My();
      $link->Query("SELECT lote, codigo, um_prod, cantidad FROM fact_vent_det WHERE f_nro = $f_nro");
      $det = array();
      while($link->NextRecord()){
         $data = $link->Record;
         $data['Stock'] = $this->getStock($data['lote'],$suc);
         $data['update'] = ((float)$data['cantidad'] > (float)$data['Stock'])?'ajustar':'';
         array_push($det, $data);
      }
      $link->Close();
      return $det;
   }

   private function checkSync($f_nro){
      $ms_link = new MS();
      $ms_link->Query("SELECT count(*) AS sync FROM OINV WHERE U_Nro_Interno in ($f_nro)");
      $sync = false;
      if($ms_link->NextRecord()){
         $sync = ((int)$ms_link->Record['sync'] > 0);
      }
      $ms_link->Close();
      return $sync;
   }

   private function getStock($lote,$suc){
      $ms_link = new MS();
      $ms_link->Query("SELECT cast(round(q.Quantity - ISNULL(q.CommitQty,0),2) as numeric(20,2)) as Stock FROM OBTN o inner join OBTW w on o.SysNumber=w.SysNumber and o.ItemCode=w.ItemCode inner join OBTQ q on o.SysNumber=q.SysNumber and w.WhsCode=q.WhsCode and q.ItemCode=w.ItemCode inner join OITM m on o.ItemCode=m.ItemCode LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code where w.WhsCode = '$suc' and  o.DistNumber = '$lote'");
      $Stock = 0.00;
      if($ms_link->NextRecord()){
         $Stock = (float)$ms_link->Record['Stock'];
      }
      $ms_link->Close();
      return $Stock;
   }

   public function enviarTicket(){
      $f_nro = $_POST['f_nro'];
      $link = new My();
      $ok = false;
      $link->Query("UPDATE factura_venta SET e_sap = null WHERE f_nro = $f_nro and e_sap=3");
      if($link->AffectedRows()>0){
         $ok = true;
      }
      $link->Close();
      echo json_encode(array("msj"=>($ok)?"Ok":"error"));
   }
}

$SyncErrorCheckNRepair = new SyncErrorCheckNRepair();

if(isset($_POST['action'])){
     call_user_func_array(array($SyncErrorCheckNRepair,$_POST['action']), array());
 }else{
     $SyncErrorCheckNRepair->start();
 }
?>