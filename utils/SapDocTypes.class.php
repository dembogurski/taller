<?php

/**
 * Description of SapDocTypes
 * @author Ing.Douglas
 * @date 24/02/2016
 */
class SapDocTypes {
   
   private $DocTypes = array();
   
   function __construct(){
       $this->DocTypes[13] = 'Factura Venta'; //OINV
       $this->DocTypes[14] = 'Devolucion'; //o Nota de Credito ORIN  
       $this->DocTypes[17] = 'Reserva'; //ORDR
       $this->DocTypes[18] = 'Factura Compra'; //OPCH
       $this->DocTypes[20] = 'Entrada por Compra'; //OPDN
       $this->DocTypes[21] = 'Devolucion Proveedor'; //ORPD
       $this->DocTypes[59] = 'Entrada Normal'; //OIGN
       $this->DocTypes[60] = 'Salida Normal'; //OIGE
       $this->DocTypes[67] = 'Traslado de Stock'; //OWTR
       /*Agregar + aqui*/ 
       
       
       // Reconciliacion Interna = Tabla OITR  Detalle --> ITR1 
       // Cuotas de Factura INV6
       // Asientos contables  OJDT --> Detalle --> JDT1 
       
   }
   function getType($DocBase){       
      return $this->DocTypes[$DocBase];   
   }   
}
?>
