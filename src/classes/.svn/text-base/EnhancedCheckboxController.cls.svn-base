public with sharing class EnhancedCheckboxController extends EnhancedComponentController{
	
	public String getOnLoad(){


		//We overwrite the passed value since it means nothing for the checkbox to be required (we treat it the same way as the checkbox)
        required = false;

		onLoad();
				
		String v = (String) myValueHolder;
		System.debug('ENHANCECHECK ' + v);      
		
		if(v != null && v != '')
		{
			v = v.toUpperCase();
			if (v == 'TRUE' || v == 'CHECKED')
				myValueHolder =  true;
			else
				myValueHolder = false;
		}
										  					
		return '';
	}
	
	
	/*public override Object getCastedValue() {     

  	  try
  	  {
  	  	Boolean bvh = (Boolean) myValueHolder;
	  	return bvh;
  	  }
  	  catch(Exception e)
  	  {
  	  	System.debug('Cannot cast to Boolean:' + e);
  	  	return false;
  	  }
	  
	}*/
	  
	

}