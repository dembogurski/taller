var openForm = false;
var checks = ["art_venta", "art_inv", "art_compra","visible_web"]; 
var buscadorArticulos =false;
var global_img_id = 0;
var ventana;

function configurar(){
    /*
    $('#articulos').DataTable( {
        "language": {
            "lengthMenu": "Mostrar _MENU_ filas por pagina",
            "zeroRecords": "Ningun resultado - lo siento",
            "info": "Mostrando pagina _PAGE_ de _PAGES_",
            "infoEmpty": "Ningun registro disponible",
            "infoFiltered": "(filtrado de un total de _MAX_ registros)",
            "search":"Buscar",
	    "paginate": {
             "previous": "Anterior",
             "next": "Siguiente"
            }
        },
        responsive: true,
		"lengthMenu": [[10, 20, 50, 100, -1], [10, 20, 50, 100, "All"]],
		"pageLength": 20,
        dom: 'l<"toolbar">frtip',
        initComplete: function(){
           $("div.toolbar").html('<button type="button" id="add_button_articulos" onclick="addUI()">Nuevo Registro</button>');           
        },
        "autoWidth": false
    } );
    
    */
    
    window.addEventListener('resize', function(event){
        if(openForm){
           centerForm();
        }
    });  
    setTimeout("contarReferencias()",100);  
}  

function filtrarArticulos(){
    var buscar = $("#buscador").val().toLowerCase();
    var stock_min = parseInt($("#stock_min").val());
    var minchars = 2;
    if(stock_min > 0 && buscar === ""){
        buscar = " ";
        minchars = 0;
    }
    if(buscar.length > minchars || stock_min > 0){
        $(".art_component").each(function(){
            var key = $(this).attr("data-search").toLowerCase();
            var index = key.indexOf(buscar);
            var stock = parseInt($(this).attr("data-stock"));
             
            if(index > 0 &&  stock >= stock_min ){
                $(this).fadeIn();
            }else{
                $(this).fadeOut();
            }
            //console.log(key+"  pos:  "+index+"  stock:"+stock+"  stock_filter:"+stock_min);
        });  
        
    }else{
        $(".art_component").fadeIn();
    }
    setTimeout("contarReferencias()",1000); // Delay del fade in fade out
}
function contarReferencias(){
    var total_referencias = $("div.art_component:visible").length; console.log("total_referencias "+total_referencias);
    $("#total_referencias").html(total_referencias);
}

function configurarCamposNumericos(){
    $(".form_number").on("keypress", function(evt) {
        var keycode = evt.charCode || evt.keyCode;             
        if (keycode == 44) {   //46 coma
           errorMsg("Utilice Punto en vez de Coma para los campos numericos",8000);
           return false;
        }
    });  
}
  
