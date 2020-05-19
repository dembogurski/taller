var decimales = 0;
var cant_articulos = 0;
var fila_art = 0;

var id = 0;

var stockComprometido = false;
var PORCENTAJE_PERMITIDO = 5; //5%
var PORCENTAJE_AJUSTE_PERMITIDO = 20; //10% si > 10 sino 20%      

var current_keypad_id = "";
var usuarios = new Array("douglas","fabiana");
  
function configurar(){
   $("#lote").focus();    
   $("#lote").change(function(){
        buscarLote();
   });
   $(".numeric").change(function(){
       var v = $(this).val();
       if(isNaN(v)){
           $(this).val(0);
       }
   });
   $(".nro_emision").each(function(){
        var nro_emision = $(this).html();
        var nro_orden = $(this).attr("data-nro_orden");
       
        if(nro_emision != ""){
            $(".codigo_ped_"+nro_orden).each(function(){
                var codigo = $(this).html();  
                // alert(nro_emision+"  "+codigo);
                buscarResumenAsignados(nro_orden,nro_emision,codigo);
            });
        }
    });
    setHotKeyArticulo();
     $("#ui_articulos").draggable();
    
 }
function cerrarPopup(){
    $("#confec_popup").slideUp();
    $("div#imgPopUpConfec").hide();
}
function procesarLotes(codigo,nro_emision,nro_orden){
        $("#confec_popup").slideDown();        
        var medida = $("#asigned_"+codigo+"-"+nro_emision).prev().prev().html();
        $(".span_medida").html(medida);
        medida = medida.replace(",",".");
        $("#medida").val(medida);
        
        $("#nro_emision").val(nro_emision);
        $("#nro_orden").val(nro_orden);
        $(".nro_emision").html(nro_emision);
        $("#codigo_ref").val(codigo);
        $(".articulo").html(codigo);
     
        $("#tipo_design").val(   $("#tr_"+nro_emision+"_"+codigo+"").attr("data-tipo"));
    
        var anchor = $(".codigo_ped_"+nro_orden).attr("data-anchor");
        $("#anchor").val(anchor);
        
        var w = $(window).width();
        var asw = $("#confec_popup").width();
        var esii = (w / 2) - (asw / 2);
        $("#confec_popup").offset({top:50,left: esii });
        $(".confec_form input[type='text']").val("");
        $("#lote").focus();     
        listarLotesAsignados(codigo,nro_emision);
}
 
