$(function() {
    $(".lote_rem").change(function() {
        guardarLoteRemplazo($(this));
    });
    setAnchorTitle();

    var isMouseDown = false;
    $("table#solicitudes tr.fila td:not(.td_remplazo)")
        .mousedown(function() {
            isMouseDown = true;
            var top_rem = $(this).parent();
            var en_remito = top_rem.hasClass("en_remito");
            var id = top_rem.attr("id");
            if (!en_remito) {
                $(this).parent().toggleClass("marcada");
            } else {
                var info = top_rem.attr("data-info");
                if (confirm("Articulo " + id + "\n" + info + "\n" + "Marcar como enviado este pedido?")) {
                    var pedido_nro = $("tr#" + id + " .nro_pedido").text();
                    $.post("../Ajax.class.php", { "action": "actualizarEstadoPedido", "ped_nro": pedido_nro, "lote": id },
                        function(data) {
                            if (data.msg === 'Ok') {
                                alert("Operacion exitosa");
                                $("#" + id).slideUp('slow', function() { $(this).remove() });
                            } else {
                                alert("Ocurrio un error al procesar la pericion \n" + data.msg);
                            }
                        }, 'json');
                }
            }
            return false; // prevent text selection
        })
        .mouseover(function() {
            if (isMouseDown) {
                var top_rem = $(this).parent();
                var en_remito = top_rem.hasClass("en_remito");
                if (!en_remito) {
                    $(this).parent().toggleClass("marcada");
                }
            }
        }).mouseup(function() {
            editar();
        })
        .bind("selectstart", function() {
            return false; // prevent text selection in IE
        });
    $("[data-verificar='si'].fila").each(function() {
        var codigo = $(this).attr("data-codigo");
        var lote = $(this).attr("data-lote");
        var remp = $(this).find(".lote_rem").val();
        controlarLotesEnRemitos(codigo, lote, remp);
    });
    $(document).mouseup(function() {
        isMouseDown = false;
    });

    $(window).scroll(function() {
        $('#message_frame').animate({ top: $(window).scrollTop() + "px" }, { queue: false, duration: 350 });
    });
    $("#message_frame").draggable();
    getUbic();
    //Cant Codigos
    $("#cantidad").html($('.fila').filter(function() { return $(this).css('display') !== 'none'; }).length);
});

function controlarLotesEnRemitos(codigo, lote, remplazo) {
    var origen = $("#destino").val(); // Origen de los remitos, un lote de otra sucursal igual a este puede estar en otra remision 
	var destino = $("#origen").val();
    var estado_ant = $(".msg_" + lote).html();
    $.ajax({
        type: "POST",
        url: "../Ajax.class.php",
        data: { "action": "controlarLotesEnRemitos", "origen": origen,"destino":destino, "codigo": codigo, "lote": lote, "remplazo": remplazo },
        async: true,
        dataType: "json",
        beforeSend: function() {
            $(".msg_" + lote).append("<img class='loading' src='../img/loading_fast.gif' width='18px' height='18px' >");
        },
        success: function(data) {
            var estado = data.estado;
            var remision = data.Remision;
            switch(estado){
                case 'Libre':
                    $(".msg_" + lote).html(estado_ant);
                    break;
                case 'En Reserva':
                    $(".msg_" + lote).text("En Orden de Fraccionamiento");
                    $(".msg_" + lote).addClass("error");
                    break;
                case 'En Remision':
                    $(".msg_" + lote).html(estado_ant + " <img class='img_en_remito' src='../img/truck.png' width='26px' height='18px' >");
                    $("#" + lote).addClass("en_remito");
                    $("#" + lote).attr("data-info", remision);
                    $("#" + lote).removeClass("marcada");
                    $(".msg_" + lote).addClass("cargando");
                    $("#check_" + lote).prop("checked", "");
                    break;
            }
            /* if (estado == 'Libre') {
                $(".msg_" + lote).html(estado_ant);
            } else {

                $(".msg_" + lote).html(estado_ant + " <img class='img_en_remito' src='../img/truck.png' width='26px' height='18px' >");
                $("#" + lote).addClass("en_remito");
                $("#" + lote).attr("data-info", remision);
                $("#" + lote).removeClass("marcada");
                $(".msg_" + lote).addClass("cargando");
                $("#check_" + lote).prop("checked", "");
            } */
        }
    });
}

function editar() {
    $(".checked").prop("checked", "");
    var cont = 0;
    $(".marcada").each(function() {
        var lote = $(this).attr("data-lote");
        $("#check_" + lote).prop("checked", "checked");
        $("#check_" + lote).addClass("checked");
        cont++;
    });
    if (cont > 0) {
        $("#message_frame").fadeIn();
    } else {
        $("#message_frame").fadeOut();
    }
}

