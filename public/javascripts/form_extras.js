function show_remaining_characters(formFieldId , maxlength) {
  var span_id = formFieldId+"_max_length"
  var form_field = jQuery("#"+formFieldId);
  var actual_length = maxlength - form_field.val().length;

  form_field.parent().append("<br /><span id='"+span_id+"'>Remaining Characters: " + actual_length+"</span>");
  jQuery("#"+span_id).css("margin-left", "10px");

  form_field.attr("maxlength", maxlength);
  form_field.keypress(function(){
      var text_length = jQuery(this).val().length;
    jQuery("#"+span_id).html("Remaining Characters: "+(maxlength-text_length));
  });
}