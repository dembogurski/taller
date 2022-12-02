
//var abm_cliente = null;
var fecha_nac = "0000-00-00";
var data_next_time_flag = true;

var escribiendo = true;
var cant_articulos = 0;
var fila_art = 0;


var um_original = "";
var cantidad_original = 0;
var factorPrecio = 1;
var precioOriginal = 0;
var F = ""; // Codigo de Falla
var moneda_cliente = "G$";
var moneda = "G$";
var decimales = 0;
var operacion = "";  
var proforma;

var um_lista_precios = ['Mts'];
var um_cursor = 0;
 
var fallas = [];
var max_mts_fallas = 0;
var max_mts_fp = 0;

var art_inv = true; //Articulo de Inventario
var mnj_x_lotes = 'Si'

var total_valor_puntos = 0;

var PORC_VALOR_MINIMO = 1.25;

var UMBRAL_VENTA_MINORISTA = 9999999999;             

var UMBRAL_VENTA_MINORISTA_FORMATTED =  (UMBRAL_VENTA_MINORISTA).format(0, 3, '.', ',')


var CI_DIP = "C.I. Diplomatica";
   
/**************Caja*************/
   var rs = 0; // Cotizacion en Reales Pesos y Dolares
   var ps = 0;
   var us = 0;
   var factura = 0;
   var mon_vuelto = "G$";
   var vuelto_gs = 0;
   var cotiz_vuelto = 1; // Cotizacion del Vuelto
   var global_cotiz = 1; 
   var errorVuelto = false;
   var TOPE_ENTREGA = 40;
   var clics_cc = 0;
   var ventana;
   var impresion_factura_cerrada = false;


function inicializar(){
    
    $("#ruc_cliente").click(function(){ $(this).select(); });
      
    // Ruc para nuevo cliente
    $("#ruc_cliente").change(function(){
        var pais = $(this).val();
        if(pais != 'PY'){
            $("#ruc_cliente").mask("r99?rrrrrrr",{placeholder:""});
        }else{
            $("#ruc_cliente").mask("999?rrrrrrr",{placeholder:""});
        }
    });
    $("#nombre_cliente").click(function(){ 
        $(this).select();
        if(touch && (operacion == "crear")){
           showKeyboard(this,buscarClienteTouchNombre);   
        }        
    }); 
    // Para cargar Ventas Abiertas
    
    
    $("#cm_falla").focus(function(){
      selectFalla();
    });
    $("#cm_falla").click(function(){
       selectFalla();  
    });
       
        
    $("*[data-next]").keyup(function (e) {
        
        if (e.keyCode == 13) { 
            if(data_next_time_flag){
               data_next_time_flag = false;   
                                   
               if($(this).attr("id") == "nombre_cliente" || $(this).attr("id") == "ruc_cliente"){                   
                   buscarCliente(this);                  
               } 
               var next =  $(this).attr("data-next");
               $("#"+next).focus();               
               setTimeout("setDefaultDataNextFlag()",600);
            }
        } 
    });  
    $('.numeros:not("#cm_falla")').change(function(){
        var decimals = 2;
        if($(this).attr("id")=="precio_venta" || $(this).attr("id")=="cm_falla"  ){
            decimals = 0;
        }
        var n = parseFloat($(this).val() ).format(decimals, 3, '.', ',') ;
        $(this).val( n  );
        if($(this).val() =="" || $(this).val() =="NaN" ){
           $(this).val( 0);
        }
        chequearDatos();
     });
     $("#cm_falla").change(function(){
         chequearMtsFalla();
     });
     $(document).keyup(function (e) {
        
        if (e.keyCode > 111 && e.keyCode < 115) {  //F1:112 F2:113 F3:114  
           if( $("#cod_falla").text() !== ""){
              $("#cm_falla").focus();  
           }else{
              $("#msg_codigo").addClass("error");
              $("#msg_codigo").html("Esta Mercader&iacute;a no esta etiquetada con Fallas");
              setTimeout('$("#msg_codigo").html("")',14000);
           }
        }
  
        if(e.keyCode == 70){
            e.preventDefault(); 
            if(data_next_time_flag){
               data_next_time_flag = false;   
                /*if($("#fp").is(":checked")){ 
                    $("#fp").prop('checked', false);
                }else{
                    $("#fp").prop('checked', true); 
                }*/
                setTimeout("setDefaultDataNextFlag()",600);  
           } 
        }
          
     });
     //inicializarCursores("descrip"); 
     statusInfo();
     setTimeout('$("#ruc_cliente").focus()',500);
      
      /*
     if(moneda_cliente !== "G$" ){ 
         decimales = 2;
     }  */
     moneda = $("#moneda").val();
     if(moneda !== "G$" ){ 
         decimales = 2;
     } 
     if(touch){
       $("#cantidad").focus(function(){
          showNumpad("cantidad",setCantidad,false);
       });  
       $("#ruc_cliente").click(function(){
            if( !$(this).is('[readonly]')){
              showNumpad("ruc_cliente",buscarClienteTouch,true);
            }
       }); 
       $("#turno").click(function(){
           showNumpad("turno",setTurno,true);             
       });
       
     } 
     operacion = $("#operacion").val();
     if(touch && (operacion == "crear")){
          
        var abm_height = $("#abm_cliente").position().top + $("#abm_cliente").height();   
        $(".numpad").focus(function(){
            var id = $(this).attr("id");
            hideKeyboard();  
            var top = $(this).offset().top;
            var left = $(this).offset().left;             
            if(id == "fecha_nac"){
                $("#n_keypad .guion").val("/");
                $("#n_keypad .punto").val(".");
                showNumpad(id,checkFecha,true,0);  
            }else if(id == "ruc"){                
                $("#n_keypad .guion").val("-");
                $("#n_keypad .punto").val(".");
                showNumpad(id,checkRucCI,true,0);  
            }else{
                $("#n_keypad .guion").val("-");
                $("#n_keypad .punto").val(".");
                showNumpad(id,checkTelef,true,0);  
            }             
            $('#n_keypad').css({ 'top'  :top  ,'left' :left, 'margin-top': '-46px' });
        });
        $(".keyboard").click(function(){
            hideNumpad();
            showKeyboard(this,check,0,abm_height);
            if(!shift){    $(".capslock").trigger("click");     }    
        });
    } 
    // var pref = $("#pref_pago").val();
    var pref = "Contado";
    
    if(pref == "Contado" ){
        $("#contado").prop("checked",true);
        $("#tarjeta").prop("checked",false);
        $("#finalizar").prop("disabled",false); 
    }else if(pref == "Otros" ){
        $("#contado").prop("checked",false);
        $("#tarjeta").prop("checked",true);
        $("#finalizar").prop("disabled",false); 
    }else{
       $("#contado").prop("checked",false);
       $("#tarjeta").prop("checked",false); 
       $("#finalizar").prop("disabled",true); 
    }
    /*
    var cat = $("#categoria").val();
    if(cat > 2){
        getHistorialPrecios();
    }  */
    setHotKeyArticulo();      
    var auto_search = $("#auto_buscar_cliente").val();
    if(auto_search == "true"){
        buscarCliente("#nombre_cliente");
    }
    
/*******************Caja*********************/
        $(window).scroll(function(){
             $('#popup_caja').animate({top:$(window).scrollTop()+"px" },{queue: false, duration: 350});
         });
         $(".entrega").change(function(){
             var resto = 0;
             if($(this).attr("id")=="entrega_gs"){
                resto = $(this).val() % 50;    
             }
             if(resto > 0 ){
                 errorMsg("Ingrese en multiplos de 50 guaranies",8000)
             }
             var n = parseFloat( $(this).val() - resto ).format(2, 3, '.', ',') ;
             $(this).val( n  );
             if($(this).val() =="" || $(this).val() =="NaN" ){
                $(this).val( 0);
             } 
             setRef();
         }); 
         $("*[data-next]").keyup(function (e) {
             if (e.keyCode == 13) {
               var next =  $(this).attr("data-next");
               $("#"+next).focus();  
             } 
         }); 
         $(".efectivo").change(function(){
             showMult($(this).attr("id"));
         });
         $(".efectivo").on("focus",function(){  
            $(this).select()
         });
         $(".entrega_conv").change(function(){
             var voucher = $.trim($("#voucher").val());
             var monto_conv = float("monto_conv");
             if(voucher !="" && monto_conv > 0){
                 $("#add_conv").removeAttr("disabled");
             }else{
                 $("#add_conv").attr("disabled",true);
             }        
         });
         $(".plan_pago").click(function(){
             setPlanPago($(this).val());
         });
         
         $("#nro_cheque").mask("9999?99999999").css("text-transform","uppercase");
         $("#nro_cuenta").mask("****?********",{placeholder:""});
         $("#voucher").mask("****?99999999",{placeholder:""});
         //$("#benef").mask("***?********************************************************************************************************************************************",{placeholder:""});
         $("#fecha_emision").mask("99/99/9999");
         $("#fecha_pago").mask("99/99/9999");
         $("#fecha_ret").mask("99/99/9999");
         $("#fecha_inicio").mask("9?99");
         $("#fecha_trasnf").mask("99/99/9999"); 
         
         $("#orden_benef").mask("***?*********************************************",{placeholder:""});
         $("#monto_orden").mask("9?999999999");
         $("#nro_orden").mask("9?999999999");
           
         $("select > option:nth-child(even)").css("background","#F0F0F5"); // Color Zebra para los Selects
         $("#benef").css("text-transform","uppercase"); // Beneficiario en el Cheque todo en Mayusculas
         $("#ui_add_cheque input").change(function(){ checkCheque() });
         
         $("#convenios").change(function(){
             var val = $(this).val();
             var tipo =   $("#convenios option:selected").attr("data-tipo");
             if(val == 17){ // Retenciones
                 $(".retencion").fadeIn();
             }else{
                 $(".retencion").fadeOut();
             }
             
             if(tipo == "Asociacion"){
                $("#tipo_nro").html("N&deg; Orden:"); 
             }else if(tipo == "Tarjeta Credito" || tipo == "Tarjeta Debito" ){
                 $("#tipo_nro").html("N&deg; Voucher:"); 
             }if(tipo == "Criptomoneda"){
                 $("#tipo_nro").html("N&deg; Cupon:"); 
                 $("#voucher").unmask();
             }else{ // Retencion
                 $("#tipo_nro").html("N&deg; Retencion:"); 
             }
         });
         statusInfo();
         $( "#tabs" ).tabs();
         
         
         if($("#estado").val() !== "Cerrada"){
             $("#notas").removeAttr("readonly");
         } 

}
function showKeyPad(){
    showNumpad("lote",buscarCodigo,false);
}
function setCantidad(){
    var c = $("#cantidad").val().replace(".",",");    
    $("#cantidad").val(c);
    chequearDatos();
}
function setTurno(){
   $("#boton_generar").focus(); 
}
function checkFecha(){
   checkDate($("#fecha_nac"));    
   hideKeyboard();    
}
function checkRucCI(){    
   checkRUC($("#ruc"));    
   hideKeyboard();    
}
function checkTelef(){
   checkTel($("#tel"));    
   hideKeyboard();    
}
function check(){
    checkNombre($("#nombre"));
    hideKeyboard();    
}
function nuevoCliente(){  
    $("[data-error]").removeAttr("data-error");  
    hideKeyboard();  
    var window_width = $(document).width()  / 2;
    var abm_width = $("#abm_cliente").width()  / 2;        
    var posx = (window_width - abm_width) ;   
    $("#abm_cliente").css({left:posx,top:36});   
    $( "#abm_cliente" ).fadeIn();   
    $("#ruc").val( $("#ruc_cliente").val() );
    $("#nombre").val( $("#nombre_cliente").val() );
}
function buscarClienteTouch(){
    buscarCliente($("#ruc_cliente"));
}
function buscarClienteTouchNombre(){
    buscarCliente($("#nombre_cliente"));
}

function ocultar(){
     $( "#boton_generar" ).fadeOut("fast"); 
}
function mostrar(){     
    getCotiz();    
    
    $("#boton_nuevo_cliente").fadeOut();
    if($.trim($("#turno").val()).replace(/\D/g,'').length > 0){
        $("#boton_generar").fadeIn(); 
    }
     getLimiteCredito();   
}
function cambiarMonedaFactura(){ 
    var mon = $("#moneda").val();
    if(mon == "G$"){
        moneda = "U$";
        $("#moneda").val("U$");
        $(".cotiz").fadeIn();
        getCotiz();
    }else{
        moneda = "G$";
        $("#moneda").val("G$");
        $("#cotiz").val("1");
        $(".cotiz").fadeOut();
    } 
}
function verificarMoneda(){
    factura = $("#factura").val(); 
   
    totalizar();
    
    var mon = $("#moneda").val();
    if(mon === "G$"){
         decimales = 0;
         $(".cotiz").fadeOut();
    }else{
       decimales = 2; 
       getCotiz();
       $(".cotiz").fadeIn(); 
    }
    getLimiteCredito();
}
function setDefaultDataNextFlag(){
    data_next_time_flag = true;
}
function selectFalla(){
    $("#cm_falla").select(); 
    if($("#fp").is(":checked") ){
         $("#msg_codigo").addClass("infoblue").html("Ingrese la sobra en Centimetros"); 
    }else{
         $("#msg_codigo").addClass("infoblue").html("Ingrese la falla en Centimetros"); 
    } 
}

function cerrar(){
   $( "#ui_clientes" ).fadeOut("fast");
   $( "#boton_generar" ).fadeOut("fast");      
}

function getCotiz(){
  var moneda =  $("#moneda").val();
  if(moneda !== 'G$'){         
        $.ajax({
            type: "POST",
            url: "Ajax.class.php",
            data: {action:"getCotiz", suc: getSuc(),moneda:moneda },
            async: true,
            dataType: "json",
            beforeSend: function() {},
            success: function(data) {   
                if(moneda == 'U$'){
                   var dolares = data.Dolares.compra;   
                   $("#cotiz").val(dolares);
                }else if(moneda == 'R$'){
                   var reales = data.Reales.compra; 
                   $("#cotiz").val(reales);
                }else{
                   var pesos = data.Pesos.compra;
                   $("#cotiz").val(pesos);
                }             
            }
        });
    }    
}

function seleccionarCliente(obj){
    hideKeyboard();
    var cliente = $(obj).find(".cliente").html(); 
    var ruc = $(obj).find(".ruc").html();  
    var codigo = $(obj).find(".codigo").html();
    var cat = $(obj).find(".cat").html(); 
    var moneda = $(obj).find(".codigo").attr("data-moneda");
    var tipo_doc = $(obj).attr("data-tipo_doc");
    moneda_cliente = $(obj).find(".codigo").attr("data-moneda"); // Desabilitado temporalmente
    //moneda_cliente = "G$";
    
    $("#ruc_cliente").val(ruc);
    $("#nombre_cliente").val(cliente);
    $("#codigo_cliente").val(codigo);
    $("#categoria").val(cat);
    $("#tipo_doc").val(tipo_doc);
    $("#moneda").val(moneda); 
     
 
    getCotiz();
    //$("#cotiz").val(x);
    $( "#ui_clientes" ).fadeOut("fast");
    $("#msg").html(""); 
    $("#boton_nuevo_cliente").fadeOut();
    if($.trim($("#turno").val()).replace(/\D/g,'').length > 0){
        $("#boton_generar").fadeIn(); 
    } // Habilitar boton generar factura 
    $( "#turno").focus();
    getLimiteCredito();
}

function setFP(){
    var fp = $("#fp").is(":checked");    
    if(fp){        
       falla(true,"FP");$("#cm_falla").focus().select(); 
       max_mts_fp = 30;
    }else{  
       max_mts_fp = 0;
       $("#cod_falla").text(F); 
       if(F == ""){
            falla(false,F);
       }else{
          falla(true,F); 
       }
       $("#cm_falla").focus().select(); 
    }
}
    
function mostrarAreaDeCarga(factura){
    factura = factura;
    $("#msg").html("");
    $("#factura").val(factura); 
    $(".factura_inv").toggleClass("factura");
    $("#area_carga").fadeIn("fast");     
    $("#lote").focus();    
}

function crearFactura(){   
    hideKeyboard();  
    var usuario = getNick();
    var suc = getSuc();
    var cod_cli = $("#codigo_cliente").val();
    var nro_diag = $("#nro_diagnostico").val();  
     
    var moneda = $("#moneda").val();
    var cotiz = $("#cotiz").val();
    var notas = $("#notas").val();
     
    if(moneda != "G$"){
        decimales = 2;
    }
    
    var tipo_doc = $("#tipo_doc").val();   
    var estado = $("#estado").val(); 
    //var turno = parseFloat($("#turno").val()); //No utilizado
    var turno = 1;
    if(isNaN(turno)){
        errorMsg("Debe ingresar el Numero de Turno",8000);
        return;
    }
    
    if(cod_cli !=""){
       $("#boton_generar").remove();
       $("#ruc_cliente").attr("readonly","true");
       $("#nombre_cliente").attr("readonly","true");
       $(".currency").css("opacity","0");
       $(".currency").unbind("click");
       $(".currency").removeAttr("onclick");
     var  turnoData = {
        "id":"",
        "fecha":"",
        "llamada":""
     };
        $.ajax({
                type: "POST",
                url: "ventas/NuevaVenta.class.php",
                data: {"action":"crearFactura","usuario":usuario,"cod_cli":cod_cli,"suc":suc,"moneda":moneda,"cotiz":cotiz,estado:estado,notas:notas,turno:turno,"id":turnoData.id,"fecha":turnoData.fecha,"llamada":turnoData.llamada,nro_diag:nro_diag}, 
                async:true,
                dataType: "html",
                beforeSend: function(){
                    $("#msg").html("<img src='img/loading.gif' width='22px' height='22px' style='margin-bottom:-5px' >");                      
                }, 
                complete: function(objeto, exito){
                    if(exito=="success"){                                 
                      var factura =  $.trim(objeto.responseText) 
                      operacion = "editar";
                      $("#operacion").val("editar")
                      mostrarAreaDeCarga(factura);
                      if(nro_diag != ""){
                          $("#notas").val("Basado en Diagnostico Nro: "+nro_diag);
                      }
                      $(".turno").fadeOut();
                    }
                },
                error: function(){
                     $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
                }
        });  
       
       
    }else{
       $("#msg").toggleClass("error");
       $("#msg").html("Debe seleccionar un cliente v&aacute;lido");
    }     
}
 
