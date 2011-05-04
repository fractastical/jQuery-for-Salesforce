public with sharing class SFDCFormDemoController extends PageControllerBase {
   
    public ApexPages.StandardController standardCon   { get; set; }
    public String formname               { get; set; }

    public SFDCFormDemoController() {
      
        init();
                       
    }
    
    public SFDCFormDemoController(ApexPages.StandardController standardCon) {
          
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