function listarLotesAsignados(codigo,nro_emision){
     
    $.ajax({
        type: "POST",
        url: "produccion/OrdenFabric.class.php",
        data: {"action": "listarLotesAsignados", nro_emision: nro_emision,codigo:codigo},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $(".fila_asign").remove();
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {   
            for (var i in data) { 
                var codigo = data[i].codigo;
                var lote = data[i].lote;
                var img = data[i].img;
                var descrip = data[i].descrip;   
                var color = data[i].color;
                var design = data[i].design;
                var cant_lote = data[i].cant_lote;
                var cortes = data[i].cortes;
                var tipo_saldo = data[i].tipo_saldo!= null?data[i].tipo_saldo:"";
                var saldo = data[i].saldo!=null?data[i].saldo:"";
                var diff  = data[i].diff != null?data[i].diff:"";
                var medida  = data[i].largo != null?data[i].largo:"";
                var codigo_om = data[i].codigo_om;
                var  fila_orig = data[i].fila_orig;
                var addclass = "";
                var complete_img = "";
                if(tipo_saldo == "Articulo" && codigo_om == null){ // Padre
                    addclass = " procesado";
                    complete_img = "<img src='img/ok.png' width='16px' height='16px' >";
                }else if((tipo_saldo == "Articulo" && codigo_om != null) || (tipo_saldo == "Retazo" && diff != null && fila_orig == 0) || (tipo_saldo == "Ajuste" && diff != null)){
                    addclass = " fracciones";
                }else if(tipo_saldo == "Retazo" && diff != null && fila_orig == 1){
                     addclass = " procesado";
                }else{
                    addclass = "";
                }
                var printer = "";
                
                if(tipo_saldo == "Retazo" && saldo != ""){
                    printer = '<img src="img/printer-01_32x32.png"  onclick="imprimirlote('+lote+','+saldo+')" style="margin:2px;width:26px;cursor:pointer">';
                }
                if(tipo_saldo == "Articulo" && codigo_om != null){
                    tipo_saldo = codigo_om;
                }
                var checked = $("#detailed").is(":checked");
                var mostrar = " style='display:none'"
                if(fila_orig == 1){
                    mostrar = "";
                }else if(fila_orig == 0 && checked ){
                    mostrar = "";
                }else{
                    mostrar = " style='display:none'"
                }       
                $("#detalle_asign").append("<tr class='fila_asign fila_"+nro_emision+"_"+lote+" lote_"+lote+""+addclass+"' "+mostrar+" ><td class='item codigo'>"+codigo+"</td><td data-img='"+img+"' class='item lote_confec' onclick='mostrarImagen($(this))'>"+lote+"</td><td  class='item descrip'>"+descrip+"</td><td  class='item color'>"+color+"</td><td  class='item design'>"+design+"</td><td  class='num stock'>"+cant_lote+"</td><td  class='num medida'>"+medida+"</td><td  class='num cortes'>"+cortes+"</td><td  class='itemc tipo_saldo'>"+tipo_saldo+"</td><td id='saldo_lote_"+lote+"' class='num saldos'>"+saldo+"</td><td  class='itemc'>"+printer+"</td><th class='msg_"+lote+"' >"+complete_img+"</th><td class='itemc'><img src='img/trash_mini.png' onclick='borrarCorte("+nro_emision+","+lote+")' style='cursor:pointer'></td></tr>");       
            }   
            $("#msg").html(""); 
        }
    });
}
function mostrarImagen(target){
    var baseURL = $("#images_url").val();
    var img = target.data('img');
    $("div#imgPopUpConfecContainer img.imagen").prop("src",baseURL+'/'+img+'.jpg');
    $("div#imgPopUpConfec").show();
}
function noImage(Obj){
    Obj.prop("src",$("#images_url").val()+"/0/0.jpg");
}
function cerrarImgPopUp(){
    $("div#imgPopUpConfec").hide();
}
function borrarCorte(nro_emision,lote){
    
    $.ajax({
        type: "POST",
        url: "produccion/Fabrica.class.php",
        data: {"action": "borrarCorte", "usuario": getNick(), "nro_emision": nro_emision,lote:lote},
        async: true,
        dataType: "html",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        complete: function (objeto, exito) {
            if (exito == "success") {                          
                var result = $.trim(objeto.responseText);
                if(result == "Ok"){
                    var codigo_ref = $("#codigo_ref" ).val();
                    listarLotesAsignados(codigo_ref,nro_emision);
                }else{
                    alert("Ocurrio un error en la comunicacion con el Servidor...");
                }
            }
        },
        error: function () {
            $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    }); 
    
    
}
function mostrarOcultarDetalles(){ 
    var codigo_ref = $("#codigo_ref").val();    
    var nro_emision = $("#nro_emision").val();
    listarLotesAsignados(codigo_ref,nro_emision);
}
function buscarResumenAsignados(nro_orden,nro_emision,codigo){
    
    $.ajax({
        type: "POST",
        url: "produccion/OrdenFabric.class.php",
        data: {"action": "buscarResumenAsignados", nro_emision: nro_emision,codigo:codigo},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#asigned_"+codigo+"-"+nro_orden).html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {   
            var asignado = data.asignado;
            $("#asigned_"+codigo+"-"+nro_emision).html(asignado); 
            var req = parseFloat( $("#asigned_"+codigo+"-"+nro_emision).prev().html().replace(".",""));
            var porc = req * PORCENTAJE_PERMITIDO / 100;
            var min = req - porc;
            var max = req + porc;

            if(asignado > min){
               $("#msg").html("Asignacion completa. <img src='img/ok.png'>");
               $("#asigned_"+codigo+"-"+nro_orden).addClass("correcto");
            }else{
              $("#msg").html("");  
              $("#asigned_"+codigo+"-"+nro_orden).removeClass("correcto");
            }
        }
    });
}
 
