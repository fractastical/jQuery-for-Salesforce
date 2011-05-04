public with sharing class EnhancedTextareaController extends EnhancedComponentController {

	public String width {get; set;}
	public String expandable {get; set;}
	public String height {get; set;}
	
	public String getOnLoad(){
				
		onLoad();
		
						  					
		if (expandable == null || expandable == '')
			expandable = 'FALSE';				  						
		if (expandable.toUpperCase() == 'TRUE') {
			
			String initialize = '$(".TA' + fieldName + '").expandable();\n';
			addOnLoadJavascriptToParentController(initialize);
		}
		if (width != null && width != '') 
		{
			String initialize = '$(".TA' + fieldName + '").width(' + width + ');\n';
			addOnLoadJavascriptToParentController(initialize);
		}
		if (height != null && height != '')
		{
			String initialize = '$(".TA' + fieldName + '").height(' + height + ');\n';
			addOnLoadJavascriptToParentController(initialize);
		}
		  
		
		return '';
		
	}  
	
	public override Object getCastedValue() {
  	
  	String s = (String) myValueHolder;
  	if(s == '')
  		return null;
  	else
	 	return myValueHolder;
  }
	
	

}