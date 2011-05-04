public with sharing class EnhancedTextController extends EnhancedComponentController {

	public String validateAs	 { get; set; }
	public String maxLength 	 { get; set; }
	public String minLength 	 { get; set; }
	public Boolean maskedInput 	 { get; set; }
	public Boolean requiresVerification { get; set; }
	
	private List<String> frontBack;
	    
	// because there is no true onload allowed for components
	// and the constructor is run before the setters on attributes
	public String getOnLoad(){
		
		  if(downgrade == null)
		  	downgrade = false;
		  	
		  onLoad();  
		  System.debug('getOnLoad TEXT');
		  
		  String s = (String) myValueHolder;
		  System.debug('val: ' + s );
		  
		  // Necessary since Integers will otherwise be displayed in the format 'x.0'   
		  if (s != null) {
				// split only works some of the time
				// see: http://community.salesforce.com/t5/Apex-Code-Development/String-split-method-works-only-some-of-the-time/m-p/185684#M30085 
				//  frontBack = s.split('.');
				try{
					  Integer i = s.indexOf('.');
					  System.debug(i + ' index of period');
					  frontBack = new List<String>();
					  frontBack.add(s.substring(0,i));
					  frontBack.add(s.substring(i+1,s.length()));
				}
				catch(Exception e)
				{
					
				}
								
			  System.debug('FB:' + frontBack.size());
			  if(frontBack.size() > 1)
			  {
		  		System.debug(frontBack[0]);  
		  		System.debug(frontBack[1]);
		  		System.debug(frontBack[1].length());
		  			  		
			  	frontBack[1] = frontBack[1].replace('0','');
		  		System.debug(frontBack[1]);
		  		System.debug(frontBack[1].length());
			  	
			  	if(frontBack[1].length() == 0) {
			  		myValueHolder = frontBack[0];
			  		//System.debug('New MVH: ' + (String) myValueHolder);	
			  	}  
			  }
		  }
		  maskedInput = false;
		  if(validateAs != null && validateAs.toLowerCase().contains('masked'))
		  	maskedInput = true;  
		  
		  String onLoadJS = '';
		  additionalValRules = '';
		  System.debug('VALIDATE AS:' + validateAs);
		  if(validateAs != null && validateAs != '')
		  {
		  	  validateAs = validateAs.replace(' ','').toUpperCase();  
			  System.debug('VALIDATE AS:' + validateAs);
			  System.debug('MASKED:' + maskedInput);
		  	
	          if (validateAs == 'URL') 
	          {
	          	additionalValRules += 'url: true, maxlength: 255';
	          }   
	          else if (validateAs == 'NUMBER') 
	          {
	          	additionalValRules += 'number: true';
	          }   
	          else if (validateAs == 'EMAIL') 
	          {
	          	additionalValRules += 'email: true';
	          }   
	          else if (validateAs == 'PHONEUS'  || validateAs == 'USPHONE' || validateAs == 'PHONE' || validateAs == 'PHONEUSMASKED' ) 
	          {
	          	if(maskedInput)
	          		onLoadJS += '$(".' + uid + '").mask("(999) 999-9999");\n';
	          	else
					additionalValRules += 'phone: true';
	          }
	          else if (validateAs == 'CURRENCY') 
	          {
	          	additionalValRules += 'currency: true';
	          }
	          else if (validateAs == 'PERCENT' || validateAs == 'PERCENTAGE') 
	          {
	          	additionalValRules += 'percentage: true';
	          }
	          else if (validateAs == 'INTERNATIONALPHONE') 
	          {
	          	additionalValRules += 'internationalPhone: true';
	          }
	          else if (validateAs == 'NAME') 
	          {
	          	additionalValRules += 'allCapsDisallowed: true,\n' +
	          						'allLowercaseDisallowed: true,\n' +
	          						'ASCIIOnly: true\n';  
	          }
	          else if (validateAs == 'ZIP' || validateAs == 'ZIPCODE' ) 
	          {
	          	additionalValRules += 'postalcode: true';
	          }
	          else 
	          	additionalValRules += validateAs.toLowerCase() + ': true';

	          
	          
		  }  
	                                     
           if(maxLength != null && maxLength != '') {
           		if(additionalValRules != '')
           			additionalValRules += ', ';
           		additionalValRules += 'maxlength: ' + maxlength; 
           }
           
           if(minLength != null && minLength != '') {
           		if(additionalValRules != '')
           			additionalValRules += ', ';
           		additionalValRules += 'minlength: ' + minLength; 
           }
                   	
		addOnLoadJavascriptToParentController(onLoadJS);

		return '';
	}
	
	
	public override Object getCastedValue()      
	{	
			  String mvhs = (String) myValueHolder;
			  if(myValueHolder == null || mvhs.length() == 0)
			  	return null;
			  	
	 		  String myType;
			  if(validateAs != null)
			  	 myType = validateAs.toUpperCase();
	          
	          if (myType == 'NUMBER' || myType == 'PERCENT' || myType == 'PERCENTAGE')   
	          {
	          	mvhs = mvhs.replaceAll('%','');
				Double d = Double.valueOf(mvhs);  
				return d;     
	          }   
	          else if (myType == 'CURRENCY')     
	          {
	          	Decimal myDecimal = Decimal.valueOf((String) myValueHolder);
	          	return myDecimal;
	          }   
	          else
	          	return myValueHolder;
	          
	}
	
}