function showKeyPad(id){
    showNumpad(id,buscarLote,false);
}
function showKeyPadCortes(id){
    showNumpad(id,calcAjuste,false);
}
function showKeyPadSaldo(id){
    current_keypad_id = id;
    showNumpad(id,calcAjuste,false);
}
function calcAjuste(){
    var descrip = $("#descrip").val();
     
    var stock = parseFloat($("#stock").val());
    if(stock <= 10){
        PORCENTAJE_AJUSTE_PERMITIDO = 20;
    }else{
        PORCENTAJE_AJUSTE_PERMITIDO = 10;
    }
    
    var cortes = parseFloat($("#cortes").val());
    if(isNaN(cortes)){
        $("#cortes").val("0");
        cortes = 0;
    }
    var medida = parseFloat($("#medida").val());
    
    var calc = cortes *  medida;
    $("#calc").html(calc);
    // var saldo = stock - calc;   
    
    var saldo = parseFloat($("#saldo").val());
    if(isNaN(saldo)){
        saldo = 0;
        $("#print_saldo").fadeOut();
    }else{
        $("#print_saldo").fadeIn();
    }
     
    var cant_om =  parseFloat( $("#cant_om").val());
    if(isNaN(cant_om)){
        cant_om = 0;
    }
    var diff = stock - (calc + cant_om + saldo);
    
    //console.log("stock "+stock +"  cant_om "+cant_om+"  calc " +calc +"  saldo "+saldo);
    
    diff = (diff).toFixed(2);
    $("#diff").val(diff);   
    
    var ajuste = $("#diff").val();  
    var valor_permitido_ajuste = (stock * PORCENTAJE_AJUSTE_PERMITIDO) / 100;
    if(ajuste < 0){
        ajuste *-1;
    }
    if(ajuste > valor_permitido_ajuste || descrip == ""){
        $("#agregar").prop("disabled",true);
         
            var d = $("#diff").val();
            var pos = usuarios.indexOf(getNick());
             
            
            if(d > 0 && pos > -1 && cortes > 0 ){
                $("#agregar").removeAttr("disabled");
            }else{
                $("#agregar").prop("disabled",true);
            }
        
    }else{
        $("#agregar").removeAttr("disabled");
    }  
    if(current_keypad_id == "saldo"){
        setPrecioRetazo();
    }
}
function setPrecioRetazo(){
    var codigo =$("#codigo").val();
    var lote =$("#lote").val();
    $.ajax({
        type: "POST",
        url: "produccion/Fabrica.class.php",
        data: {"action": "setPrecioRetazo", "usuario": getNick(), "suc": getSuc(),codigo:codigo,lote:lote},
        async: true,
        dataType: "html",
        beforeSend: function () {
            $("#print_saldo").attr("src","img/loading_fast.gif"); 
        },
        complete: function (objeto, exito) {
            if (exito == "success") {                          
                var result = $.trim(objeto.responseText);
                if(result == "Ok"){
                   $("#print_saldo").attr("src","img/printer-01_32x32.png"); 
                }else{
                    $("#print_saldo").attr("src","img/warning_red_16.png"); 
                }
            }
        },
        error: function () {
            $("#print_saldo").attr("src","img/warning_red_16.png"); 
        }
    }); 
}
 
