public with sharing class EnhancedSelectController extends EnhancedComponentController{
	
	public String picklistEntries { get; set; }
	List<PicklistVal> picklistVals;
	public List<SelectOption> picklistSO { get; set; }
	String[] currVals = new List<String>();
	public Boolean isNumber { get; set; }
	
	public void setIsNumber(Boolean isNumber) {
		System.debug(LoggingLevel.WARN, 'TRYING TO SET ISNUMBER TO ' + isNumber);
		if (isNumber != null)
			this.isNumber = isNumber;		
	}

	// because there is no true onload allowed for components
	// and the constructor is run before the setters on attributes
	public String getOnLoad(){
	
		  
		onLoad();
		  
		String currVal = (String) myValueHolder;		
		if(currVal != null)
			currVals = currVal.split(';', 0);	
		  
		String updateHiddenField = 'function updateSL' + fieldName + '() { \n' + 
		'                $("#SL' + fieldName + ' option:selected")' +
										  '.each(function(k,l) {\n' +
		'                var checkedVal = $(this).val();\n' + 
		'                $("#S' + fieldName + ' :hidden:input:first").val(checkedVal + "");\n' +
		'                   } );\n' +
		'                 } \n';  

		String initialize = '$("#SL' + fieldName + '-button").remove(); \n' +   //if the element already exists remove it
		'                 $("#SL' + fieldName + '").selectmenu({\n' +
		'					width: 150\n' +
		'					})' +   
		 					 '.bind("change", function(){\n' + 
		'                     updateSL' + fieldName + '();\n' +
		'                  }\n' + 
		'                );\n';


		initPicklistVals();
		
		
		pageController.addJavascriptMethods(updateHiddenField);
		addOnLoadJavascriptToParentController(initialize);
		return '';
		
	}
	
	public void initPicklistVals() {
		
		System.debug('initPicklistVals');
        if(picklistSO == null && picklistEntries == null && myObject != null)  
        {
            System.debug('GRABBING');
            Schema.sObjectType t = myObject.getSObjectType();
            
            Schema.DescribeSObjectResult objDesc = t.getDescribe();
            Map<String, Schema.SObjectField> fieldsMap = objDesc.fields.getMap();
            System.debug('fieldsMap:' + fieldsMap.size());
            System.debug('fieldName:' + fieldName);
            List<Schema.PicklistEntry> pickListValues = fieldsMap.get(fieldName).getDescribe().getPickListValues();
            picklistSO = new List<SelectOption>();
            for(Schema.PicklistEntry pe : pickListValues)
                picklistSO.add(new SelectOption(pe.getValue(), pe.getLabel()));
        }
        else if (picklistSO == null && picklistEntries != null)
        {
                System.debug('USING PASSED');
                picklistSO = new List<SelectOption>();
                SelectOption so;
                so = new SelectOption('','--Select--');  
                picklistSO.add(so);  
                picklistEntries = picklistEntries.replace('%,','--COMMA--');
                String[] values = picklistEntries.split(',' , 0);
                for(String s:values) {
                	s = s.replaceAll('--COMMA--',',');
                	String v;
                	String[] subvalues;
                	if (s.indexOf('|')==-1)
                	{
                		v = s;
                	}
                	else
                	{
                		subvalues = s.split('\\|',0);
                		s = subvalues[0];
                		if (subvalues.size() > 1)
         				{
	         				v = subvalues[1];	
         				}
         				else
         				{
         					v = '';
         				}
                	}
                    so = new SelectOption(v,s);
                    picklistSO.add(so);  
                }
            
        } 
        else if (picklistSO == null)
            picklistSO = new List<SelectOption>();
       

            
        picklistVals = new List<PicklistVal>();
        for(SelectOption so : picklistSO)
            picklistVals.add(new PicklistVal(so, currVals));
		
		
	}
	
      public List<PicklistVal> getPickListValues() {    
	        
        return picklistVals;
          
    }
    
	public override Object getCastedValue()      
	{	
			  System.debug(Logginglevel.WARN, 'ISNUMBER:' + isNumber);
			  
			  String mvhs = (String) myValueHolder;
			  if(myValueHolder == null || mvhs.length() == 0)
			  	return null;
			  	
	          if (isNumber != null && isNumber == true)   
	          {
	          	mvhs = mvhs.replaceAll('%','');
				Double d = Double.valueOf(mvhs);  
				return d;     
	          }   
	          else 
	          	return myValueHolder;
	          
	}


	

}