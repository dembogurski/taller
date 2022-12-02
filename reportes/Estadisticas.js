
var moneda = "G$"; //Hasta desarrollar el Filtro
var meses = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Setiembre","Octubre","Noviembre","Diciembre"];

var id_menu = "";
var active_menu = "ventas";


function configurar(){
    $('.fecha').datepicker().datepicker('option', 'dateFormat', 'dd-mm-yy');
    $('.fecha').change(function(){
        id_menu = "*";
        getGraficoEstadisticos();
    });
    
    $(".menu_button").click(function(){
        $(".activo").removeClass("activo");
        $(this).addClass("activo");
        var id = $(this).attr("id");
        setFechas(id);
    });  
    $(".nav_ventas").click(function(){
        $(this).addClass("nav_ventas_active");
        $(".nav_gastos").removeClass("nav_gastos_active");
        active_menu = "ventas";
        getTotalVentas();
    });
    $(".nav_gastos").click(function(){
        $(this).addClass("nav_gastos_active");
        $(".nav_ventas").removeClass("nav_ventas_active");
        active_menu = "gastos";
        getTotalGastos();
    });
    $("#btn_diario").trigger("click");
}

function setFechas(id){
    id_menu = id.substring(4,20);
    const today = new Date();
    
    switch(id) {
      case "btn_diario":
        $("#indicador").html("Hoy");
        var hoy = formatDate(today);
        $("#desde").val(hoy);
        $("#hasta").val(hoy);
        break;
      case "btn_semanal":
        var firstDay = getFirstDayOfWeek(today);  
        var lastDay = getLastDayOfWeek(firstDay) ;
        $("#indicador").html(firstDay.getDate()+" - "+lastDay.getDate());  
        $("#desde").val(formatDate(firstDay));
        $("#hasta").val(formatDate(lastDay));
        break;
      case "btn_mensual":
           var mes = new Date().getMonth();
           $("#indicador").html(meses[mes]); 
           var firstDay = new Date(today.getFullYear(), today.getMonth(), 1);
           var lastDay = new Date(today.getFullYear(), today.getMonth() + 1, 0);
           $("#desde").val(formatDate(firstDay));
           $("#hasta").val(formatDate(lastDay));
        break;
      case "btn_anual":
           var anio = new Date().getFullYear();
           $("#indicador").html(anio); 
           var firstDay = new Date(anio, 0, 1); 
           var lastDay = new Date(anio, 11, 31);
           $("#desde").val(formatDate(firstDay));
           $("#hasta").val(formatDate(lastDay));
        break;
      default:
        // code block
    } 
    
    getGraficoEstadisticos();     
    
}

function getGraficoEstadisticos(){
    if(active_menu == "ventas"){
       getTotalVentas();
    }else{
       getTotalGastos();
    }
    getDatosCuentasPorCobrar();
    getDatosClientesPorCobrar();
    getProductosMasVendidos();
    getProductosMasMargen();
}

function getTotalVentas(){
    var desde = fdesde();
    var hasta = fhasta(); 
    $.ajax({
        type: "POST",
        url: "reportes/Estadisticas.class.php",
        data: {action: "getTotalVentas", suc: getSuc(),usuario:getNick(),desde:desde,hasta:hasta,moneda:moneda},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#info_grafico").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {   
            var total = data[0].total;
            if(total == null){
                total = 0;
            }
            var total = parseFloat(total).format(0,3); 
            $("#info_grafico").html("Total Ventas<br> "+total+" Gs.");  
        }
    });  
    graficoVentas();
}
function getTotalGastos(){
    var desde = fdesde();
    var hasta = fhasta(); 
    $.ajax({
        type: "POST",
        url: "reportes/Estadisticas.class.php",
        data: {action: "getTotalGastos", suc: getSuc(),usuario:getNick(),desde:desde,hasta:hasta,moneda:moneda},
        async: true,
        dataType: "json",
        beforeSend: function () {
            $("#info_grafico").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) {   
            var total = data[0].total;
            if(total == null){
                total = 0;
            }
            var total = parseFloat(total).format(0,3); 
            $("#info_grafico").html("Total Gastos<br> "+total+" Gs.");  
        }
    }); 
   graficoGastos();
}
 