function showMenores(){
    $(".info_titulo").css("background","yellow")
    $(".info_titulo").html("Sugerencia de cambio de lote");
    $(".similar").remove();               
    $("#articulos").fadeIn("fast");
}
function chequearDatos(){
    
    var lote = $("#lote").val();
    var codigo = $("#codigo").val();
    var stock = float("stock");
    var precio = float("precio_cat");
    var precio_venta = float("precio_venta");
    var cantidad = float("cantidad");
    var subtotal = (precio_venta * cantidad).format(decimales,20, '', '.');
    var subtotal_format = (precio_venta * cantidad).format(decimales,3, '.', ',');
    $("#subtotal").val(subtotal_format);
    
    var limiteCredito = parseFloat($("input#limite_credito").data('limite'));
    var limiteReal = parseFloat($("input#limite_credito").data('limiteReal'));
    var restantes = chequearLimite();
    var cm_falla = 0;   
    var gramaje = 1;
    var ancho = 1;
    var um = $("#um").val();   
    var fin_pieza = $("#estado_fp").html();
    var limite_stock_negativo = parseFloat($("#limite_stock_negativo").val());
     console.log("limite_stock_negativo  " +limite_stock_negativo);

    $("input#limite_credito").val((limiteCredito - subtotal).format(0,3,'.',','));
     
     console.log("(cantidad >= (stock - limite_stock_negativo)) "+ (cantidad >= (stock - limite_stock_negativo)));

    // Se desabilito la opcion de controlar que no deje bajar mas el precio que lo que corresponde a la categoria del cliente
    if(lote.length > 2 && codigo.length > 2  && stock > limite_stock_negativo /*&& (precio_venta >= precio) */ && ( ( (stock - limite_stock_negativo) >= cantidad) && (cantidad > 0) )  && restantes > 0   ){ 
       
        if($("#um").val()==="Kg" && (gramaje == 0 || ancho == 0)){
            $("#msg_codigo").html("Error de Gramaje, verifique los datos Gramaje o Ancho incorrectos...");
            $("#add_code").attr("disabled",true); 
            $("#msg_codigo").attr("class","error");  
            return;
       }else{ 
          $("#add_code").removeAttr("disabled");  
       } 
    }else{  
       $("#add_code").attr("disabled",true);  console.log("Paso 2");
    }
     
    if(cantidad > 0 ){ 
        if((stock > limite_stock_negativo) && (cantidad > (stock - limite_stock_negativo))){
             errorMsg("Stock insuficiente... esta superando el limite de venta negativo de: "+limite_stock_negativo,10000);
            $("#cantidad").focus();
            $("#cantidad").select();
            $("#cantidad").addClass("error");
            $("#add_code").attr("disabled",true);
        }else{
            $("#cantidad").removeClass("error");     
        }
    }else{
        $("#cantidad").removeClass("error");        
    }

    if((limiteCredito - subtotal) <= 0  && limiteReal > 0){
        errorMsg("Supero el limite de credito",10000);
        $("input#limite_credito").addClass("alerta");
    }else{
        $("input#limite_credito").removeClass("alerta");
    }

    if(restantes > 0){
        $("#msg_codigo").html("");
    }else{
       $("#msg_codigo").attr("class","error");  
       $("#msg_codigo").html("Ha llegado al Limite de piezas en esta Factura.");         
       $("#add_code").attr("disabled",true);  
       errorMsg("Ha llegado al Limite de piezas en esta Factura, Genere una nueva Factura.",10000);
    }

     
}
function getFallas(){
    
   
}
function chequearMtsFalla(){
    var cm_falla = float("cm_falla");
    var stock = float("stock");
    var cantidad = float("cantidad");
    if(cm_falla > (max_mts_fallas + max_mts_fp) || cm_falla < 0){        
        $("#add_code").prop("disabled",true);
        $("#msg_codigo").attr("class","error");  
        $("#msg_codigo").html("Falla solo puede ser hasta 30cm x cada falla + 30cm por Fin de Pieza");  
        $("#cm_falla").va("");
    }else{
        $("#msg_codigo").html("");
         $("#add_code").prop("disabled",false);
    }
    if(cm_falla > 0 && ((cantidad + (cm_falla / 100)) > stock )){
        var restante = parseFloat((stock - cantidad) * 100);
        if(restante > (max_mts_fallas + max_mts_fp)){
            restante = (max_mts_fallas + max_mts_fp);
        }
        $("#cm_falla").val( (restante).format(2, 20, '', '.')) ;
    }
    
}
function chequearLimite(){
    var limite_detalles = float("limite_detalles");
    
    //var cant_detalles = $(".codigo_lote").length;
    
    var hashes = {};

    $(".hash").each(function(){
        var hs =  $(this).attr("data-hash"); 
        var c = hashes[hs]; 
        if(c == undefined){ c = 0 };        
        hashes[hs] = c + 1; 
    });
    var cant_detalles = Object.keys(hashes).length; 
     
    //var cant_detalles = $(".codigo_lote").length;
    
    var restantes = limite_detalles - cant_detalles;
    var  pref_pago = $('input[name=forma_pago]:checked').val(); 
    if(cant_detalles > 0 && (pref_pago !== undefined)){
        $("#finalizar").removeAttr("disabled"); 
    }else{
        $("#finalizar").attr("disabled",true);
    }
    return restantes;
}
function limpiarAreaCarga(){
   $(".dato:not('#um')").val(""); 
   $("#add_code").attr("disabled",true);  
}
var detdesc = null; // Solo para uso depurativo
function addCode(){
    $("#add_code").attr("disabled",true);
    var factura = $("#factura").val();
    var lote = $("#lote").val().toUpperCase();
    var codigo = $("#codigo").val();
    var stock = float("stock");
    var um = $("#um").val();
    var ancho = float("ancho");
    var gramaje = float("gramaje");
    var descrip = $("#descrip").val();
    var precio = float("precio_cat");
    var precio_venta = float("precio_venta");
    var cantidad = float("cantidad");
    var subtotal = float("subtotal");
    var categoria = $("#categoria").val(); 
    var cod_falla = $("#cod_falla").text();
    var cm_falla = $("#cm_falla").val();
    var fp = false; //$("#fp").is(":checked");
    var um_prod = $("#um").attr("data-um_prod");
    var tipo_doc = $("#tipo_doc").val();
    var estado_venta = $("#lote").data("estado_venta");
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: {"action": "agregarDetalleFactura",usuario:getNick(),suc:getSuc(),"factura":factura, "codigo": codigo,"lote":lote,"um":um,"descrip":descrip,"precio_venta":precio_venta,"cantidad":cantidad,"subtotal":subtotal,"cat":categoria,"cod_falla":cod_falla,"cm_falla":cm_falla,"gramaje":gramaje,"ancho":ancho,fp:fp,um_prod:um_prod,tipo_doc:tipo_doc,estado_venta:estado_venta,mnj_x_lotes:mnj_x_lotes},
        async: true,
        dataType: "json",
        beforeSend: function() {
            $("#msg_codigo").html("<img src='img/loadingt.gif'>");     
        },
        success: function(data) {   
            var mensaje = data.Mensaje;
            if(mensaje == "Ok" || mensaje == "Codigo Duplicado" ){
               $(".grafico_fallas").fadeOut();
               $("#msg_codigo").html("<img src='img/ok.png'>");                
               $("#lote").val("");
               
               limpiarAreaCarga();
               var total = parseFloat(data.Total).format(decimales, 3, '.', ',') ; 
               var descuento = parseFloat(data.Descuento).format(decimales, 3, '.', ',') ; 
               var DescuentoNormal = parseFloat(data.DescuentoNormal).format(decimales, 3, '.', ',') ; 
               var cantf = cantidad.format(2, 3, '.', ',') ;  
               var preciof = precio_venta.format(decimales, 3, '.', ',') ;  
               var subtotalf = subtotal.format(decimales, 3, '.', ',') ;
               var total_sin_desc = parseFloat(data.Total_sin_desc) ; 
               var detalle_descuentos = data.DetalleDescuentos; 
               var desc_sedeco = parseFloat(data.DescuentoSEDECO).format(0, 3, '.', ',') ; 
               detdesc = detalle_descuentos;
               if(mnj_x_lotes === "No"){
                   lote = "";
               }
               if(mensaje == "Ok"){
                  appendDetail(codigo,lote,descrip,cantf,um,preciof,subtotalf,total,descuento,cod_falla,cm_falla,fp,estado_venta,desc_sedeco);
               }else{
                  detailUpdate(codigo,lote,cantidad,um,precio,total,descuento,cod_falla,cm_falla,fp,estado_venta,desc_sedeco);
               }
               var desc = parseFloat(data.DescuentoNormal) ;  
               
               console.log("subtotalf "+subtotalf+"  precio_venta "+precio_venta);
                 
               //$("#desc_sedeco").text(desc_sedeco); 
               //var porcentaje_descuento = parseFloat(data.Porc_desc) ; 
               if(categoria < 3){
                   if(total_sin_desc >= UMBRAL_VENTA_MINORISTA && desc > 50 && tipo_doc != CI_DIP ){
                       $("#msg_det").html("Descuento x compra > "+UMBRAL_VENTA_MINORISTA_FORMATTED+" Gs.");                                
                   }else{
                       $("#msg_det").html("");  
                   } 
               }
               
               corregirSubtotales(detalle_descuentos);  
               
               var restantes = chequearLimite();
               if(restantes == 0){
                    $("#msg_codigo").attr("class","error"); 
                    $("#msg_codigo").html("Ha llegado al Limite de piezas en esta Factura."); 
                    $("#add_code").attr("disabled",true);  
                    errorMsg("Ha llegado al Limite de piezas en esta Factura, Genere una nueva Factura.",10000)
               }
               $("#buscador_articulos").focus();
               getLimiteCredito();
            }else{
               $("#msg_codigo").attr("class","error"); 
               $("#msg_codigo").html(mensaje); 
               $("#lote").focus();$("#lote").select();
               $("#add_code").attr("disabled",true);  
            }            
        }
    }); 
}
function appendDetail(codigo,lote,descrip,cant,um,precio,subtotal,total,descuento,cod_falla,cm_falla,fp,estado_venta,desc_sedeco){       
    var falla = cm_falla!="0" &&  cm_falla!="" ? (cm_falla / 100)+"/F": "";
    if(fp){
      falla = cm_falla!="0" ? (cm_falla / 100)+"/F+FP": "0/FP";
    }    
    var h =   precio.toString().replace(".","").replace(",","");
    var hash = codigo+"_"+h;
  
    $(".tr_total_factura").remove();
    $("#detalle_factura").append('<tr id="tr_'+codigo+'-'+lote+'" class="hash" data-hash="'+hash+'" ><td class="item codigo_art">'+codigo+'</td> <td class="item codigo_lote mnj_lote" data-codigo="'+codigo+'" title="'+codigo+'" >'+lote+'</td><td class="item '+estado_venta+'">'+descrip+'</td><td class="num cantidad">'+cant+'</td><td  class="itemc">'+um+'</td><td  class="itemc fx">'+falla+'</td><td class="num precio_venta">'+precio+'</td><td class="num descuento">0</td><td class="num subtotal_det">'+subtotal+'</td><td class="itemc"><img class="del_det trash" title="Borrar Esta Pieza" style="cursor:pointer" src="img/trash_mini.png" onclick=delDet("'+codigo+'","'+lote+'");></td></tr>');
    $("#detalle_factura").append('<tr class="tr_total_factura" style="font-weight: bolder"><td >&nbsp;Totales</td> <td id="msg_det" style="text-align: center;font-size: 11" class="info"></td><td id="total_cantidades" style="text-align: right;" class="num"></td><td colspan="2" style="text-align: center"><label class="sedeco"><b>Redondeo SEDECO:</b></label>&nbsp;<label class="sedeco" id="desc_sedeco">'+desc_sedeco+'</label><b class="sedeco">&nbsp;G$.</b></td><td id="descuento_factura" style="text-align: right;" class="num descuento">'+descuento+'</td><td style="text-align: right;" id="total_factura" class="num">'+total+'&nbsp;'+moneda+'.</td><td style="text-align:center"><img src="img/medios_pago.png" height="18" width="18" style="cursor:pointer" onclick="verMonedasExtranjeras()"></td> </tr>');
}

function detailUpdate(codigo,lote,cantidad,um,precio,total,descuento,cod_falla,cm_falla,fp,estado_venta,desc_sedeco){       
    var falla = cm_falla!="0" &&  cm_falla!="" ? (cm_falla / 100)+"/F": "";
    if(fp){
      falla = cm_falla!="0" ? (cm_falla / 100)+"/F+FP": "0/FP";
    }    
    var h =   precio.toString().replace(".","").replace(",","");
    var hash = codigo+"_"+h;
    
    var cant_linea = parseFloat( $("#tr_"+codigo+"-"+lote).find(".cantidad").text().replace(/\./g, '').replace(/\,/g, '.') ); 
    var new_cant = parseFloat(cant_linea + cantidad);
    var new_subtotal = new_cant * precio;
    
    var cantf = new_cant.format(2, 3, '.', ',') ;  
    var preciof = precio.format(decimales, 3, '.', ',') ;  
    var subtotalf = new_subtotal.format(decimales, 3, '.', ',') ;
    
    $("#tr_"+codigo+"-"+lote).find(".cantidad").html(cantf);
    $("#tr_"+codigo+"-"+lote).find(".precio_venta").html(preciof);
    $("#tr_"+codigo+"-"+lote).find(".subtotal_det").html(subtotalf);
    
  
    $(".tr_total_factura").remove();
    
    $("#detalle_factura").append('<tr class="tr_total_factura" style="font-weight: bolder"><td >&nbsp;Totales</td> <td id="msg_det" style="text-align: center;font-size: 11" class="info"></td><td id="total_cantidades" style="text-align: right;" class="num"></td><td colspan="2" style="text-align: center"><label class="sedeco"><b>Redondeo SEDECO:</b></label>&nbsp;<label class="sedeco" id="desc_sedeco">'+desc_sedeco+'</label><b class="sedeco">&nbsp;G$.</b></td><td id="descuento_factura" style="text-align: right;" class="num descuento">'+descuento+'</td><td style="text-align: right;" id="total_factura" class="num">'+total+'&nbsp;'+moneda+'.</td><td style="text-align:center"><img src="img/medios_pago.png" height="18" width="18" style="cursor:pointer" onclick="verMonedasExtranjeras()"></td> </tr>');
}

function corregirSubtotales(detalle_descuentos){ 
   //console.log(detalle_descuentos.length);   
   detalle_descuentos.forEach(function(e){
       var codigo = e.codigo;
       var lote = e.lote;
       var desc = parseFloat(  e.descuento) .format(1, 3, '.', ',') ;  
       var subtotal = parseFloat(e.subtotal).format(decimales, 3, '.', ',') ;
       //console.log(lote+"   "+desc+"   "+subtotal);
       $("#tr_"+codigo+"-"+lote).find(".descuento").html(desc);
       $("#tr_"+codigo+"-"+lote).find(".subtotal_det").html(subtotal);
   });       
   totalizar();
} 

