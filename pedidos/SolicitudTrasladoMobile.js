var nro_nota = 0;
var decimales = 0;
var cant_articulos = 0;
var fila_art = 0;
var PORC_VAL_MIN = 25;     
var data_next_time_flag = true;
var ventana;
var latencia = null;
var selecciono_nota = false;
var agregar_lotes = false;
var tipo_busqueda = "tejidos";
var printing;

function configurar(){
    setHotKeyArticulo();
    $("#filtroStock").mask("9?999",{placeholder:""});
    $(".numeros").change(function(){
        var decimals = 2;
         
        var n = parseFloat($(this).val() ).format(decimals, 3, '.', ',') ;
        $(this).val( n  );
        if($(this).val() =="" || $(this).val() =="NaN" ){
           $(this).val( 0);
        }  
     });
     $("*[data-next]").keyup(function (e) {
        
        if (e.keyCode == 13) { 
            if(data_next_time_flag){
               data_next_time_flag = false;                    
 
               var next =  $(this).attr("data-next");
               $("#"+next).focus();               
               setTimeout("setDefaultDataNextFlag()",600);
            }
        } 
    });  
    activarEstados();  
    statusInfo();
    $("#lote").focus();
     
    function setHotKeysListaCliente() {}
    controlarVacias();
    $("#cantidad").change(function(){
        var cant = parseFloat($(this).val());
        var stock = parseFloat($("#stock").val().replace(".","").replace(",","."));
        if(cant > stock){
            $("#cantidad").val($("#stock").val());
            alert("Cantidad no puede ser mayor al stock");
        }
        if(cant < stock){
            $("#obs").val("Favor fraccionar en "+ cant);
        }
    });
    $("#precio_venta").change(function(){
        var pv = parseFloat($(this).val().replace(".","").replace(",","."));
        var vm = $("#valor_minimo").val();
         
        if(pv < vm){
            $("#precio_venta").val(vm);
            alert("Estas vendiendo bajo el Minimo");
        }        
    });
    $("#precio_venta, #cantidad").focus(function(){
       $(this).select(); 
    });
    
    $(".tipo_busqueda").click(function(){
        var tipo = $("input[name='tipo_busqueda']:checked").val();
        if(tipo === "insumos"){
            tipo_busqueda = "insumos";
            $("#mts_unid").html("Cant Requerida:");
            $("#filtroStock").val("0");
            $(".btejido").fadeOut();
            $("#lote").width("200px");
            $("#codigo_cliente").val("C000018");
            $("#ruc_cliente").val("80001404-9");
            $("#categoria").val("5");
            $("#nombre_cliente").val("CORPORACION TEXTIL S.A");  
            if($("#fijar_cliente").prop("disabled")){
                fijarCliente();
                $("#fijar_cliente").removeAttr("disabled");
            }
            $(".clr_tejido").html("Stock:");
        }else{
            tipo_busqueda = "tejidos";
            $("#mts_unid").html("Mts Requeridos:");
            $("#filtroStock").val("5");
            $(".btejido").fadeIn();
            $("#lote").width("105px");
             $(".clr_tejido").html("Color:");
        }
    });
     
    $(document).click( function(){ calcularLatencia();  });    
    sumSubtotal();
}

function controlarVacias(){
    $(".solicitud_abierta_cab").each(function(){            
         var nro = $(this).attr("data-nro");
         var c = 0;
         $(".fila_"+nro).each(function(){  
           c++;        
         });   
         if(c > 0){
            $(".boton_env_"+nro).removeAttr("disabled");
            $("#eliminar_"+nro).fadeOut();             
         }else{
            $(".boton_env_"+nro).prop("disabled",true);
            $("#eliminar_"+nro).fadeIn();  
         }
    });          
}
function seleccionarLista(cod_cli){
    console.log(cod_cli);
    var cliente = $("."+cod_cli).html();    
    $("#nombre_cliente").val(cliente);
    $("#ruc_cliente").val("");
    selecciono_nota = true;
    nro_nota = parseInt($("."+cod_cli).data("nro"));     
    console.log("nro_nro "+nro_nota);
    buscarCliente("#nombre_cliente");    
}
function borrarNota(nro){
    var c = 0;
    $(".fila_"+nro).each(function(){  
      c++;        
    });    
    if(c > 0){
        alert("No se puede eliminar debido a que la Nota contiene Lotes");
    }else{
        $.ajax({
            type: "POST",
            url: "pedidos/SolicitudTrasladoMobile.class.php",
            data: {"action": "eliminarNotaPedidoVacia", "nro_nota": nro},
            async: true,
            dataType: "html",
            beforeSend: function () {
                $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            },
            complete: function (objeto, exito) {
                if (exito == "success") {                          
                    var result = $.trim(objeto.responseText);    
                    if(result == "Ok"){
                        $(".solicitud_"+nro).slideUp();
                        $(".solicitud_"+nro).remove();
                        $("#msg").html(result);
                        
                    }else{
                        $("#msg").html( result );
                    }
                }
            },
            error: function () {
                $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
            }
        });         
    }
}

