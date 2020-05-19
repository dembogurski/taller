$(function() {
    $.ajaxSetup({
        beforeSend: function() {
            $('.loader').show();
        },
        complete: function() {
            $('.loader').hide();
        },
        success: function() {
            $('.loader').hide();
        },
        fail: function() {
            $('.loader').hide();
        }
    });
    actualizarListaArticulos();

    $("input#fecha_desde, input#fecha_hasta").mask("99/99/9999");
    $("input#fecha_desde, input#fecha_hasta").datepicker({ dateFormat: 'dd/mm/yy' });
    $(".verTodos").hide();
});

function actualizarListaArticulos() {
    $("select#articulo option.loaded").hide();
    var grupoID = $("select#grupo option:selected").val();
    $("select#articulo option." + grupoID).show();
    $($("select#articulo option").get(0)).prop("selected", true);
}
// Lista Agrupada
function listarArticulos() {
    $("div.reporte").hide();
    var articulo = $("select#articulo option:selected").val();
    var fecha_limite = $("input#fecha_limite").val();
    var ItmsGrpCod = $("select#grupo option:selected").val();      

    $("table#articulos tbody").empty();
    $.post("InventarioReportes.php", { "action": "codigosXCodXSuc", "suc": opener.getSuc(), "articulo": articulo, "fecha_limite": fecha_limite, "ItmsGrpCod": ItmsGrpCod,"todos":$("#incluirAnt").is(":checked")}, function(data) {
        var lotes;
        try {
            lotes = JSON.parse(data);
        } catch (err) {
            lotes = [];
        }
        if (lotes.length > 0) {
            lotes.forEach(function(lote, i) {
                var tr = $("<tr/>", { "class": "articulos" });
                $.each(lote, function(key, value) {
                    var td = $("<td/>");
                    switch (key) {
                        case "lotes":
                        case "inv":
                        case "fdp":
                            td.attr("align", "right");
                            td.text(value);
                            break;
                        case "ItemCode":
                            td.attr("align", "center");
                            td.text(value);
                            tr.attr("onclick", "listarLotes('" + value + "')")
                            break;
                        default:
                            td.attr("align", "left");
                            td.text(value);
                            break;
                    }
                    $(td).appendTo(tr);
                });
                tr.appendTo("table#articulos tbody");
            });
            $("div#articulosContainer").show();
        }
    });
}
// Lista pendientes de inventario
var lista_proceso = {};
var pararReportePendientes = false;
function iniciarReportePendientes(){
    pararReportePendientes = false;
    lista_proceso = {};
    $(".verTodos").show();
    $("#inv_filtro").val('No');
    $("#inv_hideFDP").prop('checked',true);
    $("table#lotes th.fdpSelect input").prop("checked",false);
    $("div#reporte").hide();
    $("table#lotes tbody").empty();
    $("div#lotesContainer").show();
    $("table#lotes").show();
    $("select#articulo option." + $("select#grupo option:selected").val()).each(
        function(){
            if($("select#articulo option:selected").val() == '%'){
                var cod = $(this).val();
                var art = $(this).text();
                if(Object.keys(lista_proceso).indexOf(cod) == -1){
                    lista_proceso[cod]=art;
                }
            }else{
                var cod = $("select#articulo option:selected").val();
                var art = $("select#articulo option:selected").text();
                if(Object.keys(lista_proceso).indexOf(cod) == -1){
                    lista_proceso[cod]=art;
                }
            }
        }
    );
    pendientes();
}
// Genera el reporte
function pendientes() {
    var codigo = Object.keys(lista_proceso)[0];
    var articulo = lista_proceso[codigo];
    $("#procInfo").text("Procesando "+articulo);
    //while(Object.keys(lista_proceso).length>0){delete lista_proceso[Object.keys(lista_proceso)[0]]}
    var fecha_limite = $("input#fecha_limite").val();
    var filtro_stock = $("input#stockFiltro").val();
    if(isNaN(filtro_stock)){
        alert("Filtro de Stock debe ser un numero valido");
    }else{
        $.post("InventarioReportes.php", { "action": "lostesXSucXArticulo", "suc": opener.getSuc(), "codigo": codigo, "fecha_limite": fecha_limite,"filtro_stock":filtro_stock,"todos":$("#incluirAnt").is(":checked")}, function(data) {
            var lotes;
            try {
                lotes = JSON.parse(data);
            } catch (err) {
                lotes = [];
            }
            if (lotes.length > 0) {
                lotes.forEach(function(lote, i) {
                    var tr = $("<tr/>");
                    var checkbox = $("<input/>",{
                        "class":"fdpSelect toExcel",
                        "type":"checkbox"
                    });
                    if(lote.U_fin_pieza == 'Si' || lote.inv == 'Si'){
                        checkbox.attr("disabled","disabled");
                    }
                    var tdFDP = $("<td/>").append(checkbox);
                    tdFDP.appendTo(tr);
                    
                    var DistNumber = lote.DistNumber;
                      
                    $.each(lote, function(key, value) {
                        var td = $("<td/>",{"class":key});
                        switch (key) {
                            case "Stock":
                                td.text((parseFloat(value)).toFixed(2));
                                td.attr("align", "right");
                                td.attr("class", "stock_"+DistNumber);
                                break;
                            case "DistNumber":
                                td.attr("align", "right");
                                td.attr("id", "DistNumber_"+value);
                                td.text(value);
                                break;
                            case "U_fin_pieza":
                                td.attr("align", "center");
                                //td.attr("class", "FDP_"+value);
                                tr.addClass("FDP_"+value);
                                td.text(value);
                                break;
                            case "U_estado_venta":
                                td.attr("align", "center");                            
                                td.append(
                                    $("<abbr/>",{
                                        "title":value,
                                        "text":value.substr(0,1)
                                    })
                                );
                                break;
                            case "ItemCode":
                                td.attr("align", "center");                            
                                td.text(value);
                                break;
                            case "inv":
                                td.attr("align", "center");
                                tr.addClass(value);
                                td.text(value);
                                break;
                            case "U_img":
                                td.attr("align", "center");
                                
                                var img = $("<img/>",{
                                    "src":opener.imgURI+value+'.thum.jpg',
                                    "onerror":"noImage($(this))",
                                    "height":"16"
                                });
                                var button = $("<button/>",{
                                    "data-target":opener.imgURI+value+'.jpg',
                                    "onclick":"inv_mostrarImagen($(this))"
                                });
                                button.attr("class", "toExcel");
                                button.append(img);
                                td.append(button);
                                break;
                            default:
                                td.attr("align", "left");
                                td.text(value);
                                break;
                        }
                        $(td).appendTo(tr); 
                    });
                    var tdfin = $("<td/>",{"class":"fin_"+DistNumber+" advanced","align":"center"});
                    var tdum = $("<td/>",{"class":"fum_"+DistNumber+" advanced","align":"center"});
                    var costo = $("<td/>",{"class":"costo_"+DistNumber+" advanced","align":"center"});
                    var costo_total = $("<td/>",{"class":"costo_total_"+DistNumber+" advanced","align":"center"});
                    $(tdfin).appendTo(tr); 
                    $(tdum).appendTo(tr); 
                    $(costo).appendTo(tr); 
                    $(costo_total).appendTo(tr); 
                    tr.appendTo("table#lotes tbody");
                });
                
                invCantidadFiltrada();
                filtrarLista();
            }
            delete lista_proceso[codigo];
            if(Object.keys(lista_proceso).length>0 && !pararReportePendientes){
                pendientes();
                var todos = $("select#articulo option." + $("select#grupo option:selected").val()).length;
                var ancho = (100-parseInt((Object.keys(lista_proceso).length*100)/todos)).toString()+'%';
                $("div#inv_progresoLista").text(ancho)
                $("div#inv_progresoListaInfo").css("width", ancho);
            }else{
                $(".verTodos").hide();
            }
        });
        //$($("select#inv_filtro option").get(0)).prop("selected", true);
    }
}
var datos = null;
function avance(){   
     
    $("#procInfo").text("Avance ");
 
    var fecha_limite = $("input#fecha_limite").val();
 
           
    $.post("InventarioReportes.php", { "action": "avance", "suc": opener.getSuc(),   "fecha_limite": fecha_limite }, function(data) {
        datos = $.parseJSON(data)
        
        $(".avances").fadeIn();
        $(".report").fadeOut();
        $(".fila_avances").remove();
        
        $.each(datos, function(i,n) {
          var grup = n.grupo;
          var invent = parseInt(n.invent);
          var total = parseInt(n.total);
          
          if( isNaN(invent) ){    
              invent = 0;
          }
          var porc = ( parseFloat((invent * 100) / total)).toFixed(2);
          $("#invLotes").append("<tr class='fila_avances'><td>"+grup+"</td><td class='num'>"+invent+"</td><td  class='num'>"+total+"</td><td  class='num'>"+porc+"% </td></tr>")
        });
        
    });
         
}

