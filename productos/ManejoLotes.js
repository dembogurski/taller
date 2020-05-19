 
var decimales = 0;
var cant_articulos = 0;
var fila_art = 0;

var errores = 0;

var porc_valor_minimo = 25;         

var PORC_MINIMO_RETAZO = 20;

 
function configurar(){
    setHotKeyArticulo();  
    $("#filtros").on("keydown",function(e){
      var tecla = e.keyCode;
      if(tecla == "27"){
          $("#ui_articulos").fadeOut();
          $( "#ui_proveedores" ).fadeOut("fast");
      }    
    });
    $(".fecha").mask("99/99/9999");    
    for(var i = 1;i<8;i++){
       $("#tr_mod").append('<td> <label id="label_'+i+'">Precio'+i+':</label></td><td><input type="text" class="num valores" id="mod_val_'+i+'" size="8" onkeypress="return onlyNumbers(event)"></td>');
    }
    
    var ev = $("#estado_venta").html();
    $("#tr_mod").append('<td> <label>Estado Venta:</label> <select id="new_estado_venta"  onchange="estadoVenta()">'+ev+'</select> \n\
    &nbsp;<input type="button" id="preview" class="botones" value="Previsualizar" onclick="preview()" disabled="disabled">\n\
    &nbsp;<input type="button" id="apply" class="botones" value="Aplicar" onclick="aplicar()" disabled="disabled"> </td>');
    
    $("#mod_val_1").change(function(){
        var pi_ini = $(this).val();
        
        var red50= redondeo50(pi_ini);
        
        $(this).val(red50);        
        var p1 = $(this).val();
        
        $("#mod_val_2").val(redondeo50( p1 - ((p1 * 3) / 100)));
        $("#mod_val_3").val(redondeo50( p1 - ((p1 * 5) / 100)));
        $("#mod_val_4").val(redondeo50( p1 - ((p1 * 8) / 100)));
        $("#mod_val_5").val(redondeo50( p1 - ((p1 * 10) / 100)));
        $("#mod_val_6").val(redondeo50( p1 - ((p1 * 10) / 100)));
        $("#mod_val_7").val(redondeo50( p1 - ((p1 * 10) / 100)));
        checkVal($("#mod_val_1"));
    });
    $(".valores").not("#mod_val_1").change(function(){
        checkVal($(this));
    });
    $("#nombre_proveedor").blur(function(){
        if($(this).val().length == 0){
            $("#codigo_proveedor").val("%"); 
        }
    });
    $(".check_proveedor").trigger("click");
    $(".check_fecha_compra").trigger("click");
    $(".check_descrip").trigger("click");
    $(".check_descuentos").trigger("click");

    actualizarLista();
    ml_iniciarSugerencias();
 }
 

function checkVal(obj){
    var v = $(obj).val();
    var redond_50 = redondeo50( v );
    $(obj).val(redond_50);
    
    var err = 0;
    $(".valores").each(function(){        
        if($(this).val()==""){
            err++;
        }    
    });
    if(err > 0){
       $(".botones").prop("disabled",true);       
    }else{
       $("#preview").removeAttr("disabled");   
    }
}

