// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
/*
Event.addBehavior({
	'span.deletable' : function()  {
		var trash = $img();
		trash.src='/images/trash.gif';
		trash.alt = 'Trash';
		trash.hide();
		this.appendChild(trash);
		
		this.observe('mouseover',function() {trash.show()});
		this.observe('mouseout', function() {trash.hide()});
		this.observe('click',  function() {this.hide()});
	}
});
*/

$(document).ready(function() {
    // Put cursor on first text input of form
    $('#focus_here').focus();

    // All links with data_popup make a small popup window of what they link to.
    $('.data_popup').live('click', function(e) {
        e.preventDefault();
        window.open($(this).attr('href'), 'popwindow', 'height=400,width=600,scrollbars=true');
    });

    // Closes the current window.
    $('.closer').click(function(e) {
        window.close();
    });

    // Lets user know that it was updated.
    $('.remote_updater').click(function(e) {
        alert('Updated!');
    });

    // This specifically refreshes the hazards part of edit materials page, but could be extended.
    $('#refresh_hazards').click(function(e) {
        e.preventDefault();
        $('#hazards').load('edit.html div#hazards');
    });

    $('.activity_submitter').live('click', function(e) {
        e.preventDefault();
        $(this).parent('form').submit();
        $('#activities').load('edit.html div#activities');
    });

    $('.toggler').live('click', function(e) {
        e.preventDefault();
        $(this).next('div').toggle();
    });

    //This sends a delete request and refreshes the activity div
    $('.deleter').live('click', function(e) {
        e.preventDefault();
        path = $(this).attr('href');
        $.ajax({
            type: 'DELETE',
            url: path,
            success: function(data) {
                $('#activities').load('edit.html div#activities');
            }
        });
    });

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

var Observation  = {
	addActivity: function() {
		index =  Observation.getNewIndex('arrayActivityIndexes');
		new Ajax.Request('/observations/add_activity?index=' + index, {asynchronous:true, evalScripts:true,
			onFailure:function(request){ Activity.removeNewIndex('arrayActivityIndexes', index); }});
		return false;
	},
	
	addSetup: function(activity_index)  {
		
	},
	
	addMaterial: function(activity_index, setup_index)  {
		index =  Observation.getNewIndex('arrayActivityIndexes');
		new Ajax.Request('/observations/add_activity?index=' + index, {asynchronous:true, evalScripts:true,
			onFailure:function(request){ Activity.removeNewIndex('arrayActivityIndexes', index); }});
		return false;		
	},
	
	// index this from 0
	// pass in indexes name as a string since we can't pass by reference
	getNewIndex: function(indexes_name) {
		indexes = eval(indexes_name);
		if (indexes.length > 0) {
			new_index = indexes[indexes.length - 1] + 1;
			} else {
				new_index = 0;
			}
			indexes.push(new_index);
			return new_index;
	},
	
	getNewIndex: function(indexes_name, array_index) {
		indexes = eval(indexes_name)
		index = indexes[array_index]
		
	},
	
	// pass in indexes name as a string since we can't pass by reference
	removeNewIndex: function(indexes_name, index) {
		indexes = eval(indexes_name);
		if (indexes.include(index)) indexes.splice(indexes.indexOf(index), 1)[0];
	}
}

var Activity = {
	
	
	addActivity: function() {
		index =  Activity.getNewIndex('arrayActivityIndexes');
		new Ajax.Request('/activity/new?index=' + index, {asynchronous:true, evalScripts:true,
			onFailure:function(request){ Activity.removeNewIndex('arrayActivityIndexes', index); }});
		return false;
	},
	
	addSetup: function(activity_index) {
		index =  Activity.getNewIndex('arraySetupIndexes');
		new Ajax.Request('/setups/new?index=' + index +'&activity='+activity_index, {asynchronous:true, evalScripts:true,
			onFailure:function(request){ Activity.removeNewIndex('arraySetupIndexes', index); }});
		return false;
	},
	
	
	// index this from 0
	// pass in indexes name as a string since we can't pass by reference
	getNewIndex: function(indexes_name) {
		indexes = eval(indexes_name);
		if (indexes.length > 0) {
			new_index = indexes[indexes.length - 1] + 1;
			} else {
				new_index = 0;
			}
			indexes.push(new_index);
			return new_index;
	},

	// pass in indexes name as a string since we can't pass by reference
	removeNewIndex: function(indexes_name, index) {
		indexes = eval(indexes_name);
		if (indexes.include(index)) indexes.splice(indexes.indexOf(index), 1)[0];
	}
}	

// JavaScript functions to ensure numeric entries only in field (Bible page 357)
// <input id=<%= "#{record_id}_rate" %> type="text" name=<%= "#{record_name}[rate]" %>
//	  size=5 maxLength=5  onKeyPress="return checkNum(event)">

  function checkNum(evt) 
  {
    var charCode = (evt.which) ? evt.which : evt.keyCode
    if (charCode > 31 && (charCode < 48 || charCode > 57) && charCode != 46)
    {
      // alert("Please enter numbers only");
      return false;
    }
    return true;
  }

  function checkInt(evt) 
  {
    var charCode = (evt.which) ? evt.which : evt.keyCode
    if (charCode > 31 && (charCode < 48 || charCode > 57) )
    {
      // alert("Please enter numbers only");
      return false;
    }
    return true
  }
 

	function checkNullInputs() {
		//	Iterates input objects in a form 
		//	Radios get special treatment because several form elements share a name.  
		var vElements = document.forms[0].elements;
		
		var vElement;
		var vLastElement;
		result = true;
		// for (var k = 0; k < vElements.length; k++) {
			for (var k = vElements.length - 1; k >= 0; k--) {
			vElement = vElements[k];
			if ((vElement.type == "select-one" || vElement.type == "text") 
						&& vElement.value <= 0
					  && $(vElement).getStyle('display') != "none"
					  && $(vElement).parentNode.getStyle('display') != "none"
					) 
			{
			  // alert(vElement.id + ": " + $(vElement).parentNode.getStyle('display'))			  
				vElement.style.background = "orange";
				vLastElement = vElement;
				result = false;
			}
			else
				vElement.style.background = "";
		}	// for (var k = 0; k < aForm.elements.length; k++)
		if (!result) 
			alert("please fill in required fields");
		if (vLastElement) 
			vLastElement.focus();
		return result;
	}	

	
	function resetColor(evt)
	{
		evt.target.style.background = 'white';
		return true;
	}
