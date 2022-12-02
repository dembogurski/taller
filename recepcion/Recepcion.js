var openForm = false;

var current_id = 0;

var clientes = null;

var datos_recepcion = false; 

var printing;

var availableTags = [
	{key: "1",value: "NAME 1"},{key: "2",value: "NAME 2"},{key: "3",value: "NAME 3"},{key: "4",value: "NAME 4"},{key: "5",value: "NAME 5"}
	 ];

function configurarRecepcion(){
    $('#recepcion').DataTable( {
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
           $("div.toolbar").html('<img src="img/turbo.png" height="24" onclick="turboFind()" style="margin-botom:-6px;cursor:pointer"><button type="button" id="add_button_recepcion" onclick="addRecepcionUI()" style="margin:0px 20px 4px 4px;font-size:16px;font-weight:bolder">Nueva Recepcion</button>');           
        },
        "autoWidth": false,
         "order": [[ 0, "desc" ]]
    } );
      
    window.addEventListener('resize', function(event){
        if(openForm){
           centerForm();
        }
    });   
    $("#recepcion_filter").find("[type=search]").val($("#filter").val());
    $(window).on("navigate", function (event, data) {
        var direction = data.state.direction; alert(direction);
        if (direction == 'back') {  
           showMenu();
        } 
    });    
}  
function buscarPropietario(){
    var form_chapa = $("#form_chapa").val();
    $.ajax({
        type: "POST",
        url: "recepcion/Recepcion.class.php",
        data: {action: "buscarPropietario" , form_chapa: form_chapa,  usuario: getNick()},        
        async: true,
        dataType: "json",
        beforeSend: function () {             
            $("#msg_recepcion").html("<img src='img/loading_fast.gif'  >");
        },
        success: function (data) {   

            if(data.length > 0){  
                var nombre = data[0].cliente;
                var codigo_entidad = data[0].codigo_entidad;
                var marca = data[0].marca; 
                $("#form_marca").val(marca);
                $("#form_cod_cli").val(nombre);
                $("#form_cod_cli").attr("data-cod_cli",codigo_entidad);
                $("#form_marca").val(marca);
                buscarLogo();                
            }else{
                $("#msg_recepcion").val("C000001");
            }    
            $("#msg_recepcion").html("");   
        },
        error: function (err) { 
          $("#msg_recepcion").addClass("error");
          $("#msg_recepcion").html(err);
        }
    });         
}
 
function turboFind(){
    var search = $("#recepcion_filter").find("[type=search]").val();
    genericLoad("recepcion/Recepcion.class.php?filter="+search+"");
} 

function editRecepcionUI(pk){
    $.ajax({
        type: "POST",
        url: "recepcion/Recepcion.class.php",
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
                
                $(".form").html(form);
                $("#msg").html("");  
                buscarLogo(); 
                centerForm(); 
                $("#form_recepcion").height(2048);
                getImagesOfRecepcion();
                datos_recepcion = false;
                $(".diag_print").fadeIn();
            }else{
                $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
            }
        },
        error: function () {
           $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });   
}
function getImagesOfRecepcion(){
    var id_diag = $("#form_id_diag").val();
    $.ajax({
        type: "POST",
        url: "recepcion/Recepcion.class.php",
        data: {action: "getImagesOfRecepcion" , id_diag: id_diag,  usuario: getNick()},        
        async: true,
        dataType: "json",
        beforeSend: function () {             
            $("#msg_recepcion").html("<img src='img/loading_fast.gif'  >");
        },
        success: function (data) {   

            if(data.length > 0){ 
                for(var i in data){
                    var url = data[i].url;
                    var descrip = data[i].descrip;
                    var img_path = "files/recepcion/"+id_diag+"/"+url;
                    var tr = '<tr class="fila_diag"><td style="width:10%;font-weight:bolder" >Diag '+i+'</td><td class="diag_descrip">'+descrip+'</td><td><img onclick=verImagen("'+img_path+'") src="'+img_path+'" width="50"></td></tr>';
                    $("#photo_container").append(tr);
                }
            }else{
               // $("#form_cod_cli").val("C000001");
                console.log('Se desabilito $("#form_cod_cli").val("C000001");');
            }    
            $("#msg_recepcion").html("");   
        },
        error: function (err) { 
          $("#msg_recepcion").addClass("error");
          $("#msg_recepcion").html(err);
        }
    });        
}

function verImagen(url){
    var params = "width=1024,height=760,scrollbars=yes,menubar=yes,alwaysRaised = yes,modal=no,location=no";
    var title = "Imagen de Recepcion";
    window.open(url,title,params);
}

