/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var fila_art = 0;
var cant_articulos = 0;
var data_next_time_flag = true;
var escribiendo = false;

var editando = false;
var editing_id_ent = 0;
var editing_id_det = 0;
 
var designs = [];
var monedas = [];

var datos_incorrectos = 0;
var colores_incorrectos = 0;
var gramajes_incorrectos = 0;
var anchos_incorrectos = 0;

var copiar_de = false;
var checked = $('input[name=radio_estado]:checked').val();
var estado = "Abierta";
var cotizacion_sap = true;
var nro_pedido_compra = 0;
var loadDesings = false;

var entrada_directa_sin_invoice = false;

var pedidos = new Array();

var precios = {};


function preconfigurar(){  
    pedidos.push("0");
    inicializarCursores("clicable");
    $(".clicable").click(function() {
        var id = $(this).parent().attr("id");
        var nro_pedido = $(this).parent().attr("data-nro_pedido");
        cargarEntrada(id);
    });
    $("#pais").val($("#pais option:nth-child(1)").val())
        //$("#pais").val("PY");
    estado = $("#estado").val();

    $("#lista_invoices").DataTable({
        "language": {
            "lengthMenu": "Mostrando _MENU_ registros por pagina",
            "zeroRecords": "Ningun registro.",
            "info": "Mostrando _PAGE_ de _PAGES_ paginas",
            "infoEmpty": "No hay registros.",
            "infoFiltered": "(filtrado entre _MAX_ registros)",
            "sSearch": "Buscar",
            "oPaginate": {
                "sFirst": "Primero",
                "sLast": "�ltimo",
                "sNext": "Siguiente",
                "sPrevious": "Anterior"
            },
        }
    });   
     
}

function configurarEntradaMercaderias() {
   
    //$( "#fecha" ).datepicker({ dateFormat: 'dd-mm-yy' }   ); 
    $("#fecha").mask("99-99-9999");

    $("select > option:nth-child(even)").css("background", "#F0F0F5"); // Color Zebra para los Selects  
    $(".check").change(function() {
        var v = $(this).val();
        if (v.length < 1) {
            $(this).addClass("input_err");
        } else {
            $(this).removeClass("input_err");
        }
        checkform();
        if ($(this).attr("id") == "fecha") {
            //controlarCotizacion();
        }
    });

    //$("#pais").val( $("#pais option:nth-child(1)").val())
    $("#pais").val("PY");
     
    
    $("#tipo_doc_sap").change(function() {
        var tipo = $(this).val();
        if (tipo == "OPDN") {
            $("#button_entrada_directa").fadeIn();
            $("#proveedor").val("Internacional");
            $("#pais").val("CN");
        } else {
            $("#button_entrada_directa").fadeOut();
            $("#proveedor").val("Nacional");
            $("#pais").val("PY");
        }
        
    });
    $("#subtotal").change(function() {
        var subt = $(this).val();
        var cant = $("#cantidad").val();
        var precio_dec = subt / cant;
        $("#subtotal").val(parseFloat(precio_dec).format(4, 3, '.', ','));
    });
    $("#cotiz").change(function() {

        var cot = $("#cotiz").val().replace(/\./g, ',');

        if (isNaN(parseFloat(cot))) {
            cot = 1;
        }
        $("#cotiz").val(cot);
    });
    $("*[data-next]").keyup(function (e) {
        
        if (e.keyCode == 13) { 
            if(data_next_time_flag){
               data_next_time_flag = false;    
               var next =  $(this).attr("data-next"); console.log(next);
               $("#"+next).focus();               
               setTimeout("setDefaultDataNextFlag()",400);
            }
        } 
    });      
    setHotKeyArticulo();   
    checkRows();
    $("#nombre_proveedor").focus();
}

function cambiarEstado(estado) {
    if (checked != estado) {
        load("compras/EntradaMercaderias.class.php?estado=" + estado, { usuario: getNick(), session: (getCookie(getNick()).sesion), suc: getSuc() }, function() {
            preconfigurar();
        });
        checked = estado;
    }
}

function nuevaEntradaMercaderias() {
    
    var ses = getCookie(getNick()).sesion;
    //load("compras/NuevaEntradaMercaderias.class.php", { usuario: getNick(), session: ses, suc: getSuc() }); 
        
        //setTimeout("configurarEntradaMercaderias()",800);
    //});
    
    $.ajax({
            type: "POST",
            url: "compras/NuevaEntradaMercaderias.class.php",
            data: {usuario: getNick(), session: ses, suc: getSuc()},
            async:true,
            dataType: "html",
            beforeSend: function(objeto){ 
                  
                $("#work_area").html("<img id='loading' src='img/loading.gif'>");
            },
            complete: function(objeto, exito){
                if(exito==="success"){  
                    $("#work_area").html(objeto.responseText  );  
                     
                    configurarEntradaMercaderias();
                    
                }
            }
        }); 
}

function crearEntrada() {
    $("#boton_generar").attr("disabled", true);
    var cod_prov = $("#codigo_proveedor").val();
    var nombre = $("#nombre_proveedor").val();
    var invoice = $("#invoice").val();
    var fecha = validDate($("#fecha").val()).fecha;
    var moneda = $("#moneda").val();
    var cotiz = $("#cotiz").val();
    var suc = $("#suc").val();
    var pais_origen = $("#pais").val();
    var tipo = $("#tipo_doc_sap").val();
    var timbrado = $("#timbrado").val();
    if (tipo == "OPCH" && timbrado == "") {
        $("#timbrado").focus();
        errorMsg("Timbrado no puede ser vacio para tipo documento Factura de Proveedor", 8000);
        return;
    }
    if (pedidos.length == 0) {
        pedidos.push($("#n_nro").val());
    }
    var nros_pedidos = JSON.stringify(pedidos);


    if (moneda != "G$" && cotiz == 1) {
        errorMsg("Cotizacion para " + moneda + " no puede ser 1", 8000);
        $("#cotiz").focus();
    } else {
        $.ajax({
            type: "POST",
            url: "compras/EntradaMercaderias.class.php",
            data: { "action": "crearEntradaMercaderias", usuario: getNick(), suc: suc, cod_prov: cod_prov, nombre: nombre, invoice: invoice, fecha: fecha, moneda: moneda, cotiz: cotiz, pais_origen: pais_origen, tipo: tipo, pedidos: nros_pedidos, timbrado: timbrado },
            async: true,
            dataType: "html",
            beforeSend: function() {
                $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >");
            },
            complete: function(objeto, exito) {
                if (exito == "success") {
                    var result = $.trim(objeto.responseText);
                    $("#ref").val(result);
                    $("#msg").html("");
                    desabilitarInputs();  
                     
                    mostrarAreaCarga();
                    
                }
            },
            error: function() {
                $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
            }
        });
    }
}

