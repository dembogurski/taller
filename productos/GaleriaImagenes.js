function configurar() {
    console.log("start");
    $.ajaxSetup({
        beforeSend: function() {
            $('div.loader').show();
        },
        complete: function(html) {
            $('div.loader').hide();
        }
    });
}

/**
 * Obtiene sugerencias de busqueda.
 */

function getHits() {
    var searchParam = $("#gal_seach_key").val();
    if (2 < searchParam.length) {
        var sendParam = { "action": "getNCHits", "args": searchParam };
        $.post("productos/GaleriaImagenes.class.php", sendParam, function(data) {
            $("#searchHits").empty();
            $.each(data, function(key, val) {
                $("<li/>", {
                    "text": val.nombreComercial,
                    "onclick": "Go($(this))"
                }).appendTo("#searchHits");
            });
        }, "json");
        $("#searchHits").css("display", "block");
    }
}
// Paso previo a la creacion de la galeria
function Go(target) {
    var vSet = target || false;
    var _target = (vSet === false) ? $("#gal_seach_key").val() : target.text();
    if (($("#searchHits").css("display")) == "none" && vSet !== false) {
        $("#searchHits").css("display", "block");
    } else {
        $("#searchHits").css("display", "none");
        $("#gal_seach_key").val(_target);
        if ($.trim($("#gal_seach_key").val()).length > 0) {
            var searchParam = $("#gal_seach_key").val() + ',' + $("#f_stock").val();
            getSucs(searchParam);
        }
    }
}
// Cargar Sucursales
function getSucs(param) {
    $("div#galeria_msj").empty();
    var sendParam = { "action": "getSucXPod", "args": param };
    var d = '';
    $.post("productos/GaleriaImagenes.class.php", sendParam, function(data) {
        // Agrega Lista de Sucursales
        if(data.error || data.length == 0){
            if(data.error){
                $("div#galeria_msj").html(data.error);
            }else{
                $("div#galeria_msj").html("Error de comunicación");
            }
        }else{
            $("#f_suc").empty();
            var sucs = ['%'];
            data.forEach(function(i) {
                sucs.push(i);
            });
            sucs.sort()
            for (s in sucs) {
                var op = $("<option/>");
                $("<div/>", {
                    "text": sucs[s]
                }).appendTo(op);
                $("#f_suc").append(op);
            }
            getColors();
        }
    }, "json").fail(function(){$("div#galeria_msj").html("Error de comunicación");});
}
// Cargar Colores
function getColors() {
    var param = $("#gal_seach_key").val() + ',' + $("#f_suc").val() + ',' + $("#f_stock").val();
    var sendParam = { "action": "getColorXPodXSuc", "args": param };
    var d = '';
    $.post("productos/GaleriaImagenes.class.php", sendParam, function(data) {
        // Agrega lista de Colores
        $("#f_color").empty();
        $("<option/>", { "value": "%", "text": "%" }).appendTo("#f_color");

        $.each(data, function(key, value) {
            var op = $("<option/>", { "value": key, "text": value });
            $("#f_color").append(op);
        });
        getDisenos();
    }, "json");
}
// Cargar Disemhos
function getDisenos(){
    var param = $("#gal_seach_key").val() + ',' + $("#f_suc").val() + ',' + $("#f_color").val() + ',' + $("#f_stock").val()+ ',' + $("#f_dfp").is(":checked");
    var sendParam = { "action": "getDisenoXProdXSucXColor", "args": param };
    var d = '';
    $.post("productos/GaleriaImagenes.class.php", sendParam, function(data) {
    // Agrega lista de Colores
    $("#f_diseno").empty();
    $("<option/>", { "value": "%", "text": "%" }).appendTo("#f_diseno");

    $.each(data, function(key, value) {
        var op = $("<option/>", { "value": key, "text": value });
        $("#f_diseno").append(op);
        updateFilters();
    });
    
    }, "json");
}

