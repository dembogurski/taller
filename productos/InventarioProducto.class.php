<?PHP
session_start();

require_once("../Config.class.php");
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_DB_MSSQL.class.php");
require_once("../Y_Template.class.php");
require_once("../Ajax.class.php");

class InventarioProducto {
   function __construct(){         
        $this->t = new Y_Template("InventarioProducto.html");        
        $this->c = new Config();        
        $this->host = $_SERVER['HTTP_HOST'] != '190.128.150.70:2220'?'192.168.2.252':'190.128.150.70:2252';
        $this->images_url = "http://$this->host/prod_images/";
   }
   public function start(){
       $this->showHeader();
       $this->showFooter();
   }

   public function showHeader(){
      $suc = $_REQUEST['suc'];
      $link = new My();
      //$link->Query("SELECT if(id is null,date(now()), min(fecha)) as fechaIni FROM inventario WHERE suc = '$suc'");
      $link->Query("SELECT id_inv,inicio as fechaIni, DATE_FORMAT(inicio,'%d/%m/%Y %H:%i:%s') AS fechaFormat FROM inventario_cab WHERE suc='$suc' AND estado='En_proceso'");
      $id_inv = '';
      $fechaIni = '';
      $fechaFormat = '';
      if($link->NextRecord()){
          $id_inv = $link->Record['id_inv'];
          $fechaIni = $link->Record['fechaIni'];
          $fechaFormat = $link->Record['fechaFormat'];
      }
      $link->Close();
      $this->t->Set("id_inv", $id_inv);
      $this->t->Set("fechaIni", $fechaIni);
      $this->t->Set("fechaIni", $fechaIni);
      $this->t->Set("fechaFormat", $fechaFormat);
      $this->t->Set("images_url", $this->images_url);
      $this->t->Show("header");
      $this->t->Show("body");
   }

   public function showFooter(){
      $this->t->Show("footer");
   }

   public function insertarRegistro(){
       $msj = array();
       $usuario = $_POST['usuario'];
       $id_inv = $_POST['id_inv'];
       $suc = $_POST['suc'];
       $um = $_POST['um'];
       $lote= trim($_POST['lote']);
       $codigo= $_POST['codigo'];
       $stock_ini= $_POST['stock_ini'];
       $gramaje_ini= $_POST['gramaje_ini'];
       $ancho_ini= $_POST['ancho_ini'];
       $tara_ini= (strlen(trim($_POST['tara_ini'])) == 0)?0:trim($_POST['tara_ini']);
       $kg_calc= $_POST['kg_calc'];
       $kg_desc_ini= $_POST['kg_desc_ini'];
       $tipo_ini= $_POST['tipo_ini'];
       $stock= $_POST['stock'];
       $gramaje= $_POST['gramaje'];
       $ancho= $_POST['ancho'];
       $tara= $_POST['tara'];
       $kg= $_POST['kg'];
       $kg_desc= $_POST['kg_desc'];
       $tipo= $_POST['tipo'];
       $actualizarKgDesc = ($_POST['actualizarKgDesc']=='false')?false:true;
       

       $link = new My();
       $link->Query("INSERT INTO inventario (id_inv,usuario, suc, um, lote, codigo, stock_ini, gramaje_ini, ancho_ini, tara_ini, kg_calc,kg_desc_ini, tipo_ini, stock, gramaje, ancho, tara, kg, kg_desc, tipo) VALUES ($id_inv,'$usuario', '$suc','$um', '$lote', '$codigo', $stock_ini, $gramaje_ini, $ancho_ini, $tara_ini, $kg_calc,$kg_desc_ini, '$tipo_ini', $stock, $gramaje, $ancho, $tara, $kg, $kg_desc, '$tipo')");
       if($link->AffectedRows()>0){
           array_push($msj,array("status" => "ok", "msj" => "Se realizo el registro de inventario correctamente"));
       }else{
           array_push($msj,array("status" => "error", "msj" => "No se pudo insertar el registro"));           
       }
       $link->Close();

       if($actualizarKgDesc){
           $ms_link = new MS();
           $ms_link->Query("UPDATE OIBT set U_kg_desc=$kg_desc WHERE BatchNum = $lote");
           if( $ms_link->AffectedRows() > 0 ){
               array_push($msj,array("status" => "ok", "msj" => "Se actualizo el Kg de Descarga"));
           }else{
               array_push($msj,array("status" => "error", "msj" => "No se actualizo el Kg de Descarga"));
           }
           $ms_link->Close();
       }
       echo json_encode($msj);
   }

