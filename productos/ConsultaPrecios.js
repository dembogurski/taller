 var decimales = 0;
 var cant_articulos = 0;
 var fila_art = 0;

 var errores = 0;
var porc_valor_minimo = 25;


 function checkVal() {
     var err = 0;
     $(".valores").each(function() {
         if ($(this).val() == "") {
             err++;
         }
     });
     if (err > 0) {
         $(".botones").prop("disabled", true);
     } else {
         $("#preview").removeAttr("disabled");
     }
 }

 function preview() {
     var modificar = $("#modificar").val();
     $("#msg_lotes").html("<img src='img/loading_fast.gif' width='16px' height='16px'>");

     $(".modificado").removeClass("modificado");
     $(".resultado").removeClass("resultado");

     var estado_venta = $("#new_estado_venta").val();

     var selecteds = 0;

     if (modificar == "descuento_directo") {
         $(".lote").each(function() {
             var check = $(this).parent().find(".seleccionable").is(":checked");
             if (check) {
                 selecteds++;
                 for (var i = 1; i <= 7; i++) {
                     var px = parseFloat($(this).parent().find(".p" + i).text().replace(".", ""));
                     var vx = $("#mod_val_" + i).val();
                     $(this).parent().find(".d" + i).text(vx).addClass("modificado");
                     $(this).parent().find(".estado_venta").text(estado_venta);
                     $(this).parent().find(".Normal, .Oferta, .Arribos, .Promocion, .Retazo").toggleClass(estado_venta);
                     $(this).parent().find(".pf" + i).text(redondear(px - (px * vx / 100))).addClass("resultado");
                 }
             }
         });
     } else if (modificar == "precio_final_directo") {
         $(".lote").each(function() {
             $(".lote").each(function() {
                 var check = $(this).parent().find(".seleccionable").is(":checked");
                 if (check) {
                     selecteds++;
                     for (var i = 1; i <= 7; i++) {
                         var px = parseFloat($(this).parent().find(".p" + i).text().replace(".", ""));
                         var vx = $("#mod_val_" + i).val();
                         $(this).parent().find(".pf" + i).text(vx).addClass("modificado");
                         $(this).parent().find(".estado_venta").text(estado_venta);
                         $(this).parent().find(".Normal, .Oferta, .Arribos, .Promocion, .Retazo").toggleClass(estado_venta);
                         $(this).parent().find(".d" + i).text(100 - ((vx * 100) / px)).addClass("resultado");
                     }
                 }
             });
         });
     } else if (modificar == "porc_resp_costo") {
         $(".lote").each(function() {
             var check = $(this).parent().find(".seleccionable").is(":checked");
             if (check) {
                 selecteds++;
                 for (var i = 1; i <= 7; i++) {
                     var preciox = parseFloat($(this).parent().find(".p" + i).text().replace(".", ""));
                     var p_costox = parseFloat($(this).parent().find(".p_costo").text().replace(".", ""));
                     var vx = $("#mod_val_" + i).val();
                     var precio_finalx = redondear(p_costox * vx / 100);
                     $(this).parent().find(".pf" + i).text(precio_finalx).addClass("modificado");
                     $(this).parent().find(".estado_venta").text(estado_venta);
                     $(this).parent().find(".Normal, .Oferta, .Arribos, .Promocion, .Retazo").toggleClass(estado_venta);
                     $(this).parent().find(".d" + i).text(redondear(100 - ((precio_finalx * 100) / preciox))).addClass("resultado");
                 }
             }
         });
     } else if (modificar == "porc_resp_valmin") {
         $(".lote").each(function() {
             var check = $(this).parent().find(".seleccionable").is(":checked");
             if (check) {
                 selecteds++;
                 for (var i = 1; i <= 7; i++) {
                     var preciox = parseFloat($(this).parent().find(".p" + i).text().replace(".", ""));
                     var p_valmin = parseFloat($(this).parent().find(".p_valmin").text().replace(".", ""));
                     var vx = $("#mod_val_" + i).val();
                     var precio_finalx = redondear(p_valmin * vx / 100);
                     $(this).parent().find(".pf" + i).text(precio_finalx).addClass("modificado");
                     $(this).parent().find(".estado_venta").text(estado_venta);
                     $(this).parent().find(".Normal, .Oferta, .Arribos, .Promocion, .Retazo").toggleClass(estado_venta);
                     $(this).parent().find(".d" + i).text(redondear(100 - ((precio_finalx * 100) / preciox))).addClass("resultado");
                 }
             }
         });
     }

     if (selecteds < 1) {
         errorMsg("Debe seleccionar los lotes para previsualizar las modificaciones.", 15000);
     }

     $("#msg_lotes").html("");
     $("#apply").removeAttr("disabled");
 }

 function aplicar() {
     var c = confirm("Al aplicar los descuentos se generara una lista en cada sucursal para la Reimpresion de codigos de barras");
     if (c) {
         $(".botones").prop("disabled", true);
         var data = new Array();
         $("#msg_lotes").html("<span style='background-color;lightskyblue;color:white'> Espere...<img src='img/loading_fast.gif' width='16px' height='16px'></span>");
         var cont = 0;
         $(".lote").each(function() {
             var fila = $(this).parent();
             var check = fila.find(".seleccionable").is(":checked");
             if (check) {
                 fila.find(".result").html("<img class='updating' src='img/loading_fast.gif' width='16px' height='16px'>");
                 var array = new Array();
                 var codigo = fila.find(".codigo").text();
                 var lote = $(this).text();
                 var descrip = fila.find(".descrip").text();
                 var suc = fila.find(".suc").text();
                 array.push(codigo, lote, descrip, suc);
                 for (var i = 1; i <= 7; i++) {
                     var preciox = fila.find(".p" + i).text().replace(".", "");
                     array.push(preciox);
                 }
                 for (var i = 1; i <= 7; i++) {
                     var descx = fila.find(".d" + i).text();
                     array.push(descx);
                 }
                 data.push(array);
                 cont++;
             }
         });

         data = JSON.stringify(data);
         var estado_venta = $("#new_estado_venta").val();
         if (cont > 0) {
             $.ajax({
                 type: "POST",
                 url: "Ajax.class.php",
                 data: { "action": "actualizarDescuentosPorLote", data: data, estado_venta: estado_venta, usuario: getNick() },
                 async: true,
                 dataType: "json",
                 beforeSend: function() {
                     $("#msg_lotes").html("<img src='img/loading_fast.gif' width='16px' height='16px' >");
                 },
                 success: function(data) {
                     var estado = data.estado;
                     var mensaje = data.mensaje;
                     if (estado == "Ok") {
                         $("#msg_lotes").html("<span style='background-color;green;color:white'>" + mensaje + "</span>");
                         $(".updating").attr("src", "img/ok.png");
                     } else {
                         $("#msg_lotes").html("Ocurrio un error, vuelva a intentarlo o comuniquese con el Administrador.");
                         $(".updating").attr("src", "img/close.png");
                     }
                 }
             });
         } else {
             $("#msg_lotes").html("Debe marcar los lotes que desea modificar!");
             errorMsg("Debe marcar los lotes que desea modificar!", 15000);
         }
     }
 }

 function substractDays(date, days) {
     var result = new Date(date);
     result.setDate(result.getDate() - days);

     var dia = result.getDate();
     if (dia < 10) { dia = "0" + dia; }
     var mes = result.getMonth() + 1;
     if (mes < 10) { mes = "0" + mes; }
     var anio = result.getFullYear();

     var format = dia + "/" + mes + "/" + anio;
     return format;
 }

 function setEstandar() {
     var v = $("#estandar").val();
     var info = $("#estandar :selected").attr("data-desc");
     if (info != "") {
         $("#msg_info").html(info);
         $("#msg_info").fadeIn();
     } else {
         $("#msg_info").fadeOut();
     }

     var desde = "";
     var hasta = "";

     function todos() {
         $("#codigo").val("%");
         $("#descrip").val("");
         $("#codigo_proveedor").val("%");
         $("#nombre_proveedor").val("");
     }
     if (v == "") {

     } else if (v == "5x4") {
         desde = substractDays(new Date(), 365 * 5);
         hasta = substractDays(new Date(), 365 * 4);
         $(".valores").val(100);
         $("#modificar").val("porc_resp_valmin");
     } else if (v == "5x4_crucero") {
         desde = substractDays(new Date(), 365 * 5);
         hasta = substractDays(new Date(), 365 * 4);
         $(".valores").val(100);
         $("#modificar").val("porc_resp_costo");
     } else if (v == "7x5") {
         desde = substractDays(new Date(), 365 * 7);
         hasta = substractDays(new Date(), 365 * 5);
         $(".valores").val(100);
         $("#modificar").val("porc_resp_costo");
     } else { // 0x7
         desde = substractDays(new Date(), 365 * 100);
         hasta = substractDays(new Date(), 365 * 7);
         $(".valores").val(50);
         $("#modificar").val("porc_resp_costo");
     }
     todos();
     $("#desde").val(desde);
     $("#hasta").val(hasta);
 }

 function configurar() {
     setHotKeyArticulo();
     $("#filtros").on("keydown", function(e) {
         var tecla = e.keyCode;
         if (tecla == "27") {
             $("#ui_articulos").fadeOut();
             $("#ui_proveedores").fadeOut("fast");
         }
     });
     $(".fecha").mask("99/99/9999");
     for (var i = 1; i < 8; i++) {
         $("#tr_mod").append('<td> <label id="label_' + i + '">Desc' + i + ':</label></td><td><input type="text" class="num valores" id="mod_val_' + i + '" size="8" onkeypress="return onlyNumbers(event)"></td>');
     }
     var ev = $("#estado_venta").html();
     $("#tr_mod").append('<td> <label>Estado Venta:</label> <select id="new_estado_venta">' + ev + '</select> \n\
    &nbsp;<input type="button" id="preview" class="botones" value="Previsualizar" onclick="preview()" disabled="disabled">\n\
    &nbsp;<input type="button" id="apply" class="botones" value="Aplicar" onclick="aplicar()" disabled="disabled"> </td>');

     $(".valores").change(function() {
         checkVal();
     });
     $("#nombre_proveedor").blur(function() {
         if ($(this).val().length == 0) {
             $("#codigo_proveedor").val("%");
         }
     });

 }

 function setLabels() {
     var mod = $("#modificar").val();
     var label = "Desc";
     if (mod == "precio_final_directo") {
         label = "Precio";
     } else if (mod == "porc_resp_costo") {
         label = "%/Costo";
     } else if (mod == "porc_resp_valmin") {
         label = "%/Val Min";
     }
     for (var i = 1; i <= 7; i++) {
         $("#label_" + i).text(label + "" + i + ":");
     }
 }

 function selectRowArt(row) {
     $(".art_selected").removeClass("art_selected");
     $(".fila_art_" + row).addClass("art_selected");
     $(".cursor").remove();
     $($(".fila_art_" + row + " td").get(2)).append("<img class='cursor' src='img/l_arrow.png' width='18px' height='10px'>");
     escribiendo = false;
 }


 function seleccionarArticulo(obj) {
     var codigo = $(obj).find(".codigo").html();
     var sector = $(obj).find(".Sector").html();
     var nombre_com = $(obj).find(".NombreComercial").html();
     var precio = $(obj).attr("data-precio");
     var um = $(obj).attr("data-um");
     $("#codigo").val(codigo);
     $("#descrip").val(sector + "-" + nombre_com);
     $("#um").val(um);
     $("#ui_articulos").fadeOut();
     $("#precio_venta").val(precio);
     $("#precio_venta").focus();
     getColores();
 }

 function seleccionarProveedor(obj) {
     var proveedor = $(obj).find(".proveedor").html();
     //var ruc = $(obj).find(".ruc").html();  
     var codigo = $(obj).find(".codigo").html();

     //$("#ruc_proveedor").val(ruc);
     $("#nombre_proveedor").val(proveedor);
     $("#codigo_proveedor").val(codigo);

     $("#ui_proveedores").fadeOut("fast");
     $("#msg").html("");

 }

 function mostrar() {}

 function buscarArticulo() {
     var articulo = $("#descrip").val();
     var cat = 1;
     if (articulo.length > 0) {
         $.ajax({
             type: "POST",
             url: "Ajax.class.php",
             data: { "action": "buscarArticulos", "articulo": articulo, "cat": cat },
             async: true,
             dataType: "json",
             beforeSend: function() {
                 $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >");
             },
             success: function(data) {

                 if (data.length > 0) {
                     limpiarListaArticulos();
                     var k = 0;
                     for (var i in data) {
                         k++;
                         var ItemCode = data[i].codigo;
                         var Sector = data[i].sector;
                         var NombreComercial = data[i].descrip;
                         var Precio = parseFloat((data[i].precio)).format(0, 3, '.', ',');
                         var Ancho = parseFloat(data[i].ancho).format(2, 3, '.', ',');
                         var Composicion = data[i].composicion;
                         var UM = data[i].um;

                         $("#lista_articulos").append("<tr class='tr_art_data fila_art_" + i + "' data-precio=" + Precio + " data-um=" + UM + "><td class='item clicable_art'><span class='codigo' >" + ItemCode + "</span></td>\n\
                    <td class='item clicable_art'><span class='Sector'>" + Sector + "</span> \n\
                    </td><td class='item clicable_art'><span class='NombreComercial'>" + NombreComercial + "</span></td> \n\
                    <td class='num clicable_art'>" + Ancho + "</td>\n\
                    <td class='item clicable_art'>" + Composicion + "</td>\n\
                    <td class='num clicable_art'>" + Precio + "</td>\n\
                    </tr>");
                         cant_articulos = k;
                     }
                     inicializarCursores("clicable_art");
                     $("#ui_articulos").fadeIn();
                     $(".tr_art_data").click(function() {
                         seleccionarArticulo(this);
                     });
                     $("#msg").html("");
                 } else {
                     $("#msg").html("Sin resultados...");
                 }
             }
         });
     } else {
         $("#codigo").val("");
     }
 }

 function limpiarListaArticulos() {
     $(".tr_art_data").each(function() {
         $(this).remove();
     });
 }

 function cerrar() {}

 function limpiarCampos() {
     $(".fecha").val("");
     $("#codigo").val("%");
     $("#descrip").val("");
     $("#lotes").val("");
     $("#codigo_proveedor").val("%");
     $("#nombre_proveedor").val("");
 }

 function ocultar(clase) {
     $("." + clase).toggle();
 }

 function selecccionar() {
     var all = $("#select_all").is(":checked");
     if (all) {
         $(".seleccionable").prop('checked', true);
     } else {
         $(".seleccionable").removeAttr("checked");
     }
 }

 function verLotes() {
     var desde = "01/01/2000";
     var hasta = $("#hasta").val();
     var codigo = $("#codigo").val();
     var lotes = $("#lotes").val();
     var cod_prov = $("#codigo_proveedor").val();
     var estado_venta = $("#estado_venta").val();
     var fallas = $("#fallas").val();
     var buscarPor = $("select#serchParam option:selected").val();
     errores = 0;
     porc_valor_minimo = parseFloat($("#porc_val_min").val());
     
     var limite = $("#limite").val();
     
     var suc = $("#sucs").val();
     var ColorCod = $("select#filtroColores option:selected").val();;

     if (lotes == "" && codigo == "%") {
         alert("Considere seleccionar al menos un articulo o ingrese codigos de Lotes entre coma para filtrar...\nEj.: 13917,13817,14017  \nDe lo contrario el resultado puede ser muy largo");
         return;
     }

     $(".fila > td").css("background", "rgb(110,110,110)");
     $.ajax({
         type: "POST",
         url: "Ajax.class.php",
         data: { "action": "filtroManejoLotes", "desde": desde, "hasta": hasta, "cod_prov": cod_prov, "estado_venta": estado_venta, "fallas": fallas, "codigo": codigo, "lotes": lotes, "suc": suc, "limite": limite, "buscarPor": buscarPor, "ColorCod": ColorCod },
         async: true,
         dataType: "json",
         beforeSend: function() {
             $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >");
             $("#pder").slideUp();
         },
         success: function(data) {
             $(".fila").remove();
             var cant = 0;
             for (var i in data) {
                 var NroDoc = data[i].NroDoc;
                 var CardName = data[i].CardName;
                 var Fecha = data[i].Fecha;
                 var Codigo = data[i].Codigo;
                 var Articulo = data[i].Articulo;
                 var Lote = data[i].Lote;
                 var Suc = data[i].Suc;
                 var Stock = parseFloat(data[i].Stock).format(2, 3, ".", ",");
                 var Ancho = parseFloat(data[i].Ancho).format(2, 3, ".", ",");
                 //var PriceList = data[i].PriceList;  
                 var PrecioCosto = parseFloat(data[i].PrecioCosto).format(0, 3, ".", ",");
                 
                 var precio_promedio_penderado = parseFloat( data[i].PrecioCosto);
                  
                var ValorMinimo = parseFloat(precio_promedio_penderado  + ((precio_promedio_penderado * porc_valor_minimo) / 100)).format(0,3,".",",");
                 
                 
                 var Precio1 = parseFloat(data[i]["1"]).format(0, 3, ".", ",");
                 var Precio2 = parseFloat(data[i]["2"]).format(0, 3, ".", ",");
                 var Precio3 = parseFloat(data[i]["3"]).format(0, 3, ".", ",");
                 var Precio4 = parseFloat(data[i]["4"]).format(0, 3, ".", ",");
                 var Precio5 = parseFloat(data[i]["5"]).format(0, 3, ".", ",");
                 var Precio6 = parseFloat(data[i]["6"]).format(0, 3, ".", ",");
                 var Precio7 = parseFloat(data[i]["7"]).format(0, 3, ".", ",");

                 var U_desc1 = parseFloat(data[i].U_desc1).format(2, 3, 0, 0);
                 var U_desc2 = parseFloat(data[i].U_desc2).format(2, 3, 0, 0);
                 var U_desc3 = parseFloat(data[i].U_desc3).format(2, 3, 0, 0);
                 var U_desc4 = parseFloat(data[i].U_desc4).format(2, 3, 0, 0);
                 var U_desc5 = parseFloat(data[i].U_desc5).format(2, 3, 0, 0);
                 var U_desc6 = parseFloat(data[i].U_desc6).format(2, 3, 0, 0);
                 var U_desc7 = parseFloat(data[i].U_desc7).format(2, 3, 0, 0);

                 var pf1 = redondeo50(parseFloat(Math.round(data[i]["1"] - (data[i]["1"] * data[i].U_desc1) / 100)));
                 var pf2 = redondeo50(parseFloat(Math.round(data[i]["2"] - (data[i]["2"] * data[i].U_desc2) / 100)));
                 var pf3 = redondeo50(parseFloat(Math.round(data[i]["3"] - (data[i]["3"] * data[i].U_desc3) / 100)));
                 var pf4 = redondeo50(parseFloat(Math.round(data[i]["4"] - (data[i]["4"] * data[i].U_desc4) / 100)));
                 var pf5 = redondeo50(parseFloat(Math.round(data[i]["5"] - (data[i]["5"] * data[i].U_desc5) / 100)));
                 var pf6 = redondeo50(parseFloat(Math.round(data[i]["6"] - (data[i]["6"] * data[i].U_desc6) / 100)));
                 var pf7 = redondeo50(parseFloat(Math.round(data[i]["7"] - (data[i]["7"] * data[i].U_desc7) / 100)));
                 var EstadoVenta = data[i].EstadoVenta;
                 var UcolorComercial = data[i].U_color_comercial;
                 var colorComercial = data[i].ColorComercial;
                 var img = data[i].U_img;

                 var check_proveedor = $(".check_proveedor").is(":checked");
                 var check_fecha_compra = $(".check_fecha_compra").is(":checked");
                 var check_descrip = $(".check_descrip").is(":checked");

                 var hide_prov = "table-cell";
                 if (check_proveedor) {
                     hide_prov = "none";
                 }
                 var hide_fc = "table-cell";
                 if (check_fecha_compra) {
                     hide_fc = "none";
                 }
                 var hide_descrip = "table-cell";
                 if (check_descrip) {
                     hide_descrip = "none";
                 }
                 var resaltar = "";
                 if (PrecioCosto == 0) {
                     errores++;
                     resaltar = "resaltar";
                 }

                 $(".lotes").append("<tr class='fila'>\n\
                                        <td class='itemc oculto'>" + NroDoc + "</td>\n\
                                        <td class='item proveedor' style='display:" + hide_prov + "'>" + CardName + "</td>\n\
                                        <td class='itemc fecha_compra' style='display:" + hide_fc + "'>" + Fecha + "</td>\n\
                                        <td class='item codigo'>" + Codigo + "</td>\n\
                                        <td class='item descrip' style='display:" + hide_descrip + "'>" + Articulo + "</td>\n\
                                        <td class='item lote'>" + Lote + "</td>\n\
                                        <td class='item UcolorComercial'>" + UcolorComercial + "</td>\n\
                                        <td class='item colorComercial'>" + colorComercial + "</td>\n\
                                        <td class='itemc suc'>" + Suc + "</td>\n\
                                        <td class='num'>" + Stock + "</td>\n\
                                        <td class='num'>" + Ancho + "</td>\n\
                                        <td class='num p_costo " + resaltar + "'>" + PrecioCosto + "</td>\n\
                                        <td class='num p_valmin'>" + ValorMinimo + "</td>\n\
                                        <td class='num p1 oculto'>" + Precio1 + "</td>\n\
                                        <td class='num p2 oculto'>" + Precio2 + "</td>\n\
                                        <td class='num p3 oculto'>" + Precio3 + "</td>\n\
                                        <td class='num p4 oculto'>" + Precio4 + "</td>\n\
                                        <td class='num p5 oculto'>" + Precio5 + "</td>\n\
                                        <td class='num p6 oculto'>" + Precio6 + "</td>\n\
                                        <td class='num p7 oculto'>" + Precio7 + "</td>\n\
                                        <td class='num d1 oculto'>" + U_desc1 + "</td>\n\
                                        <td class='num d2 oculto'>" + U_desc2 + "</td>\n\
                                        <td class='num d3 oculto'>" + U_desc3 + "</td>\n\
                                        <td class='num d4 oculto'>" + U_desc4 + "</td>\n\
                                        <td class='num d5 oculto'>" + U_desc5 + "</td>\n\
                                        <td class='num d6 oculto'>" + U_desc6 + "</td>\n\
                                        <td class='num d7 oculto'>" + U_desc7 + "</td>\n\
                                        <td class='num pf1'>" + pf1 + "</td>\n\
                                        <td class='num pf2'>" + pf2 + "</td>\n\
                                        <td class='num pf3'>" + pf3 + "</td>\n\
                                        <td class='num pf4'>" + pf4 + "</td>\n\
                                        <td class='num pf5'>" + pf5 + "</td>\n\
                                        <td class='num pf6'>" + pf6 + "</td>\n\
                                        <td class='num pf7'>" + pf7 + "</td>\n\
                                        <td class='itemc estado_venta " + EstadoVenta + "'>" + EstadoVenta + "</td>\n\
                                        <td class='itemc'><button class='fotoLote' data-target='" + img + "' onclick='mostrarImagen($(this))'>Img</button></td>\n\</tr>");
                 cant++;
             }

             if (cant > 0) {
                 $("#msg").html("");
             } else {
                 $("#msg").html("Ningun resultado, verifique los filtros...");
             }
             if(!$(".permisos_extras").is(":visible")){
                $(".p_valmin, .p_costo").css("display","none");
             }else{
                $(".p_valmin, .p_costo").css("display","");
             }
             $("#pder").slideDown();
         }
     });
 }

 function igualarValores() {
     var mod_val_1 = $("#mod_val_1").val();
     for (var i = 2; i <= 7; i++) {
         $("#mod_val_" + i).val(mod_val_1);
     }
     checkVal();
 }

 function setHotKeyArticulo() {
     $("#descrip").keydown(function(e) {

         var tecla = e.keyCode; //console.log(tecla);  
         if (tecla == 38) {
             (fila_art == 0) ? fila_art = cant_articulos - 1: fila_art--;
             selectRowArt(fila_art);
         }
         if (tecla == 40) {
             (fila_art == cant_articulos - 1) ? fila_art = 0: fila_art++;
             selectRowArt(fila_art);
         }
         if (tecla != 38 && tecla != 40 && tecla != 13) {
             buscarArticulo();
             escribiendo = true;

         }
         if (tecla == 13) {
             if (!escribiendo) {
                 seleccionarArticulo(".fila_art_" + fila_art);
             } else {
                 setTimeout("escribiendo = false;", 1000);
             }
         }
         if (tecla == 27) {
             $("#ui_articulos").fadeOut();
         }
         if (tecla == 116) { // F5
             e.preventDefault();
         }

     });
 }

 function onlyNumbers(e) {
     //e.preventDefault();
     var tecla = new Number();
     if (window.event) {
         tecla = e.keyCode;
     } else if (e.which) {
         tecla = e.which;
     } else {
         return true;
     }
     if (tecla === "13") {
         this.select();
     }
     //console.log(e.keyCode+"  "+ e.which);
     if ((tecla >= "97") && (tecla <= "122")) {
         return false;
     }
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

 function mostrarImagen(Obj) {
     $("div.imgeContenedor").remove();
     var imTarget = Obj.attr("data-target");
     var conten = $("<div/>",{"class":"imgeContenedor"});     
     var frame = $("<div/>",{"class":"imgeFrame"});
     $("<button/>",{"text":"Cerrar","class":"cerrarImgPreview",click:function(){$("div.imgeContenedor").remove();}}).appendTo(frame);
     $.ajax({
         url: "http://192.168.2.220/marijoa_sap/json/chk.json",
         dataType: "jsonp",
         statusCode: {
             404: function() {
                 $("<img/>", { "src": "http://190.128.150.70:2252/prod_images/" + imTarget + ".jpg", "class": "previewImage", "style":"height: 100%; width: auto;"}).appendTo(frame);        
             },
             200: function() {
                 $("<img/>", { "src": "http://192.168.2.252/prod_images/" + imTarget + ".jpg", "class": "previewImage", "style":"height: 100%; width: auto;" }).appendTo(frame);
             }
         }
     });
     frame.appendTo(conten);
     $(conten).draggable();
     conten.appendTo("#work_area");     
 }