function preview(){
    var modificar = $("#modificar").val();   
    $("#msg_lotes").html("<img src='img/loading_fast.gif' width='16px' height='16px'>"); 
    
    $(".modificado").removeClass("modificado");  
    $(".resultado").removeClass("resultado");  
    
    var estado_venta = $("#new_estado_venta").val();
    
    var selecteds = 0;
    
    if(modificar == "descuento_directo"){        
        $(".lote").each(function(){ 
            var check = $(this).parent().find(".seleccionable").is(":checked");
            if(check){
                selecteds++;
                for(var i = 1;i <=7;i++){
                    var px =  parseFloat($(this).parent().find(".p"+i).text().replace(/\./g, ''));  
                    var vx = $("#mod_val_"+i).val();
                    $(this).parent().find(".d"+i).text(vx).addClass("modificado");
                    $(this).parent().find(".estado_venta").text(estado_venta);                  
                    $(this).parent().find(".Normal, .Oferta, .Arribos, .Promocion, .Retazo").toggleClass(estado_venta);
                    $(this).parent().find(".pf"+i).text(redondear(px - (px * vx / 100))).addClass("resultado");    
                }
          }
        });          //.replace(/\./g, '').replace(/\,/g, '.');
    }else if(modificar == "precio_final_directo"){     
        //$(".lote").each(function(){ 
           $(".lote").each(function(){ 
            var check = $(this).parent().find(".seleccionable").is(":checked");
            if(check){ 
                selecteds++;    
                for(var i = 1;i <=7;i++){                
                    var px =  parseFloat($(this).parent().find(".p"+i).text().replace(/\./g, ''));  
                    var vx = $("#mod_val_"+i).val();
                    $(this).parent().find(".pf"+i).text(  vx  ).addClass("modificado");  
                    $(this).parent().find(".estado_venta").text(estado_venta);
                    $(this).parent().find(".Normal, .Oferta, .Arribos, .Promocion, .Retazo").toggleClass(estado_venta);
                    $(this).parent().find(".d"+i).text( 100 - (( vx * 100) / px)).addClass("resultado"); 
                }    
            }       
          });               
        //});              
    }else if(modificar == "porc_resp_costo"){     
        $(".lote").each(function(){ 
         var check = $(this).parent().find(".seleccionable").is(":checked");
            if(check){ 
                selecteds++;
                for(var i = 1;i <=7;i++){                
                    var preciox =  parseFloat($(this).parent().find(".p"+i).text().replace(/\./g, ''));   
                    var p_costox =  parseFloat($(this).parent().find(".p_costo").text().replace(/\./g, ''));  
                    var vx = $("#mod_val_"+i).val();
                    var precio_finalx = redondear(p_costox * vx / 100);
                    $(this).parent().find(".pf"+i).text(  precio_finalx  ).addClass("modificado"); 
                    $(this).parent().find(".estado_venta").text(estado_venta);
                    $(this).parent().find(".Normal, .Oferta, .Arribos, .Promocion, .Retazo").toggleClass(estado_venta);
                    $(this).parent().find(".d"+i).text(redondear(100 - (( precio_finalx * 100) / preciox))).addClass("resultado"); 
                }  
        }          
        });           
    }else if(modificar == "porc_resp_valmin"){       
        $(".lote").each(function(){ 
         var check = $(this).parent().find(".seleccionable").is(":checked");
            if(check){ 
                selecteds++;
                for(var i = 1;i <=7;i++){                
                    var preciox =  parseFloat($(this).parent().find(".p"+i).text().replace(/\./g, ''));   
                    var p_valmin =  parseFloat($(this).parent().find(".p_valmin").text().replace(/\./g, ''));  
                    var vx = $("#mod_val_"+i).val();
                    var precio_finalx = redondear(p_valmin * vx / 100);
                    $(this).parent().find(".pf"+i).text(  precio_finalx  ).addClass("modificado");  
                    $(this).parent().find(".estado_venta").text(estado_venta);
                    $(this).parent().find(".Normal, .Oferta, .Arribos, .Promocion, .Retazo").toggleClass(estado_venta);
                    $(this).parent().find(".d"+i).text(redondear(100 - (( precio_finalx * 100) / preciox))).addClass("resultado"); 
                } 
         }
       });               
    } 
    
    if(selecteds < 1){
        errorMsg("Debe seleccionar los lotes para previsualizar las modificaciones.",15000);
    }
    
    $("#msg_lotes").html(""); 
    $("#apply").removeAttr("disabled");
}
function aplicar(){
    
    var estado_venta = $("#new_estado_venta").val();
    if(estado_venta == '%'){
        alert("Estado de Venta no puede ser %");
        return;
    }
    
    var c = confirm("Al aplicar los descuentos se generara una lista en cada sucursal para la Reimpresion de codigos de barras");
    if(c){
    $(".botones").prop("disabled",true);     
    var data = new Array();
    $("#msg_lotes").html("<span style='background-color;lightskyblue;color:white'> Espere...<img src='img/loading_fast.gif' width='16px' height='16px'></span>"); 
    var cont = 0;    
    $(".lote").each(function(){ 
        var fila = $(this).parent();
        var check = fila.find(".seleccionable").is(":checked");
            if(check){
            fila.find(".result").html("<img class='updating' src='img/loading_fast.gif' width='16px' height='16px'>");    
            var array = new Array();
            var codigo = fila.find(".codigo").text();
            var lote = $(this).text();
            var descrip = fila.find(".descrip").text();
            var suc = fila.find(".suc").text();
            array.push(codigo,lote,descrip,suc);
            for(var i = 1;i <=7;i++){          
               var preciox = fila.find(".p"+i).text().replace(/\./g, '');
               array.push(preciox);
            }
            for(var i = 1;i <=7;i++){          
               var descx = fila.find(".d"+i).text();
               array.push(descx);
            }
            data.push(array);
            cont++;
       }
    });
    
    data = JSON.stringify(data);
    var estado_venta = $("#new_estado_venta").val();
    if(cont > 0){
        $.ajax({
            type: "POST",
            url: "Ajax.class.php",
            data: {"action": "actualizarDescuentosPorLote", data:data,estado_venta:estado_venta,usuario:getNick()},
            async: true,
            dataType: "json",
            beforeSend: function () {
                $("#msg_lotes").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            },
            success: function (data) {   
                var estado = data.estado; 
                var mensaje = data.mensaje;
                if(estado == "Ok"){
                   $("#msg_lotes").html("<span style='background-color;green;color:white'>"+mensaje+"</span>"); 
                   $(".updating").attr("src","img/ok.png");
                }else{
                   $("#msg_lotes").html("Ocurrio un error, vuelva a intentarlo o comuniquese con el Administrador.");  
                   $(".updating").attr("src","img/close.png");
                }                
            }
        });    
    }else{
        $("#msg_lotes").html("Debe marcar los lotes que desea modificar!"); 
        errorMsg("Debe marcar los lotes que desea modificar!",15000);
    }
    }
}
function substractDays(date, days) {
    var result = new Date(date);
    result.setDate(result.getDate() - days);
    
    var dia = result.getDate(); if(dia < 10){ dia = "0"+dia; }
    var mes = result.getMonth()+1;   if(mes < 10){ mes = "0"+mes; }
    var anio = result.getFullYear();
  
    var format = dia+"/"+mes+"/"+anio;   
    return format;
} 
function setEstandar(){
   var v = $("#estandar").val();
   var info = $("#estandar :selected").attr("data-desc");
   if(info != ""){
      $("#msg_info").html(info);
      $("#msg_info").fadeIn();
   }else{
      $("#msg_info").fadeOut();
   }
    
   var desde = ""; 
   var hasta = ""; 
   function todos(){
       $("#codigo").val("%"); 
       $("#descrip").val(""); 
       $("#codigo_proveedor").val("%"); 
       $("#nombre_proveedor").val("");     
   }      
   if(v == ""){       
       
   }else if(v == "5x4"){
       desde = substractDays(new Date(),365 * 5); 
       hasta = substractDays(new Date(),365 * 4); 
       $(".valores").val(100);
       $("#modificar").val("porc_resp_valmin");
   }else if(v == "5x4_crucero"){
       desde = substractDays(new Date(),365 * 5); 
       hasta = substractDays(new Date(),365 * 4);         
       $(".valores").val(100); 
       $("#modificar").val("porc_resp_costo");
   }else if(v == "7x5"){
       desde = substractDays(new Date(),365 * 7); 
       hasta = substractDays(new Date(),365 * 5);
       $(".valores").val(100);   
       $("#modificar").val("porc_resp_costo");
   }else{ // 0x7
       desde = substractDays(new Date(),365 * 100); 
       hasta = substractDays(new Date(),365 * 7); 
       $(".valores").val(50);
       $("#modificar").val("porc_resp_costo");
   }   
   todos();   
   $("#desde").val(desde);
   $("#hasta").val(hasta);    
}
 

