var nro_nota = 0;
var decimales = 0;
var cant_articulos = 0;
var fila_art = 0;

var data_next_time_flag = true;
var ventana;

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
        checkear();
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
}
function activarEstados(){
     $(".estado").hover(function(){ $(this).children().fadeIn();} ,function(){$(this).children().fadeOut();});   
}

function limpiarAreaCarga(){
    $("#codigo").val(""); 
    $("#lote").val(""); 
    $("#descrip").val(""); 
    $("#stock").val(""); 
    $("#cantidad").val("");  
    $("#color").val(""); 
    $("#obs").val(""); 
    $("#lote").focus();
    checkear();
}

function addCode(){
    var lote = $("#lote").val();
    var color = $("#color").val(); 
    var codigo = $("#codigo").val();
    var urge = $("#urge").val();
    var mayorista = $("#mayorista").val();
    var descrip = $("#descrip").val();
    var cantidad = $("#cantidad").val().replace(".","").replace(",",".");
    var obs = $("#obs").val();
    var destino = $("#suc").val();   
    if(lote.length > 0){
        $.ajax({
            type: "POST",
            url: "Ajax.class.php",
            data: {"action": "addLoteSolicitudTraslado", nro_nota: nro_nota,codigo:codigo,lote:lote,usuario:getNick(),cantidad:cantidad,urge:urge,mayorista:mayorista,descrip:descrip,color:color,obs:obs,destino:destino},
            async: true,
            dataType: "json",
            beforeSend: function() {
                $("#msg").html("<img src='img/loading_fast.gif' width='18px' height='18px' >"); 
            },
            success: function(data) {   
                            
                var estado = data.estado;                
                var mensaje = data.mensaje;                
                $("#msg").removeClass();
                if(estado == "Ok"){                
                    $("#sol_"+nro_nota).append("<tr style='background-color: white'  ><td class='item lote_"+lote+"' name='lote'>"+lote+"</td><td class='item'>"+descrip+"</td><td class='item'>"+color+"</td><td class='num'>"+cantidad+"</td><td class='itemc'>"+mayorista+"</td><td class='itemc'>"+urge+"</td><td class='item'>"+obs+"</td>\n\
                    <td class='itemc'><img src='img/trash_mini.png' class='trash' id='trash_{"+lote+"}' style='cursor:pointer;' onclick='borrarLote("+lote+","+nro_nota+")'  /></td></tr>");
                    $("#msg").addClass("info");
                    $("#msg").html(mensaje+"   <img src='img/ok.png' width='18px' height='18px' >"); 
                    limpiarAreaCarga();
                }else{
                    $("#msg").addClass("error");
                    $("#msg").html(mensaje); 
                } 
            }
        });
    }
}
function showKeyPad(){
    showNumpad("lote",buscarLote,false);
}
function buscarLote(){
    $("[readonly], .editable:not(select):not(input#lote):not(input#color)").val(""); // Limpiar Área de Carga
    checkear();

    var articulo = $("#lote").val();
    var color = $("#color").val(); 
    var filtroStock = $("#filtroStock").val();
    var sucOrigen = getSuc();
    var sucDestino = $("#sucObjetivo option:selected").val();
    var tipo_busqueda = $("#tipo_busqueda").val();
    var mi_suc = $("#mi_suc").is(":checked");
    fila_art = 0;
    if(articulo.length > 0){
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: {"action": "buscarLotes", "articulo": articulo,"color":color,"sucOrigen":sucOrigen,"sucDestino":sucDestino,"filtroStock":filtroStock,tipo_busqueda:tipo_busqueda,mi_suc:mi_suc,suc:getSuc()},
        async: true,
        dataType: "json",
        beforeSend: function() {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            $("#result").removeClass("error");
            $("#result").addClass("info");
            $("#result").html("Buscando...");
        },
        success: function(data) { 
            //o.ItemCode,o.BatchNum as Lote,i.U_NOMBRE_COM, cast(round(Quantity - o.IsCommited,2) as numeric(20,2)) as Stock,o.U_ancho as Ancho,c.Name as Color,Status,WhsCode AS Suc,U_img as Img
            if(data.length > 0){
                limpiarListaArticulos();
                var k = 0;
                for(var i in data){        
                    k++;
                    var fallas = '';
                    var ItemCode = data[i].ItemCode;
                    var Lote = data[i].Lote;
                    var Sector = data[i].Sector;
                    var NombreComercial = data[i].NombreComercial;
                    var Color = data[i].Color;
                    var Stock =  parseFloat(  (data[i].Stock) ).format(2, 3, '.', ',');   
                    var Precio1 =  parseFloat(  (data[i].Precio1) ).format(0, 3, '.', ',');   
                    var Ancho = data[i].Ancho;
                    var Suc = data[i].Suc;
                    var Img = data[i].Img;
                    var imageTitle = "";
                    var doc = data[i].doc.doc?data[i].doc.doc:'Libre';
                    if(Img != ""){  
                        imageTitle = "title='"+Img+"'";
                    }

                    fallas += (parseFloat(data[i].f1)>0)?'<span class="fallas" title="'+parseFloat(data[i].f1)+'">F1</span>':'';
                    fallas += (parseFloat(data[i].f2)>0)?'<span class="fallas" title="'+parseFloat(data[i].f2)+'">F2</span>':'';
                    fallas += (parseFloat(data[i].f3)>0)?'<span class="fallas" title="'+parseFloat(data[i].f3)+'">F3</span>':'';
                    fallas = (fallas.trim().length>0)?', Falla: '+fallas:'';

                    // "<tr class='tr_art_data fila_art_"+i+" "+((sucOrigen===Suc)?'current':'')+"' data-codigo='"+ItemCode+"' data-stock='"+Stock+"' data-img='"+Img+"'  >
                    var td_doc = $("<td/>",{"class":"itemc Doc"});
                    var div_doc = $("<div/>",{"class":"doc"}).append($("<p/>",{"text":doc}));
                    var doc_det = $("<div/>",{"class":"doc_det","text":''});
                    
                    if(doc !== 'Libre'){ 
                        var texto =  "Nro.: "+data[i].doc.n_nro;
                        texto += (doc === 'Remision')?' para '+data[i].doc.suc:' desde '+data[i].doc.suc;
                        doc_det.text(texto);
                    }
                    div_doc.append(doc_det);
                    div_doc.appendTo(td_doc);

                    var tr = $("<tr/>",{
                        "class":"tr_art_data fila_art_"+i+" "+(((sucOrigen===Suc)?'current':'')+" "+doc),
                        "data-codigo":ItemCode, 
                        "data-stock":Stock, 
                        "data-img":Img
                    });
                    //console.log(td_doc);

                    tr.append("<td class='item clicable_art'><span class='codigo lote' >"+Lote+"</span></td>  <td class='item clicable_art'><span class='item Sector'>"+Sector+"</span> </td><td  class='item clicable_art'><span class='item NombreComercial'>"+NombreComercial+"</span><span class='fallas'>"+fallas+"</span></td> \n\
                    <td class='item Color' "+imageTitle+" >"+Color+"</td><td class='num'>"+Stock+"</td><td class='itemc Suc'>"+Suc+"</td><td class='num'>"+Precio1+"</td>");
                    
                    tr.append(td_doc);
                    $("#lista_articulos").append(tr);                                                      
                    cant_articulos = k;
                }  
                inicializarCursores("clicable_art"); 
                $("#ui_articulos").fadeIn();
                $("tr.tr_art_data.Libre").click(function(){                            
                      seleccionarArticulo(this); 
                });
                $("#msg").html(""); 
                $("#result").html(cant_articulos +" coincidencias...");
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

function limpiarListaArticulos(){    
    $(".tr_art_data").each(function () {   
       $(this).remove();
    });   
}
function seleccionarArticulo(obj){
    
    var codigo = $(obj).attr("data-codigo"); 
    var lote = $(obj).find(".lote").html();
    var sector = $(obj).find(".Sector").html(); 
    var nombre_com = $(obj).find(".NombreComercial").html();  
    var stock = $(obj).attr("data-stock"); 
    var suc = $(obj).find(".Suc").html();
    var color = $(obj).find(".Color").html();
    var img = $(obj).attr("data-img"); 
      
    $("#codigo").val(codigo);
    $("#lote").val(lote);
    $("#descrip").val(sector+"-"+nombre_com+"-"+color);   
    $("#cantidad").val(stock);
    $("#color").val(color);
    $("#stock").val(stock); 
    $("#suc").val(suc);
    var images_url = $("#images_url").val();
    
    if(img != "" && img != undefined){
        $("#img_td").html("<span id='img' class='zoom'><img src='"+images_url+"/"+img+".thum.jpg' width='146px' height='110px' style='border: solid gray 1px;margin:4px 0 4px 15px'></span>");
        //$("#img").zoom({ on:'grab' }); 
        // Opcional para Zoom mayor
          
        $("#img").zoom({url: images_url+"/"+img+".jpg"});
    }else{
        $("#img_td").html("<span id='img' class='zoom'><img src='img/no-image.png' width='146px' height='110px' style='border: solid gray 1px;margin:4px 0 4px 15px'></span>");
        $("#img").trigger('zoom.destroy'); // remove zoom
    }
    
    setTimeout('$("#cantidad").focus()',300);
    setTimeout('$("#cantidad").select()',300);
    $("#ui_articulos").fadeOut();
    checkear();
    if($("#suc").val() == getSuc()){
        $("#msg").html("Este Articulo se encuentra en su sucursal...");
    } 
     
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
             seleccionarArticulo(".fila_art_"+fila_art); 
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
        $("#img_td").html("<span id='img' class='zoom'><img src='"+images_url+"/"+img+".thum.jpg' width='146px' height='110px' style='border: solid gray 1px;margin:4px 0 4px 15px'></span>");
        //$("#img").zoom({ on:'grab' }); 
        // Opcional para Zoom mayor
          
        $("#img").zoom({url: images_url+"/"+img+".jpg"});
    }else{
        $("#img_td").html("<span id='img' class='zoom'><img src='img/no-image.png' width='146px' height='110px' style='border: solid gray 1px;margin:4px 0 4px 15px'></span>");
        $("#img").trigger('zoom.destroy'); // remove zoom
    }
    escribiendo = false;   
} 

function setDefaultDataNextFlag(){
    data_next_time_flag = true;
}
 
function generarSolicitudTraslado(){
    var sucd = $("#suc").val();
    
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: {"action": "generarSolicitudTraslado", suc: getSuc(),sucd:sucd,usuario:getNick()},
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
        
            var html = '<table border="1" class="solicitud_abierta_cab solicitud_'+Nro+'" data-destino="'+Destino+'" data-nro="'+Nro+'" style="border:1px solid gray;border-collapse: collapse;min-width: 80%;margin:4 auto;">\n\
            <tr style="background-color: lightgray">\n\
                        <th>Nro</th> <th>Usuario</th><th>Origen</th><th>Destino</th><th>Fecha</th><th>Estado</th>\n\
            </tr>\n\
                        <tr> <th>'+Nro+'</th> <th>'+Usuario+'</th><th>'+Origen+'</th><th>'+Destino+'</th><th>'+Fecha+'</th><th class="estado" style="background-color: #73AD21;color:white;width:170px;height:28px">Abierta&nbsp;<input type="button" value="Enviar Solicitud" style="display:none;height:22px;font-size: 9px;cursor:pointer" onclick="enviarSolicitud('+Nro+')"></th> </tr>\n\
            <tr>\n\
                <td colspan="6">\n\
                    <table border="1" id="sol_'+Nro+'" class="solicitud_abierta" data-destino="'+Destino+'" data-nro="'+Nro+'" style="border:1px solid gray;border-collapse: collapse;min-width: 100%;">\n\
                        <tr class="titulo"><th>Lote</th><th>Descrip</th><th>Color</th><th>Cantidad</th><th>Mayorista</th><th>Urgente</th><th>Obs</th></tr>\n\
                    </table>\n\
                </td>\n\
            </tr></table>';
            
            $("#solicitudes").append(html);
            activarEstados();
            $("#msg").html("Ok"); 
            checkear();
        }
    });
}
function checkear(){
    
    var stock    =  parseFloat(  $("#stock").val().replace(".","").replace(",",".") ); 
    var cantidad =  parseFloat(  $("#cantidad").val().replace(".","").replace(",",".") ); 
     
    var lote = $("#lote").val();
    var descrip = $("#descrip").val();
    var sucp = $("#suc").val();
     
    
    var encontro = false; 
    if(cantidad > 0 && lote.length > 0 && descrip.length > 0 && (sucp != getSuc()) && (cantidad <= stock) ) {
         
        $(".solicitud_abierta_cab").each(function(){
            var destino = $(this).attr("data-destino"); 
            var nro = $(this).attr("data-nro"); 
            if(destino == sucp){
               encontro = true; 
               $(this).fadeIn(); 
               nro_nota = nro;
            }else{
               $(this).fadeOut(); 
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
               $("#add_code").removeAttr("disabled");         
            }
        }else{
            // Generar una ya que no hay 
            $(".generar").fadeIn();
            $("#add_code").attr("disabled",true);  
        }
        
    }else{        
        $("#add_code").attr("disabled",true); 
        $(".generar").fadeOut();
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
                }else{
                    $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
                }
            }
        },
        error: function() {
            $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });   
   }
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
    }else{
        alert("Debe cargar almenos 1 Articulo para enviar la Solicitud.");
    }
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
    var suc = '%'; //$("#suc").val();     
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