global virtual class PageControllerBaseTester {
    
  public List<EnhancedComponentController> myComponentControllers = new List<EnhancedComponentController>();
  private String onLoadJavascript;
  private String javascriptMethods;  
  public String name { get; set; }
  global SObject myObject               { get; set; }
  public Boolean hasHidden = false;
  public PageReference forwardingURL    { get; set; }
  public EnhancedComponentController dispatchingController { get; set; }

    
      public void addComponentController(EnhancedComponentController compController) {
        
            if(myComponentControllers == null)
                myComponentControllers = new List<EnhancedComponentController>();
            if(!hasComponentController(compController)) 
                myComponentControllers.add(compController);
            if (compController.hidden == true)
                hasHidden = true;
            compController.order = myComponentControllers.size();
            
      } 
      
      public List<EnhancedComponentController> getMyComponentControllers() {
        return myComponentControllers;
      }
      
    private Boolean hasComponentController(EnhancedComponentController compController) {
                            
             for (EnhancedComponentController ecc : myComponentControllers)
                if (ecc == compController)
                    return true;
                    
             return false;

      }
      

  public String getOnLoadJavascript()
  {
    return onLoadJavascript;    
  }    
  
  public void addOnLoadJavascript(String jsToAdd) {
    
     if(onLoadJavascript == null)
        onLoadJavascript = '';
     onLoadJavascript += jsToAdd;
     
  }
  
  public String getJavascriptMethods()
  {
    return javascriptMethods;   
  }  
  
  public void addJavascriptMethods(String jsToAdd) {
    
     if(javascriptMethods == null)
        javascriptMethods = ''; 
     javascriptMethods += jsToAdd;
     
  }
  
  public String getJavascript()
  {
        String js = '<script type="text/javascript">\n';
        
        if(javascriptMethods != null) 
          js += javascriptMethods + '\n';
        
        if(onLoadJavascript != null)
          js += '  $(document).ready(function() {\n  ' +
            onLoadJavascript +  
            '   });  \n';
            
        js +=   '</script>';
        
        return js;
  }    

  public String getJavascriptDependencies()
  {
    return  '<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js"/></script>\n' +
        '<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.1/jquery-ui.min.js"/></script>\n' +
        '<script type="text/javascript" src="http://ajax.microsoft.com/ajax/jquery.validate/1.6/jquery.validate.min.js"></script>\n' +
        '<script type="text/javascript" src="http://ajax.microsoft.com/ajax/jquery.validate/1.6/additional-methods.js"></script>\n' +
        '\n<style> .required, .message {color: red;}\n' +    
        //'* { font-family: Verdana; font-size: 96%; }\n' +
        'label.error { float: none; color: red; padding-left: .5em; vertical-align: top; }</style>\n';
//      'label.selectmenueerror { float: none; color: red; padding-left: 155px; vertical-align: top; }</style>\n';
  }
  
  public String getCompleteJavascript()
  {
        String js = '' +
        '<script type="text/javascript">\n';
        
        if(javascriptMethods != null) 
          js += javascriptMethods + '\n';

        if(onLoadJavascript == null)
            onLoadJavascript = '';
            
          js += ' var form = $(".form");\n ' +
          ' $(document).ready(function() {\n  ' +
               ' \n' + 
               '   $(form).validate({ \n' +
               ' \n' +
               '      submitHandler: function(form) {\n' +
               '        saveMe();\n' +
               '      } \n' +
               ' }); \n' +
            onLoadJavascript +  
            '   });  \n';
            
        js +=   '</script>\n';
        
        return js;
  }    
  
  
  global virtual PageControllerBaseTester getThis() {
    return this;
  }
  
  global virtual PageReference ecSave() {

        //System.debug(myComponentControllers.size() + ' Component Controllers');
        
        // We save values in hidden fields first since there may be a duplicate and if there is a duplicate we want the displayed field to override the hidden field.
        
        if(hasHidden)
        {
            for(EnhancedComponentController ecc : myComponentControllers)
            {  
                  if(ecc.hidden == true)
                  {
                      Object oToPut = ecc.getCastedValue();
                      System.debug('ecSave ' + ecc.fieldName);   
                      
                      if(oToPut != null)  
                      {
                          System.debug('Attempting to save with an object of type ' + myObject.getSObjectType() + ' and field name: ' + ecc.fieldName);
                          
                          try {    
                                  
                                  myObject.put(ecc.fieldName, oToPut);
                              
                          } catch (Exception e) {
                              System.debug('Error with fieldname: ' + ecc.fieldName + ' ' + e);
                              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Update failed on field ' + ecc.fieldName));
                          }      
                      }
                  }
            }
        }
        
        for(EnhancedComponentController ecc : myComponentControllers)
        {  
         if(ecc.hidden != true)
              {
                  Object oToPut = ecc.getCastedValue();
                  System.debug('ecSave ' + ecc.fieldName); 
                  
                  if(oToPut != null)  
                  {  

                      System.debug('Attempting to save with an object of type ' + myObject.getSObjectType() + ' and field name: ' + ecc.fieldName);
                      
                      try {    
                              
                              myObject.put(ecc.fieldName, oToPut);
                          
                      } catch (Exception e) {
                          System.debug('Error with fieldname: ' + ecc.fieldName + ' ' + e);
                          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Update failed on field ' + ecc.fieldName));
                      }      
                  }
              }
        }
        
        // may be optional if using a standard controller w/ standard elements alongside this
        // although appears not to be triggered if no inputField is changed
        upsert myObject;   
        
        return forwardingURL;

      }
      
    
}