function setLabels(){
    var mod = $("#modificar").val();
    var label = "Desc";
    if(mod == "precio_final_directo"){
        label = "Precio"; 
    }else if(mod == "porc_resp_costo"){
        label = "%/Costo"; 
    }else if(mod == "porc_resp_valmin"){
        label = "%/Val Min"; 
    }
    for(var i = 1;i <= 7;i++){
        $("#label_"+i).text(label+""+i+":");         
    }
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
    var sector = $(obj).find(".Sector").html(); 
    var nombre_com = $(obj).find(".NombreComercial").html();  
    var precio = $(obj).attr("data-precio");
    var um = $(obj).attr("data-um");
    $("#codigo").val(codigo);
    $("#descrip").val(sector+"-"+nombre_com);
    $("#um").val(um);
    $("#ui_articulos").fadeOut();
    $("#precio_venta").val(precio);
    $("#precio_venta").focus();
     getColores();
}
function seleccionarProveedor(obj){
    var proveedor = $(obj).find(".proveedor").html(); 
    //var ruc = $(obj).find(".ruc").html();  
    var codigo = $(obj).find(".codigo").html(); 
 
    //$("#ruc_proveedor").val(ruc);
    $("#nombre_proveedor").val(proveedor);
    $("#codigo_proveedor").val(codigo); 
     
    $( "#ui_proveedores" ).fadeOut("fast");
    $("#msg").html(""); 
     
}
function mostrar(){}
 
