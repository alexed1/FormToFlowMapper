@isTest
public with sharing class GenerateApexTests {
   
    public static final String demoDataTypeClass = 'public with sharing class FormType_Contact1 {\n' +
        '\n'+
        '@auraEnabled\n' +
        'public string firstName;\n' +
        '\n'+
        '@auraEnabled\n' +
        'public string lastName;\n' + 
        '\n'+
        '@auraEnabled\n' +
        'public string address;\n' + 
    '\n'+
    '}';


    public static Map<String,String> generateTestMap() {
        Map<String,String> dataPairs = new Map<String,String>();
        dataPairs.put('firstName', 'Stephen');
        dataPairs.put('lastName', 'Maturin');
        dataPairs.put('address', '43 Hemlock');
        return dataPairs;
    }

  
    @isTest
    public static void canDeployCustomDataTypeClass() {
        Map<String,String> dataPairs = generateTestMap();
        String classText = GenerateCustomClasses.generateCustomDataTypeClass(dataPairs, 'FormType_Contact1');
        System.assertEquals(demoDataTypeClass, classText);
    }

    @isTest
    public static void CanExtractKeyValuePairs() {

        //FormToFlow_MapCreateContact.Request testRequest = new FormToFlow_MapCreateContact.Request();

        Map<String, Map<String, String>> extractedFormDataMap = new Map<String, Map<String, String>>();
       
        Map<String,String> dataPairs1 = new Map<String,String>();
        dataPairs1.put('value', 'Stephen');
        dataPairs1.put('confidence', '.66');
        extractedFormDataMap.put('firstName', dataPairs1);

        Map<String,String> dataPairs2 = new Map<String,String>();
        dataPairs2.put('value', 'Maturin');
        dataPairs2.put('confidence', '.62');
        extractedFormDataMap.put('lastName', dataPairs2);

        Map<String,String> dataPairs3 = new Map<String,String>();
        dataPairs3.put('value', '43 Magnolia');
        dataPairs3.put('confidence', '.72');
        extractedFormDataMap.put('address', dataPairs3);

        //FormType_CreateContact curFormType = new FormType_CreateContact();
        Map<String,String> extractedData =  FormToFlowUtils.ExtractKeyValuePairs(extractedFormDataMap);

        System.assertEquals(extractedData.get('firstName'), 'Stephen');
        System.assertEquals(extractedData.get('lastName'), 'Maturin');
        System.assertEquals(extractedData.get('address'), '43 Magnolia');

        FormType_CreateContact curFormType_CreateContact =  (FormType_CreateContact)JSON.deserialize(JSON.serialize(extractedData),FormType_CreateContact.class);

        System.assertEquals(curFormType_CreateContact.firstName, 'Stephen');
        System.assertEquals(curFormType_CreateContact.lastName, 'Maturin');
        System.assertEquals(curFormType_CreateContact.address, '43 Magnolia');

    }
}