function graficoVentas(){
    var desde = fdesde();
    var hasta = fhasta(); 
    $.ajax({
        type: "POST",
        url: "reportes/Estadisticas.class.php",
        data: {action: "getDatosVentas",id_menu:id_menu, suc: getSuc(),usuario:getNick(),desde:desde,hasta:hasta},
        async: true,
        dataType: "json",
        beforeSend: function () {
            //$("#grafico_ventas_gastos").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) { 
            //$("#grafico_ventas_gastos").html("");   
            var label = new Array();
            var valores = new Array();
            for(var i in data){
                label.push( data[i].label );
                valores.push( data[i].valor );
            }
            new Chartist.Line('#grafico_ventas_gastos', {
                labels: label,
                series: [
                  valores
                ]
            }, {
                low: 0,
                showArea: true
            }); 
            
        }
    });            
}
function graficoGastos(){
    var desde = fdesde();
    var hasta = fhasta(); 
    $.ajax({
        type: "POST",
        url: "reportes/Estadisticas.class.php",
        data: {action: "getDatosGastos",id_menu:id_menu, suc: getSuc(),usuario:getNick(),desde:desde,hasta:hasta},
        async: true,
        dataType: "json",
        beforeSend: function () {
            //$("#grafico_ventas_gastos").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) { 
            //$("#grafico_ventas_gastos").html("");   
            var label = new Array();
            var valores = new Array();
            for(var i in data){
                label.push( data[i].label );
                valores.push( data[i].valor );
            }
            new Chartist.Line('#grafico_ventas_gastos', {
                labels: label,
                series: [
                  valores
                ]
            }, {
                low: 0,
                showArea: true
            }); 
            
        }
    });            
}

