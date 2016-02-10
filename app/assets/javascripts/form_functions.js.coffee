window.remove_fields = (link) ->
  jQuery(link).prev("input[type=hidden]").val("1")
  jQuery(link).closest(".inputs").hide()

window.add_fields = (link, association, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp("new_" + association, "g")
  replaced = jQuery(link).prev().append(content.replace(regexp, new_id))

$ ->
  $('form').on 'click', '.add_fields', (event) ->
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')
    $(this).before($(this).data('fields').replace(regexp, time))
    event.preventDefault()

  $('form').on 'click', '.remove_fields', (event) ->
    $(this).prev('input[type=hidden]').val('1')
    $(this).closest('fieldset').hide()
    event.preventDefault()

  $('form').on 'submit', (event) -> 
    $(this).find('input[type="submit"]').attr('disabled', 'disabled')

