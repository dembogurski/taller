<?php

/**
 * Description of ReubicacionEstantes
 * @author Ing.Douglas
 * @date 07/07/2018
 */
require_once("../Y_Template.class.php");
require_once("../Y_DB_MySQL.class.php");
require_once("../Y_DB_MSSQL.class.php");

class ReubicacionEstantes {
    //put your code here
 

    function __construct() {
        $action = $_REQUEST['action'];
        if (function_exists($action)) {
            call_user_func($action);
        } else {
            $this->main();
        }
    }

    function main() {

        $t = new Y_Template("ReubicacionEstantes.html");

        $t->Show("headers");
        // Extrae los datos 
        $suc = $_REQUEST['suc'];
        
        $t->Show("body");
         
    }       
}
function interpolarAyB(){
        $ms = new MS();
        $db = new MS();
        
        $ms->Query("update [@reg_ubic] SET U_col = U_col + 7 where  U_nombre = 'B';");// 
         
        $ms->Query("update [@reg_ubic] SET U_col = 7 where  U_nombre = 'B' and U_col = 9;"); // 
        $ms->Query("update [@reg_ubic] SET U_col = 6 where  U_nombre = 'B' and U_col = 10;"); // 
        $ms->Query("update [@reg_ubic] SET U_col = 5 where  U_nombre = 'B' and U_col = 11;"); // 
        $ms->Query("update [@reg_ubic] SET U_col = 4 where  U_nombre = 'B' and U_col = 12;"); // 
        $ms->Query("update [@reg_ubic] SET U_col = 3 where  U_nombre = 'B' and U_col = 13;"); // 
        $ms->Query("update [@reg_ubic] SET U_col = 2 where  U_nombre = 'B' and U_col = 14;"); // 
        $ms->Query("update [@reg_ubic] SET U_col = 1 where  U_nombre = 'B' and U_col = 15;"); // 
         
        corregirOBTN("B"); 
        echo "Ok";
        
        /*echo "Cambiando de nombre de A --> AA <br>";
        $ms->Query("update [@reg_ubic] SET U_nombre = 'BB' where  U_nombre = 'B';");
        echo "Cambiando de nombre de B --> BB <br>";
        
        $ms->Query("update [@reg_ubic] SET U_nombre = 'B' where  U_nombre = 'AA';");
        echo "Cambiando de nombre de AA --> B <br>";
        $ms->Query("update [@reg_ubic] SET U_nombre = 'A' where  U_nombre = 'BB';");
        echo "Cambiando de nombre de BB --> A <br>"; */
        
        //corregirOBTN("A");
        //corregirOBTN("B");    
        /*
        echo "Corrigiendo Lista de Adyancencias <br>";
        $db->Query('DELETE FROM lista_adyacencias WHERE nodo LIKE "A%" OR nodo LIKE "B%" OR nodo LIKE "C%" OR nodo LIKE "D%"');
        
        $db->Query("DELETE FROM nodos WHERE suc = '00' AND nodo LIKE 'D%'");
        
         
        generarListaAdyacencias(1,8,'A',4);
        $db->Query("insert into lista_adyacencias (suc,nodo,adya,costo)values('00','A8','C1',12);");
         
        generarListaAdyacencias(1,19,'C',4);
        $db->Query("insert into lista_adyacencias (suc,nodo,adya,costo)values('00','C19','B8',4);");         */
        //generarListaAdyacencias(1,8,'B',4);
}
function procederEstanteD(){
    $ms = new MS();
    $db = new MS();
	
	$ms->Query("UPDATE [@reg_ubic] SET U_col = 14  where  U_nombre = 'D' and U_col =16;");
	$ms->Query("UPDATE [@reg_ubic] SET U_col = 13  where  U_nombre = 'D' and U_col =17;");
	$ms->Query("UPDATE [@reg_ubic] SET U_col = 18  where  U_nombre = 'D' and U_col =12;");
	$ms->Query("UPDATE [@reg_ubic] SET U_col = 19  where  U_nombre = 'D' and U_col =11;");
	$ms->Query("UPDATE [@reg_ubic] SET U_col = 19  where  U_nombre = 'D' and U_col =18;");
	
	corregirOBTN("D"); 
    /*
    echo "UPDATE [@reg_ubic] SET U_col = U_col + 10  where  U_nombre = 'E';<br>";
    $ms->Query("UPDATE [@reg_ubic] SET U_col = U_col + 10  where  U_nombre = 'E';");
    echo "UPDATE [@reg_ubic] SET U_col = U_col + 9  where  U_nombre = 'F';<br>";
    $ms->Query("UPDATE [@reg_ubic] SET U_col = U_col + 9  where  U_nombre = 'F';");
    echo "FOR";
    $count = 1;
    for($i = 20;$i > 10; $i--){         
        $ms->Query("UPDATE [@reg_ubic] SET U_col = $count  where  U_nombre = 'E' and U_col = $i;");
        echo "UPDATE [@reg_ubic] SET U_col = $count  where  U_nombre = 'E' and U_col = $i;<br>";
        $count++;
    }
    
    for($i = 18;$i > 9; $i--){         
        $ms->Query("UPDATE [@reg_ubic] SET U_col = $count  where  U_nombre = 'F' and U_col = $i;");
        echo "UPDATE [@reg_ubic] SET U_col = $count  where  U_nombre = 'E' and U_col = $i;<br>";
        $count++;
    }
    $ms->Query("UPDATE [@reg_ubic] SET U_nombre = 'D'  where  U_nombre = 'E' ;");
    $ms->Query("UPDATE [@reg_ubic] SET U_nombre = 'D'  where  U_nombre = 'F' ;");
    echo "corregirOBTN D<br>";
    
      
    echo "Borrar Lista de Adyacencias<br>";
    $db->Query('DELETE FROM lista_adyacencias WHERE nodo LIKE "D%" ');
    */
    echo "Generar Lista de Adyacencias";
    //generarListaAdyacencias(1,19,'D',4);
     
   // $db->Query("insert into lista_adyacencias (suc,nodo,adya,costo)values('00','00','D10',10);");
   // $db->Query("insert into lista_adyacencias (suc,nodo,adya,costo)values('00','00','D11',8);");    
}
 

