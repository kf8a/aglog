$(document).ready ->
  # Put cursor on first text input of form
  $('.autofocus:first').focus
  $('input.ui-date-picker').datepicker
  $('#observation_areas_as_text').tokenInput('/areas', {theme:'facebook', preventDuplicates:true} );

  sortedDrop = (event, ui) ->
    dragged = ui.draggable;
    dragged_id = dragged.attr('id');
    dropTarget = $(this).next().find('span[draggable=true]');
    target_id = dropTarget.attr('id');

    `$.post('/areas/' + dragged_id + '/move_before/' + target_id, function(data) {
      var original = $(dropTarget).parent().parent().parent();
      original.empty();
      original.before(data);

      $(dragged).parent().fadeOut();
      $(dragged).parent().remove();
      $(original).prev().find('span[draggable=true]').draggable({revert: 'invalid'});
      $(original).prev().find('span[draggable=true]').droppable({hoverClass: 'hovered', drop: handleDrop });
      $('div.droppable').droppable({hoverClass: 'hovered', drop: sortedDrop });

      original.fadeOut();
      original.remove();
    });`



  handleDrop = (event, ui) ->
    dragged = ui.draggable;
    dragged_id = dragged.attr('id');
    dropTarget = this;
    target_id = this.id;

    `$.post('/areas/' + dragged_id + '/move_to/' + target_id, function(data) {
      var original = $(dropTarget).parent();
      original.empty();
      original.before(data);

      $(dragged).parent().fadeOut();
      $(dragged).parent().remove();
      $(original).prev().find('span[draggable=true]').draggable({revert: 'invalid'});
      $(original).prev().find('span[draggable=true]').droppable({hoverClass: 'hovered', drop: handleDrop });
      $('div.droppable').droppable({hoverClass: 'hovered', drop: sortedDrop });
      original.fadeOut();
      original.remove();
    });`



  $('span[draggable=true]').draggable revert: 'invalid'
  $('span[draggable=true]').droppable hoverClass: 'hovered', drop: handleDrop
  $('div.droppable').droppable hoverClass: 'hovered', drop: sortedDrop
