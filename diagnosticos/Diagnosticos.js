var openForm = false;

function configurar(){
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
		"lengthMenu": [[10, 20, 50, 100, -1], [10, 20, 50, 100, "Todas"]],
		"pageLength": 20,
        dom: 'l<"toolbar">frtip',
        initComplete: function(){
           $("div.toolbar").html('<button type="button" id="add_button_diagnosticos" onclick="addUI()">Nuevo Registro</button>');           
        },
        "autoWidth": false,
         "order": [[ 0, "desc" ]]
    } );
      
    window.addEventListener('resize', function(event){
        if(openForm){
           centerForm();
        }
    });   
    
}  
 

function editUI(pk){
    $.ajax({
        type: "POST",
        url: "diagnosticos/Diagnosticos.class.php",
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
                buscarLogo(); 
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
                buscarLogo(); 
                $("#form_chapa").change(function(){
                    getDatos($(this).val());
                });
            }else{
                $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
            }
        },
        error: function () {
           $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });   
}
function getDatos(chapa){
    $.ajax({
        type: "POST",
        url: "diagnosticos/Diagnosticos.class.php",
        data: {action: "getDatos" , chapa: chapa,  usuario: getNick()},        
        async: true,
        dataType: "json",
        beforeSend: function () {             
            $("#msg_diagnosticos").html("<img src='img/loading_fast.gif'  >");
        },
        success: function (data) {   

            if(data.length > 0){ 
                var marca = data[0].marca;
                var cod_cli = data[0].cod_cli;
                $("#form_marca").val(marca);
                $("#form_cod_cli").val(cod_cli);
                
                buscarLogo(); 
            }else{
                $("#form_cod_cli").val("C000001");
            }    
            $("#msg_diagnosticos").html("");   
        },
        error: function (err) { 
          $("#msg_diagnosticos").addClass("error");
          $("#msg_diagnosticos").html(err);
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
          url: "diagnosticos/Diagnosticos.class.php",
          data: {action: "addData" , master: master,  usuario: getNick()},        
          async: true,
          dataType: "json",
          beforeSend: function () {
              $("#msg_diagnosticos").addClass("error");
              $("#"+form+" input[id="+table+"_save_button]").prop("disabled",true);
              $("#msg_diagnosticos").html("Insertando... <img src='img/loading_fast.gif'  >");
          },
          success: function (data) {   

              if(data.mensaje === "Ok"){ 
                  $("#msg_diagnosticos").html(data.mensaje);
                  $("#"+form+" input[id="+table+"_close_button]").fadeIn();
              }else{
                  $("#"+form+" input[id="+table+"_save_button]").prop("disabled",false);
                  $("#msg_diagnosticos").html(data.mensaje+" Rellene los campos requeridos y vuelva a intentarlo si el problema persiste contacte con el Administrador del sistema.");
              }   
              genericLoad("diagnosticos/Diagnosticos.class.php");
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
              url: "diagnosticos/Diagnosticos.class.php",
              data: {action: "updateData" , master: master,  usuario: getNick()},        
              async: true,
              dataType: "json",
              beforeSend: function () {
                  $("#"+form+" input[id="+table+"_update_button]").prop("disabled",true);
                  $("#msg_diagnosticos").html("Actualizando... <img src='img/loading_fast.gif'  >");
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

 
function buscarLogo(){
    var marca = $("#form_marca").val();
    checkImage("img/car_logos/"+marca+".png", function() {
       $("#logo").attr("src","img/car_logos/"+marca+".png"); 
    }, function() { 
       $("#logo").attr("src","img/car_logos/no_logo.png"); 
    });  
} 

function checkImage(src, good, bad) {
  var img = new Image();
  img.onload = good;
  img.onerror = bad;
  img.src = src;
}

function closeForm(){
    $(".form").html("");
    $(".form").fadeOut();
    openForm = false;
}
function nuevoCliente(){  
     
    var window_width = $(document).width()  / 2;
    var abm_width = $("#abm_cliente").width()  / 2;        
    var posx = (window_width - abm_width) ;   
    $("#abm_cliente").css({left:posx,top:36});   
    $( "#abm_cliente" ).fadeIn();   
     
}

function updateListaClientes(){
    // Buscar Ultimo cliente y Seleccinar
}


function loadImageFileAsURL(id){ 
          
    var filesSelected = document.getElementById("file_"+id).files;
    
    if (filesSelected.length > 0)  {
        var fileToLoad = filesSelected[0];  
        var fileReader = new FileReader(); 
        fileReader.onload = function(fileLoadedEvent){   
            $("#form_url_img_"+id).val(fileLoadedEvent.target.result); 
            var base64 = $("#form_url_img_"+id).val();   
             
            var img = resizedataURL(base64, 100, 60,id);      
            $("#preview_"+id).attr("src",img.src);
            //$("#msg").html("Reduciendo el tama&ntilde;o...<img src='img/activity.gif' width='24px' height='8px' >");
           
        };        
        fileReader.readAsDataURL(fileToLoad);    
         
    }else{
        alert("No se ha tomado ninguna imagen");
    }
}

function resizedataURL(datas, wantedWidth, wantedHeight,id)  {
        // We create an image to receive the Data URI
        var img = document.createElement('img');
        
        // When the event "onload" is triggered we can resize the image.
        img.onload = function() {        
                // We create a canvas and get its context.
                
                var originalwidth = img.width;
                var originalheight = img.height;
                if(originalwidth > originalheight ){
                    wantedWidth = 1024;
                    wantedHeight = 768;
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
                $("#msg").html(document.getElementById("file_"+id).files[0].name); 
                
            };

        // We put the Data URI in the image's src attribute
        img.src = datas;
        return img;
        
        
}