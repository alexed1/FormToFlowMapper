public with sharing class GenerateCustomClasses {
  
    @InvocableMethod
    public static List <Result> generate(List<Request> requestList) {

        List<Result> responseWrapper = new List<Result>();

        for (Request curRequest : requestList) {
            Result response = new Result();
            //TODO need to error check that the keys don't have illegal characters like spaces. if they do, the process fails silently
            Map<String,String> fieldData = (Map<String,String>)JSON.deserialize(curRequest.serializedKeyValuePairMap,Map<String,String>.class);
            String formName = curRequest.datasetName;
            //generate the Data class that will allow the semi structured input data to be handled by flow
            String newActionClassName =  'ProcessForm_' + formName;
            String newDatatypeClassName = formName + 'Datatype';
            String classText = generateCustomDataTypeClass( fieldData, newDatatypeClassName );
            DeployApexClass.deploy(classText,newDatatypeClassName, null);
            classText = buildActionClass(newActionClassName,newDatatypeClassName);
            System.debug('action class:' + classText);
            DeployApexClass.deploy(classText,newActionClassName, null);

            responseWrapper.add(response);
        }
        return responseWrapper;
    }

    public static String buildActionClass(String newActionClassName,String className) {
        String baseText = BASE_ACTION_TEXT;
        baseText = baseText.replace('TargetDataType', className);
        baseText = baseText.replace('TargetActionName', newActionClassName);
        return baseText;

    }

    public static String generateCustomDataTypeClass(Map<String,String> fieldData, String name) {

        String classText = 'public with sharing class ' + name + ' {\n' +
        '\n';

        for (String key : fieldData.keySet()) {
            classText = classText + '@auraEnabled\npublic string ' + key + ';\n\n';
        }

        classText = classText + '}';
        System.debug ('generated classtext is: ' + classText);
        return classText;

    }

   public class FlowServiceException extends Exception {}

    

    public class Request {

        @InvocableVariable(required=true)
        public String serializedKeyValuePairMap;

        @InvocableVariable(required=true)
        public String datasetName;
        
    }

    public class Result {

        @InvocableVariable 
        public String success;
    }

    static final string BASE_ACTION_TEXT = 
        'public with sharing  class TargetActionName { \n' +
        '\n' +
        '@InvocableMethod \n' +
        'public static List <Result> process(List<Request> requestList) {\n' +
        '\n'  +  
        '    List<Result> responseWrapper = new List<Result>();\n' +
        '\treturn responseWrapper;\n' +
    '}\n\n' +
        'public class Request {\n'+
    '\n' +
            '\t@InvocableVariable(required=true)\n' +
            '\tpublic String uploadedFileText;\n' +
    '\n'+
           '\t@InvocableVariable(required=true)\n' +
            '\tpublic String formTemplateId;\n' +
       '\n' +     
       '}\n' +
    '\n'+
       'public class Result {\n' +
    '\n'+
            '\t@InvocableVariable(required=false)\n' +
            '\tpublic  TargetDataType outputFormData;\n' +
        '}\n' +
    '\n'+
         'public static TargetDataType Convert(Map<String, String> extractedFormDataMap) {\n' +
            '\treturn  (TargetDataType)JSON.deserialize(JSON.serialize(extractedFormDataMap),TargetDataType.class);\n' +
        '\t}\n' + 
    '} \n';    

    // The methods below are for testing. The normal testing pattern doesn't do callouts, but with this class, you 
    //really want to demonstrate that the classes are getting created.
    //to run these, go to the Anonymous window in Developer console and run GenerateCustomClasses.canGenerateClasses();
    //after completion, you may need to wait a minute or two to confirm that the classes have been created, because the metadata deploy that this causes is async

    
    public static void canGenerateClasses() {
        List<GenerateCustomClasses.Request> requestList = new List<GenerateCustomClasses.Request>();
        GenerateCustomClasses.Request request = new GenerateCustomClasses.Request();
        request.serializedKeyValuePairMap = '{"address":"43 Hemlock","lastName":"Maturin","firstName":"Stephen"}';
        request.datasetName = 'mytestform';
        requestList.add(request);
        List<GenerateCustomClasses.Result> resultList = GenerateCustomClasses.generate(requestList);
        System.assertNotEquals(null, resultList);

    }
    public static Map<String,String> generateTestMap() {
        Map<String,String> dataPairs = new Map<String,String>();
        dataPairs.put('firstName', 'Stephen');
        dataPairs.put('lastName', 'Maturin');
        dataPairs.put('address', '43 Hemlock');
        //{"address":"43 Hemlock","lastName":"Maturin","firstName":"Stephen"}
        System.debug('serialization is: ' + JSON.serialize(dataPairs));
        return dataPairs;
    } 
  
}