function totalizar(){    
    var total = 0;
    var total_descuento = 0;
    var total_cantidades = 0;
    $(".cantidad").each(function(){ 
        var cant =  parseFloat( $(this).text().replace(/\./g, '').replace(/\,/g, '.')  );
        var precio=  parseFloat(  $(this).next().next().next().text().replace(/\./g, '').replace(/\,/g, '.') ); 
        var descuento=  parseFloat(  $(this).next().next().next().next().text().replace(/\./g, '').replace(/\,/g, '.') ); 
        total_descuento +=descuento;
        var subtotal = parseFloat((cant * precio ) - descuento) ;    
        console.info(cant +"  "+precio+ "  "+descuento +" = "+total_descuento);
        total += subtotal;  
        total_cantidades += cant;
    }); 
    //console.info("Total: "+total);
    //console.info("Total_descuento: "+total_descuento); 
    var desc_sedeco = parseFloat( $("#desc_sedeco").text()); 
    //console.info("desc_sedeco  "+desc_sedeco); 
     
    total -= desc_sedeco;
    
    var total_format = (total).format(decimales, 3, '.', ',');
    
    console.info("total_format  "+total_format+"    decimales: "+decimales); 
    var total_descuento_format = (total_descuento).format(1, 3, '.', ',');
    total_cantidades = (total_cantidades).format(2, 3, '.', ',');  
    
        
    $("#total_factura").html(""+total_format+"&nbsp;"+moneda+".");        
    $("#descuento_factura").html(total_descuento_format);
    $("#total_cantidades").html(total_cantidades);
    
    if($("[name=moneda_pago]:checked").length > 0){
        var mon = $("[name=moneda_pago]:checked").attr("id").substring(7,9);
        var cotiz = float("cotiz_"+mon);
        var total_me = (total / cotiz).format(2, 3, '.', ','); 
        $("#total_me").val(total_me+" "+mon.toUpperCase().replace("S","$")+".");     
    }
    if(desc_sedeco > 0){
        $(".sedeco").fadeIn();
    }else{
        $(".sedeco").fadeOut();
    }
    $("#lote").focus();
}
function delDet(codigo,lote){
 var tipo_doc = $("#tipo_doc").val();  
 var cod_desc = $("#cod_desc").val();
 $( "#dialog-confirm" ).dialog({
      resizable: false,
      height:140,
      modal: true,
      dialogClass:"ui-state-error",
      buttons: {
        "Cancelar": function() {
          $( this ).dialog( "close" );
        },  
        "Borrar esta Pieza": function() {
            $( this ).dialog( "close" );   
            var factura = $("#factura").val();
            var categoria = $("#categoria").val();
            $.ajax({
                type: "POST",
                url: "Ajax.class.php",
                data: {"action": "borrarDetalleFactura", "factura": factura,"codigo":codigo,"lote":lote,"cat":categoria,tipo_doc:tipo_doc,cod_desc:cod_desc},
                async: true,
                dataType: "json",
                beforeSend: function() {
                    $("#msg").html("<img src='img/loadingt.gif' > <img src='img/delete.png' >"); 
                },
                success: function(data) {   
                    var mensaje = data.Mensaje;
                    if(mensaje == "Ok"){
                        var total = parseFloat(data.Total).format(decimales, 3, '.', ',') ; 
                        var descuento = parseFloat(data.Descuento).format(decimales, 3, '.', ',') ; 
                         
                        if(isNaN(total)){
                            total = 0;
                            $("#desc_sedeco").text("0");
                            
                        }else{
                            var total_sin_desc = parseFloat(data.Total_sin_desc) ; 
                            var desc = parseFloat(data.Descuento) ; 
                            //var porcentaje_descuento = parseFloat(data.Porc_desc) ; 
                            if(categoria < 3){
                               if(total_sin_desc >= UMBRAL_VENTA_MINORISTA && desc > 0 && (tipo_doc != CI_DIP) ){
                                   $("#msg_det").html("Descuento x compra > "+UMBRAL_VENTA_MINORISTA_FORMATTED+" Gs.");                                
                               }else{
                                   $("#msg_det").html("");  
                               } 
                            }
                        }
                        var detalle_descuentos = data.DetalleDescuentos;
                        corregirSubtotales(detalle_descuentos);  
                        detdesc = detalle_descuentos;
                        $("#tr_"+codigo+"-"+lote).remove();
                        
                        console.log("tr_"+codigo+"-"+lote);
                         
                        chequearLimite();
                        $("#lote").focus();
                        $("#msg").html(""); 
                        getLimiteCredito();
                        totalizar();
                    }else{
                        alert("Mensaje: "+mensaje+"  Cierra la ventana.");
                    }
                }
            });
        } 
     },        
    Cancel: function() {
      $( this ).dialog( "close" );
    }
 });    
     
}
function cambiarUM(){
   if(um_cursor > um_lista_precios.length - 1){
       um_cursor = 0;
   } 
   $("#um").val(um_lista_precios[um_cursor].um);
   var precio = um_lista_precios[um_cursor].precio;
   var descuento = um_lista_precios[um_cursor].descuento;
   var mult = um_lista_precios[um_cursor].um_mult;
   var stock = parseFloat($("#stock").attr("data-stock"));
   
   $("#stock").val(  parseFloat( stock / mult  ).format(2, 3, '.', ',')   );
   
   var preciox = redondear50(parseInt(precio - descuento));  
   if(moneda != "G$"){  // No se redondea si es USS
        preciox =  parseFloat(precio - descuento);
   } 
   var precio = parseFloat(  preciox  ).format(decimales, 3, '.', ',');
   $("#precio_cat").val(precio);
   $("#precio_cat").attr("data-precio",precio);
   $("#precio_venta").val(precio);
   um_cursor++;   
}
function noUm(bool){
    if(bool){
       $("#change_um").css("opacity","1").css("cursor","pointer");
       $("#change_um").click(function(){
           cambiarUM();
       });
    }else{
       $("#change_um").css("opacity","0").css("cursor","not-allowed");
       $("#change_um").unbind("click");
       $("#change_um").removeAttr("onclick");
       um_original = "";
       cantidad_original = 0;
       factorPrecio = 1;
       precioOriginal = 0;
       //falla(false,"F");
       $("#precio_cat").attr("data-precio",parseFloat( 0 ).format(2, 3, '.', ',')); 
       $("#msg_codigo").removeClass("infoblue").html("");
       
       //$("#fp").removeAttr("checked");
    } 
}
function falla(bool,cod_falla){
   var visible = "hidden";
   bool?visible = "visible":"hidden";
   $(".grafico_fallas").fadeOut();       
   $(".falla").css("visibility",visible);  
   $("#cod_falla").text(cod_falla);
   $("#cm_falla").val("");
}

function buscarCodigo(){   
    var FP = "";
    limpiarAreaCarga();
    var lote = $("#lote").val();
    var suc = getSuc();    
    var categoria = $("#categoria").val();
    var moneda = $("#moneda").val();
    var um = $("#um").val();   
    
    if(lote != ""){
        if( $("#tr_"+lote).length > 0){
            $("#msg_codigo").html("Codigo Duplicado!!!").addClass("error");
            return;
        }
    $("#info").fadeIn("fast"); 
         
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: {"action":"buscarDatosDeCodigo","lote":lote,"categoria":categoria,"suc":suc,moneda:moneda,um:um}, 
        async:true,
        dataType: "json",
        beforeSend: function(){
           noUm(0);
           $("#msg_codigo").html("<img src='img/loadingt.gif' >");             
        },
        success: function(data){ 
            var existe = data.existe;
            $("#msg_codigo").attr("class","info");
            if( existe === "true" ){
                var Status = data.estado_venta; // Bloqueado,Normal,Oferta,Arribos,FP
                var stock = data.stock == null?0:data.stock; 
                    console.log(isNaN(data.stock));
                console.log( data.stock == null);
                $("#codigo").val(data.codigo); 
                $("#descrip").val(data.descrip);
                
                $("#stock").val(  parseFloat( stock  ).format(2, 3, '.', ',')   );
                $("#stock").attr("data-stock",parseFloat( stock  ));
                $("#lote").prop("title","Codigo Art: "+stock)
                $("#lote").data("estado_venta",Status);
                $("#descrip").prop("title","Codigo Art: "+data.codigo);                
                $("#um").val(data.um_venta); 
                
                art_inv =   JSON.parse(data.art_inv);
                mnj_x_lotes =   data.mnj_x_lotes ;
                
                if(Status != 'FP' && Status != 'Bloqueado'){
                   $("#cantidad").removeAttr("disabled")
                }else{
                    $("#cantidad").attr("disabled",true);
                }
                 
                var cotiz = $("#cotiz").val();
                
                
                var precio = data.precio;
                var descuento = data.descuento;
                 
                um_lista_precios = data.um_lista_precios;
                
                
                if(um_lista_precios.length > 1){
                    noUm(1);
                }else{
                    noUm(0);
                }
                
                
                var preciox = redondear50(parseInt(precio - descuento));  
                if(moneda != "G$"){  // No se redondea si es USS
                     preciox =  parseFloat(precio - descuento);
                } 
                var precio = parseFloat(  preciox  ).format(decimales, 3, '.', ',');
                
                console.log("preciox "+preciox+"  precio "+precio);
                
                var ancho = parseFloat(  data.ancho ).format(2, 3, '.', ',');
                var gramaje = parseFloat(  data.gramaje ).format(2, 3, '.', ',');
                
                if(Status == "FP"){
                   FP = "FP";
                   $("#estado_fp").fadeIn();
                }else{
                   FP = "";
                   $("#estado_fp").fadeOut();
                }                  
                    
                cantidad_original = data.stock;
                precioOriginal = data.precio;
                /*
                   if(((um==="Mts" && categoria > 4) || um==="Kg") && data.ancho > 0 && data.gramaje > 0 ){  
                }*/
                                
                
                $("#um").attr("data-um_prod",data.um_prod);
                $("#ancho").val(ancho);  
                $("#gramaje").val(gramaje);  
                
                $("#precio_cat").val(precio);
                $("#precio_cat").attr("data-precio",precio);
                $("#precio_venta").val(precio);
                
                 
                $("#estado_fp").html(FP);  
                
                if(precio > 0){                
                   $("#cantidad").focus();
                   $("#cantidad").select();    
                }else{
                   $("#precio_venta").focus();
                   $("#precio_venta").select();  
                }
                
                data_next_time_flag = false;
                if(Status !='Bloqueado' && Status !='FP'){
                   $("#msg_codigo").html("<img src='img/ok.png'>"); 
                   if( art_inv ){buscarStockComprometido(lote);}
                }else{
                   $("#msg_codigo").addClass("error");
                   $("#msg_codigo").html("Codigo Bloqueado para Ventas! Consulte con compras...");    
                }
                
                var imagen = data.img; 
                $("#imagen_lote").fadeIn("fast");
                if(imagen != ""){
                    
                    if(mnj_x_lotes == "Si"){
                       var images_url = $("#images_url").val();
                       $("#imagen_lote").attr("src",images_url+"/"+imagen+".thum.jpg"); 
                       $("#imagen_lote").click(function(){ cargarImagenLote(imagen);});
                    }else{
                        $("#imagen_lote").attr("src",""+imagen+""); 
                    }
                    
                }else{
                   $("#imagen_lote").attr("src","img/no-image.png"); 
                   $("#imagen_lote").off("click");
                }                
                
                if(data.um_venta != um && um != ""){
                    $("#msg_codigo").addClass("error");
                    $("#msg_codigo").html("No se ha definido precios para esta unidad de Medida: "+um);  
                    errorMsg("No se ha definido precios para esta unidad de Medida: "+um,12000);  
                }
                
                if(precio <= 0){                    
                   errorMsg("Precio no definido para esta unidad de medida...");  
                }
                
                setTimeout("setDefaultDataNextFlag()",500);
               
            }else{
                $("#msg_codigo").addClass("error");
                $("#msg_codigo").html("Codigo no encontrado o Bloqueado");                
                $("#imagen_lote").attr("src","img/no-image.png");
                $("#imagen_lote").fadeOut("fast");
                //limpiarAreaCarga();
                $("#lote").focus(); 
                $("#info").fadeOut("fast"); 
            }
        },
        error: function(e){ 
           $("#msg_codigo").addClass("error");
           $("#msg_codigo").html("Error en la comunicacion con el servidor:  "+e);
        }
    });
    }else{
         $("#info").fadeOut("fast");
    } 
}
function showFalla(calc_pos_falla,tipo_falla){
    $('#total_vender').append("<div style='margin-left:"+calc_pos_falla+"%'> <span class='falla_indic' >"+tipo_falla+"</span></div> ");
}


function buscarStockComprometido(lote){
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: {"action": "buscarStockComprometido", lote: lote,suc:getSuc(),"incluir_reservas":"No"},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            $("#stock_comprometido").html("");
            $("#stock_compr").html("");
        },
        success: function (data) {   
            var comprometido = 0;
            var st_comp = "<table class='stock_comprometido' border='1'>";
            st_comp+="";
            if(data.length > 0){
                var st_comp = "<table class='tabla_stock_comprometido' border='1'>";
                st_comp+="<tr><th colspan='6' style='background:lightskyblue;'>Stock Comprometido</th><th style='text-align:center;background:white'>X</th></tr>";
                st_comp+="<tr class='titulo' style='font-size:10px'><th>Doc</th><th>Factura</th><th>Usuario</th><th>Fecha</th><th>Suc</th><th>Estado</th><th>Cantidad</th><tr>";
                for (var i in data) {
                    var tipodoc = data[i].TipoDocumento;
                    var nro = data[i].Nro;
                    var usuario_ = data[i].usuario;
                    var fecha = data[i].fecha;
                    var suc = data[i].suc;
                    var estado = data[i].estado;
                    var cantidad = data[i].cantidad;
                    comprometido += parseFloat(cantidad);
                    st_comp+="<tr style='background:white'><td>"+tipodoc+"</td><td>"+nro+"</td><td>"+usuario_+"</td><td>"+fecha+"</td><td class='itemc'>"+suc+"</td><td>"+estado+"</td><td class='num'>"+cantidad+"</td></tr>";
                }   
                 
                var stock_limpio = float("stock") - comprometido;
                $("#stock").val(  parseFloat( stock_limpio  ).format(2, 3, '.', ',')   );
                $("#stock_compr").html("<img src='img/warning_red_16.png' onclick='verStockComprometido()' title='Alguien mas tiene cargada esta pieza en una Factura!'>");
                $("#stock_comprometido").html(st_comp);
                $(".tabla_stock_comprometido").click(function(){
                    verStockComprometido();
                });
            }
            $("#msg").html(""); 
        }
    });
}
function verStockComprometido(){
    $("#stock_comprometido").toggle();
}
function scrollCliente(sign){
    $('#cli_content').animate({
        scrollTop: ""+sign+"=250px"
    });
}
function recargar(){
    cargarFactura($("#factura").val());
}
function establecerPrecioCat(factura,pref_pago,categoria,cod_desc){
    var tipo_doc = $("#tipo_doc").val();    
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: {"action": "establecerPrecioCat", "factura": factura, "pref_pago": pref_pago,categoria:categoria,tipo_doc:tipo_doc,cod_desc:cod_desc},
        async: true,
        dataType: "html",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        complete: function (objeto, exito) {
            if (exito == "success") {                          
                var result = $.trim(objeto.responseText);
                if(result === 'Ok'){
                    cargarFactura(factura);
                    $("#msg").html(result); 
                }else{
                    alert(result);
                }
                totalizar();
            }
        },
        error: function () {
           errorMsg("Ocurrio un error en la comunicacion con el Servidor...");
        }
    }); 
}
function cargarFactura(factura){ // console.log("cargarFactura FacturaVenta");
    var usuario = getNick(); 
    var session = getCookie(usuario).sesion;    
    load("ventas/FacturaVenta.class.php",{usuario:usuario,session:session,factura:factura,suc:getSuc()}, function(){    
        $("#area_carga").fadeIn("fast",function(){           
        setTimeout( "verificarMoneda()",500); 
    });   
    } );
}
function setPrefPago(){
    var cod_desc = $("#cod_desc").val();    
    var tipo_doc = $("#tipo_doc").val();    
    var factura = $("#factura").val();
    $("#finalizar").attr("disabled",true);
    var pref_pago = $('input[name=forma_pago]:checked').val();
    var categoria = $("#categoria").val();
    var msg_pref = "Preferencia de pago establecida a Contado";
    
    
    if(pref_pago==="Otros"){
        
        if(cod_desc == 2){
            errorMsg("Solo ser permite pagos al Contado para Ventas discriminadas!",10000);
            return;   
        }else if(cod_desc == 3){
            if(categoria < 3){
                establecerPrefPago(factura,pref_pago,categoria,tipo_doc,msg_pref);
            }else{
               var c = confirm("Pagando con Tarjeta o Cheque Diferido se eliminaran los descuentos y se establecera el Precio 2, Esta seguro que desea continuar?");
               if(c){
                 $("#cod_desc").val(0);
                 establecerPrecioCat(factura,pref_pago,2,0);            
               }
            }
        }else{
            
           if(categoria > 2){ //Cat 3-7
              $.post( "Ajax.class.php",{ action: "setPrefPagoOnly",factura:factura,pref_pago:pref_pago}, function( data ) {
                establecerPrecioCat(factura,pref_pago,2,0);    
              });              
           } else{   
               msg_pref = "Preferencia de pago establecida...";
               if(categoria < 2){  // Cat 1
                  establecerPrefPago(factura,pref_pago,categoria,tipo_doc,msg_pref);
               }else{ // Cat 2
                  borrarDescuentos(); 
                   
                  establecerPrecioCat(factura,pref_pago,1,0);    
               }
           }
        }        
    }else{// Contado  
       if(categoria > 2){
           if(cod_desc < 2){ // 0 Sin descuento 1 
               $.post( "Ajax.class.php",{ action: "setPrefPagoOnly",factura:factura,pref_pago:pref_pago}, function( data ) {
                 establecerPrecioCat(factura,pref_pago,categoria,0);  
                  
               });          
           }else{// 2 Discriminadas y 3 Mayoristas
               establecerPrefPago(factura,pref_pago,categoria,tipo_doc,msg_pref); 
           }
       }else{ 
         establecerPrefPago(factura,pref_pago,categoria,tipo_doc,msg_pref); 
       }
      
    } 
}
function establecerPrefPago(factura,pref_pago,categoria,tipo_doc,msg_pref){
    $.ajax({
                type: "POST",
                url: "Ajax.class.php",
                data: {"action": "setPrefPago", "factura": factura,"pref_pago":pref_pago,"categoria":categoria,tipo_doc:tipo_doc},
                async: true,
                dataType: "json",
                beforeSend: function() {
                    $("#msg_codigo").html("<img src='img/loadingt.gif' >"); 
                    $("#desc_sedeco").text("0"); 
                },
                success: function(data) {   
                    var mensaje = data.Mensaje;
                    if(mensaje == "Ok"){
                    var total = parseFloat(data.Total).format(0, 3, '.', ',') ; 
                    var descuento = parseFloat(data.Descuento).format(0, 3, '.', ',') ; 
                    var desc_sedeco = parseFloat(data.DescuentoSEDECO).format(0, 3, '.', ',') ; 
                    $("#desc_sedeco").text(desc_sedeco);  
                    if(isNaN(data.Total)){  console.warn("data.Total is NaN");
                        total = 0;
                        corregirSubtotales(new Array());
                    }else{
                        var total_sin_desc = parseFloat(data.Total_sin_desc) ; 
                        var desc = parseFloat(data.Descuento) ; 
                        var porcentaje_descuento = parseFloat(data.Porc_desc) ; 
                        
                        console.log("total_sin_desc: "+total_sin_desc+"  desc "+desc+"  "+porcentaje_descuento);
                        if(categoria < 3){  
                           if(total_sin_desc >= UMBRAL_VENTA_MINORISTA && desc > 0 && tipo_doc != CI_DIP ){
                               $("#msg_det").html("Descuento x compra > "+UMBRAL_VENTA_MINORISTA_FORMATTED+" Gs.");                                
                           }else{
                               $("#msg_det").html("");  
                           }  
                        }
                        var detalle_descuentos = data.DetalleDescuentos;
                        corregirSubtotales(detalle_descuentos); console.log("corregirSubtotales   "   );
                    } 
                    
                    $("#msg_codigo").addClass("info");
                    $("#msg_codigo").html(msg_pref); 
                    $("#finalizar").removeAttr("disabled");
                }else{
                    alert(mensaje);
                }
                }
            });                
}

