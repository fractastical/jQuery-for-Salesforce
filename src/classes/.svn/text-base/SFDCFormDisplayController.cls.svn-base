global class SFDCFormDisplayController extends PageControllerBase {
     
      public ApexPages.StandardController standardCon { get; set; }
      public String fieldName                       { get; set; }
      public Form__c form                           { get; set; }   
      public String formname                        { get; set; }
      public SObject activeSObject                  { get; set; }  

    public SFDCFormDisplayController() {
              
        formname = ApexPages.CurrentPage().getParameters().get('name');
               
    }  
          
  global override PageReference ecSave() {
          
    SFDCFormController formCon = (SFDCFormController) dispatchingController;
    
        System.debug('*********************************************************************************test');
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
                              if(ecc.FieldName == updateFieldName) 
                        attemptUpdate();
                              
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
                        if(ecc.FieldName == updateFieldName) 
                        attemptUpdate();
                              
                          
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
        
       //System.debug(LoggingLevel.WARN, 'TRYING TO INSERT ACTIVITY RECORD');  
       //System.debug(LoggingLevel.WARN, 'formCon is null? ' + (formCon == null));  
       //System.debug(LoggingLevel.WARN, 'formCon form is null? ' + (formCon.form == null));  
       
       Formation_Settings__c settings = Formation_Settings__c.getInstance('Default');
       String ownerId;
       if( settings != null) ownerId = settings.Owner__c;    
         
        if(ownerId != null && ownerId != '' && (formCon.form.Object_Name__c == 'Contact' || formCon.form.Object_Name__c == 'Lead') )
        {
          try
              { 
                  insert new Task(
                   WhoID                         = (String) myObject.get('id'),
                   Subject                       = formCon.form.Title__c,
                   ActivityDate                  = Date.today(),  // or System.now()
                   Status                        = 'Completed',
                   Priority                      = 'Normal',
                   OwnerId              = ownerId  
                  );  
              }
              catch(Exception e)
               {
                 System.debug('Failed to insert Task' + e);
                 
              }  
        }        

      return forwardingURL;

      }
      
      

}