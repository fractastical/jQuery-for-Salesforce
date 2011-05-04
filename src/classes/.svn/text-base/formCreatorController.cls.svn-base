public class formCreatorController extends PageControllerBase {

    //Params
    public String fname                             { get; set; }
    public Integer position                         { get; set; }

    public Form__c webform                          { get; set; }  
    public Form_Field__c ff                         { get; set; }
    public String mode                              { get; set; }

    Map<String, Schema.SObjectType> gd;
    public List<SObjectType> tokens = new List<SObjectType>();
    public List<String> objectlabels                { get; set;}
    public SObjectType sot                          { get; set; } 
    public List<SelectOption> objectSelectOptions   { get; set; }
    public String selectedObject                    { get; set; } 
    public String selectedObjectLabel               { get; set; } 

    public List<SelectOption> recordSelectOptions   { get; set; }
    public String selectedRecord                    { get; set; } 
    public List<Form_Field__c> objectFields         { get; set; }
    public List<Form_Field__c> formFields           { get; set; }

    public Boolean displayPopup                     { get; set; }
    
    public Integer HeaderFieldCount = 0;
    public Integer InfoFieldCount = 0;
    public List<String> dateFields              { get; set; }
   
    public FormController myComponentController { get; set; }  
        
    //CONSTRUCTOR
    public formCreatorController(ApexPages.StandardController stdController) {
        init();
    }
    
    public formCreatorController() {
        init();
    }
    
    public void init() {
        
        dateFields = new List<String>();
        
        position = 1000;
        displayPopup = false;
        gd = Schema.getGlobalDescribe(); 
        tokens = gd.values(); //get the tokens from this map
        objectlabels = new List<String>();
        objectSelectOptions = new List<SelectOption>();
        ff = new Form_Field__c();
        
         for(SObjectType s:gd.values()) {
            
            if(!acceptedObject(s)) continue;
            
            objectlabels.add(s.getDescribe().getLabel());
            SelectOption so = new SelectOption(s.getDescribe().getName(), s.getDescribe().getLabel());
            objectSelectOptions.add(so);
        }
        formFields = new List<Form_Field__c>();
        objectFields = new List<Form_Field__c>();
        
        String webformid = System.currentPageReference().getParameters().get('id');
        if(webformid != null) {      
            webform = [select Id, Name, Object_Name__c, Object_Label__c, Finished_Blurb__c, Return_URL__c, Description__c, Title__c, Save_Button_Text__c, 
                    Style__c, Default_Record__c,  Use_Enhanced_Datepicker__c, Use_Enhanced_Lookup__c, Use_Enhanced_Multiselect__c, Use_Enhanced_Picklist__c, Use_Enhanced_Text__c, Use_Enhanced_Textarea__c
                    from Form__c where Id = :webformid];          
            myObject = webform;
            selectedObject = webform.Object_Name__c;
            selectObject();
            formFields = [Select f.Form__c, f.Type__c, f.Required__c, f.Validate_as__c, f.APIRequired__c, 
                        f.PicklistEntries__c, f.Order__c, f.Name, f.Label__c, f.Hidden__c, f.Id,
                        f.Minimum_Date__c, f.Maximum_Date__c, f.Info__c,
                        Minimum_Length__c, Max_Length__c, Requires_Verification__c
                        from Form_Field__c f where f.Form__c = :webform.Id order by f.Order__c];

            for(Form_Field__c formfield:formFields) {

                if(formfield.Type__c == 'Header') HeaderFieldCount++;
                if(formfield.Type__c == 'Info')  InfoFieldCount++;
                if(formfield.Type__c == 'Date' && formfield.Order__c != null)   
                    { 
                        String i = String.valueOf(formfield.Order__c);
                        i = i.subString(0,i.length());
                        dateFields.add(i);
                    }
                
                for(Integer i = 0; i < objectFields.size();i ++) {
                    Form_Field__c objectField = objectFields.get(i);
                    if(formField.Name == objectField.Name) objectFields.remove(i);
                }
            }                   
        }
        //create a new webform if no id is passed in the url
        else {
            webform = new Form__c();
            myObject = webform;
            sot = Schema.SObjectType.Contact.getSObjectType();
            selectedObject = 'Contact';
            selectedObjectLabel = 'Contact';
            selectObject();             
            webform.Save_Button_Text__c = 'Submit';            
            updateRecords();
        }
        webform.SavedByWebformEditor__c = true;
        
    }
    public void enablePopup() {
        displayPopup = true;
    }
    
    public String getX(String x) {
        return x;
    }
    
    private void preloadReqFields(){
            
            List<String> reqFields = new List<String>();
            for (Form_Field__c c : objectfields)
                if(c.APIRequired__c)  
                    reqFields.add(c.name);

            for (String n : reqFields) {
                    fname = n;
                    addField();
            }
        
    }
    
    public void updateRecords() {
  
        recordSelectOptions = new List<SelectOption>(); 
        recordSelectOptions.add(new SelectOption('', 'None'));
        
        for(SObject s : Database.query('select id, name from ' + selectedObject + ' order by name desc limit 100'))
            recordSelectOptions.add(new SelectOption(s.id, (String) s.get('name')));
          
    }  
    
    public PageReference selectObject() {

        sot = gd.get(selectedObject);
        selectedObjectLabel = sot.getDescribe().getLabel();
        webform.Object_Name__c = sot.getDescribe().getName();
        webform.Object_Label__c = sot.getDescribe().getLabel();
        objectFields.clear();
        formFields.clear();
        
        Map<String, SObjectField> fields = sot.getDescribe().fields.getMap();
        List<SObjectField> fieldtokens = fields.values();

        objectfields = new List<Form_Field__c>();

        for(SObjectField fieldtoken:fieldtokens) {
            DescribeFieldResult dfr = fieldtoken.getDescribe();

            if(!dfr.isCreateable()) continue; // || dfr.isDefaultedOnCreate()
            if((dfr.getName() == 'CreatedDate') || (dfr.getName() == 'LastModifiedDate') || (dfr.getName() == 'CreatedById') || (dfr.getName() == 'LastModifiedById')) continue;
            if(dfr.getName() == 'OwnerId') continue;
            //Next 2 lines handle the 'required' flag in the web form editor. We just want to exclude this flag for booleans since they always show up as not nillable
            Boolean required;
            if(!(dfr.getType().name() == 'BOOLEAN')) required = !dfr.isNillable(); //Booleans are always 'isNillable = false' but it doesn't matter since any boolean will always have a value of true or false. Let's not show that to the user. It's confusing
            if(dfr.getType().name() == 'BOOLEAN') required = false;
            
            Form_Field__c field = new Form_Field__c(Name = dfr.getName(), Label__c = dfr.getLabel(), Type__c = WebformUtils.getDisplayTypeFromSchemaType(dfr.getType().name()), Required__c = required, APIRequired__c = required, Hidden__c = false); //PicklistEntries__c = picklistvalues,
            objectFields.add(field);
        }
        objectfields = WebformUtils.sortByLabel(objectfields);

        preloadReqFields();
        updateRecords();
        
        return null;
    }


    public PageReference deepClone() {
        
        Form__c newForm = webform.clone(false,true);
        newForm.name = webform.name + '_copy';
        upsert newForm;
        List<Form_Field__c> newFormFields = new List<Form_Field__c>();
        for(Form_Field__c ff : formFields)
        {
            Form_Field__c newff = ff.clone(false,true);
            newff.Form__c = newForm.id;
            newFormFields.add(newff);
        }
        upsert newFormFields;
        
        
        return new PageReference('/' + newForm.id);
        
    }

    //adds an object's field to this web form
    public PageReference addField() {

        String fieldname = fname; 
        
        //System.debug('Adding field : ' + fieldname + ' from ' + selectedObject);
        
        for(Integer i = 0; i < objectFields.size();i++) {
            Form_Field__c ff = objectFields.get(i);
            if(ff.Name == fieldname)
             {
                DescribeFieldResult dfr = sot.getDescribe().fields.getMap().get(fieldname).getDescribe();
                String picklistvalues = '';
                String fieldType = dfr.getType().name();

                //TODO: Preload counry picklist here
                if( fieldType == 'PICKLIST' || fieldType == 'MULTIPICKLIST' ) {  

                    List<PicklistEntry> entries = dfr.getPicklistValues();

                    for(Integer j=0; j < entries.size();j++) {
                        PicklistEntry pe = entries.get(j);
                        picklistvalues = picklistvalues + pe.getValue();

                        if(j < entries.size()-1) picklistvalues += ',';
                    }
                }

                Form_Field__c field = objectFields.remove(i);
                field.PicklistEntries__c = picklistvalues;
                ff.Order__c = position;
                incrementFormFields(field);
                formFields.add(field);
                reOrderFormFields();
                ///give this a very high order to make sure the reorder puts it add the end of the list. Jquery will then give them correct sequential numbers in the interface anyway.
                position = 1000;
                break;
            }
        }       

        reOrderFormFields();

        return null;
    }
    
    public PageReference addHeader() {
        HeaderFieldCount++; //for keeping the name unique, needed for move up/down. These rely on the fieldname
        Form_Field__c f = new Form_Field__c(Name = 'Header' + HeaderFieldCount, Label__c = '* Custom Text *', Type__c = 'Header');             
        formFields.add(f);
        reOrderFormFields();
        return null;
    }
        

    public PageReference addInfo() {
        
        InfoFieldCount++; //for keeping the name unique, needed for move up/down. These rely on the fieldname
        ff.name = 'Info' + InfoFieldCount;
        ff.Label__c = 'Info' + InfoFieldCount;
        ff.Type__c = 'Info';             
        formFields.add(ff);
        ff = new Form_Field__c();
        reOrderFormFields();
        displayPopup = false;
        return null;
        
    }
    
    //remove an object's field from this web form
    public PageReference removeField() {
        
        String fieldname = fname;
        //get the Form_Field__c that was selected and move it to the object fields list
        System.debug('Field to delete : ' + fieldname);
        //
        for(Integer i = 0; i < formFields.size();i++) {
            Form_Field__c ff = formFields.get(i);
            //special case : custom text
            if(ff.Name == fieldname && ff.Type__c == 'Header') {
                System.debug('Header field to remove : ' + ff);
                ff.Order__c = null;
                formFields.remove(i); 
                break;
            }
            //normal case : move the field back 
            if(ff.Name == fieldname) {
                ff.Order__c = null;
                objectFields.add(formFields.remove(i));
                break;
            }
        }
        reOrderFormFields();
        objectfields = WebformUtils.sortByLabel(objectfields);  
        return null;
    }
    
    
    
    //save the webform and it's fields
    public PageReference save() {
        //if this page doesn't have all the needed info, stop right here
        if(!validate()) return null;
        try {
            //Save the web form     
            
            if(webform.name == null)
                webform.name = webform.Title__c.replace(' ','_');               
            
            upsert webform;
            
            ecSave();
            
            saveFields();
                        
            //and delete the form fields that are no longer in the List
            List<ID> formFieldIds = new List<ID>();
            for(Form_Field__c field:formFields) {
                formFieldIds.add(field.Id);             
            }
            List<Form_Field__c> todelete = [select Id from Form_Field__c where Form__c =:webform.Id and Id not in :formFieldIds];
            delete todelete;
        }
        catch(Exception ex) {
            ApexPages.addMessages(ex);
        }
        return new PageReference('/'+webform.Id);       
    }
    
    public PageReference saveAndValidation()
    {  
        save();  
        return new PageReference('/apex/validationRuleAdmin?id='+webform.Id);
          
    }
    
     public PageReference saveAndConditionalDisplay()
    {  
        save();  
        return new PageReference('/apex/conditionalDisplayAdmin?id='+webform.Id);
          
    }
    
    public PageReference saveFieldsAndConditionalDisplay()
    {
        saveFields();  
        return new PageReference('/apex/conditionalDisplayAdmin?id='+webform.Id); 
    }
    
    public PageReference saveFieldsAndGoToForm()
    {
        saveFields();  
        return new PageReference('/apex/formGenerator?id='+webform.Id);
    }
      
    public void saveFields()
    {
           //attached all the form fields to the correct Web Form
            for(Integer i = 0; i < formFields.size();i++) {
                Form_Field__c ff = formFields.get(i);
                if(ff.Form__c == null) ff.Form__c = webform.Id;             
            }
            
            System.debug(formfields);
            upsert formfields;
        
    }

    //JAD Form preview not supported    
    //save and preview the form
    public PageReference preview() {
        PageReference saveref = save();
        System.debug('WebForm Id : '+webform.Id);
        //if the form doesn't validate, this returns null, no use in previewing then
        //if(saveref == null) return Page.PreviewError;
        //else, show the Form       
        //PageReference pr = Page.FormPage;
        //pr.setRedirect(true);
        //pr.getParameters().put('id', webform.Id);
        //return pr;
        return null;
    }

    //method that will recalculate the order of the form fields when one has been removed or order changed
    private void reOrderFormFields() {
        if(formFields.size() == 0) return;
        //first put the list in the correct order.
        //The drag and drop functionality might have made the list completely different 
        //from the order they're in the formFields List (and because of the 'remove', some order values might be missing
        formFields = WebformUtils.sortByOrder(formFields);
        //and now fill them up with ascending values, this will remove the 'gaps' if there are any
        dateFields = new List <String>();        
        for(Integer i=0; i < formFields.size();i++) {
            Form_Field__c ff = formFields.get(i);
            ff.Order__c = i + 1;    
            if(ff.Type__c == 'Date')    
                { 
                    String s = String.valueOf(ff.Order__c);
                    s = s.subString(0,s.length());
                    dateFields.add(s);
                }
        }
    }  
    
    public List<SelectOption> getStyles()
    {
        List<SelectOption> styles = new List<SelectOption>();
        styles.add(new SelectOption('', '--SELECT--'));
        styles.add(new SelectOption('cupertino', 'Cupertino'));
        styles.add(new SelectOption('smoothness', 'Smoothness'));
        styles.add(new SelectOption('start', 'Start'));
        styles.add(new SelectOption('ui-darkness', 'UI Darkness'));
        styles.add(new SelectOption('redmond', 'Redmond'));
        styles.add(new SelectOption('black-tie', 'Black Tie'));
        styles.add(new SelectOption('blitzer', 'Blitzer'));
        styles.add(new SelectOption('dark-hive', 'Dark Hive'));
        styles.add(new SelectOption('dot-luv', 'Dot Luv'));
        styles.add(new SelectOption('eggplant', 'Eggplant'));
        styles.add(new SelectOption('excite-bike', 'Excite Bike'));
        styles.add(new SelectOption('flick', 'Flick'));
        styles.add(new SelectOption('hot-sneaks', 'Hot Sneaks'));
        styles.add(new SelectOption('humanity', 'Humanity'));
        styles.add(new SelectOption('le-frog', 'Le Frog'));
        styles.add(new SelectOption('overcast', 'Overcast'));
        styles.add(new SelectOption('pepper-grinder', 'Pepper Grinder'));
        styles.add(new SelectOption('south-street', 'South Street'));
        styles.add(new SelectOption('ui-lightness', 'UI Lightness'));
        styles.add(new SelectOption('vader', 'Vader'));

        return styles;          

    }
    
    private void incrementFormFields(Form_Field__c newItem) {
        if(formFields.size() == 0) return;
        
        for(Form_Field__c ff : formfields)
        {
            if (ff.Order__c >= newItem.order__c)
                ff.Order__c += 1;
        }
    }
    
    //method that is a pseudo variable to return the formfields' size to the page, usefull for the up / down links
    public Integer getFormFieldsSize() {
        return formFields.size();
    }
    
    //validate the page on save
    private Boolean validate() {
        Boolean valid = true;
        
        if(webform.Object_Name__c == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select an object this form needs to fill'));
            valid = false;
        }
        if(formFields.size() == 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select fields for this form'));
            valid = false;
        }
        //check if the user didn't forget any required fields
        for(Form_Field__c field:objectFields) {
            if(field.Required__c == true) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please add the required field '+field.Label__c+' to your form.'));
                valid = false;
            }
        }
        //check that all hidden fields have default values
        //check if Lookup fields point to an exising object
        for(Form_Field__c field:formFields) {
              if(field.Hidden__c == true && field.Type__c != 'Lookup') {
        //    if(field.Hidden__c == true) {               
        //        if(Webformutils.getFormFieldValue(field) == null) {    
        //            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'If you make the field \''+field.Label__c+'\' hidden, you need to provide a default value.'));
        //            valid = false; 
        //        }               
            }
            if(field.Type__c == 'Lookup') {
                try {
                    if(sot.getDescribe().fields.getMap().get(field.Name).getDescribe().isNamePointing()) continue; //skip the WhoId/WhatId fields for now       
                    //get the SObject this Lookup field points to                
                    List<Schema.Sobjecttype> referenceobjectlist = sot.getDescribe().fields.getMap().get(field.Name).getDescribe().getReferenceTo();
                    Schema.Sobjecttype referencesot;
                    if(referenceobjectlist != null && referenceobjectlist.size() > 0) referencesot = referenceobjectlist.get(0);
                    //try to find the object with this id           referencesot.getDescribe().getName()
                    //String qry = 'select Id from ' + referencesot.getDescribe().getName() + ' where Id = \'' + field.Text_Value__c + '\'';
                    String qry = 'select Id from ' + referencesot.getDescribe().getName() + ' limit 2'; // + ' where Id = \'' + field.Text_Value__c + '\'';
                    
                    System.debug('Lookup Check Query : ' + qry);
                    List<SObject> foundobjects = Database.query(qry);
                    System.debug('Result : ' + foundobjects);
                    field.Object_Name__c = referencesot.getDescribe().getName();  

                    foundobjects.get(0); //this will throw an exception if no object was found
                    
                } catch(Exception ex) {
          //          ApexPages.addMessage(new Apexpages.Message(Apexpages.Severity.ERROR, 'The Lookup ' + field.Text_Value__c +' for field '+ field.Name + ' is not valid. Lookup fields need to be hidden and have a correct Id value. '+ex.getMessage()));
           //         valid = false;  
                }   
            }
        }
        return valid;
    }
    
    public List<SelectOption> getPhoneVal()
    {
        List<SelectOption> so = new List<SelectOption>();
        so.add(new SelectOption('phoneus', 'US Phone'));
        so.add(new SelectOption('phoneusmasked', 'US Phone (Masked)'));
        so.add(new SelectOption('internationalphone', 'International Phone'));
        
        return so;
    }


    public List<SelectOption> getTextVal()
    {
        List<SelectOption> so = new List<SelectOption>();
        so.add(new SelectOption('', '--SELECT--'));
        so.add(new SelectOption('name', 'Name'));
        so.add(new SelectOption('zipcode', 'Zipcode'));
        so.add(new SelectOption('creditcard', 'Credit Card'));
        so.add(new SelectOption('alphanumeric', 'Alphanumeric'));
        so.add(new SelectOption('letterswithbasicpunc', 'Letters and Punctuation'));
        so.add(new SelectOption('nowhitespace', 'No Whitespace'));
        so.add(new SelectOption('time', 'Time'));
        return so;
        
    }
    
    //method that serves as action for the 'hidden' checkbox.
    public PageReference hiddenField() {
        //when unchecked after a value would have been defined already, the value field will disappear
        //we need to make sure that these selected values don't 'stick' in the form field
        String fieldname = System.currentPageReference().getParameters().get('fieldname');
        
        for(Form_Field__c f:formFields) {
            if(f.Name != fieldname) continue;

        }
        reOrderFormFields();
        return null;
    }
    
    //method used to clean out all the internal objects we don't want the users to create
    public Boolean acceptedObject(SObjectType s) {
        DescribeSObjectResult r = s.getDescribe();
        //skip the non createable ones, standard or custom
        if(!r.isCreateable()) return false;
        //do not accept the web form and form fields themselves
        if(r.getName() == 'Form__c' || r.getName() == 'Form_Field__c') return false;
        //other then that, we'll accepted all custom objects
        if(r.isCustom()&& r.getName() != 'Test__c' ) return true; //&& r.getName() != 'Test__c'
                
        //we're left with just the standard objects, just accept the common ones.
        String acceptedobjects = 'Case Lead Opportunity Account Contact CampaignMember';
        if(acceptedobjects.contains(r.getName())) return true;        
        
        //everything else is denied
        return false;
    }
    
  
      //*************
    // TEST METHODS
    //*************
    public static testMethod void ct1() {
        //* Construct the standard controller for Form__c. *//
        ApexPages.StandardController stdcon = new ApexPages.StandardController(new Form__c());
        
        formCreatorController controller = new formCreatorController(stdcon);
        //simulate an object select
        
        Profile p = [SELECT Id, name FROM profile WHERE name='System Administrator'];
        User u2 = TestUtility.createTestUser(p);

        controller.selectedObject = 'TestObject__c';
        controller.selectObject();                    
                    
        System.runAs(u2) {

        System.assertEquals('TestObject', controller.selectedObjectLabel);
        
        //fill in the fields
        Form__c form = controller.webform;
        form.Name = 'Test';
        form.Return_URL__c = 'http://www.salesforce.com';
        form.SavedByWebformeditor__c = true;
        //add some fields from the object to the form
        
        //namespace issues in unmanaged package
        /*
        controller.fname = 'formation__Checkbox__c'; 
        controller.addField();
        System.assertEquals(1, controller.formFields.size());
        controller.fname = 'formation__Text__c';
        controller.addField();
        System.assertEquals(2, controller.formFields.size());
        controller.fname = 'formation__Picklist__c';
        controller.addField();
        System.assertEquals(3, controller.formFields.size());
        //move a field up
        System.assertEquals('formation__Text__c', controller.formFields.get(1).Name);

        controller.fname = 'formation__Picklist__c';
        controller.removeField();
        System.assertEquals(2, controller.formFields.size());
        
        //preview the form
        PageReference previewref = controller.preview();
        System.assertEquals('/apex/formation__form', Page.form.getUrl());
        //save the webform
        PageReference ref = controller.save();
        System.assertNotEquals(null, ref);  
        */
        /*
        This code may not be working in production
        
formcreatorcontroller.ct1() Apex Classes(01pA00000019iCo)   System.LimitException: FormationLite:Too many query rows: 501
(FormationLite)
        */
        
        //create an empty webform that doesn't validate
        Form__c form2 = new Form__c();
        controller.webform = form2;
        form2.SavedByWebformeditor__c = true;
        //preview the none-validating web form
        //PageReference previewnull = controller.preview();
        //System.assertEquals('/apex/previewerror', Page.PreviewError.getUrl());
        PageReference ref2 = controller.save();
        System.assertEquals(null, ref2);
        
        //call some of the remaining methods
        controller.getFormFieldsSize();
        
        //empty the form fields list
        controller.formFields.clear();
        controller.reOrderFormFields();
        //controller.save();

        // Hopefully will bring below 501 lines     
        //System.LimitException: FormationLite:Too many query rows: 501   
        //controller.saveAndValidation();
        //controller.saveAndConditionalDisplay();
        //controller.saveFieldsAndConditionalDisplay();
        //controller.saveFieldsAndGoToForm();
        controller.getStyles();
        controller.getPhoneVal();
        controller.getTextVal();
        
        //cancel the edit
        //controller.cancel();
        
        }
    }
    
    
    //Test of an edit
    public static testMethod void ct2() {
                
        //Create a webform, fields and save it
        Form__c form = new Form__c();
        form.Name = 'Test';
        form.Object_Name__c = 'TestObject__c';
        form.Object_Label__c = 'Test';      
        form.Return_URL__c = 'http://www.salesforce.com';
        form.SavedByWebformeditor__c = true;
        insert form;
        
        //create test form fields for this web form
        Form_Field__c f1 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('STRING'), Name = 'Text__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f2 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('EMAIL'), Name = 'Email__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f3 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('URL'), Name = 'URL__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f4 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('BOOLEAN'), Name = 'Checkbox__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f5 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('DATE'), Name = 'Date__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f6 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('DATETIME'), Name = 'DateTime__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f7 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('CURRENCY'), Name = 'Currency__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f8 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('DOUBLE'), Name = 'Number__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f9 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('PERCENT'), Name = 'Percent__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f10 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('TEXTAREA'), Name = 'Text_Area__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f11 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('PHONE'), Name = 'Phone__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f12 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('PICKLIST'), Name = 'Picklist__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f13 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('UNSUPPORTED'), Name = 'Text__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f14 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('CUSTOMTEXT'), Name = 'CUSTOM Text1', Form__c = form.Id, Label__c = '* CUSTOM Text *');
        
        insert f1;
        insert f2;
        insert f3;
        insert f4;
        insert f5;
        insert f6;
        insert f7;
        insert f8;
        insert f9;
        insert f10;
        insert f11;
        insert f12;
        insert f13;
        insert f14;
        
        //now go to the editor in edit mode (the id url param exists)
        PageReference pageRef = Page.formGenerator;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', form.Id);
        
        //* Construct the standard controller for Form__c. *//
        ApexPages.StandardController stdcon = new ApexPages.StandardController(new Form__c());
        formCreatorController controller = new formCreatorController(stdcon);
        System.assertEquals(14, controller.formFields.size());
        //add a custom field
        controller.addHeader();
        System.assertEquals(15, controller.formFields.size());
        controller.save();
        //give the object a dummy required field
        Form_Field__c f15 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('STRING'), Name = 'Text__c', Form__c = form.Id, Label__c = 'lbl', Required__c = true);
        controller.objectFields.add(f15);
        System.assertEquals(controller.validate(), false);
        f15.Required__c = false;
        System.assertEquals(controller.validate(), true);
        //check if 'hidden field needs value' validation works
        Form_Field__c f16 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('STRING'), Name = 'Text__c2', Form__c = form.Id, Label__c = 'lbl', Hidden__c = true);
        controller.formFields.add(f16);
        
        //hide a field 'in the interface', this should reset any previously defined value back to null
        ApexPages.currentPage().getParameters().put('fieldname', 'Text__c2');
        controller.hiddenField();
        //System.assertEquals(webFormUtils.getFormFieldValue(f16), null);
        //does the reference check work correctly (reference Id's are stored in the Text_Value__c field)
        Form_Field__c f17 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('REFERENCE'), Name = 'Form__c', Form__c = form.Id, Label__c = 'lbl');
        controller.formFields.add(f17);
        //System.assertEquals(false, controller.validate());
        //now give it a real and existing reference  
        //f17.Text_Value__c = form.Id;
        //System.assertEquals(true, controller.validate());
    }  
    
  
}