
$(document).ready(function() {
    // Put cursor on first text input of form
    $('.autofocus:first').focus();
    $('input.ui-date-picker').datepicker();
    $('#observation_areas_as_text').tokenInput('/areas', {theme:'facebook'} );


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

function showResults(data) {
    var resultHtml = data;
    //$.each(data, function(i,item){
    //    resultHtml+='<div class="result">';
    //    resultHtml+='<h2><a href="#">'+item.title+'</a></h2>';
    //    resultHtml+='<p>'+item.post.replace(highlight, '<span class="highlight">'+highlight+'</span>')+'</p>';
    //    resultHtml+='<a href="#" class="readMore">Read more..</a>'
    //    resultHtml+='</div>';
    //});

    $('div#results').html(data);
}
