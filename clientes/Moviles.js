var openForm = false;

function configurar() {
    $('#moviles').DataTable( {
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
           $("div.toolbar").html('<button type="button" id="add_button_moviles" onclick="addMovilUI()">Nuevo Vehiculo</button>');           
        },
        "autoWidth": false
    } );
     
    
    window.addEventListener('resize', function(event){
        if(openForm){
           centerForm();
        }
    });   
     
}  


function addMovilUI(){
    var cod_cli = $("#form_cod_cli").val();
    var cliente = $("#form_nombre").val(); 
    $.ajax({
        type: "POST",
        url: "clientes/Moviles.class.php",
        data: {action: "addMovilUI" ,cod_cli:cod_cli,cliente:cliente,  usuario: getNick()},
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
                $(".uppercase").change(function(){
                     $(this).val($(this).val().toUpperCase());
                });
                $("#form_cliente").keyup(function(){
                    buscarCliente();  
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
function buscarCliente(){ // Utilizado en Moviles add_form
   var filter = $("#form_cliente").val();
   $.ajax({
        type: "POST",
        url: "recepcion/Recepcion.class.php",
        data: {action: "buscarClientes" , filter: filter },        
        async: true,
        dataType: "json",
        beforeSend: function () {             
           //$("#form_cod_cli").css("background","#FFF url(img/loading_fast.gif) no-repeat 165px");  
        },
        success: function (data) {   
            var clientes = "<ul id='lista_clientes'>";
            if(data.length > 0){ 
               for(var i in data){
                  var codigo = data[i].cod_cli;
                  var nombre = data[i].nombre;
                  clientes+="<li class='cli_"+codigo+"' onclick=selectPropietario('"+codigo+"')>"+nombre+"</li>"; 
               }                
               $("#suggesstion-box").show();
	       $("#suggesstion-box").html(clientes);
	        
            } ; 
            clientes+="</ul>";
            $("#form_cod_cli").css("background","#FFF");
        },
        error: function (err) { 
           console.log("Error: "+err);
        }
    });     
}
function selectPropietario(codigo) {
    $("#form_codigo_entidad").val(codigo);
    $("#form_cliente").val($(".cli_"+codigo).text());
    $("#suggesstion-box").hide();
}
function delMovil(id){
    var c = confirm("Confirma que desea Eliminar este Vehiculo?");
    if(c){
        var cod_cli = $("#form_cod_cli").val();
        $.post("clientes/ABMClientes.class.php", { action: "delMovil", cod_ent: cod_cli,id:id} , function(data) {
           getMoviles();
        });
    }
}
 
function editMovilUI(pk){
    var cod_cli = $("#form_cod_cli").val();
    var cliente = $(".movil_"+pk).attr("data-cliente");
    $.ajax({
        type: "POST",
        url: "clientes/Moviles.class.php",
        data: {action: "editMovilUI" ,cod_ent:cod_cli, pk: pk,cliente:cliente, usuario: getNick()},
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
                $("#tabs_vehiculos").tabs();
                $(".explorer").change(function(){
                    addCaptureMode();  
                });
                configurarCamaras();
                getImagenesVehiculo();
            }else{
                $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
            }
        },
        error: function () {
           $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });   
}

function addMovilData(form){
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
     data[column_name]=val;
     
  });   
  if($(".required").length === 0 ){
    var master = {                  
          data:data         
    };
    $.ajax({
          type: "POST",
          url: "clientes/Moviles.class.php",
          data: {action: "addData" , master: master,  usuario: getNick()},        
          async: true,
          dataType: "json",
          beforeSend: function () {
              $("#msg_moviles").addClass("error");
              $("#"+form+" input[id="+table+"_save_button]").prop("disabled",true);
              $("#msg_moviles").html("Insertando... <img src='img/loading_fast.gif'  >");
          },
          success: function (data) {   

              if(data.mensaje === "Ok"){  
                  $("#msg_moviles").html(data.mensaje);
                  $("#"+form+" input[id="+table+"_close_button]").fadeIn();
                  editMovilUI(data.id_movil);
              }else{
                  $("#"+form+" input[id="+table+"_save_button]").prop("disabled",false);
                  $("#msg_moviles").html(data.mensaje+" Rellene los campos requeridos y vuelva a intentarlo si el problema persiste contacte con el Administrador del sistema.");
              }  
              $(".explorer").change(function(){
                  addCaptureMode();  
              });
              configurarCamaras();
          },
          error: function (err) { 
            $("#msg_moviles").addClass("error");
            $("#"+form+" input[id="+table+"_save_button]").prop("disabled",false);
            $("#msg_moviles").html('Error al Registrar: Rellene los campos requeridos y vuelva a intentarlo.<a href="javascript:showTechnicalError()">Mas info</a>\n\
            <div class="technical_info">'+err.responseText+'</div>');         
          }
      });  
     }else{
      $("#msg_moviles").addClass("error");  
      $("#msg_moviles").html("Rellene los campos requeridos...");
    }
}
function updateMovilData(form){
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
              url: "clientes/Moviles.class.php",
              data: {action: "updateData" , master: master,  usuario: getNick()},        
              async: true,
              dataType: "json",
              beforeSend: function () {
                  $("#"+form+" input[id="+table+"_update_button]").prop("disabled",true);
                  $("#msg_moviles").html("Actualizando... <img src='img/loading_fast.gif'  >");
              },
              success: function (data) {                
                  if(data.mensaje === "Ok" || data.mensaje === "Sin Modificaciones"){ 
                      $("#msg_moviles").html(data.mensaje);
                      $("#"+form+" input[id="+table+"_close_button]").fadeIn();
                  }else{
                      $("#"+form+" input[id="+table+"_update_button]").prop("disabled",false);
                      $("#msg_moviles").html(data.mensaje+' intente nuevamente si el problema persiste contacte con el Administrador del sistema.<a href="javascript:showTechnicalError()">Mas info</a><div class="technical_info">'+data.query+'</div>');
                  }           
              },
              error: function (err) { 
                $("#msg_moviles").addClass("error");
                $("#msg_moviles").html('Error al Registrar: Verifique los datos y vuelva a intentarlo.<a href="javascript:showTechnicalError()">Mas info</a>\n\
                <div class="technical_info">'+err.responseText+'</div>');         
              }
        }); 
  }else{
    $("#msg_moviles").addClass("error");  
    $("#msg_moviles").html("Rellene los campos requeridos...");
  }
}


