var abm_cliente = null;
var fecha_nac = "0000-00-00";
var data_next_time_flag = true;
var nro_nota = 0;
var flag = false;
var moneda_cliente = "G$";
var moneda = "G$";
var decimales = 0;
var total_nota_credito = 0;


function preConfigurar() {

    $("#ruc_cliente").click(function() { $(this).select(); });

    // Ruc para nuevo cliente
    $("#ruc").change(function() {
        var pais = $(this).val();
        if (pais != 'PY') {
            $("#ruc").mask("r99?rrrrrrr", { placeholder: "" });
        } else {
            $("#ruc").mask("999?rrrrrrr", { placeholder: "" });
        }
    });
    $("#nombre_cliente").click(function() { $(this).select(); });
    $("#nombre_cliente").keyup(function() {
        //limpiarLista();
    });
    $("#ruc_cliente").keyup(function() {
        //limpiarLista();
    });
    inicializarCursores("clicable");
    setTimeout('$("#ruc_cliente").focus()', 500);

    $(".clicable").click(function() {
        var nro_nota = $(this).parent().attr("id").substring(3, 20);
        var factura = $(this).parent().attr("data-factura");
        //var moneda = $(this).parent().attr("data-moneda");
        cargarNotaCredito(nro_nota, factura);
        setTimeout('checkData()',2000);
        
    });
    moneda = $("#moneda").val();
    if (moneda != 'G$') {
        decimales = 2;
    }    
}
function cerrar() {
    $("#ui_clientes").fadeOut("fast");
    $("#boton_generar").fadeOut("fast");
}

function ocultar() {
    $("#boton_generar").fadeOut("fast");
}

function mostrar() {
    buscarFacturasDeCliente();
}

function seleccionarCliente(obj) {
    var cliente = $(obj).find(".cliente").html();
    var ruc = $(obj).find(".ruc").html();
    var codigo = $(obj).find(".codigo").html();
    var cat = $(obj).find(".cat").html();

    $("#ruc_cliente").val(ruc);
    $("#nombre_cliente").val(cliente);
    $("#codigo_cliente").val(codigo);
    $("#categoria").val(cat);
    $("#ui_clientes").fadeOut("fast");
    $("#msg").html("");
    buscarFacturasDeCliente();
    //$("#boton_generar").fadeIn(); // Habilitar boton generar factura 
}

function buscarFacturasDeCliente() {
    var cli_cod = $("#codigo_cliente").val();
    $(".fila_factura").remove();
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: { action: "buscarFacturasDeCliente", "cod_cli": cli_cod },
        async: true,
        dataType: "json",
        beforeSend: function() {
            $("#msg").html("<img src='img/loading_fast.gif' width='22px' height='22px' >");
        },
        success: function(data) {
            $("#factura").append("<optgroup class='fila_factura' label='N&deg;Factura Fecha Valor Total'>");
            cont = 0;
            for (var i in data) {
                cont++;
                var factura = data[i].factura;
                var fecha = data[i].fecha;
                var fecha_ing = data[i].fecha_ing;
                var moneda_factura = data[i].moneda;
                var total = parseFloat((data[i].total)).format(2, 3, ".", ",");
                $("#facturas").append("<option class='fila_factura' value='" + factura + "' id='factura_" + factura + "'  data-fecha='" + fecha_ing + "' data-moneda='" + moneda_factura + "' >" + factura + "               <b>Fecha:</b> [" + fecha + "]   <b>Total:</b> " + total + "</option>");
            }
            if (cont > 0) {
                $("#boton_generar").fadeIn();
            } else {
                ocultar();
            }
            $("#msg").html("");
        }
    });
}