function procesarLotes() {
    var origen = $("#destino").val();
    var destino = $("#origen").val();
    $("#message_header").hide();

    $.ajax({
        type: "POST",
        url: "../Ajax.class.php",
        data: { "action": "getRemitosAbiertos", suc: origen, suc_d: destino },
        async: true,
        dataType: "html",
        beforeSend: function() {
            $("#message").html("<img src='../img/loading_fast.gif' width='18px' height='18px' >");
        },
        complete: function(objeto, exito) {
            if (exito == "success") {
                var result = $.trim(objeto.responseText);
                $("#message").html(result);
                ajustarMedidas();
            }
        },
        error: function() {
            $("#message").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });
}

function insertarAqui(nro) {
    var arr = new Array();
    var lotes = new Array();

    $(".marcada").each(function() {
        var en_remito = $(this).hasClass("en_remito");
        var lote = $(this).attr("data-lote");
        var remplazo = $(this).find(".lote_rem").val();
        if (remplazo.length > 0) {
            lote = remplazo;
        }
        if (en_remito) {
            $(this).removeClass("marcada");
            $("#check_" + lote).prop("checked", "");
        } else {
            var codigo = $(this).attr("data-codigo");
            var nro_pedido = $(this).children(".nro_pedido").html();
            //var descrip = $(this).children(".descrip").html();
            var cant = $(this).children(".cant").html();
            var cod_lote = { 'nro_pedido': nro_pedido, 'codigo': codigo, 'lote': lote, 'cant': cant };

            lotes.push(cod_lote);
            $(".msg_" + lote).html("En Proceso");
        }
    });

    lotes = JSON.stringify(lotes);
    //console.log(lotes);
    var destino = $("#destino").val();
    var usuario = $("#operario").val();
    $.ajax({
        type: "POST",
        url: "../Ajax.class.php",
        data: { 'action': 'insertarLotesEnRemito', 'nro': nro, suc: destino, 'lotes': lotes,usuario:usuario },
        async: true,
        dataType: "json",
        beforeSend: function() {
            $(".btn_" + nro).append("<img class='loading' src='../img/loading_fast.gif' width='22px' height='22px' >");
        },
        success: function(data) {
            if (data.error) {
                alert(data.error);
            } else {
                var t = 0;
                for (var i in data) {
                    var lote = data[i];
                    $(".msg_" + lote).html("En Proceso <img class='img_en_remito' src='../img/truck.png' width='26px' height='18px' >");
                    $(".msg_" + lote).parent().addClass("en_remito");
                    $(".msg_" + lote).parent().removeClass("marcada");
                    $(".msg_" + lote).addClass("cargando");
                    t++;
                }
                var cant = parseFloat($(".items_" + nro).html());
                var suma = cant + t;
                $(".items_" + nro).html(suma);
                $(".loading").remove();
            }
        }
    });
}

function imprimir() {
    $("#message_frame").fadeOut(1);

    setTimeout("self.print()", 200);
}

function ajustarMedidas() {
    $("#message_frame").width("auto");
    $("#message_frame").height("auto");
}

function minimizar() {
    $("#message").empty();
    $("#message_header").show();
    ajustarMedidas();
}

function generarRemito(origen, destino) {
    var c = confirm("Confirma generar esta Remision?");
    if (c) {
        var operario = $("#operario").val();
        $.ajax({
            type: "POST",
            url: "../Ajax.class.php",
            data: { "action": "generarRemito", usuario: operario, origen: origen, destino: destino },
            async: true,
            dataType: "html",
            beforeSend: function() {
                $("#message").html("<img src='../img/loading_fast.gif' width='22px' height='22px' >");
            },
            complete: function(objeto, exito) {
                if (exito == "success") {
                    var nro = $.trim(objeto.responseText);
                    if (nro > 0) {
                        procesarLotes();
                    } else {
                        alert(nro);
                    }
                }
            },
            error: function() {
                $("#message").html("Ocurrio un error en la comunicacion con el Servidor...");
            }
        });
    }
}

function guardarLoteRemplazo(lote_obj) {

    var lote = $(lote_obj).parent().prev().html();
    var lote_rem = $(lote_obj).val();
    if (lote == lote_rem) {
        alert("Cuidado... Lote remplazo igual al lote...");
        $(lote_obj).val("");
        return;
    }
    var nro = $(lote_obj).parent().prev().attr("data-nro");
    var usuario = $("#operario").val();
    var suc = $("#destino").val();
    $.ajax({
        type: "POST",
        url: "../Ajax.class.php",
        data: { "action": "agregarCodigoRemplazoSolicitud", "usuario": usuario, "nro": nro, "lote": lote, "lote_rem": lote_rem, "suc": suc },
        async: true,
        dataType: "html",
        beforeSend: function() {
            $(".error").remove();
            $(".msg_" + lote).append("<img class='loading' src='../img/loading_fast.gif' width='18px' height='18px' >");
        },
        complete: function(objeto, exito) {
            if (exito == "success") {
                var result = $.trim(objeto.responseText);
                $(".loading").remove();
                var first_part = result.substring(0,2);
                
                if (first_part == "Ok") {
                    if(lote != ""){
                        var quty_part = parseFloat(result.substring(3,30));
                        $("#"+lote).find(".cant").html(quty_part);
                    }
                } else {
                    $(".msg_" + lote).append("<img class='error' src='../img/important.png' width='18px' height='18px' >");
                    alert(result);
                    $(lote_obj).val("");
                }
            }
        },
        error: function() {
            $(".msg_" + lote).removeClass("loading");
            $(".msg_" + lote).append("<img class='error' src='../img/important.png' width='18px' height='18px' >");
            $(lote_obj).val("");
        }
    });
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
    if (text != undefined) {
        var offset = element.offset();
        $('#anchorTitle').css({
            'top': (offset.top + element.outerHeight()) + 'px',
            'left': offset.left + 15 + 'px'
        }).html(text).show();
    }
}

function hideAnchorTitle() {
    $('#anchorTitle').hide();
}

function getUbic() {
    var lotes = new Array();
    $(".lote").each(function() {
        var lote = $(this).text();
        lotes.push(lote);
    });
    lotes = JSON.stringify(lotes);
    var destino = $("#destino").val();
    $.ajax({
        type: "POST",
        url: "../Ajax.class.php",
        data: { "action": "getLotesUbic", lotes: lotes, suc: destino },
        async: true,
        dataType: "json",
        beforeSend: function() {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >");
        },
        success: function(data) {
            for (var i in data) {
                var lote = data[i].lote;
                var ubic = data[i].ubic;
                var _ubic = ubic.split('-');
                var span_ubic = $("<span/>", { "class": "ubic_" + lote, "data-target": lote, "data-estante": _ubic[0], "data-fila": _ubic[1], "data-columna": _ubic[2], "text": ubic });
                $(".ubic_" + lote).html(span_ubic);
            }
            $("#msg").html("");
        }
    });
}
// Filtro numero de pedidos opciones
function showOption(target) {
    var t = target.attr('data-target');
    if ($("#" + t).css("display") === 'none') {
        $("#" + t).show();
    } else {
        $("#" + t).hide();
    }
}
// Filtro de Ubicación

function fitrarUbic(Obj) {
    $("tr.fila").show();
    var criterio = Obj.text();
    var filtro = '';
    switch (criterio) {
        case 'Hombre':
            filtro = "fila>3 || fila==''";
            break;
        case 'Maquina':
            filtro = "fila<4 || fila==''";
            break;
        case 'Vacios':
            filtro = "fila!=''";
            break;

    }
    if (filtro != '') {
        $("span[class^=ubic_]").each(function(Obj) {
            var estante = $(this).attr("data-estante");
            var fila = $(this).attr("data-fila");
            var columna = $(this).attr("data-columna");
            var lote = $(this).attr("data-target");
            if (eval(filtro)) {
                $("#" + lote).hide(function() {
                    var visibles = $('.fila').filter(function() { return $(this).css('display') !== 'none'; }).length;
                    $("#cantidad").html(visibles);
                });
            }
        });
    }
    $("#ubic_filtro").hide();
}
// Filtros pedidos.
function filtrar(target) {
    var t = target.text();
    if (t === '*') {
        $($(".nro_pedido").parent()).show();
    } else {
        $($(".nro_pedido").parent()).hide(function() { $("." + t).show() });
    }
    $("#nro_filtro").hide(function() {
        var visibles = $('.fila').filter(function() { return $(this).css('display') !== 'none'; }).length;
        $("#cantidad").html(visibles);
    });


}

// Lista de Estados
function mostrarOcultarEstados() {
    if ($("ul#estados").css("display") === 'none') {
        $("ul#estados").show();
    } else {
        $("ul#estados").hide();
    }
}

// Cambiar Estados
function cambiarEstado(Obj) {
    var estado = Obj.text();
    var targets = {};
    var razon = '';
    var ok = false;

    if( estado == 'Suspendido' ){
        razon = prompt("Motivo: ");
        if(razon != null && razon.trim().length > 0 && razon != undefined){
            razon = '; Usuario('+opener.getNick()+'): '+razon;
            ok = true;
        }
    }else{
        ok = true;
    }
    
    if(ok){
        $(".marcada").each(function() {
            var en_remito = $(this).hasClass("en_remito");
            var lote = $(this).attr("data-lote");
            var pedido = $(this).children("td.nro_pedido").text();
            targets[pedido] = lote;
        });
                
        $.post("../Ajax.class.php", { "action": "cambiarEstadoNotaPedido", "estado": estado,"razon":razon, "targets": JSON.stringify(targets) }, function(data) {
            console.log(data.msj);
            $(".marcada").remove();
        }, 'json');

        $("ul#estados").hide();
    }
}