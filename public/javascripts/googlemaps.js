var googlemapshow=false;
var map;
var geocoder;
function load() {
  if (GBrowserIsCompatible()) {
    var geocoder = new GClientGeocoder();
    var map = new GMap2(document.getElementById("googlemap"));
    //map.addControl(new GSmallMapControl());
    map.addControl(new GMapTypeControl());
    //map.addControl(new GScaleControl());
    map.addControl(new GLargeMapControl());
    map.setCenter(new GLatLng(50.5, 10.5), 5);
	//map.setCenter(new GLatLng(47.38359, 8.542686), 15);
    map.clearOverlays();
    var address="Sumatrastrasse 25, Zuerich";
    var response=geocoder.getLatLng(
      address,
      function(point) {
        if (point) {
	      map.setCenter(point, 15);
		  var marker = new GMarker(point);
		  map.addOverlay(marker);
		  marker.openInfoWindowHtml("<b>zimtkorn ag</b><br/>Sumatrastrasse 25<br/>8006 Z�rich<br/><br/>");
          GEvent.addListener(marker, "click", function() {
            marker.openInfoWindowHtml("<a href='http://www.zimtkorn.ch' style='background-color:transparent;'><img src='fileadmin/templates/template_pics/logo2.gif' alt='Zimtkorn Logo'/></a><br/><b>zimtkorn ag</b><br/>Sumatrastrasse 25<br/>8006 Z�rich<br/><br/>");
          });
        }
      }
    );
  }
}

function goToUni() {
  if (GBrowserIsCompatible()) {
    var geocoder = new GClientGeocoder();
    var map = new GMap2(document.getElementById("googlemap"));
    var address="Sumatrastrasse 25, Zuerich";
    var response=geocoder.getLatLng(
      address,
      function(point) {
        if (point) {
	      map.setCenter(point, 15);
		  var marker = new GMarker(point);
		  map.addOverlay(marker);
		  marker.openInfoWindowHtml("<b>zimtkorn ag</b><br/>Sumatrastrasse 25<br/>8006 Z�rich<br/><br/>");
          GEvent.addListener(marker, "click", function() {
            marker.openInfoWindowHtml("<a href='http://www.zimtkorn.ch' style='background-color:transparent;'><img src='fileadmin/templates/template_pics/logo2.gif' alt='Zimtkorn Logo'/></a><br/><b>zimtkorn ag</b><br/>Sumatrastrasse 25<br/>8006 Z�rich<br/><br/>");
          });
        }
      }
    );
  }
}

function myonload_function() {
/*  try {
    //if site requiers googlemaps
    if(googlemapshow) {
      load();
    }
  }
  catch (ex) {
  	
  }
*/
}

function myunload_function() {
  try {
    GUnload();
  }
  catch (ex) {

  }
}