// Crea la galeria
function getResult() {
    var param = $("#gal_seach_key").val() + ',' + $("#f_suc").val() + ',' + $("#f_color").val() + ',' + $("#f_diseno").val() + ',' + $("#f_stock").val() + ',' + $("#f_dfp").is(":checked") +',' + $("#f_term").val() ;
    var sendParam = { "action": "getProd", "args": param };
    var d = '';

    //console.log("N");
    $.post("productos/GaleriaImagenes.class.php", sendParam, function(data) {
        responceData = data;
        filteredData = data;
        getGallery(data);
    }, "json");
}
// Abre ventana de vista previa 
function openImgPopUp(pos) {
    var imgWidth = $(window).width() > 720 ? 720 : 302;
    var url = imgURI + filteredData[pos].Img + '.jpg';
    var precio = 0;
    var descuento = 0;
    var show = false;
    var data = 0;
    $("#popUpImageInfo").empty();
    $("#popUpImageExtraInfo tbody").empty();
    
    // Filtro Información panel izquierdo
    for (h in filteredData[pos]) {
        switch (h) {
            case 'Desc1':
                descuento = parseFloat(filteredData[pos][h]);
                show = false;
                break;
            case 'Precio':
                precio = parseFloat(filteredData[pos][h]);
                show = false;
                break;
            case 'Ubic':
            case 'Reserva':
                show = false;
                break;
            default:
                show = true;
        }
        if (show) {
            var div = $("<div/>");
            $("<label/>", {
                "text": (h.replace(/[A-Z]/g, function(x) { return ' ' + x.toUpperCase(); })).trim() + ": "
            }).appendTo(div);
            $("<span/>", {
                "id": '_' + h.toLowerCase(),
                "text": filteredData[pos][h]
            }).appendTo(div);
            $("#popUpImageInfo").append(div);
        }
    }
    
    // Agrega precio1
    if (precio > 0) {
        var div = $("<div/>");
        $("<label/>", {
            "text": "Precio 1: "
        }).appendTo(div);
        $("<span/>", {            
            //"text": (descuento > 0) ? Math.ceil(precio - (precio * (descuento / 100))) : Math.ceil(precio + (precio * (descuento / 100)))
            "text": Math.round(precio - (precio * (descuento / 100)))
        }).appendTo(div);
        $("#popUpImageInfo").append(div);
    }
    // Tabla Hijos
    for (ex in filteredData) {
        var colorCod = $("#_colorcode").text();
        var itemCod = $("#_itemcode").text();
        // Verificación de Igualdad
        if (filteredData[ex].ItemCode == itemCod && filteredData[ex].ColorCode == colorCod && filteredData[ex].Img == filteredData[pos].Img) {
            var tr = $("<tr/>");
            $("<td/>", {
                "text": filteredData[ex].Lote
            }).appendTo(tr);
            $("<td/>", {
                "text": filteredData[ex].Padre
            }).appendTo(tr);
            $("<td/>", {
                "text": filteredData[ex].Stock
            }).appendTo(tr);
            $("<td/>", {
                "text": filteredData[ex].Suc
            }).appendTo(tr);
            $("<td/>", {
                "text": filteredData[ex].Ubic
            }).appendTo(tr);
            $("<td/>", {
                "text": filteredData[ex].CodigoColorFabrica
            }).appendTo(tr);
            $("<td/>", {
                "text": filteredData[ex].fdp
            }).appendTo(tr);
            if(filteredData[ex].Reserva.length > 0){
                var td = $("<td/>", {
                    "text": 'Ver',
                    "onclick":"verReserva($(this))"
                });
                var div = $("<div/>",{
                    "class":"clistaReserva"
                });
                var ul = $("<ul/>");
                filteredData[ex].Reserva.forEach(function(valor,i){
                    $("<li/>",{"text":valor.suc+': '+valor.cantidad}).appendTo(ul);
                });
                ul.appendTo(div);
                div.appendTo(td);
                td.appendTo(tr);
            }else{
                $("<td/>", {
                    "text": 'N/A'
                }).appendTo(tr);
            }
            $("#popUpImageExtraInfo tbody").append(tr);
        }
    }
    $("#popUpImage").empty();
    $("<img/>", {
        "src": url,
        "alt": "No se encontro la imagen",
        "height": "100%",
        "width": "100%", //imgWidth,
        "onerror":"noImage($(this))",
        "onclick": "openImgPopUpEx($(this))"
    }).appendTo("#popUpImage");
    $("#popUpImageFrame").show();
    $("#back_arrow").hide();
}

