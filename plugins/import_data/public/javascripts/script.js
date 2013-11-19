(function($){
  $(document).ready(function(){
    $("#relations_button").click(function(){
      var selects = $("form select");
      var must_have = ["name","identifier"]; 
      
      for(var i = 0; i < selects.length; i++) {
        for(var j = 0; j < must_have.length; j++) {
          if( selects[i].value == must_have[j] )
            must_have.shift(j);
        }
      }
      
      if( must_have.length > 0 ) {
        var html = "<h3>Erros</h3><ul>";
        for(var j = 0; j < must_have.length; j++)
          html += "<li> Campo obrigatorio: "+must_have[j]+"</li>"
        html += "</ul>";
        
        $("#error_mensage").html(html);
        $("#error_mensage").show();
        return false;
      } else
        return true;
    });
  });
})(jQuery);
