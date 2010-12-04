var content_shield = null;
var modal_dialog = null;

function getPageSize() {
  var xScroll, yScroll;
  if (window.innerHeight && window.scrollMaxY) {
    xScroll = document.body.scrollWidth;
    yScroll = window.innerHeight + window.scrollMaxY;
  } else if (document.body.scrollHeight > document.body.offsetHeight){ // all but Explorer Mac
    xScroll = document.body.scrollWidth;
    yScroll = document.body.scrollHeight;
  } else { // Explorer Mac...would also work in Explorer 6 Strict, Mozilla and Safari
    xScroll = document.body.offsetWidth;
    yScroll = document.body.offsetHeight;
  }
  var windowWidth, windowHeight;
  if (self.innerHeight) { // all except Explorer
    windowWidth = self.innerWidth;
    windowHeight = self.innerHeight;
  } else if (document.documentElement && document.documentElement.clientHeight) { // Explorer 6 Strict Mode
    windowWidth = document.documentElement.clientWidth;
    windowHeight = document.documentElement.clientHeight;
  } else if (document.body) { // other Explorers
    windowWidth = document.body.clientWidth;
    windowHeight = document.body.clientHeight;
  }
  // for small pages with total height less then height of the viewport
  if(yScroll < windowHeight){
    pageHeight = windowHeight;
  } else {
    pageHeight = yScroll;
  }
  // for small pages with total width less then width of the viewport
  if(xScroll < windowWidth){
    pageWidth = windowWidth;
  } else {
    pageWidth = xScroll;
  }
  arrayPageSize = new Array(pageWidth,pageHeight,windowWidth,windowHeight)
  return arrayPageSize;
}

function open_vote_dialog(uni_id, uni_name) {

  var dialog_html = "";
  dialog_html += "<form action=\"/earn/uni_vote\" method=\"post\" style=\"border-style:solid;border-color:#AD027D\">";
  dialog_html += "<table width=\"400\" style=\"border-style:none;border-width:5px\"><tr><td>";
  dialog_html += "Vielen Dank f&uuml;r deine Stimme f&uuml;r die " + uni_name + ". ";
  dialog_html += "Hinterlasse hier deine Hochschul E-Mail, damit wir dich benachrichtigen ";
  dialog_html += "können, sobald deine Uni freigeschaltet ist. <br><br>";
  dialog_html += "<input type=\"hidden\" id=\"uni_id\" name=\"uni_id\" value=\"" + uni_id + "\"/>";
  dialog_html += "<label for='mail_input'>Uni E-Mail</label><br>";
  dialog_html += "<input type='text' id='mail_input' name=\"mail_input\"/>";
  dialog_html += "</td></tr><tr><td align=\"right\">";
  dialog_html += "<input type='submit' value='Absenden' onclick='hide_modal_dialog()'/>";
  dialog_html += "<input type='button' value='Abbrechen' onclick='hide_modal_dialog()' style='margin-left:30px;'/>";
  dialog_html += "</td></tr></table>";
  dialog_html += "</form>";
  //alert(dialog_html);
  show_modal_dialog(dialog_html);
}

function body_onscroll() {
  window.status = getScrollXY();
}

function show_modal_dialog(dialog_html) {
  if (content_shield == null) {
    content_shield = document.createElement("div");
    content_shield.style.height = getPageSize()[1];
    document.body.appendChild(content_shield);
    content_shield.className = "contentFaded";
    content_shield.id = "contentFaded";
    window.status="disabled";
    //Because the div is only ever going to be the height of the displayable area of the browser (100%),
    //it needs to move with the scrollbars (width will always be 100%). We could instead explicitly set
    //div height to the complete height of the page including non-visible scrollable areas, but then
    //we would need to handle window resize events as well.
    //eg. addEvent(document.body, "onscroll", body_onscroll);
  }
  modal_dialog = document.getElementById("internal_dialog");
  modal_dialog.innerHTML = dialog_html;
  modal_dialog.style.display = "block";
}

function set_dialog_size(w, h) {
  modal_dialog = document.getElementById("internal_dialog");
  modal_dialog.style.width = w;
  modal_dialog.style.height = h;
}

function hide_modal_dialog() {
  modal_dialog.style.display = "none";
  if (content_shield != null) {
    document.body.removeChild(content_shield);
    content_shield = null;
  }
}

function addEvent(obj, evType, fn, useCapture) {
  //From http://www.scottandrew.com/weblog/articles/cbs-events
  if (obj.addEventListener){
    obj.addEventListener(evType, fn, useCapture);
    return true;
  } else if (obj.attachEvent){
    var r = obj.attachEvent("on"+evType, fn);
    return r;
  } else {
    alert("Handler could not be attached");
  }
}

function getScrollXY() {
  var scrOfX = 0, scrOfY = 0;
  if( typeof( window.pageYOffset ) == 'number' ) {
    //Netscape compliant
    scrOfY = window.pageYOffset;
    scrOfX = window.pageXOffset;
  } else if( document.body && ( document.body.scrollLeft || document.body.scrollTop ) ) {
    //DOM compliant
    scrOfY = document.body.scrollTop;
    scrOfX = document.body.scrollLeft;
  } else if( document.documentElement && ( document.documentElement.scrollLeft || document.documentElement.scrollTop ) ) {
    //IE6 standards compliant mode
    scrOfY = document.documentElement.scrollTop;
    scrOfX = document.documentElement.scrollLeft;
  }
  return [ scrOfX, scrOfY ];
}