function finalizar(){
   totalizar(); 
   var tipo_doc = $("#tipo_doc").val();
   var items = $(".hash").length;
   var total_factura =   $("#total_factura").html().substring(0,$("#total_factura").text().indexOf("$")-2);
   var descuento = $("#descuento_factura").html(); 
   if( items > 0){ 
   $("#finalizar").attr("disabled",true);
   var factura = $("#factura").val();
   var cliente = $("#nombre_cliente").val();
   var ruc = $("#ruc_cliente").val(); 
   var suc = getSuc();
   var pref_pago = $('input[name=forma_pago]:checked').val();
   
   var total_moneda_ext = "";
   var moneda_ext = "";
        
   if($("[name=moneda_pago]:checked").length > 0){
        var mon = $("[name=moneda_pago]:checked").attr("id").substring(7,9);
        var cotiz = float("cotiz_"+mon);
        var total = $("#total_factura").html().substring(0,$("#total_factura").text().indexOf("$")-2).replace(/\./g, '');
        var total_me = (total / cotiz).format(2, 3, '.', ','); 
        $("#total_me").val(total_me+" "+mon.toUpperCase().replace("S","$")+".");  
        total_moneda_ext = total_me;
        moneda_ext = mon.toUpperCase().replace("S","s"); 
    }
   
   var t = $('<iframe id="ticket" name="ticket" style="width:0px; height:0px; border: 0px" src="ventas/TicketVenta.class.php?factura='+factura+'&cliente='+cliente+'&ruc='+ruc+'&suc='+suc+'&pref_pago='+pref_pago+'&total_factura='+total_factura+'&descuento='+descuento+'&total_moneda_ext='+total_moneda_ext+'&moneda_ext='+moneda_ext+'" ></iframe>');
  // t.appendTo("#work_area");
   
   //window.open("ventas/Ticket.class.php?factura="+factura+"&cliente="+cliente+"&ruc="+ruc+"&suc="+suc+"","Ticket de Venta","width=400,height=560,scrollbars=yes"); 
    var show_menu = true;
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: {"action": "finalizarVenta", "factura": factura,"pref_pago":pref_pago, usuario:getNick(),tipo_doc:tipo_doc},
        async: true,
        dataType: "html",
        beforeSend: function() {
            $("#msg_codigo").html("<img src='img/loadingt.gif'>");                      
        },
        complete: function(objeto, exito) {
            if (exito == "success") { 
                var result =  $.trim(objeto.responseText).replace(/\|/g,"\n");
                
                if(result == "Ok"){
                    t.appendTo("#work_area");                     
                    alert("La Factura ha sido enviada a caja..."); 
                    genericLoad("caja/VentasEnCaja.class.php");    
                }else{
                    alert("Hubieron algunos errores en el Procesamiento: Favor verifique la informacion de abajo: \n"+result);
                }   
            }
        },
        error: function() {
            $("#msg_codigo").html("Ocurrio un error en la comunicacion con el Servidor intente de nuevo...");
            $("#finalizar").removeAttr("disabled");
        }
    });  
   }else{
       errorMsg("Debe cargar al menos un Articulo para poder cerrar!",10000);  
   } 
}
function volverAlMenu(){
    try {      
       $("#dialog-confirm").dialog("destroy");      
        showMenu();   
    }catch(err) {
       // Ya se cerro antes  
    }
}
function borrarDescuentos(){
  $(".descuento").each(function(){
       $(this).html(0);
  }); 
  totalizar();
}
function discriminarPrecios(){
     var tipo_doc = $("#tipo_doc").val();
     var factura = $("#factura").val();
     var categoria = $("#categoria").val();
     if(categoria < 3){
     $("#cod_desc").val(2); // Ver tabla descuentos
     
     resaltarSimilares(); 
     $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: {"action": "discriminarPrecios",factura:factura,usuario: getNick(), tipo_doc: tipo_doc,suc:getSuc()},
        async: true,
        dataType: "html",
        beforeSend: function () {
            $("#discriminar").attr("disabled",true);
            $("#msg_codigo").html("Discriminando...<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        complete: function (objeto, exito) {
            if (exito == "success") {                          
                var result = $.trim(objeto.responseText);
                if(result === 'Ok'){
                    $("#msg_codigo").html(result+" El vendedor puede Finalizar...");
                    borrarDescuentos();
                    alert("Se recargara la factura para actualizar la vista");
                    recargar();
                }else{
                    alert(result);
                }
            }else{
                $("#msg_codigo").html("Ocurrio un error en la comunicacion con el Servidor...");
            }
        },
        error: function () {
            $("#msg_codigo").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    }); 
    }else{
       errorMsg("No se puede Discriminar Precios para categoria > 2, utilize Venta Mayorista!",10000);   
    }        
}
function resaltarSimilares(){
    $(".codigo_lote, .precio_venta").mouseover(function(){    
        $(".same_code").removeClass("same_code");  
        var codigo = $(this).parent().children().attr("data-codigo");      
        $("[data-codigo="+codigo+"]").each(function(){
             $(this).parent().addClass("same_code");
        });  
    });
    $("#detalle_factura").mouseout(function(){
       $(".same_code").removeClass("same_code");
    });       
}
// UI Modificar
function ventaMayorista(){     
    
    var c = confirm("Se borraran los descuentos por linea para Modificar los Precios por Grupo de Articulos, este procedimiento no es reversible.");
    if(c){
    
    $("#mayorista").attr("disabled",true);
    $("#discriminar").attr("disabled",true);    
    infoMsg("Haga clic en los Precios...",10000);
    $("#cod_desc").val(3); // Ver tabla descuentos
    borrarDescuentos(); 
    resaltarSimilares(); 
     
    
    $(".precio_venta").click( function(){        
        $(".same_code").removeClass("same_code");  
        var codigo = $(this).parent().children().attr("data-codigo");     
        $("#loteActual").val($($(this).closest('tr')).prop("id"));

        var precio =parseFloat( $(this).html().replace(/\./g,"").replace(/,/g,"."));//parseFloat( $(this).html().replace(".",""));

        $("#codigo_en_edicion").val(codigo);
        $("#codigo_en_edicion").attr("data-precio_edit",precio);
        
        
        var position_tr = $(this).offset();
        var pie = $(this).width() / 2; 
        var width = $("#div_pv_mayorista").width() / 2;
        var boton = $(this).position(); 
        var top = position_tr.top;
        
        
        $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: {"action": "getPrecioPromedioCodigo", codigo : codigo},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) { 
              
            var AvgPrice = precio;
              
            if(data.length > 0 ){ 
               var ItemCode = data[0].ItemCode;
                AvgPrice =  parseFloat(data[0].AvgPrice).format(0, 30, '.', ',') ;                      
            }else{
                AvgPrice = precio;
            }
           
            
            $("#p_valmin").val( AvgPrice * PORC_VALOR_MINIMO);
            $("[data-codigo="+codigo+"]").each(function(){
                   $(this).parent().addClass("same_code");
                   $(this).parent().attr("data-precio_promedio",AvgPrice);             
             }); 
              
            $("#msg").html("");  

            $("#div_pv_mayorista").css("margin-left",boton.left + pie - width); 
            $("#div_pv_mayorista").css("margin-top",top-44);      
            $("#div_pv_mayorista").fadeIn();   
            $("#pv_mayorista").val(precio);
            
            //console.log($("#pv_mayorista").val());
            
            $("#pv_mayorista").change(function(){
                if($("#redondear50").is(":checked")){
                   //console.log($("#pv_mayorista").val());
                   var v = $(this).val().replace(".","").replace(",",".");
                   var red = redondear50(v);
                   $("#pv_mayorista").val(red)
                }
            });            
            $("#pv_mayorista").focus();
        }
       });                
    });     
    }
}
function getHistorialPrecios(){
    var cod_cli = $("#codigo_cliente").val();
    var factura = $("#factura").val();
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: {"action": "getPrecioVentaAnterior", cod_cli: cod_cli,factura:factura},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {   
            for (var i in data) { 
                var codigo = data[i].codigo;
                var precio = data[i].precio;
                $('tr[data-hash^="'+codigo+'"]').each(function(){
                   $(this).find(".precio_venta").attr("title","Ultimo precio de venta "+precio+" Gs");      
                });
            }   
            $("#msg").html(""); 
            setAnchorTitle();
        }
    });
     
}
function actualizarPrecioMayorista(){
    
    var codigo = $("#codigo_en_edicion").val();
    //var precio = $("#codigo_en_edicion").attr("data-precio_edit");
    
    var nuevo_precio = float( "pv_mayorista");
    var valor_minimo = parseFloat( $("#p_valmin").val() );
    
    if(nuevo_precio < valor_minimo && !$("input#modPrecioBajoMinimo").is(":checked")){
        errorMsg("Precio bajo el minimo!",7000); 
        return;
    }    
    if(isNaN(nuevo_precio)){
        errorMsg("Ingrese un precio valido!",7000);
        return;   
    }    
     
    //var nuevo_precio = parseFloat($("#pv_mayorista").val());   
    var nuevo_precio_formatted = $("#pv_mayorista").val();//  parseFloat($("#pv_mayorista").val()).format(3, 2, ',', '.') ; 
    var modif_oferta = $("#edit_precio_oferta").is(":checked"); 
    var precios_bajo_minimo = 0;
    var precios_bajos = 0;
    var target = ($("#replicarXCod").is(":checked"))?"[data-codigo="+codigo+"]":$("#"+$("#loteActual").val()+" td.codigo_lote");
    $(target).each(function(){
        var precio_venta_linea = parseFloat($(this).parent().find(".precio_venta").text().replace(/\./g,"").replace(/,/g,".") );     
         
        //if(precio_venta_linea >= valor_minimo  && precio_venta_linea >  nuevo_precio    ){ // Solo si esta arriba del minimo
        if(nuevo_precio >= valor_minimo || $("input#modPrecioBajoMinimo").is(":checked")){    
           if(modif_oferta){
              $(this).parent().find(".precio_venta").html(nuevo_precio_formatted);
              $(this).parent().find(".descuento").html("0");
              $(this).parent().find(".precio_venta").css("background","lightskyblue");
           }else if (precio_venta_linea > nuevo_precio){
               $(this).parent().find(".precio_venta").html(nuevo_precio_formatted);
               $(this).parent().find(".descuento").html("0");
               $(this).parent().find(".precio_venta").css("background","lightskyblue");
           }else{
               precios_bajos++;
           }
        }else{
            $(this).parent().find(".precio_venta").css("background","orange");
            precios_bajo_minimo++;
        }  
    });   
     if(precios_bajos > 0){
        errorMsg("Algunos Precios no se modificaran porque ya estan por debajo del asignado asignando, si desea modificar los mismos marque Igualar todos los Precios!",20000); 
    }  
    if(precios_bajo_minimo > 0){
        infoMsg("Algunos Precios no se modificaran porque ya estan debajo del Minimo!",20000); 
    }    
    
    //corregirSubtotales(new Array());
    //totalizar();
    
    var master = new Array();
    $(".codigo_lote").each(function(){
       var codigo = $(this).attr("data-codigo"); 
       var lote = $(this).text();       
       var precio = parseFloat($(this).parent().find(".precio_venta").text().replace(/\./g, '').replace(/,/g, '.') ); 
       var arr = {"codigo":codigo,"lote":lote,"precio":precio}; 
       master.push(arr);
    }); 
    
    master = JSON.stringify(master);
    var factura = $("#factura").val();
    $("#msg").html("Venta Mayorista"); 
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: {"action": "actualizarPrecioMayorista", factura: factura,master:master,usuario:getNick()},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg_codigo").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {              
            $("#msg_codigo").html("Ok Precios Modificados."); 
            corregirSubtotales(data.DetalleDescuentos);           
            
        }
    });
    $("#div_pv_mayorista").fadeOut();       
}   
 
 
function zoomImage(){
    var w = $("#zoom_range").val();    
    $("#image_container").width(w);
    $("#img_zoom").width(w);    
}
function cargarImagenLote(img){   
    $("#image_container").html("");
    var images_url = $("#images_url").val();
    
    var cab = '<div style="width: 100%;text-align: right;background: white;">\n\
        <img src="img/substract.png" style="margin-top:-4px"> <input id="zoom_range" onchange="zoomImage()" type="range" name="points"  min="60" max="1000"><img src="img/add.png" style="margin-top:-4px;">\n\
        <img src="img/close.png" style="margin-top:-18px;margin-left:100px" onclick=javascript:$("#image_container").fadeOut()>\n\
    </div>';
    
    $("#image_container").fadeIn();
    
    
    var width = $("#articulos").width() + 20; 
    var top = $("#articulos").position().top;
    if(top < 100){
        top = 100;
    }
    $("#image_container").offset({left:width,top:top});
    var path = images_url+"/"+img+".jpg";
    
    var img = '<img src="'+ path +'" id="img_zoom" onclick=javascript:$("#image_container").fadeOut() width="500" >';
    $("#image_container").html( cab +" "+ img);
    $("#image_container").draggable();
}
function cerrarListaArticulos(){
   $("#articulos").fadeOut("fast"); 
   $(".info_titulo").html("Articulos de la misma Compra");
}

function float(id){
    var n =  parseFloat($("#"+id).val().replace(/\./g, '').replace(/\,/g, '.'));
    if(isNaN(n)){
        return 0;
    }else{
        return n;
    }
}
function floatp(id){
    var n = parseFloat($("#"+id).val());
    if(isNaN(n)){return 0; }else{ return n; }
}
function hideKeyboard(){
   $("#virtual_keyboard").fadeOut();
}
function verMonedasExtranjeras(){
   if(moneda === "G$"){ // Para otras no se muestra
      totalizar();
      $("#moneda_extrangera").toggle();
      $("#cotizaciones").toggle("slide");   
   }
}
 function setAnchorTitle() {
     $('td[title!=""]').each(function() {
         var a = $(this);
         a.hover(
             function() {
                 showAnchorTitle(a, a.data('title'));
             },
             function() {
                 hideAnchorTitle();
             }
         ).data('title', a.attr('title')).removeAttr('title');
     });
 }

 function showAnchorTitle(element, text) {
     var offset = element.offset();
     $('#anchorTitle').css({
         'top': (offset.top + element.outerHeight() - 40) + 'px',
         'left': offset.left + 'px'
     }).html(text).show();
 }

 function hideAnchorTitle() {
     $('#anchorTitle').hide();
 }
function getLimiteCredito(){
   //$("#boton_generar").fadeOut();
   var CardCode = $("#codigo_cliente").val();
   $.post( "Ajax.class.php",{ action: "getLimiteCreditoCliente",CardCode:CardCode}, function( data ) {
       var Limite = parseFloat(data.Limite);
       var Cuotas = parseFloat(data.Cuotas);
       var Cheques = parseFloat(data.Cheques);
       var ChequesAlDiaNoProcesados = parseFloat(data.ChequesAlDiaNoProcesados);
       var EfectivoNoProc = parseFloat(data.EfectivoNoProc);
       var VentasNoProcesadas = parseFloat(data.VentasNoProcesadas);
       
       
       var Diff = Limite - (Cuotas + Cheques + VentasNoProcesadas) + (EfectivoNoProc + ChequesAlDiaNoProcesados) ;      
       if(Limite > 0){
            $("#limite_credito").val( ( Diff).format(0, 3, '.', ','));
            $("#limite_credito").data("limite", Diff);
            $("#limite_credito").data("limiteReal", Limite);
            //$(".limite_credito").fadeIn();
            if(Diff <= 0){
                $("#limite_credito").css("color","red"); 
                $("input#limite_credito").addClass("alerta");
                //Hacer Desaparecer cuando supera el Limite
                //$("#boton_generar").fadeOut();
                $("#msg").html("Limite de Credito excedido, solo ventas al contado!").css("color","red");
            }else{
                $("#limite_credito").css("color","green");  
                $("input#limite_credito").removeClass("alerta");
                if($.trim($("#turno").val()).replace(/\D/g,'').length > 0){// Solo numeros
                    $("#boton_generar").fadeIn();
                }
            } 
            var CuotasAtrasadas = parseFloat(data.CuotasAtrasadas); 
            if(CuotasAtrasadas > 0){
                $("#msg").html("Solo contado! Cliente con "+CuotasAtrasadas+" Cuotas atrasadas!");
                $("#msg").css("background","orange");
                errorMsg("Solo contado! Cliente con "+CuotasAtrasadas+" Cuotas atrasadas!",18000);
            }
            setTimeout('$("#lote").focus()',500);  
       }else{// Sin no tiene Limite no mostramos
            if($.trim($("#turno").val()).replace(/\D/g,'').length > 0){
                $("#boton_generar").fadeIn(); 
            }
            $("#limite_credito").val('0');
            $("#limite_credito").data("limite", 0);
            $("#limite_credito").data("limiteReal", 0);
       }
   },'json'); 
}
 
/**
 * Dado un valor devuelve otro en funcion del % 50 Ej.:  14521 --> 14500,  14532 --> 14550    
 * Resolucion 347 SEDECO
 * @param {type} valor
 * @returns {redondeo50.valor_redondeado}  
 */
function redondear50(valor){ 
    var moneda = $("#moneda").val();
    if(moneda == "G$"){
        var resto = valor % 50;    
        var valor_redondear = 0;
        if(resto >= 25 ){
            valor_redondear = parseInt(50 - resto);          
        }else{
            valor_redondear = resto * -1;        
        }  
        var valor_redondeado =  parseInt(valor) + parseInt(valor_redondear);   
        if(valor_redondeado > 0){
            return valor_redondeado; 
        }else{
            return 0;
        } 
    }else{
        return 0;
    }
}
function facturaProforma(){
    var factura = $("#factura").val();
    var ruc = $("#ruc_cliente").val();
    var cliente = $("#nombre_cliente").val();
    var suc = getSuc();
    var usuario = getNick();
    var papar_size = 9; // Dedocratico A4
    var moneda = $("#moneda").val(); 

    var url = "ventas/FacturaProforma.class.php?factura="+factura+"&ruc="+ruc+"&cliente="+cliente+"&suc="+suc+"&usuario="+usuario+"&papar_size="+papar_size+"&moneda="+moneda;
    var title ="Impresion de Facturas Contables";
    var params ="width=800,height=840,scrollbars=yes,menubar=yes,alwaysRaised = yes,modal=yes,location=no";
    if(!proforma) {  
       proforma =  window.open(url,title,params);                         
    }else{
       proforma.close();
       window.open(url,title,params);                       
    }
}
 
