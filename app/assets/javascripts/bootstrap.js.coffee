jQuery ->
  # $("a[rel=popover]").popover()
  # $(".tooltip").tooltip()
  # $("a[rel=tooltip]").tooltip()
  $('#observation_areas_as_text').tokenInput('/areas', {
    theme: 'facebook',
    preventDuplicates: true
  })
  $('.draggable').draggable()
  $('.droppable').droppable(
  )
