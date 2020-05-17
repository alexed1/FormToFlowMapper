public with sharing class FormToFlowUtils {

    //convert the data structure returned by Einstein Form Reader to a simple map that can be converted to one of the custom data types that Flow understands
    public static Map<String, String>  ExtractKeyValuePairs(Map<String, Map<String, String>> extractedFormDataMap){
        
        
        Map<String, String> resultMap = new Map<String, String>();
        for (String key : extractedFormDataMap.keySet()) {
            //extract the value from the form data
            Map<String,String> valueMap = extractedFormDataMap.get(key);
            String value = valueMap.get('value'); 
            //set equivalent customobject field to the same value
            resultMap.put(key, value);
        }
   
        return resultMap;
    }
}