function guardarDetalleNotaCredito(obj) {

    var nro_nota = $("#nro_nota_credito").val();
    var codigo = $(obj).attr("data-codigo");
    var lote = $(obj).attr("data-lote");
    var precio = $(obj).attr("data-precio");
    var um_prod = $(obj).attr("data-um");
    var descrip = $(obj).attr("data-descrip");
    var cant_dev = $(obj).val();

    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: { "action": "guardarDetalleNotaCredito", nro_nota: nro_nota, codigo: codigo, lote: lote, precio: precio, cant_dev: cant_dev, um_prod: um_prod, descrip: descrip },
        async: true,
        dataType: "html",
        beforeSend: function() {
            $(obj).parent().next().next().html("<img src='img/loading_fast.gif' width='16px' height='16px' >")
        },
        complete: function(objeto, exito) {
            if (exito == "success") {
                var result = $.trim(objeto.responseText);
                $(obj).parent().next().next().html("<img src='img/ok.png' width='16px' height='16px' >")
            }
        },
        error: function() {
            $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });

}

function crearNotaCredito() {
    var factura = $("#facturas").val();
    if (factura > 0) {
        $("#factura").val(factura);
        $("#facturas").fadeOut();
        $("#factura").fadeIn();
        ocultar();
        $("#area_carga").fadeIn();
        guardarNotaCredito(factura);
        $(document).off("keydown");
        var fecha_factura = $("#facturas option:selected").attr("data-fecha");
        $("#fecha_factura").val(fecha_factura);
    } else {
        $("#nombre_cliente").focus();
    }
}

function guardarNotaCredito(factura) {

    var usuario = getNick();
    var suc = getSuc();
    var factura = $("#factura").val();
    var cod_cli = $("#codigo_cliente").val();
    var fuera_rango = $("#fuera_rango").val();
    moneda = $("#factura_" + factura).attr("data-moneda");
    if (moneda != 'G$') {
        decimales = 2;
    }

    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: { "action": "generarNotaCredito", usuario: usuario, suc: suc, factura: factura, cod_cli: cod_cli, req_auth: fuera_rango, moneda: moneda },
        async: true,
        dataType: "html",
        beforeSend: function() {
            $("#msg").html("<img src='img/loading.gif' width='22px' height='22px' >");
        },
        complete: function(objeto, exito) {
            if (exito == "success") {
                var nro_nota = $.trim(objeto.responseText);
                $("#nro_nota_credito").val(nro_nota);
                $(".nota").fadeIn();
                buscarDetallesFactura(factura, nro_nota, true);
                $("#ruc_cliente").attr("readonly", "readonly");
                $("#nombre_cliente").attr("readonly", "readonly");
                getNotasCreditoContables();
            }
        },
        error: function() {
            $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });
}

function finalizar() {
    if (flag) {
        $("#msg").removeClass("errorgrave");
        $("#msg").html("");

        var ncl = $("#nota_credito_contable").val();


        if (total_nota_credito > 0 && (!isNaN(total_nota_credito)) && flag) {

            var fuera_rango = $("#fuera_rango").val();

            if (fuera_rango == "false"/* && facturaContable && nota_credito_contable != null*/) { // Recien Imprimir cuando esta autorizada y si tiene factura factura contable asociada
                $(".print").fadeIn();
                actualizarCabeceraNotaCredito('Cerrada');
            } else {
                actualizarCabeceraNotaCredito('Pendiente');
            }

        } else {
            $(".print").fadeOut();
            actualizarCabeceraNotaCredito('Abierta');
        }
        $(".cant_dev").attr("readonly", "readonly");

    } else {
        $("#msg").addClass("errorgrave");
        $("#msg").html("Corrija las Cantidades");
    }
    if (ncl == null) {
        $("#imprimir_nc_legal").fadeOut();
    }
}

