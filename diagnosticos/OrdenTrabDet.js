var openForm = false;
/*
$(document).ready(function() {
    $('#OrdenTrabDet').DataTable( {
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
           $("div.toolbar").html('<button type="button" id="add_button_OrdenTrabDet" onclick="addOrdenTrabDetUI()">Nuevo Registro</button>');           
        },
        "autoWidth": false
    } );
    
     
    
    window.addEventListener('resize', function(event){
        if(openForm){
           centerForm();
        }
    });   
     
} ); */

 

function editOrdenTrabDetUI(id_det){
    var id_orden = $("#form_id_orden").val();
    $.ajax({
        type: "POST",
        url: "diagnosticos/OrdenTrabDet.class.php",
        data: {action: "editUI" , id_orden: id_orden, id_det:id_det, usuario: getNick()},
        async: true,
        dataType: "html",
        beforeSend: function () {
            $(".form_orden_trab_det").html("");
             $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        complete: function (objeto, exito) {
            if (exito === "success") {                          
                var form = objeto.responseText;                  
                centerDetForm(); 
                $(".form_orden_trab_det").html(form);
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

function addOrdenTrabDetUI(){
    var id_orden = $("#form_id_orden").val();
    $.ajax({
        type: "POST",
        url: "diagnosticos/OrdenTrabDet.class.php",
        data: {action: "addUI" , id_orden:id_orden, usuario: getNick()},
        async: true,
        dataType: "html",
        beforeSend: function () {
            $(".form_orden_trab_det").html("");
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        complete: function (objeto, exito) {
            if (exito === "success") {                          
                var form = objeto.responseText;                                  
                $(".form_orden_trab_det").html(form);
                centerDetForm(); 
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
function centerDetForm(){
   var w = $(document).width();
   var h = $(document).height();
   $(".form_orden_trab_det").width(w);
   $(".form_orden_trab_det").height(h);   
   $(".form_orden_trab_det").slideDown();    
}

 

function addOrdenTrabDetData(form){
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
          url: "diagnosticos/OrdenTrabDet.class.php",
          data: {action: "addData" , master: master,  usuario: getNick()},        
          async: true,
          dataType: "json",
          beforeSend: function () {
              $("#msg_OrdenTrabDet").addClass("error");
              $("#"+form+" input[id="+table+"_save_button]").prop("disabled",true);
              $("#msg_OrdenTrabDet").html("Insertando... <img src='../img/loading_fast.gif'  >");
          },
          success: function (data) {   

              if(data.mensaje === "Ok"){ 
                  $("#msg_OrdenTrabDet").html(data.mensaje);
                  $("#"+form+" input[id="+table+"_close_button]").fadeIn();
                  $("#"+form+" input[id="+table+"_next_button]").fadeIn();
                   
              }else{
                  $("#"+form+" input[id="+table+"_save_button]").prop("disabled",false);
                  $("#msg_OrdenTrabDet").html(data.mensaje+" Rellene los campos requeridos y vuelva a intentarlo si el problema persiste contacte con el Administrador del sistema.");
              }           
          },
          error: function (err) { 
            $("#msg_OrdenTrabDet").addClass("error");
            $("#"+form+" input[id="+table+"_save_button]").prop("disabled",false);
            $("#msg_OrdenTrabDet").html('Error al Registrar: Rellene los campos requeridos y vuelva a intentarlo.<a href="javascript:showTechnicalError()">Mas info</a>\n\
            <div class="technical_info">'+err.responseText+'</div>');         
          }
      });  
     }else{
      $("#msg_OrdenTrabDet").addClass("error");  
      $("#msg_OrdenTrabDet").html("Rellene los campos requeridos...");
    }
}

function siguienteDetForm(){
    addOrdenTrabDetUI();
} 

function showTechnicalError(){
    $(".technical_info").fadeToggle();
}

function updateOrdenTrabDetData(form){
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
              url: "diagnosticos/OrdenTrabDet.class.php",
              data: {action: "updateData" , master: master,  usuario: getNick()},        
              async: true,
              dataType: "json",
              beforeSend: function () {
                  $("#"+form+" input[id="+table+"_update_button]").prop("disabled",true);
                  $("#msg_OrdenTrabDet").html("Actualizando... <img src='../img/loading_fast.gif'  >");
              },
              success: function (data) {                
                  if(data.mensaje === "Ok"){ 
                      $("#msg_OrdenTrabDet").html(data.mensaje);
                      $("#"+form+" input[id="+table+"_close_button]").fadeIn();
                  }else{
                      $("#"+form+" input[id="+table+"_update_button]").prop("disabled",false);
                      $("#msg_OrdenTrabDet").html(data.mensaje+' intente nuevamente si el problema persiste contacte con el Administrador del sistema.<a href="javascript:showTechnicalError()">Mas info</a><div class="technical_info">'+data.query+'</div>');
                  }           
              },
              error: function (err) { 
                $("#msg_OrdenTrabDet").addClass("error");
                $("#msg_OrdenTrabDet").html('Error al Registrar: Verifique los datos y vuelva a intentarlo.<a href="javascript:showTechnicalError()">Mas info</a>\n\
                <div class="technical_info">'+err.responseText+'</div>');         
              }
        }); 
  }else{
    $("#msg_OrdenTrabDet").addClass("error");  
    $("#msg_OrdenTrabDet").html("Rellene los campos requeridos...");
  }
}

function closeDetForm(){
    $(".form_orden_trab_det").html("");
    $(".form_orden_trab_det").fadeOut();
   getDetalleOrden();
}