function activarEstados(){
    $(".estado").hover(function(){ $(this).children().first().fadeIn();} ,function(){$(this).children().first().fadeOut();});   
}
function mostrar(){
   $("#fijar_cliente").removeAttr("disabled"); 
   if(selecciono_nota){
       selecciono_nota = false;
       $("#fijar_cliente").click();
   }
}
function fijarCliente(){
    var ruc  = $("#ruc_cliente").val();
    var v = $("#fijar_cliente").val();
    if(v == "Fijar" && ruc.length > 0){
        $("#fijar_cliente").val("Cambiar");
        $(".clidata").attr("disabled",true);
        $("#area_carga").slideDown();
        //checkear();
    }else{
        $("#fijar_cliente").val("Fijar");
        $(".clidata").removeAttr("disabled");
        $(".clidata").val("");
        $("#area_carga").slideUp();
    }
    var cod_cli = $("#codigo_cliente").val(); 
      
    $(".solicitud_abierta_cab").each(function(){
        var codigo_cliente = $(this).find(".cod_cli").html();
        if(cod_cli != codigo_cliente){
             $(this).fadeOut();
        } 
     });    
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

function ocultar(){
    //hideKeyboard();
    //check();
}
function cerrar(){}
function limpiarAreaCarga(){
    $("#add_code").prop("disabled",true);
    $("#codigo").val(""); 
    $("#lote").val(""); 
    $("#descrip").val(""); 
    $("#stock").val(""); 
    $("#cantidad").val("");  
    $("#color").val(""); 
    $("#obs").val(""); 
    $("#lote").focus();   
}

function addCode(){
    
    if(nro_nota == 0){
        agregar_lotes = true;
        checkear();
    }else{   
       agregarLotes();
    }
}

function agregarLotes(){
    $("#add_code").attr("disabled",true);   
    //var seleccionados = $("input.check:checked").length;
    
    $("input.check:checked").each(function(){                     
          var id = $(this).attr("id").substring(6,26);
          seleccionarArticulo(".fila_art_"+id);
          registrarPedido(id);                     
    });
}

function registrarPedido(id){
    var lote = $.trim( $("#lote").val());
    var color = $("#color").val(); 
    var codigo = $("#codigo").val();
    var urge = $("#urge").val();
    var mayorista = $("#mayorista").val();
    var descrip = $("#descrip").val();
    var cantidad = $("#cantidad").val().replace(".","").replace(",",".");
    var obs = $("#obs").val();
    var precio_venta = parseFloat($("#precio_venta").val().replace(".","").replace(",",".")); 
    var precio_venta_mostrar = $("#precio_venta").val();
    var subtotal = parseFloat(cantidad) * precio_venta;

    if(lote.length > 0 && nro_nota > 0 && precio_venta > 0 && !isNaN(lote) && codigo != ""){
        var seleccionados = $("input.check:checked").length;
        var destino = $(".dest_"+nro_nota).html();
        if(destino == undefined){
            destino = $("#sucObjetivo").val();
        }
         /*
        if(seleccionados == 1){
            cantidad =  parseFloat($("#requeridos").val().replace(".","").replace(",",".")); 
            obs = obs+"Favor Fraccionar en "+cantidad;
        } */
        $.ajax({
            type: "POST",
            url: "Ajax.class.php",
            data: {"action": "addLoteSolicitudTraslado", nro_nota: nro_nota,codigo:codigo,lote:lote,usuario:getNick(),cantidad:cantidad,urge:urge,mayorista:mayorista,descrip:descrip,color:color,obs:obs,precio_venta:precio_venta,destino:destino},
            async: true,
            dataType: "json",
            beforeSend: function() {
                $("#msg").html("<img src='img/loading_fast.gif' width='18px' height='18px' >"); 
                $("#check_"+id).prop("disabled",true); 
                $("#check_"+id).after("<img src='img/loading_fast.gif' width='18px' height='18px' >"); 
            },
            success: function(data) {                               
                var estado = data.estado;                
                var mensaje = data.mensaje;                
                $("#msg").removeClass();
                if(estado == "Ok"){                
                    $("#sol_"+nro_nota+" tbody").append("<tr id='tr_"+nro_nota+"' style='background-color: white'  ><td class='item lote_"+lote+" codigo_lote' name='lote'>"+lote+"</td><td class='item'>"+descrip+"</td><td class='item'>"+color+"</td><td class='num'>"+cantidad+"</td><td class='num'>"+precio_venta+"</td><td class='num subtotal'>" + subtotal.toFixed(2) + "</td><td class='itemc'>"+mayorista+"</td><td class='itemc'>"+urge+"</td><td class='item'>"+obs+"</td>\n\
                    <td class='itemc'><img src='img/trash_mini.png' class='trash' id='trash_{"+lote+"}' style='cursor:pointer;' onclick='borrarLote("+lote+","+nro_nota+")'  /></td></tr>");
                    $("#msg").addClass("info");
                    $("#msg").html(mensaje+"   <img src='img/ok.png' width='18px' height='18px' >"); 
                    setTimeout( function(){ $("#tr_"+id).remove() },1000);
                    sumSubtotal();
                    //limpiarAreaCarga();
                }else{
                    $("#msg").addClass("error");
                    $("#msg").html(mensaje); 
                } 
            }
        });
    }else{
        alert("Seleccione un Lote y asigne un precio de venta.");
    }    
}

function showKeyPad(){
    showNumpad("lote",buscarLote,false);
}

function buscarLote(){
    //$("[readonly], .editable:not(select):not(input#lote):not(input#color)").val(""); // Limpiar Área de Carga
    var articulo = $("#lote").val();
    var color = $("#color").val(); 
    var filtroStock = $("#filtroStock").val();
    var sucOrigen = getSuc();
    var sucDestino = $("#sucObjetivo option:selected").val();
    var tipo_busqueda = $("#tipo_busqueda").val();
    var mi_suc = $("#mi_suc").is(":checked");
    var categoria = $("#categoria").val();
    var disponibles = $("#disponibles").is(":checked");
    
    var tipo = $("input[name='tipo_busqueda']:checked").val();
    if(tipo == "insumos"){
        color = "%";
        categoria = 1;
    }
    
    $("#precio_venta").val("");
    fila_art = 0;
    if(articulo.length > 0){
    $.ajax({
        type: "POST",
        url: "pedidos/SolicitudTrasladoMobile.class.php",
        data: {"action": "buscarLotes", "articulo": articulo,"color":color,"sucOrigen":sucOrigen,"sucDestino":sucDestino,"filtroStock":filtroStock,mi_suc:mi_suc,suc:getSuc(),cat:categoria,disponibles:disponibles,tipo_busqueda:tipo_busqueda,tipo:tipo},
        async: true,
        dataType: "json",
        beforeSend: function() {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            $("#result").removeClass("error");
            $("#result").addClass("info");
            $("#add_code").attr("disabled",true);   
            $("#result").html("Buscando...");
        },
        success: function(data) { 
            //o.ItemCode,o.BatchNum as Lote,i.U_NOMBRE_COM, cast(round(Quantity - o.IsCommited,2) as numeric(20,2)) as Stock,o.U_ancho as Ancho,c.Name as Color,Status,WhsCode AS Suc,U_img as Img
            if(data.length > 0){
                limpiarListaArticulos();
                var k = 0;
                cant_articulos = 0;
                for(var i in data){        
                    k++;
                    var ItemCode = data[i].ItemCode;
                    var Lote = data[i].Lote;
                    var Sector = data[i].Sector;
                    var NombreComercial = data[i].NombreComercial;
                    var Design = data[i].U_design;
                    var Color = data[i].Color;
                    var Stock =  parseFloat(  (data[i].Stock) ).format(2, 3, '.', ',');   
                    var Stock_nf =    data[i].Stock  ;   
                    var Precio1 =  parseFloat(  (data[i].Precio1) ).format(0, 3, '.', ',');   
                    var PrecioCosto =  parseFloat (data[i].PrecioCosto); 
                    var Ancho = data[i].Ancho;
                    var Suc = data[i].Suc;
                    var Img = data[i].Img;
                    var imageTitle = "";
                    var doc = data[i].doc.doc?data[i].doc.doc:'Libre';
                    if(Img != ""){  
                        imageTitle = "title='"+Img+"'";
                    }

                    // "<tr class='tr_art_data fila_art_"+i+" "+((sucOrigen===Suc)?'current':'')+"' data-codigo='"+ItemCode+"' data-stock='"+Stock+"' data-img='"+Img+"'  >
                    var td_doc = $("<td/>",{"class":"itemc Doc"});
                    var div_doc = $("<div/>",{"class":"doc"}).append($("<p/>",{"text":doc}));
                    var doc_det = $("<div/>",{"class":"doc_det","text":''});
                    
                    if(doc !== 'Libre'){ 
                        var texto =  "Nro.: "+data[i].doc.n_nro;
                        var obs = data[i].doc.obs;
                        if(obs != ""){
                            obs = "Obs:"+obs;
                        }else{ 
                            obs = "";
                        }
                        texto += (doc === 'Remision')?' para '+data[i].doc.suc + " "+obs :' desde '+data[i].doc.suc+" "+obs;
                        doc_det.text(texto);
                    }
                    div_doc.append(doc_det);
                    div_doc.appendTo(td_doc);

                    var tr = $("<tr/>",{
                        "class":"tr_art_data fila_art_"+i+" "+doc,
                        "data-codigo":ItemCode, 
                        "data-stock":Stock, 
                        "data-stock_nf":Stock_nf,
                        "data-img":Img,
                        "data-precio":Precio1,
                        "data-precio_costo":PrecioCosto,
                        "id":"tr_"+i
                    });
                    //console.log(td_doc);
                    var checkbox = "";
                    if(doc == 'Libre'){
                        checkbox = "<input id='check_"+i+"' type='checkbox' class='check' >";
                    }
                    tr.append("<td class='item clicable_art'><span class='codigo lote' >"+Lote+"</span> "+checkbox+" </td>  <td class='item clicable_art'><span class='item Sector'>"+Sector+"</span> </td><td  class='item clicable_art'><span class='item NombreComercial'>"+NombreComercial+"</span></td> \n\
                    <td class='item Color' "+imageTitle+" >"+Color+"</td><td class='item design' >"+Design+"</td><td class='num'>"+Stock+"</td><td class='itemc Suc'>"+Suc+"</td><td class='num precio'>"+Precio1+"</td>");
                    
                    tr.append(td_doc);
                    $("#lista_articulos").append(tr);                                                      
                    cant_articulos = k;
                }  
                inicializarCursores("clicable_art"); 
                $("#ui_articulos").fadeIn();
                $("tr.tr_art_data.Libre").click(function(){                     
                    
                    var fila = $(this).attr("id").substring(3,20);
                    if($("#check_"+fila).is(":checked")){
                       $("#check_"+fila).prop("checked",false);
                    }else{
                       $("#check_"+fila).prop("checked",true);                     
                    }                    
                    resaltar();
                    selectRowArt($(this).attr("id").substring(3,20));
                    //seleccionarArticulo(this); 
                });
                $("#msg").html(""); 
                $("#result").html(cant_articulos +" coincidencias...");
                selectRowArt($(".Libre").first().attr("id").substring(3,20));// Primero Libre
                 
            }else{
                limpiarListaArticulos();
                $("#msg").html(""); 
                $("#result").removeClass("info");
                $("#result").addClass("error");
                $("#result").html("0 coincidencias...");
            }
        }
    });
    }
}

function resaltar(){
    var suma = 0;
    $(".check").each(function(){   
        var id = $(this).attr("id").substring(6,26); 
        if($(this).is(":checked")){
           $("#tr_"+id).addClass("checked");
           var stock = parseFloat($(".fila_art_"+id).attr("data-stock_nf"));
           suma+=stock;
        }else{
           $("#tr_"+id).removeClass("checked");      
        }              
   }); 
   $("#seleccionados").val(suma.toFixed(1));
   if(suma > 0){
       $("#add_code").removeAttr("disabled");      
    }else{
       $("#add_code").attr("disabled",true);      
    }
}

function selectItem(){
  
  var pedido = parseFloat($("#requeridos").val().replace(".","").replace(",","."));
   
   var actual = 0; 
   if($("#autoselect").is(":checked")){
      $(".check").each(function(){
           $(this).prop("checked",false);
      });      
      $(".check").each(function(){
            var id = $(this).attr("id").substring(6,26);            
            var stock = parseFloat($(".fila_art_"+id).attr("data-stock_nf"));
            if(actual < pedido){
               actual+=stock;
               $(this).prop("checked",true);
            } 
      });
      resaltar();
   }    
}

function limpiarListaArticulos(){    
    $(".tr_art_data").each(function () {   
         $(this).remove();
    });   
}
function seleccionar(){
    $(".art_selected").click();
}
function seleccionarArticulo(obj){
    var seleccionados = $("input.check:checked").length;
    
    var codigo = $(obj).attr("data-codigo"); 
    var lote = $(obj).find(".lote").html();
    var sector = $(obj).find(".Sector").html(); 
    var nombre_com = $(obj).find(".NombreComercial").html();  
    var stock = $(obj).attr("data-stock"); 
    var suc = $(obj).find(".Suc").html();
    var color = $(obj).find(".Color").html();
    var img = $(obj).attr("data-img"); 
    var precio_venta = $(obj).attr("data-precio");  
    var PrecioCosto =  parseFloat($(obj).attr("data-precio_costo"));   
    var valor_minimo = PrecioCosto + (PrecioCosto * PORC_VAL_MIN / 100);
    $("#valor_minimo").val(valor_minimo);
      
    $("#codigo").val(codigo);
    $("#lote").val(lote);
    $("#descrip").val(sector+"-"+nombre_com+"-"+color);   
    
    if(seleccionados == 1){
       var c =  parseFloat($("#cantidad").val());
       if(c <= 0){
           $("#cantidad").val(stock);
       } 
        
    }else{
       $("#cantidad").val(stock); 
    }
    
    
    $("#color").val(color);
    $("#stock").val(stock); 
    $("#suc").val(suc);
    
    var pv = parseFloat($("#precio_venta").val());
    if(pv == "NaN" || pv == 0){
      $("#precio_venta").val(precio_venta);
    }
    
    var images_url = $("#images_url").val();
    
    //checkear();// Aqui genera el Pedido 
    
    if(img != "" && img != undefined){
        $("#img_td").html("<span id='img' class='zoom'><img id='imagen_lote' src='"+images_url+"/"+img+".thum.jpg' width='160px' height='120px' style='border: solid gray 1px;margin:4px 0 4px 5px'></span>");
         
        //$("#img").zoom({url: images_url+"/"+img+".jpg"});
         
        //$("#imagen_lote").attr("src",images_url+"/"+img+".thum.jpg"); 
        $("#img_td").click(function(){ cargarImagenLote(img);});
    }else{
        $("#img_td").html("<span id='img' class='zoom'><img src='img/no-image.png' width='160px' height='120px' style='border: solid gray 1px;margin:4px 0 4px 5px'></span>");
        $("#img").trigger('zoom.destroy'); // remove zoom
    }
    
    setTimeout('$("#cantidad").focus()',300);
    setTimeout('$("#cantidad").select()',300);
    //$("#ui_articulos").fadeOut();
    //checkear();
    /*
    if($("#suc").val() == getSuc()){
        $("#msg").html("Este Articulo se encuentra en su sucursal...");
        $("#add_code").attr("disabled",true);     
    } else{
        $("#add_code").removeAttr("disabled");         
    }*/
     
}
function sumSubtotal(){
    $("table.solicitud_abierta").each(function(){
        var sumSubtotal = 0;
        $(this).find("td.subtotal").each(function(){
            sumSubtotal += parseFloat($(this).text());
        });
        $(this).find("td.sumSubtotal").text(sumSubtotal.toFixed(2));
    });      
}
function cargarImagenLote(img){  
    
    //var img = $("#"+lote).attr("data-img");
    
    $("#image_container").html("");
    var images_url = $("#images_url").val();
    
    var cab = '<div style="width: 500px;text-align: center;background: white">\n\
     <div style="width:100%;background: white;">   <img src="img/substract.png" style="margin-top:-4px"> <input id="zoom_range" onchange="zoomImage()" type="range" name="points"  min="60" max="1000"><img src="img/add.png" style="margin-top:-4px;"></div>\n\
     <div style="float:left;width:10%;background: white;">  <img src="img/close.png" style=margin-top:-20px;margin-left:2px" onclick=javascript:$("#image_container").fadeOut()> </div> </div>';
    
    $("#image_container").fadeIn();
    
    var contw = $("#image_container").width();
    
    var width = $(window).width() ; 
    var top = 100;
    
    var center = (width / 2) - (contw / 2);

    $("#image_container").offset({left:30,top:top});
    var path = images_url+"/"+img+".jpg";
    
    var imghtml = '<img src="'+ path +'" id="img_zoom" onclick=javascript:$("#image_container").fadeOut() width="500" >';
    $("#image_container").html( cab +" "+ imghtml);
    $("#image_container").draggable();  
}
function zoomImage(){
    var w = $("#zoom_range").val();    
    $("#image_container").width(w);
    $("#img_zoom").width(w);    
}
function setHotKeyArticulo(){
    $(".buscador").keyup(function(e) {
        
        var tecla = e.keyCode; //console.log(tecla);  
        if (tecla == 38) {
            (fila_art == 0) ? fila_art = cant_articulos-1 : fila_art--;       
            selectRowArt(fila_art);
        }
        if (tecla == 40) {
            (fila_art == cant_articulos-1) ? fila_art = 0 : fila_art++;  
            selectRowArt(fila_art);
        }
        if (tecla != 38 && tecla != 40 && tecla != 13) {
            //buscarLote();
            //console.log("Tecla: "+tecla);
            escribiendo = true;            
        }
        if (tecla == 13) {
           if(!escribiendo){ 
             //seleccionarArticulo(".fila_art_"+fila_art); 
             $(".fila_art_"+fila_art).find(".check").prop("checked",true);
             resaltar();
           }else{
               buscarLote();
               setTimeout("escribiendo = false;",700);
           }
        }
        if (tecla == 116) { // F5
            e.preventDefault(); 
        }  
    });
}
function seleccionarAbajo(){
   (fila_art == cant_articulos-1) ? fila_art = 0 : fila_art++;  
    selectRowArt(fila_art);  
}
function seleccionarArriba(){
   (fila_art == 0) ? fila_art = cant_articulos-1 : fila_art--;       
    selectRowArt(fila_art);
}
function selectRowArt(row) {
    var images_url = $("#images_url").val();
    $(".art_selected").removeClass("art_selected");
    $(".fila_art_" + row).addClass("art_selected");
    $(".cursor").remove();
    $($(".fila_art_" + row + " td").get(2)).append("<img class='cursor' src='img/l_arrow.png' width='18px' height='10px'>");
    var img = $(".fila_art_" + row).attr("data-img");
    if(img != "" && img != undefined){
        $("#img_td").html("<span id='img' class='zoom'><img src='"+images_url+"/"+img+".thum.jpg' width='160px' height='120px' style='border: solid gray 1px;margin:4px 0 4px 15px'></span>");
        //$("#img").zoom({ on:'grab' }); 
        // Opcional para Zoom mayor
        
       $("#img_td").click(function(){ cargarImagenLote(img);}); 
       //$("#img").zoom({url: images_url+"/"+img+".jpg"});
    }else{
        $("#img_td").html("<span id='img' class='zoom'><img src='img/no-image.png' width='146px' height='110px' style='border: solid gray 1px;margin:4px 0 4px 15px'></span>");
        $("#img").trigger('zoom.destroy'); // remove zoom
    }
    escribiendo = false;  
     
    var codigo = $(".fila_art_" + row).data("codigo"); 
    var sector = $(".art_selected").find(".Sector").html(); 
    var nombre_com = $(".art_selected").find(".NombreComercial").html();  
    var stock = $(".art_selected").attr("data-stock"); 
    var suc = $(".art_selected").find(".Suc").html();
    var color = $(".art_selected").find(".Color").html();
    var precio_venta = $(".art_selected").attr("data-precio");  
    var PrecioCosto =  parseFloat($(".art_selected").attr("data-precio_costo"));   
    var valor_minimo = PrecioCosto + (PrecioCosto * PORC_VAL_MIN / 100);
    $("#valor_minimo").val(valor_minimo);
    
    $("#codigo").val(codigo);
    $("#descrip").val(sector+"-"+nombre_com+"-"+color);   
    $("#cantidad").val(stock);
    $("#color").val(color);
    $("#stock").val(stock); 
    $("#suc").val(suc);
    $("#seleccionar").fadeIn();   
    $("#precio_venta").val(precio_venta);
    buscarUltimoPrecioVenta();
} 
function buscarUltimoPrecioVenta(){
    var codigo = $("#codigo").val();
    var cod_cli = $("#codigo_cliente").val();
    $.ajax({
        type: "POST",
        url: "pedidos/SolicitudTrasladoMobile.class.php",
        data: {"action": "getPrecioVentaAnterior", codigo: codigo,cod_cli:cod_cli},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {   
            for (var i in data) { 
                var precio = data[i].precio;
                $("#precio_venta").val(precio); 
            }   
            $("#msg").html(""); 
        }
    });
}

function setDefaultDataNextFlag(){
    data_next_time_flag = true;
}
 
function generarSolicitudTraslado(){
    var sucd = $("#suc").val();
    var cod_cli = $("#codigo_cliente").val();
    var cliente = $("#nombre_cliente").val();
    var cat = $("#categoria").val();
    
    if(sucd != ""){
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: {"action": "generarSolicitudTraslado", suc: getSuc(),sucd:sucd,usuario:getNick(),cod_cli:cod_cli,cliente:cliente,cat:cat,tipo:tipo_busqueda},
        async: true,
        dataType: "json",
        beforeSend: function() {
            $(".generar").fadeOut();
            $("#msg").html("Generando Solicitud... <img src='img/loading_fast.gif' width='18px' height='18px' >"); 
        },
        success: function(data) {   
            //n_nro as Nro,usuario as Usuario,date_format(fecha,'%d-%m-%Y') as Fecha,estado as Estado,suc as Origen,suc_d as Destino
            var Nro = data[0].Nro;
            var Usuario = data[0].Usuario;
            var Fecha = data[0].Fecha;
            var Estado = data[0].Estado;
            var Origen = data[0].Origen;
            var Destino = data[0].Destino;    
            nro_nota = Nro;
            var html = '<table border="1" class="solicitud_abierta_cab solicitud_'+Nro+'" data-destino="'+Destino+'" data-nro="'+Nro+'" style="border:1px solid gray;border-collapse: collapse;min-width: 80%;margin:4 auto;">\n\
            <tr style="background-color: lightgray">\n\
                        <th>Nro</th> <th>Usuario</th><th>Origen</th><th>Destino</th><th>Fecha</th><th>Estado</th>\n\
            </tr>\n\
                        <tr> <th>'+Nro+'</th> <th class="cod_cli" >'+cod_cli+'</th><th style="text-align: left">'+cliente+'</th><th>'+Destino+'</th><th>'+Fecha+'</th><th class="estado" style="background-color: #white;color:black;width:170px;height:28px">Abierta&nbsp;<input type="button" value="Enviar Solicitud" style="display:none;height:22px;font-size: 9px;cursor:pointer" onclick="enviarSolicitud('+Nro+')"></th> </tr>\n\
            <tr>\n\
                <td colspan="6">\n\
                    <table border="1" id="sol_'+Nro+'" class="solicitud_abierta" data-destino="'+Destino+'" data-nro="'+Nro+'" style="border:1px solid gray;border-collapse: collapse;min-width: 100%;">\n\
                        <tr class="titulo"><th>Lote</th><th>Descrip</th><th>Color</th><th>Cantidad</th><th>Precio</th><th>Subtotal</th><th>Mayorista</th><th>Urgente</th><th>Obs</th></tr>\n\
                    </table>\n\
                </td>\n\
            </tr></table>';
            
            $("#solicitudes").append(html);
            activarEstados();
            $("#msg").html("Ok"); 
            //checkear();
            controlarVacias();
           
            if(agregar_lotes){
                 agregar_lotes = false;
                 agregarLotes();
            }
           
        }
    });
    }else{
        alert("Seleccione al menos un articulo para identificar la sucursal.");
    }
}
function checkear(){
    
    var stock    =  parseFloat(  $("#stock").val().replace(".","").replace(",",".") ); 
    var cantidad =  parseFloat(  $("#cantidad").val().replace(".","").replace(",",".") ); 
     
    var lote = $("#lote").val();
    var descrip = $("#descrip").val();
    var sucp = $("#suc").val();
    var cod_cli = $("#codigo_cliente").val(); 
    
    var encontro = false; 
    if(cantidad > 0 && lote.length > 0 && descrip.length > 0 && (cantidad <= stock) ) {
         
        $(".solicitud_abierta_cab").each(function(){
            var destino = $(this).attr("data-destino"); 
            var nro = $(this).attr("data-nro");
            var codigo_cliente = $(this).find(".cod_cli").html();
             
            if(cod_cli != codigo_cliente){
                 $(this).fadeOut();
            }else{            
                if(destino == sucp  && cod_cli ==  codigo_cliente ){  // Controlar codigo de cliente                    
                   encontro = true; 
                   $(this).fadeIn(); 
                   nro_nota = nro;
                }else{
                   $(this).fadeOut(); 
                }
            }
        });
         
        if(encontro){
            // Verficar duplicados
            var duplicado = false;
            $(".lote_"+lote).each(function(){
                duplicado = true;
            });            
            if(duplicado){
                $("#result").addClass("duplicado");
                $("#result").html("Articulo "+lote+" Duplicado!!! Intente con otro Codigo.");     
                $(".lote_"+lote).css("background","orange"); 
                setTimeout('$(".lote_'+lote+'").css("background","initial")',4000);
            }else{
               $("#result").html("");
               agregar_lotes = false;
               agregarLotes();
            }
            
        }else{
            generarSolicitudTraslado();
            // Generar una ya que no hay 
            //$(".generar").fadeIn();
            //$("#add_code").attr("disabled",true);  
        }
        
    }else{     
        generarSolicitudTraslado();
        //$("#add_code").attr("disabled",true); 
        //$(".generar").fadeOut();
    }
}
function borrarLote(lote,nro){
    var c = confirm("Esta seguro de que desea eliminar este Articulo?");
    if(c){
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: {"action": "borrarLoteDeSolicitudTraslado", nro_nota: nro, lote:lote},
        async: true,
        dataType: "html",
        beforeSend: function() {
            $("#msg").html("<img src='img/loading_fast.gif' width='18px' height='18px' >");                      
        },
        complete: function(objeto, exito) {
            if (exito == "success") {                          
                var result = $.trim(objeto.responseText);
                if(result == "Ok"){
                    $(".lote_"+lote).parent().remove();
                    $("#msg").html(result);
                    sumSubtotal();
                }else{
                    $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
                }
            }
            controlarVacias();
        },
        error: function() {
            $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });   
   }
   sumSubtotal();
}
function enviarSolicitud(nro){
    var cont = 0;
    $("#sol_"+nro+" td[name='lote']").each(function(){
       cont++;
    });
        if(cont > 0){   
            var c = confirm("Confirma enviar esta solicitud?");
            if(c){
                $.ajax({
                    type: "POST",
                    url: "Ajax.class.php",
                    data: {"action": "cambiarEstadoSolicitudTraslado", usuario: getNick(), nro: nro,estado:'Pendiente'},
                    async: true,
                    dataType: "html",
                    beforeSend: function() {
                        $("#msg").html("<img src='img/loading_fast.gif' width='18px' height='18px' >");                      
                    },
                    complete: function(objeto, exito) {
                        if (exito == "success") {                          
                            var result = $.trim(objeto.responseText);     
                            $(".solicitud_"+nro).slideUp();
                            $(".solicitud_"+nro).remove();
                            $("#msg").html(result);
                        }
                    },
                    error: function() {
                        $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
                    }
                });   
           }
    }else{
        alert("Debe cargar almenos 1 Articulo para enviar la Solicitud.");
    }
}
function mostrarTodo() {
    $(".solicitud_abierta_cab").show();
}
function mostrarResultados() {
    if( $(".tr_art_data").length>0 ){
        $("#ui_articulos").fadeIn();
    }
}
function ocultarResultados() {    
    $("#ui_articulos").fadeOut();    
}

function  historial(){
    var lote = $("#lote").val();
    var suc = $("#suc").val();     
    var url = "productos/HistorialMovimiento.class.php?lote="+lote+"&suc="+suc+"";
    var title = "Historial de Movimiento de Lote";
    var params = "width=980,height=480,scrollbars=yes,menubar=yes,alwaysRaised = yes,modal=yes,location=no";
    
    if(!ventana){        
        ventana = window.open(url,title,params);
    }else{
        ventana.close();
        ventana = window.open(url,title,params);
    }  
}

var ping_time = 0;

var timeout = null;
var check_flag = true;

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

function comprobanteTermico(nro){
    
    var params = "width=400,height=400,scrollbars=yes,menubar=yes,alwaysRaised = yes,modal=yes,location=no";
    var url = "https://190.128.150.70/marijoa_sap/pedidos/ImpresorComprobanteTermico.class.php?nro="+nro+"";
    var title = "Comprobante de Pedido";
    if(!printing){        
        printing = window.open(url,title,params);
    }else{
        printing.close();
        printing = window.open(url,title,params);
    } 
}

function cerrar(){
   $("#ui_clientes").fadeOut();
}