function cargarEntrada(id_ent) {
    var usuario = getNick();
    var session = getCookie(usuario).sesion;
    load("compras/CargarEntradaMercaderias.class.php", { usuario: usuario, session: session, id_ent: id_ent, nro_pedido: 0 },  mostrarAreaCarga   );
}

function mostrarAreaCarga() {  
    
    estado = $("#estado").val();  
    if ($("#estado").val() == "Abierta") {
        $("#area_carga").fadeIn("fast", function() {
            $("#codigo").focus();
            setHotKeyArticulo();
            $("#area_carga").fadeIn();
            configAreaCarga();
        });
    } else {
        $("div#area_carga input[type=text]").attr("readonly", true);
        $(".control").fadeOut();
        $("#inv_obs").attr("readonly", true);
        if(estado == "Recibida"){
            $("#estado").click(function(){
                $(".back_invoice").fadeIn();
            }); 
        }
    }
    //configAreaCarga();
    cargarDetalleEntrada($("#ref").val());
}
function volverAAbrirFactura(){
    var ref = $("#ref").val();
    $.ajax({
        type: "POST",
        url: "compras/EntradaMercaderias.class.php",
        data: {"action": "cambiarEstado", "ref": ref, "estado": "Abierta"},
        async: true,
        dataType: "html",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        complete: function (objeto, exito) {
            if (exito == "success") {                          
                var result = $.trim(objeto.responseText);            
                if(result == "Ok"){
                    alert("Se ha cambiado el estado con exito!");
                    showMenu();
                }else{
                    $("#msg").html("Ocurrio un error en la comunicacion con el Servidor..."+ result);
                }                
            }
        },
        error: function () {
            $("#msg").html("Ocurrio un error en la comunicacion con el Servidor... " );
        }
    }); 
}

function configAreaCarga() {
    $(".numero").change(function() {
        var v = $(this).val();
        console.log(v);
        var vf = parseFloat(v).format(2, 3, '.', ',');
        console.log(vf);
        $(this).val(vf);
    });

    $(".requerido").blur(function() {
        var v = $(this).val();
        if (v.length < 1) {
            $(this).addClass("input_err");
        } else {
            $(this).removeClass("input_err");
        }
        controlarDatos();
    });
    
    $("#ch_articulo").autocomplete({
      source: function(request, response) {

        $.ajax({
          type: 'get',
          url: 'compras/Descarga.class.php?action=buscarArticulos',
          data: { articulo: request.term },
          dataType: "json",
          minLength: 3,
          beforeSend: function() {            
            $(".loading_articulo").fadeIn();            
          },
          success: function(data){                                
               response($.map(data, function(item) {                 
                 return {
                     label: item.ItemName,
                     value: item.ItemCode
                 };
               }));
               $(".loading_articulo").fadeOut();            
          } 
         
       });       
     },
     select: function(event,ui){ 
        setTimeout(function(){$("#ch_articulo").val(ui.item.label);},600);         
        $("#ch_articulo").attr("data-codigo",ui.item.value);
     } 
    });         
}

function buscarImagenPantoneColorLiso(){
      var codigo = $("#codigo").val();
      var color = $("#color").val();
      $.ajax({
            type: "POST",
            url: "compras/EntradaMercaderias.class.php",
            data: { "action": "getImageColorPantoneLiso","codigo":codigo,"color":color },
            async: true,
            dataType: "json",
            beforeSend: function() {
                $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            },
            success: function(data) {
                
                var color = data.color;                
                $("#img").val(color);
                if(data.thumnail != ""){
                   $("#td_img").html("<img src='"+data.thumnail+"' width='106'>" );   
                }else{
                    $("#td_img").html("");   
                }                 
                
                $("#msg").html("");
            }
        });    
}
function controlarDatos() {
    datos_incorrectos = 0;
    $(".requerido").each(function() {
        var v = $(this).val();
        if (v.length < 1) {
            datos_incorrectos++;
            //errorMsg("Hay campos requeridos...", 4000);
        }
         
    });
    $(".numero").each(function() {
        /*var v = $(this).val();
        var id = $(this).attr("id");
        if (isNaN(v)) {
            v = parseFloat($(this).val().replace(".", "").replace(",", "."));
        }
        if (isNaN(v) || v <= 0) {
            datos_incorrectos++;
            errorMsg("Hay numeros incorrectos..." + id, 4000);
        }*/
    });
    if (datos_incorrectos > 0) {
        $("#add_code").attr("disabled", true);
        $("#update").attr("disabled", true);
        if (datos_incorrectos > 0 && datos_incorrectos < 2) {
            errorMsg("Debe rellenar todos los campos.", 6000);
        }
    } else {
        $("#add_code").removeAttr("disabled");
        $("#update").removeAttr("disabled");
    }
    var cant = $("#cantidad").val();
    if (isNaN(cant)) {
        $("#cantidad").focus();  
    } else {
        $("#add_code").focus();
    }
    var precio = parseFloat($("#precio").val().replace(".", "").replace(",", "."));
    var cantidad = parseFloat($("#cantidad").val().replace(".", "").replace(",", "."));
    var subtotal = parseFloat(precio * cantidad).format(2, 3, '.', ',')  ;   
    if(isNaN(precio * cantidad)){
        subtotal = "";
    }
    $("#subtotal").val(subtotal);
    
}

function limpiarAreaCarga() {
    $(".requerido").val("");
    $("#img").val("");
    $("#piezas").val("0");
}

