// (c) 2009, David Van Puyvelde, Sales Engineering, Salesforce.com Inc.
// Mod JDietz@gmail.com / d3developer.com / @fractastical.
// Rest of copyright notice moved to bottom 
   
public class WebFormUtils {
     
     public SObject getFormFieldValue(Form_Field__c f)  
     {
     	return null;
     }
     
     public static String getDisplayTypeFromSchemaType(String schemaType)
     {
     	
     	if(schemaType == 'EMAIL') return 'Email';
		if(schemaType == 'URL') return 'URL';
		if(schemaType == 'BOOLEAN') return 'Checkbox';
		if(schemaType == 'DATE') return 'Date';
		if(schemaType == 'DATETIME') return 'Datetime';
		if(schemaType == 'CURRENCY') return 'Currency';
		if(schemaType == 'STRING') return 'Text';
		if(schemaType == 'DOUBLE') return 'Number';		
		if(schemaType == 'PERCENT') return 'Percent';
		if(schemaType == 'TEXTAREA') return 'Textarea';
		if(schemaType == 'PHONE') return 'Phone';
		if(schemaType == 'PICKLIST') return 'Picklist';
		if(schemaType == 'MULTIPICKLIST') return 'Multi-Select';
		if(schemaType == 'REFERENCE') return 'Lookup';    
     	
     	return null;	  
     }
     
	//method that will sort a formfield list by field label
	public static List<Form_Field__c> sortByLabel(List<Form_Field__c> origlist) {
		//create a Map with label as key and the formfields as value
		//create a List with just the keys to sort it
		Map<String, Form_Field__c> ffmap = new Map<String, Form_Field__c>();
		List<String> tosort = new List<String>();
		for(Form_Field__c ff:origlist) {
			ffmap.put(ff.Label__c, ff);
			tosort.add(ff.Label__c);
		}
		//now sort the list with the key values of the map
		tosort.sort();		
		//create a new list and fill it with by getting the keys from the sorted list and getting the objectss from the Map
		List<Form_Field__c> sortedlist = new List<Form_Field__c>();
		for(String s:tosort) {
			sortedlist.add(ffmap.get(s));
		}	
		return sortedlist;
	}
	
	//jdietz@gmail.com
	public static String getJQueryValidation(Form_Field__c formField)	{
		           
		  Boolean required = formField.required__c;
		  String objectType = formField.type__c;
		  Boolean valRuleAdded = false;
		           
 		  String validationString = '';
          
         if(objectType == 'Date')    
          {
          	validationString += 'date:true';
          	valRuleAdded = true;
          }
          if (objectType == 'Lookup') 
          {
          	validationString += 'phone: false';
          	valRuleAdded = true;
          }   
          
          if (objectType == 'URL') 
          {
          	validationString += 'url: true, maxlength: 255';
          	valRuleAdded = true;
          }   
          else if (objectType == 'Number') 
          {
          	validationString += 'digits: true';
          	valRuleAdded = true;
          }   
          else if (objectType == 'Email') 
          {
          	validationString += 'email: true';
          	valRuleAdded = true;
          }   
          else if (objectType == 'Phone') 
          {
          	validationString += 'internationalPhone: true';
          	//validationString += 'phone: false';
          	valRuleAdded = true;
          }
          else if (objectType == 'Textarea') 
          {
          	//validationString += 'phone: false';
          	validationString += 'maxlength: 32000';
          	valRuleAdded = true;          	
          }
           else if (objectType == 'Text' && formField.max_length__c == null) 
          {
          	validationString += 'maxlength: 255';
          	valRuleAdded = true;
          }
             
             
           if(required) {
           		if(valRuleAdded)
           			validationString += ', required: true';
           		else
           			validationString += 'required: true';  
           }
                        
           if(formField.max_length__c != null) {
           		if(valRuleAdded)
           			validationString += ', ';
           		else
           		  valRuleAdded = true;
           		validationString += 'maxlength: ' + formField.max_length__c; 
           }

			/*
           if(formField.type__c == 'NAME') {
           		if(valRuleAdded)
           			validationString += ', ';
           		else
           		  valRuleAdded = true;
           		  
           		validationString += 'allCapsDisallowed: true;';
           		validationString += 'allLowercaseDisallowed: true;';
           		validationString += 'ASCIIOnly: true';
           		
           }*/
           
           return validationString;
		
	}
	
	
	//method that will sort a formfield list by Order field
	public static List<Form_Field__c> sortByOrder(List<Form_Field__c> origlist) {
		//create a Map with order as key and the formfields as value
		//create a List with just the keys to sort it
		Map<Double, Form_Field__c> ffmap = new Map<Double, Form_Field__c>();
		List<Double> tosort = new List<Double>();
		for(Form_Field__c ff:origlist) {
			ffmap.put(ff.Order__c, ff);
			tosort.add(ff.Order__c);
			System.debug('o:' + ff.Order__c);  
		}
		//now sort the list with the key values of the map
		tosort.sort();		
		//create a new list and fill it with by getting the keys from the sorted list and getting the objectss from the Map
		List<Form_Field__c> sortedlist = new List<Form_Field__c>();
		for(Double d:tosort) {
			sortedlist.add(ffmap.get(d));
		}	
		return sortedlist;
	}
	
	
	
	
	//TEST METHODS
	