function editUI(pk){
    $.ajax({
        type: "POST",
        url: "productos/Articulos.class.php",
        data: {action: "editUI" , pk: pk,  usuario: getNick()},
        async: true,
        dataType: "html",
        beforeSend: function () {
            $(".form").html("");
            $("#msg_articulos").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        complete: function (objeto, exito) {
            if (exito === "success") {                          
                var form = objeto.responseText;                  
                centerForm(); 
                $(".form").html(form);
                $("#msg_articulos").html("");                
                $( "#tabs" ).tabs(); 
                $( "#tabs" ).tabs({ active: 0 }); 
                configurarCamposNumericos();
                $(".modif").click(function () {
                    $("#articulos_update_button").prop("disabled",false);               
                });
                $(".nomodif").click(function () {
                    $("#articulos_update_button").prop("disabled",true);               
                });
                $("#add_barcode").keyup(function(){
                    var bar = $(this).val();
                    if(bar !== ""){
                        $("#add_barcode_button").prop("disabled",false);
                    }else{
                        $("#add_barcode_button").prop("disabled",true);
                    }
                }); 
                $("#add_barcode").change(function(){
                    var bar = $(this).val();
                    if(bar !== ""){
                       addBarcode();   
                    } 
                });
                $(".form_number:not('#form_costo_prom,#form_costo_cif')").each(function(){    
                    
                   var decimales = 2;
                   if($(this).attr("id") == "form_espesor"){
                       decimales = 4;
                   }
                   var vf = parseFloat($(this).val()).format(decimales, 3, '.', ',');
                   $(this).val(vf) 
                });
              
                $(".form_number:not('#form_costo_prom,#form_costo_cif')").change(function(){      
                    
                   var decimales = 2;
                   if($(this).attr("id") == "form_espesor"){
                       decimales = 4;
                   }
                   var vf = parseFloat( $(this).val()).format(decimales, 3, '.', ',');
                   $(this).val(vf);
                });  
                getImagenesArticulo();  
                prepareCloneFunctions();
                $(".form").offset({  top: $(".product_code_"+pk).offset().top - 200 });
            }else{
                $("#msg_articulos").html("Ocurrio un error en la comunicacion con el Servidor...");
            }
        },
        error: function () {
           $("#msg_articulos").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });   
}

function prepareCloneFunctions(){
   $("#edit_articulos").mousedown(function(event) {
        switch (event.which) {
            case 1:
                break;
            case 2:
                break;
            case 3: 
                $(".clone").fadeIn(); 
                setTimeout('$(".clone").fadeOut()',8000);   
                $("#clone").click(function() { 
                    clonarArticulo();
                });
                break;
            default:

        }
    });
    $("#edit_articulos").contextmenu(function() {
        return false;
    });    
}
function clonarArticulo(){
    var c = confirm("Confirme que desea Clonar este Articulo?");
    if(c){
        var codigo = $("#form_codigo").val();
        $.ajax({
            type: "POST",
            url: "productos/Articulos.class.php",
            data: {action: "clonar",codigo:codigo, suc: getSuc(), usuario: getNick()},
            async: true,
            dataType: "json",
            beforeSend: function () {
                $("#clone").html("Clonando...<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            },
            success: function (data) {   
                if (data.mensaje === "Ok") {
                    var codigo_clon = data.codigo_clon;
                    alert("El articulo ha sido clonado con Exito, el nuevo codigo es el: "+codigo_clon+"\nA continuacion modifique los datos");                    
                    editUI(codigo_clon);
                } else {
                    $("#msg").html("Error al :  ");   
                }                
            },
            error: function (e) {                 
                $("#clone").html("Error al clonar:  " + e);   
                errorMsg("Error al clonar:  " + e, 10000);
            }
        }); 
    }
}

function copiarListaMateriales(){
    var codigo_a_copiar = prompt("Ingrese el Codigo del Articulo a copiar la Lista de Materiales");
    var codigo = $("#form_codigo").val();
    if(codigo_a_copiar != undefined && codigo_a_copiar.length > 2){
        $.ajax({
            type: "POST",
            url: "productos/Articulos.class.php",
            data: {action: "copiarListaMateriales",codigo:codigo,codigo_a_copiar:codigo_a_copiar, suc: getSuc(), usuario: getNick()},
            async: true,
            dataType: "json",
            beforeSend: function () {
                $("#clone").html("Clonando...<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            },
            success: function (data) {   
                if (data.mensaje === "Ok") {
                    getListaMateriales();
                } else {
                    $("#msg").html("Error al copiar Lista de Materiales Ingrese un codigo valido:  ");   
                }                
            },
            error: function (e) {                 
                $("#clone").html("Error al copiar Lista de Materiales:  " + e);   
                errorMsg("Error al copiar Lista de Materiales " + e, 10000);
            }
        }); 
    }
     
}

function getPropiedades(){
    var codigo = $("#form_codigo").val();
    $.ajax({
        type: "POST",
        url: "productos/Articulos.class.php",
        data: {action: "getPropiedades", codigo: codigo },
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg_articulos").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {  
             $(".row_prop").remove();
             if(data.length > 0){
                 for(var i in data){
                    var cod_prop = data[i].cod_prop;
                    var descrip = data[i].descrip;
                    var valor_def = (data[i].valor_def).toString().split(",");
                    var valor = data[i].valor;
                    var elements = '<option style="min-width:40px" value="" ></option>';
                    valor_def.forEach(function(e) {
                        var selected = '';
                        if(e === valor){ 
                            selected = 'selected="selected"';
                        }   
                        elements+='<option style="min-width:40px" value='+e+' '+selected+'>'+e+'</option>';
                    });
                    
                    $("#art_propiedades").append("<tr class='row_prop' data-cod='"+cod_prop+"'><td  class='itemc'>"+cod_prop+"</td><td class='item'>"+descrip+"</td><td  class='itemc'><select class='prop_"+cod_prop+"' onchange='saveProp("+cod_prop+")'>"+elements+"</select></td></tr>");
                 }
                 $("#msg_articulos").html("");   
             }else{
                 $("#msg_articulos").html("Este articulo aun no tiene propiedades asignadas" );
             }              
        },
        error: function (e) {                 
            $("#msg_articulos").html("Error al obtener las propiedades del articulo" + e);   
            errorMsg("Error al obtener las propiedades del articulo  " + e, 10000);
        }
    }); 
}
function saveProp(cod_prop){
    var value = $(".prop_"+cod_prop).val();
    var codigo = $("#form_codigo").val();
    $("#msg_articulos").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
    $.post("productos/Articulos.class.php", { "action": "saveProp",codigo:codigo,cod_prop:cod_prop,value:value  }, function(data) {
         $("#msg_articulos").html(data ); 
    });
}
function getDatosInventario(){
    if($("#form_art_inv").is(":checked")){
    var codigo = $("#form_codigo").val();
        $.ajax({
            type: "POST",
            url: "productos/Articulos.class.php",
            data: {action: "getDatosInventario", codigo: codigo },
            async: true,
            dataType: "json",
            beforeSend: function () {
                $("#msg_articulos").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            },
            success: function (data) {  
                 $(".row_inv").remove();
                 if(data.length > 0){
                     for(var i in data){
                        var suc = data[i].suc;
                        var nombre = data[i].nombre;
                        var stock = data[i].stock;
                        var estado_venta = data[i].estado_venta;

                        $("#stock_x_suc").append("<tr class='row_inv'><td  class='itemc'>"+suc+"</td><td class='item'>"+nombre+"</td><td  class='num'>"+stock+"</td><td  class='itemc'>"+estado_venta+"</td><td  class='itemc' title='Historial'><img style='cursor:pointer;border:solid gray 1px;' onclick=historial('"+suc+"') src='img/historial.png' height='24px' ></td></tr>");
                     }
                     $("#msg_articulos").html("");   
                     var um_inv = $("#form_um").val();
                     $("#um_inv_art").html("("+um_inv+")");
                 }else{
                     $("#msg_articulos").html("Este articulo aun no tiene stock" );
                 }              
            },
            error: function (e) {                 
                $("#msg_articulos").html("Error al obtener las propiedades del articulo" + e);   
                errorMsg("Error al obtener las propiedades del articulo  " + e, 10000);
            }
        });     
    }else{
        $("#stock_x_suc").fadeOut(); 
    }
}

function  historial(suc = "%"){
    
    var codigo = $("#form_codigo").val();
      
    var url = "productos/HistorialMovimiento.class.php?lote=''&suc="+suc+"&codigo="+codigo;
    var title = "Historial de Movimiento de Lote";
    var params = "width=980,height=480,scrollbars=yes,menubar=yes,alwaysRaised = yes,modal=yes,location=no";
    
    if(!ventana){        
        ventana = window.open(url,title,params);
    }else{
        ventana.close();
        ventana = window.open(url,title,params);
    } 
}

function getUsos(){
    getUsosAsignNoAsign("getUsosNoAsignados");
    getUsosAsignNoAsign("getUsosAsignados");
}

function getFiltrosListaPrecios(){
    
    var um = $("#form_um").val();
    $.ajax({
        type: "POST",
        url: "productos/Articulos.class.php",
        data: {action: "getMonedaFromListaPrecios",um:um,"campo":"moneda"},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#lp_moneda").html("");
            $(".lp_row").remove();
            $("#msg_articulos").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {   
            if (data.length > 0){
                for(var i in data){
                    var moneda = data[i].moneda;
                    $("#lp_moneda").append("<option value='"+moneda+"'>"+moneda+"</option>");
                }
                $("#msg_articulos").html("Ok"); 
            }    
            getUmFromListaPrecios($("#lp_moneda").val());
            $("#lp_moneda").change(function(){
                var moneda = $(this).val();
                getUmFromListaPrecios(moneda);
            });
             
        },
        
        error: function (e) {                 
            $("#msg_articulos").html("Error al obtener moneda:  " + e);   
            errorMsg("Error al obtener moneda:  " + e, 10000);
        }
    });    
}
function getUmFromListaPrecios(moneda){
    var um = $("#form_um").val();
    $.ajax({
        type: "POST",
        url: "productos/Articulos.class.php",
        data: {action: "getUmFromListaPrecios",moneda:moneda,um:um,},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#lp_um").html("");
            $(".lp_row").remove();
            $("#msg_articulos").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {   
            if (data.length > 0){
                for(var i in data){
                    var um = data[i].um;
                    $("#lp_um").append("<option value='"+um+"'>"+um+"</option>");
                }
                $("#msg_articulos").html("Ok"); 
            }  
            getListaPrecios(); 
             
        },
        
        error: function (e) {                 
            $("#msg_articulos").html("Error al obtener moneda:  " + e);   
            errorMsg("Error al obtener moneda:  " + e, 10000);
        }
    });        
}

function getListaPrecios(){
    var codigo = $("#form_codigo").val();
    var moneda = $("#lp_moneda").val();
    var um = $("#lp_um").val();
    $.ajax({
        type: "POST",
        url: "productos/Articulos.class.php",
        data: {action: "getListaPrecios", suc: getSuc(), usuario: getNick(),codigo:codigo,moneda:moneda,um:um},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg_articulos").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            $(".lp_row").remove();
        },
        success: function (data) {   
                for(var i in data){
                    var num = data[i].num;
                    var moneda = data[i].moneda;
                    var um = data[i].um;
                    var descrip = data[i].descrip;
                    var factor = data[i].factor;
                    var regla_redondeo = data[i].regla_redondeo; 
                    var decimales = 2;
                    if(regla_redondeo == "SEDECO"){
                        decimales = 0;
                    }
                    var precio = parseFloat(data[i].precio).format(decimales, 3, '.', ',');
                    var monr = moneda.replace("$","s");
                    var pre_ref = num+"-"+monr+"-"+um;
                    var ref = data[i].ref;
                    
                    var  row = "first_row";
                    if (i > 0 ){
                         row = "";
                    }
                    
                    $("#lista_precios").append("<tr class='lp_row'><td class='itemc lista'>"+num+"</td><td class='itemc'>"+moneda+"</td><td class='itemc'>"+um+"</td><td class='item descrip_"+descrip+"'>"+descrip+"</td><td class='num' data-regla='"+regla_redondeo+"'>"+factor+"</td><td class='itemc' style='width:80px'><input type='text' data-num='"+num+"' data-moneda='"+moneda+"'  data-um='"+um+"' data-ref='"+ref+"'  class='precio_venta num precio_"+pre_ref+" "+row+"' value='"+precio+"' id='precio_"+num+"' onkeypress='return onlyNumbers(event)' ></td><td class='itemc ref'>"+ref+"</td><td class='itemc' id='msg_lp_"+num+"' > </td></tr>");
                }
                
                $(".ref").hover(function(){
                    var ref = $(this).html();
                    $(".descrip_"+ref).addClass("referencia");
                },
                function(){
                    $(".referencia").removeClass("referencia");
                });
               
                $(".first_row").change(function(){                    
                    var apply_factor = $("#apply_factor").is(":checked");
                    if(apply_factor){
                        cambiarPrecio();
                    }
                });     
                $(".precio_venta").click(function(){ 
                  $(this).select();
                });
                
            $("#msg_articulos").html("Ok"); 
        },
        error: function (e) {                 
            $("#msg_articulos").html("Error al obtener lista:  " + e);   
            errorMsg("Error al obtener lista:  " + e, 10000);
        }
    }); 
}

function cambiarPrecio(){
    //var precio =  parseFloat( $(".precio_venta").val());  
    $(".precio_venta").each(function () {
        var referencia = $(this).attr("data-ref");
        var precio = parseFloat( $(".precio_"+referencia).val().replace(/\./g, '').replace(/\,/g, '.'));console.log("precio: "+precio);
        var factor =  parseFloat( $(this).parent().prev().html());   console.log("Factor: "+factor);
        var regla_redondeo  = $(this).parent().prev().attr("data-regla");   console.log("regla_redondeo: "+regla_redondeo);
        var calc = precio * factor;
        var moneda = $("#lp_moneda").val();
        if(regla_redondeo == "SEDECO"){
            calc = parseFloat(redondearMoneda(calc,moneda)).format(0, 3, '.', ',') ;  
        }else if(regla_redondeo == "2_DEC_ARRIBA"){
            calc = parseFloat(Math.ceil(calc * 100)/100).format(2, 3, '.', ',') ;  
        }else if(regla_redondeo == "2_DEC_ABAJO"){
            calc = parseFloat(Math.floor(calc * 100)/100).format(2, 3, '.', ',') ;  
        }
        $(this).val(calc);
    }); 
}
function guardarListaPrecios(){
    var codigo = $("#form_codigo").val();
    $(".precio_venta").each(function () {        
        var num = $(this).attr("data-num");
        var moneda = $(this).attr("data-moneda");
        var um = $(this).attr("data-um");
        var precio = parseFloat($(this).val().replace(/\./g, '').replace(/\,/g, '.') );                 
        $("#msg_lp_"+num).html("<img src='img/loading_fast.gif' width='16px' height='16px' >");
        $.post("productos/Articulos.class.php", { "action": "guardarListaPrecios",usuario:getNick(),suc:getSuc(), codigo:codigo,num:num, moneda:moneda,um:um,precio:precio  }, function(data) {                        
            console.log(data);
            var lp = parseInt(data);
            $("#msg_lp_"+lp).html("<img src='img/ok.png' width='16px' height='16px' >");
        });
    }); 
}

function getListaMateriales(){
   var codigo = $("#form_codigo").val();
   $.ajax({
            type: "POST",
            url: "productos/Articulos.class.php",
            data: {action: "getListaMateriales",codigo:codigo,usuario:getNick()},
            async: true,
            dataType: "json",
            beforeSend: function () {
                $(".row_lista_mat").remove();
                $("#msg_articulos").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            },
            success: function (data) {   
                if(data.length > 0){
                 for(var i in data){
                    
                    var articulo = data[i].articulo;
                    var ref = data[i].ref;
                    var descrip = data[i].descrip;
                    var um = data[i].um;
                    var cantidad = data[i].cantidad;
                    var rendimiento = data[i].rendimiento;
                    var precio_unit = data[i].precio_unit;
                    var sub_total = data[i].sub_total;
                    var checked = ref === "true"?'checked="checked"':"";
                     
                    $("#lista_materiales").append("<tr class='art_"+articulo+" row_lista_mat' data-cod='"+articulo+"'><td  class='itemc'>"+articulo+"</td><td  class='item'>"+descrip+"</td><td  class='num'>"+cantidad+"</td><td  class='itemc'>"+um+"</td><td  class='itemc'><input type='checkbox' class='ref_"+articulo+" referencia' "+checked+" onclick='return false;'  ></td><td  class='itemc'>"+rendimiento+"</td><td  class='num'>"+precio_unit+"</td><td  class='num'>"+sub_total+"</td><td class='itemc'><img src='img/trash_mini.png' style='cursor:pointer' onclick=deleteFromListaMat('"+articulo+"') ></td></tr>");
                 }
                 //$("#lista_materiales").append(lastRowListaMateriales);
                  
                 
                 $("#lista_articulos").draggable();
                 $("#msg_articulos").html("");  
                  
             }else{
                 $("#msg_articulos").html("Este articulo no tiene lista de materiales" );
                 //$("#lista_materiales").append(lastRowListaMateriales);
                  
                 $("#lista_articulos").draggable();
                  
             }                    
            },
            error: function (e) {                 
                $("#msg_articulos").html("Error al obtener Lista de Materiales:  " + e);   
                errorMsg("Error al obtener Lista de Materiales:  " + e, 10000);
            }
        }); 
}
function deleteFromListaMat(articulo){
    var c = confirm("Esta seguro que desea quitar este articulo de la lista de materiales?");
    if(c){
        var codigo = $("#form_codigo").val();
        $("#msg_"+articulo).html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        $.post("productos/Articulos.class.php", { "action": "deleteFromListaMat",codigo:codigo,articulo:articulo   }, function(data) {
            console.log(data);
            $(".art_"+articulo).remove();
            alert("Articulo eliminado de la Lista de Materiales");
        });
    }
}
function buscarArticulos(){
    if(!buscadorArticulos){
        $("#msg_articulos").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        $.post("productos/Articulos.class.php", { "action": "buscarArticulos",filtro:" a.cod_sector not in(106,107) "  }, function(data) {
            $("#lista_articulos").html(data ); 
            $("#msg_articulos").html("");
            $('#buscar_articulos').DataTable( {
             "language": {
                 "lengthMenu": "Mostrar _MENU_ filas por pagina",
                 "zeroRecords": "Ningun resultado - lo siento",
                 "info": "Mostrando pagina _PAGE_ de _PAGES_",
                 "infoEmpty": "Ningun registro disponible",
                 "infoFiltered": "(filtrado de un total de _MAX_ registros)",
                 "search":"Buscar",
                 "paginate": {
                  "previous": "Anterior",
                  "next": "Siguiente"
                 }
             },
             responsive: true,
                     "lengthMenu": [[10, 20, 50, 100, -1], [10, 20, 50, 100, "All"]],
                     "pageLength": 10,
             dom: 'l<"toolbar">frtip',
             initComplete: function(){
                $("div.toolbar").html('<button type="button" id="add_button_articulos" onclick="closeSearchUI()">Cancelar</button>');    
                configurarEventoDataTablesListaMat();
                $('input[type="search"]').change(function(){
                   configurarEventoDataTablesListaMat();
                });
             },
             "autoWidth": false
         } );
            $("#lista_articulos").fadeIn();
            
         }); 
         
        buscadorArticulos = true;
    }else{
        $("#lista_articulos").fadeIn();
    }
}

function configurarEventoDataTablesListaMat(){
    console.log("Config Lista mat");
    $('#lista_articulos td').click(function () {
        var articulo = $(this).parent().attr("data-codigo");       
        if( $(".art_"+articulo).length > 0 ){
            errorMsg("Este articulo ya esta en la lista de materiales");
        }else{
            var descrip = $(".descrip_"+articulo).text();
            var um = $(".um_"+articulo).text();
            var precio_costo = $(this).parent().attr("data-precio_costo");
            $("#lista_materiales").append("<tr class='art_"+articulo+" row_lista_mat' data-articulo="+articulo+"><td class='itemc' >"+articulo+"</td><td>"+descrip+"</td><td class='itemc' ><input type='number' step='any' size='4' class='cant_"+articulo+" input_lista_mat num'  ></td><td class='itemc'>"+um+"</td><td class='itemc'><input type='checkbox' class='ref_"+articulo+" referencia'> </td><td class='itemc'><input type='number' size='4' class='rend_"+articulo+" itemc input_lista_mat' value='1' ></td><td class='itemc'><input type='number' step='any' size='8' class='p_costo_"+articulo+" input_lista_mat num' style='width:60px' value='"+precio_costo+"' ></td><td class='subtotal_"+articulo+" subt num'></td><td class='itemc' id='msg_"+articulo+"'></td></tr>");
            infoMsg("Ingrese la cantidad Requerida y/o el Rendimiento para guardar",8000);
            $(".cant_"+articulo).focus();
            configurarEventosFilaMateriales();
        }  
    });    
}

function configurarEventosFilaMateriales(){
 $(".input_lista_mat, .referencia").change(function(){
    var articulo = $(this).parent().parent().attr("data-articulo");                
    addToListaMat(articulo);
 });   
} 
function addToListaMat(articulo){
     
    var codigo = $("#form_codigo").val();
    var cantidad = $(".cant_"+articulo).val();
    var mtr = $(".ref_"+articulo).is(":checked");
    var rend = $(".rend_"+articulo).val();
    var p_costo = $(".p_costo_"+articulo).val();
    var subtotal = parseFloat(cantidad * p_costo);
    
    if(cantidad == "" || rend == ""){
        errorMsg("Ingrese la cantidad para guardar",6000);
    }else{
        $(".subtotal_"+articulo).html(subtotal);

        $.ajax({
            type: "POST",
            url: "productos/Articulos.class.php",
            data: {action: "addToListaMat",codigo:codigo,articulo:articulo,cantidad:cantidad,mtr:mtr,rend:rend,p_costo:p_costo  },
            async: true,
            dataType: "json",
            beforeSend: function () {
                $("#msg_"+articulo).html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            },
            success: function (data) {   
                if (data.mensaje === "Ok") {
                   $("#msg_"+articulo).html("<img src='img/ok.png' width='16px' height='16px' >"); 
                } else {
                   $("#msg_"+articulo).html("<img src='img/warning_red_16.png' width='16px' height='16px' >"); 
                }                
            },
            error: function (e) {                 
                $("#msg").html("Error al xxx cuenta:  " + e);   
                errorMsg("Error al xxx cuenta:  " + e, 10000);
            }
        }); 
    }
     
}
function closeSearchUI(){
    $("#lista_articulos").fadeOut();
}
function getUsosAsignNoAsign(tipo_uso){
    
    var codigo = $("#form_codigo").val();
    $.ajax({
        type: "POST",
        url: "productos/Articulos.class.php",
        data: {action: tipo_uso, codigo: codigo },
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg_articulos").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {  
             $(".row_uso_"+tipo_uso).remove();
             if(data.length > 0){
                 for(var i in data){
                    var cod_uso = data[i].ID;
                    var descrip = data[i].descrip;
                     
                    $("#"+tipo_uso).append("<tr class='row_uso_"+tipo_uso+"' data-cod='"+cod_uso+"'><td  class='itemc'>"+cod_uso+"</td><td  class='item'>"+descrip+"</td></tr>");
                 }
                 $("#msg_articulos").html("");  
                 $(".row_uso_"+tipo_uso+"").click(function(){
                        if($(this).hasClass("selected_"+tipo_uso)){
                            $(this).removeClass("selected_"+tipo_uso);
                        }else{
                            $(this).addClass("selected_"+tipo_uso);
                        }
                 });
             }else{
                 $("#msg_articulos").html("Este articulo aun no tiene usos asignados" );
             }              
        },
        error: function (e) {                 
            $("#msg_articulos").html("Error al obtener los usos del articulo" + e);   
            errorMsg("Error al obtener los usos del articulo  " + e, 10000);
        }
    });     
}
function asignar(){
    var codigo = $("#form_codigo").val();
    var lista = listaSeleccionados("getUsosNoAsignados"); 
    if(lista.length >0){ 
        var ids = JSON.stringify(lista);
        $.ajax({
            type: "POST",
            url: "productos/Articulos.class.php",
            data: {action: "asignar",codigo:codigo,ids:ids},
            async: true,
            dataType: "json",
            beforeSend: function () {
                $("#msg_articulos").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            },
            success: function (data) {   
                if (data.mensaje === "Ok") {
                    $("#msg_articulos").html("Ok"); 
                    $("#getUsosAsignados").append($(".selected_getUsosNoAsignados"));
                } else {
                    $("#msg_articulos").html("Error al asignar");   
                }                
            },
            error: function (e) {                 
                $("#msg_articulos").html("Error al asignar:  " + e);   
                errorMsg("Error al asignar:  " + e, 10000);
            }
        }); 
    }
}

function desasignar(){
    var codigo = $("#form_codigo").val();
    var lista = listaSeleccionados("getUsosAsignados"); 
    if(lista.length >0){ 
        var ids = JSON.stringify(lista);
        $.ajax({
            type: "POST",
            url: "productos/Articulos.class.php",
            data: {action: "desasignar",codigo:codigo,ids:ids},
            async: true,
            dataType: "json",
            beforeSend: function () {
                $("#msg_articulos").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            },
            success: function (data) {   
                if (data.mensaje === "Ok") {
                    $("#msg_articulos").html("Ok"); 
                    $("#getUsosNoAsignados").append($(".selected_getUsosAsignados"));
                } else {
                    $("#msg_articulos").html("Error al asignar");   
                }                
            },
            error: function (e) {                 
                $("#msg_articulos").html("Error al asignar:  " + e);   
                errorMsg("Error al asignar:  " + e, 10000);
            }
        }); 
    }
}

function listaSeleccionados(tipo_uso){
    var ids = new Array();
    $(".selected_"+tipo_uso).each(function(){
       var id =$(this).attr("data-cod");  
       ids.push(id);        
    }); 
    return ids;
}

function addUI(){
    $.ajax({
        type: "POST",
        url: "productos/Articulos.class.php",
        data: {action: "addUI" ,  usuario: getNick()},
        async: true,
        dataType: "html",
        beforeSend: function () {
            $(".form").html("");
             $("#msg_articulos").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        complete: function (objeto, exito) {
            if (exito === "success") {                          
                var form = objeto.responseText;                  
                centerForm(); 
                $(".form").html(form);
                $("#msg_articulos").html("");     
                $( "#tabs" ).tabs(); 
                $( "#tabs" ).tabs({ active: 0 });
                $("#form_cod_sector").change(function(){
                     generarCodigo();
                });
                configurarCamposNumericos();
            }else{
                $("#msg_articulos").html("Ocurrio un error en la comunicacion con el Servidor...");
            }
        },
        error: function () {
           $("#msg_articulos").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });   
}

function generarCodigo(){
    var cod_sector = $("#form_cod_sector").val();
    $.ajax({
        type: "POST",
        url: "productos/Articulos.class.php",
        data: {action: "generarCodigo",cod_sector:cod_sector, suc: getSuc(), usuario: getNick()},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {   
           
            $("#msg_articulos").html(""); 
            var codigo = data[0].codigo;
            $("#form_codigo").val(codigo);
            $("#msg_codigo").html("Codigo Probable");
                          
        },
        error: function (e) {                 
            $("#msg_articulos").html("Error al generar codigo:  " + e);   
            errorMsg("Error al generar codigo:  " + e, 10000);
        }
    }); 
}

function centerForm(){
   var w = $(document).width();
   var h = $(document).height();
   $(".form").width(w);
   $(".form").height(h);   
   $(".form").fadeIn();
   openForm = true; 
}

function addData(form){
   
   var data = {}; 
   
   var table = form.substring(4,60);     
   $("#"+form+" [id^='form_']").each(function(){
     
     var pk = $(this).hasClass("PRI");
     var column_name = $(this).attr("id").substring(5,60);
     var val = $(this).val(); 
     var req = $(this).attr("required");
      
     if(req === "required" && val === ""){
         $(this).addClass("required");     
     }else{
         $(this).removeClass("required");     
     }
     var index = checks.indexOf(column_name);
     if(index >= 0){  
         val = $(this).is(":checked");
     }
     data[column_name]=val;
     
  });  
  if(data["costo_prom"]===""){
      data["costo_prom"]="0";
  }
  
  if($(".required").length === 0 ){
    var master = {                  
          data:data         
    };
    $.ajax({
          type: "POST",
          url: "productos/Articulos.class.php",
          data: {action: "addData" , master: master,  usuario: getNick()},        
          async: true,
          dataType: "json",
          beforeSend: function () {
              $("#msg_articulos").addClass("error");
              $("#"+form+" input[id="+table+"_save_button]").prop("disabled",true);
              $("#msg_articulos").html("Insertando... <img src='img/loading_fast.gif'  >");
          },
          success: function (data) {   

              if(data.mensaje === "Ok"){ 
                  $("#msg_articulos").html(data.mensaje);
                  $("#"+form+" input[id="+table+"_close_button]").fadeIn();
                  $("#form_codigo").val(data.codigo);
                  alert("Se ha registrado el articulo con el codigo "+data.codigo+" se levantara la ventana para edicion de Propiedades y Usos");
                  editUI(data.codigo);
              }else{
                  $("#"+form+" input[id="+table+"_save_button]").prop("disabled",false);
                  $("#msg_articulos").html(data.mensaje+" Rellene los campos requeridos y vuelva a intentarlo si el problema persiste contacte con el Administrador del sistema.");
              }           
          },
          error: function (err) { 
            $("#msg_articulos").addClass("error");
            $("#"+form+" input[id="+table+"_save_button]").prop("disabled",false);
            $("#msg_articulos").html('Error al Registrar: Rellene los campos requeridos y vuelva a intentarlo.<a href="javascript:showTechnicalError()">Mas info</a>\n\
            <div class="technical_info">'+err.responseText+'</div>');         
          }
      });  
     }else{
      $("#msg_articulos").addClass("error");  
      $("#msg_articulos").html("Rellene los campos requeridos...");
    }
}

function addBarcode(){
    var codigo = $("#form_codigo").val();
    var barcode = $("#add_barcode").val();
    var cant = $(".barc_"+barcode).length;
    if(cant > 0){
        alert("Codigo de barras ya ha sido registrado con anterioridad");
        $(".barc_"+barcode).css("background","orange");
    }else{
        $.ajax({
            type: "POST",
            url: "productos/Articulos.class.php",
            data: {action: "addBarcode", codigo: codigo, barcode: barcode},
            async: true,
            dataType: "json",
            beforeSend: function () {
                $("#msg_articulos").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            },
            success: function (data) {   
                if (data.resultado > 0) {
                    $("#msg_articulos").html("Ok"); 
                    $("#add_barcode").val("");
                    getCodigoBarras();
                } else {
                    $("#msg_articulos").html("Error al registrar codigo puede que ya este registrado.");   
                }                
            },
            error: function (e) {                 
                $("#msg_articulos").html("Error al registrar codigo de barras  ");   
                errorMsg("Error al registrar codigo de barras  " + e, 10000);
            }
        });  
    }
}

function getCodigoBarras(){
    var codigo = $("#form_codigo").val();
    $.ajax({
        type: "POST",
        url: "productos/Articulos.class.php",
        data: {action: "getCodigoBarras", codigo:codigo},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {   
            $(".barcode_line").remove();
            for(var i in data){
                var barc =   data[i].barcode ;    
                $("#artBarcodes").append("<tr class='barcode_line'><td class='item barcode_"+i+" barc_"+barc+"'>"+barc+"</td><td class='itemc'> <img style='cursor:pointer' src='img/trash_mini.png' width='16px' onclick=deleteBarcode("+i+")   ></td></tr>");
            }   
            $("#msg").html("");
        },
        error: function (e) {                 
            $("#msg").html("Error :  " + e);   
            errorMsg("Error  :  " + e, 10000);
        }
    });    
}
 

function getHistorialCostos(){
var codigo = $("#form_codigo").val();
    $.ajax({
        type: "POST",
        url: "productos/Articulos.class.php",
        data: {action: "getHistorialCostos", codigo:codigo},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {   
            $(".costos_line").remove();
            $(".chart-container").remove();      
            
            for(var i in data){
                var id_hist =   data[i].id_hist;    
                var usuario =   data[i].usuario;    
                var fecha =   data[i].fecha;   
                var costo_prom =    parseFloat(data[i].costo_prom).format(2, 3, '.', ',');
                var costo_cif =    parseFloat(data[i].costo_cif).format(2, 3, '.', ',');
                var notas =   data[i].notas;
                $("#historial_costos").append("<tr class='costos_line id_hist_"+id_hist+"'><td class='item'>"+usuario+"</td> <td class='itemc fecha'>"+fecha+"</td>   <td class='num costo_prom'>"+costo_prom+"</td> <td class='num'>"+costo_cif+"</td><td class='item'>"+notas+"</td></tr>");
            } 
            $("#div_nuevo_costo").before('<div id="chart_container" class="chart-container" style="position: absolute; height:340px; width: 770px; float:left "> </div>');
            $("#msg").html("");
            drawChartPPP();
        },
        error: function (e) {                 
            $("#msg").html("Error  : getHistorialCostos " + e);   
            errorMsg("Error getHistorialCostos:  " + e, 10000);
        }
    });        
}
function drawChartPPP(){
        var codigo = $("#form_codigo").val();
        var labels =new Array();
       
        $(".fecha").each(function(){
              labels.push($(this).text().toString());
        });
        var data_val =new Array();

        $(".costo_prom").each(function(){
             var v = parseFloat($(this).text().replace(".","").replace(",","."));           
             //var v = parseFloat($(this).text());
             data_val.push(v);
        });	

        
        var canvas = '<img style="margin:0;float:right;background-color:white" src="img/close.png" onclick=javascript:$(".chart-container").fadeOut() ><canvas id="chartjs"  class="chartjs"  style="display: block; width: 100%; height: 96%;"></canvas>';
        $("#chart_container").html(canvas);
 
            
           var graph = new Chart($("#chartjs"),{
            "type":"line",
            "data":{"labels":labels,
            "datasets":[
                {"label":"Historial de Costos de "+codigo,
                 "data":data_val,
                 "fill":false,
                 "responsive":true,
                 "maintainAspectRatio":false,
                 "borderColor":"rgb(237, 28, 36)",
                 "lineTension":0.1}]},
             "options":{}
         });     
        $(".chart-container").draggable();
        $(".chart-container").resizable();
     //$("#grafico_historial").load("productos/Articulos.class.php?action=drawChartPPP&labels="+labels+"&data="+data_val+"&label=Historial de Costos, Articulo: "+codigo+"  ");
    // var graph_window = window.open("productos/Articulos.class.php?action=drawChartPPP&labels="+labels+"&data="+data_val+"&label=Historial de Costos, Articulo: "+codigo+"  ", "MsgWindow", "width=1024,height=760");

}

function nuevoPPP(){
    $("#nuevo_costo_ppp").slideDown(); 
    getCuentasContables();
}
function aplicarPPP(){   
    var codigo = $("#form_codigo").val();
    var cta_aum = $("input[name=cta_aum]").val();
    var cta_dism = $("input[name=cta_dism]").val();  
    var new_costo_ppp = parseFloat($("#new_costo_ppp").val());
    var new_costo_cif =  parseFloat($("#new_costo_cif").val());
    var rev_notas = $("#rev_notas").val();
    if(new_costo_ppp > 0 || new_costo_cif > 0){
        if(rev_notas != ""){
        $.ajax({
            type: "POST",
            url: "productos/Articulos.class.php",
            data: {action: "aplicarPPP_CIF",codigo:codigo,cta_aum:cta_aum,cta_dism:cta_dism,new_costo_ppp:new_costo_ppp,new_costo_cif:new_costo_cif,rev_notas:rev_notas,  suc: getSuc(), usuario: getNick()},
            async: true,
            dataType: "json",
            beforeSend: function () {
                $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            },
            success: function (data) {   
                if (data.mensaje === "Ok") {
                    $("#nuevo_costo_ppp").slideUp(function(){
                        $("#form_costo_prom").val((new_costo_ppp).format(2, 3, '.', ','));
                        $("#form_costo_cif").val((new_costo_cif).format(2, 3, '.', ','));
                             
                        getHistorialCostos();
                    });
                    
                } else {
                    errorMsg("Error al cambiar el costo del articulo" + e, 10000);
                }                
            },
            error: function (e) {                 
                $("#msg").html("Error al cambiar el costo del articulo " + e);   
                errorMsg("Error al cambiar el costo del articulo" + e, 10000);
            }
        }); 
        }else{
           errorMsg("Ingrese un motivo valido especificando el porque esta cambiando el costo del articulo",15000); 
        }
    }else{
        errorMsg("Ingrese al menos un precio de costo nuevo Costo Promedio o Costo CIF",15000);
    }
    
}
function getCuentasContables(){
    $.ajax({
        type: "POST",
        url: "productos/Articulos.class.php",
        data: {action: "getCuentasContables", usuario:getNick()},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {   
            $(".costos_line").remove();
            for(var i in data){
                var cuenta =   data[i].cuenta;    
                var nombre =   data[i].nombre;   
                $(".cuentas_contab").append("<option value='"+cuenta+"'>"+cuenta+"-"+nombre+"</option>");
            } 
            $("#msg").html("");
        },
        error: function (e) {                 
            $("#msg").html("Error  : getHistorialCostos " + e);   
            errorMsg("Error getHistorialCostos:  " + e, 10000);
        }
    });        
}

function deleteBarcode(i){
    var barcode = $(".barcode_"+i).html();
    var codigo = $("#form_codigo").val();
    $.ajax({
        type: "POST",
        url: "productos/Articulos.class.php",
        data: {action: "deleteBarcode", codigo:codigo,barcode:barcode},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {   
           getCodigoBarras();    
        },
        error: function (e) {                 
            $("#msg").html("Error al xxx cuenta:  " + e);   
            errorMsg("Error al xxx cuenta:  " + e, 10000);
        }
    }); 
}

function showTechnicalError(){
    $(".technical_info").fadeToggle();
}

function updateData(form){
  var update_data = {};
  var primary_keys = {};  
  var table = form.substring(5,60);   
  $("#"+form+" [id^='form_']").each(function(){
       
     var pk = $(this).hasClass("PRI");
     var column_name = $(this).attr("id").substring(5,60);
     var val = $(this).val();
     var req = $(this).attr("required");
      
     if(req === "required" && val === ""){
         $(this).addClass("required");     
     }else{
         $(this).removeClass("required");     
     }
     var index = checks.indexOf(column_name);
     if(index >= 0){  
         val = $(this).is(":checked");
     }
     
     console.log(column_name +"   "+val );
     if(val == "NaN"){  console.log("True");
         val = 0;
     }
     
     if(pk){
         primary_keys[column_name]=val;
     }else{
         update_data[column_name]=val;
     } 
     
     
  });
  if($(".required").length == 0 ){
        var master ={                  
              primary_keys:primary_keys,
              update_data:update_data
        };
        $.ajax({
              type: "POST",
              url: "productos/Articulos.class.php",
              data: {action: "updateData" , master: master,  usuario: getNick()},        
              async: true,
              dataType: "json",
              beforeSend: function () {
                  $("#"+form+" input[id="+table+"_update_button]").prop("disabled",true);
                  $("#msg_articulos").html("Actualizando... <img src='img/loading_fast.gif'  >");
              },
              success: function (data) {                
                  if(data.mensaje === "Ok"){ 
                      $("#msg_articulos").html(data.mensaje);
                      $("#"+form+" input[id="+table+"_close_button]").fadeIn();
                  }else{
                      $("#"+form+" input[id="+table+"_update_button]").prop("disabled",false);
                      $("#msg_articulos").html(data.mensaje+' intente nuevamente si el problema persiste contacte con el Administrador del sistema.<a href="javascript:showTechnicalError()">Mas info</a><div class="technical_info">'+data.query+'</div>');
                  }           
              },
              error: function (err) { 
                $("#msg_articulos").addClass("error");
                $("#msg_articulos").html('Error al Registrar: Verifique los datos y vuelva a intentarlo.<a href="javascript:showTechnicalError()">Mas info</a>\n\
                <div class="technical_info">'+err.responseText+'</div>');         
              }
        }); 
  }else{
    $("#msg_articulos").addClass("error");  
    $("#msg_articulos").html("Rellene los campos requeridos...");
  }
}

function closeForm(){
    $(".form").html("");
    $(".form").fadeOut();
    openForm = false;
    genericLoad("productos/Articulos.class.php");
}


// Galeria
//resizedataURL(base64, 1024, 1632);
function resizedataURL(datas, wantedWidth, wantedHeight)  {
        // We create an image to receive the Data URI
        var img = document.createElement('img');
        
        // When the event "onload" is triggered we can resize the image.
        img.onload = function() {        
                // We create a canvas and get its context.
                
                var originalwidth = img.width;
                var originalheight = img.height;
                if(originalwidth > originalheight ){
                    wantedWidth = 1632;
                    wantedHeight = 1024;
                }                
                var canvas = document.createElement('canvas');
                var ctx = canvas.getContext('2d');

                // We set the dimensions at the wanted size.
                canvas.width = wantedWidth;
                canvas.height = wantedHeight;

                // We resize the image with the canvas method drawImage();
                ctx.drawImage(this, 0, 0, wantedWidth, wantedHeight);

                imagen = canvas.toDataURL();
              //console.log(dataURI);
                /////////////////////////////////////////
                // Use and treat your Data URI here !! //
                /////////////////////////////////////////
                $("#msg").html(document.getElementById("image-picker").files[0].name);
                $("#levantar-mult").removeAttr("disabled");
                $("#levantar-mult").focus();
                
            };

        // We put the Data URI in the image's src attribute
        img.src = datas;
         
}
 
var images = new Array();
var images_names = new Array();

function loadImageFileAsURLMultiple(){ 
    images.splice(0,images.length);
    images_names.splice(0,images_names.length);
    images = new Array();
    images_names = new Array();

    $("#levantar-mult").attr("disabled",true);
    var filesSelected = document.getElementById("image-picker-mult").files;
    
    $(".previews").remove();
    var galeria = $("#galeria");
     

    for(var i = 0;i < filesSelected.length; i++ )  {
        var fileToLoad = filesSelected[i];  
        var filename =  (  document.getElementById("image-picker-mult").files[i].name).replace(".jpg","").replace(".jpeg",""); 
        images_names.push(filename);
        var fileReader = new FileReader(); 
        fileReader.onload = function(fileLoadedEvent){              
           images.push( fileLoadedEvent.target.result);
           var  src = fileLoadedEvent.target.result;
           global_img_id++;
            var div = '<div class="design_div" data-id="'+i+'">\n\
                    <div><label>Imagen principal</label><input type="radio" name="img_group" data-id="'+global_img_id+'" ></div>\n\
                    <img class="imagen_design" src= "'+src+'"></div>';
                    $("#galeria").append(div);
        };        
        fileReader.readAsDataURL(fileToLoad);             
    }
    configureGroupSetPrinc();
    $("#levantar-mult").removeAttr("disabled");
}

function levantarDocumentoMult(){    
    $("#levantar-mult").attr("disabled",true);
    var codigo = $("#form_codigo").val();
    var cant = images_names.length;
    var current = 0;
    var fecha = $("#fecha").val();
    if( fecha != "" ){
    $("#msg").html("");
    for(var i = 0;i < images_names.length; i++ )  {
        var img = images[i];
        var filename = images_names[i];    
        var form_data = new FormData();
        form_data.append('file', $('#image-picker-mult').prop('files')[i]);
        form_data.append('action', "subirImagen");
        form_data.append("suc",getSuc());
        form_data.append("usuario",getNick());
        form_data.append("fecha",fecha);
        form_data.append("filename",filename);
        form_data.append("codigo",codigo);
        form_data.append("i",i);
       
        $.ajax({
            type: "POST",
            url: "productos/Articulos.class.php",
            data: form_data,
            async: true,
            cache: false,
            contentType: false,
            processData: false,
            dataType: "json",
            beforeSend: function () {
                $("#msg").append("<span class='upload_"+i+"'>Levantando "+filename+" <img src='img/loading_fast.gif' width='16px' height='16px' ></span><br>"); 
            },
            success: function (data) {   
                var mensaje = data.mesaje; 
                var x = data.i;                 
                //$("#guardar").removeAttr("disabled");
                if(mensaje == "Ok"){ 
                    var file = data.name;
                    $(".upload_"+x).html(">> "+file+": <img src='img/ok.png' width='16px' height='16px' >" );                     
                    current++;
                    console.log("Cant: "+cant+" current: "+current);
                    if(current == cant){
                       getImagenesArticulo();
                    }
                }else{
                   $(".upload_"+x).html(">>"+filename+"Error: "+data.error);           
                }
            },
            error: function (xhr, ajaxOptions, thrownError) {          
               $(".upload_"+i).html(xhr+" "+ajaxOptions+" "+thrownError);      
            }
        });         
    } 
   }else{
       alert("Seleccione una Fecha");
   }
}

function getImagenesArticulo(){
    var codigo = $("#form_codigo").val();
    $.ajax({
        type: "POST",
        url: "productos/Articulos.class.php",
        data: {action: "getImagenesArticulo",codigo:codigo, suc: getSuc(), usuario: getNick()},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $(".design_div").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {     //id_img,  , principal
            if(data.length > 0){
                $(".design_div").remove();
                for(var i in data){
                    var id_img = data[i].id_img;
                    global_img_id = id_img;
                    var url = data[i].url;
                    var princ= data[i].principal;
                    var checked = ""; 
                    
                    var nomenc = "Convertir en Principal";
                    if(princ == "Si"){   
                        nomenc = "Imagen principal";
                        checked = "checked='checked'"; 
                        $("#art_image").html('<img class="art_image" src= "'+url+'">');
                    }else{
                        nomenc = "Convertir en Principal";
                    }
                    var div = '<div  class="design_div div_'+id_img+'" >\n\
                    <div class="princ_'+princ+'" ><label>'+nomenc+'</label><input type="radio" name="img_group" '+checked+'  data-id="'+id_img+'"></div>\n\
                    <img class="imagen_design" src= "'+url+'">\n\
                    <div style="text-align:center"><input type="button" value="Quitar" style="font-size:8px" onclick="eliminarFoto('+id_img+')" ></div>\n\
                    </div>';
                    $("#galeria").append(div);
                }
                configureGroupSetPrinc();
            }         
        },
        error: function (e) {                 
            $("#msg").html("Error en getImagenesArticulo " + e);   
            errorMsg("Error en getImagenesArticulo:  " + e, 10000);
        }
    }); 
}
function configureGroupSetPrinc(){
    $("input[name=img_group]").click(function(){
        var c = confirm("Confirme que desea establecer esta imagen como principal?");
        if(c){
           var src = $(this).parent().parent().find(".imagen_design").attr("src");
           $(".art_image").attr("src",src);
           var id = $(this).attr("data-id");
           setPrincipalImage(id);
        }
   });
}
function setPrincipalImage(id){
    var codigo = $("#form_codigo").val();
    $.post("productos/Articulos.class.php", { "action": "setPrincipalImage",codigo:codigo,id:id  }, function(data) {
        getImagenesArticulo();
    }, "json");    
}

function eliminarFoto(id){
    var c = confirm("Confirme que desea eliminar esta foto?");
    if(c){
        $(".div_"+id).html("Eliminando...");
        var codigo = $("#form_codigo").val();
        $.post("productos/Articulos.class.php", { "action": "eliminarFoto",codigo:codigo,id:id  }, function(data) {
            getImagenesArticulo();
        }, "json"); 
    }
}