function centerForm(){
   var w = $(document).width();
   var h = $(document).height();
   $(".form").width(w);
   $(".form").height(h);   
   $(".form").fadeIn();
   openForm = true; 
} 
function closeMovilForm(){
    $(".form").html("");
    $(".form").fadeOut();
    openForm = false;
}

function configurarCamaras(){
   $('.inputfile').change(function(evt) {
        var id = $(this).attr("id").substring(5,10);
         
        var files = evt.target.files;
        var file = files[0];  

        if (file) {
            var reader = new FileReader();
            reader.onload = function(e) {
                document.getElementById('preview_'+id).src = e.target.result;
                resizeImage(id);
            };
            reader.readAsDataURL(file);
        }   
    });  
     
    addCaptureMode();  
     
}

function addCaptureMode(){ 
    var chk = $(".explorer:checked").val();   
    if(chk === "camera"){
        $(".inputfile").prop("capture","camera");
    }else{
        $(".inputfile").removeAttr("capture");
    }    
}


function resizeImage(id) {  
    if (window.File && window.FileReader && window.FileList && window.Blob) {
        var filesToUploads = document.getElementById('file_'+id).files;
        var file = filesToUploads[0];
        if (file) {

            var reader = new FileReader();
            // Set the image once loaded into file reader
            reader.onload = function(e) {

                var img = document.createElement("img");
                img.src = e.target.result;

                var canvas = document.createElement("canvas");
                var ctx = canvas.getContext("2d");
                ctx.drawImage(img, 0, 0);

                var MAX_WIDTH = 800;
                var MAX_HEIGHT = 600;
                var width = img.width;
                var height = img.height;

                if (width > height) {
                    if (width > MAX_WIDTH) {
                        height *= MAX_WIDTH / width;
                        width = MAX_WIDTH;
                    }
                } else {
                    if (height > MAX_HEIGHT) {
                        width *= MAX_HEIGHT / height;
                        height = MAX_HEIGHT;
                    }
                }
                canvas.width = width;
                canvas.height = height;
                var ctx = canvas.getContext("2d");
                ctx.drawImage(img, 0, 0, width, height);

                dataurl = canvas.toDataURL(file.type);
                console.log(dataurl);
                uploadCarImage(dataurl);
                document.getElementById('form_url_img_'+id).value = dataurl;
                //addPhotoButton();
            };
            reader.readAsDataURL(file);

        }

    } else {
        alert('Esta Api no es soportada por este navegador');
    }
}

