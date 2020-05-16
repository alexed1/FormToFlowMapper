public with sharing  class FormToFlow_MapCreateContact {
 
    @InvocableMethod(label='BaseMapperDoNotUseDirectly' )
    public static List <Result> process(List<Request> requestList) {

        List<Result> responseWrapper = new List<Result>();

        for (Request curRequest : requestList) {
            Result response = new Result();
            //Map<String, Map<String, String>> extractedFormDataMap = EinsteinFormReader.processform(curRequest.formTemplateId, curRequest.uploadedFileText);
            Map<String, Map<String, String>> extractedFormDataMap = new Map<String, Map<String, String>>();
            response.outputFormData = (FormType_CreateContact)ConvertExtractedFormDataToCustomType(extractedFormDataMap, response.outputFormData);
            responseWrapper.add(response);
        }
        //FormType_CreateContact curCustomObject = new FormType_CreateContact();
        return responseWrapper;
    }

    //the goal here is to iterate over each form field and try to find a matching field in our custom type
    //because we want to be able to auto generate this action as easily as possible for each form type, we use dynamic tools to do the mapping instead of listing out the field names here
    public static FormType_Base  ConvertExtractedFormDataToCustomType(Map<String, Map<String, String>> extractedFormDataMap, FormType_Base curCustomObject){
        
        
        for (String key : extractedFormDataMap.keySet()) {
            
            //extract the value from the form data
            Map<String,String> valueMap = extractedFormDataMap.get(key);
            String value = valueMap.get('value'); 
            
            //set equivalent customobject field to the same value
            curCustomObject.setValue(key, value);
        }      

   
        return curCustomObject;
    }

   


    public class Request {

        @InvocableVariable(required=true)
        public String uploadedFileText;

        @InvocableVariable(required=true)
        public String formTemplateId;
        
    }

    public class Result {

        @InvocableVariable(required=false)
        public  FormType_CreateContact outputFormData;
    }
}