function addCode() {
    $("#add_code").attr("disabled", true);
    $("#finalizar").attr("disabled", true);
    var ref = $("#ref").val();
    var tipo = $("#tipo_doc_sap").val();
    
    var codigo = $("#codigo").val();
    var um_art = $("#um").val();
    var descrip = $("#descrip").val();
    
    
    var umc = $("#umc").val();
    
    var precio    = parseFloat($("#precio").val().replace(".", "").replace(",", "."));
    var cantidad  = parseFloat($("#cantidad").val().replace(".", "").replace(",", ".")) ;
    var subtotal  = parseFloat($("#subtotal").val().replace(".", "").replace(",", ".")) ; 
     
    
    var entrada_directa = false;
    if(tipo == "OIGN"){
        entrada_directa = true;
    }

    $.ajax({
        type: "POST",
        url: "compras/EntradaMercaderias.class.php",
        data: {
            "action": "agregarDetalleEntrada",
            ref: ref,            
            codigo: codigo,
            um_art: um_art,
            descrip: descrip, 
            umc: umc, 
            cantidad : cantidad,
            precio: precio,
            subtotal:subtotal,
            entrada_directa:entrada_directa,            
            usuario:getNick()
        },
        async: false,
        dataType: "json",
        beforeSend: function() {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >");
        },
        success: function(data) {
            for (var i in data) {
                var id_ent = data[i].id_ent;
                var id_det = data[i].id_det; 
                var codigo = data[i].codigo;
                var lote = data[i].lote;
                var descrip = data[i].descrip;
                var um = data[i].um;                
                var precio = data[i].precio;
                var cantidad = data[i].cantidad;
                var subtotal = data[i].subtotal; 
                var cant_calc = data[i].cant_calc;
                var um_prod = data[i].um_prod;
                 

                $("#detalle_entrada").append('<tr id="tr_' + id_ent + '_' + id_det + '" class="fila_ent ' + um + '"  > \n\
                <td class="item">' + codigo + '</td>\n\
                <td class="item">' + descrip + '</td> \n\
                <td class="itemc">' + um + '</td>\n\
                <td class="num">' + cantidad + '</td>\n\
                <td class="num">' + precio + '</td>\n\
                <td class="num subtotal">' + subtotal + '</td>\n\
                <td class="itemc">' + um_prod + '</td>\n\
                <td class="num">' + cant_calc + '</td>\n\
                <td class="itemc"><img class="del_det trash" title="Borrar Esta Pieza" style="cursor:pointer" src="img/trash_mini.png" onclick=delDet("' + id_ent + '_' + id_det + '");></td></tr>');
            }
            $("#msg").html("");
            limpiarAreaCarga();  
            totalizar();
            //$("#generar_lotes").removeAttr("disabled");
        }
    });

}
 
function cargarDetalleEntrada(id_ent) {  
    $("#detalle_entrada tbody").empty();
    $.ajax({
        type: "POST",
        url: "compras/EntradaMercaderias.class.php",
        data: { "action": "getDetalleEntradaMercaderias", id_ent: id_ent },
        async: true,
        dataType: "json",
        beforeSend: function() {
            $("#msg").html("Cargando Detalle. <img src='img/loading_fast.gif' width='16px' height='16px' >");
        },
        success: function(data) {
            for (var i in data) {
                var id_ent = data[i].id_ent;
                var id_det = data[i].id_det; 
                var codigo = data[i].codigo;
                var lote = data[i].lote;
                var descrip = data[i].descrip;
                var um = data[i].um;                
                var precio = data[i].precio;
                var cantidad = data[i].cantidad;
                var subtotal = data[i].subtotal; 
                var cant_calc = data[i].cant_calc;
                var um_prod = data[i].um_prod;
                var haveObs = '';
                var Obs = stringify(data[i].obs);
                
                var ult_td = '<td class="itemc"></td>';
                if(estado == "Recibida" || estado == "Cerrada"){                    
                    if (Obs.length > 0) {
                       haveObs = "<img title='"+Obs+"' src='img/warning_yellow_16.png' width='14px' height='14px' >"
                    }
                    ult_td = "<td class='itemc observ' id='obs_" + id_det + "' onclick='showObs(" + id_det + ")' style='cursor:pointer' data-obs='" + Obs + "' >" + haveObs + "</td>";
                }else{
                    if(estado == "Abierta" && Obs.length > 0){
                       haveObs = "<img title='"+Obs+"' src='img/warning_yellow_16.png' width='14px' height='14px' >" 
                       ult_td = '<td class="itemc"><img class="del_det trash" title="Borrar Esta Pieza" style="cursor:pointer" src="img/trash_mini.png" onclick=delDet("' + id_ent + '_' + id_det + '");>&nbsp;' + haveObs + '</td>';
                    }else{
                       ult_td = '<td class="itemc"><img class="del_det trash" title="Borrar Esta Pieza" style="cursor:pointer" src="img/trash_mini.png" onclick=delDet("' + id_ent + '_' + id_det + '");></td>';    
                    }
                    
                }
                
                $("#detalle_entrada").append('<tr id="tr_' + id_ent + '_' + id_det + '" class="fila_ent ' + um + '"  > \n\
                <td class="item">' + codigo + '</td>\n\
                <td class="item">' + descrip + '</td> \n\
                <td class="itemc">' + um + '</td>\n\
                <td class="num">' + cantidad + '</td>\n\
                <td class="num">' + precio + '</td>\n\
                <td class="num subtotal">' + subtotal + '</td>\n\
                <td class="itemc">' + um_prod + '</td>\n\
                <td class="num">' + cant_calc + '</td>\n\
                    '+ ult_td +' </tr>');
            }
            $("#msg").html("");
            getGastos();
           
            
            if(estado == "Cerrada"){
               $("#finalizar").attr("disabled",true);
               $("#finalizar").fadeOut();
            }else{
                checkRows();
            }
            if(estado !== "Abierta" && estado !== "Cerrada"){
                $("#alerta_gastos").fadeIn(5000);
            }
            $("#bale").focus();
        }
    });
}

function checkRows(){
    if($(".fila_ent").length > 0){
        $("#finalizar").removeAttr("disabled");
        $("#finalizar").fadeIn("disabled");
    }else{
        $("#finalizar").attr("disabled",true);
    }
}

