var openForm = false;

function configurarClientes() {
    $('#clientes').DataTable( {
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
           $("div.toolbar").html('<button type="button" id="add_button_clientes" onclick="addUI()">Nuevo Registro</button>');           
        },
        "autoWidth": false
    }); 
     
    
    window.addEventListener('resize', function(event){
        if(openForm){
           centerForm();
        }
    });   
     
} 
 

function editUI(pk){
    $.ajax({
        type: "POST",
        url: "clientes/ABMClientes.class.php",
        data: {action: "editUI" , pk: pk,  usuario: getNick()},
        async: true,
        dataType: "html",
        beforeSend: function () {
            $(".form").html("");
             $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        complete: function (objeto, exito) {
            if (exito === "success") {                          
                var form = objeto.responseText;                  
                centerForm(); 
                $(".form").html(form);
                $("#msg").html("");   
                $( "#tabs" ).tabs();
                getMoviles();
            }else{
                $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
            }
        },
        error: function () {
           $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });   
}

function addUI(){
    $.ajax({
        type: "POST",
        url: "clientes/ABMClientes.class.php",
        data: {action: "addUI" ,  usuario: getNick()},
        async: true,
        dataType: "html",
        beforeSend: function () {
            $(".form").html("");
             $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        complete: function (objeto, exito) {
            if (exito === "success") {                          
                var form = objeto.responseText;                  
                centerForm(); 
                $(".form").html(form);
                $("#msg").html("");                 
            }else{
                $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
            }
        },
        error: function () {
           $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
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
   
   var table = form.substring(4,60);     console.log(table);
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
     data[column_name]=val;
     
  });   
  if($(".required").length === 0 ){
    var master = {                  
          data:data         
    };
    $.ajax({
          type: "POST",
          url: "clientes/ABMClientes.class.php",
          data: {action: "addData" , master: master,  usuario: getNick()},        
          async: true,
          dataType: "json",
          beforeSend: function () {
              $("#msg_clientes").addClass("error");
              $("#"+form+" input[id="+table+"_save_button]").prop("disabled",true);
              $("#msg_clientes").html("Insertando... <img src='../img/loading_fast.gif'  >");
          },
          success: function (data) {   

              if(data.mensaje === "Ok"){ 
                  $("#msg_clientes").html(data.mensaje);
                  $("#"+form+" input[id="+table+"_close_button]").fadeIn();
                  var cod_cli = data.cod_cli;
                  editUI(cod_cli);
              }else{
                  $("#"+form+" input[id="+table+"_save_button]").prop("disabled",false);
                  $("#msg_clientes").html(data.mensaje+" Rellene los campos requeridos y vuelva a intentarlo si el problema persiste contacte con el Administrador del sistema.");
              }           
          },
          error: function (err) { 
            $("#msg_clientes").addClass("error");
            $("#"+form+" input[id="+table+"_save_button]").prop("disabled",false);
            $("#msg_clientes").html('Error al Registrar: Rellene los campos requeridos y vuelva a intentarlo.<a href="javascript:showTechnicalError()">Mas info</a>\n\
            <div class="technical_info">'+err.responseText+'</div>');         
          }
      });  
     }else{
      $("#msg_clientes").addClass("error");  
      $("#msg_clientes").html("Rellene los campos requeridos...");
    }
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
              url: "clientes/ABMClientes.class.php",
              data: {action: "updateData" , master: master,  usuario: getNick()},        
              async: true,
              dataType: "json",
              beforeSend: function () {
                  $("#"+form+" input[id="+table+"_update_button]").prop("disabled",true);
                  $("#msg_clientes").html("Actualizando... <img src='img/loading_fast.gif'  >");
              },
              success: function (data) {                
                  if(data.mensaje === "Ok"){ 
                      $("#msg_clientes").html(data.mensaje);
                      $("#"+form+" input[id="+table+"_close_button]").fadeIn();
                  }else{
                      $("#"+form+" input[id="+table+"_update_button]").prop("disabled",false);
                      $("#msg_clientes").html(data.mensaje+' intente nuevamente si el problema persiste contacte con el Administrador del sistema.<a href="javascript:showTechnicalError()">Mas info</a><div class="technical_info">'+data.query+'</div>');
                  }           
              },
              error: function (err) { 
                $("#msg_clientes").addClass("error");
                $("#msg_clientes").html('Error al Registrar: Verifique los datos y vuelva a intentarlo.<a href="javascript:showTechnicalError()">Mas info</a>\n\
                <div class="technical_info">'+err.responseText+'</div>');  
                $("#"+form+" input[id="+table+"_update_button]").prop("disabled",false); 
              }
        }); 
  }else{
    $("#msg_clientes").addClass("error");  
    $("#msg_clientes").html("Rellene los campos requeridos...");
  }
}

// LLama los validadores
function checkRUC(Obj) {
    var ruc = $.trim(Obj.val()); 
    var tipo_doc = $("#form_tipo_doc").val();     
     
    $("#msg_ruc" ).html("");
    if (!validRUC(ruc) && tipo_doc == "C.I." && !isNaN(ruc)) {
        $.ajax({
            type: "POST",
            url: "Ajax.class.php",
            data: { "action": "calcularDV", "ci": parseInt(ruc) ,usuario:getNick()},
            async: true,
            dataType: "json",
            beforeSend: function() {
                 
            },
            complete: function(objeto, exito) {
                var respuesta = objeto.responseJSON;
                if (exito == "success" && $.trim(respuesta.CI).length > 0) {
                    Obj.val(respuesta.CI + "-" + respuesta.DV);
                    Obj.removeClass("required");
                    var ruc_dv = $.trim(Obj.val()); 
                    checkearRUC(Obj,ruc_dv, tipo_doc);
                } else {
                    Obj.addClass("required");
                    $("#msg_ruc").html("Caracteres invalidos ...");
                }
                 
            },
            error: function() {
                Obj.addClass("required");
                $("#msg_ruc").html("Ocurrio un error en la comunicacion con el Servidor...");
            }
        });
    } else {
        if ( tipo_doc === "C.I." && validRUC(ruc) ) {
            checkearRUC(Obj,ruc, tipo_doc);
        }else if(tipo_doc !== "C.I."){
            Obj.removeClass("required");
        }else{
            Obj.addClass("required");
            $("#msg_ruc").html("Caracteres invalidos ...");
        }
    }
    
}

function checkearRUC(Obj,ruc, tipo_doc) {
    $.ajax({
        type: "POST",
        url: "Ajax.class.php",
        data: { "action": "checkearRUC", "ruc": ruc, "tipo_doc": tipo_doc },
        async: true,
        dataType: "json",
        beforeSend: function() {
            //$("#msg_ruc").html("<img src='img/activity.gif' width='46px' height='8px' >");
        },
        success: function(data) {
            if (data.length > 0) {
                if (data[0].Status === "Error") {
                    var dv = data[0].dv;
                    $("#msg_ruc").html("El Digito Verificador del RUC debe ser:  " + dv);
                    Obj.addClass("required");
                } else {
                    var nombre = data[0].Cliente;
                    var rc = data[0].RUC;
                    if($("#form_nombre").val() !== nombre){
                       $("#msg_ruc").html("Ya existe un cliente con este RUC <br> " + nombre);
                       Obj.addClass("required");
                    }else{
                       Obj.removeClass("required");
                    }
                }
            } else {
                $("#msg_ruc").html("");
                Obj.removeClass("required");
            }
        }
    });
    
}
function getMoviles(){
   $(".new_movil").val("");
    var cod_cli = $("#form_cod_cli").val();
    $.ajax({
        type: "POST",
        url: "clientes/ABMClientes.class.php",
        data: {action: "getMoviles", cod_ent: cod_cli},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            $(".movil_row").remove();
        },
        success: function (data) {   
            for(var i in data){
                var id = data[i].id;  
                var cliente = data[i].cliente;  
                var chapa = data[i].chapa;
                var marca = data[i].marca;
                var modelo = data[i].modelo;
                $("#moviles").append("<tr class='movil_row movil_"+id+"'' data-id='"+id+"' data-cliente='"+cliente+"'> <td class='itemc'><img class='editar' src='img/car_logos/"+marca+".png' style='height:7mm;'> </td><td class='item editar'>"+modelo+"</td><td class='item editar'>"+chapa+"</td><td class='itemc'><img src='img/trash_mini.png' style='cursor:pointer' onclick=delMovil('"+id+"')></td></tr>");
            } 
            $("#moviles").append("<tr class='movil_row'><td colspan='3'></td><td class='itemc'><img src='img/button-add_blue.png' style='height:7mm;cursor:pointer' onclick='addMovilUI()' ></td><tr>");
            $("#msg").html(""); 
            $(".editar").click(function(){
               var id_ = $(this).parent().attr("data-id");               
               editMovilUI(id_);
            });
            
        },
        error: function (e) {                 
            $("#msg").html("Error obtener moviles:  " + e);   
            errorMsg("Error obtener moviles:  " + e, 10000);
        }
    });     
} 
function getFacturas(tipo){
    var filtro = " = 'Presupuesto'";
    if(tipo == "facturas"){
        filtro = " in('Abierta','Cerrada')";
    }
    var cod_cli = $("#form_cod_cli").val();
    $.ajax({
        type: "POST",
        url: "clientes/ABMClientes.class.php",
        data: {action: "getFacturas", cod_cli: cod_cli, filtro:filtro},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            $(".venta_row").remove();
        },
        success: function (data) {   
            for(var i in data){
                var f_nro = data[i].f_nro;  
                var fecha = data[i].fecha;  
                var total = data[i].total;
                var estado = data[i].estado;                
                $("#"+tipo).append("<tr class='venta_row fila_"+f_nro+"' data-nro='"+f_nro+"'  > <td class='itemc'>"+f_nro+"</td><td class='itemc editar_venta'>"+fecha+"</td><td class='num editar_venta'>"+total+"</td><td class='itemc'>"+estado+"</td></tr>");
            } 
            if(tipo == "presupuestos"){
              $("#"+tipo).append("<tr class='venta_row'><td colspan='3'></td><td class='itemc'><img src='img/button-add_blue.png' style='height:7mm;cursor:pointer' onclick='crearPresupuesto()' ></td><tr>");
           }else{
              $("#"+tipo).append("<tr class='venta_row'><td colspan='3'></td><td class='itemc'><img src='img/button-add_blue.png' style='height:7mm;cursor:pointer' onclick='crearVenta()' ></td><tr>");
           }
            
            $("#msg").html(""); 
            $(".editar_venta").click(function(){
               var nro = $(this).parent().attr("data-nro");               
               alert("Aun en desarrollo"); 
            });
            
        },
        error: function (e) {                 
            $("#msg").html("Error obtener moviles:  " + e);   
            errorMsg("Error obtener moviles:  " + e, 10000);
        }
    });     
}

