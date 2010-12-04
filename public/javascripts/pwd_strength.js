// Password strength meter v1.0
// Matthew R. Miller - 2007
// www.codeandcoffee.com
// Based off of code from  http://www.intelligent-web.co.uk

// Settings 
// -- Toggle to true or false, if you want to change what is checked in the password
var bCheckNumbers = true;
var bCheckUpperCase = true;
var bCheckLowerCase = true;
var bCheckPunctuation = true;
var nPasswordLifetime = 365;
 
// Check password
function checkPassword(strPassword,str_user_login)
{  var ctlLog = document.getElementById("user_login");
	// Reset combination count
	nCombinations = 0;
	count = 1;
	// Check numbers
	if (bCheckNumbers)
	{
		strCheck = "0123456789";
		if (doesContain(strPassword, strCheck) > 0) 
		{ 
        	nCombinations += strCheck.length; 
        	count += 0.5; 	
    		}
	}
	
	// Check upper case
	if (bCheckUpperCase)
	{
		strCheck = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		if (doesContain(strPassword, strCheck) > 0) 
		{ 
        	nCombinations += strCheck.length;
        	count += 0.5;
    		}
	}
	
	// Check lower case
	if (bCheckLowerCase)
	{
		strCheck = "abcdefghijklmnopqrstuvwxyz";
		if (doesContain(strPassword, strCheck) > 0) 
		{ 
        	nCombinations += strCheck.length;
        	count += 0.5;	
    		}
	}
	
	// Check punctuation
	if (bCheckPunctuation)
	{
		strCheck = ";:-_=+\|//?^&!.@$Ј#*()%~<>{}[]";
		if (doesContain(strPassword, strCheck) > 0) 
		{ 
        	nCombinations += strCheck.length;
        	count += 0.5;
    		}
	}
	
	// Calculate
	// -- 500 tries per second => minutes 
    	var nDays = ((Math.pow(nCombinations,2 ) / 500) / 2) / 86400;
 
	// Number of days out of password lifetime setting
	var nPerc = nDays * 100000000 / nPasswordLifetime;

	if ((count >= 2.5) && (strPassword.length > 6))
  	{
  		count = 6;
   	}
   	if ((count >= 2.5) && (strPassword.length < 6))
   	{
   		count = 2.5;
   	}
  
	var nRound = Math.round(nPerc*count);
	  // Influece strPassword.length
	if (nRound < (strPassword.length * 5)) 
	{ 
		nRound += strPassword.length; 
	}
	if ( str_user_login == strPassword)
	{
		nRound = 0;
	}
	return nRound;
} 
// Runs password through check and then updates GUI 
function getPasswordStrength(strPassword, strFieldID,str_user_login) 
{
	// Check password
	var nRound = checkPassword(strPassword,str_user_login);
	
	 // Get controls
    	var ctlBar = document.getElementById(strFieldID + "_bar"); 
    	var ctlText = document.getElementById(strFieldID + "_text");
        var ctlImg = document.getElementById("img");
       
    	if (!ctlBar || !ctlText)
    		return;
    
   
	if (nRound > 100)
		nRound = 100;
    	ctlBar.style.width = nRound + "%";
 
 	// Color and text
 	if (nRound > 95)
 	{
 		strText = "Very Secure";
 		strColor = "#3bce08";
                 ctlImg.src="/images/ill_profile_compl_active.gif";
 	}
 	else if (nRound > 70)
 	{
 		strText = "Secure";
 		strColor = "orange";
              ctlImg.src="/images/ill_profile_compl_active_copy_o.gif";
	}
 	else if (nRound > 45)
 	{
 		strText = "Mediocre";
 		strColor = "#ffd801";
                 ctlImg.src="/images/ill_profile_compl_active_copy_y.gif";
 	}
 	else
 	{
 		strColor = "red";
 		strText = "Insecure";
               ctlImg.src="/images/ill_profile_compl_active_copy_r.gif";
 	}
	//ctlBar.style.backgroundColor = strColor;
	ctlText.innerHTML = "<span style='color: " + strColor + ";'>" + strText + "</span>";
    
     
}
 
// Checks a string for a list of characters
function doesContain(strPassword, strCheck)
 {
    	nCount = 0; 
 
	for (i = 0; i < strPassword.length; i++) 
	{
		if (strCheck.indexOf(strPassword.charAt(i)) > -1) 
		{ 
	        	nCount++; 
		} 
	} 
 
	return nCount; 
} 
 
 
// Checks for empty fields 
function EmptyField(string,list,type_form)
 {

  var temp = new Array();
  temp = string.split(',');
  var message;
  var temp_list = new Array();
  temp_list = list.split(',');
  switch(type_form)
  {
	case 1:
      for(i = 0; i < temp.length; i++)
      {
      temp[i]= 'category_' + temp[i];
      }  
      message = 'Select the country for category(s): ';
	  break;    
	case 2:
	  message = 'Select the category for winery(s): ';
	  break;
	case 3:
	
	  message = 'Select the parent category for category(s): ';
	  break;
	case 4:
	  temp.shift();
	  
	  message = 'Select the city for country(s): ';
	  break;  
	default:
  }
  
  
  var x;
  var ctl1;
  var list_reg="";
  for(i = 0; i < temp.length; i++)
  {
    if ((document.getElementById(temp[i]).value==null) || (document.getElementById(temp[i]).value==""))
     list_reg = list_reg + temp_list[i];
  }
  if (list_reg!="")
    alert(message + list_reg);
  else 
  {
    switch(type_form)
    {
	case 1:
	  document.category_upload.submit();
	  break;    
	case 2:
	  document.winery_upload.submit();
	  break;
	case 3:
	  document.category_upload_correct.submit();
	  break;
	case 4:
	  document.country_upload.submit();
	  break;  
	default:
	}
    
  }	 
 }
 