function listarLotes(codigo) {
    $("table#lotes th.fdpSelect input").prop("checked",false);
    $("input#inv_hideFDP").prop("checked",false);
    $("div#reporte").hide();
    $("table#lotes tbody").empty();
    var fecha_limite = $("input#fecha_limite").val();
    var filtro_stock = $("input#stockFiltro").val();
    if(isNaN(filtro_stock)){
        alert("Filtro de Stock debe ser un numero valido");
    }else{
        $.post("InventarioReportes.php", { "action": "lostesXSucXArticulo", "suc": opener.getSuc(),"filtro_stock":filtro_stock, "codigo": codigo, "fecha_limite": fecha_limite }, function(data) {
            var lotes;
            try {
                lotes = JSON.parse(data);
            } catch (err) {
                lotes = [];
            }
            if (lotes.length > 0) {
                $("span#lotesCodigo").text(codigo);
                lotes.forEach(function(lote, i) {
                    var tr = $("<tr/>");
                    var checkbox = $("<input/>",{
                        "class":"fdpSelect toExcel",
                        "type":"checkbox"
                    });
                    if(lote.U_fin_pieza == 'Si' || lote.inv == 'Si'){
                        checkbox.attr("disabled","disabled");
                    }
                    var tdFDP = $("<td/>").append(checkbox);
                    tdFDP.appendTo(tr);
                    $.each(lote, function(key, value) {
                        var td = $("<td/>",{"class":key});
                        switch (key) {
                            case "Stock":
                                td.text((parseFloat(value)).toFixed(2));
                                td.attr("align", "right");
                                break;
                            case "DistNumber":
                                td.attr("align", "right");
                                td.attr("id", "DistNumber_"+value);
                                td.text(value);
                                break;
                            case "U_fin_pieza":
                                td.attr("align", "center");
                                //td.attr("class", "FDP_"+value);
                                tr.addClass("FDP_"+value);
                                td.text(value);
                                break;
                            case "U_estado_venta":
                                td.attr("align", "center");                            
                                td.append(
                                    $("<abbr/>",{
                                        "title":value,
                                        "text":value.substr(0,1)
                                    })
                                );
                                break;
                            case "ItemCode":
                                td.attr("align", "center");                            
                                td.text(value);
                                break;
                            case "inv":
                                td.attr("align", "center");
                                tr.addClass(value);
                                td.text(value);
                                break;
                            case "U_img":
                                td.attr("align", "center");
                                var img = $("<img/>",{
                                    "src":opener.imgURI+value+'.thum.jpg',
                                    "onerror":"noImage($(this))",
                                    "height":"16"
                                });
                                var button = $("<button/>",{
                                    "data-target":opener.imgURI+value+'.jpg',
                                    "onclick":"inv_mostrarImagen($(this))"
                                });
                                button.append(img);
                                td.append(button);
                                break;
                            default:
                                td.attr("align", "left");
                                td.text(value);
                                break;
                        }
                        $(td).appendTo(tr);
                    });
                    tr.appendTo("table#lotes tbody");
                });
                $("div#lotesContainer").show();
                invCantidadFiltrada();
                filtrarLista();
            }
        });
        $($("select#inv_filtro option").get(0)).prop("selected", true);
        $("table#lotes").show();
    }
}
// Ejecutar poner en fin de pieza
function ponerNFDP(){
    var lotes = [];
    var cantLotes = $("input:checked").closest("tr.No.FDP_No").length;

    $("input:checked").closest("tr.No.FDP_No").find("td.DistNumber").each(function(){
        lotes.push($(this).text());
    });

    if(lotes.length > 0){
        if(confirm("Confirmar!!\n"+cantLotes+" lotes pasaran a Fin De Pieza")){
            $.post("InventarioReportes.php", { "action": "ponerNFDP","user":opener.getNick(),"suc": opener.getSuc(),"lotes":JSON.stringify(lotes) }, function(data) {
                data.FDP.forEach(function(v,i){                
                    $("td#DistNumber_"+v).closest('tr').removeClass("FDP_No");
                    $("td#DistNumber_"+v).closest('tr').removeClass("No");
                    $("td#DistNumber_"+v).closest('tr').find('.U_fin_pieza').text('Si')
                    $("td#DistNumber_"+v).addClass("ok");
                    var chk = $($("td#DistNumber_"+v).closest('tr').find('.fdpSelect'));
                    chk.prop("checked", false);
                    chk.prop("disabled", true);
                    
                });
                data.lotesEX.forEach(function(v,i){
                    $("td#DistNumber_"+v).addClass("error");
                });
                if(data.lotesEX.length > 0){
                    alert("No se puede dar FDP a todos los lotes\nAlgunos tienen Stock en otra sucurzal");
                }
            }, "json");
        }
    }
}
// Para poner en fin de pieza
function seleccionarTodos(target){
    if(target.is(":checked")){
        $("table#lotes tr.No.FDP_No:visible td input.fdpSelect").prop("checked",true);
    }else{
        $("table#lotes tr.No.FDP_No:visible td input.fdpSelect").prop("checked",false);
    }
}