   public function registrosAnteriores($lote,$suc){
       $link = new My();       
       $registros = array();
                
       $query = "SELECT id_inv, usuario,suc,um,stock,gramaje,ancho,tara,kg,date_format(date(fecha),'%d-%m-%Y') as fecha, time(fecha) as hora FROM inventario WHERE lote = '$lote' and suc like '$suc'";
       //echo $query;
       $link->Query($query);
       if($link->NumRows()>0){
           while($link->NextRecord()){
               array_push($registros,$link->Record);
           }           
       }
       $link->Close();  
       echo json_encode($registros);
       //echo json_encode(array("query"=>$query));
   }
                
   public function esRollo($lote,$codigo){
       $r = verifRollo($lote,$codigo);
       if(verifRollo($lote,$codigo)){
           echo '{"esRollo":1}';
       }else{
           echo '{"esRollo":0}';
       }       
   }

   /*
   * Cantidad de lotes inventariados por dia en un rango de fecha
   */
   public function verifAvance($fechaIni,$suc,$codigo,$id_inv){
       $respuesta = array();
       $link = new My();
       $msLink = new MS();
       $link->Query("SELECT COUNT(distinct lote) AS inv FROM inventario WHERE codigo = '$codigo' AND suc = '$suc' AND id_inv=$id_inv");
       $link->NextRecord();
       $respuesta['inventariados'] = $link->Record['inv'];
       $link->Close();

       $msLink->Query("SELECT COUNT(*) as lotes FROM OBTN o INNER JOIN (SELECT i.ItemCode,i1.SysNumber,i.LocCode,min(i.DocDate) as entDate,sum(i1.Quantity) as Stock FROM OITL i INNER JOIN ITL1 i1 ON i.LogEntry=i1.LogEntry group by i.ItemCode,i1.SysNumber,i.LocCode) as mov on o.ItemCode=mov.ItemCode and o.SysNumber = mov.Sysnumber INNER JOIN OITM m on o.ItemCode=m.ItemCode LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code WHERE mov.LocCode like '$suc' AND o.U_fin_pieza <> 'Si' and Stock > 0 and o.ItemCode like '$codigo' and mov.entDate < CONVERT(DATETIME, '$fechaIni', 111)");
       $msLink->NextRecord();
       $respuesta['lotes'] = $msLink->Record['lotes'];
       $msLink->Close();
              
       echo json_encode($respuesta);
   }

   /*
   * Busca los datos de lote 
   */
   public function buscarDatosDeCodigo($lote, $suc){
       $db = new My();
       $ms_link = new MS();
       $datos = array();
       $query = "SELECT o.ItemCode as Codigo,mov.Stock,(m.U_NOMBRE_COM + '-' + c.Name) as Descrip,o.U_fin_pieza as FP,m.InvntryUom as UM,o.U_ancho as Ancho,o.U_gramaje as Gramaje,o.U_tara as Tara, o.U_padre as Padre,o.U_ubic, o.U_img as Img,o.U_F1 as F1,o.U_F2 as F2,o.U_F3 as F3, o.U_kg_desc, CONVERT(varchar,mov.entDate,120) as entDate FROM OBTN o INNER JOIN (SELECT i.ItemCode,i1.SysNumber,i.LocCode,min(i.DocDate) as entDate,sum(i1.Quantity) as Stock FROM OITL i INNER JOIN ITL1 i1 ON i.LogEntry=i1.LogEntry group by i.ItemCode,i1.SysNumber,i.LocCode) as mov on o.ItemCode=mov.ItemCode and o.SysNumber = mov.Sysnumber INNER JOIN OITM m on o.ItemCode=m.ItemCode LEFT JOIN [@EXX_COLOR_COMERCIAL] c ON o.U_color_comercial = c.Code WHERE mov.LocCode like '$suc' and o.DistNumber='$lote'";
       $ms_link->Query($query);
       if($ms_link->NextRecord()){
           $datos = $ms_link->Record;
           if(count($datos)){
               $datos = array_map("utf8_encode",$datos);
              // print_r($datos);
                
               $rem = "SELECT CONCAT(fecha_cierre,' ',hora_cierre) AS fecha_ingreso FROM nota_remision n, nota_rem_det d WHERE n.n_nro = d.n_nro AND lote = '$lote' AND n.estado = 'Cerrada' AND n.suc_d = '$suc'";
                
               $db->Query($rem);
               if($db->NumRows() > 0){ 
                   $db->NextRecord();
                   $fecha_ingreso = $db->Record['fecha_ingreso'];
                   $datos['entDate'] = $fecha_ingreso;
               }
               // Buscar si esta en una Remision Abierta o En Proceso
               $rem2 = "SELECT n.n_nro, n.suc_d FROM nota_remision n, nota_rem_det d WHERE n.n_nro = d.n_nro AND lote = '$lote' AND n.estado != 'Cerrada' AND n.suc = '$suc'";
                
               $db->Query($rem2);
               if($db->NumRows() > 0){ 
                   $db->NextRecord();
                   $n_nro = $db->Record['n_nro'];
                   $destino = $db->Record['suc_d'];
                   $datos['NroRemision'] = $n_nro;
                   $datos['Destino'] = $destino;
                   $datos['Mensaje']="En Remision";
               }else{
                  $datos['Mensaje']="Ok"; 
               }
                
           }
            echo json_encode($datos);
       }else{
           echo '{"Mensaje":"Error: Codigo no encontrado!"}';
       }       
       $ms_link->Close();
   }

