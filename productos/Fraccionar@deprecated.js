/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var data_next_time_flag = true;
var ajustes_pendientes = true;
var cotizacion_dolar = false;
var intentos = 0;
var procesados = 0;
var pendientes = 1;


function configurar() {
    $("#lote").focus();
    $("#lote").change(function() {
        buscarDatos();
    });

    $("#stockreal").change(function() {
        calcAjuste();
    });
    $("*[data-next]").keyup(function(e) {
        if (e.keyCode == 13) {
            if (data_next_time_flag) {
                data_next_time_flag = false;
                var next = $(this).attr("data-next");
                $("#" + next).focus();
                setTimeout("setDefaultDataNextFlag()", 600);
            }
        }
    });

    $("#tabs").tabs();
    var balanza = getCookie("balanza").sesion;
    if (balanza == null) { balanza = "localhost"; }
    $("#balanza").val(balanza); // Poner balanza ultimamente utilizada
    var metrador = getCookie("metrador").sesion;
    if (metrador == null) { metrador = "localhost"; };
    $("#metrador").val(metrador);

    $(".calc").change(function() {
        calcularGramaje();
    });
    configurePrinter();
    checkearCotizDolar();

}

function showKeyPad(id) {
    //if(touch){
    showNumpad(id, buscarDatos, false);
    //}
}

function showKeyPadGeneric(id) {
    //if(touch){
    showNumpad(id, calcularGramaje, false);
    var position = $("#" + id).offset();
    //console.log('top'  + position.top  +'left' + position.left);
    $('#n_keypad').css({ 'top': position.top - 56, 'left': position.left - 7 });
    //}
}

function calcTara() {
    var tara = $("#tara").val();
    var ftara = tara * 1000;
    $("#tara").val(ftara);
    calcularGramaje();
}

function calcularGramaje() {
    var tara = parseFloat($("#tara").val());
    var ancho = parseFloat($("#ancho").val());
    var metros = parseFloat($("#metros").val());
    var kg = parseFloat($("#kg").val());
    var gramaje = redondear(((kg - (tara / 1000)) * 1000) / (metros * ancho));
    var stock = parseFloat($("#stock").val().replace(/\./g,"").replace(",", "."));

    if (!cotizacion_dolar) {
        alertar("Cotizacion del Dolar debe ser Definida, contacte con Administracion");
        return;
    }

    if (metros > stock) {
        if (!isNaN(metros)) {
            alertar("Atencion! Esta intentando Fraccionar mas de lo que figura en Stock");
        }
        $("#fraccionar").attr("disabled", true);
        return;
    }

    if (isNaN(gramaje)) {
        $("#gramaje_calc").val("");
    } else {
        $("#gramaje_calc").val(gramaje);
    }
    if (gramaje > 0) {
        $("#fraccionar").removeAttr("disabled");
    } else {
        $("#fraccionar").attr("disabled", true);
    }
    var ancho_lote = parseFloat($("#anch").val().replace(",", "."));
    if (!ancho.between(ancho_lote.min(10), ancho_lote.max(10)) && !isNaN(ancho)) {
        alertar("Atencion! compruebe que el Ancho este correcto.");
        if (ancho > 10) {
            $("#fraccionar").attr("disabled", true);
        }
        return;
    } else {
        $("#msg_trab").html("");
    }

    if (!metros.between(0, 200) && !isNaN(metros)) {
        alertar("Cuidado! El corte no esta dentro del rango de fraccionamiento.");
        return;
    } else {
        $("#msg_trab").html("");
    }
    if (!kg.between(0, 400) && !isNaN(kg)) {
        $("#fraccionar").attr("disabled", true);
        alertar("Cuidado! El kilage parece ser incorrecto...");
        $("#kg").effect("shake");
        return;
    } else {
        $("#msg_trab").html("");
    }

}