function buscarArticulo(){
    var articulo = $("#descrip").val();
    var cat = 1;
    if(articulo.length > 0){
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
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
                    var ItemCode = data[i].ItemCode;
                    var Sector = data[i].Sector;
                    var NombreComercial = data[i].NombreComercial; 
                    var Precio =  parseFloat(  (data[i].Precio) ).format(0, 3, '.', ',');
                    var Ancho = parseFloat(data[i].U_ANCHO).format(2, 3, '.', ',');
                    var Composicion = data[i].U_COMPOSICION;
                    var UM = data[i].UM;         
                                                                         
                    $("#lista_articulos") .append("<tr class='tr_art_data fila_art_"+i+"' data-precio="+Precio+" data-um="+UM+"><td class='item clicable_art'><span class='codigo' >"+ItemCode+"</span></td>\n\
                    <td class='item clicable_art'><span class='Sector'>"+Sector+"</span> \n\
                    </td><td class='item clicable_art'><span class='NombreComercial'>"+NombreComercial+"</span></td> \n\
                    <td class='num clicable_art'>"+Ancho+"</td>\n\
                    <td class='item clicable_art'>"+Composicion+"</td>\n\
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
    }else{
         $("#codigo").val(""); 
    }
} 
function limpiarListaArticulos(){    
    $(".tr_art_data").each(function () {   
       $(this).remove();
    });    
} 
function cerrar(){}  

function limpiarCampos(){
   $(".fecha").val("");     
   $("#codigo").val("%"); 
   $("#descrip").val(""); 
   $("#lotes").val("");
   $("#codigo_proveedor").val("%"); 
   $("#nombre_proveedor").val("");    
}
function ocultar(clase){
    $("."+clase).toggle();
}
function selecccionar(){
   var all = $("#select_all").is(":checked");
   if(all){       
      $(".seleccionable").prop('checked',true);
   }else{   
       $(".seleccionable").removeAttr("checked");
   }
}
function verLotes(){
    $("#btn_preview").prop("disabled",true);
    var desde = $("#desde").val();
    var hasta = $("#hasta").val();
    var codigo = $("#codigo").val();
    var lotes = $("#lotes").val();
    var cod_prov = $("#codigo_proveedor").val();
    var estado_venta = $("#estado_venta").val();
    var fallas = $("#fallas").val(); 
    var terminacion = $("#term").val();
    var fp = $("#fp").val();
    
    var ColorCod = $("select#filtroColores option:selected").val(); 
    if(terminacion == "%"){
        terminacion = '';
    }
    var terminacion_padre = $("#term_padre").val();
    if(terminacion_padre == "%"){
        terminacion_padre = '';
    }
    errores = 0;
    porc_valor_minimo = parseFloat($("#porc_val_min").val());
    
    
    var suc = $("#sucs").val();
    
    $(".fila > td").css("background","rgb(110,110,110)");
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: {"action": "filtroManejoLotes", desde:desde,hasta:hasta,cod_prov:cod_prov,estado_venta:estado_venta,fallas:fallas,codigo:codigo,lotes:lotes,suc:suc,terminacion:terminacion,terminacion_padre:terminacion_padre,ColorCod:ColorCod,fp:fp},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            $("#pder").slideUp(); 
        },
        success: function (data) { 
            $(".fila").remove();    
            var cant = 0;
            var displayColores = ($("th.colores").is(":visible"))?"":"style='display:none'";
            var displayPrecioFinal = ($("th.colores").is(":visible"))?"style='display:none'":"display:block";
            $("div#editarColor, div#pder").hide(0); 
            for (var i in data) { 
                var NroDoc = data[i].NroDoc;
                var CardName = data[i].CardName;                
                var Fecha = data[i].Fecha;  
                var Codigo = data[i].Codigo;  
                var Articulo = data[i].Articulo;  
                var Lote = data[i].Lote;  
                var Suc = data[i].Suc;  
                var Stock =  parseFloat(data[i].Stock).format(2,3,".",","); 
                
                var ColorComercial = data[i].ColorComercial;  
                //var PriceList = data[i].PriceList;  
                var PrecioCosto = parseFloat(data[i].PrecioCosto).format(0,3,".",",");
                var FactorPrecio = parseFloat(data[i].U_factor_precio).format(3,10,"","."); 
                var gramaje =  parseFloat(data[i].U_gramaje).format(3,10,"","."); 
                var ancho = parseFloat(data[i].Ancho).format(3,10,"","."); 
                var precio_promedio_penderado = parseFloat( data[i].PrecioCosto);
                  
                var ValorMinimo = parseFloat(precio_promedio_penderado  + ((precio_promedio_penderado * porc_valor_minimo) / 100)).format(0,3,".",",");
               
                var Precio1 = parseFloat(data[i]["1"]).format(0,3,".",",");
                var Precio2 = parseFloat(data[i]["2"]).format(0,3,".",",");
                var Precio3 = parseFloat(data[i]["3"]).format(0,3,".",",");
                var Precio4 = parseFloat(data[i]["4"]).format(0,3,".",",");
                var Precio5 = parseFloat(data[i]["5"]).format(0,3,".",",");
                var Precio6 = parseFloat(data[i]["6"]).format(0,3,".",",");
                var Precio7 = parseFloat(data[i]["7"]).format(0,3,".",",");
                
                var U_desc1 = parseFloat(data[i].U_desc1).format(6,3,0,0);
                var U_desc2 = parseFloat(data[i].U_desc2).format(6,3,0,0);
                var U_desc3 = parseFloat(data[i].U_desc3).format(6,3,0,0);
                var U_desc4 = parseFloat(data[i].U_desc4).format(6,3,0,0);
                var U_desc5 = parseFloat(data[i].U_desc5).format(6,3,0,0);
                var U_desc6 = parseFloat(data[i].U_desc6).format(6,3,0,0);
                var U_desc7 = parseFloat(data[i].U_desc7).format(6,3,0,0);     

                var ColorCode = data[i].U_color_comercial;
                var ColorComercial = data[i].ColorComercial;
                
                var pf1 = parseFloat( redondeo50(Math.round(data[i]["1"] - (data[i]["1"] * data[i].U_desc1) / 100)));
                var pf2 = parseFloat( redondeo50(Math.round(data[i]["2"] - (data[i]["2"] * data[i].U_desc2) / 100)));
                var pf3 = parseFloat( redondeo50(Math.round(data[i]["3"] - (data[i]["3"] * data[i].U_desc3) / 100)));
                var pf4 = parseFloat( redondeo50(Math.round(data[i]["4"] - (data[i]["4"] * data[i].U_desc4) / 100)));
                var pf5 = parseFloat( redondeo50(Math.round(data[i]["5"] - (data[i]["5"] * data[i].U_desc5) / 100)));
                var pf6 = parseFloat( redondeo50(Math.round(data[i]["6"] - (data[i]["6"] * data[i].U_desc6) / 100)));
                var pf7 = parseFloat( redondeo50(Math.round(data[i]["7"] - (data[i]["7"] * data[i].U_desc7) / 100)));                    
                var EstadoVenta = data[i].EstadoVenta;
                
                var check_proveedor = $(".check_proveedor").is(":checked");
                var check_fecha_compra = $(".check_fecha_compra").is(":checked");
                var check_descrip = $(".check_descrip").is(":checked");
                var check_descuentos = $(".check_descuentos").is(":checked");
                
                var hide_prov = "table-cell";
                if(check_proveedor){
                    hide_prov = "none";
                }
                var hide_fc = "table-cell";
                if(check_fecha_compra){
                    hide_fc = "none";
                }
                var hide_descrip= "table-cell";
                if(check_descrip){
                    hide_descrip = "none";
                }
                var hide_descuentos= "table-cell";
                if(check_descuentos){
                    hide_descuentos = "none";
                }
                var resaltar = "";
                if(PrecioCosto == 0){
                    errores++;
                    resaltar = "resaltar";
                }
                var verValMinPrecMinVent = "";
                if(!$(".verValMinPrecMinVent").is(":visible")){
                    verValMinPrecMinVent = "style='display:none'";
                }

                $(".lotes").append("<tr class='fila' data-gramaje='"+gramaje+"' data-ancho='"+ancho+"'>\n\
                                        <td class='itemc' >"+NroDoc+"</td>\n\
                                        <td class='item proveedor' style='display:"+hide_prov+"'>"+CardName+"</td>\n\
                                        <td class='itemc fecha_compra' style='display:"+hide_fc+"'>"+Fecha+"</td>\n\
                                        <td class='item codigo'>"+Codigo+"</td>\n\
                                        <td class='item descrip' style='display:"+hide_descrip+"'>"+Articulo+"</td>\n\
                                        <td class='item lote' title='"+ColorComercial+"'>"+Lote+"</td>\n\
                                        <td class='itemc suc'>"+Suc+"</td>\n\
                                        <td class='num'>"+Stock+"</td>\n\
                                        <td class='num p_costo "+resaltar+"'"+verValMinPrecMinVent+">"+PrecioCosto+"</td>\n\
                                        <td class='num p_valmin' "+verValMinPrecMinVent+">"+ValorMinimo+"</td>\n\
                                        <td class='num p_factor'>"+FactorPrecio+"</td>\n\
                                        <td class='num p1' data-precio='"+Precio1+"'  >"+Precio1+"</td>\n\
                                        <td class='num p2' data-precio='"+Precio2+"'  >"+Precio2+"</td>\n\
                                        <td class='num p3' data-precio='"+Precio3+"'  >"+Precio3+"</td>\n\
                                        <td class='num p4' data-precio='"+Precio4+"'  >"+Precio4+"</td>\n\
                                        <td class='num p5' data-precio='"+Precio5+"'  >"+Precio5+"</td>\n\
                                        <td class='num p6' data-precio='"+Precio6+"'  >"+Precio6+"</td>\n\
                                        <td class='num p7' data-precio='"+Precio7+"'  >"+Precio7+"</td>\n\
                                        <td class='num d1 descuentos' style='display:"+hide_descuentos+"'>"+U_desc1+"</td>\n\
                                        <td class='num d2 descuentos' style='display:"+hide_descuentos+"'>"+U_desc2+"</td>\n\
                                        <td class='num d3 descuentos' style='display:"+hide_descuentos+"'>"+U_desc3+"</td>\n\
                                        <td class='num d4 descuentos' style='display:"+hide_descuentos+"'>"+U_desc4+"</td>\n\
                                        <td class='num d5 descuentos' style='display:"+hide_descuentos+"'>"+U_desc5+"</td>\n\
                                        <td class='num d6 descuentos' style='display:"+hide_descuentos+"'>"+U_desc6+"</td>\n\
                                        <td class='num d7 descuentos' style='display:"+hide_descuentos+"'>"+U_desc7+"</td>\n\
                                        <td class='num pf1 precios factor_precio filtroLista' "+displayPrecioFinal+" data-precio_final='"+pf1+"'  >"+pf1+"</td>\n\
                                        <td class='num pf2 precios factor_precio filtroLista' "+displayPrecioFinal+" data-precio_final='"+pf2+"'  >"+pf2+"</td>\n\
                                        <td class='num pf3 precios factor_precio filtroLista' "+displayPrecioFinal+" data-precio_final='"+pf3+"'  >"+pf3+"</td>\n\
                                        <td class='num pf4 precios factor_precio filtroLista' "+displayPrecioFinal+" data-precio_final='"+pf4+"'  >"+pf4+"</td>\n\
                                        <td class='num pf5 precios factor_precio filtroLista' "+displayPrecioFinal+" data-precio_final='"+pf5+"'  >"+pf5+"</td>\n\
                                        <td class='num pf6 precios factor_precio filtroLista' "+displayPrecioFinal+" data-precio_final='"+pf6+"'  >"+pf6+"</td>\n\
                                        <td class='num pf7 precios factor_precio filtroLista' "+displayPrecioFinal+" data-precio_final='"+pf7+"'  >"+pf7+"</td>\n\
                                        <td class='colores item filtroLista' "+displayColores+">"+ColorCode+"</td>\n\
                                        <td class='colores item filtroLista' "+displayColores+">"+ColorComercial+"</td>\n\
                                        <td class='itemc estado_venta"+EstadoVenta+"'>"+EstadoVenta+"</td>\n\
                                        <td class='result itemc'><input type='checkbox' class='seleccionable' ></td>\n\
                                    </tr>");
                cant++;            
        }
        if(errores > 0){
            errorMsg("Existen codigos con Precio de Costo incorrecto",15000);
        }
        if(cant > 0){
            $("#msg").html(""); 
        }else{
            $("#msg").html("Ningun resultado, verifique los filtros..."); 
        }
        if($("th.colores").is(":visible")){
            $("div#editarColor").slideDown();
        }else{
            $("div#pder").slideDown();
        }
        $("#btn_preview").removeAttr("disabled");
    }
    });
       
}
function igualarValores(){
   var mod_val_1 = $("#mod_val_1").val(); 
   for(var i = 2;i <=7;i++){
      $("#mod_val_"+i).val(mod_val_1);       
   }  
   checkVal($("#mod_val_1"));
}



