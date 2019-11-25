jQuery(document).ready(function() {
    $('.datepicker').datepicker();
    $('#observation_areas_as_text').tokenInput('/areas.json', {
      theme: 'facebook'
    }, {
      prePopulate: $('#observation_areas_as_text').data('pre')
    });
  });