function actualizarCabeceraNotaCredito(estado) {
    var nro_nota = $("#nro_nota_credito").val();
    var fuera_rango = $("#fuera_rango").val();
    var genCajaMov = $("input#generarMovimientoCaja").is(":checked");
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: { "action": "actualizarCabeceraNotaCredito", "nro_nota": nro_nota, "req_auth": fuera_rango, "estado": estado,"genCajaMov":genCajaMov },
        async: true,
        dataType: "html",
        beforeSend: function() {
            $("#msg").html("<img src='img/loading.gif' width='22px' height='22px' >");
        },
        complete: function(objeto, exito) {
            if (exito == "success") {
                var result = $.trim(objeto.responseText);
                if (result == 'Abierta') {
                    alert("La nota de Credito ha quedado en estado Abierta, hasta que se complete el procedimiento o se carguen productos.");
                }
                if (result == 'Pendiente') {
                    alert("La nota de Credito ha quedado en estado Pendiente, se requiere autorizacion para finalizar la transaccion.");
                } else {
                    alert("La nota de Credito ha sido Cerrada con Exito.");
                }
                getNotasCreditoContables();
                $("#msg").html("");
                $("#finalizar").fadeOut();
                $("#atras").fadeIn();
            }
        },
        error: function() {
            $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });
}

function buscarDetallesFactura(factura, nro_nota, comparar_fechas) {

    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: { "action": "buscarDetallesFacturaNotaCredito", factura: factura, nro_nota: nro_nota },
        async: true,
        dataType: "json",
        beforeSend: function() {
            $("#msg").html("<img src='img/loading_fast.gif' width='18px' height='18px' >");
        },
        success: function(data) {
            var total = 0;
            for (var i in data) {
                var codigo = data[i].codigo;
                var lote = data[i].lote;
                var um_prod = data[i].um_prod;
                var descrip = data[i].descrip;
                var um_cod = data[i].um_cod;
                var cantidad = data[i].cantidad;
                //var precio_venta = parseFloat(data[i].precio_venta).format(decimales, 3, ".", ",");
                var pn = parseFloat((data[i].subtotal/data[i].cantidad));
                var precio_venta = parseFloat(pn).format(decimales, 3, ".", ",");
                var precio_neto = parseFloat(data[i].precio_neto).format(decimales, 3, ".", ",");
                var subtotal = parseFloat(data[i].subtotal).format(decimales, 3, ".", ",");
                var sum_cant_dev_ant = data[i].sum_cant_dev_ant;
                if (sum_cant_dev_ant == null) {
                    sum_cant_dev_ant = 0;
                }

                var max_cant_dev = cantidad - sum_cant_dev_ant;

                var cant_dev = data[i].cant_dev;
                var subtotal_dev = parseFloat(data[i].subtotal_dev).format(decimales, 3, ".", ",");
                if (cant_dev == null) {
                    cant_dev = 0;
                    subtotal_dev = 0;
                }
                // Para sumar
                var sbt = parseFloat(data[i].subtotal);
                total += sbt;
                
                $(".tr_total_factura").before('<tr id="tr_' + lote + '"><td class="item codigo_lote" >' + lote + '</td><td class="item">' + descrip + '</td><td class="num cantidad" id="cant_vend_' + lote + '">' + cantidad + '</td><td  class="itemc">' + um_cod + '</td> <td class="num" id="precio_venta_' + lote + '">' + precio_venta + '</td><td class="num">' + subtotal + '</td><td class="num" id="cant_max_dev_' + lote + '" >' + max_cant_dev + '</td>\n\
                <td class="itemc" style="width:60px"><input type="text" id="dev_' + lote + '" data-codigo="' + codigo + '" data-lote="' + lote + '" data-precio="' + pn + '" data-um="' + um_prod + '" data-descrip="' + descrip + '" class="cant_dev num" size="8" maxlength="10" value="' + cant_dev + '" ></td><td style="width:120px" class="num subtotal_dev_" id="subtotal_dev_' + lote + '">' + subtotal_dev + '</td><td class="itemc"></td></tr>');
            }

            $("#total_factura").html(moneda + ". " + (total).format(decimales, 3, ".", ","));
            $("#msg").html("");
            $("#area_carga").fadeIn();
            
            $(".cant_dev").change(function() {
                var lote = $(this).attr("data-lote");

                var cantv = parseFloat($("#cant_vend_" + lote).html());
                var precio_venta = parseFloat($("#precio_venta_" + lote).html().replace(/\./g, '').replace(/\,/g, '.'));
                //var cant_dev =  ($(this).val()).replace(/\./g, '').replace(/\,/g, '.');
                var cant_dev = $(this).val();
                var valor_dev = (precio_venta * cant_dev).format(decimales, 3, ".", ",");

                var cant_max_dev = parseFloat($("#cant_max_dev_" + lote).html());

                console.log(cant_dev + "   " + cant_max_dev);
                if (cant_dev > cant_max_dev) {
                    $(this).addClass("error_cant");
                    $("#msg").addClass("errorgrave");
                    $("#msg").html("Ingrese una cantidad menor");
                    $(this).focus().select();
                    flag = false;
                } else {
                    $(this).removeClass("error_cant");
                    $("#msg").removeClass("errorgrave");
                    $("#msg").html("");
                    flag = true;
                    guardarDetalleNotaCredito(this);
                }
                $("#subtotal_dev_" + lote).html(valor_dev);

                // Check data
                checkData();

                sumar();
            });
            $(".cant_dev").focus(function() { $(this).select() });
            if (comparar_fechas) {

                var start = new Date($("#fecha_factura").val());
                var end = new Date($('#fecha_hoy').val());

                var diff = new Date(end - start);

                var horas = diff / 1000 / 60 / 60;
                //console.log(end+"   "+start+"   Differencia en dias "+horas);
                if (horas > 48) {
                    $("#msg").addClass("errorgrave");
                    $("#msg").html("<br>&nbsp;&nbsp;&nbsp;&nbsp;Esta factura ha superado el limite de tiempo de 48 horas para Devolucion, requerir&aacute; autorizaci&oacute;n! para finalizar");
                    $("#fuera_rango").val("true");
                } else {
                    $("#fuera_rango").val("false");
                }
            }
            $(".cant_dev").mask("9?fffff", { placeholder: "" });
            $("#div_guardar").fadeIn();

            sumar();
        }
    });
}