function imprimirDetalle(){
    var factura = $("#factura").val();    
    var user = getNick();
    var url = "ventas/ImprimirFactura.class.php?factura="+factura+"&user="+user;
    var title ="Impresion de Facturas";
    var params ="width=800,height=840,scrollbars=yes,menubar=yes,alwaysRaised = yes,modal=yes,location=no";
    if(!proforma) {  
       proforma =  window.open(url,title,params);                         
    }else{
       proforma.close();
       window.open(url,title,params);                       
    }
}
 
var turnoData = {};
function verifTurno(){
    turnoData = {
        "id":"",
        "fecha":"",
        "llamada":""
    };
    var suc = getSuc();
    var paneles = {
        "01":"192.168.6.6",
        "02":"192.168.7.170",
        "06":"192.168.5.50"
    };

    if($.trim($("#turno").val()).replace(/\D/g,'').length == 0){
        $("#boton_generar").fadeOut(); 
    }

    if(Object.keys(paneles).indexOf(suc) > -1 && $.trim($("#turno").val()).replace(/\D/g,'').length > 0 && !isNaN($.trim($("#turno").val()).replace(/\D/g,''))){
        $("#msg").empty();
        $("#msg").removeClass("error");
        if(parseInt($.trim($("#turno").val()).replace(/\D/g,''))<100){
            $.ajax({
                url: "http://" + paneles[suc] + "/get_data.php",
                // The name of the callback parameter, as specified by the YQL service
                jsonp: "callback",
                // Tell jQuery we're expecting JSONP
                dataType: "jsonp",
                // Tell YQL what we want and that we want JSON
                data: {
                  "action":"getTurno",
                  "turno":$.trim($("#turno").val()).replace(/\D/g,''),
                  "format": "json"
                },
                // Work with the response
                success: function( response ) {
                    turnoData = response; // server response
                    $("#boton_generar").fadeIn(); 
                    verifTurnoNFactura(turnoData.id);
                }
                ,
                error: function () {
                    errorMsg("Ocurrio un error en la comunicacion con el Panel de Turnos...",8000);
                    $("#boton_generar").fadeIn(); 
                }
                ,
                timeout: 1500
            });
        }else{
            $("#boton_generar").fadeIn(); 
        }
    }else{
        $("#boton_generar").fadeIn(); 
    }
}

function verifTurnoNFactura(turno_id){
    var sData = {
        "action":"verifTurnoNFactura",
        "turno_id":turno_id,
        "suc":getSuc()
    };
    $.post("ventas/NuevaVenta.class.php",sData,function(data){
        if(data.f_nro !== ''){
            $("#msg").addClass("error");
            $("#msg").text("El turno ya fue usado en el ticket "+data.f_nro);
        }
    },"json");
}


function soloNumero(target){
    target.val($.trim($("#turno").val()).replace(/\D/g,''));
    if($.trim($("#turno").val()).replace(/\D/g,'').length == 0){
        $("#boton_generar").fadeOut(); 
    }
}


/////////////////////////////   Busquedas        /////////////////////////////