   /*
   * Foto
   */
   public function lotesSimilares($lote){
       $ms_link = new MS();
       $lotes = array();
       $datosPorLote = "SELECT o.DistNumber,l.BaseEntry,l.DocType,l.DocNum, o.ItemCode,o.U_color_comercial,o.U_design,o.U_nro_lote_fab,o.U_color_cod_fabric FROM OBTN o INNER JOIN  ixvITL_Min x ON o.ItemCode = x.ItemCode AND o.SysNumber = x.SysNumber INNER JOIN	OITL l ON l.LogEntry = x.LogEntry AND l.ItemCode = x.ItemCode where o.DistNumber = '$lote'";
       
       
       $ms_link->Query($datosPorLote);
       if($ms_link->NextRecord()){
           $ItemCode = $ms_link->Record['ItemCode'];
           $DocNum = $ms_link->Record['DocNum'];
           $DocType = $ms_link->Record['DocType'];
           $U_design = $ms_link->Record['U_design'];
           $U_color_comercial = $ms_link->Record['U_color_comercial'];
           $U_nro_lote_fab = $ms_link->Record['U_nro_lote_fab'];
           $U_color_cod_fabric = $ms_link->Record['U_color_cod_fabric'];
           
           $lotesSimilares = "SELECT o.DistNumber, l.LocCode, l.BaseEntry,l.DocType,l.DocNum, o.ItemCode,o.U_color_comercial,o.U_design,o.U_nro_lote_fab,o.U_color_cod_fabric, o.U_img FROM OBTN o INNER JOIN  ixvITL_Min x ON o.ItemCode = x.ItemCode AND o.SysNumber = x.SysNumber INNER JOIN	OITL l ON l.LogEntry = x.LogEntry AND l.ItemCode = x.ItemCode where o.ItemCode = '$ItemCode' and l.DocNum = $DocNum and l.DocType = $DocType and o.U_design = '$U_design' and o.U_color_comercial = '$U_color_comercial' and U_nro_lote_fab = '$U_nro_lote_fab' and U_color_cod_fabric = '$U_color_cod_fabric'";

           $ms_link->Query($lotesSimilares);
           while($ms_link->NextRecord()){
               array_push($lotes, array_map("utf8_encode", $ms_link->Record));
           }
           $ms_link->Close();
       }
       echo json_encode($lotes);
   }

