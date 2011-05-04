public with sharing class EnhancedMultiselectController extends EnhancedComponentController{
    
    public String picklistEntries   { get; set; }
    List<PicklistVal> picklistVals;    
    public List<SelectOption> picklistSO { get; set; }
    String[] currVals = new List<String>();
    
    // because there is no true onload allowed for components
    // and the constructor is run before the setters on attributes
    public String getOnLoad() {

		//We overwrite the passed value since it means nothing for the Multiselect to be required (we treat it the same way as the checkbox)
        required = false;

        onLoad();  
        
        
        String currVal = (String) myValueHolder;        
        if(currVal != null)
            currVals = currVal.split(';', 0);                   
              
        String updateHiddenField = '' + 
        '          function updateMS' + fieldName + '() { \n' + 
        '                $("#S' + fieldName + ' :hidden:input:first").val(""); \n' + 
        '                $("input[name=\'MS' + fieldName + '\']:checked")' +
                              '.each(function(k,l) {\n' +
        '                          var checkedVal = $(this).val();\n' + 
        '                          var currValue = $("#S' + fieldName + ' :hidden:input:first").val();\n' +
        '                          $("#S' + fieldName + ' :hidden:input:first").val(currValue + checkedVal + ";");\n' +
        '                      } );\n' +
        '                  } \n';
                        
        String initialize = '' +
        //  	 A bit buggy when rerenders but unable to fix (as of yet)
        //'      $('.ui-multiselect-checkboxes > li > label > a > input').each(function() { appendTo($(this).parent.parent()); } );
        //		find('a span div').remove()\n' +      
        //'      $('.ui-multiselect-checkboxes > li > label').find('a span div').remove()\n' +      
        //'       $(".ui-multiselect-options").empty().remove();\n' +      
         
        '       $("[name=\'MS' + fieldName + '\'].ui-multiselect").remove();\n' +
        '       $("[name=\'MS' + fieldName + '\']").multiSelect({\n' +
        '         onCheck: function(){\n' + 
        '           updateMS' + fieldName + '();\n' +
        '          },\n' + 
        '         onUncheckAll: function(){\n' + 
        '             $("#S' + fieldName + ' :hidden:input:first").val(""); \n' + 
        '         },\n' + 
        '         onCheckAll: function(){\n' + 
        '            updateMS' + fieldName + '();\n' +
        '            }\n' +     
        '         });\n';
            
        initializePicklistVals();
        pageController.addJavascriptMethods(updateHiddenField);
        addOnLoadJavascriptToParentController(initialize);
        return '';
    }
    
    public void initializePicklistVals()
    {
    	        System.debug('GETPICKLISTVAL');
        if(picklistSO == null && picklistEntries == null && myObject != null)  
        {
            System.debug('GRABBING');
            Schema.sObjectType t = myObject.getSObjectType();
            
            Schema.DescribeSObjectResult objDesc = t.getDescribe();
            Map<String, Schema.SObjectField> fieldsMap = objDesc.fields.getMap();
            System.debug('fieldsMap:' + fieldsMap.size());
            System.debug('fieldName:' + fieldName);
            List<Schema.PicklistEntry> pickListValues = fieldsMap.get(fieldName).getDescribe().getPickListValues();
            picklistSO = new List<SelectOption>();
            for(Schema.PicklistEntry pe : pickListValues)
                picklistSO.add(new SelectOption(pe.getValue(), pe.getLabel()));
        }
        else if (picklistSO == null && picklistEntries != null)
        {
                 System.debug('USING PASSED');
                picklistSO = new List<SelectOption>();
                SelectOption so;
                picklistEntries = picklistEntries.replace('\\,','--COMMA--');
                String[] values = picklistEntries.split(',' , 0);
                for(String s:values) {
                	s = s.replaceAll('--COMMA--',',');
                    so = new SelectOption(s,s);
                    picklistSO.add(so);  
                }
            
        } 
        else if (picklistSO == null)
            picklistSO = new List<SelectOption>();
       

            
        picklistVals = new List<PicklistVal>();
        for(SelectOption so : picklistSO)
            picklistVals.add(new PicklistVal(so, currVals));
	        
    	
    }
      public List<PicklistVal> getPickListValues() {    
        return picklistVals;
          
    }
    
    	
    
	

}