function sinFoto(){
    $("#img").val("0/0");
} 
function ocultar(i) {
    $("#fila_detalle_" + i).slideUp();
} 
function totalizar() {
    var subtotal = 0;
    var cotiz_factura = parseFloat($("#cotiz").val());
    $(".subtotal").each(function() {
        var v = parseFloat($(this).text());
        subtotal += v;
    });

    $("#total_entrada").val(parseFloat(subtotal).format(2, 3, '.', ','));
    
    var total_ref = parseFloat(subtotal * cotiz_factura);
    
    $("#total_entrada_ref").val(parseFloat(subtotal * cotiz_factura).format(0, 3, '.', ','));
 
    var gastos = 0;
    $(".gasto").each(function() {
        var g = parseFloat($(this).val().replace(/\./g,""));
        gastos += g;
    });

    var porc_recargo = (gastos * 100 / total_ref).toFixed(4);
    
    $("#porc_recargo").val(porc_recargo+"%");

    var total_gastos = (subtotal * cotiz_factura) + gastos ;
    var total_formated = (total_gastos).format(0, 3, '.', ',');
    var gastos_formated = (gastos).format(0, 3, '.', ',');
    $("#total_gastos").val(gastos_formated);
    $("#mercaderias_gastos").val(total_formated);
    if(total_ref > 0){
        $("#finalizar").removeAttr("disabled");
    }else{
        $("#finalizar").prop("disabled",true);
    }

}
function showObs(AbsEntry) {
    var estado = $("#estado").val();
    if (estado !== "En_Transito") {
        $("#observ").attr("disabled", true);
    } else {
        $("#observ").removeAttr("disabled");
    }
    actual_AbsEntry = AbsEntry;

    $(".tmp_obs").removeClass("tmp_obs");

    var ref = $("#ref").val();

    var p = $("#tr_" +ref+"_"+ AbsEntry);

    var h = $("#tr_" +ref+"_"+ AbsEntry).height();
    var tr = p.position();
    

    var obs = $("#obs_" + AbsEntry).attr("data-obs");
    $("#obs_" + AbsEntry).addClass("tmp_obs");
    $("#obs").slideDown("slow");
    $("#observ").val($.trim(obs));
    $('#obs').animate({ top: tr.top + h  + "px" }, { queue: false, duration: 150 });
}
function getGastos() {
     
    var ref = $("#ref").val();
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: { "action": "getGastosEntradaMerc", ref: ref },
        async: true,
        dataType: "json",
        beforeSend: function() {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >");
            $(".row_gasto").remove();
        },
        success: function(data) {
            var total = 0;
            var gastos = 0;
            var cotiz_factura = parseFloat($("#cotiz").val());
             
            for (var i in data) { 
                 
                var cod_gasto = data[i].cod_gasto;
                var nombre_gasto = data[i].nombre_gasto;
                var valor = parseFloat(data[i].valor);
                var moneda = data[i].moneda;
                var cotiz = parseFloat(data[i].cotiz);
                var valor_ref = parseFloat(data[i].valor_ref);
                var valor_ref_f = (valor_ref).format(0, 3, '.', ',');
                var requerido = parseInt(data[i].req);
                
                var req = "";
                if(requerido > 0){
                     req = "*";
                }
                
                var visible = 'style="display:none"';
                var fila_0 = ' cero';
                if(valor > 0){
                    visible = ""; 
                    fila_0 = "";
                }
                
                  
                var select = "<select class='gmonedas_"+cod_gasto+"'>"; 
                monedas.forEach(function(e){ 
                    var selected = "";
                    if(e === moneda){
                        selected = 'selected="selected"';   
                    }
                    select+="<option value='"+e+"' "+selected+">"+e+"</option>";
                });
                select+="</select>";   
                
                gastos += valor_ref;
                total += valor_ref;
                $("#expenses").append("<tr class='row_gasto "+fila_0+"' "+visible+" >\n\
                <td style='width:42%' class='item'> " + nombre_gasto + "</td> <td style='text-align:center'>"+req+"<input class='num tipo_gasto valor_" + cod_gasto + "' id='id_gasto_" + cod_gasto + "' onchange='guardarGasto(" + cod_gasto + ")' type='text' value='" + valor + "'   size='12'></td>\n\
                <td> "+select+"  </td>\n\
                <td style='text-align:center'><input class='num cotiz_"+ cod_gasto + " g_cotiz' id='cotiz_" + cod_gasto + "' onchange='guardarGasto(" + cod_gasto + ")' type='text' value='" + cotiz + "'   size='6'></td> \n\
                <td style='width:3%;text-align:center'  ><input class='gasto num valor_ref_"+ cod_gasto + "' id='valor_ref_" + cod_gasto + "' onchange='guardarGasto(" + cod_gasto + ")' type='text' readonly='readonly' value='" + valor_ref_f + "'   size='16'> </td>   \n\   \n\
                <td><span id='sp_" + cod_gasto + "'></span></td><tr>");
            }
            var total_entrada = parseFloat( $("#total_entrada").val(    ))  * cotiz_factura ;
            var impuesto = total_entrada * 10 / 100;

            
            total += total_entrada ;
            var gastos_formated = (gastos).format(2, 3, '.', ',');
            var total_formated = (total).format(2, 3, '.', ',');
            var impuesto_formated = (impuesto).format(2, 3, '.', ','); 

            $("#expenses").append("<tr class='row_gasto' ><td> <b>Total Gastos:</b></td><td></td><td></td><td></td> <td style='width:3%;text-align:center' ><input id='total_gastos' type='text' readonly='readonly' value='" + gastos_formated + "' style='text-align:right;margin-right:1px;font-weight:bolder' size='16' ><div style='width:140px'></div></td><tr>");
            $("#expenses").append("<tr class='row_gasto' ><td> <b>Porcentaje Recargo:</b></td><td></td><td></td><td></td> <td style='width:3%;text-align:center' ><input id='porc_recargo' type='text' readonly='readonly' value='' style='text-align:right;margin-right:1px;font-weight:bolder' size='16' ><div style='width:140px'></div></td><tr>");            
            $("#expenses").append("<tr class='row_gasto'><td> <b>Total Mercaderias + Gastos:</b></td><td>.</td><td  style='text-align:center'> <img id='mas_menos' src='img/button-add_blue.png' style='cursor:pointer;height:24px' onclick='masGastos()' > </td><td>.</td><td style='width:3%;text-align:center' ><input id='mercaderias_gastos'  type='text' readonly='readonly' value='" + total_formated + "' style='text-align:right;margin-right:1px;font-weight:bolder' size='16' ><div style='width:140px'></div></td><tr>");
            totalizar();
            if(estado == "Cerrada"){
                $("#expenses select").prop("disabled",true);
                $("#expenses .tipo_gasto").prop("readonly",true);
                $("#expenses .g_cotiz").prop("readonly",true);
                $("#mas_menos").remove();
            }
            $("#msg").html("");
            if (estado == "Abierta") {
                //controlarCotizacion();
            } else {
                $("div#area_ara input[type=text]").attr("readonly", true);
            }
        }
    });
}
function masGastos(){
    var src = $("#mas_menos").attr("src");
    if(src == "img/button-add_blue.png"){
        $("#mas_menos").attr("src","img/button_minus_blue.png"); 
        $(".cero").slideDown();
    }else{
        $("#mas_menos").attr("src","img/button-add_blue.png");
        $(".cero").slideUp();        
    }
}
 
function controlarDatosServer() {
    var filas = $(".fila_ent").length;
    if (filas > 0) {
        var id_ent = $("#ref").val();
        $.ajax({
            type: "POST",
            url: "Ajax.class.php",
            data: { "action": "verificarDatosEntradaMercaderia", id_ent: id_ent },
            async: true,
            dataType: "json",
            beforeSend: function() {
                $("#msg_bottom").removeClass("error");
                $("#msg_bottom").addClass("info");
                $("#msg_bottom").html("<img src='img/loading_fast.gif' width='16px' height='16px' >");
                $(".input_err").removeClass("input_err");
            },
            success: function(data) {
               
                var cant_errores = 0;
                var all_errors = "";
                var primero = 0;
                 if(data.length > 0){
                    for (var i in data) {
                        var arreglo = data[i];
                        var id_det = arreglo.id_det;
                        var errores = arreglo.errores;
                        var clase = arreglo.clase;
                        all_errors+=errores+"<br>";
                        if (i == 0) {
                            primero = id_det;
                        }
                        $("#tr_" + id_ent + "_" + id_det).find("." + clase).addClass("input_err");
                        cant_errores++;
                        
                    }
                    if (cant_errores > 0) {
                        $("#msg_bottom").addClass("error");
                        $("#msg_bottom").html("<img src='img/warning_red_16.png' width='16px' height='16px' > Debe corregir los errores antes de generar los lotes...<br>"+all_errors);
                        var top = $("#tr_" + id_ent + "_" + primero).position().top;
                        scrollWindows(top - 50);
                        errorMsg("Existen datos incorrectos favor corregir antes de Generar los Lotes.", 20000);
                         
                         
                    } else {
                        generarLotes();          
                        $("#msg_bottom").html("");
                    }
                    
                }else{
                    $("#msg_bottom").html("");
                    generarLotes();
                }   
           } 
        });
    } else {
        errorMsg("Debe cargar al menos un articulo para poder cargar.", 8000);
    }

}

