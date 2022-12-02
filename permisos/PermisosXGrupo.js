
var ocultos = new Array();

function configurar(){
   /* $(".mate").hover(function(){
      $(this).find("input").fadeIn();
    });
    $(".mate").mouseout(function(){
       $this = $(this); 
       setTimeout( function(){ $this.find(".oculto").fadeOut();} ,5000);
    });
    $(".oculto").click(function(){
         if($(this).is(":checked")){   
            $(this).removeClass("oculto");
         }else{
           $(this).addClass("oculto");   
         }
    }); 
     $(".mate").click(function(){   
        $(this).find(".oculto").each(function(){
           $(this).removeClass("oculto");
        });
    }); */
    $(".mate").hover(function(){
      $(this).parent().find(".permiso").addClass("foco");
    });
    $(".mate").mouseout(function(){
      $(this).parent().find(".permiso").removeClass("foco");
    });
    $(".rezizable").resizable();
    ocultos.forEach(function(i){
        $(".grupo_selector_"+i).click();
    });
    
    $(".check_permiso").click(function(){        
        var permiso = $(this).parent().attr("data-permiso");
        var grupo = $(this).parent().attr("data-grupo");
        
        var trustee = "";
   
        $(this).parent().find(".check_permiso").each(function(){
            var vem = $(this).attr("data-name"); 
            if($(this).is(":checked")){
               trustee+=vem;
            }else{
               trustee+="-";
            }
        });
        guardarPermiso(permiso,grupo,trustee);
        
    });
    $("div[class^=ch]").click(function(){
        var c = $(this).attr("class").substring(2,3); 
        $(this).parent().find("."+c).click();
    });
}

function todos(){
   $(".selected").trigger("click"); 
   $("#todos").css("background","orange");
   $("#ninguno").css("background","white");
}
function ninguno(){
    $(".unselected").trigger("click"); 
    $("#todos").css("background","white");
    $("#ninguno").css("background","orange");
}
function resaltarColumna(id_grupo){
    $(".grupo_"+id_grupo).toggleClass("marcada");
}

function guardarPermiso(permiso,grupo,trustee){
    console.log("permiso "+permiso+"  grupo:  "+grupo+"   truestee: "+trustee);
    $.ajax({
        type: "POST",
        url: "permisos/PermisosXGrupo.class.php",
        data: {action: "guardarPermiso", suc: getSuc(), usuario: getNick(),permiso:permiso,grupo:grupo,trustee:trustee},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {   
            if (data.mensaje === "Ok") {
                $("#msg").html("Ok"); 
            } else {
                $("#msg").html("Error al :  ");   
            }                
        },
        error: function (e) {           
             
            errorMsg("Error al guardar permiso  " + e, 10000);
        }
    }); 
}

function toggleGrupo(id_grupo){
    
    if($(".grupo_selector_"+id_grupo).hasClass("selected")){
        $(".grupo_selector_"+id_grupo).removeClass("selected");
        $(".grupo_selector_"+id_grupo).addClass("unselected");
    }else{
        $(".grupo_selector_"+id_grupo).removeClass("unselected");
        $(".grupo_selector_"+id_grupo).addClass("selected");
    }
    $(".grupo_"+id_grupo).fadeToggle();
}

function buscarUsuarios(){
    var usuario = $("#busuarios").val();    
    $.ajax({
        type: "POST",
        url: "reportes/ReportesUI.class.php",
        data: { "action": "getUsuarios", usuario: usuario, suc: "%" },
        async: true,
        dataType: "json",
        beforeSend: function() {
            $("#usuarios").html("");
            $("#msg").html("<img src='img/loading_fast.gif' width='16px' height='16px' >");
        },
        success: function(data) {
            if (data.length > 0) {
                $("#usuarios").append("<option value='*' data-img=''  >Ninguno</option>");    
                var primero = "*";
                var c = 0;
                for (var i in data) {
                    var usuario_ = data[i].usuario;
                    var nombre = data[i].nombre;
                    var apellido = data[i].apellido;
                    
                    var imagen = data[i].imagen;
                    $("#usuarios").append("<option value='" + usuario_ + "' data-img='" + imagen + "'  >" + usuario_ + "  -  " + nombre + " " + apellido + "</option>");
                    if(c == 0){
                       primero = usuario_; 
                    }
                    c++;
                }
                $("#usuarios").val(primero);
                getGruposUsuario();
                $("#msg").html("");
            } else {
                $("#msg").html("Sin resultados");
            }
        }
    });    
}

function getGruposUsuario(){
     
    $.ajax({
        type: "POST",
        url: "permisos/PermisosXGrupo.class.php",
        data: {action: "getGruposUsuario", suc: getSuc(), usuario: $("#usuarios").val()},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $(".star").remove();
        },
        success: function (data) {   
            if (data.length > 0) {
                for(var i in data){
                    var g = data[i].id_grupo;
                    $("th.grupo_"+g).append("<img class='star' src='img/yellow_star.png' width='16px'>");
                }
            }               
        },
        error: function (e) {                 
            
        }
    }); 
}