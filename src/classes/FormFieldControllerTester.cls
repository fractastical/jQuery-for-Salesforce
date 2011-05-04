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

global class FormFieldControllerTester {
    
    public Form_Field__c field { get; set; }
    public String order         { get; set; }  
    public List<SelectOption> picklistSelectOptions;
    //workaround for bug #W-638516
    public PageReference pagetemplatename {get;set;}
    public PageControllerBaseTester pageController { get; set; }  


    public Boolean useEnhancedDatepicker { get; set; }
    public Boolean useEnhancedPicklist { get; set; }
    public Boolean useEnhancedMultiselect { get; set; }
    public Boolean useEnhancedText { get; set; }
    public Boolean useEnhancedLookup { get; set; }
    public Boolean useEnhancedTextarea { get; set; }
    
    
    //CONSTRUCTOR
    public FormFieldControllerTester() {
        //workaround for bug #W-638516  
       // pagetemplatename = new PageReference('/apex/'+System.currentPageReference().getParameters().get('pagetemplatename'));
    }

    public List<SelectOption> getPicklistSelectOptions() {
        //if this is a picklist field, set up the selectoptions for the drop down that needs to be rendered
        if (field != null) {
        
            if(field.Type__c == 'Picklist'  || field.Type__c == 'Multi-Select')
              {   
                  if( field.PicklistEntries__c != null) {
        
                        PicklistSelectOptions = new List<SelectOption>();
                        SelectOption so;
                        if (field.Type__c == 'Picklist') {
                             so = new SelectOption('','--Select--');  
                             PicklistSelectOptions.add(so);  
                        }
                                
                        String[] values = field.PicklistEntries__c.split(',' , 0);
                        for(String s:values) {
                            so = new SelectOption(s,s);
                            PicklistSelectOptions.add(so);
                        }
                }
            }
            return PicklistSelectOptions;
        }
        return null;
    }

    
    

}