function getPuntos(){
    var cod_cli = $("#form_cod_cli").val();
    $.ajax({
        type: "POST",
        url: "clientes/ABMClientes.class.php",
        data: {action: "getPuntos", cod_cli: cod_cli},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            $(".puntos_row").remove();
        },
        success: function (data) {   
            for(var i in data){
                var id = data[i].id;  
                var puntos = data[i].puntos;  
                var motivo = data[i].motivo;
                var fecha = data[i].fecha;  
                var fecha_canje = data[i].fecha_canje===null?"":data[i].fecha_canje;
                var estado = data[i].estado;                
                $("#puntos").append("<tr class='puntos_row fila_puntos_"+id+"'  > <td class='itemc'>"+fecha+"</td> <td class='itemc'>"+puntos+"</td><td class='item'>"+motivo+"</td><td class='itemc'>"+fecha_canje+"</td><td class='itemc'>"+estado+"</td></tr>");
            } 
            
            $("#puntos").append("<tr class='puntos_row'><td colspan='4'></td><td class='itemc'><img src='img/button-add_blue.png' style='height:7mm;cursor:pointer' onclick='agregarPuntosUI()' ></td><tr>");
           
            
            $("#msg").html(""); 
             
            
        },
        error: function (e) {                 
            $("#msg").html("Error obtener moviles:  " + e);   
            errorMsg("Error obtener moviles:  " + e, 10000);
        }
    });         
}