function agregarCortes(){
        var tipo = $("#tipo_saldo").val();   
        var nro_emision = $("#nro_emision").val();  
        var nro_orden = $("#nro_orden").val();
        var codigo = newFunction();       
        var lote = $("#lote").val();       
        var cortes = parseFloat($("#cortes").val());
        var medida = parseFloat($("#medida").val());
        var saldo = parseFloat($("#saldo").val());
        var ajuste = parseFloat( $("#diff").val() );
        var codigo_ref = $("#codigo_ref").val();
        var stock = $("#stock").val();
        var array_codigos_om = new Array();
        var tipo_saldo = "Retazo";

        // H0244, IN030 Hilos OverLock
        /*if(/H0244|IN030/.test(codigo)){
            cortes = 0;
        }*/

        if(tipo != "Saldo Retazo"){ 
            
            $(".pack").each(function(){
               var codigo = $(this).attr("data-codigo");
               var largo = parseFloat($(this).attr("data-largo"));
               var obj = {"codigo":codigo,"largo":largo};
               array_codigos_om.push(obj);
            });
        
             
            tipo_saldo = "Articulo";
            if(isNaN(saldo)){
                saldo = 0;
            }
            if(isNaN(ajuste)){
                alert("Cargue un saldo o Saldo de Retazo si existe o 0 ex corte exacto");
                return;
            }             
        } 
         
        var codigo_om = JSON.stringify(array_codigos_om);
        $.ajax({
            type: "POST",
            url: "produccion/Fabrica.class.php",
            data: {"action": "agregarCortes",usuario:getNick(),codigo_ref:codigo_ref, nro_emision: nro_emision,nro_orden:nro_orden,codigo:codigo,lote:lote,stock:stock,cortes:cortes,medida:medida,saldo:saldo,codigo_om:codigo_om,ajuste:ajuste,tipo_saldo:tipo_saldo,suc:getSuc()},
            async: true,
            dataType: "json",
            beforeSend: function () {
                $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            },
            success: function (data) {   
                 if(data.estado == "Ok"){
                     $("#agregar").prop("disabled",true);
                     $(".fila_"+nro_emision+"_"+lote).removeClass("encontrado");
                     $(".fila_"+nro_emision+"_"+lote).addClass("procesado");
                     $(".msg_"+lote).prev().html(ajuste);    
                     var saldo_format = parseFloat(saldo).format(2, 3, '.', ',');
                     $(".msg_"+lote).prev().prev().html(saldo_format);
                     $(".msg_"+lote).prev().prev().prev().html(tipo_saldo);
                     $(".msg_"+lote).prev().prev().prev().prev().html(cortes);
                     
                     $(".msg_"+lote).html("<img src='img/ok.png' width='16px' height='16px' >");
                     $("#msg").html("Ok");
                     $(".confec_form input[type=text]").val("");
                     $("#lote").focus();
                     $("#codigo_om").html("");
                     var codigo_ref = $("#codigo_ref").val();      
                     listarLotesAsignados(codigo_ref,nro_emision);
                 }else{                                 
                    $("#msg").html(data);
                 }   
            }
        });    


    function newFunction() {
        return $("#codigo").val();
    }
}