function getDatosCuentasPorCobrar(){
    var desde = fdesde();
    var hasta = fhasta(); 
    $.ajax({
        type: "POST",
        url: "reportes/Estadisticas.class.php",
        data: {action: "getCuentasPorCobrar", desde:desde, suc: getSuc(),usuario:getNick(),desde:desde,hasta:hasta},
        async: true,
        dataType: "json",
        beforeSend: function () {
            //$("#grafico_ventas_gastos").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) { 
            var valor_total = parseFloat(data[0].valor_total); //.format(0,3)
            var pagado = parseFloat(data[0].pagado) ;             
            var saldo = parseFloat(data[0].saldo) ; 
            
            console.log("Valor Total: "+valor_total+"  Pagado: "+pagado+"  Saldo: "+saldo );
            
            $("#info_dona_deudas_x_cobrar").html("Total cuentas: "+valor_total.format(0,3)+" Gs.<br> Total cobrado: "+pagado.format(0,3)+ "Gs.<br>Saldo a Cobrar: "+saldo.format(0,3)+ "Gs.");    
            
            var calc_porc = (pagado * 100) / valor_total  
            var saldo_dona = 100 - calc_porc;
            
            var label_calc = (calc_porc).toFixed(2);
            var label_saldo = (saldo_dona).toFixed(2);
            
            new Chartist.Pie('.cuentas_por_cobrar', {
                labels: [label_calc+"%" ,label_saldo+"%"],
                series: [calc_porc,saldo_dona]                
                }, {
                donut: true,
                donutHeight:80,
                donutWidth: 30,
                startAngle: 0,
                total: 100,
                showLabel: true
            });   
            
        }
    });             
}
function getDatosClientesPorCobrar(){
    var desde = fdesde();
    var hasta = fhasta(); 
    $.ajax({
        type: "POST",
        url: "reportes/Estadisticas.class.php",
        data: {action: "getClientesPorCobrar", desde:desde, suc: getSuc(),usuario:getNick(),desde:desde,hasta:hasta},
        async: true,
        dataType: "json",
        beforeSend: function () {
            //$("#grafico_ventas_gastos").html("<img src='img/loading_fast.gif' width='16px' height='16px' >"); 
        },
        success: function (data) { 
            var clientes_deudores = parseFloat(data.clientes_deudores); //.format(0,3)
            var clientes_cobrados = parseFloat(data.clientes_cobrados) ;     
            var clientes_x_cobrar = parseFloat(clientes_deudores - clientes_cobrados) ;
                                                  
            $("#info_dona_clientes_x_cobrar").html("Clientes con Deudas: "+clientes_deudores.format(0,3,".",",")+"<br> Clientes Cobrados: "+clientes_cobrados.format(0,3,".",",")+ "<br>Clientes por Cobrar: "+clientes_x_cobrar);    
            
            var calc_porc = (clientes_cobrados * 100) / clientes_deudores  
            var saldo_dona = 100 - calc_porc;
            
            var label_calc = (calc_porc).toFixed(0);
            var label_saldo = (saldo_dona).toFixed(0);
            
            new Chartist.Pie('.clientes_por_cobrar', {
                labels: [label_calc+"%" ,label_saldo+"%"], 
                series: [{value: calc_porc, className: 'clientes_deudores'}, {value: saldo_dona, className: 'clientes_cobrados'}]
                }, {
                donut: true,
                donutHeight:80,
                donutWidth: 30,
                startAngle: 0,
                total: 100,
                showLabel: true
            });   
               
        }
    });             
}
function getProductosMasVendidos(){
    var desde = fdesde();
    var hasta = fhasta(); 
    $.ajax({
        type: "POST",
        url: "reportes/Estadisticas.class.php",
        data: {action: "getProductosMasVendidos", desde:desde, suc: getSuc(),usuario:getNick(),desde:desde,hasta:hasta},
        async: true,
        dataType: "json",
        beforeSend: function () {
             $(".fila_producto").remove(); 
        },
        success: function (data) { 
            $(".fila_producto").remove(); 
            for(var i in data){
                var producto = data[i].producto;
                var cantidad = parseFloat(data[i].cantidad);
                var img = data[i].img;
                $("#productos_mas_vendidos").append("<div class='col-12 row fila_producto'><div class='col-8 h3 mt-5' style='text-align:left'>"+producto+"</div> <div class='col-1 h3 mt-5'>"+cantidad+"</div><div class='col-3 img_container'><img src='"+img+"' class='art_component_image'></div></div>");
            }   
        }
    });             
} 
function getProductosMasMargen(){
    var desde = fdesde();
    var hasta = fhasta(); 
    $.ajax({
        type: "POST",
        url: "reportes/Estadisticas.class.php",
        data: {action: "getProductosMasMargen", desde:desde, suc: getSuc(),usuario:getNick(),desde:desde,hasta:hasta},
        async: true,
        dataType: "json",
        beforeSend: function () {
             $(".fila_margen").remove(); 
        },
        success: function (data) { 
            $(".fila_margen").remove(); 
            for(var i in data){
                var producto = data[i].producto;
                var margen = parseFloat(data[i].margen).format(0,3,".",",");
                 
                $("#productos_mas_margen").append("<div class='col-12 row fila_margen'><div class='col-9 h3 mt-5' style='text-align:left'>"+producto+"</div> <div style='text-align:right;padding-right:4px' class='col-3 h3 mt-5'>"+margen +"</div></div>");
            }   
        }
    });             
} 



function fdesde(){
    return validDate($("#desde").val()).fecha;
}
function fhasta(){
    return validDate($("#hasta").val()).fecha;
}

function getFirstDayOfWeek(d) {
  // ?? clone date object, so we don't mutate it
  const date = new Date(d);
  const day = date.getDay(); // ?? get day of week

  // ?? day of month - day of week (-6 if Sunday), otherwise +1
  const diff = date.getDate() - day + (day === 0 ? -6 : 1);

  return new Date(date.setDate(diff));
}

function getLastDayOfWeek(firstDay){
    const lastDay = new Date(firstDay);
    lastDay.setDate(lastDay.getDate() + 6);
    return new Date(lastDay);
}

function padTo2Digits(num) {
  return num.toString().padStart(2, '0');
}
function formatDate(date) {
  return [
    padTo2Digits(date.getDate()),  
    padTo2Digits(date.getMonth() + 1),    
    date.getFullYear()
  ].join('-');
}



