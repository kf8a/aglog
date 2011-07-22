$(document).ready ->
  # Put cursor on first text input of form
  $('.autofocus:first').focus()
  $('input.ui-date-picker').datepicker()
  $('#observation_areas_as_text').tokenInput('/areas', {theme:'facebook', preventDuplicates:true} )

  drag_selector = 'span[draggable=true]'
  drop_selector = 'div.droppable'

  sortedDrop = (event, ui) ->
    dragged = ui.draggable
    dragged_id = dragged.attr('id')
    dropTarget = $(this).parent().find(drag_selector)
    target_id = dropTarget.attr('id')

    $.post('/areas/' + dragged_id + '/move_before/' + target_id, (data) ->
      original = $(dropTarget).parent().parent().parent()
      original.empty()
      original.before(data)

      $(dragged).parent().fadeOut()
      $(dragged).parent().remove()
      $(original).prev().find(drag_selector).draggable revert: 'invalid'
      $(original).prev().find(drag_selector).droppable hoverClass: 'hovered', drop: handleDrop
      $(drop_selector).droppable hoverClass: 'hovered', drop: sortedDrop

      original.fadeOut()
      original.remove()
    )

  handleDrop = (event, ui) ->
    dragged = ui.draggable
    dragged_id = dragged.attr('id')
    dropTarget = this
    target_id = @id

    $.post('/areas/' + dragged_id + '/move_to/' + target_id, (data) ->
      original = $(dropTarget).parent()
      original.empty()
      original.before(data)

      $(dragged).parent().fadeOut()
      $(dragged).parent().remove()
      $(original).prev().find(drag_selector).draggable revert: 'invalid'
      $(original).prev().find(drag_selector).droppable hoverClass: 'hovered', drop: handleDrop
      $(drop_selector).droppable hoverClass: 'hovered', drop: sortedDrop
      original.fadeOut()
      original.remove()
    )

  $(drag_selector).draggable revert: 'invalid'
  $(drag_selector).droppable hoverClass: 'hovered', drop: handleDrop
  $(drop_selector).droppable hoverClass: 'hovered', drop: sortedDrop