function buscarArticulo(){
    var articulo = $("#buscador_articulos").val();
    var cat = $("#categoria").val();
    
    fila_art = 0;
    if(articulo.length > 0){
    $.ajax({
        type: "POST",
        url: "ventas/FacturaVenta.class.php",
        data: {"action": "buscarArticulos", "articulo": articulo,"cat":cat},
        async: true,
        dataType: "json",
        beforeSend: function() {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function(data) { 
            
            if(data.length > 0){
                limpiarListaArticulos();
                var k = 0;
                for(var i in data){        
                    k++;
                    var codigo =  (data[i].codigo).toString().toUpperCase();                    
                    var descrip = (data[i].descrip).toString().toUpperCase();        
                    var um = data[i].um;
                    var img = data[i].img;
                    //console.log(codigo+"   "+descrip);                                                     
                    $("#lista_articulos").append("<tr class='tr_art_data fila_art_"+i+"' data-um='"+um+"' data-img='"+img+"'><td class='item clicable_art'><span class='codigo' >"+codigo+"</span></td>\n\
                    </td><td class='item clicable_art'><span class='descrip_art'>"+descrip+"</span></td>  </tr>");
                    cant_articulos = k;
                }  
                inicializarCursores("clicable_art"); 
                $("#ui_articulos").fadeIn();
                $(".tr_art_data").click(function(){                            
                      seleccionarArticulo(this); 
                });
                $("#msg").html(""); 
            }else{
                $("#msg").html("Sin resultados..."); 
            }
        }
    });
    }
} 
 
function inicializarCursores(clase){
    $("."+clase).mouseover(function(){
        $(".cursor").remove(); // Le saco a todos los que tienen
        $(this).append("<img class='cursor' src='img/l_arrow.png' width='18px' height='10px'>");
    }).mouseleave(function(){
        $(this).children('.cursor').remove();
    });   
}  
function limpiarListaArticulos(){    
    $(".tr_art_data").each(function () {   
       $(this).remove();
    });    
} 
function showHideSearchBar(bool){
    if(bool){
        $("#ui_articulos").fadeIn(function(){
            $("#buscador_articulos").focus().select();
        });
    }else{
        $("#ui_articulos").fadeOut();
    }
}
function setHotKeyArticulo(){
     
    $("#buscador_articulos").keydown(function(e) {
        
        var tecla = e.keyCode;   console.log(tecla+"  "+fila_art);  
        if (tecla == 38) {
            (fila_art == 0) ? fila_art = cant_articulos-1 : fila_art--;
            selectRowArt(fila_art);
        }
        if (tecla == 40) {
            (fila_art == cant_articulos-1) ? fila_art = 0 : fila_art++;
            selectRowArt(fila_art);
        }
        if (tecla != 38 && tecla != 40 && tecla != 13) {
            buscarArticulo();
            escribiendo = true;
            
        }
        if (tecla == 13) {
           if(!escribiendo){ 
             seleccionarArticulo(".fila_art_"+fila_art); 
           }else{
               setTimeout("escribiendo = false;",1000);
           }
        }
        if (tecla == 116) { // F5
            e.preventDefault(); 
        } 
          
    });
}
function selectRowArt(row) {
    $(".art_selected").removeClass("art_selected");
    if(row !== "%"){
        $(".fila_art_" + row).addClass("art_selected");
        $(".cursor").remove();
        $($(".fila_art_" + row + " td").get(2)).append("<img class='cursor' src='img/l_arrow.png' width='18px' height='10px'>");
        var img = $(".fila_art_" + row ).attr("data-img");
        $("#imagen_lote").fadeIn();
        $("#imagen_lote").attr("src",img);
    }
    escribiendo = false;   
} 


function seleccionarArticulo(obj){   
    var codigo = $(obj).find(".codigo").html(); 
    var um = $(obj).attr("data-um");
   
    $("#ui_articulos").fadeOut();
    $("#lote").val(codigo); 
    $("#um").val(um); 
    buscarCodigo();
}

function imprimirFactura(){
     
     var factura_contable = $("#factura_contable").val();
     var tipo_factura = $("#tipo_factura").val();
     var pdv = $("#factura_contable option:selected").attr("data-pdv"); 
     var moneda = $("#moneda").val();
      
     if(factura_contable != ""){
         factura = $("#factura").val();   
         //var factura = $("#factura").val();    
         var ruc = $("#ruc_cliente").val();
         var cliente = encodeURI($("#nombre_cliente").val());
         var suc = getSuc();
         var usuario = getNick();
         var papar_size = 9; // Dedocratico A4
         var tipo_fact = $("#tipo_fact").val();
                  
         var url = "caja/ImpresorFactura.class.php?factura="+factura+"&ruc="+ruc+"&cliente="+cliente+"&suc="+suc+"&factura_legal="+factura_contable+"&usuario="+usuario+"&papar_size="+papar_size+"&tipo_factura="+tipo_factura+"&pdv="+pdv+"&man_pre="+tipo_fact+"&moneda="+moneda;
         var title ="Impresion de Facturas Contables";
         var params ="width=800,height=840,scrollbars=yes,menubar=yes,alwaysRaised = yes,modal=yes,location=no";
         if(typeof(showModalDialog) === "function"){ // Firefox
             window.showModalDialog(url,title,params);                      
         }else{
             window.open(url,title,params);                       
         }
     }else{
         alert("Debe Pre cargar las Facturas Contables para poder Imprimir");
     }
  }
  
function updateListaClientes(nombre,ruc){  
   $("#ruc_cliente").val(ruc);
   $("#nombre_cliente").val(nombre);
   buscarCliente($("#ruc_cliente"));
   $("#boton_generar").focus();
}

/*********************Caja*********************/

function irACaja(){
    var factura = $("#factura").val();
    cobrarFactura(factura);    
}

function showMult(id){
      
      var val = parseFloat($("#"+id).val() .replace(/\./g, '').replace(/\,/g, '.')); 
      var ter = id.substring(8,12);
      if(ter == "rs"){
          var mult_rs = (rs*val).format(2, 3, '.', ',');
          $("#mult_"+ter).text(" * "+rs+" = "+ mult_rs);
          guardarEfectivo(id,"R$",rs);
      }else if(ter == "ps"){
          var mult_ps = (ps*val).format(2, 3, '.', ',');
          $("#mult_"+ter).text(" * "+ps+" = "+ mult_ps);
          guardarEfectivo(id,"P$",ps);
      }else if(ter == "us"){
          var mult_us = (us*val).format(2, 3, '.', ',');
          $("#mult_"+ter).text(" * "+us+" = "+ mult_us);
          guardarEfectivo(id,"U$",us);
      }else{ //Guaranies
         guardarEfectivo(id,"G$",1);            
      }
  }
   
  function guardarEfectivo(id,moneda,cotiz){
    var monto = float(id);  
    var monto_ref = float(id) * cotiz; 
    var suc = getSuc();
    var monedas_vuelto = $("#monedas_vuelto").val();
    var vuelto =   parseFloat(($("#vuelto_faltante").val()).replace(/\./g, '').replace(/\,/g, '.'));
    if($("#label_vuelto_faltante").text() === "Faltante:"){
        vuelto = 0;
        monedas_vuelto = "";
    }
     
        $.ajax({
            type: "POST",
            url: "Ajax.class.php",
            data: {"action": "agregarEfectivo", "nro_referencia": factura, "moneda": moneda,"monto":monto,"cotiz":cotiz,"monto_ref":monto_ref,"id_concepto":1,"campo":"f_nro",suc:suc,usuario:getNick(),moneda_vuelto:monedas_vuelto,vuelto:vuelto,cotiz_vuelto:cotiz_vuelto},
            async: true,
            dataType: "html",
            beforeSend: function() {
                $("#msg_efectivo").html("Guardando... <img src='img/loadingt.gif' >");                      
            },
            complete: function(objeto, exito) {
                if (exito == "success") {                          
                    var result = $.trim(objeto.responseText);
                    $("#msg_efectivo").html(objeto.responseText+"<img src='img/ok.png' width='16px' height='16px' >"); 
                    setTimeout("$('#msg_efectivo').html('');",5000);
                }
            },
            error: function() {
                $("#msg_efectivo").html("Ocurrio un error en la comunicacion con el Servidor...");
            }
        }); 
    
  }
  function actualizarVuelto(){
    if($("#label_vuelto_faltante").text() === "Vuelto:"){
        var monedas_vuelto = $("#monedas_vuelto").val();
        var vuelto =   parseFloat(($("#vuelto_faltante").val()).replace(/\./g, '').replace(/\,/g, '.'));
        $.ajax({
            type: "POST",
            url: "Ajax.class.php",
            data: {"action": "actualizarVuelto", "factura": factura, "moneda": monedas_vuelto,"vuelto":vuelto,cotiz_vuelto:cotiz_vuelto},
            async: true,
            dataType: "html",
            beforeSend: function() {
                $("#msg_efectivo").html("Guardando... <img src='img/loadingt.gif' >");                      
            },
            complete: function(objeto, exito) {
                if (exito == "success") {                          
                    var result = $.trim(objeto.responseText);
                    $("#msg_efectivo").html(objeto.responseText+"<img src='img/ok.png' width='16px' height='16px' >"); 
                    setTimeout("$('#msg_efectivo').html('');",5000);
                }
            },
            error: function() {
                $("#msg_efectivo").html("Ocurrio un error en la comunicacion con el Servidor...");
            }
        }); 
    }
  }
  function setDateCheque(){
      var tipo = $("#tipo").val();
      if(tipo == "Al_Dia"){
          $("#fecha_emision").val($(".fecha_hoy").val());
          $("#fecha_pago").val($(".fecha_hoy").val());  
          $("#fecha_emision").attr("readonly",true);
          $("#fecha_pago").attr("readonly",true);
      }else{
          $("#fecha_emision").val($(".fecha_hoy").val());
          $("#fecha_pago").val("");  
          $("#fecha_emision").removeAttr("readonly");
          $("#fecha_pago").removeAttr("readonly");
      }     
  }
  /**
   * Metodo que levanta la UI para cobrar una Factura Formas de cobro posibles Monedas Locales Tarjetas Credito y 
   * Debito,Cheques y Credito (Cuotas)
   * @param {type} factura
   * @returns {cobrarFactura}
   */
  function cobrarFactura(factura){
     
      $("#tabs").tabs( "enable");
      $("#tabs").tabs( "option", "active", 0 );
      this.factura = factura;
      var fecha = $("#fecha").val(); 
      var cod_cli = $("#codigo_cliente").val(); 
      var cod_desc = 0;        
      var ruc = $("#ruc_cliente").val(); 
      var cliente = $("#nombre_cliente").val(); 
      var cat = $("#categoria").val(); 
      //var moneda = $("#moneda_"+factura).html(); 
      
      var total_descuento = 0;
      var total_pagar =  $.trim($("#total_factura").text().replace("G$.",""));
      
      
      if(impresion_factura_cerrada){
         fecha = $("#bfecha").val(); 
         cod_cli = $("#bcod_cli").val(); 
         cod_desc = $("#bcod_desc").val();        
         ruc = $("#bruc").val(); 
         cliente = $("#bcliente").val(); 
         cat = $("#bcat").val(); 
         moneda = $("#bmoneda").val();        
         total_descuento =  $("#bdescuento" ).val();
         total_pagar =  $("#btotal").val(); // En la moneda que sea    
      }
      
      var mon = moneda.replace("$","s").toLowerCase(); //console.log(mon);
      var total_pagar_moneda = total_pagar.replace(/\./g, '').replace(/\,/g, '.');
      
      // $CardCode
      /*
      if(cat < 3){ //Clientes con Categoria 1 y 2 No pueden insertar cheques diferidos
          //$("#tab_credito").fadeOut();
          $(".diferido").prop("disabled",true);                  
          
      }else{
          var limite = parseFloat($("#limite_credito").val());
          if(limite > 0){
            // $("#tab_credito").fadeIn();
             $(".diferido").removeAttr("disabled");
          }else{
             //$("#tab_credito").fadeOut()
             $(".diferido").prop("disabled",true); 
             errorMsg("Sin limite de credito asignado No se permiten cheques diferidos ni cuotas",50000);
          }          
      }*/
      
           
      $(".monedas").removeClass("moneda_factura");
      $(".loading_cotiz").fadeIn();       
      rs = float("cotiz_rs");
      ps = float("cotiz_ps");
      us = float("cotiz_us");
      
      cotiz_vuelto = 1;
      
      if(moneda == "G$"){
          global_cotiz = 1; 
      }else if(moneda == "U$"){
          global_cotiz = us;                 
      }else if(moneda == "R$"){
          global_cotiz = rs;                 
      }else if(moneda == "P$"){
          global_cotiz = ps;         
      } 
      $("#total_gs").val(parseFloat( total_pagar_moneda * global_cotiz ).format(0, 3, '.', ',')); 
      $("#total_rs").val(parseFloat((total_pagar_moneda * global_cotiz) / rs).format(2, 3, '.', ','));
      $("#total_ps").val(parseFloat((total_pagar_moneda * global_cotiz) / ps).format(2, 3, '.', ','));
      $("#total_us").val(parseFloat((total_pagar_moneda * global_cotiz) / us).format(2, 3, '.', ',')); 
      
      $("#total_"+mon).addClass("moneda_factura"); // Resaltarl la Moneda de la Factura
      
      $("#factura_popup_caja").val(factura);
      $("#fecha").val(fecha);
      
       
      $("#ruc_cliente_popup_caja").val(ruc);
      //$("#codigo_cliente_popup_caja").val(cod_cli);  
      $("#nombre_cliente_popup_caja").val(cliente);
      $("#benef").val(cliente); 
      $("#categoria_popup_caja").val(cat); 
      $("#moneda_popup_caja").val(moneda);   
      $("#monedas_cuotas").val(moneda);      
   
      
      
      $("#popup_caja").slideDown("fast").css('top', "10px"); 
      
      
      $("#entrega_gs").focus();
       /*
      $("#total_rs").val("");
      $("#total_ps").val("");
      $("#total_us").val("");*/
      
        $("#total_rs").attr("title"," Cotiz: "+rs+" ");
        $("#total_ps").attr("title"," Cotiz: "+ps+" ");
        $("#total_us").attr("title"," Cotiz: "+us+" ");
        $("#total_rs").attr("data-info"," Cotiz: "+rs+" ");
        $("#total_ps").attr("data-info"," Cotiz: "+ps+" ");
        $("#total_us").attr("data-info"," Cotiz: "+us+" ");
 
        setTimeout('$(".loading_cotiz").fadeOut("fast")',1000);  
           
        getEfectivoFactura(factura); 
        getConveniosDeFactura(factura);
        getChequesDeFactura(factura);
        getTransferenciasBancariasDeFactura();
        getCuotasDeFactura();
        getDatosConvenioFactura();
        getPuntos();
        
        getFacturasContables(); 
        acomodarPopup();
           
      $(window).resize(function(){acomodarPopup();});  
      getLimiteCredito();
      statusInfo(); 
  }
  
  function imprimirFacturaCerrada(){
      impresion_factura_cerrada = true;
      $("#ventas").remove();     
      $("#tabs input").prop("disabled",true);
      $("#cerrar_venta").remove();      
      $("#popup_print").fadeIn();
      $("#popup_print").draggable();
  }
  function cargarFactura(){
      //var ticket = $("#bticket").val();
      var usuario = getNick(); 
        var session = getCookie(usuario).sesion;
        var estado = $("#estado").val();
        load("ventas/FacturaVenta.class.php",{usuario:usuario,session:session,factura:factura,suc:getSuc(),estado:estado}, function(){    
            if(estado != "Cerrada"){
              $("#area_carga").fadeIn("fast",function(){             
                 setTimeout( "verificarMoneda()",500);          
              });   
            }else{
                setTimeout( "verificarMoneda()",500);  
            }
      });    
  } 
  function buscarTicket(){
      var ticket = $("#bticket").val();
      $.ajax({
        type: "POST",
        url: "caja/VentasEnCaja.class.php",
        data: {"action": "buscarTicket", ticket: ticket,suc:getSuc()},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg_b").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            $("#popup_print input:not('.mantain')").val("");
            $("#cargar_venta").prop("disabled",true);
        },
        success: function (data) {   
             
            if(data.cod_cli !== undefined){
                var bcod_cli = data.cod_cli;
                var ruc_cli = data.ruc_cli;
                var cliente = data.cliente;  
                var fecha = data.fecha;  
                var moneda = data.moneda;  
                var total = data.total;  
                var total_desc = data.total_desc;  
                var cod_desc = data.cod_desc;
                var fact_nro = data.fact_nro;
                var bcat = data.cat;
                $("#bcliente").val(cliente);
                $("#bruc").val(ruc_cli);
                $("#bcat").val(bcat);
                $("#bfactura").val(fact_nro);
                $("#btotal").val(  (parseFloat(total)).format(2, 3, '.', ',') );
                $("#bdescuento").val( (parseFloat(total_desc)).format(2, 3, '.', ','));
                $("#bfecha").val(fecha);
                $("#bmoneda").val(moneda);
                $("#bcod_desc").val(cod_desc);
                $("#bcod_cli").val(bcod_cli);
                
                $("#cargar_venta").prop("disabled",false);
                $("#msg_b").html(""); 
            }else{
               $("#msg_b").html("Ticket no encontrado o no le pertenece a su sucursal.");  
            }
              
            
        }
    });
  }
  
  // Acomodar el ancho del popup
  function acomodarPopup(){
        var width_hijos=126;  // 126 = width de espacios
        $('#bottom_bar > *').width(function(i,w){width_hijos+=w;});
        var popup_width = $("#popup_caja").width(); 
        
        var wa = $("#work_area").width();
        if( popup_width < width_hijos ){ 
             $("#popup_caja").width(width_hijos+2);          
        }  
        var margin_left =  0;
        if(wa > ($("#popup_caja").width())){
             margin_left =  (wa - ($("#popup_caja").width()) ) / 2;
        } 
        $("#popup_caja").css("margin-left", margin_left );        
  }
  function getFacturasContables(){
   var suc = getSuc();   
   var tipo_fact = $("#tipo_fact").val();
   var moneda = $("#moneda").val();
   tipo_doc = "Factura";
   if(tipo_fact === "Conf"){
       tipo_doc = "Factura Conformada";
   }
   $.ajax({
            type: "POST",
            url: "Ajax.class.php",
            data: {"action": "getFacturasContables", "suc": suc,tipo_fact:tipo_fact,tipo_doc:tipo_doc,moneda:moneda},
            async: true,
            dataType: "json",
            beforeSend: function() {
                $("#loading_facts").fadeIn();
            },
            success: function(data) {  
                $("#factura_contable").empty();
                var cont = 0;
                for(var i in data){ 
                     var fact_cont = data[i].fact_nro; 
                     var pdv_cod = data[i].pdv_cod; 
                     $("#factura_contable").append("<option value='"+fact_cont+"' data-pdv="+pdv_cod+">"+fact_cont+"</option>");  cont++;
                } 
                $("#loading_facts").fadeOut();
                if(cont == 0){
                    $("#imprimir_factura").fadeOut();
                    alert("Debe cargar Facturas Contables Pre Impresas en el sistema para poder Imprimir.");
                }else{
                    $("#imprimir_factura").fadeIn();
                    $("#imprimir_factura").removeAttr("disabled");
                }
            }
        });
  }
  
  function getDatosConvenioFactura(){
     $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: {"action": "getDatosConvenioFactura", factura: factura},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {   
             
           $("#nro_orden").val(data.nro_orden);
           $("#orden_benef").val(data.orden_cli);            
           $("#monto_orden").val(data.orden_valor);             
             
           $("#msg").html(""); 
        }
    }); 
  }
  function getConveniosDeFactura(nro_factura){
   $.ajax({
            type: "POST",
            url: "Ajax.class.php",
            data: {"action": "getConvenios", "nro_referencia": nro_factura,"campo":"f_nro","id_concepto":1},
            async: true,
            dataType: "json",
            beforeSend: function() {
                $("#msg_convenio").html("Recuperando datos... <img src='img/loadingt.gif'>"); 
            },
            success: function(data) { 
                $(".conv_foot").remove();
                $("[class^='tr_convenios']").remove();
                var total = 0;
                for(var i in data){ 
                     var conv_cod = data[i].cod_conv;
                     var vouch = data[i].voucher;
                     var nombre = data[i].nombre;
                     var monto = data[i].monto;  
                     var monto_conv_formated = parseFloat( monto ).format(2, 3, '.', ',');  
                     total += parseFloat( monto ) ;
                     $("#lista_convenios") .append("<tr class='tr_convenios_"+vouch+"'><td class='itemc'>"+conv_cod+"</td>  <td class='item'>"+nombre+"</td> <td class='item'>"+vouch+"</td> <td class='num'>"+monto_conv_formated+"</td><td class='itemc'><img class='del_conv' title='Borrar Tarjeta' style='cursor:pointer' src='img/trash_mini.png' onclick=delConv('"+conv_cod+"','"+vouch+"');></td></tr>");                                       
                } 
                total = parseFloat(total).format(2, 3, '.', ',');  
                $("#lista_convenios") .append("<tr class='conv_foot'><td colspan='3' > </td><td style='text-align: center;font-weight: bolder;font-size: 13px' class='total_convenios'>"+total+"</td><td></td> </tr>");
                $("#msg_convenios").html("");    
                setRef();                  
            }
        });         
  }
  function getEfectivoFactura(nro_factura){
    $.ajax({
            type: "POST",
            url: "Ajax.class.php",
            data: {"action": "getEfectivoFactura", "factura": nro_factura},
            async: true,
            dataType: "json",
            beforeSend: function() {
                $("#msg_efectivo").html("Recuperando datos... <img src='img/loadingt.gif'>"); 
            },
            success: function(data) {   
                for(var i in data){ 
                     var codigo = (data[i].codigo).toLowerCase().replace("$","s");
                     var monto = data[i].entrada;
                     $("#entrega_"+codigo).val( parseFloat( monto ).format(2, 3, '.', ',') );   
                     var vuelto = data[i].salida;
                     if(vuelto > 0){
                         mon_vuelto =   data[i].codigo ;                            
                     }
                }   
                setRef();
                $("#msg_efectivo").html(""); 
            }
    });       
  }
  function getChequesDeFactura(nro_factura){
        $.ajax({
            type: "POST",
            url: "Ajax.class.php",
            data: {"action": "getChequesDeFactura", "factura": nro_factura},
            async: true,
            dataType: "json",
            beforeSend: function() {
                $("#msg_cheques").html("Recuperando datos... <img src='img/loadingt.gif'>"); 
            },
            success: function(data) { 
                $(".cheques_foot").remove();
                $(".tr_cheques").remove(); 
                
                var total = 0;
                for(var i in data){ 
                     var nro_cheque = data[i].nro_cheque;
                     var banco = data[i].banco;
                     var cuenta = data[i].cuenta;
                     var valor = data[i].valor;  
                     var cotiz = data[i].cotiz;                        
                     var valor_ref = data[i].valor_ref;  
                     var fecha_emis = data[i].fecha_emis;
                     var fecha_pago = data[i].fecha_pago;
                     var benef = data[i].benef;  
                     var moneda = data[i].moneda;                       
                     var valor_formated = parseFloat( valor ).format(0, 3, '.', ',');  
                     var valor_gs_formated = parseFloat( valor_ref ).format(0, 3, '.', ',');  
                     total += parseFloat( valor_ref ) ;
                     $("#lista_cheques") .append("<tr class='tr_"+nro_cheque+"  tr_cheques'><td>"+nro_cheque+"</td><td>"+banco+"</td><td>"+cuenta+"</td><td>"+benef+"</td><td  class='num' >"+valor_formated+"</td><td class='itemc'>"+moneda+"</td><td class='num'>"+cotiz+"</td><td class='num'>"+valor_gs_formated+"</td><td  class='itemc'>"+fecha_emis+"</td><td  class='itemc'>"+fecha_pago+"</td><td  class='itemc'><img class='del_chq' title='Borrar Cheque' style='cursor:pointer' src='img/trash_mini.png' onclick=delCheque('"+nro_cheque+"','"+factura+"');></td></tr>");                                       
                } 
                total = parseFloat(total).format(2, 3, '.', ',');  
                $("#lista_cheques") .append("<tr class='cheques_foot'><td colspan='7' > </td><td style='text-align: center;font-weight: bolder;font-size: 13px' class='total_cheques'>"+total+"</td><td></td> </tr>");
                $("#msg_cheques").html("");    
                setRef();                  
            }
        });       
  }
  function cancelar(){      
     $("[class^=tr_convenios]").remove();
     $("[class^=tr_cuotas]").remove();
     $("[class^=tr_cheques]").remove();
     $("#popup_caja").slideUp("slow"); 
  }
  
  function addConv(){
     $("#add_conv").attr("disabled",true); 
     var conv_cod = $("#convenios").val();
     var conv_nombre = $("#convenios option:selected").text();
     var voucher = $.trim($("#voucher").val());
     var monto_conv = float("monto_conv");
     var monto_conv_formated = $("#monto_conv").val();
     var suc = getSuc();
     
     var timbrado = $("#timbrado_ret").val();
     var fecha_ret = validDate($("#fecha_ret").val()).fecha;
     
     $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: {"action": "agregarConvenio", "nro_referencia": factura, "conv_cod": conv_cod,"conv_nombre":conv_nombre,"voucher":voucher,"monto_conv":monto_conv,"campo":"f_nro","id_concepto":1,suc:suc,timbrado:timbrado,fecha_ret:fecha_ret},
        async: true,
        dataType: "html",
        beforeSend: function() {
            $("#msg_convenios").html("Guardando... <img src='img/loadingt.gif' width='22px' height='22px' >");                      
        },
        complete: function(objeto, exito) {
            if (exito == "success") {                          
                var result = parseFloat( objeto.responseText ).format(2, 3, '.', ',');  
                
                $(".conv_foot").remove();
                $("#lista_convenios") .append("<tr class='tr_convenios_"+voucher+"'><td class='itemc'>"+conv_cod+"</td>  <td class='item'>"+conv_nombre+"</td> <td class='item'>"+voucher+"</td> <td class='num'>"+monto_conv_formated+"</td><td class='itemc'><img class='del_conv' title='Borrar Tarjeta' style='cursor:pointer' src='img/trash_mini.png' onclick=delConv('"+conv_cod+"','"+voucher+"');></td></tr>");
                $("#lista_convenios") .append("<tr class='conv_foot'><td colspan='3' > </td><td style='text-align: center;font-weight: bolder;font-size: 13px' class='total_convenios'>"+result+"</td><td></td> </tr>");
                $("#msg_convenios").html("");   
                $("#voucher").val("");
                $("#monto_conv").val("");
                setRef();
            }
        },
        error: function() {
            $("#msg_convenios").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });    
     
  }
  
 function delConv(conv_cod,voucher){  
     
    $("#add_conv").attr("disabled",true); 
    $( "#dialog-confirm" ).dialog({
      resizable: false,
      height:140,
      modal: true,
      buttons: {
        "Cancelar": function() {
          $( this ).dialog( "close" );
        },  
        "Borrar este Cobro": function() {
                $( this ).dialog( "close" );
                $.ajax({
                      type: "POST",
                      url: "Ajax.class.php",
                      data: {"action": "borrarConvenio", "nro_referencia": factura, "conv_cod": conv_cod,"voucher":voucher,"campo":"f_nro","id_concepto":1},
                      async: true,
                      dataType: "html",
                      beforeSend: function() {
                          $("#msg_convenios").html("Borrando... <img src='img/loadingt.gif' width='22px' height='22px' >");                      
                      },
                      complete: function(objeto, exito) {
                          if (exito == "success") {                          
                              var result = parseFloat( objeto.responseText ).format(2, 3, '.', ',');  
                              $("#add_conv").removeAttr("disabled");
                              $(".conv_foot").remove();               
                              $("#lista_convenios") .append("<tr class='conv_foot'><td colspan='3' > </td><td style='text-align: center;font-weight: bolder;font-size: 13px' class='total_convenios'>"+result+"</td><td></td> </tr>");
                              $("#msg_convenios").html("");  
                              $(".tr_convenios_"+voucher).remove();
                              setRef();
                          }
                      },
                      error: function() {
                          $("#msg_convenios").html("Ocurrio un error en la comunicacion con el Servidor...");
                      }
                  });       
                } 
        },        
        close: function() {            
          $( this ).dialog( "destroy" );
        }
      });
     
 }
 
 function calcRefCheque(){
     var valor = float("valor_cheque");
     var moneda_chq = $("#monedas_cheque").val();
     if(   moneda_chq === "G$"){
         $("#cotiz_cheque").val("1,00");  
     }else{ // U$
         $("#cotiz_cheque").val(us);  
     }     
     var cotiz = float("cotiz_cheque");
     var valor_ref = valor * cotiz;
     var valor_ref_fortted = valor_ref.format(2, 3, '.', ','); 
     $("#valor_cheque_gs").val(valor_ref_fortted);
     checkCheque();     
 }
 function checkCheque(){
    var chq_num = $("#nro_cheque").val();
    var nro_cuenta = $("#nro_cuenta").val();
    var benef = $("#benef").val();
    var valor_gs = float("valor_cheque_gs");
    
    var emis =  $("#fecha_emision").val() ;  
    var pago =  $("#fecha_pago").val();  
    
    if(chq_num.length >= 3 && nro_cuenta.length > 3 &&  benef.length >= 3 && valor_gs > 0 && ( emis != "" && pago != "" && (chq_num < 2147483647 ) ) ){
        $("#add_cheque").removeAttr("disabled");        
    }else{
        $("#add_cheque").attr("disabled",true);
    }
    if((chq_num > 2147483647 )){
        alert("Valor del cheque demasiado grande");
        errorMsg("Valor del cheque demasiado grande",8000);
    }
 }
 
 function addCheque(){
    $("#add_cheque").attr("disabled",true); 
    var nro_cheque = $("#nro_cheque").val().toUpperCase() ;
    var cuenta = $("#nro_cuenta").val();
    var banco = $("#bancos").val();
    var nombre_banco = $("#bancos option:selected").text();
    var benef = $("#benef").val().toUpperCase();
    var valor = float("valor_cheque");  
    var moneda = $("#monedas_cheque").val();
    var cotiz = float("cotiz_cheque");  
    var valor_gs = float("valor_cheque_gs");  
    var emis = validDate($("#fecha_emision").val()).fecha;  
    var pago = validDate($("#fecha_pago").val()).fecha;  
    var tipo = $("#tipo").val();
    var suc = getSuc();
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: {action: "agregarCheque", nro_cheque: nro_cheque, suc: suc,cuenta:cuenta,banco:banco,valor:valor,moneda:moneda,cotiz:cotiz,valor_ref:valor_gs,benef:benef,emision:emis,pago:pago,factura:factura,concepto:1,trans_num:factura,campo:"f_nro",tipo:tipo},
        async: true,
        dataType: "html",
        beforeSend: function() {
            $("#msg_cheques").html("<img src='img/loading.gif' width='22px' height='22px' >");                      
        },
        complete: function(objeto, exito) {
            if (exito == "success") {                          
                var total_cheques = parseFloat($.trim(objeto.responseText)).format(0, 3, '.', ',');
                var valor_f = parseFloat(valor).format(0, 3, '.', ',');
                var valor_gs_f = parseFloat(valor_gs).format(0, 3, '.', ',');
                
                $("#msg_cheques").html(""); 
                $(".cheques_foot").remove();
                $("#lista_cheques").append("<tr class='tr_"+nro_cheque+" tr_cheques'><td>"+nro_cheque+"</td><td>"+nombre_banco+"</td><td>"+cuenta+"</td><td>"+benef+"</td><td  class='num' >"+valor_f+"</td><td class='itemc'>"+moneda+"</td><td class='num'>"+cotiz+"</td><td class='num'>"+valor_gs_f+"</td><td class='itemc'>"+emis+"</td><td class='itemc'>"+pago+"</td><td class='itemc'><img class='del_chq' title='Borrar Cheque' style='cursor:pointer' src='img/trash_mini.png' onclick=delCheque('"+nro_cheque+"','"+factura+"');></td></tr>");
                $("#lista_cheques").append("<tr class='cheques_foot'><td colspan='7' > </td><td style=';font-weight: bolder;font-size: 13px' class='total_cheques num'>"+total_cheques+"</td><td></td> </tr>")
                setRef();
                $("#nro_cheque").val("").focus();
                $("#nro_cuenta").val();
                $("#bancos").val(1);
                $("#bancos option:selected").text();
                $("#benef").val("");
                $("#valor_cheque").val("");  ; 
                $("#cotiz_cheque").val("");  ;  
                $("#valor_cheque_gs").val("");  ;  
                $("#fecha_emision").val("");  
                $("#fecha_pago").val(""); 
                $("#add_cheque").removeAttr("disabled");
            }
        },
        error: function() {
            $("#msg_cheques").html("Ocurrio un error en la comunicacion con el Servidor, intente de nuevo en algunos instantes o contacte con el Administrador.");
        }
    });  
 }
 
 function delCheque(nro_cheque,factura){
     $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: {"action": "borrarChequeDeFactura", "nro_cheque": nro_cheque, "factura": factura},
        async: true,
        dataType: "html",
        beforeSend: function() {
            $("#msg_cheques").html("<img src='img/loading.gif' width='16px' height='16px' >");                      
        },
        complete: function(objeto, exito) {
            if (exito == "success") {                          
                var total = $.trim(objeto.responseText);
                var valor_total = parseFloat(total).format(0, 3, '.', ',');
                $(".total_cheques").html(valor_total); 
                $(".tr_"+nro_cheque).remove();
                $("#msg_cheques").html("");
                setRef();
            }
        },
        error: function() {
            $("#msg_cheques").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    }); 
 }
 function setCuenta(){
   $("#nro_cuenta_dep").val($("#bancos_dep option:selected").attr("data-cuenta")); 
 }
 function addDep(){
     
    var fecha_tranf = $("#fecha_trasnf").val();
    var nro_dep = $("#nro_dep").val();
    var banco = $("#bancos_dep").val();
    var cuenta_dep = $("#nro_cuenta_dep").val();
    var total_dep = parseFloat($(".total_dep").val().replace(/\./g, '').replace(/\,/g, '.')); 
    var suc = getSuc();
    if(fecha_tranf != "" && nro_dep != "" && cuenta_dep != "" && total_dep >= 0  ){
       
        $.ajax({
            type: "POST",
            url: "Ajax.class.php",
            data: {"action": "agregarDepositoPorFacturaVenta", factura:factura,suc:suc,fecha_tranf:fecha_tranf,nro_dep:nro_dep,banco:banco,cuenta:cuenta_dep,total:total_dep,usuario:getNick()},
            async: true,
            dataType: "html",
            beforeSend: function() {
                $("#msg_transf").html("<img src='img/loading.gif' width='22px' height='22px' >");                      
            },
            complete: function(objeto, exito) {
                if (exito == "success") {                          
                    var result = $.trim(objeto.responseText);  
                    if(result=="Ok" ){
                        $("#del_dep").fadeIn();
                        $("#msg_transf").html("Ok");   
                        setRef();
                    }else{
                         $("#msg_transf").html("Ocurrio un error en la comunicacion con el Servidor...");         
                    }
                }
            },
            error: function() {
                $("#msg_transf").html("Ocurrio un error en la comunicacion con el Servidor...");
            }
        });   
    }else{
        $("#msg_transf").addClass("error");
        $("#msg_transf").html("Todos los campos deben estar completos...");
    }
}
function getTransferenciasBancariasDeFactura(){
    $.ajax({
            type: "POST",
            url: "Ajax.class.php",
            data: {"action": "getTransferenciaBancariaDeFactura", "factura": factura},
            async: true,
            dataType: "json",
            beforeSend: function() {
                $("#msg_transf").html("Recuperando datos... <img src='img/loadingt.gif'>"); 
            },
            success: function(data) {   
                if(data.length > 0){
                   var id_banco = data[0].id_banco ;
                   var fecha_trasnf = data[0].fecha_lat ;
                   var cuenta = data[0].cuenta;
                   var nro_deposito = data[0].nro_deposito;
                   var entrada = parseFloat(data[0].entrada).format(2, 3, '.', ',');  ;
                   $("#fecha_trasnf").val(fecha_trasnf);                   
                   $("#nro_dep").val(nro_deposito);
                   $("#bancos_dep").val(id_banco);
                   $("#nro_cuenta_dep").val(cuenta);
                   
                   $("#total_dep").val(entrada); 
                   setRef();
                }else{
                    //$("#fecha_trasnf").val("");
                    $("#nro_dep").val("");
                    //$("#bancos_dep").val("");
                    //$("#nro_cuenta_dep").val("");
                    $("#total_dep").val(0); 
                }
                $("#msg_transf").html(""); 
            }
    });     
}
 function getCuotasDeFactura(){
     // Este metodo toma NaN como Monto inicial por lo tanto solo devuelve las ya generadas
     $(".cuotas").remove();
     $.ajax({
            type: "POST",
            url: "Ajax.class.php",
            data: {"action": "getCuotasDeFactura",factura:factura},
            async: true,
            dataType: "json",
            beforeSend: function() {
                $("#msg_cuotas").html("<img src='img/loading.gif' height='20px' width='20px' >"); 
            },
            success: function(data) {  
               $(".cuotas_foot").remove(); 
                    var total_moneda = 0;  
                    var total = 0;
                    for(var i in data){ 
                         var nro = data[i].id_cuota;
                         var moneda = data[i].moneda;
                         var monto = data[i].monto;
                         var tasa_interes = data[i].tasa_interes;  
                         var cotiz = data[i].cotiz;                        
                         var ret_iva = data[i].ret_iva;  
                         var monto_ref = data[i].monto_ref;
                         var valor_total = data[i].valor_total;
                         var vencimiento = data[i].vencimiento;  
                         var estado = data[i].estado;                       
                         var monto_ref_formated = parseFloat( monto_ref ).format(0, 3, '.', ',');  
                         //var valor_gs_formated = parseFloat( valor_ref ).format(0, 3, '.', ',');  
                         total += parseFloat( monto_ref ); 
                         total_moneda+= parseFloat( valor_total )
                         var paper_size = '<label>A4&nbsp;</label><input type="radio" value="9" name="paper_size_'+nro+'" checked="checked" >&nbsp;<label>Oficio</label><input type="radio" value="14" name="paper_size_'+nro+'" >'; 
                         $("#lista_cuotas") .append("<tr class='tr_"+nro+" cuotas tr_cuotas'><td class='itemc'>"+nro+"</td><td class='num' >"+monto+"</td><td class='itemc' >"+moneda+"</td><td class='num' >"+cotiz+"</td><td  class='itemc'>"+tasa_interes+"%</td><td  class='num' >"+ret_iva+"</td>\n\
                         <td class='num'>"+valor_total+"</td><td class='num'>"+monto_ref+"</td><td  class='itemc'>"+vencimiento+"</td><td  class='itemc'>"+paper_size+"<img id='img_"+nro+"' src='img/printer-01_32x32.png' width='22' height='20' style='cursor:pointer' onclick='imprimirPagare("+nro+")' > </td></tr>");                                       
                         $(".cuotas_bar").fadeIn();
                    } 
                    if(total > 0){
                        $("#tipo_factura").val("Credito");
                    }else{
                        $("#tipo_factura").val("Contado");
                    }
                    total = parseFloat(total).format(2, 3, '.', ',');  
                    total_moneda = parseFloat(total_moneda).format(2, 3, '.', ',');
                    $("#lista_cuotas").append("<tr class='cuotas_foot'><td colspan='6' > </td> <td style='text-align: right;font-weight: bolder;font-size: 13px' class='total_cuotas_moneda' >"+total_moneda+"</td> <td style='text-align: right;font-weight: bolder;font-size: 13px' class='total_cuotas'>"+total+"</td><td></td> </tr>");
                    $("#msg_cuotas").html("");    
                    setRef();            
                    $("#msg_cuotas").html(""); 
            }
        }); 
  
 }
  function setPlanPago( plan ){
      if(plan != 4){
         $("#n_cuotas").attr("disabled",true); 
      }else{
         $("#n_cuotas").removeAttr("disabled");
      }
      if(plan > 1){$("#generar_cuotas").val("Generar Cuotas");}else{$("#generar_cuotas").val("Generar Cuota");}
      calcRefCuota();
      $("#generar_cuotas").removeAttr("disabled");
  }
  function calcRefCuota(){
        var moneda_cuota = $("#monedas_cuotas").val();
        if(   moneda_cuota === "G$"){
            $("#cotiz_cuota").val("1,00");  
        }else{ // U$
            $("#cotiz_cuota").val(parseFloat(us).format(2, 3, '.', ','));  
        }     
        var cotiz = float("cotiz_cuota");
        var  faltante = float("vuelto_faltante");
        var plan = $('input[name=plan]:checked').val();
        var cuotas = plan;
        if(plan == 4){
             cuotas = $("#n_cuotas").val();
        }
        var valor_cuota = parseFloat((faltante / cotiz) / cuotas).format(2, 3, '.', ',');
        var moneda = $("#monedas_cuotas option:selected").text();
        $("#msg_valcuota").html(cuotas+" de "+valor_cuota+"  "+moneda);
  }
  function generarCuotas(){
    var cant_cuotas = $(".tr_cuotas").length;
    if(cant_cuotas < 1){
    $("#generar_cuotas").attr("disabled",true);  
    var moneda_cuota = $("#monedas_cuotas").val();
    var suc = getSuc();
    if(   moneda_cuota === "G$"){
        $("#cotiz_cuota").val("1,00");  
    }else{ // U$
        $("#cotiz_cuota").val(parseFloat(us).format(2, 3, '.', ','));  
    }     
    var cotiz = float("cotiz_cuota");
    var  faltante = float("vuelto_faltante");
    var plan = $('input[name=plan]:checked').val();
    var cuotas = plan;
    if(plan == 4){
         cuotas = $("#n_cuotas").val();
    }
    if(isNaN(cuotas)){
        cuotas = 0;
    }
    var valor_cuota = parseFloat((faltante / cotiz) / cuotas);// Este no se puede tomar por el redondeo
    var tax = 2.3; // 2%
    var interes = 0;  // Se Calcula 
    var fecha_inicio =  $("#fecha_inicio").val() ;
    
    var total_factura = float("total_gs");
    
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: {"action": "generarCuotas",factura:factura,monto:valor_cuota, moneda: moneda_cuota, cuotas:cuotas,cotiz:cotiz,tax:tax,interes:interes,suc:suc,fecha_inicio:fecha_inicio,total_factura:total_factura},
        async: true,
        dataType: "json",
        beforeSend: function() {
            $("#msg_cuotas").html("<img src='img/loading.gif' height='20px' width='20px' >"); 
        },
        success: function(data) {  
           $(".cuotas_foot").remove(); 
                var total_moneda = 0;  
                var total = 0;
                for(var i in data){ 
                     var nro = data[i].id_cuota;
                     var moneda = data[i].moneda;
                     var monto = data[i].monto;
                     var tasa_interes = data[i].tasa_interes;  
                     var cotiz = data[i].cotiz;                        
                     var ret_iva = data[i].ret_iva;  
                     var monto_ref = data[i].monto_ref;
                     var valor_total = data[i].valor_total;
                     var vencimiento = data[i].vencimiento;  
                     var estado = data[i].estado;                       
                     var monto_ref_formated = parseFloat( monto_ref ).format(0, 3, '.', ',');  
                     //var valor_gs_formated = parseFloat( valor_ref ).format(0, 3, '.', ',');  
                     total += parseFloat( monto_ref ); 
                     total_moneda+= parseFloat( valor_total )
                     var paper_size = '<label>A4&nbsp;</label><input type="radio" value="9" name="paper_size_'+nro+'" checked="checked" >&nbsp;<label>Oficio</label><input type="radio" value="14" name="paper_size_'+nro+'" >'; 
                     $("#lista_cuotas") .append("<tr class='tr_"+nro+" cuotas tr_cuotas'><td class='itemc'>"+nro+"</td><td class='num' >"+monto+"</td><td class='itemc' >"+moneda+"</td><td class='num' >"+cotiz+"</td><td  class='itemc'>"+tasa_interes+"%</td><td  class='num' >"+ret_iva+"</td>\n\
                     <td class='num'>"+valor_total+"</td><td class='num'>"+monto_ref+"</td><td  class='itemc'>"+vencimiento+"</td><td  class='itemc'>"+paper_size+"<img id='img_"+nro+"' src='img/printer-01_32x32.png' width='22' height='20' style='cursor:pointer' onclick='imprimirPagare("+nro+")' > </td></tr>");                                       
                     $(".cuotas_bar").fadeIn();
                } 
                if(total > 0){
                    $("#tipo_factura").val("Credito");
                }else{
                    $("#tipo_factura").val("Contado");
                }
                total = parseFloat(total).format(2, 3, '.', ',');  
                total_moneda = parseFloat(total_moneda).format(2, 3, '.', ',');
                $("#lista_cuotas").append("<tr class='cuotas_foot'><td colspan='6' > </td> <td style='text-align: right;font-weight: bolder;font-size: 13px' class='total_cuotas_moneda' >"+total_moneda+"</td> <td style='text-align: right;font-weight: bolder;font-size: 13px' class='total_cuotas'>"+total+"</td><td></td> </tr>");
                $("#msg_cuotas").html("");    
                setRef();            
                $("#msg_cuotas").html(""); 
        }
    }); 
    }else{
      errorMsg("Elimine primero las cuotas existentes antes de generar nuevas",8000);
    }
  }
  
  function getReserva(){
    var ticket = $("#ticket_reserva").val();   
    var cod_cli = $("#codigo_cliente").val();  
    
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: {"action": "getValorReserva", "reserva": ticket,"cod_cli":cod_cli},
        async: true,
        dataType: "json",
        beforeSend: function() {
            $("#msg_reservas").html("Buscando datos de Reserva <img src='img/loading.gif' width='22px' height='22px' >"); 
        },
        success: function(data) {   
            var estado = data.estado;
            var expira = data.expira;
            if(estado != 'Error'){
                if(estado == 'Expirado'){
                   $("#msg_reservas").html("Este ticket ha vencido en la fecha : "+expira+" ");
                   $("#entrega_reserva").val(0);
                }else if(estado == 'Liberada'){
                    var valor =  parseFloat($.trim(data.valor)).format(2, 3, '.', ',');    
                    $("#entrega_reserva").val(valor);
                    $("#entrega_reserva").addClass("info");
                    $("#msg_reservas").html(""); 
                }else{ // Cualquier otro estado
                   $("#msg_reservas").addClass("error"); 
                   $("#msg_reservas").html("Esta reserva esta en estado : "+estado+" para que tenga efecto la reserva debe estar en Liberada");
                   $("#entrega_reserva").val(valor);  
                }
            }else{
              $("#msg_reservas").addClass("error");
              $("#msg_reservas").html(data.mensaje);  
              $("#entrega_reserva").val(0);
              $("#ticket_reserva").val(""); 
            }
             setRef(); 
        }
    });
  }  
  function imprimirPagare(nro){
      $("#img_"+nro).attr("src","img/printer-02_32x32.png");
      var ruc = $("#ruc_cliente").val();
      var suc = getSuc();
      var usuario = getNick();
      var papar_size = $('input[name=paper_size_'+nro+']:checked').val();
      var url = "caja/Pagare.class.php?factura="+factura+"&ruc="+ruc+"&suc="+suc+"&nro_pg="+nro+"&usuario="+usuario+"&papar_size="+papar_size;
      var title = "Impresion de Pagares";
      var params = "width=800,height=760,scrollbars=yes,menubar=yes,alwaysRaised = yes,modal=yes,location=no";
      
      if(typeof(showModalDialog) === "function"){ // Firefox         
         window.showModalDialog(url,title,params);             
      }else{
         window.open(url,title,params);        
      }
  }
   
  
  function imprimirFactura(){
     var factura_contable = $("#factura_contable").val();
     var tipo_factura = $("#tipo_factura").val();
     var pdv = $("#factura_contable option:selected").attr("data-pdv"); 
     var moneda = $("#moneda").val();
     
     if(factura_contable != ""){
         if($(".codigo_art").length > 0){
            var ruc = $("#ruc_cliente").val();
            var cliente = encodeURI($("#nombre_cliente").val());
            var suc = getSuc();
            var usuario = getNick();
            var papar_size = 9; // Dedocratico A4
            var tipo_fact = $("#tipo_fact").val();

            var url = "caja/ImpresorFactura.class.php?factura="+factura+"&ruc="+ruc+"&cliente="+cliente+"&suc="+suc+"&factura_legal="+factura_contable+"&usuario="+usuario+"&papar_size="+papar_size+"&tipo_factura="+tipo_factura+"&pdv="+pdv+"&man_pre="+tipo_fact+"&moneda="+moneda;
            var title ="Impresion de Facturas Contables";
            var params ="width=800,height=840,scrollbars=yes,menubar=yes,alwaysRaised = yes,modal=yes,location=no";
            if(typeof(showModalDialog) === "function"){ // Firefox
                window.showModalDialog(url,title,params);                      
            }else{
                window.open(url,title,params);                       
            }
         }else{
             Swal.fire("Nada que imprimir","","warning");
         }
     }else{
         Swal.fire("Debe Pre cargar las Facturas Contables para poder Imprimir","","warning");
     }
  }
  function eliminarCuotas(){
      $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: {"action": "eliminarCuotas", "factura": factura},
        async: true,
        dataType: "html",
        beforeSend: function() {
            $("#msg_cuotas").html("<img src='img/loadingt.gif' >");                      
        },
        complete: function(objeto, exito) {
            if (exito == "success") {                          
                $(".cuotas").remove();   $(".total_cuotas").html("0"); $(".total_cuotas_moneda").html("0");  
                setRef();    
                $(".cuotas_bar").fadeOut();
                $("#msg_cuotas").html("Cuotas eliminadas puede generar de nuevo...");  
                $("#tipo_factura").val("Contado");
            }
        },
        error: function() {
            $("#msg_cuotas").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    }); 
  }
  
   
  /**
   * float dado un id le saca el valor y devuelve un Numero valido
   * en caso de no ser un numero devuelve 0
   * @param {String} id
   * @returns {Number}
   */
  
  function float(id){
        //console.log("float id: "+id);
        if($("#"+id).length > 0){
            var n =  parseFloat($("#"+id).val().replace(/\./g, '').replace(/\,/g, '.'));
            if(isNaN(n)){
                return 0;
            }else{
                return n;
            }
        }else{
            return 0;
        }
  } 
  
  function setRef(){
      vuelto_gs = 0;
      var entrega_gs = float("entrega_gs");
      
      var entrega_rs = float("entrega_rs") * rs;
      var entrega_ps = float("entrega_ps") * ps;
      var entrega_us = float("entrega_us") * us; 
                
      var total_entrega_efectivo =  entrega_gs + entrega_rs +  entrega_ps + entrega_us  ;
      
      var total_convenios = parseFloat($(".total_convenios").text().replace(/\./g, '').replace(/\,/g, '.'));
      
      var total_cheques =  parseFloat($(".total_cheques").text().replace(/\./g, '').replace(/\,/g, '.'));
      
      var total_cuotas = parseFloat($(".total_cuotas").text().replace(/\./g, '').replace(/\,/g, '.'));
      
      var total_transferencias_bancarias = parseFloat($(".total_dep").val().replace(/\./g, '').replace(/\,/g, '.'));
      
      var reserva = float("entrega_reserva");
      
      var total_pagar_gs  = float("total_gs");
      var vuelvo_faltante = total_pagar_gs - (total_entrega_efectivo + total_convenios + total_cheques + total_cuotas + reserva + total_transferencias_bancarias +total_valor_puntos);
      vuelto_gs = vuelvo_faltante; 
      if(vuelvo_faltante <= 0){
         $("#label_vuelto_faltante").text("Vuelto:"); $("#vuelto_faltante").css("color","green");  $("#label_vuelto_faltante").css("color","green");  
         vuelvo_faltante*= -1; vuelto_gs*= -1;
         var total_gs = float("total_gs");
         
         if(vuelvo_faltante >  total_gs ){
            errorMsg("Vuelto no puede ser mayor al total",7000);
            $(".cerrar_venta").attr("disabled",true);
         }else{
            $(".cerrar_venta").removeAttr("disabled");
         }
              
      }else{
         $("#label_vuelto_faltante").text("Faltante:"); $("#vuelto_faltante").css("color","red"); $("#label_vuelto_faltante").css("color","red");  
         $(".cerrar_venta").attr("disabled",true);
      }        
      
      var total_entregado = total_entrega_efectivo + total_convenios + total_cheques + total_cuotas + reserva + total_transferencias_bancarias + total_valor_puntos;

      /**
       * Habilitar cobro en cuotas
       * si la diferencia entre limite de credito y entrega en efectivo es igual o mayor a cero
       */
      
      var cat = parseFloat($("#categoria").val());
      var ruc = $("#ruc_cliente").val();
      var limite = parseFloat($("#limite_credito").val().replace(/\./g,''));
      /*
      if(!(cat < 3)  && (0 <= (total_entregado + limite))){
        $("#tab_credito").fadeIn();
      }else{
        $("#tab_credito").fadeOut();
      } */
      $("#monedas_vuelto").val(mon_vuelto); // Mostrar vuelto en lamoneda que que ya se pre cargo
      $("#total_entrega").val(total_entregado.format(2, 3, '.', ','));
      calcVuelto(0);
      //$("#vuelto_faltante").val(vuelvo_faltante.format(2, 3, '.', ','));   
            
  }
  function calcVuelto(update){
     var mv = $("#monedas_vuelto").val();
     var vuelto = vuelto_gs;
     cotiz_vuelto = 1;
     if(mv == 'R$'){
        vuelto = vuelto_gs / rs;  cotiz_vuelto = rs;
     }else if(mv == 'P$'){
        vuelto = vuelto_gs / ps;  cotiz_vuelto = ps;
     }else if(mv == 'U$'){
        vuelto = vuelto_gs / us;  cotiz_vuelto = us;
     } 
     $("#vuelto_faltante").val(vuelto.format(2, 3, '.', ',')); 
     console.log(update+" "+mv+"  "+vuelto+"   "+cotiz_vuelto);
     if(update){
        actualizarVuelto();
     }
  }
  
  function borrarDescuento(factura){
   var tipo_doc = $("#fact_"+factura).attr("data-tipo_doc");
   
   $("#alert_msg").html("Esta a punto de eliminar el Descuento, confirme este procedimiento.<br>Los Descuentos para Cat. 1 y 2 solo estan permitidos para pagos en Efectivo");
   $("#dialog-confirm").attr("title","Que desea hacer?");   
   $( "#dialog-confirm" ).dialog({
      resizable: false,
      height:180,
      width:360,
      modal: true,
      dialogClass:"ui-state-highlight",
      buttons: {
        "Cancelar": function() {
          $( this ).dialog( "close" );
        },  
        "Borrar Descuento": function() {                
                $.ajax({
                      type: "POST",
                      url: "Ajax.class.php",
                      data: {"action": "borrarDescuentoDeFactura", "factura": factura,tipo_doc:tipo_doc},
                      async: true,
                      dataType: "html",
                      beforeSend: function() {
                          $("#trash_desc_"+factura).html("<img src='img/loadingt.gif' width='22px' height='22px' >"); 
                          $("#alert_msg").html("El Descuento se esta eliminando espere...<img src='img/loadingt.gif' width='22px' height='22px' >");
                      },
                      complete: function(objeto, exito) {
                          if (exito == "success") {                          
                             $("#trash_desc_"+factura).html(""); 
                             var total_bruto =  $("#total_bruto_"+factura).html();
                             $("#total_"+factura).html(total_bruto);
                             $("#total_desc_"+factura).html("0");
                             $("#trash_desc_"+factura).fadeOut("slow");
                             $( "#dialog-confirm" ).dialog( "close" );
                          }
                      },
                      error: function() {
                          alert("Ocurrio un error en la comunicacion con el Servidor...");
                      }
                  });       
                } 
        },        
        close: function() {            
          $( this ).dialog( "destroy" );
        }
      });  
  }
  function  guardarDatosConvenio(){
      var orden_beneficiario = $("#orden_benef").val();
      var valor_orden = $("#monto_orden").val();
      var nro_orden = $("#nro_orden").val();
      if(isNaN(valor_orden)){
          valor_orden = 0;          
      }
      $("#msg_conv").html("Guardando datos...");  
      $.post("Ajax.class.php", {action: "guardarDatosConvenio", "factura": factura, orden_beneficiario: orden_beneficiario, valor_orden: valor_orden,nro_orden:nro_orden},function(data){
           $("#msg_conv").html(data);  
      });
  }
  function imprimirTicket(){
      var factura = $("#factura").val();
      var cliente = $("#nombre_cliente").val();
      var ruc = $("#ruc_cliente").val(); 
      var suc = getSuc();
      
      var moneda =  $("#moneda").val();
      
      $("#ticket_caja").remove(); // Si existe lo elimino
      var t = $('<iframe id="ticket_caja" name="ticket_caja" style="width:0px; height:0px; border: 0px" src="caja/TicketCaja.class.php?factura='+factura+'&cliente='+cliente+'&ruc='+ruc+'&suc='+suc+'&moneda='+moneda+'">');
      t.appendTo(".popup_caja");    
  }
  function cerrarVenta(){
    $("#cerrar_venta").attr("disabled",true);
    var usuario = getNick(); 
    var moneda_vuelto = $("#monedas_vuelto").val();
    var vuelto = float("vuelto_faltante");
    var tipo_factura = $("#tipo_factura").val();
    
    var orden_beneficiario = $("#orden_benef").val();
    var valor_orden = $("#monto_orden").val();
    if((orden_beneficiario != "" && valor_orden <= 0) || valor_orden > 0 && orden_beneficiario == ""){
        errorMsg("Si la venta es de un Convenio revise los datos del Nro de Orden",20000);    
        return;
    }  
    
    if(vuelto > 0){
        var total_factura = parseFloat($("#total_gs").val().replace(/\./g, '').replace(/\,/g, '.'));   
        var total_convenios = parseFloat($(".total_convenios").text().replace(/\./g, '').replace(/\,/g, '.'));      
        var total_cheques =  parseFloat($(".total_cheques").text().replace(/\./g, '').replace(/\,/g, '.'));      
        var total_cuotas = parseFloat($(".total_cuotas").text().replace(/\./g, '').replace(/\,/g, '.'));
        var reserva = float("entrega_reserva");
        if((total_convenios + total_cheques + total_cuotas + reserva) >  (total_factura + ((total_factura * TOPE_ENTREGA) / 100)) ){
            errorMsg("La suma de Cheques, Tarjetas y cuotas no puede exeder el total de la factura + !",20000);
            return;
        } 
    }
    
    var ticket = $("#ticket_reserva").val();  
    var suc = getSuc();  parseFloat($("#total_gs").val().replace(/\./g, '').replace(/\,/g, '.'));   
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: {"action": "cerrarVenta", "usuario": usuario, "factura": factura,"moneda_vuelto":moneda_vuelto,"vuelto":vuelto,"cotiz":cotiz_vuelto,"vuelto_gs":vuelto_gs,ticket_reserva:ticket,suc:suc,tipo_factura:tipo_factura},
        async: true,
        dataType: "html",
        beforeSend: function() {
            $(".info").html("Cerrando Venta Favor Espere... <img src='img/loading.gif' width='22px' height='22px' >");                      
        },
        complete: function(objeto, exito) {
            if (exito == "success") {                          
                var result = $.trim(objeto.responseText); 
                if(result == "Ok"){
                   $("#fact_"+factura).remove();
                   $("#popup_caja").slideUp("fast"); 
                   $(".entrega").val(""); 
                   $(".info").html("Venta Cerrada con exito!!!");
                   Swal.fire({
                    title: 'Venta Cerrada, Desea crear otra Factura?', 
                    showCancelButton: true,
                    confirmButtonText: 'Si crear otra Factura',
                    cancelButtonText : 'No, Salir al Menu',
                  }).then((result) => {                    
                    if (result.isConfirmed) {
                       genericLoad("ventas/NuevaVenta.class.php");
                    } else {
                       showMenu();
                    }
                  });
                  
                }else{
                    $(".info").html("Ocurrio un Error durante la transaccion, recargue la lista y vuelva a intentarlo, en caso de que siga el error contacte con el Adminitrador...");    
                    alert("Informe Tecnico: Factura: "+factura+" ["+result+"]");
                }
            }
        },
        error: function() {
            $("#.info").addClass("error");
            $("#.info").html("Ocurrio un error en la comunicacion con el Servidor, favor intente mas tarde...");
            $("#cerrar_venta").removeAttr("disabled");
        }
    }); 
  }
  