function piezasInventariadasXRangoFecha() {
    var desde = flipDate($("input#fecha_desde").val());
    var hasta = flipDate($("input#fecha_hasta").val());
    $("div.reporte").hide();
    $("table#invLotes tbody").empty();
    $.post("InventarioReportes.php", { "action": "piezasInventariadasXRangoFecha","user":opener.getNick(), "suc": opener.getSuc(), "desde": desde, "hasta": hasta }, function(data) {

        try {
            var respuesta = data;
            if (respuesta.length > 0) {
                $("span#periodo").text(" Desde " + desde + " hasta " + hasta);
                respuesta.forEach(function(d, i) {
                    var tr = $("<tr/>");
                    $.each(d, function(key, value) {
                        $("<td/>", { "text": value, "align": "center" }).appendTo(tr);
                    });
                    tr.appendTo("table#invLotes tbody");
                });
                $("div#invContainer").show();
            }
        } catch (err) {
            console.log("Error: " + err);
        }
    }, "json");
}

function cerrarLitaLotes() {
    $("div#lotesContainer").hide();
    pararReportePendientes = true;
}

function flipDate(date) {
    var rDate = date.split('/');
    return rDate[2] + '-' + rDate[1] + '-' + rDate[0]
}

function filtrarLista() {
    var sumMTS = 0;
    $("table#lotes tbody tr").hide();
    var show = $("select#inv_filtro option:selected").val();
    if (show == '*') {
        $("table#lotes tbody tr").show();
    } else {
        $("table#lotes tbody tr." + show).show();
    }
    if($("input#inv_hideFDP").is(":checked")){
        $("tr.FDP_Si").hide();
    }
    $("table#lotes tr:visible td.Stock").each(function(){
        sumMTS += parseFloat($(this).text())
    });
    $("td#sumMTS").text(sumMTS.toFixed(2));
    invCantidadFiltrada();
}