function sumar() {
    total_nota_credito = 0;
    $(".subtotal_dev_").each(function() {
        var s = parseFloat($(this).html().replace(/\./g, '').replace(/\,/g, '.'));
        if (!isNaN(s)) {
            total_nota_credito += s;
        }
    });
    $("#total_dev").html(moneda + ". " + (total_nota_credito).format(decimales, 3, ".", ","));
}

function imprimirNotaCredito() {
    var factura = $("#factura").val();
    var suc = getSuc();
    var tipo = $("#tipo").val();

    var nro_nota = $("#nro_nota_credito").val();
    //var paper_size = $('input[name=paper_size]:checked').val();
    var usuario = getNick();
    var params = "width=800,height=760,scrollbars=yes,menubar=yes,alwaysRaised = yes,modal=yes,location=no";
    var url = "notas_credito/ImprimirNotaCredito.class.php?nro_nota=" + nro_nota + "&suc=" + suc + "&factura=" + factura + "&paper_size=9&usuario=" + usuario + "&moneda=" + moneda;
    var title = "Nota de Credito";
    window.open(url, title, params);
}

function imprimirNotaCreditoLegal() {
    var nota_credito_contable = $("#nota_credito_contable").val();

    var tipo_doc = "Nota de Credito";
    var pdv = $("#nota_credito_contable option:selected").attr("data-pdv");
    var suc = getSuc();

    if (nota_credito_contable != null) {
        var nro_nota = $("#nro_nota_credito").val();
        var factura = $("#factura").val();
        var ruc = $("#ruc_cliente").val();
        var cliente = $("#nombre_cliente").val();

        var usuario = getNick();
        var papar_size = 9; // Dedocratico A4
        var tipo_fact = $("#tipo_fact").val();

        var url = "notas_credito/ImpresorNotaCredito.class.php?nro_nota=" + nro_nota + "&factura=" + factura + "&ruc=" + ruc + "&cliente=" + cliente + "&suc=" + suc + "&nota_credito_contable=" + nota_credito_contable + "&usuario=" + usuario + "&papar_size=" + papar_size + "&tipo_doc=" + tipo_doc + "&pdv=" + pdv + "&man_pre=" + tipo_fact + "&moneda=" + moneda;
        var title = "Impresion de Facturas Contables";
        var params = "width=800,height=840,scrollbars=yes,menubar=yes,alwaysRaised = yes,modal=yes,location=no";
        if (typeof(showModalDialog) === "function") { // Firefox
            window.showModalDialog(url, title, params);
        } else {
            window.open(url, title, params);
        }

    } else {
        alert("Debe Pre cargar las Facturas Contables para poder Imprimir");
    }
}