function agregarPuntosUI(){
   Swal.fire({
      title: '<big>Agregar  puntos... </big>',
      icon: '',
      html:
        '<div style="text-align:left"><b>Puntos:</b> <input type="number" step="1" style="text-align:center" size="4" id="cant_puntos" value="1"><br>' +
        '<b>Motivo:</b> <input type="text" size="40" id="motivo_puntos" value=""></div>' ,
      showCloseButton: false,
      showCancelButton: true,
      focusConfirm: false,
      confirmButtonText:
        'Agregar Puntos',
      confirmButtonAriaLabel: 'Thumbs up, great!',
      cancelButtonText:
        'Cancelar',
      cancelButtonAriaLabel: 'Thumbs down'
    }).then((result) => {   
        if (result.isConfirmed) {
          var puntos = parseInt($("#cant_puntos").val());   
          var motivo = $("#motivo_puntos").val();   
          if(puntos > 0 && motivo.length > 3){
              agregarPuntos(puntos, motivo);
          }else{
              Swal.fire('Ha ingresados datos incorrectos o invalidos!', '', 'error')
          }
        }  
    });   
}

function agregarPuntos(puntos, motivo){
  var cod_cli = $("#form_cod_cli").val();  
  $.post("clientes/ABMClientes.class.php", { "action": "agregarPuntos" ,cod_cli:cod_cli,puntos:puntos,motivo:motivo,usuario:getNick() }, function(data) {
       getPuntos();  
  }, "json");   
}

function crearPresupuesto(){
    var cod_cli = $("#form_cod_cli").val();    
    genericLoad("ventas/NuevaVenta.class.php?cod_cli="+cod_cli+"&estado=Presupuesto");
}
function crearVenta(){
    var cod_cli = $("#form_cod_cli").val();    
    genericLoad("ventas/NuevaVenta.class.php?cod_cli="+cod_cli+"");
}

function closeForm(){
    $(".form").html("");
    $(".form").fadeOut();
    openForm = false;
    genericLoad("clientes/ABMClientes.class.php");
}
function closeMovilForm(){
    var cod_cli = $("#form_codigo_entidad").val();    
    $(".form").html("");
    $(".form").fadeOut();
    openForm = false;    
    editUI(cod_cli);
}


