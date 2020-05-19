<?php
session_start();

require_once("../Config.class.php");
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_DB_MSSQL.class.php");
require_once("../Y_Template.class.php");

class GaleriaImagenes {
   private $t;
   private $c;   
   private $host;
   private $images_url;

   function __construct(){         
        $this->t = new Y_Template("GaleriaImagenes.html");        
        $this->c = new Config();        
        $this->host = ($_SERVER['HTTP_HOST'] == '190.128.150.70:2220' || $_SERVER['HTTP_HOST'] == '190.128.150.70')?'190.128.150.70:2252':'192.168.2.252';        
        $this->images_url = "http://$this->host/prod_images/";
   }

   public function start(){
      $this->showHeader();
      $this->showFooter();
   }

   public function showHeader(){
      $this->t->Set("images_url", $this->images_url);
      $this->t->Show("header");
      $this->t->Show("body");
   }

   public function showFooter(){
      $this->t->Show("footer");
   }

   public function getColorHits($search){
      $res = array();
      $ms = new MS();           
      $ms->Query("SELECT Code,Name,U_rgb FROM [@EXX_COLOR_COMERCIAL] WHERE Name LIKE '$search%' ORDER BY Name asc");
      while($ms->NextRecord()){
         array_push($res,$ms->Record);
      }
      echo json_encode($res);
      $ms->Close();
   }

   // Devuelve sugerencias de nombre comercial
   public function getNCHits($search){
      $res = array();
      $ms = new MS();
      $search_param = is_numeric(trim($search))?"o.DistNumber = '" . trim($search) . "'":"i.U_NOMBRE_COM LIKE '%" . trim($search) . "%'";           
      $ms->Query("SELECT t.ItmsGrpNam as sector,i.U_NOMBRE_COM as nombreComercial FROM OITM i INNER JOIN OITB t ON  i.ItmsGrpCod = t.ItmsGrpCod INNER JOIN OBTN o ON i.ItemCode = o.ItemCode WHERE $search_param  GROUP BY t.ItmsGrpNam,i.U_NOMBRE_COM ORDER BY t.ItmsGrpNam ASC,i.U_NOMBRE_COM ASC");
      while($ms->NextRecord()){
         array_push($res,array_map('utf8_encode',$ms->Record));
      }
      echo json_encode($res);
      $ms->Close();
   }

   // Lista de sucursales en las que existen los productos
   public function getSucXPod($prod,$stock){
       $res = array();
       $ms = new MS();
       $sucs = array();
       $stock = ((int)$stock>=0)?" AND (q.Quantity - ISNULL(q.CommitQty,0))>$stock ":'';
       $query = "SELECT WhsCode AS Suc FROM OITM i INNER JOIN OITB t ON  i.ItmsGrpCod = t.ItmsGrpCod INNER JOIN OBTN o ON i.ItemCode = o.ItemCode LEFT JOIN	OBTQ q ON o.ItemCode = q.ItemCode AND o.SysNumber = q.SysNumber inner JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code INNER JOIN ITM1 l on i.ItemCode = l.ItemCode AND PriceList = 1 WHERE o.U_fin_pieza <> 'Si' and i.U_NOMBRE_COM = '$prod' $stock group by WhsCode  ORDER BY WhsCode asc";
       $ms->Query($query);
       while($ms->NextRecord()){
           array_push($sucs,$ms->Record['Suc']);
       }
       echo count($sucs)>0?json_encode($sucs):'{"error":"No se obtuvo resultados"}';
   }
   
   // Lista de colores por sucursales y articulo
   public function getColorXPodXSuc($prod,$suc,$stock){
       $res = array();
       $ms = new MS();
       $colores = array();
       $stock = ((int)$stock>=0)?" AND (q.Quantity - ISNULL(q.CommitQty,0))>$stock ":'';
       $query = "SELECT c.Code,c.Name FROM OITM i INNER JOIN OITB t ON  i.ItmsGrpCod = t.ItmsGrpCod INNER JOIN OBTN o ON i.ItemCode = o.ItemCode LEFT JOIN	OBTQ q ON o.ItemCode = q.ItemCode AND o.SysNumber = q.SysNumber inner JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code INNER JOIN ITM1 l on i.ItemCode = l.ItemCode AND PriceList = 1 WHERE o.U_fin_pieza <> 'Si' and i.U_NOMBRE_COM = '$prod' and WhsCode like '$suc' $stock group by c.Code,c.Name  ORDER BY c.Name asc";
       $ms->Query($query);
       
       while($ms->NextRecord()){
           $colores[$ms->Record['Code']] = utf8_encode($ms->Record['Name']);
       }
       echo count($colores)>0?json_encode($colores):'{"error":"No se obtuvo resultados"}';
   }

