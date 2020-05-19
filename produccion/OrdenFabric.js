var ping_time = 0;

var timeout = null;
var check_flag = true;

var data_next_time_flag = true;
 
var loadDesings = false;
 
var designs = ['ABORIGEN', 'BULGAROS'];
 
var decimales = 0;
var cant_articulos = 0;
var fila_art = 0;

var nro_orden = 0;

var PORCENTAJE_PERMITIDO = 4;         

function configurar(){
      
    $(".numeros").change(function(){
        var decimals = 0;
         
        var n = parseFloat($(this).val() ).format(decimals, 3, '.', ',') ;
        $(this).val( n  );
        if($(this).val() =="" || $(this).val() =="NaN" ){
           $(this).val( 0);
        }  
     });
     setHotKeyArticulo();
     
  $("#design").autocomplete({
        source: designs
  });  
  $("#design").blur(function() {
        var v = $(this).val();
        var inarr = $.inArray(v, designs);
        if (inarr == -1) {
            $("#msg").html("Dise�o invalido, debe ser un Dise�o de la lista");
            infoMsg("" + designs, 10000);
            $("#msg").addClass("error");
            setTimeout('$("#designs").focus()', 300);
        } else {
            $("#msg").html("");
            $("#msg").removeClass("error");
        }
        //controlarDatos();
    });
    $(".requerido").change(function(){
        controlarDatos();
    });
    $(".requerido").blur(function(){
        controlarDatos();
    });
    $("#lote").change(function(){
        buscarDatos();
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
    $(".sap_doc").each(function(){
        var sap_doc = $(this).attr("id").substring(8,30);
        if(sap_doc != ""){
           ferificarEstadoOrdenSAP(sap_doc);
        }else{
           $(this).addClass("bloqueado"); 
           $(this).html("Error Sync");
        }
    });
}
function ferificarEstadoOrdenSAP(nro_doc_sap){
    $.ajax({
        type: "POST",
        url: "produccion/OrdenFabric.class.php",
        data: {"action": "ferificarEstadoOrdenSAP", "nro_doc_sap": nro_doc_sap},
        async: true,
        dataType: "html",
        beforeSend: function () {
            $("#msg_"+nro_doc_sap).html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        complete: function (objeto, exito) {
            if (exito == "success") {
                
                var result = $.trim(objeto.responseText);
                if(result == "Liberado"){
                    $("#btn_"+nro_doc_sap).fadeIn();
                    $("#msg_"+nro_doc_sap).html(""); 
                    $("#sap_doc_"+nro_doc_sap).removeClass("bloqueado");
                }else{
                    $("#btn_"+nro_doc_sap).fadeOut();
                    $("#msg_"+nro_doc_sap).html(result); 
                    $("#sap_doc_"+nro_doc_sap).addClass("bloqueado");
                }
            }
        },
        error: function () {
            $("#msg_"+nro_doc_sap).html("Error"); 
        }
    });     
}

function controlarDatos(){
    var c = $("#cantidad").val().replace(".","");
    var l = $("#codigo").val().length;
    var d = $("#design").val().length; 
    if(isNaN(c) || l == 0 || d == 0 || c == 0){
        $("#insertar").prop("disabled",true);
    }else{
       $("#insertar").removeAttr("disabled"); 
    }
}
function fijarCliente(){
    var v = $("#fijar_cliente").val();
    var ruc  = $("#ruc_cliente").val();
    if(ruc == "XXXX"){
        //alert("El pedido debe ser para un cliente, no esta permitido generar Ordenes a clientes anonimos");
        errorMsg("El pedido debe ser para un cliente, no esta permitido generar Ordenes a clientes anonimos",10000);
        return;
    }else{
        if(v == "Fijar" && ruc.length > 0){
            $("#fijar_cliente").val("Cambiar");
            $(".clidata").attr("disabled",true);         
            listarOrdenes(); 
        }else{
            $("#fijar_cliente").val("Fijar");
            $(".clidata").removeAttr("disabled");
            $(".clidata").val("");   
            $("#enviar_nota").fadeOut();
            $("#generar").fadeOut();

        }
        var cod_cli = $("#codigo_cliente").val(); 
        $(document).click( function(){ calcularLatencia();  });
    }
    /*  
    $(".solicitud_abierta_cab").each(function(){
        var codigo_cliente = $(this).find(".cod_cli").html();
        if(cod_cli != codigo_cliente){
            $(this).fadeOut();
        } 
     }); */   
}
function seleccionarCliente(obj){
    var cliente = $(obj).find(".cliente").html(); 
    var ruc = $(obj).find(".ruc").html();  
    var codigo = $(obj).find(".codigo").html();
    var cat = $(obj).find(".cat").html();  
 
    $("#ruc_cliente").val(ruc);
    $("#nombre_cliente").val(cliente);
    $("#codigo_cliente").val(codigo);
    $("#categoria").val(cat);
       
    $("#ui_clientes" ).fadeOut("fast");
    $("#tipo").focus();
    $("#msg").html(""); 
    
    $("#fijar_cliente").removeAttr("disabled");
    
    $("#codigo").focus();
}
function mostrar(){
    $("#fijar_cliente").val("Fijar");
    $("#fijar_cliente").removeAttr("disabled");
}

function insertar(){
       
    var codigo = $("#codigo").val();    
    var descrip = $("#descrip").val();
    var cantidad = $("#cantidad").val().replace(".","");
    var design = $("#design").val();    
    var largo = $("#largo").val().replace(",",".");;    
    
    $.ajax({
        type: "POST",
        url: "produccion/OrdenFabric.class.php",
        data: {"action": "insertarEnOrdenFabric", "nro_orden": nro_orden, "codigo": codigo,"descrip":descrip,cantidad:cantidad,design:design,largo:largo},
        async: true,
        dataType: "html",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        complete: function (objeto, exito) {
            if (exito == "success") {                          
                var result = $.trim(objeto.responseText);        
                listarOrdenes();
                limpiarAreaCarga();
                $("#insertar").attr("disabled",true);// Solo se Permite de a uno
            }else{
                alert("Ocurrio un error en la comunicacion con el Servidor...")
            }
            
        },
        error: function () {
            $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });     
}

function ocultar(){}

function listarOrdenes(){
    $("#solicitudes_abiertas").fadeIn();
    var cod_cli = $("#codigo_cliente").val();
    $.ajax({
        type: "POST",
        url: "produccion/OrdenFabric.class.php",
        data: {"action": "listarOrdenes", cod_cli: cod_cli,"usuario": getNick()},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {   
            $(".orden").remove();
            $("#generar").fadeOut();
            if(data.length > 0){
                var tabla = "<table class='orden' border='1' >";
                tabla+='<tr  class="titulo" ><th>N&deg;</th><th>Cliente</th><th>Fecha</th><th>*</th></tr>';
                for (var i in data) { // No mas de una por Cliente por Usuario
                    nro_orden = data[i].nro_orden;
                    var cod_cli = data[i].cod_cli;   
                    var cliente = data[i].cliente;
                    var usuario = data[i].usuario;
                    var fecha = data[i].fecha;
                    var estado = data[i].estado;
                    tabla+='<tr class="fila"><td  class="itemc">'+nro_orden+'</td><td>'+cliente+'</td><td  class="itemc">'+fecha+'</td><td class="itemc"><img style="cursor:pointer" src="img/trash_mini.png" onclick="borrarOrden('+nro_orden+')" ></td></tr>';
                } 
                tabla+='<tr><td  colspan="4">\n\
                <table border="1" class="detalle" >\n\
                    <tr><th>N&deg;</th><th>Codigo</th><th>Descripcion</th><th>Dise&ntilde;o</th><th>Cantidad</th></tr>\n\
                 </table>\n\
                </td></tr>';
                tabla+='</table>';
                $("#area_carga").slideDown();
                getDetalleOrden(nro_orden);
            }else{
                $("#area_carga").slideUp();
                $("#generar").fadeIn();
            }
            
            $("#solicitudes_abiertas").append(tabla);
            $("#msg").html(""); 
            
        }
    });
}
function getDetalleOrden(nro_orden){
    $.ajax({
        type: "POST",
        url: "produccion/OrdenFabric.class.php",
        data: {"action": "getDetalleOrden", nro_orden: nro_orden},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {   
            var i = 0;
            for (var i in data) { 
                var id_det = data[i].id_det;
                var codigo = data[i].codigo;         
                var descrip = data[i].descrip;         
                var cantidad = data[i].cantidad;         
                var design = data[i].design;
                $(".detalle").append("<tr><td class='itemc'>"+id_det+"</td><td class='item'>"+codigo+"</td><td class='item'>"+descrip+"</td><td class='item'>"+design+"</td><td class='num'>"+cantidad+"</td></tr>");
                i++;
            }  
            if(i > 0){
                $("#enviar_nota").fadeIn();
            }else{
                $("#enviar_nota").fadeOut();
            }
            $("#msg").html(""); 
        }
    });    
}

function generarOrden(){
    $("#generar").fadeOut();
    var cod_cli = $("#codigo_cliente").val();
    var cliente = $("#nombre_cliente").val();
    $.ajax({
        type: "POST",
        url: "produccion/OrdenFabric.class.php",
        data: {"action": "generarOrden", "usuario": getNick(), "suc": getSuc(),cod_cli:cod_cli,cliente:cliente},
        async: true,
        dataType: "html",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        complete: function (objeto, exito) {
            if (exito == "success") {                          
                var result = $.trim(objeto.responseText);   
                if(result == "Ok"){
                    $("#msg").html("");
                    $(".requerido").removeAttr("disabled"); 
                    listarOrdenes();                     
                }else{
                    alert(result);
                    $("#msg").html(result);
                }
            }
        },
        error: function () {
            $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    }); 
}
function cerrar(){
    $("#ui_clientes").fadeOut();
}
  
var  calcularLatencia = function(){
    if(check_flag){
    $.ajax({
        type: "POST",
        url: "pedidos/SolicitudTrasladoMobile.class.php",
        timeout:40000, //40 seconds timeout
        data: {"action": "ping"},
        async: true,
        dataType: "html",
        beforeSend: function () {
            ping_time = new Date().getTime();
             
            infoMsg("Ping",3000);
            check_flag = false;
            setTimeout( function(){ check_flag = true; },20000);// Minimo 20 segundos
        },
        
        complete: function (objeto, exito) {
            if (exito == "success") {                          
                var result = $.trim(objeto.responseText);  // Not used
                var pong_time = new Date().getTime();
                var diff = (pong_time - ping_time ) / 1000; // In seconds
                
                if(diff < 5){
                    $("#conexion").css("background","green");
                }else if(diff > 5 && diff < 11){
                    $("#conexion").css("background","orange");
                }else{
                    $("#conexion").css("background","red");
                }
                infoMsg("Tiempo de conexion: "+diff+" seg",6000);
            }
             
        },
        error: function (jqXHR, textStatus) {
            if(textStatus === 'timeout'){
                $("#conexion").css("background","red");
            }
            $("#msg").html("Error de conexion");
        }
    }); 
    }
}

function limpiarAreaCarga(){
    $(".requerido, .ui-autocomplete-input").val(""); 
    $("#insertar").prop("disabled",true);
    $(".requerido").attr("disabled",true); 
}

function buscarArticulo(){
    var articulo = $("#codigo").val();
    var cat = $("#categoria").val();
    
    fila_art = 0;
    if(articulo.length > 0){
    $.ajax({
        type: "POST",
        url: "produccion/OrdenFabric.class.php",
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
                    var ItemCode =  (data[i].ItemCode).toString().toUpperCase();
                    var Sector = data[i].Sector;
                    var NombreComercial = data[i].NombreComercial; 
                    var Precio =  parseFloat(  (data[i].Precio) ).format(0, 3, '.', ',');
                    var Anchor = parseFloat(data[i].Anchor).format(2, 3, '.', ',');
                    var Largo = parseFloat(data[i].Largo).format(2, 3, '.', ',');
                    var Especificaciones = data[i].U_ESPECIFICA;
                    var UM = data[i].UM;         
                                                                         
                    $("#lista_articulos") .append("<tr class='tr_art_data fila_art_"+i+"' data-sector="+Sector+" data-largo="+Largo+" data-precio="+Precio+" data-um="+UM+"><td class='item clicable_art'><span class='codigo' >"+ItemCode+"</span></td>\n\
                    </td><td class='item clicable_art'><span class='NombreComercial'>"+NombreComercial+"</span></td> \n\
                    <td class='itemc clicable_art'>"+Anchor+" x "+Largo+"</td>\n\
                    <td class='item clicable_art'>"+Especificaciones+"</td>\n\
                    <td class='num clicable_art'>"+Precio+"</td>\n\
                    </tr>");
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
function limpiarListaArticulos(){    
    $(".tr_art_data").each(function () {   
       $(this).remove();
    });    
} 
 
function setDefaultDataNextFlag(){
    data_next_time_flag = true;
}
function setHotKeyArticulo(){
     
    $("#codigo").keydown(function(e) {
        
        var tecla = e.keyCode;  //console.log(tecla);  
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


function seleccionarArticulo(obj){
    var codigo = $(obj).find(".codigo").html();
    var sector = $(obj).attr("data-sector"); 
    var nombre_com = $(obj).find(".NombreComercial").html();  
    var precio = $(obj).attr("data-precio");
    var um = $(obj).attr("data-um");
    var largo = $(obj).attr("data-largo"); 
    $("#codigo").val(codigo);
    $("#descrip").val(sector+"-"+nombre_com);
    $("#um").val(um);
    $("#largo").val(largo);
    $("#ui_articulos").fadeOut();   
    $("#cantidad").focus();
}

var entMerc_designTarget;

function selectDesigns(ObjTarget) {
    entMerc_designTarget = ObjTarget.data("target");
    if (!loadDesings) {
        $.ajax({
            type: "POST",
            url: "Ajax.class.php",
            data: { "action": "getDesignsImages" },
            async: true,
            dataType: "json",
            beforeSend: function() {
                $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >");
            },
            success: function(data) {
                //console.log(data);
                for (var i in data) {
                    var key = data[i].key;
                    var name = data[i].name;
                    var thums = data[i].thumnails;
                    var ul = '<ul id="' + key + '" data-name="' + name + '" >';
                    for (var i = 0; i < thums.length; ++i) {
                        var img = thums[i];
                        var class_ = "";
                        if (i == 0) {
                            class_ = "class='lastitem'";
                        }
                        ul += '<li ' + class_ + '><img title="' + name + '" src="img/PATTERNS/' + key + '/' + img + '" height="46"  ></li>';
                    }

                    ul += '</ul>';
                    $("#designs_container").append(ul);
                    //console.log(key+"  "+name+"  "+thums);

                }
                $("#designs_container li").click(function() {
                    var name = $(this).parent().attr("data-name");
                    $("#" + entMerc_designTarget).val(name);
                    $("#designs_container").fadeOut();
                });
                loadDesings = true;
                $("#msg").html("");
            }
        });
    }
    var window_width = $(document).width() / 2;
    var desing_width = $("#designs_container").width() / 2;
    var posx = (window_width - desing_width);
    posx = posx + "px";
    $("#designs_container").css({ left: posx, top: 50 });
    $("#designs_container").fadeIn();
}

function hideDesigns() {
    $("#designs_container").fadeOut();
}

function borrarOrden(nro_orden){
    var c = confirm("Esta seguro de que desea eliminar la Orden de Fabricacion? Este proceso no es reversible");
    if(c){
        $.ajax({
            type: "POST",
            url: "produccion/OrdenFabric.class.php",
            data: {"action": "eliminarOrden", nro_orden: nro_orden},
            async: true,
            dataType: "html",
            beforeSend: function () {
                $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            },
            complete: function (objeto, exito) {
                if (exito == "success") {                          
                    var result = $.trim(objeto.responseText);   
                    listarOrdenes();
                }
            },
            error: function () {
                $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
            }
        }); 
    }
}

function enviarOrden(){
    var obs = $("#obs").val();
    $.ajax({
        type: "POST",
        url: "produccion/OrdenFabric.class.php",
        data: {"action": "cambiarEstadoOrden", nro_orden: nro_orden,"estado":"Pendiente",obs:obs},
        async: true,
        dataType: "html",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        complete: function (objeto, exito) {
            if (exito == "success") {                          
                var result = $.trim(objeto.responseText); 
                if(result == "Ok"){                  
                   
                   $("#enviar_nota").fadeOut();                   
                   sincronizarOrdenFabric(nro_orden);
                }else{
                   alert("Error: "+result);
                }
            }
        },
        error: function () {
            $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    }); 
}
function sincronizarOrdenFabric(nro_orden){
    /*
   var server_ip = location.host;
   var url = "http://"+server_ip+":8081" // Desmarcar despues
   //var url = "http://localhost:8081";
   */
   var data = {     
        "action": "generarOrdenFabricion",
        "NroOrden": nro_orden
    };
    $.post(bc_url, data, function(data) {
        if (data.status == "ok") {
            $("#msg").html("Ok"); 
            alert("La Orden de Fabricacion ha sido enviada con exito");
            //genericLoad("produccion/OrdenFabric.class.php");
            $("#area_carga").fadeOut();
            $("#solicitudes_abiertas").fadeOut();
            $(".requerido").attr("disabled",true); 
            $("#generar").fadeIn();             
        } else {
           alert("Error en la comunicacion con el servidor, intente enviar nuevamente."); 
        }
    }, "jsonp").fail(function() {
         alert("Error de comunicacion con el servidor "+data.status);
    });    
}
function sincronizarEmisionProduccion(nro_emision,nro_orden){
   var server_ip = location.host;
   var url = "http://"+server_ip+":8081" // Desmarcar despues
   //var url = "http://localhost:8081";
   var data = {
        "action": "generarEmisionProduccion",
        "NroEmision": nro_emision
    };
    $.post(url, data, function(data) {
        if (data.status == "ok") {
            $("#msg").html("Ok"); 
            alert("La Emision para Produccion ha sido enviada con exito");
            genericLoad("produccion/OrdenFabric.class.php?action=listarPendientes");
        } else {
           alert("Error en la comunicacion con el servidor, intente enviar nuevamente."); 
           ponerPendientePorErrorSinc(nro_emision,nro_orden);
        }
    }, "jsonp").fail(function() {
         alert("Error de comunicacion "+data);
         ponerPendientePorErrorSinc(nro_emision,nro_orden);
    });    
}
function ponerPendientePorErrorSinc(nro_emision,nro_orden){
$.ajax({
        type: "POST",
        url: "produccion/OrdenFabric.class.php",
        data: {"action": "ponerEnPendiente", nro_emision: nro_emision,nro_orden:nro_orden,usuario:getNick()},
        async: true,
        dataType: "html",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        complete: function (objeto, exito) {
            if (exito == "success") {                          
                var result = $.trim(objeto.responseText);    
                if(result == "Ok"){
                    $("#msg").html(""); 
                    
                }else{
                    $("#msg").html(result); 
                }
            }
        },
        error: function () {
            $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });    
}
function misOrdenes(){
    genericLoad("produccion/OrdenFabric.class.php?action=misOrdenes");
}
function agregarLotes(codigo,nro_orden){
    var nro_emision = parseInt( $("#emis_"+nro_orden).html() );
    $(".msg").html("");
    if(isNaN(nro_emision)){
        generarEmision(codigo,nro_orden);
    }else{  
        
        //var req = parseFloat($(".req_"+nro_orden).html().replace(".","").replace(",","."));
        var medida = parseFloat($(".medida_"+nro_orden).html().replace(".","").replace(",","."));
        var cant_pedida = parseFloat($(".cant_pedida_"+nro_orden).html().replace(".","").replace(",","."));
        
        //$("#requerido").val(req);
        $("#medida").val(medida);
        $("#a_codigo").html(" "+codigo);
        $("#codigo_art").val(codigo);
        $("#nro_orden").val(nro_orden);
        $("#nro_emision").val(nro_emision);    
        $("#cant_pedida").val(cant_pedida);    
        $("#pedido").val(cant_pedida);    
        
        
        $("#asign_popup").slideDown();
        $("#asign_popup").draggable();
        
        
        var w = $(window).width();
        var asw = $("#asign_popup").width();
        var esii = (w / 2) - (asw / 2);
        $("#asign_popup").offset({top:100,left: esii });
        
        $("#lote").focus();    
        buscarArticulosPermitidos();
        listarLotesAsignados();
    } 
}
function buscarArticulosPermitidos(){
    var ItemCodePadre = $("#codigo_art").val();
    $.ajax({
        type: "POST",
        url: "produccion/OrdenFabric.class.php",
        data: {"action": "getArticulosPermitidos", ItemCodePadre: ItemCodePadre},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {   
            $(".permitidos").remove();
            for (var i in data) { 
                var Code = data[i].Code;
                var ItemName = data[i].ItemName; 
                var Quantity = data[i].Quantity; 
                $("#permitidos").append("<tr class='permitidos'><td  data-qty='"+Quantity+"' class='permit_"+Code+" codigo_permitido' onclick=sumarAsignados('"+Code+"')>"+Code+"</td><td>"+ItemName+"</td></tr>");
            }   
            $("#msg").html(""); 
        }
    });
}
function cerrarPopup(){
    $("#asign_popup").slideUp();
}
function generarEmision(codigo,nro_orden){
    
    $.ajax({
        type: "POST",
        url: "produccion/OrdenFabric.class.php",
        data: {"action": "generarEmision", nro_orden: nro_orden,"usuario": getNick(), "suc": getSuc()},         
        async: true,
        dataType: "html",
        beforeSend: function () {     
            $("#emis_"+nro_orden).html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        complete: function (objeto, exito) {
            if (exito == "success") {                          
                var nro_emis = parseInt($.trim(objeto.responseText));    
                if(!isNaN(nro_emis)){
                    $("#emis_"+nro_orden).html(nro_emis);
                    $(".requerido").removeAttr("disabled"); 
                    agregarLotes(codigo,nro_orden);                    
                }else{
                    alert($.trim(objeto.responseText));
                }
            }
        },
        error: function () {
            $("#emis_"+nro_orden).html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });     
            
}
function showKeyPad(){
    showNumpad("lote",buscarDatos,false);
}

function listarLotesAsignados(){
    var nro_emision = $("#nro_emision").val();
    var codigo_ref = $("#codigo_art").val(); 
    $.ajax({
        type: "POST",
        url: "produccion/OrdenFabric.class.php",
        data: {"action": "listarLotesAsignados", nro_emision: nro_emision,codigo:codigo_ref},
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
                var descrip = data[i].descrip;   
                var cant_lote = data[i].cant_lote;
                var img = data[i].img;
                $("#detalle_asign").append("<tr  class='fila_asign fila_"+nro_emision+"_"+lote+"'><td class='asign_"+codigo+" itemc'>"+codigo+"</td><td data-img='"+img+"' class='item asigned_lote'>"+lote+"</td><td  class='item'>"+descrip+"</td><td  class='num cant_"+codigo+"'>"+cant_lote+"</td><th><img src='img/trash_mini.png'  onclick='eliminarLote("+nro_emision+","+lote+")'></th></tr>");  
            }   
            $("#msg").html(""); 
        }
    });
}

function buscarDatos(){
   var lote = $("#lote").val();
   var suc = getSuc();
   var producto_final = $("#codigo_art").val();
   //$('input[type="checkbox"]#traer_historial').prop("checked",false);
   $.ajax({
        type: "POST",
        url: "produccion/OrdenFabric.class.php",
        data: {"action":"buscarDatosDeCodigo","lote":lote,"categoria":1,"suc":suc,producto_final:producto_final}, // Utilizo la misma funcion de Factura de Ventas
        async:true,
        dataType: "json",
        beforeSend: function(){ 
           $("#msg").html("<img src='img/loadingt.gif' >");   
            
           $("#img").fadeOut("fast");
           $("#codigo").val(""); 
           $("#um").val("");  
           $("#suc").val("");   
           $("#ancho").val("");  
           $("#gramaje").val("");  
           $("#descrip").val("");  
           $("#stock").val("");  
           
        },
        success: function(data){ 
            var mensaje = data[0].Mensaje;
            $("#msg").attr("class","info");
            if( mensaje === "Ok" ){
                var ItemCode = data[0].Codigo;
                 
                // Ver si coincide el ItemCode con los articulos Permitidos
                var enlista = false;
                
                $(".permitido").removeClass("permitido");
                
                $(".codigo_permitido").each(function(){
                    var cp = $(this).html();
                    if(cp == ItemCode){
                        enlista = true;
                        $(this).addClass("permitido");
                    }
                });
                
                 
                 
                $("#codigo").val(ItemCode); 
                $("#descrip").val(data[0].Descrip);
                $("#stock").val(  parseFloat( data[0].Stock  ).format(2, 3, '.', ',')   );
                
                var ancho = parseFloat(  data[0].Ancho ).format(2, 3, '.', ',');
                var gramaje = parseFloat(  data[0].Gramaje ).format(2, 3, '.', ',');
                var um = data[0].UM; 
                var suc = data[0].Suc;  
                var img = data[0].Img;  
                var padre = data[0].Padre;  
                var ubic = data[0].U_ubic;  
                var fab_color_cod = data[0].U_color_cod_fabric;
                var color = data[0].Descrip.split("-")[1];
                var design = data[0].U_Design;  
                var MateriaPrima = parseFloat(  data[0].MateriaPrima ).format(2, 3, '.', ',');  
                        
                $("#um").val(um);  
                $("#suc").val(suc);   
                $("#ancho").val(ancho);  
                $("#gramaje").val(gramaje);  
                $("#padre").val(padre); 
                $("#ubic").val(ubic); 
                $("#fab_color_cod").val(fab_color_cod); 
                $("#color").val(color); 
                $("#design").val(design); 
                $("#materia_prima").val(MateriaPrima);  
                        
                if(img != "" && img != undefined){
                    var images_url = $("#images_url").val();
                    $("#img").attr("src",images_url+"/"+img+".thum.jpg");
                    $("#img").fadeIn(100);
                }else{
                    $("#img").attr("src","img/no_image.png");
                    $("#img").fadeIn(2500);
                }                
         
                $("#msg").html("<img src='img/ok.png'>");  
                if(getSuc() == suc){
                   $("#imprimir").removeAttr("disabled");
                }else{
                    $("#msg").addClass("error");
                    $("#msg").html("Esta pieza no se encuentra en esta Sucursal!, Corrobore.");   
                }
                if(enlista){
                    buscarStockComprometido(lote);
                }else{
                    $("#asignar").prop("disabled",true);
                    $("#msg").addClass("error");
                    $("#msg").html("Esta pieza no esta en la lista de Articulos para emision");   
                }
                sumarAsignados(ItemCode);
                //$("#imprimir").removeAttr("disabled");
            }else{
                $("#msg").addClass("error");
                $("#msg").html(mensaje);   
                $("#lote").focus(); 
                $("#lote").select();
                //$("#imprimir").attr("disabled",true);
            }
        },
        error: function(e){ 
           $("#msg").addClass("error");
           $("#msg").html("Error en la comunicacion con el servidor:  "+e);
           $("#imprimir").attr("disabled",true);
           $("#lote").select();
        }
    });
}
function asignarLote(){
    var nro_emision = $("#nro_emision").val();
    var nro_orden = $("#nro_orden").val(); 
    var codigo = $("#codigo").val(); 
    var codigo_ref = $("#codigo_art").val(); 
    
    var lote = $("#lote").val(); 
    var cantidad = parseFloat($("#stock").val().replace(/\./g,"").replace(/,/g,".")); 
    var color = $("#color").val(); 
    var descrip = $("#descrip").val(); 
    var design = $("#design").val(); 
    
    var ancho = parseFloat($("#ancho").val().replace(",","."));
    var medida = parseFloat($("#medida").val()); 
    
    var multiplicador = Math.floor(  ancho / medida); 
    if(multiplicador < 1){
        multiplicador = 1;
    }
    
    var esta_asignado = false;
    
    $(".asigned_lote").each(function(){  
        var loteasignado = $(this).html();    
        if(loteasignado == lote){
            esta_asignado = true;
        }
    });
           
    if(codigo != "" || lote !="" ){
       if(!esta_asignado){ 
    
        $.ajax({
            type: "POST",
            url: "produccion/OrdenFabric.class.php",
            data: {"action": "asignarLote", nro_orden: nro_orden,nro_emision:nro_emision,codigo:codigo,lote:lote,descrip:descrip,color:color,design:design,cantidad:cantidad,codigo_ref:codigo_ref,usuario:getNick(),multiplicador:multiplicador},
            async: true,
            dataType: "json",
            beforeSend: function () {
                $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            },
            success: function (data) {   
                if(data.Estado == "Ok"){
                    $("#detalle_asign").append("<tr class='fila_asign fila_"+nro_emision+"_"+lote+"'><td class='asign_"+codigo+" itemc'>"+codigo+"</td><td class='item asigned_lote' >"+lote+"</td><td class='item'>"+descrip+"</td><td class='num cant_"+codigo+"'>"+cantidad+"</td><th><img src='img/trash_mini.png' onclick='eliminarLote("+nro_emision+","+lote+")'></th></tr>");
                    sumarAsignados(codigo);
                    buscarResumenAsignados(nro_orden,nro_emision,codigo_ref);
                    limpiarAsignForm();
                    $("#msg").html("");
                }else{
                    alert(data.Mensaje);
                    $("#msg").html(data.Mensaje);
                }    
            }
        });
    }else{
        alert("Este lote ya esta asignado previamente.");
    }
    }else{
        alert("Puntee un lote con el lector.");
    }
    
}
function sumarAsignados(codigo){  
     
    var tasign = 0;
    $(".cant_"+codigo).each(function(){
       var v = parseFloat($(this).html());
       tasign+=v;
    });
    var mp = parseFloat($(".permit_"+codigo).attr("data-qty").replace(",",".")) ; 
    var calcasign =  tasign / mp ;    
    var fixedval =  (tasign / mp).toFixed(2);    
    $("#tasign").val(fixedval);
    var pedido = parseFloat($("#pedido").val());
    if(calcasign >= pedido){
      $(".msg").html("Asignacion completa para este Articulo ["+codigo+"] <img src='img/ok.png'>");
      $(".msg").css("color","green");
    }else{
      $(".msg").html("Falta Asignar mas para este Articulo ["+codigo+"]");
      $(".msg").css("color","red");
    }
}
function eliminarLote(nro_emision,lote){
    var c = confirm("Seguro que desea eliminar este lote?");
    if(c){
    $.ajax({
        type: "POST",
        url: "produccion/OrdenFabric.class.php",
        data: {"action": "eliminarLote", nro_emision: nro_emision,lote:lote},
        async: true,
        dataType: "html",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        complete: function (objeto, exito) {
            if (exito == "success") {                          
                var result = $.trim(objeto.responseText);   
                if(result == "Ok"){
                    $(".fila_"+nro_emision+"_"+lote).remove();
                    $("#msg").html("Ok"); 
                }else{                     
                    $("#msg").html(result); 
                }
            }
        },
        error: function () {
            $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    }); 
    }    
}
function limpiarAsignForm(){
    $(".asign_form input[type=text]:not(.ped)").val("");    
    $("#lote").focus(); 
    $("#asignar").prop("disabled",true);
}
function buscarResumenAsignados(nro_orden,nro_emision,codigo){
    /*
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
            $("#asigned_"+codigo+"-"+nro_orden).html(asignado); 
            var req = parseFloat( $("#asigned_"+codigo+"-"+nro_orden).prev().html().replace(".",""));
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
    });*/
}
function buscarStockComprometido(lote){
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: {"action": "buscarStockComprometido", lote: lote,suc:getSuc(),"incluir_reservas":"Si"},
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
                st_comp+="<tr class='titulo' style='font-size:10px'><th>Doc</th><th>Nro Doc</th><th>Usuario</th><th>Fecha</th><th>Suc</th><th>Estado</th><th>Cantidad</th><tr>";
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
               
               
                //console.log(comprometido);
                var stock_limpio = parseFloat($("#stock").val().replace(",","."))  - comprometido;
                $("#stock").val(  parseFloat( stock_limpio  ).format(2, 3, '.', ',')   );
                $("#stock_compr").html("<img src='img/warning_red_16.png' onclick='verStockComprometido()' title='Alguien mas tiene cargada esta pieza en una Factura!'>");
                $("#stock_comprometido").html(st_comp);
                $(".tabla_stock_comprometido").click(function(){
                    verStockComprometido();
                });
                
                if(stock_limpio > 0){
                    $("#asignar").removeAttr("disabled"); 
                    $("#msg").html("<img src='img/ok.png'>");  
                }else{
                    $("#asignar").prop("disabled",true);
                     $("#msg").html("<img src='img/warning_red_16.png>");  
                }
            }else{
                var stock_limpio = parseFloat($("#stock").val().replace(",","."))  - comprometido;
                if(stock_limpio > 0){
                    $("#asignar").removeAttr("disabled");   
                    $("#msg").html("<img src='img/ok.png'>");  
                }else{
                    $("#asignar").prop("disabled",true);
                    $("#msg").html("<img src='img/warning_red_16.png'>");  
                }
            }
            
        }
    });
}
function verStockComprometido(){
    $("#stock_comprometido").toggle();
}
function ponerEnProduccion(nro_orden){
    var flag = true;
    $(".req_"+nro_orden).each(function(){     
        var req  =  parseFloat($(this).html().replace(".",""));
        var asign = parseFloat($(this).next().html());
        var porc = req * PORCENTAJE_PERMITIDO / 100;
        var min = req - porc;
        var max = req + porc;
        
        console.log("req "+req+ " asign "+asign +" min: "+min +"  max: "+max);
        //if(asign < min || asign > max){  // Quitado por orden de Victor
        if(asign < min ){
            flag = false;
            $(this).addClass("incorrecto");
        }else{
            $(this).removeClass("incorrecto");
        }
    });
    if(flag){
    var c = confirm("Confirma que desea poner en proceso esta emision?");
    if(c){
    var nro_emision = parseInt(  $("#emis_"+nro_orden).html()  );
    $.ajax({
        type: "POST",
        url: "produccion/OrdenFabric.class.php",
        data: {"action": "ponerEnProduccion", nro_emision: nro_emision,nro_orden:nro_orden,usuario:getNick()},
        async: true,
        dataType: "html",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        complete: function (objeto, exito) {
            if (exito == "success") {                          
                var result = $.trim(objeto.responseText);    
                if(result == "Ok"){
                    $("#msg").html(""); 
                    $(".orden_"+nro_orden).slideUp();
                    sincronizarEmisionProduccion(nro_emision,nro_orden);
                }else{
                    $("#msg").html(result); 
                }
            }
        },
        error: function () {
            $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    }); 
   } }else{
       alert("Asignaciones fuera de Rango, favor corregir antes de poner en Proceso");
   }
}
/*
function asignar(nro_orden){
    var usuario_ = $(".asignar_"+nro_orden).val();
    if(usuario_ != ""){
        $.ajax({
            type: "POST",
            url: "produccion/OrdenFabric.class.php",
            data: {"action": "asignarOrdenFabric",nro_orden:nro_orden, "usuario": usuario_},
            async: true,
            dataType: "html",
            beforeSend: function () {
                $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            },
            complete: function (objeto, exito) {
                if (exito == "success") {                          
                    var result = $.trim(objeto.responseText);   
                    if(result == "Ok"){
                        alert("La Orden de Fabricacion ha sido asignada y puesta en Proceso.");
                        genericLoad("produccion/OrdenFabric.class.php?action=listarPendientes");
                    }else{
                        alert("Error: "+result);
                    }
                }
            },
            error: function () {
                $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
            }
        }); 
    }else{
        alert("Seleccione un Confeccionista.")
    }
}*/
/*
function emisionProduccion(nro_orden){
    var suc = getSuc();
    genericLoad("produccion/EmisionProduccion.class.php?nro_orden="+nro_orden+"&suc="+suc);
}*/