function addRecepcionUI(chapa){
    $.ajax({
        type: "POST",
        url: "recepcion/Recepcion.class.php",
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
                $("#form_recepcion").height(2048);
                $(".form").html(form);
                $("#msg").html("");  
                $("#form_usuario").val(getNick());
                buscarLogo(); 
                $("#form_chapa").change(function(){
                    getDatos($(this).val());
                });
                $(".explorer").change(function(){
                    addCaptureMode();  
                });
                configurarCamaras();
                $("#form_cod_cli").keyup(function(){
                    buscarClientes();  
                });
                if(chapa !== undefined){
                   $("#form_chapa").val(chapa); 
                   $("#form_chapa").trigger("change"); 
                }
                datos_recepcion = false;
            }else{
                $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
            }
        },
        error: function () {
           $("#msg").html("Ocurrio un error en la comunicacion con el Servidor...");
        }
    });   
}
function buscarClientes(){
   var filter = $("#form_cod_cli").val();
   $.ajax({
        type: "POST",
        url: "recepcion/Recepcion.class.php",
        data: {action: "buscarClientes" , filter: filter },        
        async: true,
        dataType: "json",
        beforeSend: function () {             
           $("#form_cod_cli").css("background","#FFF url(img/loading_fast.gif) no-repeat 165px");  
        },
        success: function (data) {   
            var clientes = "<ul id='lista_clientes'>";
            if(data.length > 0){ 
               for(var i in data){
                  var codigo = data[i].cod_cli;
                  var nombre = data[i].nombre;
                  clientes+="<li class='cli_"+codigo+"' onclick=selectCliente('"+codigo+"')>"+nombre+"</li>"; 
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
function selectCliente(codigo) {
    $("#form_cod_cli").val($(".cli_"+codigo).text());
    $("#form_cod_cli").attr("data-cod_cli",codigo);
    $("#suggesstion-box").hide();
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

function addPhotoButton(){
    current_id++;
    var curplus = current_id + 1;
    var photoButton = '\
       <tr> <td class="fila_img">Diag '+curplus+':</td> <td>\n\
        <textarea class="form_textarea" id="form_img_descrip_'+current_id+'" cols="30" rows="3" style="height: auto"   ></textarea>\n\
       </td>\n\
       <td>\n\
           <img src="img/no_img.png" id="preview_'+current_id+'" width="46" class="img_preview">\n\
           <input type="file" id="file_'+current_id+'" accept="image/*"   class="inputfile" ><label class="capturar"   for="file_'+current_id+'"></label> <textarea class="form_textarea diag_img" id="form_url_img_'+current_id+'" cols="40" rows="3"   ></textarea> \n\
        </td>\n\
      </tr>';
    $("#photo_container").append(photoButton);
    configurarCamaras();
}

function getDatos(chapa){
    $.ajax({
        type: "POST",
        url: "recepcion/Recepcion.class.php",
        data: {action: "getDatos" , chapa: chapa,  usuario: getNick()},        
        async: true,
        dataType: "json",
        beforeSend: function () {             
            $("#msg_recepcion").html("<img src='img/loading_fast.gif'  >");
        },
        success: function (data) {   

            if(data.length > 0){ 
                var marca = data[0].marca;
                var modelo = data[0].modelo;
                var cod_cli = data[0].cod_cli;
                var cliente = data[0].nombre;
                $("#form_marca").val(marca);
                $("#form_cod_cli").attr("data-cod_cli",cod_cli);
                $("#cliente").val(cliente);
                $("#logo").attr("src","img/car_logos/"+marca+".png");
                $("#modelo").text(modelo); 
            }else{
                $("#form_cod_cli").val("C000001");
                $("#form_cod_cli").attr("data-cod_cli","C000001");
            }    
            $("#msg_recepcion").html("");   
        },
        error: function (err) { 
          $("#msg_recepcion").addClass("error");
          $("#msg_recepcion").html(err);
        }
    });     
}

function datosRecepcion(id_diag){
   if(!datos_recepcion){
        $.ajax({
             type: "POST",
             url: "recepcion/Recepcion.class.php",
             data: {action: "getDatosRecepcion" , id_diag: id_diag,  usuario: getNick()},        
             async: true,
             dataType: "json",
             beforeSend: function () {             
                 $("#msg_recepcion").html("<img src='img/loading_fast.gif'  >");
             },
             success: function (data) {   
                 if(data.length > 0){ 
                     var editable = true;
                     if(id_diag > 0){
                        editable = false;
                     }
                     for(var i = 0;i <18;i++){
                        var id_part = data[i].id_part;
                        var descrip = data[i].descrip;
                        var tipo_dato = data[i].tipo_dato;
                        var opciones = data[i].opciones;
                        var valor = data[i].valor;
                        var elem = dibujarElemento(id_part,descrip,tipo_dato,opciones,valor,editable); 

                        var j = eval(i + 18);  
                        var id_part2 = data[j].id_part;
                        var descrip2 = data[j].descrip;
                        var tipo_dato2 = data[j].tipo_dato;
                        var opciones2 = data[j].opciones;
                        var valor2 = data[j].valor;
                        
                        var elem2 = dibujarElemento(id_part2,descrip2,tipo_dato2,opciones2,valor2,editable); 
                        $("#tabla_recepcion").append("<tr><td style='height:32px'><label class='rec_label_izq' for='part_"+id_part+"'>"+descrip+"</label></td><td>"+elem+"</td><td><label class='rec_label_der' for='part_"+id_part2+"'> "+descrip2+"</label></td><td>"+elem2+"</td></tr>"); 
                     }

                     $("#datos_recepcion").slideDown();
                     $("#msg_recepcion").html("");
                     datos_recepcion = true;
                     $("#mas_datos").text("Contraer");
                 }else{
                     $("#msg_recepcion").html("");                
                 }    

             },
             error: function (err) { 
                $("#msg_recepcion").addClass("error");
                $("#msg_recepcion").html(err);
             }
         });     
    }else{
        if($("#mas_datos").text() == "Contraer"){
            $("#mas_datos").text("Mas datos");
            $("#datos_recepcion").slideUp();
        }else{
            $("#datos_recepcion").slideDown();
            $("#mas_datos").text("Contraer");
        } 
    }
}
function dibujarElemento(id_part,descrip,tipo_dato,opciones,valor,editable){
    var elem;
    if(tipo_dato == "select"){ 
        var ops = opciones.split(",");        
        editable? chk = "checked" :chk = "disabled";  
        
        elem = '<select class="part" '+chk+' id="part_'+id_part+'">'; 
        ops.forEach(function(e){
           var sel = valor==e?"selected":"";           
           elem+="<option value='"+e+"' "+sel+" >"+e+"</option>";
        });
        elem += '</select>'
    }else if(tipo_dato == "boolean"){
        enab = "";
        var chk = valor=="Si"?"checked":"";
        //Si es la primera vez todo tildado por defecto
        
        if(editable){
            chk = "checked";            
        }else{
            enab = "disabled";
        } 
        elem = '<input class="part"  id="part_'+id_part+'" '+chk+' '+enab+'  type="checkbox" >';
    }else{
        editable? chk = "checked" :chk = "readonly";
        elem = '<input class="part"  id="part_'+id_part+'" type="text" size="10" >';
    }  
    return elem;
}


function centerForm(){
   var w = $(document).width();
   var h = $(document).height();
   $(".form").width(w);
   $(".form").height(h);   
   $(".form").fadeIn();
   openForm = true; 
   if(is_mobile){
       $(".form_table").width("98%");
   }
}

function addRecepData(form){
   var data = {}; 
   
   if($(".part").length == 0){       
       alert("Atencion! Corroborre como recibe el vehiculo!");
       datosRecepcion(-1);
       return;
   }
   
   var datos_recep = {};
   $(".part").each(function(){
        var id = $(this).attr("id").substring(5,30);
        var tipo = $(this).prop("type");

        var valor = $(this).val();
        if(tipo == "checkbox"){
           valor =  $(this).is(":checked")?'Si':'No';
        }
        datos_recep[id]=valor;
        //console.log(id+" "+tipo+"   "+valor);
   });
   
   var table = form.substring(4,60);      
   $("#"+form+" [id^='form_']").each(function(){
     
     var pk = $(this).hasClass("PRI");
     var column_name = $(this).attr("id").substring(5,60);
     var val = $(this).val(); 
     var req = $(this).attr("required");
     
        console.log( column_name);
     
     if(column_name === "cod_cli"){
         val = $(this).attr("data-cod_cli");
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
          data:data,
          datos_recep:datos_recep
    };
    $.ajax({
          type: "POST",
          url: "recepcion/Recepcion.class.php",
          data: {action: "addData" , master: master,  usuario: getNick()},        
          async: true,
          dataType: "json",
          beforeSend: function () {
              $("#msg_recepcion").addClass("error");
              $("#"+form+" input[id="+table+"_save_button]").prop("disabled",true);
              $("#msg_recepcion").html("Insertando... <img src='img/loading_fast.gif'  >");
          },
          success: function (data) {   

              if(data.mensaje === "Ok"){ 
                  $("#form_id_diag").val(data.id_diag);
                  $("#msg_recepcion").html(data.mensaje);
                  $("#"+form+" input[id="+table+"_close_button]").fadeIn();  
                  $(".diag_print").fadeIn();
              }else{
                  $("#"+form+" input[id="+table+"_save_button]").prop("disabled",false);
                  $("#msg_recepcion").html(data.mensaje+" Rellene los campos requeridos y vuelva a intentarlo si el problema persiste contacte con el Administrador del sistema.");
              }   
              
          },
          error: function (err) { 
            $("#msg_recepcion").addClass("error");
            $("#"+form+" input[id="+table+"_save_button]").prop("disabled",false);
            $("#msg_recepcion").html('Error al Registrar: Rellene los campos requeridos y vuelva a intentarlo.<a href="javascript:showTechnicalError()">Mas info</a>\n\
            <div class="technical_info">'+err.responseText+'</div>');         
          }
      });  
     }else{
      $("#msg_recepcion").addClass("error");  
      $("#msg_recepcion").html("Rellene los campos requeridos...");
    }
}
function showTechnicalError(){
    $(".technical_info").fadeToggle();
}

function updateRecepData(form){
  var update_data = {};
  var primary_keys = {};  
  var table = form.substring(5,60);   
  $("#"+form+" [id^='form_']").each(function(){
       
     var pk = $(this).hasClass("PRI");
     var column_name = $(this).attr("id").substring(5,60);
     var val = $.trim($(this).val());
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
              url: "recepcion/Recepcion.class.php",
              data: {action: "updateData" , master: master,  usuario: getNick()},        
              async: true,
              dataType: "json",
              beforeSend: function () {
                  $("#"+form+" input[id="+table+"_update_button]").prop("disabled",true);
                  $("#msg_recepcion").html("Actualizando... <img src='img/loading_fast.gif'  >");
              },
              success: function (data) {                
                  if(data.mensaje === "Ok" || data.mensaje === "Si Modificaciones" ){ 
                      $("#msg_recepcion").html(data.mensaje);
                      $("#"+form+" input[id="+table+"_close_button]").fadeIn();
                  }else{
                      $("#"+form+" input[id="+table+"_update_button]").prop("disabled",false);
                      $("#msg_recepcion").html(data.mensaje+' intente nuevamente si el problema persiste contacte con el Administrador del sistema.<a href="javascript:showTechnicalError()">Mas info</a><div class="technical_info">'+data.query+'</div>');
                  }           
              },
              error: function (err) { 
                $("#msg_recepcion").addClass("error");
                $("#msg_recepcion").html('Error al Registrar: Verifique los datos y vuelva a intentarlo.<a href="javascript:showTechnicalError()">Mas info</a>\n\
                <div class="technical_info">'+err.responseText+'</div>');         
              }
        }); 
  }else{
    $("#msg_recepcion").addClass("error");  
    $("#msg_recepcion").html("Rellene los campos requeridos...");
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
                document.getElementById('form_url_img_'+id).value = dataurl;
                addPhotoButton();
            };
            reader.readAsDataURL(file);

        }

    } else {
        alert('Esta Api no es soportada por este navegador');
    }
}

function imprimirRecepcion(){
    var id_diag = $("#form_id_diag").val();
    var usuario = getNick();       
    var url = "recepcion/RecepPrint.class.php?id_diag="+id_diag+"&usuario="+usuario;
    var title = "Recepcion de Vehiculo";
    var params = "width=760,height=800,scrollbars=yes,menubar=yes,alwaysRaised = yes,modal=yes,location=no";
     
    if(!printing){        
        printing = window.open(url,title,params);
    }else{
        printing.close();
        printing = window.open(url,title,params);
    }         
}

function crearPresupuesto(){
    var cod_cli = $("#form_cod_cli").val();
    var nro_diag = $("#form_id_diag").val();
    genericLoad("ventas/NuevaVenta.class.php?cod_cli="+cod_cli+"&estado=Presupuesto&nro_diag="+nro_diag);
}
function crearDiagnostico(){  
    var nro_recep = $("#form_id_diag").val(); // Este en realidad es el Numero de Recepcion
    var chapa = $(".nro_chapa").text();
    //genericLoad("diagnosticos/Diagnosticos.class.php?cod_cli="+cod_cli+"&estado=Presupuesto&nro_recep="+nro_recep);
    addDiagUI(nro_recep,chapa);
}