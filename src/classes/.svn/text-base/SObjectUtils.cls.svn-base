public with sharing class SObjectUtils {

	//Does not support fields with multiple reference object types
	
    public SObject deepClone(SObject so) {
    	    	
    	SObject newSO = so.clone(false,true);
    	
    	//TODO: Find Child objects. List. 
    	
   		Schema.DescribeSObjectResult R  = so.getSObjectType().getDescribe();   
    	List<Schema.ChildRelationship> CR = R.getChildRelationships();
    	for (Schema.ChildRelationship c : CR) {
    		String relName = c.getRelationshipName();
    		String value = (String) so.get(relName);
    		String childObjectName = c.getChildSObject().getDescribe().getName();
    		//Campaign 
    		String queryString = 'select id from ' + childObjectName + ' where id=\'' + value + '\' limit 1';
    		SObject child = Database.query(queryString);       
    		deepClone(child);
    	}
    		
    	
		SObjectType sot = so.getSObjectType();   
    	Map<String, SObjectField> fields = sot.getDescribe().fields.getMap();
    	
    	List<SObjectField> fieldtokens = fields.values();
    	
		        for(SObjectField fieldtoken:fieldtokens) {
		        	
		            DescribeFieldResult dfr = fieldtoken.getDescribe();
					       
					if(dfr.isNameField())     
						newSO.put(dfr.getName(), so.get(dfr.getName()) + '_copy');
					
					System.debug('rn:' + dfr.getRelationshipName() + 'ro:' + dfr.getRelationshipOrder());
					
					// Has a relationship and is not a child in that relationship
					if(dfr.getRelationshipName() != null && dfr.isCreateable()) //dfr.getRelationshipOrder() != null && dfr.getRelationshipOrder() != 1)
					{  
						String relName = dfr.getRelationshipName();
						System.debug(relName);  
						
						if (relName.substring(relName.length() - 3, relName.length()) == '__r')
							relName = relName.substring(0,relName.length()-1) + 'c';
							
						//if(globalDesc == null)
						//	globalDesc = Schema.getGlobalDescribe();
						
						//SObjectType innerSot = gd.get(relName);
						System.debug('select id from ' + relName + ' where id = \'' + dfr.getReferenceTo() + '\'');
						SObject innerObject = Database.query('select id from ' + relName + ' where id = \'' + dfr.getReferenceTo() + '\'');
						deepClone(innerObject);
					}

					//	getReferenceTo  
					//  getRelationshipName  // Sobject name
					//  
					//  getRelationshipOrder // 1 if child  
					//	newSO.put(dfr.getName(), so.get(dfr.getName()) + ' copy');
						
		        }

    	upsert newSO;
    	
    	return newSo;
    	
    }
    
    public String hello(){
    	return '';
    }
    
    
    
public static testMethod void t1() {
    
    
    TestLookupObject__c tlo = new TestLookupObject__c();
    tlo.name = 'tlo';
    insert tlo;
    
    TestObject__c to = new TestObject__c();    
    to.Test_Lookup_Object__c = tlo.id;
    to.name ='to';
    insert to;
    
    Test.startTest();
    
    User u = TestUtility.createTestUser([select id, name from Profile where name='System Administrator' limit 1]);
    
    System.runAs(u) {
    
    
	    TestObject__c to2 = to.clone(false, true);
	    upsert to2;
	    SObject so2 = (SObject) to;
	    SObject so3	= so2.clone(false, true);
	    upsert so3;
      
        //hello();  createTestUser
        SObjectUtils sou = new SObjectUtils();
	    SObject newSo = sou.deepClone((SObject) to);  
	      
	    System.assertEquals('to_copy',newSo.get('name'));
	    String nsoid = (String) newSo.get('Test_Lookup_Object__c');
	    TestLookupObject__c tloc = [select id, name from TestLookupObject__c where id =: nsoid limit 1]; 
	    System.assertEquals('tlo_copy', tloc.name);
    
    }
      
    Test.stopTest();

    }


    
public static testMethod void t2() {
    
    
    Campaign c = new Campaign();  
    c.name = 'c';
    insert c;
    
    Contact co = new Contact();
    co.FirstName = 'Joe';
    co.LastNAme = 'User';
    insert co;
    
    CampaignMember cm = new CampaignMember();    
    cm.CampaignId = c.id;
    cm.ContactId = co.id;
    insert cm;
    
    Test.startTest();
    
    User u = TestUtility.createTestUser([select id, name from Profile where name='System Administrator' limit 1]);
    
    System.runAs(u) {
    
    /*
	    Campaign c2 = c.clone(false, true);
	    upsert c2;
	    SObject so2 = (SObject) to;
	    SObject so3	= so2.clone(false, true);
	    upsert so3;*/
      
        //hello();  createTestUser
        SObjectUtils sou = new SObjectUtils();
	    SObject newSo = sou.deepClone((SObject) c);  
	      
	    System.assertEquals('c_copy',newSo.get('name'));
	    String nsoid = (String) newSo.get('Id');
	    CampaignMember cm2 = [select id, ContactId from CampaignMember where CampaignId =: nsoid limit 1]; 
	    
	   	System.assertEquals(co.id, cm2.ContactId);            
    
    }
      
    Test.stopTest();

    }



}