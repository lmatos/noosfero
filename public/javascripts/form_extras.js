function show_remaining_characters(formFieldId , maxlength, user_mensage) {
  user_mensage = (user_mensage == undefined) ? "Remaining Characters:" : user_mensage;
  var span_id = formFieldId+"_max_length"
  var form_field = jQuery("#"+formFieldId);
  var actual_length = maxlength - form_field.val().length;

  form_field.parent().append("<br /><span id='"+span_id+"'>"+user_mensage+" "+actual_length+"</span>");
  jQuery("#"+span_id).css("margin-left", "10px");

  function show_characters() {
    var text_length = jQuery(this).val().length;
    jQuery("#"+span_id).html(user_mensage+" "+(maxlength-text_length));
  }

  form_field.attr("maxlength", maxlength);
  form_field.keypress(show_characters);
  form_field.blur(show_characters);
}