function getLimiteCredito(){
    var CardCode = $("#codigo_cliente").val();
    $.post( "Ajax.class.php",{ action: "getLimiteCreditoCliente",CardCode:CardCode}, function( data ) {
       var es_funcionario = $("#nombre_cliente").val().indexOf("FUNCIONARI")>=0?true:false; 
       var Limite = parseFloat(data.Limite);
       var Cuotas = parseFloat(data.Cuotas);
       var Cheques = parseFloat(data.Cheques);
       var ChequesAlDiaNoProcesados = parseFloat(data.ChequesAlDiaNoProcesados);
       var EfectivoNoProc = parseFloat(data.EfectivoNoProc);
       var VentasNoProcesadas = parseFloat(data.VentasNoProcesadas);
       var CuotasAtrasadas = parseInt(data.CuotasAtrasadas);
       var CuotasAtrasadasPermitidas = parseInt(data.LIMITE_CUOTAS_ATRASADAS);
       
       var CantidadDeCuotas = parseInt(data.CANTIDAD_CUOTAS);
       var PlazoMaximo = parseInt(data.PLAZO_MAXIMO);
       
       if(CantidadDeCuotas == 1 ){
           $("#p2").prop("disabled",true);
           $("#p3").prop("disabled",true);           
           $("#pn").prop("disabled",true);           
       }else if(CantidadDeCuotas == 2 ){           
           $("#p3").prop("disabled",true);           
           $("#pn").prop("disabled",true);           
       }else if(CantidadDeCuotas == 3 ){                      
           $("#pn").prop("disabled",true);           
       }else if(CantidadDeCuotas > 3 ){    
           $(".cuota_x").prop("disabled",false);
           $(".cuota_x").fadeIn();  console.log( "  for ");
           for(var i = (CantidadDeCuotas + 1 );i <= 60;i++  ){                
               $(".n_cuota_"+i ).prop("disabled",true);
               $(".n_cuota_"+i ).fadeOut();
           }
       }
       
       if(PlazoMaximo == 30 ){
           $("#p2").prop("disabled",true);
           $("#p3").prop("disabled",true);           
           $("#pn").prop("disabled",true);           
       }else if(PlazoMaximo == 60 ){           
           $("#p3").prop("disabled",true);           
           $("#pn").prop("disabled",true);           
       }else if(PlazoMaximo == 90 ){                      
           $("#pn").prop("disabled",true);           
       } 
       
       console.log("Limite "+Limite);       
       console.log("CantidadDeCuotas "+CantidadDeCuotas);
       console.log("PlazoMaximo "+PlazoMaximo);
       //console.log("Limite "+Limite);
       
       var Diff = parseFloat(Limite - (Cuotas + Cheques + VentasNoProcesadas) + (EfectivoNoProc + ChequesAlDiaNoProcesados)); 
       var deuda_actual = (Cuotas + Cheques + VentasNoProcesadas) + (EfectivoNoProc + ChequesAlDiaNoProcesados);
       
       $("#limite_credito").val( ( Diff).format(0, 3, '.', ','));
       
       var limite_vs_cant_cuotas_y_diff = ( Limite > 0 && CantidadDeCuotas > 0 && Diff >= 0 );
       var cuotas_atrasadas_vs_permitidas = (CuotasAtrasadas < CuotasAtrasadasPermitidas) || (CuotasAtrasadas == 0); 
        console.log("CuotasAtrasadas "+CuotasAtrasadas+"  CuotasAtrasadasPermitidas  "+CuotasAtrasadasPermitidas);
         
        console.log("limite_vs_cant_cuotas_y_diff:  "  +limite_vs_cant_cuotas_y_diff + " cuotas_atrasadas_vs_permitidas  "+ cuotas_atrasadas_vs_permitidas +"  Diff  "+Diff+"  Deuda actual = "+deuda_actual+"  ");
        
        /*
        if((( Limite > 0 && CantidadDeCuotas > 0 && Diff >= 0 ) && (cuotas_atrasadas_vs_permitidas))   || (es_funcionario)  ){
                      
        }else{
            $("#tab_credito").fadeOut();
        } */
        
        //$("#tab_credito").fadeIn();  
         
         
        //$(".limite_credito").fadeIn();
        if(Diff <= 0){
           $("#limite_credito").css("color","red"); 
        }else{
           $("#limite_credito").css("color","green");  
        } 
        if(CantidadDeCuotas != null){
            if(PlazoMaximo != ""){
               $("#msg_cuotas").html("Cantidad de cuotas: "+CantidadDeCuotas+" Plazo maximo: "+PlazoMaximo+" dias");
               $("#msg_cuotas").css("background","red").css("color","white");
            }
        }
                
        var CardCode = $("#codigo_cliente").val();
        
        if(CuotasAtrasadas > CuotasAtrasadasPermitidas && getSuc() != "00" &&  !es_funcionario   ){
           //$("#tab_credito").fadeOut();
           errorMsg("Cliente tiene "+CuotasAtrasadas+" cuotas atrasadas...",25000); 
        }
    },'json'); 
}  