function verReserva(target){    
    var current = target.find("div.clistaReserva");
    if(current.is(":visible")){
        current.hide();
    }else{
        $("div.clistaReserva").hide();
        current.show();
    }
}
// Genera la galeria
function getGallery(data) {
    $("#gal_body").empty();
    $("#popUpImageMenu").empty();
    for (prod in data) {
        var _id = data[prod].ItemCode + '_' + data[prod].ColorCode + '_' + data[prod].Img.replace('/', '_');
        var id = "cod_" + MD5(_id);
        var lotes = $("#" + id).length
            // Imagen
        if (lotes == 0) {
            var div = $("<div/>", { "id": id, "data-position": prod }); // Principal
            // Cabecera 
            $("<span/>", {
                "text": data[prod].ItemCode + ' - ' + data[prod].Sector
            }).appendTo(div);
            $("<span/>", {
                "class": "codigos",
                "text": "Lotes: 1",
                "data-lotes": 1
            }).appendTo(div);
            // Imagen
            $("<img/>", {
                "src": imgURI + data[prod].Img + '.thum.jpg',
                "alt": "No se encontro la imagen",
                "height": "160",
                "width": "240",
                "onerror":"noImage($(this))",
                "onclick": "openImgPopUp(" + prod + ")"
            }).appendTo(div);
            // Pie
            $("<span/>", {
                "text": data[prod].NombreComercial + ' - ' + data[prod].Color
            }).appendTo(div);
            // Agrega la cuerpo de la galeria                
            $("#gal_body").append(div);
            // Genera menu con miniaturas para el popUp
            var imgConten = $("<div/>", {
                "data-info": data[prod].ItemCode + ' - ' + data[prod].Sector + ' - ' + data[prod].NombreComercial + ' - ' + data[prod].Color
            });
            $("<img/>", {
                "src": imgURI + data[prod].Img + '.thum.jpg',
                "alt": data[prod].ItemCode + ' - ' + data[prod].Sector + ' - ' + data[prod].NombreComercial + ' - ' + data[prod].Color,
                "height": "60",
                "width": "80",
                "onerror":"noImage($(this))",
                "onclick": "openImgPopUp(" + prod + ")"
            }).appendTo(imgConten);
            imgConten.appendTo("#popUpImageMenu");
        } else {
            var current = parseInt($("#" + id + " .codigos").attr("data-lotes")) + 1;
            $("#" + id + " .codigos").html("Lotes: " + current);
            $("#" + id + " .codigos").attr("data-lotes", current);
        }
    }
    $('div.loader').hide();
}

function noImage(Obj){
    Obj.prop("src",imgURI+"0/0.jpg")
}

// Aplica Filtros de resultado
function updateFilters() {
    var filter = [];
    var suc = $("#f_suc option:selected").val();
    var color = $("#f_color option:selected").val();
    var stock = $("#f_stock").val();
    var disenho = $("#f_diseno option:selected").text();
    var f_term = $("#f_term").val();

    if (suc !== '%') { filter.push("n.Suc === '" + suc + "'"); }
    if (color !== '%') { filter.push(" n.ColorCode === '" + color + "'"); }
    if (!isNaN(stock)) { filter.push(" n.Stock > " + stock); }
    if (disenho !== '%') { filter.push(" n.Disenho === '" + disenho + "'"); }
    filter.push(" n.Stock > " + stock); 


    var filtros = filter.join(' && '); //"n.ItemCode==='H0027' && n.Color==='ROJO' && n.Stock>0";
    //console.log(filtros);
    var as = $(responceData).filter(function(i, n) { return eval(filtros) });
    filteredData = as.toArray();
    getGallery(filteredData);
}
// Cierra popUP
function closeImgPopUp() {
    $("#popUpImageFrame").hide();
    $("#back_arrow").show();
}
// Abre el popUp Externo
function openImgPopUpEx(target) {
    window.open(target.attr("src"), "_blank", "toolbar=No,scrollbars=yes,resizable=yes");
}

