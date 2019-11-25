(function() {
  window.remove_fields = function(link) {
    jQuery(link).prev("input[type=hidden]").val("1");
    return jQuery(link).closest(".inputs").hide();
  };

  window.add_fields = function(link, association, content) {
    var new_id, regexp, replaced;
    new_id = new Date().getTime();
    regexp = new RegExp("new_" + association, "g");
    return replaced = jQuery(link).prev().append(content.replace(regexp, new_id));
  };

  $(function() {
    $('form').on('click', '.add_fields', function(event) {
      var regexp, time;
      time = new Date().getTime();
      regexp = new RegExp($(this).data('id'), 'g');
      $(this).before($(this).data('fields').replace(regexp, time));
      return event.preventDefault();
    });
    $('form').on('click', '.remove_fields', function(event) {
      $(this).prev('input[type=hidden]').val('1');
      $(this).closest('fieldset').hide();
      return event.preventDefault();
    });
    return $('form').on('submit', "#reset_password", function(event) {
      return $(this).find('input[type="submit"]').attr('disabled', 'disabled');
    });
  });

}).call(this);