function invCantidadFiltrada() {    
    var visibles = $("table#lotes tbody tr:visible").length;
    var msj = (visibles > 0) ? " lotes " + visibles : " lote " + visibles;
    $("span#inv_listaCount").text(msj);
}
function noImage(Obj){
    Obj.prop("src",opener.imgURI+"0/0.jpg")
}
var inv_popUp;
function inv_mostrarImagen(Obj){
    if(inv_popUp !== undefined){
        inv_popUp.close();
    }
    inv_popUp = window.open(Obj.data("target"), "_blank", "toolbar=yes,scrollbars=yes,resizable=yes,top=100,left=100,width=400,height=400"); 
}
function toExcel(){
    $(".toExcel").fadeToggle();
}
function historial(){
    var i = 0;
        $(".FDP_No .DistNumber").each(function(){
           var lote = $(this).text();
           getHistorial(lote);
        i++;
    });    
}

function getHistorial(lote){
    var suc = window.opener.getSuc();
    $.ajax({
        type: "POST",
        url: "InventarioProducto.class.php",
        data: {"inv_action": "historial", "args": lote+","+suc  },
        async: true,
        dataType: "json",
        beforeSend: function () {
            $(".fin_"+lote).html("<img src='../img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {   
            $(".fin_"+lote).html(); 
                var DocDateIN = data.DocDateIN;
                var uin = data.UsuarioIN;
                var DocDateUM = data.DocDateUM!=undefined?data.DocDateUM:'';
                var uum = data.UsuarioUM!=undefined?data.UsuarioUM:'';
                var p_costo = parseFloat(data.AvgPrice); 
                var stock = parseFloat($(".stock_"+lote).html()); 
                var costo = (stock * p_costo).format(2, 3, '.', ',');
                $(".fin_"+lote).html("<span style='font-size:10px'>"+uin+"<br>"+DocDateIN+"</span>"); 
                $(".fum_"+lote).html("<span style='font-size:10px'>"+uum+"<br>"+DocDateUM+"</span>"); 
                $(".costo_"+lote).html(p_costo); 
                $(".costo_total_"+lote).html(costo); 
                
        }
    });
    
}

Number.prototype.format = function(n, x, s, c) {           
    var s_ = s || ".";   
    var c_ = c || ",";   
    
    var re = '\\d(?=(\\d{' + (x || 3) + '})+' + (n > 0 ? '\\D' : '$') + ')',
        num = this.toFixed(Math.max(0, ~~n));

    return (c_ ? num.replace('.', c_) : num).replace(new RegExp(re, 'g'), '$&' + (s_ || ','));
};