   // Listar diseños segun criterios anteriores 
   public function getDisenoXProdXSucXColor($prod,$suc,$color,$stock,$fdp){
        $res = array();
        $ms = new MS();
        $disenos = array();
        $stock = ((int)$stock>=0)?" AND (q.Quantity - ISNULL(q.CommitQty,0))>$stock ":'';
        $fdp_filter = ($fdp == 'true')?"like '%'":"<> 'Si'";

        $query = "SELECT ISNULL(NULLIF(U_design,''),'No definido') AS U_design, ISNULL(d.Code,'No definido') as Code FROM OBTN o INNER JOIN OITM a ON o.ItemCode=a.ItemCode LEFT JOIN	OBTQ q ON o.ItemCode = q.ItemCode AND o.SysNumber = q.SysNumber INNER JOIN	OBTW w ON o.ItemCode = w.ItemCode AND o.SysNumber = w.SysNumber AND q.WhsCode = w.WhsCode LEFT JOIN [@DESIGN_PATTERNS] d ON o.U_design = d.Name WHERE o.U_fin_pieza $fdp_filter AND a.U_NOMBRE_COM LIKE '$prod' AND o.U_color_comercial LIKE '$color' AND w.WhsCode LIKE '$suc' $stock GROUP BY ISNULL(NULLIF(U_design,''),'No definido'), ISNULL(d.Code,'No definido') ORDER BY U_design ASC";
        //echo $query;
        $ms->Query($query);
        
        while($ms->NextRecord()){
            $disenos[$ms->Record['Code']] = utf8_encode($ms->Record['U_design']);
        }
        echo count($disenos)>0?json_encode($disenos):'{"error":"No se obtuvo resultados"}';
   }
   // Lista de de productos
   public function getProd($comName,$suc,$color,$diseno,$stock,$fdp,$term){
      $res = array();
      $ms = new MS();  
      $filtroDiseno = "";
      switch($diseno){
          case 'No definido':
            $filtroDiseno = " AND d.Code IS NULL ";
            break;
          case '%':
            $filtroDiseno = "";
            break;
          default:
            $filtroDiseno = " AND d.Code LIKE '$diseno' ";
      }
      $fdp_filter = ($fdp == 'true')?"like '%'":"<> 'Si'";
      $term_filter = ($term == '%')?"":" AND o.DistNumber like '%$term' ";
      
      $stock = ((int)$stock>=0)?" AND (q.Quantity - ISNULL(q.CommitQty,0))>$stock ":'';
      $query = "SELECT o.ItemCode,o.DistNumber as Lote,o.U_padre as Padre,ItmsGrpNam as Sector,o.U_design as Disenho,i.U_NOMBRE_COM as NombreComercial, cast(round(q.Quantity - ISNULL(q.CommitQty,0),2) as numeric(20,2)) as Stock,o.U_ancho as Ancho,c.Name as Color,c.Code as ColorCode,Status,WhsCode AS Suc,U_img as Img, Price as Precio, o.U_ubic as Ubic, o.U_color_cod_fabric as CodigoColorFabrica, U_desc1 as Desc1, U_gramaje as Gramaje, o.U_fin_pieza as fdp, i.U_COMPOSICION as composicion FROM OITM i INNER JOIN OITB t ON  i.ItmsGrpCod = t.ItmsGrpCod INNER JOIN OBTN o ON i.ItemCode = o.ItemCode LEFT JOIN	OBTQ q ON o.ItemCode = q.ItemCode AND o.SysNumber = q.SysNumber inner JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code LEFT JOIN [@DESIGN_PATTERNS] d ON o.U_design = d.Name INNER JOIN ITM1 l on i.ItemCode = l.ItemCode AND PriceList = 1 WHERE o.U_fin_pieza $fdp_filter $filtroDiseno  $term_filter  and i.U_NOMBRE_COM = '$comName' and whsCode like '$suc' and c.Code like '$color' $stock  ORDER BY i.U_NOMBRE_COM ASC,c.Name ASC,Stock DESC";
      $ms->Query($query);
      while($ms->NextRecord()){
          $fila = array_map('utf8_encode',$ms->Record);
          $fila['Reserva'] = $this->enReserva($fila['Lote']);
          array_push($res,$fila);
      } 
      //echo '{"query":"'.$query.'"}';     
      echo json_encode($res);
      $ms->Close();
   }
   // Verificar reserva / asignacion
   private function enReserva($lote){
       $my = new My();
       $asinacion = array();
       $my->Query("SELECT o.suc, c.nombre, cantidad,fecha,o.usuario, o.estado FROM orden_procesamiento o , clientes c WHERE o.cod_cli = c.cod_cli AND  lote = '$lote'; ");
       while($my->NextRecord()){ 
           array_push($asinacion,$my->Record);           
       }
       return $asinacion;
   }

   public function enReservaJSON($lote){
      echo json_encode($this->enReserva($lote));
   }
}

session_unset();
session_destroy(); 
//$galeria = new GaleriaImagenes();
if(isset($_SESSION['galeria'])){
    $galeria = unserialize($_SESSION['galeria']);
    if(isset($_POST['action'])){
        call_user_func_array(array($galeria,$_POST['action']), explode(',', $_POST['args']));
    }else{
        $galeria->start();
    }
}else{    
    $_SESSION['galeria'] = serialize(new GaleriaImagenes());
    $galeria = unserialize($_SESSION['galeria']);
    if(isset($_POST['action'])){
        call_user_func_array(array($galeria,$_POST['action']), explode(',', $_POST['args']));
    }else{
        $galeria->start();
    }
}
?>