function buscarLote(){
   $("#warning").html(""); 
   $("#stockreal, #ajuste, #motivo").val('');
   $("#ajustar").attr('Disabled','Disabled')
   var lote = $("#lote").val();
   
   $(".encontrado").removeClass("encontrado");
   if($(".lote_"+lote).hasClass("procesado")){
       alert("Este lote ya ha sido procesado");
   }else{
        if($(".lote_"+lote).length > 0){
            var codigo = $(".lote_"+lote).find(".codigo").html();
            $(".lote_"+lote).addClass("encontrado");
            $("#codigo").val( codigo );
            $("#stock").val( $(".lote_"+lote).find(".stock").html());
            $("#descrip").val( $(".lote_"+lote).find(".descrip").html());
            $("#design").val( $(".lote_"+lote).find(".design").html());
            $("#color").val( $(".lote_"+lote).find(".color").html());
            $("#msg").removeClass("noencontrado");
            var rowpos = $(".lote_"+lote).position();
            $('#container_design').scrollTop(rowpos.top-30);
            
            if(codigo == 'IN030' || codigo == 'IN036'){
                var stock = parseFloat($("#stock").val());
                var medida = parseFloat($("#medida").val());
                var cortes = stock / medida;
                $("#cortes").val(cortes); 
            }else{
                buscarMedida(codigo);
            }            
            
        }else{        
            $(".lote_"+lote).removeClass("encontrado");
            $("#msg").addClass("noencontrado");
            $("#msg").html("Lote no encontrado o no asignado.");       
            $(".confec_form input[type=text]:not('#lote')").val("");
            $("#lote").focus();
            $("#lote").select();
        }
        $("#cortes").focus();   
        var tipo = $("#tipo_saldo").val();
        if(tipo == "Articulo Otra Medida"){
          cambiarTipoSaldo();
        }
   }
}
function buscarMedida(codigo){
    var articulo =$(".articulo").html();
    $.ajax({
        type: "POST",
        url: "produccion/Fabrica.class.php",
        data: {"action": "buscarMedida", articulo: articulo,codigo:codigo},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >");     
        },
        success: function (data) {               
            var Cantidad = data.Cantidad; 
            $("#medida").val(Cantidad);
            var cant = parseFloat(Cantidad);
            $(".span_medida").html(cant);
            
            $("#msg").html(""); 
        }
    });
    
}
function cambiarTipoSaldo(){
    var tipo = $("#tipo_saldo").val();
    if(tipo == "Articulo Otra Medida"){
       $("#tipo_saldo").val("Saldo Retazo");
       $(".articulo_om").fadeOut();             
       //$(".saldo").fadeIn();               
    }else{
       $("#tipo_saldo").val("Articulo Otra Medida");
       $("#codigo_om").html("");
       $(".articulo_om").fadeIn();
       //$(".saldo").fadeOut();
       //$("#saldo").val("0");
       $("#cant_om").val("0");
    }
    calcAjuste();
}

