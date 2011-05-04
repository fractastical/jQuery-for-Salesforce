public with sharing class FormAdminController {

    public fieldGroup currGroup                     { get; set; }
    public List<fieldGroup> groups                  { get; set; }
    public Form__c webform                          { get; set; }  
    public List<Form_Field__c> formFields           { get; set; }
    public List<Form_Field__c> allFormFields        { get; set; }
    public List<Form_Field__c> removedFields        { get; set; }

    public List<SelectOption> formFieldNames        { get; set; }
    public List<SelectOption> activeShowFieldPicklistSO { get; set; }

    public String val                               { get; set; }
    public String groupName                         { get; set; }
    public String showFieldName                     { get; set; }
    public String activeShowFieldType               { get; set; }
    public String fieldName                         { get; set; }
    public Boolean displayPopup                     { get; set; }
    public Boolean displayAddValPopup               { get; set; }
    public Form_Field__c activeFormField            { get; set; }
    
	
    public FormAdminController(ApexPages.StandardController stdController) {
        init();
    }

    public FormAdminController() {
        init();
    }
    
    public void init() {  
    	
        displayAddValPopup = false;
        displayPopup = false;
        allFormFields = new List<Form_Field__c>();
        formFields = new List<Form_Field__c>();   
        removedFields = new List<Form_Field__c>();     
        String webformid = System.currentPageReference().getParameters().get('id');
        currGroup = new fieldGroup();
        groups = new List<fieldGroup>();
        
        if(webformid != null) {      
            formFields = [Select f.id, f.Form__c, f.Type__c, f.Order__c, 
                                 f.Name, f.Label__c, f.Hidden__c, 
                                 f.Group__c, f.PicklistEntries__c
                                 from Form_Field__c f where f.Form__c = :webformid 
                                 and f.Hidden__c != true order by f.Order__c];    
           
           
           formFieldNames = new List<SelectOption>();
           formFieldNames.add(new SelectOption('','--SELECT--'));
            
           List<Integer> indexesToRemove = new List<Integer>();
           
           for(Integer i = 0; i < formFields.size();i++) {  
            
                allFormFields.add(formFields.get(i));
                System.debug('i:' + i + ' size:' + formFields.size());
                System.debug('name:' + formfields.get(i).name + ' type:' + formfields.get(i).Type__c + ' Label:' + formfields.get(i).Label__c);
                
                if(formfields.get(i).Type__c != 'Header' && formfields.get(i).Type__c != 'Info' && formFields.get(i).Label__c != null)
                        formFieldNames.add(new SelectOption(formFields.get(i).name, formFields.get(i).Label__c));
                if(formfields.get(i).Type__c != 'Header' && formfields.get(i).Type__c != 'Info' && formFields.get(i).Label__c == null)
                        formFieldNames.add(new SelectOption(formFields.get(i).name, formFields.get(i).name));
                          
                
                if(formFields.get(i).Group__c != null && formFields.get(i).Group__c != '')
                {

                    Boolean addedToExistingGroup = false;                   
                    for(fieldGroup g : groups) {     
                        
                        System.debug(formFields.get(i).Name + 'gn: ' + g.groupName);
                        
                        if(formFields.get(i).Group__c == g.groupName)
                        {
                        	System.debug('MATCH');
                            g.fields.add(formFields.get(i));
                            addedToExistingGroup = true;
                            break;
                        }
                    }
                      
                    if(addedToExistingGroup == false)
                    {
                        groups.add(new fieldGroup(formFields.get(i).Group__c));
                        groups.get(groups.size() - 1).fields.add(formFields.get(i));
                    }
                
                	indexesToRemove.add(i);
                	
                }
                
            }    
            for(Integer i = indexesToRemove.size()-1; i >= 0; i--)
                formfields.remove(indexesToRemove[i]);
                
            for(fieldGroup g : groups)  
            {
                List<Field_Show_Rule__c> sr = [select name, Form_Field__c, Form_Field__r.name, Form_Field__r.Type__c, Form_Field__r.PicklistEntries__c, Value_to_show__c, Operator__c from Field_Show_Rule__c where name =: g.groupName and Form_Field__r.Form__c =: webformid limit 1];//Vilpesh 09292010 added Operator__c
                if(sr.size() == 1)
                {
                    if(sr.get(0).value_to_show__c != null && sr.get(0).value_to_show__c != '')
                        g.showVals = sr.get(0).value_to_show__c.split(',');
                        
                    g.showRule = sr.get(0);
                    g.showFieldName = sr.get(0).Form_Field__r.name;
                    g.showFieldType = sr.get(0).Form_Field__r.Type__c;
                    g.showRule.Operator__c =   sr.get(0).Operator__c; //Added by Vilpesh on 09302010
  
                }   
            }
        }
    }
    
    //Added by Vilpesh 09272010
    public List<SelectOption> getOperatorNames() {
        List<SelectOption> operatorNames = new List<SelectOption>();
        operatorNames.add(new SelectOption('Equals','Equals'));
        operatorNames.add(new SelectOption('Not Equals','Not Equals'));
        return operatorNames;
    }
      
    
    public PageReference enablePopup() {
        displayPopup = true;
        return null;
    }

    public PageReference disablePopup() {
        displayPopup = false;
        return null;
    }

    public PageReference enableAddValPopup() {
        displayAddValPopup = true;
        System.debug('activeShowFieldType:' + activeShowFieldType);
        System.debug('groupname:' + groupname);

        if(activeShowFieldType == 'NumberPicklist' || activeShowFieldType == 'Picklist')    
        {   

           for(fieldGroup g : groups) {
                            
                if(groupName == g.groupName)
                {
                    activeShowFieldPicklistSO = g.getShowFieldPicklistSO();    
                    System.debug('GROUP MATCH');
                    break;  
                }
            }
             
        }   
        return null;
    }

    public PageReference disableAddValPopup() {
        displayAddValPopup = false;
        return null;
    }

    public List<SelectOption> getGroupsSO() {
        
        List<SelectOption> so = new List<SelectOption>();
        so.add(new SelectOption('','--SELECT--'));
        for(fieldGroup g : groups)
            so.add(new SelectOption(g.groupName,g.groupName));
        return so;
    }
    
    public Boolean getHasGroups() {
        
        return (groups != null && groups.size() > 0); 
    }
    
    public PageReference addGroup() {
        groups.add(currGroup);
        currGroup = new fieldGroup();
        return null;
    }
    
    public PageReference addFieldToGroup() {

        System.debug('fieldname:' + fieldname);
        System.debug('groupname:' + groupname);

       Form_Field__c formFieldtoAdd;
       Boolean found = false;
       for(Integer i = 0; i < formFields.size(); i++)
       {        
            System.debug('fieldname:' + fieldname);
            System.debug('formFields.get(i).name:' + formFields.get(i).name);
            
            if(formFields.get(i).name == fieldname)
            {   
                formFieldtoAdd = formFields.get(i);
                formFields.remove(i);
                found = true;
                
                System.debug('MATCH!');
                break;
            }
       }       
    
       for(fieldGroup g : groups) {

            System.debug('groupname:' + groupname);
            System.debug('g.groupname:' + g.groupname);
                        
            if(groupName == g.groupName)
            {
                g.fields.add(formFieldtoAdd);
                System.debug('GROUP MATCH');
                
                break;  
            }
        }

        displayPopup = false;
        return null;

    }
    
    public PageReference removeFieldFromGroup() {
       
       for(fieldGroup g : groups) {
            for(Integer i=0;i < g.fields.size();i++)
            {           
                if(g.fields[i].name == fieldName)
                    {
                        Form_Field__c f = g.fields.get(i);
                        removedFields.add(g.fields.get(i));
                        removedFields.get(removedFields.size() - 1).Group__c = null;
                        g.fields.remove(i);  
                        formFields.add(f);
                       return null;
                    }
                    
            }
        }

        return null;
    }

    public PageReference saveShowField() {

       if(groupname==null) groupname = ApexPages.CurrentPage().getParameters().get('mygroupname');
       System.debug('groupname:' + groupname);
       
       Form_Field__c showField;
       Boolean found = false;
       String showFieldName;
       
      for(fieldGroup g : groups) {

            System.debug('g.groupname:' + g.groupname);
                        
            if(groupName == g.groupName)
            {
                showFieldName = g.ShowFieldName;
                System.debug('FOUND SHOWNAME');
                break;  
            }
        }
        
        System.debug('showfieldname:' + showFieldName);
        System.debug('allformfieldsize:' + allFormFields.size());
       
       for(Integer i = 0; i < allFormFields.size(); i++)
       {        
            System.debug('showFieldname:' + showFieldName);
            System.debug('allFormFields.get(i).name:' + allFormFields.get(i).name);
            if(allFormFields.get(i).name == showFieldName)
            {   
                showField = allFormFields.get(i);
                System.debug('MATCH SHOW FIELD!');  
                break;
            }
       }       
        for(fieldGroup g : groups) {
    
                System.debug('groupname:' + groupname);
                System.debug('g.groupname:' + g.groupname);
                            
                if(groupName == g.groupName)
                {
                    g.showFieldPicklistEntries = showField.PicklistEntries__c;
                    g.showFieldId = showField.Id;
                    g.showFieldType = showField.Type__c;
                    System.debug('GROUP MATCH');
                    break;  
                }
        }  

        return null;

    }
    

    public PageReference removeVal() {

       for(fieldGroup g : groups) {
                        
            if(groupName == g.groupName)
            {
                for(Integer i=0;i < g.showVals.size(); i++)
                {
                    if(val == g.showVals[i])
                    {
                        g.showVals.remove(i);
                        return null;    
                    }

                }
            }
        }
        
        return null;
        
    }


    public PageReference addVal() {
    
       displayAddValPopup = false;
       System.debug('groupname:' + groupname);
       System.debug('val:' + val);
         
       for(fieldGroup g : groups) {
                        
            if(groupName == g.groupName)
            {
                g.showVals.add(val);
                val = '';
                return null;
            }
        }
        return null;
    }


    public PageReference save() {
        List<Form_Field__c> fieldsToSave = new List<Form_Field__c>();
        List<Field_Show_Rule__c> showRulesToSave = new List<Field_Show_Rule__c>();
        
        for(fieldGroup g : groups) {
            //System.debug('SHOWFIELD:' + g.showField);
            
            System.debug('------Group :' + g.groupName);//Vilpesh 09302010
            if(null != g.fields) System.debug('------Total Fields :' + g.fields.size());//Vilpesh 09302010
            
            for(Form_Field__c f : g.fields) {
                f.Group__c = g.groupName;
                fieldsToSave.add(f);
            }  
            if (g.showFieldname != null) {
                g.ShowRule.name = g.groupName.replaceAll(' ','');
                
                System.debug('------ShowRuleName :' + g.ShowRule.name);//Vilpesh 09302010
                
                if ((g.showRule.Form_Field__c == null ) || (((String) g.showRule.Form_Field__c) == ''))
                    g.showRule.Form_Field__c = g.showFieldId;               

                //crazy work around for bug when assigning string  

                if(g.showVals.size() > 0) {
                	System.debug('------Total Show Values :' + g.showVals.size());//Vilpesh 09302010
                    g.showRule.Value_To_Show__c = g.showVals.get(0) + ',';
                                         
                    for(Integer i = 1; i < g.showVals.size(); i++)
                        g.showRule.Value_To_Show__c += g.showVals.get(i) + ',';
                    
                    if(g.showRule.Value_To_Show__c.length() > 0)
                        g.showRule.Value_To_Show__c = g.showRule.Value_To_Show__c.substring(0, g.showRule.Value_To_Show__c.length()-1);
                        
                    System.debug('------Value(s) assigned :' + g.showRule.Value_To_Show__c);//Vilpesh 09302010
                    System.debug('------Operator :' + g.ShowRule.Operator__c);//Vilpesh 09302010
                    
                }
                
                if (g.showRule.Form_Field__c != null && g.showRule.Value_To_Show__c != null)
                    showRulesToSave.add(g.ShowRule);
            }
                
        }
        
        update fieldsToSave;
        upsert showRulesToSave;
        update removedFields; 
        
        return null;
    }

    public class fieldGroup {
        public String groupName { get; set; }
        public String showFieldName { get; set; }
        public String showFieldId { get; set; }
        public String showFieldType { get; set; }
        public String showFieldPicklistEntries { get; set; }
        public Field_Show_Rule__c showRule { get; set; }
        public List<String> showVals { get; set; }
        public List<Form_Field__c> fields { get; set; } 
                
        public fieldGroup() {
            fields = new List<Form_Field__c>();
            showVals = new List<String>();
            //showVals.add('value');
            showRule = new Field_Show_Rule__c();
        }

        public fieldGroup(String name) {
            groupName = name;
            fields = new List<Form_Field__c>();
            showVals = new List<String>();
            //showVals.add('value');  
            showRule = new Field_Show_Rule__c();
        }

    	public List<SelectOption> getShowFieldPicklistSO() {
	        List<SelectOption> picklistSO = new List<SelectOption>();
	        SelectOption so;
	        List<String> values = new List<String>();
	        if(showFieldPicklistEntries != null) 
	            values = showFieldPicklistEntries.split(',', 0);
	        for(String s:values) {
	            so = new SelectOption(s,s);  
	            picklistSO.add(so);
	        }
	        return picklistSO;  
    	}
    }


}