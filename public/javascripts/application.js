// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

/**
* Changes the checked value of checkboxes
* checked_action can be "all", "none" or "toggle"
**/
function change_checkboxes_by_class(class_name, checked_action) {
	$$('input.' + class_name + '[type="checkbox"]').each(function(item) {
		switch(checked_action) {
			case "all":
				item.checked = true;
				break;
			case "none":
				item.checked = false;
			break;
			case "toggle":
				item.checked = !item.checked;
			break;
		}
	});
}

function set_internal_dialog_position() {

  x = (document.all)?document.body.scrollLeft:window.pageXOffset;
  y = (document.all)?document.body.scrollTop:window.pageYOffset;

  /*var m = get_mouse_pos(event);*/
  $('internal_dialog').style.top = (y + 250) +'px';
  $('internal_dialog').style.left = (x + 250) + 'px';
}
/*
function get_mouse_pos(evt) {
    if(!evt) evt = window.event;
    var pos = {left: evt.clientX, top: evt.clientY};
    var body = (window.document.compatMode && window.document.compatMode == "CSS1Compat") ?
    window.document.documentElement : window.document.body || null;
    if (body) {
        pos.left += body.scrollLeft;
        pos.top += body.scrollTop;
    }
    return pos;
}
*/