function getNotasCreditoContables() {
    var suc = getSuc();
    var tipo_fact = $("#tipo_fact").val();
    if (tipo_fact == "Pre-Impresa" || tipo_fact == undefined) {
        tipo_fact = "Pre";
    } else {
        tipo_fact = "Man";
    }

    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: { "action": "getFacturasContables", "suc": suc, tipo_fact: tipo_fact, tipo_doc: "Nota de Credito", moneda: moneda },
        async: true,
        dataType: "json",
        beforeSend: function() {
            $("#loading_facts").fadeIn();
        },
        success: function(data) {
            $("#factura_contable").empty();
            var cont = 0;
            for (var i in data) {
                var fact_cont = data[i].fact_nro;
                var pdv_cod = data[i].pdv_cod;
                console.log(fact_cont + "   " + pdv_cod);
                $("#nota_credito_contable").append("<option value='" + fact_cont + "' data-pdv='" + pdv_cod + "'>" + fact_cont + "</option>");
                cont++;
            }
            $("#loading_facts").fadeOut();
            if (cont == 0) {
                $("#imprimir_nota_credito").fadeOut();
                alert("Debe cargar Notas de Credito Contables en el sistema para poder Imprimir.");
            }
        }
    });
}

function getPassword(id) {
    nro_nota = id;
    var position_tr = $("#nc_" + id).offset();
    var pie = $("#auth_" + id).width() / 2;
    var width = $("#verificar").width() / 2;
    var boton = $("#auth_" + id).position();
    var top = position_tr.top;

    $("#verificar").css("margin-left", boton.left + pie - width);
    $("#verificar").css("margin-top", top - 44);
    $("#verificar").fadeIn();
    $("#passw").focus();
}

function autorizar() {

    var passw = $("#passw").val();
    var usuario = getNick();
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: { "action": "autorizarNotaCredito", "usuario": usuario, "passw": passw, nro_nota: nro_nota },
        async: true,
        dataType: "html",
        beforeSend: function() {
            $("#msg_pw").html("<img src='img/loading_fast.gif' width='20px' height='20px' >");
        },
        complete: function(objeto, exito) {
            if (exito == "success") {
                var result = $.trim(objeto.responseText);
                if (result == "Ok") {
                    $("#verificar").addClass("info");
                    $("#verificar").html("Autorizado! La Ventana se Recargara en 4 Segundos!!!");

                    setTimeout('genericLoad("notas_credito/NotasCreditoAbiertas.class.php")', 4000);

                } else {
                    $("#msg_pw").addClass("errorgrave");
                    $("#msg_pw").html(result);
                }
            }
        },
        error: function() {
            $("#msg_pw").addClass("errorgrave");
            $("#msg_pw").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });
}


function eliminarNotaCredito(nro_nota) {
    var c = confirm("Confirme �Eliminar esta nota de Nota de Credito?");
    if (c) {
        $.post("Ajax.class.php", { action: "eliminarNotaCredito", nro_nota: nro_nota }, function(data) {
            genericLoad("notas_credito/NotasCreditoAbiertas.class.php");
        });
    }
}

function checkData() {
    $("#finalizar").attr("disabled", "disabled");
    if ($("input.cant_dev:not(.error_cant)").length === $("input.cant_dev").length) {
        var cant_mod = 0;
        $("input.cant_dev").each(function() {
            cant_mod += parseFloat(isNaN(eval($(this).val())) ? 0 : $(this).val());
        });
        if (cant_mod > 0) {
            $("#finalizar").removeAttr("disabled");
        }
    }
}