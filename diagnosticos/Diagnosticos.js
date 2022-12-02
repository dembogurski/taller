var openForm = false;
var printing;

function configurarDiagnosticos(){
    $('#diagnosticos').DataTable( {
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
           $("div.toolbar").html('<button type="button" id="add_button_diagnosticos" onclick="addDiagUI()">Nuevo Diagnostico</button>');           
        },
        "autoWidth": false
    });  
     
    
    window.addEventListener('resize', function(event){
        if(openForm){
           centerForm();
        }
    });   
     
} 
 

function editDiagUI(pk){
    $.ajax({
        type: "POST",
        url: "diagnosticos/Diagnosticos.class.php",
        data: {action: "editUI" , pk: pk,  usuario: getNick()},
        async: true,
        dataType: "html",
        beforeSend: function () {
            $(".form").html("");
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
            $(".add_button").remove(); 
        },
        complete: function (objeto, exito) {
            if (exito === "success") {                          
                var form = objeto.responseText;                  
                centerForm(); 
                $(".form").html(form);
                $("#msg").html("");  
                getDetalleDiagnostico();
            }else{
                $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
            }
        },
        error: function () {
           $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });   
}

function getDetalleDiagnostico(){
    var id_diag = $("#form_id_diag").val();
    $.post("diagnosticos/Diag_det.class.php", { id_diag: id_diag }, function(data) {
        $("#detalle_diagnostico").html(data);
        $("#detalle_diagnostico").append('<div style="text-align:right;"><img style="height:30px;margin-right:4px" src="img/button-add_blue.png"  onclick="addDiag_detUI()"></div>')                    
    });    
}

function addDiagUI(id_recep,chapa){
    $.ajax({
        type: "POST",
        url: "diagnosticos/Diagnosticos.class.php",
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
                $("#form_usuario").val(getNick());
                if(id_recep !== undefined){
                    $("#form_id_rec").val(id_recep);
                    $("#form_chapa").val(chapa); 
                }
            }else{
                $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
            }
        },
        error: function () {
           $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });   
}

function selectChapa(){
    var chapa = $("#form_id_rec :selected").attr("data-chapa");
    $("#form_chapa").val(chapa);
    
}

function centerForm(){
   var w = $(document).width();
   var h = $(document).height();
   $(".form").width(w);
   $(".form").height(h);   
   $(".form").fadeIn();
   openForm = true; 
}

function addDiagData(form){
   var data = {}; 
   
   var table = form.substring(4,60);     console.log(table);
   $("#"+form+" [id^='form_']").each(function(){
     
     var pk = $(this).hasClass("PRI");
     var column_name = $(this).attr("id").substring(5,60);
     var val = $(this).val(); 
     if(column_name === "fecha_ingreso"){
        val = $("#form_fecha_ingreso").val().replace("T"," ");
     }
        
     if(column_name === "fecha_salida" && val === ""){
        val = "2000-01-01 00:00:00";
     }
     
     $("#form_fecha_salida").val().replace("T"," ")
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
          url: "diagnosticos/Diagnosticos.class.php",
          data: {action: "addData" , master: master,  usuario: getNick()},        
          async: true,
          dataType: "json",
          beforeSend: function () {
              $("#msg_diagnosticos").addClass("error");
              $("#"+form+" input[id="+table+"_save_button]").prop("disabled",true);
              $("#msg_diagnosticos").html("Insertando... <img src='../img/loading_fast.gif'  >");
          },
          success: function (data) {   

              if(data.mensaje === "Ok"){ 
                  $("#msg_diagnosticos").html(data.mensaje);
                  $("#"+form+" input[id="+table+"_close_button]").fadeIn();
                  var id_diag = data.id_diag;
                  editDiagUI(id_diag);
              }else{
                  $("#"+form+" input[id="+table+"_save_button]").prop("disabled",false);
                  $("#msg_diagnosticos").html(data.mensaje+" Rellene los campos requeridos y vuelva a intentarlo si el problema persiste contacte con el Administrador del sistema.");
              }           
          },
          error: function (err) { 
            $("#msg_diagnosticos").addClass("error");
            $("#"+form+" input[id="+table+"_save_button]").prop("disabled",false);
            $("#msg_diagnosticos").html('Error al Registrar: Rellene los campos requeridos y vuelva a intentarlo.<a href="javascript:showTechnicalError()">Mas info</a>\n\
            <div class="technical_info">'+err.responseText+'</div>');         
          }
      });  
     }else{
      $("#msg_diagnosticos").addClass("error");  
      $("#msg_diagnosticos").html("Rellene los campos requeridos...");
    }
}
function showTechnicalError(){
    $(".technical_info").fadeToggle();
}

function updateDiagData(form){
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
              url: "diagnosticos/Diagnosticos.class.php",
              data: {action: "updateData" , master: master,  usuario: getNick()},        
              async: true,
              dataType: "json",
              beforeSend: function () {
                  $("#"+form+" input[id="+table+"_update_button]").prop("disabled",true);
                  $("#msg_diagnosticos").html("Actualizando... <img src='../img/loading_fast.gif'  >");
              },
              success: function (data) {                
                  if(data.mensaje === "Ok"){ 
                      $("#msg_diagnosticos").html(data.mensaje);
                      $("#"+form+" input[id="+table+"_close_button]").fadeIn();
                  }else{
                      $("#"+form+" input[id="+table+"_update_button]").prop("disabled",false);
                      $("#msg_diagnosticos").html(data.mensaje+' intente nuevamente si el problema persiste contacte con el Administrador del sistema.<a href="javascript:showTechnicalError()">Mas info</a><div class="technical_info">'+data.query+'</div>');
                  }           
              },
              error: function (err) { 
                $("#msg_diagnosticos").addClass("error");
                $("#msg_diagnosticos").html('Error al Registrar: Verifique los datos y vuelva a intentarlo.<a href="javascript:showTechnicalError()">Mas info</a>\n\
                <div class="technical_info">'+err.responseText+'</div>');         
              }
        }); 
  }else{
    $("#msg_diagnosticos").addClass("error");  
    $("#msg_diagnosticos").html("Rellene los campos requeridos...");
  }
}

function closeForm(){
    $(".form").html("");
    $(".form").fadeOut();
    openForm = false;
}

function crearOrdenTrabajo(){
    var nro_diag = $("#form_id_diag").val();    
    var chapa = $(".nro_chapa").html();
    addOrdenesTrabajoUI(nro_diag,chapa);
    //genericLoad("diagnosticos/OrdenesTrabajo.class.php?estado=crearOrdenTrabajo&nro_diag="+nro_diag+"&chapa="+chapa+"");
}

function imprimirDiagnostico(){
    var id_diag = $("#form_id_diag").val();
    var usuario = getNick();       
    var url = "diagnosticos/DiagPrint.class.php?id_diag="+id_diag+"&usuario="+usuario;
    var title = "Diagnostico de Vehiculo";
    var params = "width=760,height=800,scrollbars=yes,menubar=yes,alwaysRaised = yes,modal=yes,location=no";
     
    if(!printing){        
        printing = window.open(url,title,params);
    }else{
        printing.close();
        printing = window.open(url,title,params);
    }         
}