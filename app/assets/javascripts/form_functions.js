function remove_fields(link) {
  jQuery(link).prev("input[type=hidden]").val("1");
  jQuery(link).parent().parent(".inputs").first().hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  var replaced = jQuery(link).prev().append(content.replace(regexp, new_id));
  $(replaced).find(':input').first().focus();
}