   public function guardarImagen(){
        require_once '../Config.class.php';
        require_once '../utils/NAS.class.php';
        $lote_principal = $_POST['lote'];
        $lotes = $_POST['lotes'];
        $ms_link = new MS();
        $file;
        $thumnail;
        $image_info;
        $width;
        $height;
        $type;
        $respuesta = array();

        if($_FILES['file']['error'] > 0) { echo 'Error during uploading, try again'; }        
        $extsAllowed = array( 'jpg', 'jpeg', 'png');
        // Extension
        $extUpload = strtolower( substr( strrchr($_FILES['file']['name'], '.') ,1) ) ;

        // Permitidos
        if (in_array($extUpload, $extsAllowed) ) {
            $name = "img/{$_FILES['file']['name']}";
            $tmp_file = $_FILES['file']['tmp_name'];
            $file = file_get_contents($tmp_file);
            $image_info = getimagesize($tmp_file);
            $width = $new_width = $image_info[0];
            $height = $new_height = $image_info[1];
            $type = $image_info[2];
            // Load the image
            switch ($extUpload)
            {
                case 'jpg':
                    $image = imagecreatefromjpeg($tmp_file);
                    break;
                case 'gif':
                    $image = imagecreatefromgif($tmp_file);
                    break;
                case 'png':
                    $image = imagecreatefrompng($tmp_file);
                    break;
                default:
                    die('Error loading '.$tmp_file.' - File type '.$extUpload.' not supported');
            }

            // Create a new, resized image
            $new_width = 150;
            $new_height = $height / ($width / $new_width);
            $new_image = imagecreatetruecolor($new_width, $new_height);
            imagecopyresampled($new_image, $image, 0, 0, 0, 0, $new_width, $new_height, $width, $height);
            
            // Save the new image over the top of the original photo
            ob_start(); 
            switch ($extUpload)
            {
                case 'jpg':
                    imagejpeg($new_image);
                    $thumnail = ob_get_clean();
                    break;
                case 'gif':
                    imagegif($new_image);         
                    $thumnail = ob_get_clean();
                    break;
                case 'png':
                    imagepng($new_image);
                    $thumnail = ob_get_clean();
                    break;
                default:
                    die('Error saving image: '.$tmp_file);
            }        
            ob_end_clean(); 

        }else{ 
            $respuesta['error'] = "Archivo invalido tipos permitidos ".$extsAllowed[0].", ".$extsAllowed[1].", o ".$extsAllowed[2]; 
        }
        
        $ms_link->Query("SELECT o.DistNumber,l.BaseEntry,l.DocType,l.DocNum, o.ItemCode,o.U_color_comercial,o.U_design,o.U_nro_lote_fab,o.U_color_cod_fabric FROM OBTN o INNER JOIN  ixvITL_Min x ON o.ItemCode = x.ItemCode AND o.SysNumber = x.SysNumber INNER JOIN	OITL l ON l.LogEntry = x.LogEntry AND l.ItemCode = x.ItemCode where o.DistNumber = '$lote_principal'");
        if($ms_link->NextRecord()){            
            $BaseType = $ms_link->Record['DocType'];
            $BaseEntry = $ms_link->Record['DocNum'];
            try{
                $c = new Config();
                $username = $c->getNasUser();
                $password = $c->getNasPassw();
                $path = $c->getNasPath();
                $folder = $c->getNasFolder();
                $port = $c->getNasPort();
                $host = $c->getNasHost();

                $full_path = $path."/$folder/".$BaseType."-".$BaseEntry;
                $filename = $full_path."/_$lote_principal.jpg";
                //$nas = new NAS($host,$port);
                $nas = new NAS("192.168.2.252","22");
                $nas->login($username, $password);
                $nas->mkdir($full_path);
                $nas->setContent($file ,$filename);
                $thumname = $full_path."/_$lote_principal.thum.jpg";
                $nas->setContent($thumnail,$thumname);
                $file_url = "http://$host/$folder/$BaseType"."-"."$BaseEntry/_$lote_principal.jpg";        
                
                $lista_lotes = $this->buscarHijos($lotes);
                $ms_link->Query("UPDATE OIBT SET U_img = '$BaseType"."-"."$BaseEntry/_$lote_principal' WHERE BatchNum in ($lista_lotes)");

                if($ms_link->AffectedRows() >0 ){
                    $respuesta['msj']="Lote se actualizo";
                }else{
                    $respuesta['msj']="Error al actualizar lote";
                }
                $U_img = $BaseType."-".$BaseEntry."/".$lote_principal;
                $respuesta['url'] = $file_url;
                $respuesta['host'] = $_SERVER['REMOTE_ADDR'];
                
            }catch (Exception $e) {
                $respuesta['error'] = $e->getMessage();
            }
        }
        $this->imgLog($lotes,"Asignar $BaseType"."-"."$BaseEntry/_$lote_principal");
        echo json_encode($respuesta);
   }

   public function asignarImagenExistente($ref,$lotes){
       $ms_link = new MS();
       $ms_link->Query("SELECT o.DistNumber,l.BaseEntry,l.DocType,l.DocNum, o.ItemCode,o.U_color_comercial,o.U_design,o.U_nro_lote_fab,o.U_color_cod_fabric,o.U_img FROM OBTN o INNER JOIN  ixvITL_Min x ON o.ItemCode = x.ItemCode AND o.SysNumber = x.SysNumber INNER JOIN	OITL l ON l.LogEntry = x.LogEntry AND l.ItemCode = x.ItemCode where o.DistNumber = '$ref'");

        if($ms_link->NextRecord()){            
            $BaseType = $ms_link->Record['DocType'];
            $BaseEntry = $ms_link->Record['DocNum'];
            $img = $ms_link->Record['U_img'];            
            $ms_link->Query("UPDATE OIBT SET U_img = '$img' WHERE BatchNum in ($lotes)");
            $ms_link->Close();
        }
        $this->imgLog($lotes,"Asignar $ref");
        echo '{"data":"Ok"}';
    }

