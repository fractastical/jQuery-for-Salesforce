global with sharing virtual class EnhancedComponentController {

  public SObject myObject       { get; set; }
  public String fieldName       { get; set; }
  public Object myValueHolder   { get; set; }
  public Boolean required       { get; set; }
  public Boolean hidden         { get; set; }
  public String defaultValue    { get; set; }
  public String uid             { get; set; }
  public String additionalValRules { get; set; }
  public Integer order          { get; set; }  
  public Boolean downgrade      { get; set; }
    
  public PageControllerBase pageController { get; 
    set {
      if (value != null) {
        pageController = value;
        pageController.addComponentController(this); 
        //order = pageController.myComponentControllers.size();    
      }  
    }
  }

  public EnhancedComponentController()  {
    downgrade = false;
    
  }
 
  public virtual void onLoad() {
    
    try {
        System.debug('onLoad ' + fieldName);
        if(myObject == null && pageController != null)
            myObject = pageController.myObject;

        if(defaultValue != null && defaultValue != '')
            myValueHolder = defaultValue;

        try {
            //This can be a boolean which cannot be cast to a String
            String s = (String) myValueHolder;
            System.debug('onLoad Value: ' + s);
        }
        catch(Exception e)
        {  
        }


        if(myObject != null && myObject.get(fieldName) != null)
            myValueHolder = String.valueOf(myObject.get(fieldName));
        
        try {
            //This can be a boolean which cannot be cast to a String
            String s = (String) myValueHolder;
            System.debug('onLoad Value: ' + s);
        }
        catch(Exception e)
        {  
        }
            
        uid='EC' + order + fieldname;       
        
    }
    catch(SObjectException soe)
    {
        System.debug(soe);
    }  
    //System.debug('DEFAULTVALUE:' + defaultValue);
    

    
    
  }
  
  public virtual void addOnLoadJavascriptToParentController(String js)
  {
    if (hidden != true && pageController != null)
    {
        if(downgrade != true)
            pageController.addOnLoadJavascript(js);         
    
        if(required == true) {
    
                if(additionalValRules != null && additionalValRules != '')
                    additionalValRules += ', ';
                else    
                  additionalValRules = '';  
                additionalValRules += 'required: true';                                    
        }
        if(additionalValRules != null && additionalValRules != '')
        {
               String init = '$(".' + uid + '").rules("add", \n' +   
                                ' { ' + additionalValRules + ' });\n'; 
                                    
               pageController.addOnLoadJavascript(init);
        }
    
    }
                
  }
  
  public virtual Object getCastedValue() {
    
        return myValueHolder;
  }
     
  
}