public with sharing class EnhancedComponentTestSuite {

  // test method for our pre-loaded test object 
  static testmethod void testTestObject() {
    
    TestObject__c to = new TestObject__c();
    to.Currency__c = 21.0;
    to.Date__c = Date.newInstance(2009,01,02);
    to.Text__c = 'Text1';
    to.Text_Area__c = 'LongText';
    to.Percent__c = 41;
    to.Number__c = 23;
    to.Url__c = 'http://woo.com';
    to.Email__c = 'foogly@aol.com';
    to.Name = 'Jamie Jones';
    to.Text_Area_Long__c = 'VeryLongText';
    to.Picklist_Multi_Select__c = 'Hello;Goodbye';
    to.Picklist__c = 'Hello';

    insert to;
    
    PageControllerBase pcb = new PageControllerBase();
    pcb.myObject = to;      
    
    EnhancedTextController etch = new EnhancedTextController();
    etch.defaultValue = 'foo';
    etch.pageController = pcb;
    etch.fieldName = 'Text__c';
    etch.validateAs = 'name';
    etch.maxLength = '20';
    etch.hidden = true;
    etch.getOnLoad();
    System.assertEquals('Text1',(String) etch.getCastedValue());
    System.assertNotEquals(null, to.Text__c);
    
    
	EnhancedDatePickerController edpc = new EnhancedDatePickerController();
	edpc.pageController = pcb;	  	
	edpc.maxDate = '02/22/2011';
	edpc.minDate = '4/4/2009';
	edpc.fieldName = 'Date__c';
	edpc.getOnLoad();	  	
	Date d = (Date) edpc.getCastedValue();
	System.assertEquals(to.Date__c, d);
      
    edpc.myValueHolder = '01/02/2008';
    pcb.ecSave(); 
    System.assertEquals(Date.newInstance(2008,01,02), to.Date__c);
    System.assertNotEquals(null, to.Date__c);
    
    edpc.myValueHolder = '2009-01-02';
    pcb.ecSave(); 
    System.assertEquals(Date.newInstance(2009,01,02), to.Date__c);
    System.assertNotEquals(null, to.Date__c);
    
    
    EnhancedLookupController elc = new EnhancedLookupController();
    elc.objectToLookup = 'TestLookupObject__c'; 
    TestLookupObject__c tlo_toTest = new TestLookupObject__c();
    tlo_toTest.name = 'Test TLO';
    insert tlo_toTest;
    TestLookupObject__c tlo = [Select id from TestLookupObject__c where name = 'Test TLO' limit 1];
    
    elc.fieldName = 'Test_Lookup_Object__c';
    elc.pageController = pcb;
    elc.getOnLoad();
    elc.myValueHolder = tlo.id;
    pcb.ecSave();
    System.assertEquals(tlo.id, to.Test_Lookup_Object__c);
    System.assertNotEquals(null, tlo.id);

    EnhancedTextareaController etac = new EnhancedTextareaController();
    etac.width = '200';
    etac.height = '200';
    etac.expandable = 'true';
    etac.pageController = pcb;          
    etac.fieldName = 'Text_Area__c';
    etac.getOnLoad();
    System.assertEquals(to.Text_Area__c,(String) etac.getCastedValue());
    System.assertNotEquals(null, to.Text_Area__c);

    etac.myValueHolder = 'ffff';    
    pcb.ecSave();
    System.assertEquals('ffff',to.Text_Area__c);
    
    EnhancedTextController etc = new EnhancedTextController();
    etc.pageController = pcb;
    etc.fieldName = 'Text__c';
    etc.validateAs = 'name';
    etc.maxLength = '20';
    etc.getOnLoad();
    System.assertEquals(to.Text__c,(String) etc.getCastedValue());
    System.assertNotEquals(null, to.Text__c);

    etc.myValueHolder = 'googly';
    pcb.ecSave();
    System.assertEquals('googly', to.Text__c);
    
    EnhancedTextController etc2 = new EnhancedTextController();
    etc2.pageController = pcb;
    etc2.fieldName = 'Number__c';
    etc2.validateAs = 'number';
    etc2.getOnLoad();
    System.assertEquals(to.Number__c,(Double) etc2.getCastedValue());
    etc2.myValueHolder = '14';
    pcb.ecSave();
    System.assertEquals(14.0, to.Number__c);
    System.assertNotEquals(null, to.Number__c);

    EnhancedTextController etc3 = new EnhancedTextController();
    etc3.pageController = pcb;
    etc3.fieldName = 'Percent__c';
    etc3.validateAs = 'percent';
    etc3.getOnLoad();

    System.assertEquals(to.Percent__c,(Double) etc3.getCastedValue());
    
    etc3.myValueHolder = '10%';
    pcb.ecSave();
    System.assertEquals(10, to.Percent__c);
    System.assertNotEquals(null, to.Percent__c);


    EnhancedTextController etc4 = new EnhancedTextController();
    etc4.pageController = pcb;
    etc4.fieldName = 'Currency__c';
    etc4.validateAs = 'currency';
    etc4.getOnLoad();
    System.assertEquals(to.Currency__c,(Double) etc4.getCastedValue());
    System.assertNotEquals(null, to.Currency__c);
    
    etc4.myValueHolder = '10.01';
    pcb.ecSave();
    System.assertEquals(10.01, to.Currency__c);


    EnhancedCheckboxController ecc = new EnhancedCheckboxController();
    ecc.pageController = pcb;
    ecc.fieldName = 'Checkbox__c';
    ecc.defaultValue = 'checked';
    ecc.getOnLoad();
    System.assertEquals(true,(Boolean) ecc.getCastedValue());
    
    ecc.myValueHolder = true;
    pcb.ecSave();
    System.assertEquals(true, to.Checkbox__c);

    EnhancedMultiselectController empc = new EnhancedMultiselectController();
    empc.pageController = pcb;
    empc.fieldName = 'Picklist_Multi_Select__c';
    empc.myObject = pcb.myObject;
    empc.getOnLoad();
    System.assertEquals(to.Picklist_Multi_Select__c,(String) empc.getCastedValue());

    empc.myValueHolder = empc.getPicklistValues()[0].so.getValue();
    pcb.ecSave();
    System.assertEquals(empc.getPicklistValues()[0].so.getValue(), to.Picklist_Multi_Select__c);

    EnhancedSelectController esc = new EnhancedSelectController();
    esc.pageController = pcb;
    esc.fieldName = 'Picklist__c';
    esc.myObject = pcb.myObject;
    esc.getOnLoad();
    System.assertEquals(to.Picklist__c,(String) esc.getCastedValue());
    
    esc.myValueHolder = esc.getPicklistValues()[0].so.getValue();
    pcb.ecSave();
    System.assertEquals(esc.getPicklistValues()[0].so.getValue(), to.Picklist__c);

    EnhancedSelectController ensc = new EnhancedSelectController();
    ensc.isNumber = true;
    ensc.picklistEntries = '1,2,3';
    ensc.pageController = pcb;
    ensc.fieldName = 'Number__c';
    ensc.myObject = pcb.myObject;
    ensc.getOnLoad();
    ensc.myValueHolder = ensc.getPicklistValues()[2].so.getValue();
    pcb.ecSave();
    System.assertEquals(2, to.Number__c);


    //Sometimes breaks on install on client orgs (but not always)
    //System.assertEquals(false, ApexPages.hasMessages());
    
    EnhancedTextController etc5 = new EnhancedTextController();
    etc5.fieldName = 'myfakename';
    etc5.validateAs = 'url';
    etc5.getOnLoad();
    etc5.myValueHolder = 'www.fake.com';
    pcb.ecSave();


    
    EnhancedLookupController elc2 = new EnhancedLookupController();
    elc2.objectToLookup = 'TestLookupObject__c'; 
    TestLookupObject__c tlo_toTest2 = new TestLookupObject__c();
    tlo_toTest2.name = 'Test TLO2';
    insert tlo_toTest2;
    TestLookupObject__c tlo2 = [Select id from TestLookupObject__c where name = 'Test TLO2' limit 1];
    
    elc2.fieldName = 'Test_Lookup_Object__c';
    elc2.bigset = true;
    elc2.pageController = pcb;
    elc2.displayColumn = 'name';
    elc2.getOnLoad();
    ApexPages.currentPage().getParameters().put('term', 'Test TLO2');
    ApexPages.currentPage().getParameters().put('tlo', 'Test_Lookup_Object__c');
    elc2.doSearch();  
    System.assert(elc2.getResult().length() > 3);
    elc2.myValueHolder = tlo2.id;
    pcb.ecSave();
    System.assertEquals(tlo2.id, to.Test_Lookup_Object__c);
    


    System.assertEquals(13, pcb.getMyComponentControllers().size());
    System.assertNotEquals(null, pcb.getOnLoadJavascript());
    System.assertNotEquals(null, pcb.getJavascriptMethods());
    System.assertNotEquals(null, pcb.getCompleteJavascript());
    System.assertNotEquals(null, pcb.getJavascript());
    System.assertNotEquals(null, pcb.getJavascriptDependencies());

  }




}