function generarListaAdyacencias($ini,$fin,$letra,$distancia){
    $db = new MS();
    for($i = $ini;$i < $fin;$i++){
        $adya = $i + 1;
        $de = $letra."".$i;
        $a = $letra."".$adya;
        $ins = "insert into lista_adyacencias (suc,nodo,adya,costo)values('00','$de','$a',$distancia);";
        echo $ins."<br>";
        $db->Query($ins);
    }
}
 
 

function cambiarEstanteIJ(){
    $ms = new MS(); 
    $ms->Query("UPDATE [@reg_ubic] SET U_nombre = 'G'  where  U_nombre = 'I' and U_col < 9;");    
    $ms->Query("UPDATE [@reg_ubic] set U_col = U_col + 8  where  U_nombre = 'J';");          
    $ms->Query("UPDATE [@reg_ubic] SET U_nombre = 'G'  where  U_nombre = 'J' and U_col < 17;");
      
    $ms->Query("UPDATE [@reg_ubic] SET U_nombre = 'H'  where  U_nombre = 'I' and U_col > 8;");
    $ms->Query("UPDATE [@reg_ubic] SET U_col = 1  where  U_nombre = 'H' AND U_col = 16 ;");    
    $ms->Query("UPDATE [@reg_ubic] SET U_col = 2  where  U_nombre = 'H' AND U_col = 15 ;");   
    $ms->Query("UPDATE [@reg_ubic] SET U_col = 3  where  U_nombre = 'H' AND U_col = 14 ;");    
    $ms->Query("UPDATE [@reg_ubic] SET U_col = 4  where  U_nombre = 'H' AND U_col = 13 ;");    
    $ms->Query("UPDATE [@reg_ubic] SET U_col = 5  where  U_nombre = 'H' AND U_col = 12 ;");    
    $ms->Query("UPDATE [@reg_ubic] SET U_col = 6  where  U_nombre = 'H' AND U_col = 11 ;");    
    $ms->Query("UPDATE [@reg_ubic] SET U_col = 7  where  U_nombre = 'H' AND U_col = 10 ;");    
    $ms->Query("UPDATE [@reg_ubic] SET U_col = 8  where  U_nombre = 'H' AND U_col = 9 ;");   
    
    $ms->Query("UPDATE [@reg_ubic] SET U_nombre = 'H', U_col = 9   where  U_nombre = 'H' AND U_col = 24 ;");    
    $ms->Query("UPDATE [@reg_ubic] SET U_nombre = 'H', U_col = 10  where  U_nombre = 'H' AND U_col = 23 ;");    
    $ms->Query("UPDATE [@reg_ubic] SET U_nombre = 'H', U_col = 11  where  U_nombre = 'H' AND U_col = 22 ;");    
    $ms->Query("UPDATE [@reg_ubic] SET U_nombre = 'H', U_col = 12  where  U_nombre = 'H' AND U_col = 21 ;");    
    $ms->Query("UPDATE [@reg_ubic] SET U_nombre = 'H', U_col = 13  where  U_nombre = 'H' AND U_col = 20 ;");    
    $ms->Query("UPDATE [@reg_ubic] SET U_nombre = 'H', U_col = 14  where  U_nombre = 'H' AND U_col = 19 ;");    
    $ms->Query("UPDATE [@reg_ubic] SET U_nombre = 'H', U_col = 15  where  U_nombre = 'H' AND U_col = 18 ;");    
    $ms->Query("UPDATE [@reg_ubic] SET U_nombre = 'H', U_col = 16  where  U_nombre = 'H' AND U_col = 17 ;");    
    corregirOBTN("G");
    corregirOBTN("H");
}

