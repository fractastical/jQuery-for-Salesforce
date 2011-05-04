		/**
		 * DHTML phone number validation script. Courtesy of SmartWebby.com (http://www.smartwebby.com/dhtml/)
		 */

	// Declaring required variables
	var digits = "0123456789";
	// non-digit characters which are allowed in phone numbers
	var phoneNumberDelimiters = "()- x.";
	// characters which are allowed in international phone numbers
	// (a leading + is OK)
	var validWorldPhoneChars = phoneNumberDelimiters + "+";
	// Minimum no of digits in an international phone no.
	var minDigitsInIPhoneNumber = 10;

	function isInteger(s)
	{   var i;
	    for (i = 0; i < s.length; i++)
	    {   
	        // Check that current character is number.
	        var c = s.charAt(i);
	        if (((c < "0") || (c > "9"))) return false;
	    }
	    // All characters are numbers.
	    return true;
	}
	function trim(s)
	{   var i;
	    var returnString = "";
	    // Search through string's characters one by one.
	    // If character is not a whitespace, append to returnString.
	    for (i = 0; i < s.length; i++)
	    {   
	        // Check that current character isn't whitespace.
	        var c = s.charAt(i);
	        if (c != " ") returnString += c;
	    }
	    return returnString;
	}
	
	function stripCharsInBag(s, bag)
	{   var i;
	    var returnString = "";
	    // Search through string's characters one by one.
	    // If character is not in bag, append to returnString.
	    for (i = 0; i < s.length; i++)
	    {   
	        // Check that current character isn't whitespace.
	        var c = s.charAt(i);
	        if (bag.indexOf(c) == -1) returnString += c;
	    }
	    return returnString;
	}

	function checkInternationalPhone(strPhone){
				var bracket=3;
				strPhone=trim(strPhone);
				if(strPhone.indexOf("+")>1) 
					return false;
				if(strPhone.indexOf("-")!=-1)
					bracket=bracket+1
				if(strPhone.indexOf("(")!=-1 && strPhone.indexOf("(")>bracket)
					return false;
				var brchr=strPhone.indexOf("(")
				if(strPhone.indexOf("(")!=-1 && strPhone.charAt(brchr+2)!=")")
					return false;
				if(strPhone.indexOf("(")==-1 && strPhone.indexOf(")")!=-1)
					return false;
				s=stripCharsInBag(strPhone,validWorldPhoneChars);
				return (isInteger(s) && s.length >= minDigitsInIPhoneNumber);
	}


		      jQuery.validator.addMethod("allCapsDisallowed", function(value, element) {
					return this.optional(element) || /[a-z]/.test(value);
				}, "Please include lowercase letters");  

    			jQuery.validator.addMethod("allLowercaseDisallowed", function(value, element) {
					return this.optional(element) || /[A-Z]/.test(value);
				}, "Please include uppercase letters");  
				
    			jQuery.validator.addMethod("ASCIIOnly", function(value, element) {
					return this.optional(element) || /^[\x00-\x7F]+$/.test(value);
				}, "ASCII characters only please.");    

    			jQuery.validator.addMethod("internationalPhone", function(value, element) {
					return this.optional(element) || checkInternationalPhone(value);
				}, "Please enter a valid phone number");    
				
    			jQuery.validator.addMethod("currency", function(value, element) {
					return this.optional(element) || /^[+-]?[0-9]{1,3}(?:[0-9]*(?:[.,][0-9]{2})?|(?:,[0-9]{3})*(?:\.[0-9]{2})?|(?:\.[0-9]{3})*(?:,[0-9]{2})?)$/.test(value);
				}, "Not a recognized currency format");  
				  
    			jQuery.validator.addMethod("percentage", function(value, element) {
					return this.optional(element) || /^\s*((-){0,1}(\d{0,})(\.?(\d*)))?\s*\%?\s*$/.test(value);
				}, "Please enter a percentage");    
				jQuery.validator.addMethod("postalcode", function(postalcode, element) {
					return this.optional(element) || postalcode.match(/(^\d{5}(-\d{4})?$)|(^[ABCEGHJKLMNPRSTVXYabceghjklmnpstvxy]{1}\d{1}[A-Za-z]{1} ?\d{1}[A-Za-z]{1}\d{1})$/);
				}, "Please specify a valid postal/zip code");
				
				
				
				 

