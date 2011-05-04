public class JsonUtils {

    public static String JSENCODE(String s)
    {
        s = s.replaceAll('\'', '\\\'');
        return s;
    }   
  
    // see: http://community.salesforce.com/t5/Apex-Code-Development/Building-a-reusable-JSON-component/m-p/172428
    // and: http://joe-ferraro.com/2009/04/extjs-vf-json/
    
    public static String getJsonFromObject(String objectName, List<String> columns, String filterString)
     {
        if(filterString == null)
            filterString = '';
    
            String jsonData = '[ ';
            try {
                
                //System.debug('getJsonifiedObjectRecords for:' + objectName);
                  
                String queryString = 'Select id,';
                  
                for(String c: columns) 
                    queryString += c + ',';
                
                queryString = queryString.substring(0,queryString.length() - 1);
                queryString += ' from ' + objectName + ' ' + filterString;
                //queryString += ' limit 10000';
                
                System.debug('QUERYSTRING:' + queryString);
                //for List<sObject> sos = Database.query(queryString);
                //Map<String, Schema.SObjectField> columns = sos.getSObjectType().getDescribe().fields.getMap();
                           
                //jsonData += '[';    
                for (sObject so :  Database.query(queryString)) {  
                        jsonData += ' { ';
                          for(String column : columns)
                          {   
                                    //System.debug('jsonData:' + jsonData);
                                     try 
                                     {
                                        String cellval = '';
                                        List<String> cParts = column.split('[.]');    
                                        if(cParts.size() == 2)
                                        {
                                            String outerObjectName = cParts.get(0);
                                            //if(outerObjectName.endsWith('__r'))
                                            //  outerObjectName = outerObjectName.substring(0,outerObjectName.length() - 1) + 'c';
                                            cellval = (String) so.getSObject(cParts.get(0)).get(cParts.get(1));
                                        }
                                        else
                                        {
                                            cellVal = String.valueOf( so.get(column));
                                        }
                                        jsonData += '"'+column+'" : "'+String.escapeSingleQuotes(cellVal)+'",'; 
                                        
                                          
                                     }      
                                     catch(Exception ex) 
                                     {
                                        System.debug(ex);
                                     }
                         }
                         jsonData = jsonData.substring(0, jsonData.length() - 1);
                         jsonData = jsonData + '},';  
                         
                }
        
                jsonData = jsonData.subString(0,jsonData.length() - 1);
                
            }
            catch(Exception e)
            {   
                System.debug('Bad query in Jsonify Call ' + e);         
            }

        jsonData += ']';
        
        //System.debug('jsonData:' + jsonData);

        return jsonData;
   }
        
        
   public static String jsonify(List<String> records)
        {
            String json = '[ ';
            for(String r : records) {
                r = r.trim();
                json += '\'' + r + '\',';
            }
            
            json = json.substring(0,json.length() - 1);
            json += ']';
            return json;
        }

   public static String jsonify(List<JsonObject> records)
        {
            String json = '[ ';
            for(JsonObject r : records) {
                //r = r.ValuetoString().trim();  
                json += '' + r.ValuetoString() + ',';  
            }
            
            json = json.substring(0,json.length() - 1);
            json += ']';
            return json;
        }



}