function cambiarEstanteKL(){
    $ms = new MS(); 
    $ms->Query("UPDATE [@reg_ubic] SET U_nombre = 'X'  where  U_nombre = 'K' and U_col > 8;");    
    $ms->Query("UPDATE [@reg_ubic] SET U_nombre = 'I', U_col = U_col + 8  where  U_nombre = 'L' and U_col < 9;");    
    $ms->Query("UPDATE [@reg_ubic] SET U_nombre = 'I'  where  U_nombre = 'K' and U_col < 9;");    
    
    $count = 9;
    for($i = 16;$i > 8; $i--){       
        $ms->Query("UPDATE [@reg_ubic] SET U_nombre = 'J',  U_col = $count  where  U_nombre = 'L' and U_col = $i;");         
        $count++;
    }
    
    $count = 1;
    for($i = 16;$i > 8; $i--){         
        $ms->Query("UPDATE [@reg_ubic] SET  U_nombre = 'J', U_col = $count  where  U_nombre = 'X' and U_col = $i;");         
        $count++;
    }
     
    corregirOBTN("I");
    corregirOBTN("J");
    // Ya esta ya se puede usar

}    
function cambiarEstanteQROP(){
    $ms = new MS(); 
    
    $count = 9;
    for($i = 24;$i > 16; $i--){         
        $ms->Query("UPDATE [@reg_ubic] SET  U_nombre = 'H', U_col = $count  where  U_nombre = 'J' and U_col = $i;");        
        
        $count++;
    }
    
    /*
    $ms->Query("UPDATE [@reg_ubic] SET  U_col = U_col - 7  where  U_nombre = 'N' and U_col < 9; ");  
    
    $ms->Query("UPDATE [@reg_ubic] SET  U_col = 2  where  U_nombre = 'N' and U_col = 0; "); 
    $ms->Query("UPDATE [@reg_ubic] SET  U_col = 3  where  U_nombre = 'N' and U_col = -1; ");
    $ms->Query("UPDATE [@reg_ubic] SET  U_col = 4  where  U_nombre = 'N' and U_col = -2; ");
    $ms->Query("UPDATE [@reg_ubic] SET  U_col = 5  where  U_nombre = 'N' and U_col = -3; ");
    $ms->Query("UPDATE [@reg_ubic] SET  U_col = 6  where  U_nombre = 'N' and U_col = -4; ");
    $ms->Query("UPDATE [@reg_ubic] SET  U_col = 7  where  U_nombre = 'N' and U_col = -5; ");
    $ms->Query("UPDATE [@reg_ubic] SET  U_col = 8  where  U_nombre = 'N' and U_col = -6; ");  */
    
        /*
    $count = 1;
    for($i = 16;$i > 8; $i--){         
        $ms->Query("UPDATE [@reg_ubic] SET  U_nombre = 'N', U_col = $count  where  U_nombre = 'Q' and U_col = $i;");         
        $count++;
    }
    $count = 9;
    for($i = 8;$i > 0; $i--){         
        $ms->Query("UPDATE [@reg_ubic] SET  U_nombre = 'N', U_col = $count  where  U_nombre = 'R' and U_col = $i;");         
        $count++;
    }
     
    corregirOBTN("M"); */
    corregirOBTN("H");
    
}