function controlarCotizacion() {
    var moneda = $("#moneda").val();
    if (moneda != "G$") {
        $(".cotizacion").fadeIn();
        var fecha = validDate($("#fecha").val()).fecha;
        if (fecha != "NaN-NaN-NaN") {
            $.post("Ajax.class.php", { action: "getCotizacionContable", moneda: moneda, fecha: fecha,suc:getSuc() }, function(data) {
                var estado = data.estado;
                var mensaje = data.mensaje;
                if (estado == "Ok") {
                    var cotiz = parseFloat(data.venta).format(0, 6, '.', ',');      
                    $("#cotiz").val(cotiz);
                    
                    $("#cotiz").attr("title","Fecha de cotizacion: "+data.fecha)
                    
                    cotizacion_sap = true;
                    //$("#moneda").css("border", "solid gray 1px");
                } else {
                    errorMsg("No hay cotizacion para: "+moneda+" y Fecha: "+fecha+" puede hacerlo en Menu: Administracion --> Finanzas --> Cotizaciones Contables", 30000);
                    //cotizacion_sap = false;
                    //$("#moneda").css("border", "solid red 1px");
                }

            }, 'json');
        }else{
            errorMsg("Debe cargar una fecha valida",8000);
        }
    }else{
        $(".cotizacion").fadeOut();
    }
}

function guardarGasto(cod_gasto) {
    var id_ent = $("#ref").val();
    var valor = parseFloat($(".valor_"+ cod_gasto).val());
    var cotiz = parseFloat($(".cotiz_"+ cod_gasto).val());
    var moneda = $(".gmonedas_"+ cod_gasto).val();
    var valor_ref = valor * cotiz;
    var valor_ref_formated = (valor_ref).format(0, 3, '.', ',');
    $(".valor_ref_" + cod_gasto).val(valor_ref_formated);
        
    $("#sp_" + cod_gasto).html("<img src='img/loading_fast.gif' width='16px' height='16px' >");
    $.post("Ajax.class.php", { action: "guardarGastoEntradaMerc", id_ent: id_ent, cod_gasto: cod_gasto, valor: valor,moneda:moneda,cotiz:cotiz }, function(data) {
        $("#sp_" + cod_gasto).html("<img src='img/ok.png' width='16px' height='16px' >");
        $("#porc_recargo").val(data);
        totalizar();
    });
}

 
function verPrecios(){
    var info = precios[$("#codigo").val()];
    $("#div_precios").html(info);
    $("#div_precios").slideDown();
    $("#div_precios").click(function(){
        $(this).slideUp();
    });
}

 function buscarPrecios(codigo){  //url: "compras/EntradaMercaderias.class.php",
    $.post( "compras/EntradaMercaderias.class.php",{ action: "getPreciosArticulo",codigo:codigo}, function( data ) {
        var precios_codigo = "";
         
        for(var i in data){ // Solo Necesito el 1 ahora  num ,moneda,um,precio
           var num = data[i].num;  
           var moneda = data[i].moneda;  
           var um = data[i].um;  
           var dec = 0;
           
           if(moneda === "U$"){  
               dec = 2;
           }
           var mon_ = moneda.replace("$","s");
           var p = parseFloat(data[i].precio).format(dec, 3, '.', ','); 
           precios_codigo+="<div class='"+mon_+"_"+um+"' > Precio "+num+"  -  "+moneda+"  -  "+um+"  : "+p+"</div>";                     
        }      
        precios[codigo] = precios_codigo;  
   },'json');      
 }
 
function setUm() {
    var umc = $("#umc").val();
    if (umc == "Unid") {
        $(".umgroup").fadeOut();
        $(".umgroup").val(1);
    } else {
        $(".umgroup").fadeIn();
        $(".umgroup").val("");
    }
}

function showContextMenu() {
    if (editando) {
        $("#cantidades").attr("rows", 1);
    } else {
        $("#cantidades").attr("rows", 10);
    }
    var precio = parseFloat($("#precio").val().replace(".", "").replace(",", "."));
    if (!isNaN(precio) && precio > 0) {
        $(".tmp_row").remove();
        $("#edit_bale").slideDown("slow");
        var off = $("#piezas").offset();
        var h = $("#piezas").height();
        $('#edit_bale').offset({ top: off.top + h + 2, left: off.left });
        $("#precio").removeClass("input_err");
        $("#cantidades").focus();
    } else {
        errorMsg("Debe ingresar primero el precio.", 6000);
        $("#precio").addClass("input_err").focus();
    }
}