function uploadCarImage(imgData){
   var id_movil = $("#id_movil").val();
    
   $.ajax({
        type: "POST",
        url: "clientes/Moviles.class.php",
        data: {action: "uploadCarImage" ,id_movil:id_movil, imgData: imgData,  usuario: getNick()},        
        async: true,
        dataType: "json",
        beforeSend: function () { 
            $("#preview_0").html("Subiendo... <img src='img/loading_fast.gif'  >");
        },
        success: function (data) {                
            if(data.mensaje === "Ok"){ 
                $("#preview_0").html("Ok"); 
                getImagenesVehiculo();
            }else{ 
                $("#msg_moviles").html(data.mensaje+' intente nuevamente si el problema persiste contacte con el Administrador del sistema.<a href="javascript:showTechnicalError()">Mas info</a><div class="technical_info">'+data.query+'</div>');
            }           
        },
        error: function (err) { 
          $("#preview_0").addClass("error"); 
        }
  });   
}


function getImagenesVehiculo(){
    var id_movil = $("#id_movil").val();
    $.ajax({
        type: "POST",
        url: "clientes/Moviles.class.php",
        data: {action: "getImagenesVehiculo",id_movil:id_movil, suc: getSuc(), usuario: getNick()},
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
                    var url = data[i].url_img;
                    var princ= data[i].principal;
                    var checked = ""; 
                    
                    var nomenc = "Convertir en Principal";
                    if(princ == "Si"){   
                        nomenc = "Imagen principal";
                        checked = "checked='checked'"; 
                        $("#mov_image").html('<img class="mov_image" src= "'+url+'">');
                    }else{
                        nomenc = "Convertir en Principal";
                    }
                    //<div class="princ_'+princ+'" ><label>'+nomenc+'</label><input type="radio" name="img_group" '+checked+'  data-id="'+id_img+'"></div>\n\
                    var div = '<div  class="design_div div_'+id_img+'" >\n\
                    <img class="imagen_design img_'+id_movil+'_'+id_img+'"  src= "'+url+'" onclick="abrirFoto('+id_img+')" >\n\
                    <div style="text-align:center"><input type="button" value="Quitar" style="font-size:8px" onclick="eliminarFoto('+id_img+')" ></div>\n\
                    </div>';
                    $("#all_photos").append(div);
                }
                configureGroupSetPrinc();
            }         
        },
        error: function (e) {                 
            $("#msg").html("Error en getImagenesVehiculo " + e);                
        }
    }); 
}
function configureGroupSetPrinc(){
    $("input[name=img_group]").click(function(){
        var c = confirm("Confirme que desea establecer esta imagen como principal?");
        if(c){
           var src = $(this).parent().parent().find(".imagen_design").attr("src");
           $(".mov_image").attr("src",src);
           var id = $(this).attr("data-id");
           setPrincipalImage(id);
        }
   });
}
function setPrincipalImage(id){
     
    var id_movil = $("#id_movil").val();
    $.post("clientes/Moviles.class.php", { "action": "setPrincipalImage",id_movil:id_movil,id:id  }, function(data) {
        getImagenesVehiculo();
    }, "json");    
}