function setHotKeyArticulo(){
    $("#descrip").keydown(function(e) {
        
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
        if(tecla == 27){
           $("#ui_articulos").fadeOut(); 
        }  
        if (tecla == 116) { // F5
            e.preventDefault(); 
        } 
          
    });
}
 function getColores() {
     var ItemCode = $("#codigo").val();
     $("#filtroColores").empty();
     $($("#filtroColores").parent()).append("<img src='img/loading_fast.gif' width='16px' height='16px'>");
     $.post("Ajax.class.php", { "action": "coloresXArticulo", "ItemCode": ItemCode }, function(data) {
         if (!data.msg) {
             $("<option/>", {
                 "value": "todos",
                 "text": "--  Todos  --"
             }).appendTo("#filtroColores");
             $.each(data, function(key, value) {
                 $("<option/>", {
                     "value": key,
                     "text": value + ': ' + key
                 }).appendTo("#filtroColores");
             });
         }
         $($("#filtroColores").parent().find("img")).remove();
     }, "json");
 }
function onlyNumbers(e){
        //e.preventDefault();
	var tecla=new Number();
	if(window.event) {
		tecla = e.keyCode;
	}else if(e.which) {
		tecla = e.which;
	}else {
	   return true;
	}
        if(tecla === "13"){
            this.select();
        }
        //console.log(e.keyCode+"  "+ e.which);
	if((tecla >= "97") && (tecla <= "122")){
		return false;
	}
}

