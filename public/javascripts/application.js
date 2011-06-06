
$(document).ready(function() {
    // Put cursor on first text input of form
  $('.autofocus:first').focus();
  $('input.ui-date-picker').datepicker();
  $('#observation_areas_as_text').tokenInput('/areas', {theme:'facebook', preventDuplicates:true} );

  $('li[draggable=true]').bind('dragstart', function() {
    this.style.opacity = '0.4';  // this / e.target is the source node.
  });
  $('li[draggable=true]').bind('dragend', function() {
    this.style.opacity = '1';
  });
  $('li[draggable=true]').bind('dragenter', function() {
    $(this).css('border','1px black solid');
   });
  $('li[draggable=true]').bind('dragleave', function() {
    $(this).css('border','none');
   });

  $('li[draggable=true]').bind('dragover', function(event) {
    event.stopPropagation();
    event.preventDefault();
    return false;
  });

  $('li[draggable=true]').bind('drop', function(event) {
    console.log(this);
    event.stopPropagation();
    event.preventDefault();
    return false;
  });

//    // All links with data_popup make a small popup window of what they link to.
//    $('.data_popup').live('click', function(e) {
//        e.preventDefault();
//        window.open($(this).attr('href'), 'popwindow', 'height=400,width=600,scrollbars=true');
//    });
//
//    // Closes the current window.
//    $('.closer').click(function(e) {
//        window.close();
//    });
//
//    // Lets user know that it was updated.
//    $('.remote_updater').click(function(e) {
//        alert('Updated!');
//    });
//
//    // This specifically refreshes the hazards part of edit materials page, but could be extended.
//    $('#refresh_hazards').click(function(e) {
//        e.preventDefault();
//        $('#hazards').load('edit.html div#hazards');
//    });
//
//
//    $('.toggler').live('click', function(e) {
//        e.preventDefault();
//        $(this).next('div').toggle();
//    });

});

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
