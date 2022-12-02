



$(function(){
   $(".sino").change(function(){
       var ini = $(this).attr("id").substring(0,6);
       var fin = $(this).attr("id").substring(6,8);
       var chq = $(this).is(":checked");       
       if(fin == "si"){           
           $("#"+ini+"no").prop("checked",!chq);
       }else{
           $("#"+ini+"si").prop("checked",!chq);
       }
   });    
});