	public testMethod static void t1() {
		//test the getValue method
		
		/*
		Form_Field__c f1 = new Form_Field__c(Type__c = 'STRING', Name = 'Text__c', Text_Value__c='text', Label__c = 'lbl1', Order__c = 1);
		Form_Field__c f2 = new Form_Field__c(Type__c = 'EMAIL', Name = 'Email__c', Email_Value__c = 'mail@a.com', Label__c = 'lbl2', Order__c = 2);
		Form_Field__c f3 = new Form_Field__c(Type__c = 'URL', Name = 'URL__c', URL_Value__c='http://www.url.com', Label__c = 'lbl3', Order__c = 3);
		Form_Field__c f4 = new Form_Field__c(Type__c = 'BOOLEAN', Name = 'Checkbox__c', Boolean_Value__c = true, Label__c = 'lbl4', Order__c = 4);
		Form_Field__c f5 = new Form_Field__c(Type__c = 'DATE', Name = 'Date__c', Date_Value__c = System.today(), Label__c = 'lbl');
		Form_Field__c f6 = new Form_Field__c(Type__c = 'DATETIME', Name = 'DateTime__c', DateTime_Value__c = System.now(), Label__c = 'lbl');
		Form_Field__c f7 = new Form_Field__c(Type__c = 'CURRENCY', Name = 'Currency__c', Currency_Value__c = 100, Label__c = 'lbl');
		Form_Field__c f8 = new Form_Field__c(Type__c = 'DOUBLE', Name = 'Number__c', Number_Value__c = 100, Label__c = 'lbl');
		Form_Field__c f9 = new Form_Field__c(Type__c = 'PERCENT', Name = 'Percent__c', Percent_Value__c = 100, Label__c = 'lbl');
		Form_Field__c f10 = new Form_Field__c(Type__c = 'TEXTAREA', Name = 'Text_Area__c', Text_Area_Value__c = 'text', Label__c = 'lbl');
		Form_Field__c f11 = new Form_Field__c(Type__c = 'PHONE', Name = 'Phone__c', Phone_Value__c = '1234567', Label__c = 'lbl');
		Form_Field__c f12 = new Form_Field__c(Type__c = 'PICKLIST', Name = 'Picklist__c', Picklist_Value__c = 'A', Label__c = 'lbl');
		Form_Field__c f13 = new Form_Field__c(Type__c = 'REFERENCE', Name = 'Reference__c', Text_Value__c = 'reference', Label__c = 'lbl');
		Form_Field__c f14 = new Form_Field__c(Type__c = 'NONEXISTANT', Name = 'Reference__c', Text_Value__c = 'reference', Label__c = 'lbl');
		Form_Field__c f15 = new Form_Field__c(Type__c = 'MULTIPICKLIST', Name = 'MultiPicklist_Value__c', Picklist_Value__c = 'B', Label__c = 'lbl');
		
		
		getFormFieldValue(f1);
		getFormFieldValue(f2);
		getFormFieldValue(f3);
		getFormFieldValue(f4);
		getFormFieldValue(f5);
		getFormFieldValue(f6);
		getFormFieldValue(f7);
		getFormFieldValue(f8);
		getFormFieldValue(f9);
		getFormFieldValue(f10);
		getFormFieldValue(f11);
		getFormFieldValue(f12);
		getFormFieldValue(f13);
		getFormFieldValue(f14);
		getFormFieldValue(f15);

		List<Form_Field__c> lista = new List<Form_Field__c>();
		lista.add(f4);
		lista.add(f2);
		lista.add(f1);
		lista.add(f3);
		//first by label
		List<Form_Field__c> sortedlist = sortByLabel(lista);
		Form_Field__c ff1 = sortedlist.get(0);
		System.assertEquals('lbl1', ff1.Label__c);
		//again, wrong order
		lista = new List<Form_Field__c>();
		lista.add(f4);
		lista.add(f2);
		lista.add(f1);
		lista.add(f3);
		
		sortedlist = sortByOrder(lista);
		ff1 = sortedlist.get(0);
		System.assertEquals(1, ff1.Order__c);
		
		//test the setvalue methods
		setFormFieldValue(f1, 'v'); System.assertEquals(getFormFieldValue(f1),'v');
		setFormFieldValue(f2, 'v'); System.assertEquals(getFormFieldValue(f2),'v');
		setFormFieldValue(f3, 'v'); System.assertEquals(getFormFieldValue(f3),'v');
		setFormFieldValue(f7, '100'); System.assertEquals(getFormFieldValue(f7),100);
		setFormFieldValue(f8, '200'); System.assertEquals(getFormFieldValue(f8),200);
		setFormFieldValue(f9, '10'); System.assertEquals(getFormFieldValue(f9),10);
		setFormFieldValue(f10, 'v'); System.assertEquals(getFormFieldValue(f10),'v');
		setFormFieldValue(f11, '123'); System.assertEquals(getFormFieldValue(f11),'123');
		setFormFieldValue(f12, 'v'); System.assertEquals(getFormFieldValue(f12),'v');
		setFormFieldValue(f13, 'ref'); System.assertEquals(getFormFieldValue(f13),'ref');
		setFormFieldValue(f15, 'c'); System.assertEquals(getFormFieldValue(f15),'c');
		*/ 
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
//  INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRA NTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
//  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
//  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
//  EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.