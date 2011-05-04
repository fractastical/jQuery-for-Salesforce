public with sharing class PicklistVal {
    	
    	public SelectOption so 		{ get; set; }
    	public Boolean selected 	{ get; set; }
    	public String outputHTML 	{ get; set; }

	
    	public PicklistVal(SelectOption so, String[] currVals)
    	{
    		//System.debug(so.getValue() + ' |@| ');
    		System.debug(currVals.size() + ' SIZE ');
    		
    		selected = false;
    		this.so = so;
    		for(String val : currVals)
    		{
    			System.debug(so.getValue() + ' |@| ' + val);
    			if(so.getValue() == val) 
    			{
    				selected = true;
    				break;  
    			}
    		}
    		outputHTML = '<option ';
    		if (selected)
    			outputHTML += 'selected="selected" '; 
    		outputHTML += 'value="' + so.getValue() + '">';
    		outputHTML += so.getLabel() + ' </option>\n';
    		
    	} 
    	


}