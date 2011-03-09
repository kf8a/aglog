
$(document).ready(function() {
    // Put cursor on first text input of form
    $('.autofocus:first').focus();

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
  jQuery(link).prev().append(content.replace(regexp, new_id));
}

