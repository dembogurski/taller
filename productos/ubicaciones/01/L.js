var canvas; 
var colorFondo = '#95a5a6';
//var objetos =[];
 
$(function(){
    canvas = new fabric.Canvas('plano');
    EstanteBandejas3D( "L",5,6,50,120,50,120,canvas,"left",colorFondo );
});

