<?PHP
require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_DB_MSSQL.class.php");

class VentasPorSectorArticulos{
   private $t;
   private $suc;
   private $target_suc;
   private $usuario;   
   private $sector;   
   private $articulo;
   private $group_suc;
   private $extra_data;
   private $extra_select_data;
   private $extra_order;
   private $group_color;
   private $extra_select_order;
   private $group_select_color;
   private $group_by;
   private $stockCrit01;
   private $stockCrit02;
   private $estado_venta;
   private $fin_pieza;
   private $val01_1;
   private $val01_2;
   private $mostrar_costo;
   private $lotes;
   private $subFilters;
   private $terminacion;
        
    
   function __construct(){
      $link = new MS();
      $infoRolloStock01 = '';
      $infoRolloStock02 = '';
      $filtroStock01 = '';
      $filtroStockInf01 = '';
      $filtroStock02 = '';
      $filtroStockInf02 = '';
      $filtro_articulos='';
      $filtro_estado_venta='';
      $cri02_visibility='';
      $this->t = new Y_Template("StockXSectorXArticulo.html");
      $this->suc = $_GET['suc'];
      $this->target_suc = $_GET['select_suc'];
      $this->usuario = $_GET['user'];
      $this->sector = $_GET['select_sector'];
      $this->articulo = $_GET['select_articulos'];
      $this->extra_data = '';
      $this->extra_select_data = '';
      $this->extra_order = '';
      $this->fin_pieza = $_GET['fin_pieza'];
      $this->estado_venta = $_GET['estado_venta'];
      $this->stockCrit01 = $_GET['stockCrit_01'];
      $this->val01_1 = $_GET['val01_1'];
      $this->val01_2 = $_GET['val01_2'];
      $this->stockCrit02 = $_GET['stockCrit_02'];
      $this->val02_1 = $_GET['val02_1'];
      $this->val02_2 = $_GET['val02_2'];
      $this->mostrar_costo  = $_GET['mostrar_costo'];
      $this->terminacion  = (strlen(trim($_GET['terminacion'])) < 3 && is_numeric(trim($_GET['terminacion'])))?trim($_GET['terminacion']):'%';
      

      $this->t->Set("filters",json_encode($_GET));
      
      if($this->mostrar_costo == 'true'){
         $this->t->Set("display_costo","");
      }else{
         $this->t->Set("display_costo","style='display:none'"); 
      }
      $lotes09 = '';
      if($this->target_suc == '09'){
            $my = new My();
            $my->Query("SELECT lote FROM fraccionamientos WHERE suc_destino='09' AND codigo LIKE '$this->articulo' UNION SELECT distinct lote FROM orden_procesamiento o WHERE codigo LIKE '$this->articulo' AND suc='09' AND o.estado = 'Pendiente' group by o.lote");
            $lts = array();
            while($my->NextRecord()){
                  array_push($lts, $my->Record['lote']);
            }
            $lotes09 = implode(',',$lts);
            $filtro_articulos = " o.DistNumber IN ($lotes09) ";
            $this->target_suc = '00';
      }else{
            // Filtro Articulos            
            if($this->articulo === '%' ){
               // Extrae solo los codigos de articulos
               $filtro_articulos = "o.ItemCode in (".trim(implode(',',array_map(array($this,'comillas'),array_keys( $this->getArticulosInGrupo($this->sector)))),',').')';
            }else{
               $filtro_articulos = "o.ItemCode like '$this->articulo'";
            }
      }
      // Filtro Stock 01
      if($this->stockCrit01 === 'Entre'){
            $infoRolloStock01 = "nn.Stock BETWEEN $this->val01_1 AND $this->val01_2";
            $filtroStock01 = "(cast(round(sum(q.Quantity - ISNULL(q.CommitQty,0)),2) as numeric(20,2)) BETWEEN $this->val01_1 AND $this->val01_2)";
            $filtroStockInf01 = " $this->stockCrit01 $this->val01_1 m , $this->val01_2 m ";
      }else{
            $infoRolloStock01 = "nn.Stock $this->stockCrit01 $this->val01_1";
            $filtroStock01 = "(cast(round(sum(q.Quantity - ISNULL(q.CommitQty,0)),2) as numeric(20,2)) $this->stockCrit01 $this->val01_1)";
            $filtroStockInf01 = " $this->stockCrit01 $this->val01_1 ";
      }
      // Filtro Stock 02
      if($this->stockCrit02 === 'Entre'){
            $infoRolloStock02 = "nn.Stock BETWEEN $this->val02_1 AND $this->val02_2";
            $filtroStock02 = "(cast(round(sum(q.Quantity - ISNULL(q.CommitQty,0)),2) as numeric(20,2)) BETWEEN $this->val02_1 and $this->val02_2)";
            $filtroStockInf02 = " $this->stockCrit02 $this->val02_1 m , $this->val02_2 m ";
      }else{
            $infoRolloStock02 = "nn.Stock $this->stockCrit02 $this->val02_1";
            $filtroStock02 = "(cast(round(sum(q.Quantity - ISNULL(q.CommitQty,0)),2) as numeric(20,2)) $this->stockCrit02 $this->val02_1)";
            $filtroStockInf02 = " $this->stockCrit02 $this->val02_1 ";
      }
      // Filtro Estado de venta
      if(strlen($this->estado_venta) != 0){
            $estados = implode(',',array_map(function($st){return "'$st'";},explode(',',$this->estado_venta)));
            $filtro_estado_venta = " AND U_estado_venta in ($estados) ";
      }
      // Agrupar
      if($_GET['group_suc'] == 'true'){
         $this->extra_data .= ',w.WhsCode';
         $this->extra_select_data .= ',WhsCode';

         $this->extra_order .= ',WhsCode ASC';
         $this->group_suc = ',w.WhsCode';
         $this->group_select_suc = ',WhsCode';
      }else{
         $this->t->Set('suc_visibility',"style='display:none'");
      }
      if($_GET['group_color'] == 'true'){
         $this->extra_data .= ',c.Code,c.Name';
         $this->extra_select_data .= ',Name';

         $this->extra_order .= ',Name ASC';
         $this->group_color = ',c.Code,c.Name';
         $this->group_select_color = ',Code,Name';
      }else{
         $this->t->Set('color_visibility',"style='display:none'");
      }
      if($_GET['group_design'] == 'true'){
         $this->extra_data .= ',U_design';
         $this->extra_select_data .= ',U_design'; 
         $this->extra_order .= ',U_design ASC';
         $this->group_design = ',U_design';
         $this->group_select_design = ',U_design';         
      }else{
         $this->t->Set('design_visibility',"style='display:none'");
      }
      // PopUp
      if($_GET['popup'] == 'true'){
            $this->lotes = "DistNumber,";
            if(isset($_GET['subFilters'])){
                  $sf = json_decode($_GET['subFilters']);
                  foreach($sf as $key=>$value){
                        if($key == 'type'){
                              if($value == 'C1'){
                                    $infoRolloStock02 = $infoRolloStock01;
                                    $filtroStock02 = $filtroStock01;
                                    $filtroStockInf02 = $filtroStockInf01;
                              }else{
                                    $infoRolloStock01 = $infoRolloStock02;
                                    $filtroStock01 = $filtroStock02;
                                    $filtroStockInf01 = $filtroStockInf02;
                              }
                        }else{
                              $this->subFilters .= " AND $key='$value'";
                        }
                  }
            }
            $this->t->Set('rollos_visibility',"style='display:none'");
      }else{
         $this->t->Set('lote_visibility',"style='display:none'");
      }
      if($infoRolloStock01 === $infoRolloStock02){
            $cri02_visibility = "style='display:none'";
      }

      // Procesar
      $this->t->Show('header');
      $this->t->Set('user',$this->usuario);
      $this->t->Set('time',date('d-m-Y H:i'));
      $this->t->Set('desde',$this->r_desde);
      $this->t->Set('hasta',$this->r_hasta);
      $this->t->Set('target_suc',$this->target_suc);
      $this->t->Set('sector',($this->sector == '%')?'%':$this->getSectores($this->sector));
      $this->t->Set('articulo',$this->articulo);
      $this->t->Set('filtroStock01',$filtroStockInf01);
      $this->t->Set('filtroStock02',$filtroStockInf02);
      $this->t->Set('estado_venta',$this->estado_venta);
      $this->t->Set('cri02_visibility',$cri02_visibility);
      
      $this->t->Show('general_head');
      $this->t->Show('table_suc_head');
      
      if($this->mostrar_costo == 'true'){
          $Price_as_Precio1_U_desc1 = ",Price as Precio1, U_desc1";
          $Precio1_U_desc1 = ",Precio1, U_desc1 ";
      }else{
         $Price_as_Precio1_U_desc1 = " ";
         $Precio1_U_desc1 = " ";
      }

   
      $sub_query = "SELECT o.DistNumber,b.ItmsGrpNam,m.ItemName,m.ItemCode,1 as rollos,cast(round(sum(q.Quantity - ISNULL(q.CommitQty,0)),2) as numeric(20,2)) as Stock,AvgPrice,"
              . "cast(round(sum(q.Quantity - ISNULL(q.CommitQty,0)),2) as numeric(20,2)) * AvgPrice as CostoTotal  $Price_as_Precio1_U_desc1    $this->extra_data "
              . "FROM OBTN o INNER JOIN OITM m on o.ItemCode=m.ItemCode INNER JOIN OITB b on m.ItmsGrpCod = b.ItmsGrpCod "
              . "LEFT JOIN OBTQ q ON o.ItemCode = q.ItemCode AND o.SysNumber = q.SysNumber "
              . "INNER JOIN OBTW w ON o.ItemCode = w.ItemCode AND o.SysNumber = w.SysNumber AND q.WhsCode = w.WhsCode "
              . "left join [@EXX_COLOR_COMERCIAL] c on o.U_color_comercial = c.Code "
              . "inner join ITM1 it on o.ItemCode = it.ItemCode and it.PriceList = 1 "
              . "where w.WhsCode like '$this->target_suc' "
              . "AND right(o.DistNumber,2) like '$this->terminacion' and U_fin_pieza like '$this->fin_pieza' and $filtro_articulos $filtro_estado_venta $this->subFilters "
              . "group by m.ItemName,m.ItemCode,b.ItmsGrpNam,AvgPrice,Price, U_desc1  $this->group_suc $this->group_color $this->group_design ,o.DistNumber HAVING ($filtroStock01 OR $filtroStock02)";
      
      
      $query = "SELECT $this->lotes nn.ItmsGrpNam,nn.ItemName,nn.ItemCode,SUM(CASE WHEN $infoRolloStock01 THEN 1 ELSE 0 END) AS rollosC1,"
              . "SUM(CASE WHEN $infoRolloStock01 THEN Stock ELSE 0 END) AS StockC1,SUM(CASE WHEN $infoRolloStock02 THEN 1 ELSE 0 END) AS rollosC2,"
              . "SUM(CASE WHEN $infoRolloStock02 THEN Stock ELSE 0 END) AS StockC2,AvgPrice,sum(nn.Stock) * AvgPrice as CostoTotal  $Precio1_U_desc1  $this->group_select_suc "
              . "$this->group_select_color $this->group_select_design from "
              . "($sub_query) as nn "
              . "group by $this->lotes nn.ItmsGrpNam,nn.ItemName,nn.ItemCode,AvgPrice  $Precio1_U_desc1  $this->group_select_suc $this->group_select_color $this->group_select_design "
              . "ORDER BY nn.ItmsGrpNam asc,nn.ItemName asc $this->extra_order";
       
      $link->Query($query);
      
      /*echo $query;
      
      echo "Aplicando mejoras al reporte... ";
      die(); */

      if($link->NumRows()>0){
         $sumMts01 = 0;
         $sumRollos01 = 0;
         $sumMts02 = 0;
         $sumRollos02 = 0;
         $sumCostoTotal = 0;
         $current_item = '';
         $current_color = '';
         $sumCostoTotalP1 = 0;
         
         $suc_group = array();
         while($link->NextRecord()){            
            if($current_item==='')$current_item =  $link->Record['ItemCode'];
            if($current_color==='' && $this->group_color )$current_color =  $link->Record['Name'];
            $StockC1 = 0 + (float)$link->Record['StockC1'];
            $sumMts01 += (float)$link->Record['StockC1'];
            $sumRollos01 += 0 + (float)$link->Record['rollosC1'];
            $sumMts02 +=  0 + (float)$link->Record['StockC2'];
            $sumRollos02 += 0 + (float)$link->Record['rollosC2'];
            $sumCostoTotal += (float)$link->Record['CostoTotal'];
            
            $Precio1 = (float)$link->Record['Precio1'];
            $U_desc1 = (float)$link->Record['U_desc1'];
            
            $Precio1Neto = ($Precio1 - (($Precio1 * $U_desc1) / 100) );
            $CostoTotalP1 =   $Precio1Neto * $StockC1;
            
            $sumCostoTotalP1 +=0+   $CostoTotalP1;
            $this->t->Set("CostoTotalP1",number_format($CostoTotalP1, 2, ',', '.'));
            $this->t->Set("Precio1Neto",number_format($Precio1Neto, 2, ',', '.'));
            $this->t->Set("sumCostoTotalP1",number_format($sumCostoTotalP1, 2, ',', '.'));
            
            foreach($link->Record as $key=>$value){
               if($key == 'Stock' || $key == 'AvgPrice' || $key == 'CostoTotal' || $key == 'Precio1' || $key == 'U_desc1'){
                  $this->t->Set($key,number_format($value , 2, ',', '.'));
               }else{
                  $this->t->Set($key,$value);
               }
            }
            $this->t->Show('table_suc_data');
         }

      }
      $porcentajes =0;// $this->porcentajeFacturas($this->desde,$this->hasta,$this->target_suc,$filtro_articulos);
      //print_r($this->porcentajeFacturas($this->desde,$this->hasta,$this->target_suc,$filtro_articulos));
      $this->t->Set('pTotalMetros',number_format($porcentajes['difCount'], 2, ',', '.'));
      $this->t->Set('pTotalMov',number_format($porcentajes['difSumFacts'], 2, ',', '.'));
      $this->t->Set('sumRollos01',number_format($sumRollos01, 0, ',', '.'));
      $this->t->Set('sumMts01',number_format($sumMts01, 2, ',', '.'));
      $this->t->Set('sumRollos02',number_format($sumRollos02, 0, ',', '.'));
      $this->t->Set('sumMts02',number_format($sumMts02, 2, ',', '.'));
      $this->t->Set('TotalCosto',number_format($sumCostoTotal, 2, ',', '.'));
      $this->t->Show('footer');
   }

