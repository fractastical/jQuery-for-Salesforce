//See bottom for copyright notice

global class SFDCFormController extends EnhancedComponentController {

    public Form__c form                             { get; set; }
    public List<Form_Field__c> fields               { get; set; }
    public String testString                        { get; set; }  
    public String formName                          { get; set; }  
    public String UpdateFieldName                   { get; set; }  
    public Boolean forwardParams                        { get; set; }  
    public String paramsToForward                   { get; set; }    
    List<String> params;
    List<String> values;      
    Map<String,String> allParams;

    public List<FieldWrapper> fieldsWithVal         { get; set; }
    public List<FieldWrapper> allFields             { get; set; }
    public List<FieldWrapper> fieldsWithAutoComplete{ get; set; }
    public List<FieldWrapper> fieldsWithShowRules   { get; set; }    
    public List<FieldWrapper> fieldsWithMaxLength   { get; set; }    
 
    public List<FieldWrapper> fieldsWithGroups      { get; set; }
    public List<FieldWrapper> fieldsWithDatePicker  { get; set; }
    public List<FieldWrapper> fieldsWithMultiSelect { get; set; }

    //Map that holds all the object names and tokens in your org
    Map<String, Schema.SObjectType> gd;
    public List<SObjectType> tokens = new List<SObjectType>();
    public Boolean editMode                         { get; set; }
    public PageControllerBase pageController        { get; set; }    
    public Boolean hasRequired                      { get; set; }    
        
    private static String DEFAULT_THEME = 'cupertino';
    
    public void getInit() {
  
        if (form == null) {
    
           if (formName == null || formName == '' )
                formName = System.currentPageReference().getParameters().get('name');
                                
            if(formName == null) {
                            
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You cannot access this page without a form name.'));
                return;  
            }
            try {
                
                form = [select Id, Name, Object_Name__c, Object_Label__c, Return_URL__c, Description__c, 
                        Title__c, Use_Enhanced_Datepicker__c, Use_Enhanced_Lookup__c,
                        Use_Enhanced_Multiselect__c, Use_Enhanced_Picklist__c, Use_Enhanced_Text__c, 
                        Use_Enhanced_Textarea__c, Style__c, Save_Button_Text__c, Default_Record__c,
                         Finished_Blurb__c from Form__c where name = :formname];        
            
            } catch(QueryException qe)  {
                
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'There is no form with this name.'));
                 return;        
                 
            }    
            
            
            /*if(paramsToForward != null)
            {
                forwardParams = true;
                params = paramsToforward.split(',');
                values = new List <String>();

                for(String p : params) 
                    values.add(System.currentPageReference().getParameters().get(p));
                
            }*/
            if(forwardParams != null && forwardParams)      
                allParams = System.currentPageReference().getParameters();   
                            
            String mode = System.currentPageReference().getParameters().get('mode');
            
            if(mode == 'edit')
                editMode = true;
            else  
                editMode = false;
                
            fields = [Select f.Name, f.Id, f.Type__c, f.Label__c, f.Order__c,  f.PicklistEntries__c,  
                        f.Required__c, f.Hidden__c, f.Tooltip__c, Default_Value__c, Info__c, Validate_as__c,
                        f.Requires_Verification__c, Object_Name__c, Group__c, Minimum_Length__c, 
                        Max_Length__c, Update_On__c, Masked_Input__c, Filter__c,
                        Minimum_Date__c, Maximum_Date__c  
                        from Form_Field__c f where f.Form__c = :form.id order by f.Order__c];
                        
            fieldsWithVal = new List<FieldWrapper>();  
            allFields = new List<FieldWrapper>();  
            fieldsWithShowRules = new List<FieldWrapper>();
            fieldsWithGroups = new List<FieldWrapper>();
            fieldsWithMaxLength = new List<FieldWrapper>();

            hasRequired = false;
            
            for(Form_Field__c f : fields)
            {
                
                 // Used on Customer Portal
                 if(f.Default_Value__c == 'CURRUSER')
                 {
                    User u = [select id, contactId from User where id =: UserInfo.getUserId()];
                    f.Default_Value__c = u.contactId;
                 }
                 
                 FieldWrapper fwv = new FieldWrapper(f);
                 if(fwv.hasValRules)
                    fieldsWithVal.add(fwv);
                 if(fwv.getHasShowRules())
                    fieldsWithShowRules.add(fwv); 
                 if(fwv.field.Max_Length__c != null)  
                    fieldsWithMaxLength.add(fwv);     
                 if(fwv.belongsToGroup)
                    fieldsWithGroups.add(fwv);  
                 if(fwv.field.Update_On__c == true) {
                    UpdateFieldName = fwv.field.name;
                    pageController.UpdateFieldName = UpdateFieldName;
                 }
                 if(f.Required__c)                  
                     hasRequired = true;
                        
                 allFields.add(fwv);
            }
                
            //get a full list of all objecttokens in this org
            gd = Schema.getGlobalDescribe();
            //System.debug('Results of Global Describe : ' + gd);            
            //get a reference to the token related to the object referenced in the webform
            //instantiate an object of this type
            String debugString = '';
            try {
                // myObject may also be passed to the form
                if(myObject == null)
                {
                    debugString += '1';

                    if(pageController != null)
                        debugString += 'a';
                    
                    if(pageController.myObject != null)
                    {
                        debugString += 'b';
                        myObject = pageController.myObject;
                    }
                        
                    debugString += '2';

                    if(myObject == null) {
                        debugString += '3';
                        
                        System.debug('INITIALIZING myObject');

                        SObjectType sot = gd.get(form.Object_Name__c);
                        debugString += '4';

                        if(sot.getDescribe().isAccessible())
                        myObject = sot.newSObject();                        
                        debugString += '5';

                        pageController.myObject = myObject;
                        debugString += '6';
                        
                    }
                }
            }
            
            //this happens when the object's API name doesn't exist, or has been removed from the profile access settings
            //Typically when admin's don't setup the webform editor correctly
            catch(System.NullPointerException ex) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'The system can not create a form for : '+ form.Object_Name__c + 'debug: ' + debugString));
                return;
            }
        
        String retUrl;
        if(form.Return_URL__c != null && form.Return_URL__c != '' && form.Return_URL__c.startsWith('www.')) 
        {
            retUrl = 'http://'+form.Return_URL__c; //this slightly different from the component version that takes sites into account         
        }
        else if(form.Return_URL__c != null && form.Return_URL__c != '')
        {
            retUrl = form.Return_URL__c;
        }
        if(retURL != null)
        {
            PageReference fwdRef = new PageReference(retURL);
            pageController.forwardingURL = fwdRef;
            
        }
        
            //if there is an existing object with default values for the form, we will load them
            if(form.Default_Record__c != null)
            {
                try {
                    System.debug('************************************************************************************: ' + form.Object_Name__c);
                    SObjectType sot = gd.get(form.Object_Name__c);
                    Map<String, SObjectField> fields = sot.getDescribe().fields.getMap();
                    List<SObjectField> fieldtokens = fields.values();
                    List<String> objectfields = new List<String>();
        
                    for(SObjectField fieldtoken:fieldtokens) {
                        
                        DescribeFieldResult dfr = fieldtoken.getDescribe();
                        if(!dfr.isCreateable()) continue; // || dfr.isDefaultedOnCreate()
                        if((dfr.getName() == 'CreatedDate') || (dfr.getName() == 'LastModifiedDate') || (dfr.getName() == 'CreatedById') || (dfr.getName() == 'LastModifiedById')) continue;
                        if(dfr.getName() == 'OwnerId') continue;
                        if(dfr.getName() == 'Name') continue;
    
                        objectFields.add(dfr.getName());
                        
                    }
                    
                    String queryString = 'select id, ';
                    for(String obf : objectfields)
                        queryString += obf + ', ';
                    queryString = queryString.substring(0,queryString.length()-2);
                    queryString += ' from ' + form.Object_Name__c + ' where id =\'' + form.Default_Record__c + '\'';
                    System.debug('QUERY:' + queryString);
                    List<SObject> defaults = Database.query(queryString);
                    for(String obf : objectFields)
                        if(defaults[0].get(obf) != null)
                            myObject.put(obf, defaults[0].get(obf));
                }
                catch (Exception e)             {
                    
                    System.debug('Could not load default values: ' + e ); 
                }
            }
            System.debug('Results of Global Describe : ' + gd);
            pageController.dispatchingController = this;  
            
            
         }
    }
    
    
    //fill the object with the correct field values and save it
    public PageReference saveObject() {
        System.debug('Entering Save method');
        String id;
        List<sObject> sos;        
        PageReference newPr;
        
        try {
            //Boolean to keep validation status
            Boolean valid = true;
            //loop over all the displayed fields
            for(Form_Field__c ff:fields) {
                String fieldtype = ff.Type__c;
                String name = ff.Name;
                //Object value = WebformUtils.getFormFieldValue(ff);
                Object value;  
                //Check if required fields have values
                try {
                    System.debug('Checking validity. Field:' + name + 'Required:' + ff.Required__c + ' Value:' + (String) value);     
                    String v = (String) value;
                    if (v == '' || v == null || v.length() < 1)
                        value = null;
                }
                catch (TypeException te)
                {
                    
                }
                if((value == null) && ff.Required__c  ) {
                    System.debug('value is null and required. Adding message!');
                    ApexPages.Message reqMsg = new ApexPages.Message(ApexPages.Severity.ERROR, ff.Label__c + ' is a required field.');
                    ApexPages.addMessage(reqMsg);               
                    valid = false;
                }           
                if(value != null) myObject.put(name, value);     
            }
            if(valid) {
                
                if(UpdateFieldName != null)
                {
                    try {
                             String queryString = 'Select Id from ' + myObject.getSObjectType() + ' where '  + UpdateFieldName + '=\'' + myObject.get(UpdateFieldName) + '\' limit 1';
                             System.debug('Attempting to update existing object. Query:' + queryString);
                             sos = Database.query(queryString);  
                             if(sos.size() > 0)
                             {
                                 SObject newmyObject = sos[0];
                                 Map<String, Schema.SObjectField> m = myObject.getSObjectType().getDescribe().fields.getMap();
                                 List<String> fieldNames = new List<String>();
                                 fieldNames.addAll(m.keySet());
                        
                                 for(Integer i=0; i < fieldNames.size(); i++)
                                 {
                                    String fieldName = fieldNames.get(i);
                                    if(fieldName != 'id')
                                    {
                                        Object o = myObject.get(fieldName);
                                        if (o!=null)
                                            newmyObject.put(fieldName,o);
                                    }
                                 }
                                 myObject = newmyObject;
                             }
                             
                        }
                        catch(Exception e)
                        {
                            System.debug('Error while attempting to Update existing object' + e);
                        }
                }

                System.debug('Ready to save sobject instance');
    
                upsert myObject;
                
                            
                
                pageController.ecSave();
                
                String retUrl = form.Return_URL__c;
                //accept url's with or without http://
                if (retUrl != null && retUrl.length() > 3)
                {
                    if(!form.Return_URL__c.startsWith('http://')) retUrl = 'http://'+form.Return_URL__c; //this slightly different from the component version that takes sites into account         
                    newPr =  new PageReference(retUrl);    
                }  

                         
            }
        } catch(Exception ex) {
            ApexPages.addMessages(ex);
            System.debug('Exception occured '+ex.getMessage());
        }

        if(forwardParams != null && forwardParams) {       
            
            newPr.getParameters().putAll(allParams);
            newPr.getParameters().put('id', myObject.id);
            
        }
            
        return newPr;
    }
    

    public Boolean getEmpty()  {
        return (allFields == null || allFields.size() == 0);
    }
    
    public Boolean getHasMessages() {
        return ApexPages.hasMessages();
    }
    
    public String getStylesheet()
    {
        String url = 'http://ajax.googleapis.com/ajax/libs/jqueryui/1.8/themes/';
        if(form.Style__c != null && form.Style__c != '')
        {   
            if(form.Style__c.startsWith('http')) return form.Style__c;
            else
                url += form.Style__c.replace(' ','-').toLowercase(); 
        }
        else
            url += DEFAULT_THEME;
            
        url += '/jquery-ui.css';
        
        return url;         

    }  

    class FieldWrapper
    {
        public Form_Field__c field {get; set;}
        public Integer order {get; set;}
        public Boolean hasValRules {get; set;}
        public Boolean belongsToGroup {get; set;}
        public String jqueryValidation {get; set;}
        public List<ShowRule> showRules { get; set; }
        public Boolean hasTooltip { get; set; }
          
        public FieldWrapper(Form_Field__c field)
        {
            this.field = field;
            if(field.Order__c != null)
                order = field.Order__c.intValue();  
            jqueryValidation = WebFormUtils.getJQueryValidation(field);  
            if (jqueryValidation == '')
                hasValRules = false;
            else
                hasValRules = true; 
            if (field.Group__c != null && field.Group__c.length() > 2)  
            {
                field.Group__c = field.Group__c.replaceAll(' ','');     
                belongsToGroup = true;    
            }
            else          
                belongsToGroup = false;    
            
            showRules = new List<ShowRule>();
            List<Field_Show_Rule__c> fsrs = [SELECT id, name, value_to_show__c from Field_Show_Rule__c where Form_Field__c =: field.id];
            for(Field_Show_Rule__c fsr : fsrs) 
            {
                ShowRule sr = new ShowRule(fsr);
                if(sr.hasValue)
                    showRules.add(sr);   
            } 
                
            if (field.Tooltip__c != null && field.Tooltip__c != '')
                hasTooltip = true;
            else
                hasTooltip = false;
                    
            //System.debug('Show rules run ' + showRules.size() + ' record returned');
                        
        }    
        
    public Boolean getHasMessages() {
    
        return ApexPages.hasMessages();
        
    }
    
    public Boolean getHasShowRules()
    {
        if (showRules == null || showRules.size() == 0)
            return false;
        else
            return true;
    }
    }


    
}