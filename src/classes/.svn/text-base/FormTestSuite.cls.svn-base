public with sharing class FormTestSuite {


        //** TEST METHODS **//  
    
    public static testMethod void t1() {
        //set up a test web form
        Form__c form = new Form__c();
        form.Name = 'testWebform';
        form.Object_Name__c = 'Test__c';
        form.Return_URL__c = 'www.x.com';
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
        Form_Field__c f13b = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('INTEGER'), Name = 'Integer__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f15 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('MULTIPICKLIST'), Name = 'MultiPicklist__c', Form__c = form.Id, Label__c = 'lbl');
        
        
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
        insert f13b;
        insert f15;
                
        //add a field with a missing required value
        Form_Field__c f14 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('STRING'), Name = 'Text__c', Form__c = form.Id, Label__c = 'lbl', Required__c = true);
        insert f14;
        
        
        
        //set the current page for the test, put the web form id in parameters and instantiate the controller
        PageReference pageRef = Page.form;
        //PageReference pageRef;
        Test.setCurrentPage(pageRef);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('name', form.name);
        
        FormController controller = new FormController();
        controller.getInit();
        System.assertEquals(16, controller.fields.size());
        System.assertNotEquals(null,controller.getStylesheet());
        
        //save with missing required fields
        PageReference ref = controller.saveObject();
          
        System.assertEquals(null,ref);
        //add the required values and save again
        //f14.Text_Value__c ='something';
        //upsert f14;
                
        //now do everything again but with no 'required field' validation errors
        FormController controller2 = new FormController();
        
        PageReference ref2 = controller2.saveObject();  
        //System.assertEquals('http://www.x.com',ref2.getUrl());  
    }
    
    /* 081610 This method suddenly started throwing an exception on managed package install:
    *  System.NullPointerException: Attempt to de-reference a null object
	* (FormationLite)formtestsuite.t2()	Apex Classes(01pA0000000zupF)	
	* Cause unknown
	*/
	/*
    public static testMethod void t2() {
                
        //add an object with a required field in the db, just to throw an exception (Form__c itself for example)
        //set up a test web form
        Form__c form2 = new Form__c();
        form2.Name = 'test webform';
        form2.Object_Name__c = 'TestObject__c';//can't use account. Not accessible via Dynamix Apex in packaged class.
        form2.Object_Label__c = 'Test';
        form2.Return_URL__c = 'http://www.x.com';
        form2.SavedByWebformeditor__c = true;
        
        insert form2;
        //create test form fields for this web form
        Form_Field__c f20 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('STRING'), Name = 'Phone', Form__c = form2.Id, Label__c = 'lbl');
        //add just one, we ommit the required 'Name' field.     
        insert f20;
        
        // Add parameters to page URL
        PageReference pr = Page.form;
        //PageReference pr;  
        Test.setCurrentPage(pr);
        ApexPages.currentPage().getParameters().put('id', form2.Id);
        
        FormController controller3 = new FormController();
        //the save needs to throw an exception because the object's required field is not in the formfields list        
       
        System.assert(controller3.saveObject() == null);
        
        ApexPages.currentPage().getParameters().put('name', form2.name);
        FormDisplayController fdc = new FormDisplayController();
        fdc.myObject = new TestObject__c();
        fdc.ecSave();       
          
    } */ 

    public static testMethod void testDefaultRecordLoad() {
        //set up a test web form
        TestObject__c to = new TestObject__c();
        to.name ='Frog King';
        to.Text__c = 'Frogs rule';
        insert to;
        
        Form__c form = new Form__c();
        form.Name = 'testWebform';
        form.Object_Name__c = 'TestObject__c';
        form.Return_URL__c = 'www.x.com';
        form.Default_Record__c = to.id;
        form.SavedByWebformeditor__c = true;
        
        insert form;
        
        //create test form fields for this web form       
        Form_Field__c f1 = new Form_Field__c(Type__c = 'Text', Name = 'Text__c', Form__c = form.Id, Label__c = 'lbl');
        insert f1;
        
        //set the current page for the test, put the web form id in parameters and instantiate the controller
        PageReference pageRef = Page.form;
        Test.setCurrentPage(pageRef);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('name', form.name);
        PageControllerBase pcb = new PageControllerBase();
        FormController controller = new FormController();
        controller.pageController = pcb;
        controller.getInit();
        System.assertEquals(to.Text__c, (String) controller.myObject.get('Text__c'));
               
    }
    
    public static testMethod void testDefaultValueSaveWithHiddenText() {
        
        Form__c form = new Form__c();
        form.Name = 'testWebform';
        form.Object_Name__c = 'TestObject__c';
        form.Return_URL__c = 'www.x.com';
        form.SavedByWebformeditor__c = true;
        
        insert form;
        
        //create test form fields for this web form       
        Form_Field__c f1 = new Form_Field__c(Type__c = 'Text', Name = 'Text__c', Form__c = form.Id, Label__c = 'lbl', Default_Value__c = 'Frog soup');
        insert f1;
        Form_Field__c f2 = new Form_Field__c(Type__c = 'Text', Name = 'Text__c', Form__c = form.Id, Label__c = 'lbl', Hidden__c = true, Default_Value__c = 'Frog patte');
        insert f2;
        
        PageReference pageRef = Page.form;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('name', form.name);
        PageControllerBase pcb = new PageControllerBase();
        FormController controller = new FormController();
        controller.pageController = pcb;
        controller.getInit();

		EnhancedTextController etc = new EnhancedTextController();
		etc.pageController = pcb;
		etc.fieldName = f1.name;
		etc.defaultValue = f1.Default_Value__c;
		etc.validateAs = f1.Type__c;
		etc.hidden = f1.Hidden__c;
		etc.getOnLoad();
  
		EnhancedTextController etc2 = new EnhancedTextController();
		etc2.pageController = pcb;
		etc2.fieldName = f2.name;
		etc2.defaultValue = f2.Default_Value__c;
		etc2.validateAs = f2.Type__c;
		etc2.hidden = f2.Hidden__c;
		etc2.getOnLoad();			  	


		System.assertEquals(f1.Default_Value__c,(String) etc.getCastedValue());

		System.assertEquals(f2.Default_Value__c,(String) etc2.getCastedValue());
        
        pcb.ecSave();
        
        System.assertEquals(f1.Default_Value__c, pcb.myObject.get('Text__c'));
               
               
    }
    
    
        public static testMethod void testDefaultValueSaveWithCURRUSER() {
        
        Form__c form = new Form__c();
        form.Name = 'testWebform';
        form.Object_Name__c = 'TestObject__c';
        form.Return_URL__c = 'www.x.com';
        form.SavedByWebformeditor__c = true;
        
        insert form;
        
        //create test form fields for this web form       
        Form_Field__c f1 = new Form_Field__c(Type__c = 'Text', Name = 'Text__c', Form__c = form.Id, Hidden__c = true, Label__c = 'lbl', Default_Value__c = 'CURRUSER');
        insert f1;  
		Profile p = [select Id, Name from Profile where name = 'System Administrator' limit 1];
        User u = TestUtility.createTestUser(p);
        update u;

		System.runAs(u)
		{        
	        PageReference pageRef = Page.form;
	        Test.setCurrentPage(pageRef);
	        ApexPages.currentPage().getParameters().put('name', form.name);
	        PageControllerBase pcb = new PageControllerBase();
	        FormController controller = new FormController();
	        controller.pageController = pcb;
	        controller.getInit();
			
			//System.assertEquals(u.id,controller.allFields.get(0).field.Default_Value__c);
	
			EnhancedTextController etc = new EnhancedTextController();
			etc.pageController = pcb;
			etc.fieldName = controller.allFields.get(0).field.name;
			etc.defaultValue =  controller.allFields.get(0).field.Default_Value__c;
			etc.validateAs =  controller.allFields.get(0).field.Type__c;
			etc.hidden =  controller.allFields.get(0).field.Hidden__c;
			etc.getOnLoad();
			
	  		
	        pcb.ecSave();
	        
	        //Need customer portal
	        //System.assertEquals(u.id, pcb.myObject.get('Text__c'));	        
		}
	               
               
    }
    

    public static testMethod void testDefaultValueSaveWithHiddenLookup() {
        
        Form__c form = new Form__c();
        form.Name = 'testWebform';
        form.Object_Name__c = 'TestObject__c';
        form.Return_URL__c = 'www.x.com';
        form.SavedByWebformeditor__c = true;
        
        insert form;
	    
	    Profile p = [select Id, Name from Profile where name = 'System Administrator' limit 1];
        User u = TestUtility.createTestUser(p);
        update u;

		Test.startTest();
		
		System.runAs(u)
		{        
	    
	        PageReference pageRef = Page.form;
	        Test.setCurrentPage(pageRef);
	        ApexPages.currentPage().getParameters().put('name', form.name);
	        PageControllerBase pcb = new PageControllerBase();
	        FormController controller = new FormController();
	        controller.pageController = pcb;
	        controller.getInit();
		
			EnhancedLookupController elc = new EnhancedLookupController();
			elc.objectToLookup = 'TestLookupObject__c';	
			
			TestLookupObject__c tlo_toTest = new TestLookupObject__c();
			tlo_toTest.name = 'Test TLO';
			insert tlo_toTest;
			
			TestLookupObject__c tlo_toTest2 = new TestLookupObject__c();
			tlo_toTest2.name = 'Test TLO2';
			insert tlo_toTest2;
			
			TestLookupObject__c tlo = [Select id from TestLookupObject__c where name = 'Test TLO' limit 1];
			TestLookupObject__c tlo2 = [Select id from TestLookupObject__c where name = 'Test TLO2' limit 1];
			
			elc.fieldName = 'Test_Lookup_Object__c';
			//elc.jsonRecordLimit = 5;
			elc.defaultValue = tlo.id;
			elc.hidden = true;
			elc.pageController = pcb;
			elc.getOnLoad();
		  	pcb.ecSave();
		    System.assertEquals(tlo.id, pcb.myObject.get('Test_Lookup_Object__c'));
			System.assertNotEquals(null, tlo.id);
	
			EnhancedLookupController elc2 = new EnhancedLookupController();
			elc2.objectToLookup = 'TestLookupObject__c';	
			//elc2.jsonRecordLimit = 5;
			elc2.fieldName = 'Test_Lookup_Object__c';
			elc2.pageController = pcb;
			elc2.getOnLoad();
			elc2.myValueHolder = tlo2.id;
		  	pcb.ecSave();
			System.assertEquals(tlo2.id, (String) pcb.myObject.get('Test_Lookup_Object__c'));
	                
			EnhancedLookupController elc3 = new EnhancedLookupController();
			elc3.objectToLookup = 'TestLookupObject__c';	
			//elc3.jsonRecordLimit = 5;
			elc3.fieldName = 'Test_Lookup_Object__c';
			elc3.defaultValue = '';
			elc3.pageController = pcb;
			elc3.getOnLoad();
		  	pcb.ecSave();
			System.assertEquals(tlo2.id, (String) pcb.myObject.get('Test_Lookup_Object__c'));
			
			EnhancedLookupController elc4 = new EnhancedLookupController();
			elc4.objectToLookup = 'TestLookupObject__c';	
			//elc4.jsonRecordLimit = 5;
			elc4.fieldName = 'Test_Lookup_Object__c';
			elc4.defaultValue = tlo.id;
			elc4.pageController = pcb;
			elc4.getOnLoad();
		  	pcb.ecSave();    
			//System.assertEquals(tlo.id, (Id) pcb.myObject.get('Test_Lookup_Object__c'));
			/*System.AssertException: Assertion Failed: Expected: a01A00000029cm2IAA, Actual: a01A00000029cm3IAA
	Class.formation.FormTestSuite.testDefaultValueSaveWithHiddenLookup: line 272, column 3
	External entry point*/
		}


      }


    public static testMethod void testSaveWithUpdateOn() {
        
        Form__c form = new Form__c();
        form.Name = 'testWebform';
        form.Object_Name__c = 'TestObject__c';
        form.Return_URL__c = 'www.x.com';
        form.SavedByWebformeditor__c = true;
        
        insert form;
        
        Form_Field__c f1 = new Form_Field__c(Type__c = 'Text', Name = 'Text__c', Form__c = form.Id, Hidden__c = true, Update_on__c = true, Label__c = 'lbl', Default_Value__c = 'hi');
        insert f1;  

        Form_Field__c f2 = new Form_Field__c(Type__c = 'Text', Name = 'name', Form__c = form.Id, Hidden__c = true, Update_on__c = false, Label__c = 'lbl', Default_Value__c = 'hi');
        insert f2;  
        
        
		TestObject__c to = new TestObject__c();
		to.name = 'Frank99887766655';
		to.Text__c = 'TestText445566';
		insert to;
		
		        
        PageReference pageRef = Page.form;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('name', form.name);
        PageControllerBase pcb = new PageControllerBase();
        FormController controller = new FormController();
        controller.pageController = pcb;
        controller.getInit();
	
		EnhancedTextController etc = new EnhancedTextController();
		etc.pageController = pcb;
		etc.fieldName = 'Text__c';
		etc.getOnLoad();
		etc.myValueHolder = 'TestText445566';
		
		EnhancedTextController etc2 = new EnhancedTextController();  
		etc2.pageController = pcb;
		etc2.fieldName = 'name';
		etc2.getOnLoad();
		etc2.myValueHolder = 'Franklin';
		
		pcb.ecSave();
		
		List<TestObject__c> testObs = [select id, name from TestObject__c where Text__c = 'TestText445566'];
		System.assertEquals(1, testObs.size());
		System.assertEquals('Franklin', testObs[0].name);
		

      }


    
    //no web form id url param
    public static testMethod void t3() {
        //instantiate the controller with no Id param
        FormController controller1 = new FormController();
        
        //set up a test web form - we're going to hit the nullpointer exception with this one
        Form__c form = new Form__c();
        form.Name = 'test webform';
        form.Object_Name__c = 'testbypassx'; //when people don't set up the web editor and try to fill this in manually
        form.Return_URL__c = 'www.x.com';
        
        insert form;
        //create test form fields for this web form
        Form_Field__c f1 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('STRING'), Name = 'Text__c', Form__c = form.Id, Label__c = 'lbl');
        Form_Field__c f2 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('EMAIL'), Name = 'Email__c', Form__c = form.Id, Label__c = 'lbl');
        
        insert f1;  
        insert f2;

    
        //set the current page for the test, put the web form id in parameters and instantiate the controller
       PageReference pageRef = Page.form;
       // PageReference pageRef;  
        Test.setCurrentPage(pageRef);
        // Add parameters to page URL
        ApexPages.currentPage().getParameters().put('id', form.Id);
        //instantiate the controller with the form/wrong object name
        FormController controller = new FormController();           
    }


    public static testMethod void testPicklist() {
        FormFieldController controller = new FormFieldController();
        Form_Field__c field = new Form_Field__c();
        field.PicklistEntries__c = 'a,b,c%,d';
        field.Type__c = 'Picklist';
        controller.field = field;
        //List<SelectOption> selectlist = controller.getPicklistSelectOptions();

		PageControllerBase pcb = new PageControllerBase();
		EnhancedSelectController ensc = new EnhancedSelectController();
		ensc.picklistEntries = field.PicklistEntries__c;
		ensc.pageController = pcb;  
		ensc.fieldName = 'Picklist__c';
		ensc.getOnLoad();
        System.assertEquals('c,d', ensc.getPicklistValues().get(3).so.getValue());
        System.assertEquals(4, ensc.getPicklistValues().size());

    }
    
   public static testMethod void testLabel() {
        EnhancedLabelController controller = new EnhancedLabelController();
        Form_Field__c field = new Form_Field__c();
        field.name = 'pebbles';
        field.Label__c = 'Fruity Pebbles';
        field.Tooltip__c = 'delicious';
		controller.label = field.Label__c;
		controller.forField = field.name;
		controller.renderIcon = true;
		controller.tooltip = field.Tooltip__c;
		controller.getOnLoad();
    }
    

    public static testMethod void testMultiPicklist() {
        FormFieldController controller = new FormFieldController();
        Form_Field__c field = new Form_Field__c();
        field.PicklistEntries__c = 'a,b,c';
        field.Type__c = 'Multi-Select';
        controller.field = field;
        List<SelectOption> selectlist = controller.getPicklistSelectOptions();
        System.assertEquals(3, selectlist.size());
    }

    public static testMethod void testNumberPicklist() {
    	
        Form__c form = new Form__c();
        form.Name = 'testWebform';
        form.Object_Name__c = 'TestObject__c';
        form.Return_URL__c = 'www.x.com';
        form.SavedByWebformeditor__c = true;
        
        insert form;
	
	    Form_Field__c field = new Form_Field__c();
        field.PicklistEntries__c = '1,2,3';
        field.Type__c = 'NumberPicklist';
    	field.Form__c = form.id;
    	insert field;
    	        
        PageReference pageRef = Page.form;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('name', form.name);
        PageControllerBase pcb = new PageControllerBase();
        FormController controller = new FormController();
        controller.pageController = pcb;
        controller.getInit();
        
		EnhancedSelectController ensc = new EnhancedSelectController();
		ensc.isNumber = true;
		ensc.picklistEntries = field.PicklistEntries__c;
		ensc.pageController = pcb;  
		ensc.fieldName = 'Number__c';
		ensc.getOnLoad();
		ensc.myValueHolder = ensc.getPicklistValues()[2].so.getValue();
		System.assertEquals(2,(Decimal) ensc.getCastedValue());
	  	pcb.ecSave();
	  	System.assertEquals(2, pcb.myObject.get('Number__c'));
        
        
    }


    public static testMethod void testMultiPicklist2() {
    	
        Form__c form = new Form__c();
        form.Name = 'testWebform';
        form.Object_Name__c = 'TestObject__c';
        form.Return_URL__c = 'www.x.com';
        form.SavedByWebformeditor__c = true;
        
        insert form;  
	
	    Form_Field__c field = new Form_Field__c();
        field.PicklistEntries__c = '1,2,3';
        field.Type__c = 'Multi-Select';
    	field.Form__c = form.id;
    	insert field;
    	        
        PageReference pageRef = Page.form;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('name', form.name);
        PageControllerBase pcb = new PageControllerBase();
        FormController controller = new FormController();
        controller.pageController = pcb;
        controller.getInit();
        
		EnhancedMultiselectController ensc = new EnhancedMultiselectController();
		ensc.picklistEntries = field.PicklistEntries__c;
		ensc.pageController = pcb;  
		ensc.fieldName = 'Picklist_Multi_Select__c';
		ensc.getOnLoad();
		ensc.myValueHolder = ensc.getPicklistValues()[2].so.getValue();
		System.assertEquals('3', ensc.getCastedValue());
	  	pcb.ecSave();
	  	System.assertEquals('3', pcb.myObject.get('Picklist_Multi_Select__c'));
        
        
    }





    public static testMethod void testConditionalDisplayAdmin() {
    	
        Form__c form = new Form__c();
        form.Name = 'testWebform';
        form.Object_Name__c = 'Test__c';
        form.Return_URL__c = 'www.x.com';
        form.SavedByWebformeditor__c = true;
        insert form;

        Form_Field__c f1 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('STRING'), Name = 'Text__c', Form__c = form.Id, Label__c = 'tlbl');
        Form_Field__c f2 = new Form_Field__c(Type__c = WebFormUtils.getDisplayTypeFromSchemaType('EMAIL'), Name = 'Email__c', Form__c = form.Id, Label__c = 'elbl');
        Form_Field__c f3 = new Form_Field__c(Type__c = 'Picklist', Name = 'Picklist__c', PicklistEntries__c = 'Option 1,Option 2,Option 3', Form__c = form.Id, Label__c = 'plbl');

		insert f1;
		insert f2;
		insert f3;

       	PageReference pageRef = Page.conditionalDisplayAdmin;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', form.Id);

		FormAdminController fa = new FormAdminController();
		fa.currGroup.groupName = 'group1';
		fa.addGroup();
		System.assertEquals(1, fa.groups.size());
		fa.groupName = 'group1';
		fa.fieldName = 'Text__c';
		fa.addFieldToGroup();
		System.assertEquals(1, fa.groups.get(0).fields.size());
		System.assertEquals('group1', fa.groups.get(0).groupName);
		fa.save();
				
		fa = new FormAdminController();
		
		System.assertEquals(1, fa.groups.size());
		f1 = [Select id, group__c from Form_Field__c where Form__c = :form.id and name = 'Text__c' limit 1];
		System.assertEquals(fa.groups.get(0).groupName, f1.Group__c);
		
		fa.currGroup.groupName = 'group2';
		fa.addGroup();
		System.assertEquals(2, fa.groups.size());
		fa.groupName = 'group2';
		fa.fieldName = 'Email__c';  
		fa.addFieldToGroup();
		System.assertEquals(1, fa.groups.get(1).fields.size());
		fa.groupName = 'group2';
		fa.fieldName = 'Email__c';
		fa.removeFieldFromGroup();			
		System.assertEquals(0, fa.groups.get(1).fields.size());
		fa.save(); 

		fa = new FormAdminController();
		System.assertEquals(1, fa.groups.size());
		fa.groups.get(0).showFieldName = 'Picklist__c';
		fa.groupName = 'group1';
		fa.saveShowField();
		System.assert(fa.groups.get(0).ShowFieldName == 'Picklist__c');
		System.assert(fa.groups.get(0).ShowFieldType == 'Picklist');  
		System.assert(fa.groups.get(0).ShowFieldPicklistEntries != null);
		System.assertEquals(3,fa.groups.get(0).getShowFieldPicklistSO().size());
		fa.val = 'Option 1';  
		fa.addVal();
		fa.val = 'Option 2';  
		fa.addVal();
			//	System.assertEquals('Option 1', fa.groups.get(0).showVals.get(0) +  fa.groups.get(0).showVals.get(1) +  fa.groups.get(0).showVals.get(2) + fa.groups.get(0).showVals.get(3));	
		
		System.assertEquals(2, fa.groups.get(0).showVals.size());	
		fa.save();  
		Field_Show_Rule__c sr = [select name, Form_Field__c, Form_Field__r.name, Form_Field__r.PicklistEntries__c, Value_to_show__c from Field_Show_Rule__c where Form_Field__c =: f3.id limit 1];		
		System.assertEquals('Option 1,Option 2', sr.Value_to_Show__c);
		fa = new FormAdminController();
		System.assertEquals(2, fa.groups.get(0).showVals.size());	
		fa.currGroup.groupName = 'group3';
		fa.addGroup();
		System.assertEquals(2, fa.groups.size());
		fa.groupName = 'group3';
		fa.fieldName = 'Email__c';
		fa.addFieldToGroup();
		System.assertEquals(1, fa.groups.get(1).fields.size());  
		fa.groups.get(1).showFieldName = 'Picklist__c';
		fa.groupName = 'group3';
		fa.saveShowField();
		System.assertEquals('Picklist__c',fa.groups.get(1).showFieldName);
		System.assertEquals('Picklist',fa.groups.get(1).showFieldType);
		fa.val = 'Option 3';
		fa.addVal();
		fa.save();
		List<Field_Show_Rule__c> srs = [select name, Form_Field__c, Form_Field__r.name, Form_Field__r.PicklistEntries__c, Value_to_show__c from Field_Show_Rule__c where Form_Field__c =: f3.id];		
		System.assertEquals(2, srs.size());
		fa = new FormAdminController();
		System.assertEquals('Picklist__c',fa.groups.get(1).showFieldName);
		
		fa.enableAddValPopup();
		fa.disableAddValPopup();
		fa.enablePopup();
		fa.disablePopup();
		//System.assertEquals('Picklist',fa.groups.get(1).showField.name);  
		

    }

  

}

//  Copyright (c) 2009, David Van Puyvelde, Sales Engineering, Salesforce.com Inc.
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//  Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. 
//  Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//  Neither the name of the salesforce.com nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission. 
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
//  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
//  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
//  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.