function cambiarEstanteS(){
    $ms = new MS(); 
    //$ms->Query("UPDATE [@reg_ubic] SET U_nombre = 'O', U_col = U_col -2  where  U_nombre = 'S' and U_col < 10;"); 
    
    //$ms->Query("UPDATE [@reg_ubic] SET U_nombre = 'O', U_col = 9,U_fila = 1  where  U_nombre = 'S' and U_fila = 5 and U_col = 12;"); 
    
    $ms->Query("UPDATE [@reg_ubic] SET U_nombre = 'O', U_col = 9,U_fila = 3  where  U_nombre = 'S' and U_fila = 4 and U_col = 12;"); 
    $ms->Query("UPDATE [@reg_ubic] SET U_nombre = 'O', U_col = 9,U_fila = 4  where  U_nombre = 'S' and U_fila = 6 and U_col = 12;"); 
    $ms->Query("UPDATE [@reg_ubic] SET U_nombre = 'O', U_col = 9,U_fila = 5  where  U_nombre = 'S' and U_fila = 1 and U_col = 12;"); 
    
    //$ms->Query("UPDATE [@reg_ubic] SET U_nombre = 'O', U_col = U_col - 3  where  U_nombre = 'S' and U_col > 12;"); 
    
    corregirOBTN("O");
}

function corregirOBTN($E){
    $ms0 = new MS();
    $ms1 = new MS();
    $est = "select U_codigo,U_lote,U_suc,U_nombre,U_tipo,U_fila,U_col from [@reg_ubic] where  U_nombre = '$E'";
    //echo $est;
    $ms0->Query($est);
    echo $ms0->NumRows();
    while($ms0->NextRecord()){
        $U_codigo = $ms0->Record['U_codigo'];
        $U_lote = $ms0->Record['U_lote'];
        $U_suc = $ms0->Record['U_suc'];
        $Estante = $ms0->Record['U_nombre'];
        $fila = $ms0->Record['U_fila'];
        $col = $ms0->Record['U_col'];
        $UBICACION = "$Estante-$fila-$col";
        
        $qry = "UPDATE OBTN SET U_ubic = '$UBICACION' WHERE ItemCode ='$U_codigo' and DistNumber = '$U_lote';";
        //echo "$qry <br>";
        $ms1->Query($qry);
    }
}

new ReubicacionEstantes();

?>

        