/**
 * Tipo de modificación
 */

function actualizarLista(){
    var target = $("select#ml_tipoMod option:selected").val();
    $(".filtroLista").hide(0,function(){
        $("."+target).show(0);
    });
}
function ml_buscarColor(){    
    var colorRef = $("input#ml_cambioColor").val();
    $("ul#ml_listaColores").empty();
    if((colorRef.trim()).length>2){
        $("div#bc_loader").show(0);
        $.post("productos/ManejoLotes.class.php",{"action":"buscarColores","search":colorRef}, function(data){
            $.each(data, function(key,value){
                $("<li/>",{
                    "text":value,
                    "data-codigo":key,
                    "hover":function(){$("ul#ml_listaColores li").removeClass("selected");},
                    "onclick":"ml_setColor($(this))"
                }).appendTo("ul#ml_listaColores");
            });
            $("div#bc_loader").hide(0);
        },'json');
    }
    $("ul#ml_listaColores").show(0);
}
function ml_setColor(target){
    $("input#ml_cambioColor").val(target.text());
    $("input#ml_cambioColor").data('codigo',target.data('codigo'));
    $("ul#ml_listaColores").hide(0);
}
function ml_buscarToggle(){
    if(!$("ul#ml_listaColores").is(":visible")){
        $("ul#ml_listaColores").show(0);
    }
}
function ml_iniciarSugerencias(){
    $("input#ml_cambioColor").unbind();
    $("input#ml_cambioColor").bind({
        keydown: function(e) {
            var options = $("ul#ml_listaColores li").length-1;
            var current = $("ul#ml_listaColores li.selected").index();
            $("ul#ml_listaColores li").removeClass("selected");
            var next = 0;
            switch(e.which){
                case 38:// Flecha arriba
                    if(!$("ul#ml_listaColores").is(":visible")){$("ul#ml_listaColores").show(0);}
                    next = (current == -1)?options:current-1;
                    var target = $("ul#ml_listaColores li").get(next);
                    $(target).addClass("selected");
                    $("input#ml_cambioColor").val($(target).text());
                    $("input#ml_cambioColor").data('codigo',$(target).data('codigo'));
                break;
                case 40:// Flecha abajo
                    if(!$("ul#ml_listaColores").is(":visible")){$("ul#ml_listaColores").show(0);}
                    next = (current == options)?0:current+1;
                    var target = $("ul#ml_listaColores li").get(next);
                    $(target).addClass("selected");
                    $("input#ml_cambioColor").val($(target).text());
                    $("input#ml_cambioColor").data('codigo',$(target).data('codigo'));
                    //console.log('current'+current+', option:'+options+', '+next+', '+target.text());
                break;
                case 13:// Enter
                    $("ul#ml_listaColores").hide(0);
                    break;
                default:
                    ml_buscarColor();
                    break;
            }
        }
    });
}

