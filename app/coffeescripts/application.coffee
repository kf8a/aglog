$(document).ready ->
  # Put cursor on first text input of form
  $('.autofocus:first').focus()
  $('input.ui-date-picker').datepicker()
  $('#observation_areas_as_text').tokenInput('/areas', {theme:'facebook', preventDuplicates:true} )

  $('.hider').click ->
    $(this).next().toggle('slow')
