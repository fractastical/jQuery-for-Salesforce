public with sharing class EnhancedLookupController extends EnhancedComponentController {
	
		public String displayColumn 		{ get; set; }
		public String objectToLookup 		{ get; set; }
		public String siteUrl		 		{ get; set; }
		public String host		 		{ get; set; }
		public String extension		 		{ get; set; }

		public String displayName 			{ get; set; }
		public String filterString 			{ get; set; }
	    public transient List<JsonObject> jsonObjs { get; set; }        
		public Boolean bigset 		  		{ get; set; }
		public List<String> paramValues 	{ get; set; }
		public List<String> paramKeys 		{ get; set; }
		public Map<String,String> params 	{ get; set; }
		public String secondDisplayColumn 	{ get; set; }
		public String thirdDisplayColumn 	{ get; set; }  
		
		private transient String jsonData;  
		
		
	public enhancedLookupController()  
	{
		System.debug('before: '+filterString);
		    host = ApexPages.currentPage().getHeaders().get('Host');
		System.debug('after: '+filterString);
		
			/*testUrl = host + ApexPages.currentPage().getUrl();  
			List<String> l = new List<String>();
			l.addAll(ApexPages.currentPage().getHeaders().keySet());
			for(String s : l)
				System.debug('header:' + s);
			List<String> l2 = new List<String>();
			l2.addAll(ApexPages.currentPage().getHeaders().values());
			for(String s : l2)
				System.debug('val:' + s);  
				*/
	}

	public String getOnLoad(){

		onLoad();		
  
  
  	    if (objectToLookup == null)
	    	objectToLookup = 'Account';
  
		if(bigset == null)
			bigset = false;

		List<String> columns = new List<String>();

		List<String> displayCols = new List<String>();

		if (displayColumn == null)
			displayColumn = 'name';
		else {
			
			displayCols = displayColumn.split('[.]');
			if(displayCols.size() > 1)
			{
					displayColumn = displayCols.get(0);
					secondDisplayColumn = displayCols.get(1);
					if(displayCols.size() > 2)
						thirdDisplayColumn = displayCols.get(2);
			}
		}
			
		List<String> fieldCols = fieldName.split(',');
		if(fieldCols.size() > 1)
		{  
				displayColumn = fieldCols.get(0);
				secondDisplayColumn = fieldCols.get(1);
				if(fieldCols.size() > 2)
					thirdDisplayColumn = fieldCols.get(2);
		}
		
		
		
		String initialize;
			
		//columns.add('id');  
		columns.add(displayColumn);
		 
		if(!bigset)	
		{	
			jsonData = JsonUtils.getJsonFromObject(objectToLookup, columns, filterString);
			 initialize = 'var ' + uid + 'data = ' + jsonData + ';\n' +
					
					'$(".L' + uid + '").autocomplete(' + uid + 'data, { \n' +
					'\n' + 			
					'						 formatItem: function(item) {  \n' +
					'						   return item.' + displayColumn + ';      \n' +
					'						   }   \n' +
					'\n' +
					'						 }).result(function(event, item) {\n' +
					'								  $(".' + uid + '").val(item.id);\n' +
					'								});  \n';
		}	
		else
		{
			uid = 'LL' + uid;
			
			String host = ApexPages.currentPage().getHeaders().get('Host');
			/*List<String> l = new List<String>();
			l.addAll(ApexPages.currentPage().getHeaders().keySet());
			for(String s : l)
				System.debug('header:' + s);
			List<String> l2 = new List<String>();
			l2.addAll(ApexPages.currentPage().getHeaders().values());
			for(String s : l2)
				System.debug('val:' + s);*/
			
		    String fullUrl;
		    if (Site.getPrefix() != null)
		         fullUrl = Site.getPrefix() + Page.largeLookup.getUrl();
		    else
		    	fullUrl = Page.largeLookup.getUrl();
		
		System.debug('FILTERSTRING: ' + filterString);
 

			initialize = '' +
		//'		getLookuppageVarfor' + uid + '();' + 	   
		'		$(".L' + uid + '").autocomplete({\n' +
		'			source: function(request, response) {\n' +
		//'				$.getJSON(( getLookuppageVarfor' + uid + '() + "?otl=' + objectToLookup + '&" ), {\n' + 
		//'old (new below)				$.getJSON(("' + fullUrl + '?otl=' + objectToLookup + '" ), {\n' + 
		'				$.getJSON(("' + fullUrl+'"), {\n' + 
							// Not sure if we need this
							// see: http://www.tgerm.com/2010/02/visualforce-salesforce-jquery-ajax-how.html
		'					"core.apexpages.devmode.url":\'1\','+   
		'					"otl":\'' + objectToLookup+'\','+
		'					term: request.term\n' +
		'				}, response);\n' +
		'			},\n' +
		'			select: function(event, ui) {\n' +
		'				$(".' + uid +'").val(ui.item.id);\n' +
		'			},\n' +
		'			minLength: 2\n' +
		'		});\n ';  
		}
							
		if (myValueHolder != null)
				initialize += 	'$(".' + uid + '").val("' + (String) myValueHolder + '");\n';
		     
		addOnLoadJavascriptToParentController(initialize);
		return ''; 
		
	}
      	
  public override Object getCastedValue() {
  	
  	String s = (String) myValueHolder;
  	if(s == '')
  		return null;
  	else
	 	return myValueHolder;
  }
     
    
    /** invoked on an Ajax request */    
    public void doSearch() {
    	
	  	  params = ApexPages.currentPage().getParameters();
	      paramValues = params.values();
	      paramKeys = new List <String>();
	      paramKeys.addAll(params.keySet());
	      
	      
	      for(String s: paramKeys)  
	          System.debug('k:' + s);
	      for(String s: paramValues)
	          System.debug('v:' + s);
                
        if(params.get('otl') != null)
	        objectToLookup = params.get('otl');
	    else if (objectToLookup == null)
	    	objectToLookup = 'Account';
	    	
	    if(params.get('dc') != null)
	        displayColumn = params.get('dc');
	    else if (displayColumn == null)
	    	displayColumn = 'name';         
  
	    if(params.get('filterstring') != null)
	        filterString = params.get('filterstring');
	    else if (filterString == null)  
	    	filterString = '';
                
        List<Sobject> records;

        String term = params.get('term');

        
        if(term != null)
	        records = getRecords(term);    
          
        if (records != null && !records.isEmpty()) {  
            // Jsonify the results !
            jsonObjs = new List<JSONObject>();   
            for (Sobject o : records) {
                JSONObject cjson = new JSONObject();
                cjson.putOpt('id', new JSONObject.value((String) o.get('id')));
                if(secondDisplayColumn != null)  {

	                if(thirdDisplayColumn != null)  {

		                cjson.putOpt('label', new JSONObject.value((String) o.get(displayColumn) + '(' + ( (String) o.get(secondDisplayColumn) ) + ',' + ( (String) o.get(thirdDisplayColumn) ) + ')' ));
	                }
	                else
	                	cjson.putOpt('label', new JSONObject.value((String) o.get(displayColumn) + '(' + ( (String) o.get(secondDisplayColumn) ) + ')' ));
	                	
                }          
	            else
	            	cjson.putOpt('label', new JSONObject.value((String) o.get(displayColumn)));
	            	
                cjson.putOpt('value', new JSONObject.value((String) o.get(displayColumn)));
                jsonObjs.add(cjson);  

            }   

        }
    }
    
    // Does the SOQL query, using Ajax request data
    public List<SObject> getRecords(String filter) {
    	System.debug('WeGotIt');
        List<SObject> records = new List<SObject>();

  			String limitString;
  			if(filter.length() > 3) 
  				limitString = 'limit 20';  
  			else
  				limitString = 'limit 8';  


        if (filter != null && filter.trim().length() > 0){
  
            String completeFilter = '%' + String.escapeSingleQuotes(filter)  + '%';
            if(filterString.trim().startsWith('WHERE'))
            	filterString = 'AND' + filterString.trim().substring(5, filterString.length());
            	
            String queryString = 'select id, ' + displayColumn;
            if(secondDisplayColumn != null) {
            	queryString += ', ' + secondDisplayColumn;
            	if(thirdDisplayColumn != null)
	            	queryString += ', ' + thirdDisplayColumn;
            }
            queryString += ' from ' + objectToLookup + ' where ' + displayColumn + ' like \'' + completeFilter + '\' ';
            
            if(filterString.toLowerCase().contains('limit'))
            	queryString += filterString;
            else
            	queryString += filterString + ' ' + limitString;
            
            System.debug('QUERYSTRING: ' + queryString);
            
            records = Database.query(queryString);
            
        }     
        else {

            String queryString = 'select id, ' + displayColumn;
            if(secondDisplayColumn != null) {
            	queryString += ', ' + secondDisplayColumn;
            	if(thirdDisplayColumn != null)
	            	queryString += ', ' + thirdDisplayColumn;
            }
            queryString += ' from ' + objectToLookup + ' ';
            
            if(filterString.toLowerCase().contains('limit'))
            	queryString += filterString;
            else
            	queryString += filterString + ' ' + limitString;


            System.debug('QUERYSTRING: ' + queryString);
            records = Database.query(queryString);
        	        	
        }  
        return records;      
    }    

    // Returns the JSON result string
    public String getResult() {
	    if(jsonObjs != null)
		    return JsonUtils.jsonify(jsonObjs);
		else return '[ ]';        
    }

	

}