function alertar(msg) {
    $("#msg_trab").html("<label style='background:white;color:red;border:solid red 1px;font-size:13px;padding:2px 4px'><img style='margin-bottom:-3px' src='img/warning_yellow_16.png'>&nbsp;" + msg + "</label>");
}

function fraccionar() {
    $("#fraccionar").attr("disabled", true);

    if (pendientes > 0) {
        alert("No se puede Fraccionar, debido a que hay Fracciones Pendientes, espere unos segundos si no se actualiza envie un email a Informatica con este lote.");
        return;
    }

    var lote = $("#lote").val();
    var codigo = $("#codigo").val();
    var tara = $("#tara").val();
    var ancho = $("#ancho").val();
    var metros = $("#metros").val();
    var kg = $("#kg").val();
    var um = $("#um").val();
    var kg_desc =  parseFloat($("#kg_desc").val().replace(/\./g,"").replace(",", "."));
    var gramaje = redondear(((kg - (tara / 1000)) * 1000) / (metros * ancho));
    var gramaje_rollo = $("#gram").val();
    var presentacion = $(".selected :nth-child(2)").text();
    var destino = $(".selected :nth-child(3)").text();
    var total_fraccionado = parseFloat($("#total_fraccionados").text());
    if (presentacion == "") {
        presentacion = "Pieza";
    }
    if (destino == "") {
        destino = "00";
    }
    $.ajax({
        type: "POST",
        url: "productos/Fraccionar.class.php",
        data: { "action": "fraccionar", codigo: codigo, lote: lote, tara: tara, ancho: ancho, fraccion: metros, kg: kg, gramaje: gramaje, usuario: getNick(), kg_desc: kg_desc, suc: getSuc(), um: um, gramaje_rollo: gramaje_rollo, presentacion: presentacion, destino: destino, total_fraccionado: total_fraccionado },
        async: true,
        dataType: "html",
        beforeSend: function() {
            $("#fila_frac").fadeIn();
            $("#msg_trab").html("<img src='img/loading_fast.gif' width='16px' height='16px' >");
        },
        complete: function(objeto, exito) {
            if (exito == "success") {
                //var hijo = $.trim((objeto.responseText)).substring(2, 50);  
                var hijo = $.trim((objeto.responseText));
                $("#nuevo_lote").val(hijo);

                $("#msg_trab").html("<img src='img/ok.png' width='20px' height='20px' >");
                $("#tr_total_fracc").before("<tr class='procesados' ><td class='lotes'>" + hijo + "</td> <td class='lotes cant_frac'>" + metros + "</td><td class='lotes'>" + presentacion + "</td><td class='lotes'>" + destino + "</td></tr>");
                procesados++;

                $("#area_trab input[type=text]:not([id=nuevo_lote])").val("");
                totalizar();
                moveScroll("-");
            }
            setMetrador(true);
        },
        error: function() {
            $("#msg_trab").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });
}

function imprimir() {
    var lote = $("#nuevo_lote").val();
    var printer = $("#printers").val();
    var silent_print = $("#silent_print").is(":checked");
    if (typeof(jsPrintSetup) == "object") {
        jsPrintSetup.setSilentPrint(silent_print);
    }
    var suc = getSuc();
    var usuario = getNick();
    var url = "barcodegen/BarcodePrinter.class.php?codes=" + lote + "&usuario=" + usuario + "&printer=" + printer + "&silent_print=" + silent_print;
    var title = "Impresion de Codigos de Barras";
    var params = "width=800,height=480,scrollbars=yes,menubar=yes,alwaysRaised = yes,modal=yes,location=no";
    window.open(url, title, params);
}

function buscarDatos() {
    $("div#mf_stock_comprometido tbody").empty();
    
    $("#msg").removeClass("error");
    $("#imprimir").attr("disabled", true);
    $("#img").fadeOut("fast");
    $("#codigo").val("");
    $("#um").val("");
    $("#suc").val("");
    $("#anch").val("");
    $("#gram").val("");
    $("#gramaje_m").val("");
    $("#gramaje_calc").val("");
    $("#descrip").val("");
    $("#kg_desc").val("");
    $("#stock").val("");
    $("#metros").val("");
    $("#kg").val("");
    $("#tara").val("");
    
    $(".ajuste").fadeOut("fast");
    $(".fila_cortes").remove();
    $("#area_frac").fadeOut();

    $.post("Ajax.class.php", { "action": "buscarStockComprometido", "lote": $("#lote").val(), suc: getSuc(), "incluir_reservas": "No" }, function(data) {
        if (data.length > 0) {
            data.forEach(function(element) {
                var tr = $("<tr/>");
                $.each(element, function(key, value) {
                    $("<td/>", {
                        "class": key,
                        "text": value
                    }).appendTo("div#mf_stock_comprometido tbody");
                });
            }, this);
            $("div#mf_stock_comprometido").show();
        } else {
            $("div#mf_stock_comprometido").hide();
            var lote = $("#lote").val();
            var suc = getSuc();
            $.ajax({
                type: "POST",
                url: "productos/Fraccionar.class.php",
                data: { "action": "buscarDatosDeLote", "lote": lote, "categoria": 1, "suc": suc }, // Utilizo la misma funcion de Factura de Ventas
                async: true,
                dataType: "json",
                beforeSend: function() {
                    $("#msg").html("<img src='img/loadingt.gif' >");
                },
                success: function(data) {
                    var mensaje = data[0].Mensaje;
                    $("#msg").attr("class", "info");
                    if (mensaje === "Ok") {
                        $("#codigo").val(data[0].Codigo);
                        $("#descrip").val(data[0].Descrip);
                        $("#stock").val(parseFloat(data[0].Stock).format(2, 3, '.', ','));

                        var ancho = parseFloat(data[0].Ancho).format(2, 3, '.', ',');
                        var gramaje = parseFloat(data[0].Gramaje).format(0, 3, '.', ',');
                        var gramaje_m = parseFloat(data[0].GramajeM).format(0, 3, ',', '.');
                        var kg_desc = parseFloat(data[0].Kg_desc).format(3, 3, ',', '.');
                        var um = data[0].UM;
                        var suc = data[0].Suc;
                        var img = data[0].Img;
                        var PrecioCosto = parseFloat(data[0].PrecioCosto);

                        $("#um").val(um);
                        $("#suc").val(suc);
                        $("#anch").val(ancho);
                        $("#ancho").val(parseFloat(data[0].Ancho).format(2, 3, '', '.'));
                        $("#gram").val(gramaje);
                        $("#gramaje_m").val(gramaje_m);
                        $("#kg_desc").val(kg_desc);
                        
                        if(um == "Unid"){
                            $(".um_princ").html("Unid");
                            $(".corte").fadeOut();
                            $("#tara").val("1");
                            $("#ancho").val("1");
                            $("#kg").val("1");
                        }else{
                            $(".um_princ").html("Metros");
                            $(".corte").fadeIn();
                        }

                        if (img != "" && img != undefined) {
                            var images_url = $("#images_url").val();
                            $("#img").attr("src", images_url + "/" + img + ".thum.jpg");
                            $("#img").fadeIn(2500);
                        } else {
                            $("#img").attr("src", "img/no_image.png");
                            $("#img").fadeIn(2500);
                        }

                        $("#msg").html("<img src='img/ok.png'>");
                        if (PrecioCosto > 0) {
                            if (getSuc() == suc) {
                                $("#area_frac").fadeIn();

                                data_next_time_flag = false;

                                //setTimeout("setDefaultDataNextFlag()",800);
                            } else {
                                $("#msg").addClass("error");
                                $("#msg").html("Esta pieza no se encuentra en esta Sucursal!, Corrobore.");
                            }
                        } else {
                            $("#msg").addClass("error");
                            $("#msg").html("Precio de costo no definido para este codigo: " + data[0].Codigo);
                        }
                        chequearPendientes();
                    } else {
                        $("#msg").addClass("error");
                        $("#msg").html(mensaje);
                        $("#lote").focus();
                        $("#lote").select();
                        $(".fila_cortes").remove();
                    }
                },
                error: function(e) {
                    $("#msg").addClass("error");
                    $("#msg").html("Error en la comunicacion con el servidor:  " + e);
                    $("#imprimir").attr("disabled", true);
                    $("#lote").select();
                }
            });

        }
    }, 'json');
}

function chequearPendientes() {
    var codigo = $("#codigo").val();
    var lote = $("#lote").val();
    var suc = getSuc();
    $.ajax({
        type: "POST",
        url: "productos/Fraccionar.class.php",
        data: { "action": "chequearFraccionesPendientes", codigo: codigo, lote: lote },
        async: true,
        dataType: "html",
        beforeSend: function() {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >");
        },
        complete: function(objeto, exito) {
            if (exito == "success") {
                pendientes = $.trim(objeto.responseText);
                if (pendientes > 0) {
                    errorMsg("Este lote tiene Fraccionamientos pendientes de Sincronizacion con SAP, espere a que se sincronice,si tarda demasiado comuniquese con informatica para solucionar el problema", 20000);
                } else {
                    $("#msg").html("");
                }
            }
        },
        error: function() {
            $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });
}
/*
function leerMetrador(){ //ttyS0
    intentos++;          
    var ip_domain = $("#metrador").val();
    var puerto = $("#puerto").val();  

    $.ajax({
        url : "http://"+ip_domain+"/serial/CP20.php?port="+puerto,
        dataType:"jsonp",
        jsonp:"mycallback", 
        beforeSend: function () {
           $("#metros").val(""); 
           $("#msg_trab").html("<img src='img/loading_fast.gif' width='20' height='20' > &nbsp;&nbsp;<label style='color:black;font-size:14px'>Conectado con: "+ip_domain+"...  </label>  "+intentos);  
        }, 
        success:function(data){
           
            var metros = data.metros;

            var total = data.total; 
           
            if(metros > 0){
               $("#metros").val(metros);               
               $("#msg_trab").html("<img src='img/Circle_Green.png' width='20' height='20' style='margin-bottom: -3px' >&nbsp;&nbsp;<label style='color:green;font-size:18px'>"+metros+"</label>");
               calcularGramaje();
               intentos = 0;
            }else{ 
              $("#msg_trab").html("<img src='img/Circle_Green.png' width='20' height='20' style='margin-bottom: -3px'>&nbsp;&nbsp;<label style='color:red;font-size:18px'>0.00</label>");
              intentos = 0;
            } 
        }
    });         
}*/
function leerDatosBalanza(id) {
    intentos++;
    var ip_domain = $("#balanza").val();

    $.ajax({
        url: "http://" + ip_domain + "/serial/Indicador_LR22.php",
        dataType: "jsonp",
        jsonp: "mycallback",
        beforeSend: function() {
            $("#" + id).val("");
            $("#msg_trab").html("<img src='img/loading_fast.gif' width='20' height='20' > &nbsp;&nbsp;<label style='color:black;font-size:14px'>Conectado con: " + ip_domain + "...  </label>    " + intentos);
        },
        success: function(data) {
            var dato = data.peso;
            var estado = data.estado;

            //$("#"+id).val(dato);  

            if (estado == "estable") {
                if (dato == "") {
                    if (intentos < 5) {
                        leerDatosBalanza();
                    } else {
                        $("#msg_trab").html("<label style='color:red;font-size:18px'>ERROR... </label>No se puede conectar con la balanza...");
                        intentos = 0;
                    }
                } else {
                    $("#msg_trab").html("<img src='img/Circle_Green.png' width='20' height='20' style='margin-bottom: -3px' >&nbsp;&nbsp;<label style='color:green;font-size:20px'>Estable</label>");
                    intentos = 0;
                    $("#" + id).val(dato);
                    if (id == "tara") {
                        calcTara();
                    } else {
                        calcularGramaje();
                    }
                }

            } else {
                $("#msg_trab").html("<img src='img/Circle_Red.png' width='20' height='20' style='margin-bottom: -3px'>&nbsp;&nbsp;<label style='color:red;font-size:20px'>Inestable</label>");
                intentos = 0;
            }
        }
    });
}



function showHideChilds(bool) {
    $("#fraccionados").toggle(bool);
    $(".scrollButtons").toggle(bool);
}

function moveScroll(sign) {
    $('#work_area').animate({
        scrollTop: "" + sign + "=100px"
    });
}

function getListaHijos() {
    var lote = $("#lote").val();
    $("#fraccionados").fadeIn();
    $(".scrollButtons").fadeIn();
    $.ajax({
        type: "POST",
        url: "productos/Fraccionar.class.php",
        data: { "action": "getFraccionados", lote: lote },
        async: true,
        dataType: "json",
        beforeSend: function() {
            $(".procesados").remove();
            $("#msg_trab").html("<img src='img/loading_fast.gif' width='16px' height='16px' >");
        },
        success: function(data) {
            $(".selected").removeClass("selected");
            for (var i in data) {
                var hijo = data[i].lote;
                var suc_destino = data[i].suc_destino;
                var cantidad = data[i].cantidad;
                var presentacion = data[i].presentacion;
                $("#tr_total_fracc").before("<tr class='procesados' ><td class='lotes'>" + hijo + "</td> <td class='lotes cant_frac'>" + cantidad + "</td><td class='lotes'>" + presentacion + "</td><td class='lotes'>" + suc_destino + "</td></tr>");
                procesados++;
            }

            totalizar();
            $("#msg_trab").html("");
        }
    });

}

function cambiarBalanza() {
    var ip = $("#balanza").val();
    setCookie("balanza", ip, 365);
}

function cambiarMetrador() {
    var ip = $("#metrador").val();
    setCookie("metrador", ip, 365);
}

function cambiarImpresora() {
    var printer = $("#printers").val();
    setCookie("printer", printer, 365);
}

function setDirectPrint() {
    var checked = $("#silent_print").is(":checked");
    setCookie("silent_print", checked, 365);
}

function totalizar() {
    var total = 0;
    $(".cant_frac").each(function() {
        var v = parseFloat($(this).text());
        total += v;
    });
    total = redondear(total, 2);
    $("#total_fraccionados").html(total);
}
Number.prototype.between = function(a, b) {
    var inclusive = true;
    var min = Math.min(a, b),
        max = Math.max(a, b);
    return inclusive ? this >= min && this <= max : this > min && this < max;
};

Number.prototype.min = function(v) {
    return this - (this * v / 100);
};
Number.prototype.max = function(v) {
    return this + (this * v / 100);
};

function checkearCotizDolar() {
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: { "action": "verificarCotizMoneda", "moneda": "U$" },
        async: true,
        dataType: "html",
        beforeSend: function() {
            $("#msg").html("Verificando cotizacion Dolar...<img src='img/loading_fast.gif' width='18px' height='18px' >");
        },
        complete: function(objeto, exito) {
            if (exito == "success") {
                var result = $.trim(objeto.responseText);
                if (result == "0") {
                    cotizacion_dolar = false;
                    errorMsg("Se requiere establecer cotizacion del Dolar para el dia de la Fecha,contacte con Administracion.", 100000);
                    alertar("Se requiere establecer cotizacion del Dolar,contacte con Administracion.");

                } else {
                    cotizacion_dolar = true;
                }
                $("#msg").html("");
            }
        },
        error: function() {
            $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });
}

function configurePrinter() {
    if (typeof(jsPrintSetup) == "object") {
        if (jsPrintSetup.getPrintersList() == null) {
            alert("Sr. Usuario haga clic en el boton 'Permitir' que se encuentra en la parte superior derecha, y recargue la pagina.");
            return;
        }
        var printer_list = (jsPrintSetup.getPrintersList()).split(",");
        $.each(printer_list, function(number) {
            $("#printers").append('<option>' + printer_list[number] + '</option>');
        });
        jsPrintSetup.definePaperSize(100, 100, "Custom", "Etiqueta_Marijoa", "Etiqueta Marijoa", 60, 40, jsPrintSetup.kPaperSizeMillimeters);
        //jsPrintSetup.setPaperSizeData(100);
        //jsPrintSetup.definePaperSize(101, 101, "Custom", "Etiqueta_Marijoa 10x5", "Etiqueta Marijoa 10x5", 100, 50, jsPrintSetup.kPaperSizeMillimeters);  
        jsPrintSetup.setOption('marginTop', 0);
        jsPrintSetup.setOption('marginBottom', 0);
        jsPrintSetup.setOption('marginLeft', 0);
        jsPrintSetup.setOption('marginRight', 0);
        jsPrintSetup.setPaperSizeData(100);

        var printer = getCookie("printer").sesion;
        $("#printers").val(printer);

        var sp = getCookie("silent_print").sesion;
        if (sp == "true") {
            $("#silent_print").prop("checked", true);
        } else {
            $("#silent_print").prop("checked", false);
        }

        $("#silent_print").click(function() {
            var print_silent = $(this).is(":checked");
            jsPrintSetup.setSilentPrint(print_silent);
            setDirectPrint();
        });

    } else {
      // alert("Este navegador necesita de un Plug in 'js print setup' para mejor funcionamiento, considere instalarlo en Herramientas -> Complementos Busque 'js print setup' e instalelo, posteriormente reinicie su navegador y vuelva a intentarlo, si el problema persiste contacte con el administrador del sistema :D");
    }
}


// Metrador

function setMetrador(reset) {
    var IP = $("select#metrador option:selected").val();
    var port = $("select#puerto option:selected").val();
    var mts = (reset || $.trim($("input#corte").val()) == '') ? '9999,99' : $("input#corte").val();
    $("div#metradorMsj").html("<img src='img/loading_fast.gif' width='20' height='20' >");
    $("div#metradorMsj").removeClass("error");

    $.get("http://" + IP + "/serial/CP20.php", { "action": "set", "port": port, "mts": mts }, function(data) {
        if (!data.error) {
            $("div#metradorMsj").text("Ok");
        } else {
            $("div#metradorMsj").text(data.error);
            $("div#metradorMsj").addClass("error");
        }
    }, "jsonp").fail(function() {
        $("div#metradorMsj").text("Error de comunicacion IP:" + IP + ", Puerto:" + port);
        $("div#metradorMsj").addClass("error");
    });
}

function leerMetrador() {
    var IP = $("select#metrador option:selected").val();
    var port = $("select#puerto option:selected").val();
    $("#msg_trab").html("<img src='img/loading_fast.gif' width='20' height='20' >");
    
    $.get("http://" + IP + "/serial/CP20.php", { "action": "get", "port": port }, function(data) {
        var getMts = parseFloat(data.metros);
        $("#metros").val(getMts);
    }, "jsonp").fail(function() {
        $("#msg_trab").html("Error de comunicacion IP:" + IP + ", Puerto:" + port);
    });
}

function tieneStockComprometido() {
    $("div#mf_stock_comprometido tbody").empty();

    $.post("Ajax.class.php", { "action": "buscarStockComprometido", "lote": $("#lote").val(), suc: getSuc(), "incluir_reservas": "No" }, function(data) {
        if (data.length > 0) {
            data.forEach(function(element) {
                var tr = $("<tr/>");
                $.each(element, function(key, value) {
                    $("<td/>", {
                        "class": key,
                        "text": value
                    }).appendTo("div#mf_stock_comprometido tbody");
                });
            }, this);
            $("div#mf_stock_comprometido").show();
            return true;
        } else {
            $("div#mf_stock_comprometido").hide();
            return false;
        }
    }, 'json');

}