function eliminarSeleccionados(){
    var id_ent = $("#ref").val();
    var ids = [];
    $('html, body').css("cursor", "wait");
    $("tr[id^='tr_'].selected").each(function() {
        var id_det = $(this).attr("id").split('_')[2];
        ids.push(id_det);
    });
    $.post("Ajax.class.php", { "action": "eliminarSeleccionados", usuario:getNick(), "id_ent": id_ent, "ids": JSON.stringify(ids)},function(data){
        if(parseInt(data.eliminados) !== ids.length){
            alert("Se eliminaron "+parseInt(data.eliminados)+" de "+ids.length+" seleccionados.\n Berifique!")
        }
        ids.forEach(function(id,i){
           $("tr#tr_"+id_ent+"_"+id).remove();
        });
        $('html, body').css("cursor", "auto");
    },"json")
    .error(function() {
        alert("Ocurrio un error al comunicar con el Servidor");
        $('html, body').css("cursor", "auto");
    });;
    
}
// Actualizar Datos
function cambiarValoresEntMercaderia() {
    // New
    var entMercUpdate = {};
    if ($("[id^='ch_'].error").length > 0) {
        alert("Existen campos con datos No Permitidos");
    } else {
        $("input.changes:checked").closest("tr").find("[id^='ch_']").each(function() {
            var row = $(this).prop("id").substr(3, $(this).prop("id").length - 1);
            var text = '';
            var value = '';

            text = $(this).val();
            value = $(this).data("Code");

            if (text.trim() !== '' && text !== undefined) {
                switch (row) {
                    case 'color':
                        entMercUpdate[row] = text;
                        entMercUpdate['cod_pantone'] = value;
                        break;
                    case 'codFab':
                        entMercUpdate['cod_catalogo'] = text.split('-')[0];
                        entMercUpdate['fab_color_cod'] = text.split('-')[1];
                        break;
                     case 'articulo':
                        entMercUpdate['codigo'] = $("#ch_articulo").attr("data-codigo");
                        entMercUpdate['descrip'] = text;
                        break;    
                    default:
                        entMercUpdate[row] = text;

                }
            }
        });
    }
    if (Object.keys(entMercUpdate).length > 0) {
        $('html, body').css("cursor", "wait");
        var selectedColorCod = $("#ch_color").data("Code");
        var selectedColorName = $("#ch_color").val();
        var id_ent = $("#ref").val();
        var ids = [];
        $("tr[id^='tr_'].selected").each(function() {
            var id_det = $(this).attr("id").split('_')[2];
            ids.push(id_det);
        });

        $.post("Ajax.class.php", { "action": "cambiarValoresEntMercaderia", "Code": selectedColorCod, "Name": selectedColorName, "id_ent": id_ent, "ids": JSON.stringify(ids), "entMercUpdate": JSON.stringify(entMercUpdate) },
            function(data) {
                cerrarToolBox();
                cargarDetalleEntrada(id_ent);
                var msj = ""
                $.each(data, function(key, value) {
                    msj += value + "\r\n";
                });
                $('html, body').css("cursor", "auto");
                $("tr[id^='tr_'].selected").each(function() {
                    $(this).find("td.color").text(selectedColorName);
                });
                alert(msj);
            }, "json").error(function() {
            alert("Ocurrio un error al comunicar con el Servidor");
            $('html, body').css("cursor", "auto");
        });
    }
}
  

function puntoXComa(){
    if($("#dotbycomma").is(":checked")){
      var v = $("#cantidades").val().replace(/\,/g, '.');  
      $("#cantidades").val(v);
    }else{
      var v =  $("#cantidades").val().replace(/\./g, ',');   
      $("#cantidades").val(v);
    }   
}

//END Toolbox

function actualizarCantidades(indicador) { // 1 replace 0 no replace
    var counter = 0;
    var qtys = $.trim($("#cantidades").val()).split("\n");
    if (editando) {
        $("#cantidades").val(qtys[0]);
        qtys = $.trim($("#cantidades").val()).split("\n");
    }
    var precio = $("#precio").val()
    if (indicador == 1) {
        precio = $("#precio").val().replace(",", ".");
    } else {
        precio = $("#precio").val().replace(".", "").replace(",", ".");
    }

    if (isNaN(precio)) {
        errorMsg("Ingrese el precio de costo de este Articulo", 10000);
    }
    $("#precio").val(parseFloat(precio).format(3, 3, '.', ','));
    var sub_total = 0;
    var total_um = 0;
    $.each(qtys, function(k) {
        var cant = parseFloat(qtys[k]);
        var costo = precio * cant;
        sub_total += costo;
        total_um += cant * 1;
        counter++
    });
    if (!isNaN(sub_total) || !isNaN(total_um)) {
        $("#subtotal").val(parseFloat(sub_total).format(2, 3, '.', ','));
        $("#cantidad").val(parseFloat(total_um).format(2, 3, '.', ','));
        $("#piezas").val(counter);
    } else {
        $("#subtotal").val("");
        $("#cantidad").val("");
        $("#piezas").val("0");
    }
}

function closeCantPopup() {
    $("#edit_bale").slideUp("fast");
}

function cancelarUpdate() {
    $(".insert").fadeIn();
    $(".edit").fadeOut();
    editando = false;
}

function delDet(tr_id) {
    if ($("input#estado").val() == "Abierta" ) {
        var c = confirm("Confirma que desea eliminar este registro?");
        if (c) {
            var id_ent = tr_id.split("_")[0];
            var id_det = tr_id.split("_")[1];
            $.post("Ajax.class.php", { action: "borrarDetalleEntradaMercaderia", id_ent: id_ent, id_det: id_det }, function(data) {
                $("#tr_" + tr_id).remove();
                cancelarUpdate();
                limpiarAreaCarga();
                totalizar();
            });
        }
    } else {
        alert("La compra no esta Abierta no se puede Eliminar Lotes...");
    }
}

 

function desabilitarInputs() {
    $("#codigo_proveedor").attr("readonly", true);
    $("#nombre_proveedor").attr("readonly", true).removeClass("editable");
    $("#ruc_proveedor").attr("readonly", true).removeClass("editable");
    $("#invoice").attr("readonly", true).removeClass("editable");
    $("#fecha").attr("readonly", true).removeClass("editable");
    $("#fecha").datepicker("option", "readonly", true);
    $("#moneda").attr("disabled", true);
    $("#cotiz").attr("readonly", true).removeClass("editable");
    $("#suc").attr("readonly", true);
    $("#tipo_doc_sap").attr("disabled", true);
    $("#pais").attr("disabled", true);
    $(".tr_cli_data").off("click");
    $(".tr_cli_data").unbind("click");
    $("#nombre_proveedor").off('change');
    $("#ruc_proveedor").off('change');
}

function seleccionarProveedor(obj) {
    var proveedor = $(obj).find(".proveedor").html();
    var ruc = $(obj).find(".ruc").html();
    var codigo = $(obj).find(".codigo").html();
    var moneda = $(obj).attr("data-moneda");  
    var pais = $(obj).attr("data-pais");  
    console.log(pais);
    $("#pais option").filter(function() {
       return this.text == pais; 
    }).attr('selected', true);
    
    
    $("#ruc_proveedor").val(ruc);
    $("#nombre_proveedor").val(proveedor);
    $("#codigo_proveedor").val(codigo);
    
    $("#moneda").val(moneda);
    if(pais != "PY"){
        $("#proveedor").val("Internacional");
    }else{
        $("#proveedor").val("Nacional");
    }
    $("#pais").val(pais);

    $("#ui_proveedores").fadeOut("fast");
    $("#msg").html("");
     
    setTimeout('$("#invoice").focus()',400);
}



function checkform() {

    var cod_prov = $("#codigo_proveedor").val();
    var ruc = $("#ruc_proveedor").val();
    var nombre = $("#nombre_proveedor").val();
    var invoice = $("#invoice").val();
    var fecha = validDate($("#fecha").val()).fecha;
    var cotiz = $("#cotiz").val();
    var pais = $("#pais").val();
    var tipo = $("#tipo_doc_sap").val();
    var timbrado = $("#timbrado").val();
   
    if (cod_prov.length > 2 && ruc.length > 2 && nombre.length > 1 && invoice.length > 2 && fecha.length == 10 && cotiz.length > 0 && pais.length > 1  ) {
         
            $("#boton_generar").prop("disabled", false);
         
    } else {
        $("#boton_generar").prop("disabled", true);
    }
}

