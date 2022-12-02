var openForm = false;

function setSubtotal(){
    $(".recalc").change(function(){
        
       var precio = parseFloat($("#form_precio").val().replace(/\./g,"").replace(",",".")); 
       var cant = parseFloat($("#form_cant").val().replace(/\./g,"").replace(",",".")); 
       if(isNaN(cant)){
           cant = 1;
       } 
        
       var subtotal = (precio * cant).format(2, 3, '.', ',');    
       
       
       
       $("#form_precio").val(precio.format(2, 3, '.', ','));
       $("#form_cant").val(cant.format(2, 3, '.', ','));
       $("#form_subtotal").val(subtotal);
       
    });
}
 
function editDiag_detUI(id_det){
    var id_diag = $("#form_id_diag").val();
    $.ajax({
        type: "POST",
        url: "diagnosticos/Diag_det.class.php",
        data: {action: "editUI" , id_diag: id_diag,id_det:id_det,  usuario: getNick()},
        async: true,
        dataType: "html",
        beforeSend: function () {
            $(".form_diag_det").html("");
             $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        complete: function (objeto, exito) {
            if (exito === "success") {                          
                var form = objeto.responseText;   
                $(".form_diag_det").html(form); 
                centerDetForm(); 
                $("#msg").html("");    
                setSubtotal();
            }else{
                $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
            }
        },
        error: function () {
           $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });   
}


function addDiag_detUI(){
    var id_diag = $("#form_id_diag").val();
    $.ajax({
        type: "POST",
        url: "diagnosticos/Diag_det.class.php",
        data: {action: "addUI" , id_diag:id_diag, usuario: getNick()},
        async: true,
        dataType: "html",
        beforeSend: function () {
            $(".form_diag_det").html("");
             $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        complete: function (objeto, exito) {
            if (exito === "success") {                          
                var form = objeto.responseText;                  
                centerDetForm(); 
                $(".form_diag_det").html(form);
                $("#msg").html("");             
                setSubtotal();
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
   $(".form_diag_det").width(w);
   $(".form_diag_det").height(h);   
   $(".form_diag_det").slideDown();    
}

function addDiag_detData(form){
   var data = {}; 
   
   var table = form.substring(4,60);      
   $("#"+form+" [id^='form_']").each(function(){
     
     var pk = $(this).hasClass("PRI");
     var column_name = $(this).attr("id").substring(5,60);
     var val = $(this).val(); 
     var req = $(this).attr("required");
     if($(this).hasClass("form_number")){
         val = parseFloat($(this).val().replace(/\./g,"").replace(",","."));
     } 
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
          url: "diagnosticos/Diag_det.class.php",
          data: {action: "addData" , master: master,  usuario: getNick()},        
          async: true,
          dataType: "json",
          beforeSend: function () {
              $("#msg_diag_det").addClass("error");
              $("#"+form+" input[id="+table+"_save_button]").prop("disabled",true);
              $("#msg_diag_det").html("Insertando... <img src='../img/loading_fast.gif'  >");
          },
          success: function (data) {   

              if(data.mensaje === "Ok"){ 
                  $("#msg_diag_det").html(data.mensaje);
                  $("#"+form+" input[id="+table+"_close_button]").fadeIn();
                  $("#"+form+" input[id="+table+"_next_button]").fadeIn();
                  getDetalleDiagnostico();
              }else{
                  $("#"+form+" input[id="+table+"_save_button]").prop("disabled",false);
                  $("#msg_diag_det").html(data.mensaje+" Rellene los campos requeridos y vuelva a intentarlo si el problema persiste contacte con el Administrador del sistema.");
              }           
          },
          error: function (err) { 
            $("#msg_diag_det").addClass("error");
            $("#"+form+" input[id="+table+"_save_button]").prop("disabled",false);
            $("#msg_diag_det").html('Error al Registrar: Rellene los campos requeridos y vuelva a intentarlo.<a href="javascript:showTechnicalError()">Mas info</a>\n\
            <div class="technical_info">'+err.responseText+'</div>');         
          }
      });  
     }else{
      $("#msg_diag_det").addClass("error");  
      $("#msg_diag_det").html("Rellene los campos requeridos...");
    }
}
function showTechnicalError(){
    $(".technical_info").fadeToggle();
}

function updateDiag_detData(form){
  var update_data = {};
  var primary_keys = {};  
  var table = form.substring(5,60);   
  $("#"+form+" [id^='form_']").each(function(){
       
     var pk = $(this).hasClass("PRI");
     var column_name = $(this).attr("id").substring(5,60);
     var val = $(this).val();
     var req = $(this).attr("required");
     if($(this).hasClass("form_number")){
         val = parseFloat($(this).val().replace(/\./g,"").replace(",","."));
     }
      
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
              url: "diagnosticos/Diag_det.class.php",
              data: {action: "updateData" , master: master,  usuario: getNick()},        
              async: true,
              dataType: "json",
              beforeSend: function () {
                  $("#"+form+" input[id="+table+"_update_button]").prop("disabled",true);
                  $("#msg_diag_det").html("Actualizando... <img src='../img/loading_fast.gif'  >");
              },
              success: function (data) {                
                  if(data.mensaje === "Ok"){ 
                      $("#msg_diag_det").html(data.mensaje);
                      $("#"+form+" input[id="+table+"_close_button]").fadeIn();                      
                  }else{
                      $("#"+form+" input[id="+table+"_update_button]").prop("disabled",false);
                      $("#msg_diag_det").html(data.mensaje+' intente nuevamente si el problema persiste contacte con el Administrador del sistema.<a href="javascript:showTechnicalError()">Mas info</a><div class="technical_info">'+data.query+'</div>');
                  }           
              },
              error: function (err) { 
                $("#msg_diag_det").addClass("error");
                $("#msg_diag_det").html('Error al Registrar: Verifique los datos y vuelva a intentarlo.<a href="javascript:showTechnicalError()">Mas info</a>\n\
                <div class="technical_info">'+err.responseText+'</div>');         
              }
        }); 
  }else{
    $("#msg_diag_det").addClass("error");  
    $("#msg_diag_det").html("Rellene los campos requeridos...");
  }
}

function closeDiag_detForm(){
    $(".form_diag_det").html("");
    $(".form_diag_det").fadeOut();   
    getDetalleDiagnostico();
}