function buscarArticulo(){
    //var articulo = $("#codigo_om").val();
    var articulo = "%"+$("#tipo_design").val();
    var disenho = "%"+$("#design").val();
    var cat = 1;
    fila_art = 0;
    var anchor = $("#anchor").val();
    $.ajax({
        type: "POST",
        url: "produccion/OrdenFabric.class.php",
        data: {"action": "buscarArticulos", "articulo": articulo,"cat":cat,"anchor":anchor,"disenho":disenho},
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
                    var ItemCode =  (data[i].ItemCode).toString().toUpperCase();
                    var Sector = data[i].Sector;
                    var NombreComercial = data[i].NombreComercial; 
                    var Precio =  parseFloat(  (data[i].Precio) ).format(0, 3, '.', ',');
                    var Anchor = parseFloat(data[i].Anchor).format(2, 3, '.', ',');
                    var Largo = parseFloat(data[i].Largo).format(2, 3, '.', ',');
                    var Especificaciones = data[i].U_ESPECIFICA;
                    var UM = data[i].UM;         
                                                                         
                    $("#lista_articulos") .append("<tr style='font-size:18px' class='tr_art_data fila_art_"+i+"' data-sector="+Sector+" data-ancho="+Anchor+" data-largo="+Largo+" data-precio="+Precio+" data-um="+UM+"><td style='height:30px' class='itemc clicable_art'><span class='codigo' >"+ItemCode+"</span></td>\n\
                    </td><td class='item clicable_art'><span class='NombreComercial'>"+NombreComercial+"</span></td> \n\
                    <td class='itemc clicable_art'>"+Largo+"</td></tr>");
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
function limpiarListaArticulos(){    
    $(".tr_art_data").each(function () {   
       $(this).remove();
    });    
} 
 
function setDefaultDataNextFlag(){
    data_next_time_flag = true;
}
function setHotKeyArticulo(){
     
    $("#codigo_om").keydown(function(e) {
        
        var tecla = e.keyCode;  console.log(tecla);  
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
    $(".fila_art_" + row).addClass("art_selected");
    $(".cursor").remove();
    $($(".fila_art_" + row + " td").get(2)).append("<img class='cursor' src='img/l_arrow.png' width='18px' height='10px'>");
    escribiendo = false;   
} 

function selectArt(id){
    $(".pack_selected").removeClass("pack_selected");
    $("#"+id).addClass("pack_selected");    
}
function calcTotalArtOM(){
    var suma = 0;
    $(".pack").each(function(){
        var largo = parseFloat($(this).attr("data-largo"));
        suma += largo;
    });
    $("#cant_om").val(suma);
    calcAjuste();   
}
function eliminarArticulo(id){
    $("#"+id).remove();
    calcTotalArtOM();
}
function seleccionarArticulo(obj){
    var codigo = $(obj).find(".codigo").html();
    var sector = $(obj).attr("data-sector"); 
    var nombre_com = $(obj).find(".NombreComercial").html();  
    var precio = $(obj).attr("data-precio");
     
    var ancho =  parseFloat( $(obj).attr("data-ancho").replace(",","."));
    var largo =  parseFloat( $(obj).attr("data-largo").replace(",",".")); 
    var unif = ancho+" x "+largo;
    
    
    var pack = "<div class='pack' onclick=selectArt('pack_"+id+"') data-codigo='"+codigo+"' data-largo='"+largo+"'  id='pack_"+id+"' ><div style='width:86%;float:left;font-size:16px'>  <span>"+codigo+"</span>&nbsp;-&nbsp;<span>"+unif+"</span> </div> <div style='width:8%;float:right;font-family:arial;font-weight:normal;margin: 0px 2px 0px 2px;border:solid gray 1px;text-align:center' onclick=eliminarArticulo('pack_"+id+"') >x</div></div>";
    id++;
    
    $("#codigo_om").append(pack);
    //$("#descrip_om").val(sector+"-"+nombre_com);
    
    //$("#cant_om").val($(obj).attr("data-largo"));
    $("#ui_articulos").fadeOut();   
    $("#cantidad").focus();
    
    calcTotalArtOM(); 
}

function finalizarEmision(nro_emision){
    $.ajax({
        type: "POST",
        url: "produccion/Fabrica.class.php",
        data: {"action": "finalizarEmision", "nro_emision": nro_emision,"usuario":getNick()},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            $("#finalizar_"+nro_emision).prop("disabled",true);
        },
        success: function (data) {                
            var estado = data.estado;
          
            if(estado == "Error"){
                
                if(data.msg == "DiffProc"){
                
                var proc = parseInt(data.procesados);
                var no_proc = parseInt(data.no_procesados);
                var total = proc + no_proc;                
                
                alert("Falta procesar "+no_proc+" lotes, total lotes procesados: "+proc+"/"+total+" "); 
                
                }else{
                     alert(data.msg); 
                }
            }else{
                 generarReciboProduccion(nro_emision);
            }
            
        }
    });
}
function generarReciboProduccion(nro_emision){
   var server_ip = location.host;
   var url = "http://"+server_ip+":8081" // Desmarcar despues
   //var url = "http://localhost:8081";
   var data = {
        "action": "generarReciboProduccion",
        "NroEmision": nro_emision
    };
    $.post(url, data, function(data) {
        if (data.status == "ok") {
            $("#msg").html("Ok"); 
            alert("El recibo de produccion has sido generado con exito");
            genericLoad("produccion/Fabrica.class.php");
        } else {
           alert("Error en la comunicacion con el servidor, intente enviar nuevamente."); 
        }
    }, "jsonp").fail(function() {
         alert("Error en la comunicacion con el servidor.");
    });    
}

function buscarDatosDeOrden(){
    var nro_emision = $("#nro_emision").val();
    $.ajax({
        url: "produccion/Fabrica.class.php",
        data: {"action": "buscarDatosDeOrden", "nro_emision": nro_emision},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("Recuperando datos de Orden de Produccion.  <img src='img/loading_fast.gif' width='16px' height='16px' > "); 
        },
        success: function (data) {
            $(".fila_td").remove();
            var nro_orden = data[0].nro_orden;
            var cod_cli = data[0].cod_cli;
            var cliente = data[0].cliente;
            var usuario = data[0].usuario;
            var fecha = data[0].fecha;
            $(".datos_orden").append("<tr class='fila_td'> \n\
                    <td><b>Nro Orden:</b>"+nro_orden+"</td>\n\
                    <td><b>Cod Cliente:</b>"+cod_cli+"</td>\n\
                    <td><b>Cliente:</b>"+cliente+"</td>\n\
                    <td><b>Usuario:</b>"+usuario+"</td>\n\
                    <td><b>Fecha:</b>"+fecha+"</td> </tr>");
             //o.nro_orden,cod_cli,cliente,o.usuario,DATE_FORMAT(o.fecha,'%d-%m-%Y') AS fecha
            
            $("#msg").html(""); 
        }
    });
}

function buscarEmision(){
    buscarDatosDeOrden();
    var nro_emision = $("#nro_emision").val();
    $.ajax({
        url: "produccion/Fabrica.class.php",
        data: {"action": "planillaProduccion", "nro_emision": nro_emision},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("Recuperando Planilla de Produccion.  <img src='img/loading_fast.gif' width='16px' height='16px' > "); 
        },
        success: function (data) {
            //id_res,codigo,lote,descrip,color,design,cant_frac AS unidades,usuario
            $(".fila").remove();
            for (var i in data) { 
                var id_res = data[i].id_res;
                var fecha = data[i].fecha;     
                var usuario = data[i].usuario;  
                var codigo = data[i].codigo;       
                var lote = data[i].lote;        
                var descrip = data[i].descrip;                
                var design = data[i].design;        
                var unidades = data[i].unidades; 
                $(".planilla").append("<tr class='fila'><td class='itemc'>"+id_res+"</td><td class='item'>"+usuario+"</td><td class='itemc'>"+fecha+"</td><td class='item'>"+codigo+"</td><td class='item'>"+lote+"</td><td class='item'>"+descrip+"</td><td class='item'>"+design+"</td><td class='num'>"+unidades+"</td><td class='itemc'><img src='img/printer-01_32x32.png'  onclick='imprimirlote("+lote+",null)' style='margin:2px;width:26px;cursor:pointer'></td></tr>");   
            }   
            $("#msg").html(""); 
        }
    });
}
function imprimirCodigoRef(){
    var codigo = $("#codigo_ref").val();
    imprimirCodigo(codigo);
}
function imprimirCodigoOM(){
    var codigo_om = $(".pack_selected" ).attr("data-codigo");
    if(codigo_om != ""){
        imprimirCodigo(codigo_om);
    }else{
        alert("Elija un codigo de otra medida antes de imprimir");
    }
}
function imprimirlote(lote,metros){    
    var suc = getSuc();
    var usuario = getNick();   
    var random = parseInt( Math.random() * 1000);
    //var metros = $("#saldo_lote_"+lote).html();
    var url = "barcodegen/BarcodePrinter.class.php?codes="+lote+"&usuario="+usuario+"&random="+random;
    if(metros != null){    
       url = "barcodegen/BarcodePrinter.class.php?codes="+lote+"&usuario="+usuario+"&metros="+metros+"&random="+random;;
    }
    var title = "Impresion de Codigos de Barras";
    var params = "width=800,height=480,scrollbars=yes,menubar=yes,alwaysRaised = yes,modal=yes,location=no";
    window.open(url,title,params);  
}
function imprimirSaldo(){
    var src = $("#print_saldo").attr("src");
    if(src == "img/printer-01_32x32.png"){
       var lote = $("#lote").val();
       var metros = parseFloat($("#saldo").val());
       imprimirlote(lote,metros);
    }else{
        alert("Actualizando precio favor espere!");
    }
}

function imprimirCodigo(codigo){
    var random = parseInt( Math.random() * 1000);
    var url = "produccion/Fabrica.class.php?action=imprimirCodigo&codigo="+codigo+"&usuario="+getNick()+"&random="+random; 
    var title = "Impresion de Codigos y Medidas";
    var params = "width=800,height=480,scrollbars=yes,menubar=yes,alwaysRaised = yes,modal=yes,location=no";
    window.open(url,title,params);  
}