//Actualizar color
function ml_actualizarColor(){
    $("span#ml_actualizarColorMsj").empty();
    var lotes = [];
    if( $("input[type=checkbox].seleccionable:checked").length == 0 ){
        $("span#ml_actualizarColorMsj").text("Seleccione el o los lotes a actualizar !");
    }else{
        if( $("input#ml_cambioColor").data("codigo").trim().length == 0 || typeof($("input#ml_cambioColor").data("codigo")) == "undefined" ){
            $("span#ml_actualizarColorMsj").text("Seleccione un Color !");
        }else{
            $("div#bc_loader").show(0);
            $($("input[type=checkbox].seleccionable:checked").closest("tr")).each(function(){
                lotes.push($(this).find("td.lote").text());
            });
    
            $.post("productos/ManejoLotes.class.php",{"action":"actualizarColor","usuario":getNick(),"padreEHijos":$("input#padreEHijos").is(":checked"), "lotes":JSON.stringify(lotes), "ColorCod":$("input#ml_cambioColor").data("codigo")}, function(data){
                $("span#ml_actualizarColorMsj").text(data.msj);
                $("div#bc_loader").hide(0);
                $("input#btn_preview").removeAttr("disabled");
            },'json');
        }
    }
}

function previewFactorPrecio(){
    var c = 0;
   $(".fila").each(function(){
        var check = $(this).find(".seleccionable").is(":checked");
        if(check){
         c++;
        var FactorPrecio = parseFloat($("#factor_precio").val());
            if(isNaN(FactorPrecio)){
                alert("Ingrese un valor valido!");
                return;
            }
            $(this).find(".p_factor").html(FactorPrecio).addClass("modificado");              
        }
    });
    if(c ==0){
        alert("Debe seleccionar al menos un lote para previsualizar");
    }
}

