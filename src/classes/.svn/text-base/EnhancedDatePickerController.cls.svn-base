public with sharing class EnhancedDatePickerController extends EnhancedComponentController{
	
	public String minDate { get; set; }
	public String maxDate { get; set; }
	
	
	public override void onLoad() {
		
		try {      
	  		System.debug('onLoad ' + fieldName);
		  	myObject = pageController.myObject;
		  	if(myObject != null && myObject.get(fieldName) != null) {
		  		Date d = (Date) myObject.get(fieldName);
        		Datetime dt = Datetime.newInstance(d.year(),d.month(),d.day());
        		System.debug('DATETIME:' + d.year() + ' - ' + d.month() + ' - ' + d.day() );
		  		myValueHolder = dt.format('M/d/yyyy');
		  	}
			String s = (String) myValueHolder;
			System.debug('onLoad Value: ' + s);
	  	}
	  	catch(SObjectException soe)  
	  	{
	  		System.debug(soe);
	  	}    
		uid='EC' + order + fieldName;

		
	}

	
	// because there is no true onload allowed for components
	// and the constructor is run before the setters on attributes
	public String getOnLoad(){
		
		onLoad();
		                                                             
        //detect users locale so that the right date format can be used
        String locale = UserInfo.getLocale();
        String datefrmt;
       
        if (locale == 'en_US') {
            datefrmt = '\'MM dd, yy\'';
        }
        else {
            datefrmt = '\'dd MM yy\'';  
        }

        String initialize = '$(".' + uid + '").datepicker({ changeYear: true, ' +
                                                                    'changeMonth: true, ' +
                                                                    'dateFormat: ' + datefrmt +' });\n';  
		//System.debug('MAX' + maxDate + 'MIN' + minDate);

		if(maxDate != null && maxDate != '') 
		{
		  if(maxDate == 'TODAY')
				initialize += ', "maxDate": +0 ';
		  else
		  {
			  String[] stringDate = maxDate.split('/');
		  	  if(stringDate.size() == 3)
		  	  {
			      String m = stringDate[0];
			      if(m.length() == 1)
			      	m = '0' + m;
			      String d =  stringDate[1];
			      if(d.length() == 1)
			      	d = '0' + d;
			      String y = stringDate[2];
					initialize += ', "maxDate": "' + m + '/' + d + '/' + y + '"';
	
		  	  }
		  }
		}
			
		if(minDate != null && minDate != '') 
		{
			
			if(minDate == 'TODAY')
				initialize += ', "minDate": +0 ';
		  else
		  {
			
			  String[] stringDate = minDate.split('/');
		  	  if(stringDate.size() == 3)
		  	  {
			      String m = stringDate[0];
			      if(m.length() == 1)
			      	m = '0' + m;
			      String d =  stringDate[1];
			      if(d.length() == 1)
			      	d = '0' + d;
			      String y = stringDate[2];
					initialize += ', "minDate": "' + m + '/' + d + '/' + y + '"';
		  	  }
		  }
			
		}
																		
			//initialize += ' });\n';
																			
		addOnLoadJavascriptToParentController(initialize);
		return '';
	}
	
	// supports two formats, 'yyyy-MM-dd' and 'mm/dd/yyyy'
	
	public override Object getCastedValue() {     

  	  String s = (String) myValueHolder;
  	  
  	  if(s != null)
  	  {
		  String[] stringDate = s.split('/');
	  	  if(stringDate.size() == 3)
	  	  {
		      Integer m = Integer.valueOf(stringDate[0]);
		      Integer d =  Integer.valueOf(stringDate[1]);
		      Integer y = Integer.valueOf(stringDate[2]);
			  return date.newInstance(y,m,d);
	  	  }
	  	  else
	  	  {
	  	  	stringDate = s.split('-');
	  	  	if(stringDate.size() == 3)
	  	  	{
	  	  	  Integer m = Integer.valueOf(stringDate[1]);
		      Integer d =  Integer.valueOf(stringDate[2].split(' ')[0]);
		      Integer y = Integer.valueOf(stringDate[0]);
			  return date.newInstance(y,m,d);
	  	  	}
	  	  }
  	  
  	  }  
  	  
	   return null;

	}
	  
	

}