function eliminarFoto(id){
    var c = confirm("Confirme que desea eliminar esta foto?");
    if(c){
        $(".div_"+id).html("Eliminando...");
        var id_movil = $("#id_movil").val();
        $.post("clientes/Moviles.class.php", { "action": "eliminarFoto",id_movil:id_movil,id:id  }, function(data) {
            getImagenesArticulo();
        }, "json"); 
    }
}

function abrirFoto(id_img){
    var id_movil = $("#id_movil").val();
    var url_img = $(".img_"+id_movil+"_"+id_img).attr("src");
    window.open(url_img,"Imagen de Vehiculo",""); 
}

function getRecepcionesVehiculo(){
   var chapa = $(".nro_chapa").html(); 
   $.ajax({
        type: "POST",
        url: "recepcion/Recepcion.class.php",
        data: {action: "getRecepcionesVehiculo",chapa:chapa, suc: getSuc(), usuario: getNick()},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $(".collage_div").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {     //id_img,  , principal
            if(data.length > 0){
                $(".collage_div, .boton_nuevo_recepcion").remove();                
                for(var i in data){
                    var id_diag = data[i].id_diag;                    
                    var user = data[i].usuario;
                    var fecha= data[i].fecha;
                    var collage= data[i].collage; 
                    
                    var imgs = "";
                    if(collage != null){
                    var arr = collage.split(",");
                        for( var i = 0; i < arr.length; i++  ){
                           var url = arr[i]; 
                           imgs +='<img class="imagen_collage"  src= "files/recepcion/'+id_diag+'/'+url+'" >';
                           if(i>3){ break; } 
                        }
                    }
                    
                    var div = '<div onclick="editRecepcionUI('+id_diag+')" class="collage_div div_'+id_diag+'" >\n\
                    <div onclick="editRecepcionUI('+id_diag+')" class="titulo_collage"><b>'+user+' &nbsp;-&nbsp; '+fecha+'  </b></div>\n\
                    '+imgs+'</div>';
                    $("#recepciones").append(div);
                } 
            }
            var add_diag = "<div class='itemc boton_nuevo_recepcion'><input type='button' value='Nueva Recepcion' onclick=agregarRecepcion()></div>";
            $("#recepciones").append(add_diag);
            $("#recepciones").css("max-width", $(document).width() - 10);
        },
        error: function (e) {                 
            $("#msg").html("Error en getImagenesVehiculo " + e);                
        }
    }); 
}

function agregarRecepcion(){
    var chapa = $(".nro_chapa").html();
    addRecepcionUI(chapa);
}

function cambiarTipo(){
    var tipo = $("#form_tipo").val();
    $("#img_tipo").attr("src","img/cartypes/"+tipo+".jpg");
}

function cambiarPropietario(){
    var valor = $("#cambiar_propietario").val();
    if(valor == "Cambiar"){
       $("#form_cliente").val("");
       $("#form_cliente").prop("placeholder","Busque aqui el cliente");
       $("#form_cliente").prop("readonly",false);
       $("#form_cliente").focus();
       $("#cambiar_propietario").val("Aceptar");
       $("#form_cliente").keyup(function(){
           buscarCliente();  
        });
    }else{        
        if( $("#form_cliente").val()!= ""){
            $("#cambiar_propietario").val("Cambiar");
            $("#form_cliente").prop("readonly",true);
            updateMovilData("edit_moviles");
            alert("Ok se cambio el propietario!");
        }else{
            alert("Busque un propietario ya registrado.");
            $("#form_cliente").focus();
        }
    }
}