function completar(id){
   var total =   parseFloat(($("#total_"+id).val()).replace(/\./g, '').replace(/\,/g, '.'));
   var entrega_actual =   parseFloat(($("#entrega_"+id).val()).replace(/\./g, '').replace(/\,/g, '.'));
   if(entrega_actual > 0){
       $("#entrega_"+id).val(0);
       //$("#comp_"+id).val("&#x25C0;");
   }else{ 
       $("#entrega_"+id).val(total);
       //$("#comp_"+id).val("&#x25BC;");
   } 
   $("#entrega_"+id).trigger("change");
}

function completarTarjeta(){
    var total =   parseFloat(($("#total_gs").val()).replace(/\./g, '').replace(/\,/g, '.'));
    var entrega_actual =   parseFloat(($("#total_entrega").val()).replace(/\./g, '').replace(/\,/g, '.'));    
    var diff = parseFloat(total - entrega_actual);
    $("#monto_conv").val(diff);
    $("#entrega_gs").trigger("change");
    $(".entrega_conv").trigger("change");
}

function getPuntos(){
    var cod_cli = $("#codigo_cliente").val();
    $.ajax({
        type: "POST",
        url: "ventas/FacturaVenta.class.php",
        data: {action: "getPuntos", cod_cli: cod_cli},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            $(".puntos_row").remove();
        },
        success: function (data) {   
            for(var i in data){
                var id = data[i].id;  
                var puntos = data[i].puntos;  
                var valor = data[i].valor;  
                var motivo = data[i].motivo;
                var fecha = data[i].fecha;  
                var fecha_canje = data[i].fecha_canje===null?"":data[i].fecha_canje;
                var estado = data[i].estado;     
                var valor_puntos = puntos * valor;
                var valor_puntos_formatted = (valor_puntos).format(0, 3, '.', ',');
                        
                $("#lista_puntos").append("<tr class='puntos_row fila_puntos_"+id+"'  > <td class='itemc'>"+fecha+"</td> <td class='itemc'>"+puntos+"</td><td class='item'>"+motivo+"</td><td class='num'>"+valor_puntos+"</td><td class='itemc'>"+estado+"</td><td class='itemc'><input onclick='sumarPuntos()' type='checkbox' class='check_puntos' data-valor='"+valor_puntos+"' id='check_"+id+"' data-id='"+id+"'></td></tr>");
            } 
            
            $("#lista_puntos").append("<tr class='puntos_row'><td>Total:</td><td class='cant_puntos num' style='font-weight:bolder'></td><td ></td><td class='total_puntos num' style='font-weight:bolder'></td><tr>");
           
            
            $("#msg").html(""); 
             
            
        },
        error: function (e) {                 
            $("#msg").html("Error obtener moviles:  " + e);   
            errorMsg("Error obtener moviles:  " + e, 10000);
        }
    });         
}

function sumarPuntos(){
    var total = 0;
    $(".check_puntos").each(function(){
        if($(this).is(":checked")){
         var valor = parseFloat($(this).attr("data-valor"));
         total+=0+valor;
        }
    }); 
    total_valor_puntos = total;
    
    $(".total_puntos").html((total).format(0, 3, '.', ','));
    setRef();
}