    public function imgLog($lotes,$accion){
        $link = new My();
        $link->Query("INSERT INTO logs (usuario, fecha, hora, accion, tipo, doc_num, data) VALUES ('Sistema', DATE(NOW()), TIME(NOW()), '$accion', 'Lote', '', '$lotes')");
        $link->Close();
    }

    /*
    * Busca Hijos y Nietos
    */
    public function buscarHijos($lote){
        $ms_link = new MS();
        $l_lotes = trim(implode(',',array_map(array($this,'comillas'),explode(',',$lote))),',');
        $lotes = $l_lotes;
        $seguir = true;
        $padre = $l_lotes;
        while($seguir){
            $ms_link->Query("SELECT DISTINCT DistNumber FROM OBTN WHERE U_padre in ($padre)");
            if($ms_link->NumRows() >0 ){
                $padre = '';
                while($ms_link->NextRecord()){
                    $lotes .= ",'".$ms_link->Record['DistNumber']."'";
                    $padre .= (strlen($padre)>0)?",'".$ms_link->Record['DistNumber']."'" : "'".$ms_link->Record['DistNumber']."'";
                }
            }else{
                $seguir = false;
            }
        }
        $ms_link->Close();
        
        return $lotes;
    }
    // Agrega comillas
    function comillas($st){
        return "'".$st."'";
     }

    // Nuevo proceso de inventario
    public function nuevo_inventario($usuario,$suc){
        $respuesta = array();
        $my = new My();
        $my->Query("INSERT INTO inventario_cab (usuario, suc) VALUES ('$usuario', '$suc')");
        if($my->AffectedRows()>0){
           $my->Query("SELECT id_inv,inicio, DATE_FORMAT(inicio,'%d/%m/%Y %H:%i:%s') AS fechaFormat FROM inventario_cab WHERE suc='$suc' AND estado='En_proceso' ORDER BY id_inv DESC LIMIT 1");
           if($my->NextRecord()){
              $respuesta['id_inv'] = $my->Record['id_inv'];
              $respuesta['fechaIni'] = $my->Record['inicio'];
              $respuesta['fechaFormat'] = $my->Record['fechaFormat'];
              $my->Close();
           }else{
               $respuesta['erro'] = 'No se pudo generar nuevo proceso de inventario!';
           }
        }
        echo json_encode($respuesta);
    }

    // Finalizar Inventario
    public function fin_inventario($id_inv, $usuario){
        $my = new My();
        $my->Query("UPDATE inventario_cab SET estado='Cerrada', fin=CURRENT_TIMESTAMP, cerrado_por = '$usuario' WHERE id_inv=$id_inv");
        if($my->AffectedRows()>0){
            $respuesta['estado'] = 'OK';
            $my->Close();
        }else{
            $respuesta['erro'] = 'No se pudo generar nuevo proceso de inventario!';
        }
        echo json_encode($respuesta);
    }
    