function previewPreciosXKg(){
    var c = 0;
    $(".fila").each(function(){
        var check = $(this).find(".seleccionable").is(":checked");
        if(check){
           c++;
            var FactorPrecio = parseFloat( $(this).find(".p_factor").html());            
             
            var g = parseFloat($(this).data("gramaje"));
            var ancho = parseFloat($(this).data("ancho"));
            var long_1m = (1000) / (g * ancho);
             for(var i = 1;i <=7;i++){
                var pf = parseFloat($(this).find(".pf"+i).data("precio_final"));             
                var precio_x_kg = (pf *  long_1m * FactorPrecio).toFixed(0);
                $(this).find(".pf"+i).html(precio_x_kg).addClass("modificado"); ;
             }
        }
    });
    if(c ==0){
        alert("Debe seleccionar al menos un lote para previsualizar");
    }else{
        $("#msg_lotes").addClass("error");
        $("#msg_lotes").html("ATENCION! Mostrando precios finales en KG");
    }
    
    
}

function actualizarFactorPrecio(){
    $("span#ml_actualizarFactorMsj").empty();
    var lotes = [];
    if( $("input[type=checkbox].seleccionable:checked").length == 0 ){
        $("span#ml_actualizarFactorMsj").text("Seleccione el o los lotes a actualizar !");
    }else{ 
        var FactorPrecio = parseFloat($("#factor_precio").val());
        if(isNaN(FactorPrecio)){
            alert("Ingrese un valor valido!");
            return;
        }
        $("span#ml_actualizarFactorMsj").text("Actualizando espere!");
         
        
        $(".fila").each(function(){
        var check = $(this).find(".seleccionable").is(":checked");
        if(check){
            lotes.push($(this).find("td.lote").text());        
            $(this).find(".p_factor").html(FactorPrecio).addClass("resultado");            
        }
       });   
          
        $.post("productos/ManejoLotes.class.php",{"action":"actualizarFactorPrecio", "lotes":JSON.stringify(lotes),FactorPrecio:FactorPrecio}, function(data){
            $("span#ml_actualizarFactorMsj").text(data.msj);                
            $("input#btn_preview").removeAttr("disabled");
        },'json');
                    
    }
}


function estadoVenta(){
    var estado = $("#new_estado_venta").val();
    switch(estado){
        case "Retazo":
            var articulos = [];
            $(".codigo").each(function(){
            var articulo = $(this).text();
            if(articulos.indexOf(articulo) == -1){
                articulos.push(articulo);
            }
            });
            if(articulos.length > 1){
                $("#new_estado_venta").val("%");
                alert("No puede pasar a retazo lotes de diferentes articulos");
            }else{
                if(articulos.length == 0){
                    $("#new_estado_venta").val("%");
                }else{
                    aplicarPrecioRetazo();
                }
            }
            break;
        default:
            /* $(".botones").prop("disabled",true);
            $("input[id^=mod_val_]").val(''); */
            $("input[id^=mod_val_]").each(function(){
                checkVal($(this));
            });
        break;
    }
}

function aplicarPrecioRetazo(){
    var precioMinimoVenta = parseInt($($(".fila").get(0)).find(".p_valmin").text().replace(/\./g, ''));
    var nPrecioMinimoVenta = Math.round(precioMinimoVenta + ((precioMinimoVenta * PORC_MINIMO_RETAZO) / 100));

    console.log(precioMinimoVenta + ((precioMinimoVenta * PORC_MINIMO_RETAZO) / 100));

    $("#modificar").val('precio_final_directo');setLabels();
    $("input[id^=mod_val_]").val(nPrecioMinimoVenta);

    $("input[id^=mod_val_]").each(function(){
        checkVal($(this));
    });
}