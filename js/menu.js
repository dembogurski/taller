/**
 * 
 * Seteo de Variables
 * @type String|@exp;sub
 */

var ant = "";
var count = -1;
var sub = "";
var first_menu = "";
var nav = Array();
var set_width = 0;
var current_group = "";
var open_manual;

$(function() {
    cargarMenu(json);
});
/**
 * 
 * @param {object json} menu
 * @param {boolen} back
 */
function cargarMenu(menu, back) {
    back = false || back;
    if (!back) {
        nav.push(menu);
        count++;
    }
    ant = sub;
    sub = menu;
    var i = 0;
    $("#menu").fadeOut("fast", function() {
        $("#menu").empty();
        $.each(menu, function(key, value) {
            if (typeof value === "object") {
                var local_id = (value.id).toString().replace(/\./g, '_');
                if (i == 0) { first_menu = "menu_" + local_id; }
                var width = parseInt(value.width);
                //console.log("Menu "+key+"   "+width);
                if (!isNaN(width)) {
                    set_width = width;
                }
                var icon = "img/menu/generic_folder.png";
                if(value.icon !== undefined){
                    icon = value.icon;
                }
                console.log( key +"   "+ value.icon);
                if (typeof value.url === "undefined") {
                    //$("#menu").append("<div id='menu_" + local_id + "' class='menu'  data-info='" + value.help + "' title='" + value.help + "' onclick='cargarMenu(sub[" + '"' + key + '"' + "])'>" + key + "</div>");
                    createMenu(local_id,value.help,"cargarMenu(sub[" + '"' + key + '"' + "])",icon,key);
                } else {
                    //$("#menu").append("<div id='menu_" + local_id + "' class='menu'  data-info='" + value.help + "' title='" + value.help + "' onclick='" + value.function+"(" + '"' + value.url + '"' + ")' >" + key + "</div>");
                    createMenu(local_id,value.help,"" + value.function+"(" + '"' + value.url + '"' + ")",icon,key);
                }
                i++;
            }
        });

        if (nav.length > 1) {
            $("#menu").append("<div><button id='menu_volver' class='menu' data-info=' Volver ' title='Volver al menu anterior' onclick='back()'>Atras</button></div>");
        }
        
    });
    $("#menu").fadeIn(50);
    setTimeout("statusInfo()", 1000);
    setTimeout("activeArrows()", 1000);
}
function createMenu(local_id,help,click,icon,key){
   $("#menu").append("<div id='menu_" + local_id + "' class='menu'  data-info='" + help + "' title='" + help + "' onclick='"+click+"'>\n\
   <img src='"+icon+"' class='menu_icon' >\n\
   <div class='icon_label'>" + key + "</div></div>"); 
}

function activeArrows() {
    $("#" + first_menu).focus();
    $(".menu").keydown(function(e) {
        console.log(e.keyCode);
        if (e.keyCode >= 37 && e.keyCode <= 38) {
            $(this).prev(".menu").focus();
        }
        if (e.keyCode >= 39 && e.keyCode <= 40) {
            $(this).next(".menu").focus();
        }
    });
    $(".menu").hover(function() {
        $(this).focus();
    });
}

function back() {
    if (count > 0) {
        var bPos = nav[count - 1];
        count--;
        nav.pop();
        cargarMenu(bPos, true);
        return true;
    } else {
        return false;
    }
}

function hideMenu() {
    $("#menu").fadeOut(function() {
        $("#work_area").css("z-index", "0");
        $("#back_arrow").fadeIn("slow");
    });
}

function showMenu() {
    $("#work_area").css("z-index", "-1").empty();
    $("#back_arrow").fadeOut("fast"); // Ocultar el boton atras
    $("#menu").fadeIn("slow");
    $(document).off('keydown'); // Limpiar la cola  
    activeArrows();
}