   function porcentajeFacturas($desde,$hasta,$suc,$filtro_articulos){
      $link = new My();
      $link1 = new My();
      $countFacts = 0;
      $sumFacts = 0;
      $dtCountFacts = 0;
      $dtSumFacts = 0;
      $data = array();

      $link->Query("SELECT sum(d.cantidad) sumMts,sum(d.subtotal) as sumFacts from factura_venta f inner join fact_vent_det d using(f_nro)
where f.estado='Cerrada' AND f.fecha_cierre BETWEEN '$desde' AND '$hasta' AND f.suc LIKE '$suc'");
   
      if($link->NumRows()>0){
         $link->NextRecord();
         $totalMts = (float)$link->Record['sumMts'];
         $totalMov = (float)$link->Record['sumFacts'];
      }

      $link1->Query("SELECT sum(d.cantidad) sumMts,sum(d.subtotal) as sumFacts from factura_venta f inner join fact_vent_det d using(f_nro)
where $filtro_articulos AND f.estado='Cerrada' AND f.fecha_cierre BETWEEN '$desde' AND '$hasta' AND f.suc LIKE '$suc'");

      if($link1->NumRows()>0){
         $link1->NextRecord();
         $totalMtsFiltered = (float)$link1->Record['sumMts'];
         $totalMovFiltered = (float)$link1->Record['sumFacts'];
      }

      
      $difCount = ($totalMts > 0)?(($totalMtsFiltered*100)/$totalMts):0.00;
      $difSumFacts = ($totalMov > 0)?(($totalMovFiltered*100)/$totalMov):0.00;
      $data['difCount'] = $difCount;
      $data['difSumFacts'] = $difSumFacts;
      return $data;
   }

   function comillas($st){
      return "'".$st."'";
   }

   function getArticulosInGrupo($grupo){
      $link = new MS();
      $articulos = array();
      $link->Query("SELECT ItemCode,LTRIM(SUBSTRING(ItemName,CHARINDEX('-',ItemName)+1,LEN(ItemName))) as ArticuloNombre FROM OITM where ItmsGrpCod like '$grupo' and ItmsGrpCod not in (107) order by ArticuloNombre asc");//106:INSUMOS, 107:ACTIVOS   
      while($link->NextRecord()){
         $articulos[$link->Record['ItemCode']] = $link->Record['ArticuloNombre'];
      }
      return $articulos;
   }

   private function flipDate($date,$separator){
      $date = explode($separator,$date);
      return $date[2].'-'.$date[1].'-'.$date[0];
   }

   function getSectores($code){
      $ms = new MS();
      $ms->Query("SELECT ItmsGrpNam FROM OITB WHERE ItmsGrpCod = $code");
      $ms->NextRecord(); 
      return $ms->Record['ItmsGrpNam'];
   }
}

new VentasPorSectorArticulos();
?>