// MD5
var MD5 = function(s) {
    function L(k, d) { return (k << d) | (k >>> (32 - d)) }

    function K(G, k) { var I, d, F, H, x;
        F = (G & 2147483648);
        H = (k & 2147483648);
        I = (G & 1073741824);
        d = (k & 1073741824);
        x = (G & 1073741823) + (k & 1073741823); if (I & d) { return (x ^ 2147483648 ^ F ^ H) } if (I | d) { if (x & 1073741824) { return (x ^ 3221225472 ^ F ^ H) } else { return (x ^ 1073741824 ^ F ^ H) } } else { return (x ^ F ^ H) } }

    function r(d, F, k) { return (d & F) | ((~d) & k) }

    function q(d, F, k) { return (d & k) | (F & (~k)) }

    function p(d, F, k) { return (d ^ F ^ k) }

    function n(d, F, k) { return (F ^ (d | (~k))) }

    function u(G, F, aa, Z, k, H, I) { G = K(G, K(K(r(F, aa, Z), k), I)); return K(L(G, H), F) }

    function f(G, F, aa, Z, k, H, I) { G = K(G, K(K(q(F, aa, Z), k), I)); return K(L(G, H), F) }

    function D(G, F, aa, Z, k, H, I) { G = K(G, K(K(p(F, aa, Z), k), I)); return K(L(G, H), F) }

    function t(G, F, aa, Z, k, H, I) { G = K(G, K(K(n(F, aa, Z), k), I)); return K(L(G, H), F) }

    function e(G) { var Z; var F = G.length; var x = F + 8; var k = (x - (x % 64)) / 64; var I = (k + 1) * 16; var aa = Array(I - 1); var d = 0; var H = 0; while (H < F) { Z = (H - (H % 4)) / 4;
            d = (H % 4) * 8;
            aa[Z] = (aa[Z] | (G.charCodeAt(H) << d));
            H++ }
        Z = (H - (H % 4)) / 4;
        d = (H % 4) * 8;
        aa[Z] = aa[Z] | (128 << d);
        aa[I - 2] = F << 3;
        aa[I - 1] = F >>> 29; return aa }

    function B(x) { var k = "",
            F = "",
            G, d; for (d = 0; d <= 3; d++) { G = (x >>> (d * 8)) & 255;
            F = "0" + G.toString(16);
            k = k + F.substr(F.length - 2, 2) } return k }

    function J(k) { k = k.replace(/rn/g, "n"); var d = ""; for (var F = 0; F < k.length; F++) { var x = k.charCodeAt(F); if (x < 128) { d += String.fromCharCode(x) } else { if ((x > 127) && (x < 2048)) { d += String.fromCharCode((x >> 6) | 192);
                    d += String.fromCharCode((x & 63) | 128) } else { d += String.fromCharCode((x >> 12) | 224);
                    d += String.fromCharCode(((x >> 6) & 63) | 128);
                    d += String.fromCharCode((x & 63) | 128) } } } return d } var C = Array(); var P, h, E, v, g, Y, X, W, V; var S = 7,
        Q = 12,
        N = 17,
        M = 22; var A = 5,
        z = 9,
        y = 14,
        w = 20; var o = 4,
        m = 11,
        l = 16,
        j = 23; var U = 6,
        T = 10,
        R = 15,
        O = 21;
    s = J(s);
    C = e(s);
    Y = 1732584193;
    X = 4023233417;
    W = 2562383102;
    V = 271733878; for (P = 0; P < C.length; P += 16) { h = Y;
        E = X;
        v = W;
        g = V;
        Y = u(Y, X, W, V, C[P + 0], S, 3614090360);
        V = u(V, Y, X, W, C[P + 1], Q, 3905402710);
        W = u(W, V, Y, X, C[P + 2], N, 606105819);
        X = u(X, W, V, Y, C[P + 3], M, 3250441966);
        Y = u(Y, X, W, V, C[P + 4], S, 4118548399);
        V = u(V, Y, X, W, C[P + 5], Q, 1200080426);
        W = u(W, V, Y, X, C[P + 6], N, 2821735955);
        X = u(X, W, V, Y, C[P + 7], M, 4249261313);
        Y = u(Y, X, W, V, C[P + 8], S, 1770035416);
        V = u(V, Y, X, W, C[P + 9], Q, 2336552879);
        W = u(W, V, Y, X, C[P + 10], N, 4294925233);
        X = u(X, W, V, Y, C[P + 11], M, 2304563134);
        Y = u(Y, X, W, V, C[P + 12], S, 1804603682);
        V = u(V, Y, X, W, C[P + 13], Q, 4254626195);
        W = u(W, V, Y, X, C[P + 14], N, 2792965006);
        X = u(X, W, V, Y, C[P + 15], M, 1236535329);
        Y = f(Y, X, W, V, C[P + 1], A, 4129170786);
        V = f(V, Y, X, W, C[P + 6], z, 3225465664);
        W = f(W, V, Y, X, C[P + 11], y, 643717713);
        X = f(X, W, V, Y, C[P + 0], w, 3921069994);
        Y = f(Y, X, W, V, C[P + 5], A, 3593408605);
        V = f(V, Y, X, W, C[P + 10], z, 38016083);
        W = f(W, V, Y, X, C[P + 15], y, 3634488961);
        X = f(X, W, V, Y, C[P + 4], w, 3889429448);
        Y = f(Y, X, W, V, C[P + 9], A, 568446438);
        V = f(V, Y, X, W, C[P + 14], z, 3275163606);
        W = f(W, V, Y, X, C[P + 3], y, 4107603335);
        X = f(X, W, V, Y, C[P + 8], w, 1163531501);
        Y = f(Y, X, W, V, C[P + 13], A, 2850285829);
        V = f(V, Y, X, W, C[P + 2], z, 4243563512);
        W = f(W, V, Y, X, C[P + 7], y, 1735328473);
        X = f(X, W, V, Y, C[P + 12], w, 2368359562);
        Y = D(Y, X, W, V, C[P + 5], o, 4294588738);
        V = D(V, Y, X, W, C[P + 8], m, 2272392833);
        W = D(W, V, Y, X, C[P + 11], l, 1839030562);
        X = D(X, W, V, Y, C[P + 14], j, 4259657740);
        Y = D(Y, X, W, V, C[P + 1], o, 2763975236);
        V = D(V, Y, X, W, C[P + 4], m, 1272893353);
        W = D(W, V, Y, X, C[P + 7], l, 4139469664);
        X = D(X, W, V, Y, C[P + 10], j, 3200236656);
        Y = D(Y, X, W, V, C[P + 13], o, 681279174);
        V = D(V, Y, X, W, C[P + 0], m, 3936430074);
        W = D(W, V, Y, X, C[P + 3], l, 3572445317);
        X = D(X, W, V, Y, C[P + 6], j, 76029189);
        Y = D(Y, X, W, V, C[P + 9], o, 3654602809);
        V = D(V, Y, X, W, C[P + 12], m, 3873151461);
        W = D(W, V, Y, X, C[P + 15], l, 530742520);
        X = D(X, W, V, Y, C[P + 2], j, 3299628645);
        Y = t(Y, X, W, V, C[P + 0], U, 4096336452);
        V = t(V, Y, X, W, C[P + 7], T, 1126891415);
        W = t(W, V, Y, X, C[P + 14], R, 2878612391);
        X = t(X, W, V, Y, C[P + 5], O, 4237533241);
        Y = t(Y, X, W, V, C[P + 12], U, 1700485571);
        V = t(V, Y, X, W, C[P + 3], T, 2399980690);
        W = t(W, V, Y, X, C[P + 10], R, 4293915773);
        X = t(X, W, V, Y, C[P + 1], O, 2240044497);
        Y = t(Y, X, W, V, C[P + 8], U, 1873313359);
        V = t(V, Y, X, W, C[P + 15], T, 4264355552);
        W = t(W, V, Y, X, C[P + 6], R, 2734768916);
        X = t(X, W, V, Y, C[P + 13], O, 1309151649);
        Y = t(Y, X, W, V, C[P + 4], U, 4149444226);
        V = t(V, Y, X, W, C[P + 11], T, 3174756917);
        W = t(W, V, Y, X, C[P + 2], R, 718787259);
        X = t(X, W, V, Y, C[P + 9], O, 3951481745);
        Y = K(Y, h);
        X = K(X, E);
        W = K(W, v);
        V = K(V, g) } var i = B(Y) + B(X) + B(W) + B(V); return i.toLowerCase() };