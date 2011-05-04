public with sharing class FormDemoController extends PageControllerBase {
	 
	  public ApexPages.StandardController standardCon 	{ get; set; }
	  public String formname 							{ get; set; }

    public FormDemoController() {
    	
        init();
                       
    }
    
    public FormDemoController(ApexPages.StandardController standardCon) {
    	    
    	myObject = standardCon.getRecord();
    	init();
    	               
    }
    	
	public void init() {
		
		formname = ApexPages.CurrentPage().getParameters().get('name');
		
	}    
	   	  
	 public void save()
	 {
	  	ecSave();
	 }
	  

}