    function historial($lote,$suc){
       $ms = new MS();
        
        $Qry = "SELECT i.DocEntry,o.ItemCode,c.AvgPrice, o.DistNumber,i.LocCode, o.itemName   as ItemName, i.DocType, i.ApplyEntry,o.U_fin_pieza,
        CONVERT(VARCHAR(10),i.DocDate,105) as DocDate, 
		  CASE WHEN ( i.DocType = 17 ) THEN -i1.AllocQty ELSE i1.Quantity END AS Quantity, i.CardCode,i.CardName, 
        CASE WHEN ( i1.Quantity > 0 or  i1.AllocQty < 0 ) THEN 'Entrada' else 'Salida' end as Direction,        
        case i.DocType 
        when 20 then (Select LEFT(t1.DocTime,case len(t1.doctime) when 4 then 2 else 1 end)+':'+right(t1.DocTime,2)+'|'+ ISNULL ( t1.U_Usuario , '' )+'|'+t1.Comments  FROM OPDN t1 where t1.docentry=i.DocEntry) 
        when 18 then (Select LEFT(t2.DocTime,case len(t2.doctime) when 4 then 2 else 1 end)+':'+right(t2.DocTime,2)+'|'+ISNULL ( t2.U_Usuario , '' )+'|'+t2.Comments  FROM OPCH t2 where t2.docentry=i.DocEntry) 
        when 59 then (Select LEFT(t3.DocTime,case len(t3.doctime) when 4 then 2 else 1 end)+':'+right(t3.DocTime,2)+'|'+ISNULL ( t3.U_Usuario , '' )+'|'+t3.Comments  FROM OIGN t3 where t3.docentry=i.DocEntry) 
        when 60 then (Select LEFT(t4.DocTime,case len(t4.doctime) when 4 then 2 else 1 end)+':'+right(t4.DocTime,2)+'|'+ISNULL ( t4.U_Usuario , '' )+'|'+t4.Comments  FROM OIGE t4 where t4.docentry=i.DocEntry)
        when 13 then (Select LEFT(t5.DocTime,case len(t5.doctime) when 4 then 2 else 1 end)+':'+right(t5.DocTime,2)+'|'+ISNULL ( t5.U_vendedor + '|'+'Ticket:' + CAST(t5.U_nro_interno as varchar), '' )  FROM OINV t5 where t5.docentry=i.DocEntry)
        when 67 then (Select LEFT(t6.DocTime,case len(t6.doctime) when 4 then 2 else 1 end)+':'+right(t6.DocTime,2)+'|'+ISNULL ( concat( t6.U_vendedor,' --> ',t6.U_Usuario ) , '' )+'| Rem: '+CAST(t6.U_Nro_Interno as VARCHAR) FROM OWTR t6 where t6.docentry=i.DocEntry)
        when 14 then (Select LEFT(t7.DocTime,case len(t7.doctime) when 4 then 2 else 1 end)+':'+right(t7.DocTime,2)+'|'+ISNULL ( t7.U_Usuario , '' )+'|'+t7.Comments FROM ORIN t7 where t7.docentry=i.DocEntry)
		  when 17 then (Select LEFT(t8.DocTime,case len(t8.doctime) when 4 then 2 else 1 end)+':'+right(t8.DocTime,2)+'|'+ISNULL ( t8.U_vendedor , '' )+'| Interno: '+CAST(t8.U_Nro_Interno as VARCHAR) FROM ORDR t8 where t8.docentry=i.DocEntry)
		  when 21 then (Select LEFT(t9.DocTime,case len(t9.doctime) when 4 then 2 else 1 end)+':'+right(t9.DocTime,2)+'|'+ISNULL ( t9.U_Usuario , '' )+'|'+t9.Comments FROM ORPD t9 where t9.docentry=i.DocEntry) else NULL end AS 'MovData'
        FROM OBTN o INNER JOIN OITL i ON o.ItemCode = i.ItemCode INNER JOIN ITL1 i1 ON i.LogEntry=i1.LogEntry AND o.SysNumber=i1.SysNumber INNER JOIN OITM c ON o.ItemCode = c.ItemCode    WHERE o.DistNumber = '$lote' and i.LocCode like '$suc' order by i.CreateDate asc, i.CreateTime asc";   
        
        
        $ms->Query($Qry);
        
        $rows = $ms->NumRows();
                
                
        $arr = array();
        $i = 1;
        while($ms->NextRecord()){ 
                
                
            if( $i == 1 || $i == $rows){ 
                $Quantity = $ms->Record['Quantity'];
                $DocDate = $ms->Record['DocDate'];
                $AvgPrice = $ms->Record['AvgPrice'];
                $Mov = explode("|", $ms->Record['MovData']);
                $Hora = $Mov[0];
                $Usuario = $Mov[1];
                
                $ter = '';
                if( $i == 1 ){
                  $ter = 'IN';
                }else if($i == $rows ){
                    $ter = 'UM';
                }
                //echo "Fila>>>>>>> $i  ter $ter <br> ";
                
                //$arr["Quantity$ter"]=$Quantity;
                $arr["DocDate$ter"]=$DocDate." ".$Hora;
                $arr["Usuario$ter"]=$Usuario;
                $arr["AvgPrice"]= $AvgPrice;
                
            }
            //echo "Fila: $i<br>";
            $i++;
        }       
                
        echo json_encode($arr);
    }
    
}

$inventario = new InventarioProducto();
if(isset($_POST['inv_action'])){
    call_user_func_array(array($inventario,$_POST['inv_action']), explode(',', $_POST['args']));
}else{
    $inventario->start();
}

?>