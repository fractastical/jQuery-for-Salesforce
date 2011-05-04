// Wrapper class for Field_Show_Rule__c for conditional field display 

public class ShowRule {

  		public List<String> valuesToShow 	{ get; set; }
  		public String firstValueToShow 		{ get; set; }
  		public String groupName 			{ get; set; }
  		public Boolean hasValue				{ get; set; }
  		public String operator 				{ get; set; }//Added by Vilpesh 10012010
  		
  		public ShowRule(Field_Show_Rule__c showRule) {
  			System.debug('*****Current showRule : ' + showRule.id + ' name : ' + showRule.name + ' Value_show : ' + showRule.value_to_show__c + ' Operator : ' + showRule.Operator__c);//Added Operator__c by Vilpesh 10012010
  			valuesToShow = new List<String>();
  			hasValue = true;
  			
			if(showRule.Value_to_Show__c != null && showRule.Value_to_Show__c != '')
	  			valuesToShow = showRule.Value_to_Show__c.split(',');
	  		else
	  			hasValue = false;
	  			
	  		if (valuesToShow.size() > 0)
      			firstValueToShow = valuesToShow.remove(0);
	  		
	  		operator = showRule.Operator__c;//Added by Vilpesh 10012010
 
  			groupName = showRule.name;
  			System.debug('*****Current 1stValuShow : ' + firstValueToShow + ' total size--valuesToShow : '+valuesToShow + ' groupName : ' + groupName);
  		}
	
	
}