function generarLotes() {


    $("#msg_obs").html("Generando Lotes. <img src='img/loading_fast.gif' width='16px' height='16px' >");
    $("#generar_lotes").attr("disabled", true);


    var ids = new Array();

    $(".fila_ent").each(function() {
        var id = $(this).attr("id").substring(3, 60);
        var rf = id.split("_")[0];
        var det_id = id.split("_")[1];
        var lote = $("#tr_" + id + " td:nth-child(4)").text();
        if (lote.length < 1) {
            ids.push(det_id);
            $("#tr_" + rf + "_" + det_id + " td:nth-child(4)").html("<img src='img/loading_fast.gif' width='12px' height='12px'>");
        }
    });

    ids = JSON.stringify(ids);

    var ref = $("#ref").val();
    $.ajax({
        type: "POST",
        url: "compras/EntradaMercaderias.class.php",
        data: { "action": "generarLoteEntradaMercaderia", id_ent: ref, ids: ids },
        async: true,
        dataType: "json",
        beforeSend: function() {
            $("#msg_obs").html("Generando Lotes espere...<img src='img/loading_fast.gif' width='12px' height='12px' >");
        },
        success: function(data) {
            $.each(data, function(id_det, lote) {
                $("#tr_" + ref + "_" + id_det + " td:nth-child(4)").html(lote);
            });
            $("#msg_obs").html("Ok, lotes generados...");
            $("#en_transito").fadeIn();
            var tipo = $("#tipo_doc_sap").val();
            if(tipo == "OIGN"){ //Entrada directa
             // $("#finalizar").removeAttr("disabled"); 
             // $("#finalizar").val("Pasar Directamente a SAP");
            }
        }
    });


    $("#msg_obs").html("");
    
    
}

function ponerEnTransito(){
    var ref = $("#ref").val();
    $.ajax({
        type: "POST",
        url: "compras/EntradaMercaderias.class.php",
        data: {"action": "cambiarEstado", "usuario": getNick(), ref: ref,estado:"En_Transito"},
        async: true,
        dataType: "html",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        complete: function (objeto, exito) {
            if (exito == "success") {                          
                var result = $.trim(objeto.responseText);
                if(result == "Ok"){
                    cambiarEstado("En_Transito");
                }
            }
        },
        error: function () {
            $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });     
}

function finalizar() {
    var error_lotes = 0;
    var filas = $(".fila_ent").length;

    if (filas > 0) {

        var error_lotes = 0;
        $(".mnj_x_lotes_si").each(function() {
            var id = $(this).attr("id").substring(3, 60);
            var lote = $("#tr_" + id + " td:nth-child(4)").text();
            if (lote.length < 1) {
                error_lotes++;
            }
        });
        if (error_lotes > 0) {
            errorMsg("Falta generar al menos " + error_lotes + " lotes...", 6000);
            return;
        }

        if (colores_incorrectos > 0) {
            errorMsg("Falta corregir al menos " + colores_incorrectos + " colores...", 18000);
            return;
        }
        //var gastos = $("#total_gastos").val().replace(/\./g,"");
        var g = $("#total_gastos").val();
        
        var tipo_doc = $("#tipo_doc_sap").val();        
         
        
        var c = confirm("Esta operacion es irreversible ha cargado Gastos por "+g+" confirme para continuar...");
        if(c){
            
            if(tipo_doc != "OPDN" || (tipo_doc == "OPDN"  )){
            
            $("#finalizar").attr("disabled", true);
            var ref = $("#ref").val();
            $.ajax({
                type: "POST",
                url: "compras/EntradaMercaderias.class.php",
                data: { "action": "cerrarEntradaMercaderias", usuario: getNick(), ref: ref,tipo_doc:tipo_doc },
                async: true,
                dataType: "html",
                beforeSend: function() {
                    $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >");
                    $("#finalizar").attr("disabled", true);
                },
                complete: function(objeto, exito) {
                    if (exito == "success") {
                        var result = $.trim(objeto.responseText);
                        if (result == "Ok") {
                            $("#estado").val("Cerrada");
                            $("#area_carga").fadeOut();
                            $("div#area_carga input[type=text]").attr("readonly", true);
                            $(".control").fadeOut();
                            $("#inv_obs").attr("readonly", true);
                            estado = "Cerrada";
                            $("#msg").html("<img src='img/ok.png' width='16px' height='16px' >");
                            $("#msg_obs").html("Cerrada <img src='img/ok.png' width='16px' height='16px' >");
                            infoMsg("Entrada Cerrada con exito ", 25000)
                             
                            $("#expenses select").prop("disabled",true);
                            $("#expenses .tipo_gasto").prop("readonly",true);
                            $("#expenses .g_cotiz").prop("readonly",true);
                            $("#mas_menos").remove();
                            
                            setTimeout("showMenu()",5000);
           
                        } else {
                            errorMsg("Ocurrio un error en la comunicacion con el Servidor... Mensaje de Error:" + result + "", 20000);
                        }
                    }
                },
                error: function() {
                    $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
                }
            });
            }else{
                errorMsg("Debe cargar todos los gastos posibles o al menos Despacho de Importacion para compras Internacionales", 20000);
            }
        } else {
            errorMsg("Debe cargar al menos un art�culo para poder cerrar", 8000);
        }
    }
}

/*
function controlarInvoice() {

    var invoice = $("#invoice").val();
    var cod_prov = $("#codigo_proveedor").val();
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: { "action": "controlarEntradaMercaderias", "invoice": invoice, "cod_prov": cod_prov },
        async: true,
        dataType: "html",
        beforeSend: function() {
            $("#msg").html("Verificando datos. <img src='img/loading_fast.gif' width='16px' height='16px' >");
        },
        complete: function(objeto, exito) {
            if (exito == "success") {
                var result = $.trim(objeto.responseText);
                if (result == "Ok") {
                    $("#boton_generar").removeAttr("disabled")
                } else {
                    $("#boton_generar").attr("disabled", true);
                    errorMsg(result, 10000);
                }
                $("#msg").html("");
            }
        },
        error: function() {
            $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
            errorMsg("Ocurrio un error en la comunicacion con el Servidor...", 10000);
        }
    });
}*/


function mostrar() {}

function cerrar() {
    $("#ui_proveedores").fadeOut();
}

function setDefaultDataNextFlag() {
    data_next_time_flag = true;
}

function setHotKeyArticulo() {
    $("#codigo").keydown(function(e) {

        var tecla = e.keyCode;
        if (tecla == 27) {
            $("#ui_articulos").fadeOut();
            escribiendo = false;
        }
        if (tecla == 38) {
            (fila_art == 0) ? fila_art = cant_articulos - 1: fila_art--;
            selectRowArt(fila_art);
        }
        if (tecla == 40) {
            (fila_art == cant_articulos - 1) ? fila_art = 0: fila_art++;
            selectRowArt(fila_art);
        }
        if (tecla != 38 && tecla != 40 && tecla != 13 && tecla != 9) { //9 Tab 38-40 Flechas Arriba abajo
            buscarArticulo();
            escribiendo = true;
        }
        if (tecla == 13) {
            if (!escribiendo) {
                if($("#ui_articulos").is(":visible")){
                   seleccionarArticulo(".fila_art_" + fila_art);
                }else{
                    $("#umc").focus();
                }
            } else {
                setTimeout("escribiendo = false;", 1000);
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
    var img = $(".fila_art_" + row).attr("data-img");
    $("#art_img").attr("src",img);
    escribiendo = false;
}

function updateNotes() {
    $("#msg_obs").html("Guardando Notas... <img src='img/loading_fast.gif' width='16px' height='16px' >");
    var ref = $("#ref").val();
    var notes = $("#inv_obs").val();
    $.post("Ajax.class.php", { action: "updateEntradaNotes", ref: ref, notes: notes }, function(data) {
        $("#msg_obs").html("<img src='img/ok.png' width='16px' height='16px' >");
    });
}

function seleccionarArticulo(obj) {
    var codigo = $(obj).find(".codigo").html();
    var sector = $(obj).find(".Sector").html();
    var nombre_com = $(obj).find(".NombreComercial").html();
    var precio = $(obj).attr("data-precio");
    var precio_costo = parseFloat($(obj).attr("data-precio_costo").replace(".","").replace(",","."));
    var ancho = $(obj).attr("data-ancho");
    var gramaje = $(obj).attr("data-gramaje");
    var um = $(obj).attr("data-um");
    var img = $(obj).attr("data-img");
    if (isNaN(gramaje)) {
        gramaje = "";
    }
    if (isNaN(ancho)) {
        ancho = "";
    }
    
    /*
    var cotiz_compra = parseFloat($("#cotiz").val());
    var precio_moneda_compra = (precio_costo / cotiz_compra).format(2, 3, '.', ',');;
    */
   
   var umc = $(obj).attr("data-umc").split(",");
                        
    $("#umc").html("");
    umc.forEach(function(e){
        $("#umc").append("<option  value='"+e+"'>"+e+"</option>")
    });

    $("#codigo").val(codigo);
    $("#descrip").val(nombre_com);
    $("#um").val(um);
    $("#art_img").attr("src",img);
    
    //$("#gramaje").val(gramaje);
    //$("#composicion").val(composicion);
    $("#ui_articulos").fadeOut();
    //$("#precio").val(precio_moneda_compra);
    //$("#bale").focus();
    /*
    if (um == "Mts") {
        $(".c_unid").prop("disabled", true);
        $(".c_metros").removeAttr("disabled");
        $(".c_yardas").removeAttr("disabled");
        $(".c_kilos").removeAttr("disabled"); 
        $("#umc").val("Mts");
    }else if(um == "Kg"){
        $(".c_kilos").removeAttr("disabled"); 
        $(".c_metros").prop("disabled", true);
        $(".c_unid").prop("disabled", true);
        $(".c_yardas").prop("disabled", true);
        $("#umc").val("Kg");		
    } else { // Unid
        $(".c_metros").prop("disabled", true);
        $(".c_yardas").prop("disabled", true);
        $(".c_kilos").prop("disabled", true);
        $(".c_unid").removeAttr("disabled");
        $("#umc").val("Unid");
    }*/
    $("#umc").val(um);
    $("#umc").focus();
}

function buscarArticulo() {
    var articulo = $("#codigo").val();
    fila_art = 0;
    if (articulo.length > 0) {
          
        $.ajax({
            type: "POST",
            url: "compras/EntradaMercaderias.class.php",
            data: { "action": "buscarArticulos", "articulo": articulo  },
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
                        var UM = data[i].um;
                        var img = data[i].img;
                        var prior = (data[i].prior).split(","); 
                        var umc = (data[i].umc).split(",");
                        
                        $("#umc").html("");
                        umc.forEach(function(e){
                            $("#umc").append("<option  value='"+e+"'>"+e+"</option>")
                        });
                        
                        var PrecioCosto = parseFloat((data[i].costo_prom)).format(0, 3, '.', ',');
                         
                        $("#lista_articulos").append("<tr class='tr_art_data fila_art_" + i + "' data-precio='" + Precio + "' data-precio_costo='" + PrecioCosto + "' data-um='" + UM + "' data-img='" + img + "' data-umc='"+umc+"'  ><td class='item clicable_art'><span class='codigo' >" + ItemCode + "</span></td>   <td class='item clicable_art'><span class='Sector'>" + Sector + "</span> </td><td  class='item clicable_art'><span class='NombreComercial'>" + NombreComercial + "</span></td><td class='itemc clicable_art'><span class='um'> " + UM + "</span></td> </tr>");
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
    }
}
 

function limpiarListaArticulos() {
    $(".tr_art_data").each(function() {
        $(this).remove();
    });
}

function infoTipo() {
    $("#msg_info").fadeIn();
    setTimeout(function() {
        $("#msg_info").fadeOut("slow");
    }, 10000);
}

function eliminarEntrada(ref) {
    var c = confirm("Este procedimiento no tiene vuelta atras...\nConsidere hacer una copia en Excel antes de continuar.\nEsta Seguro que desea Eliminar esta Compra?");
    if(c){
        $("#" + ref).children().html("<img src='img/loading_fast.gif' width='16px' height='16px' >");
        $.post("Ajax.class.php", { action: "eliminarEntradaMercaderia", ref: ref }, function(data) {
            $("#" + ref).remove();
        });
    }
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

    }
    //console.log(e.keyCode+"  "+ e.which);
    if ((tecla >= "97") && (tecla <= "122")) {
        return false;
    }
}

function scrollWindows(pixels) {
    $("#work_area").animate({
        scrollTop: pixels
    }, 250);
}
function stringify(str) {
    if (str == null) {
        return "";
    } else {
        return str;
    }
}

function descargarExcel(id_ent){     
    $.ajax({
        type: "POST",
        url: "compras/EntradaMercaderias.class.php",
        data: {action: "descargarExcel", id_ent:id_ent,suc: getSuc(), usuario: getNick()},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {   
            if (data.mensaje === "Ok") {
                window.open(data.url);
                $("#msg").html("Descargando excel");   
            } else {
                $("#msg").html("Error al generar Excel  ");   
            }                
        },
        error: function (e) {                 
            $("#msg").html("Error al generar Excel  :  " + e);   
            errorMsg("Error al generar Excel  " + e, 10000);
        }
    }); 
}
