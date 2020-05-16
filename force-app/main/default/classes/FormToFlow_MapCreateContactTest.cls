@isTest
public with sharing class FormToFlow_MapCreateContactTest {
   
    @isTest
    public static void CanMapContacts() {

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

        FormType_CreateContact curFormType = new FormType_CreateContact();
        curFormType = (FormType_CreateContact)FormToFlow_MapCreateContact.ConvertExtractedFormDataToCustomType(extractedFormDataMap,curFormType);

        System.assertEquals(curFormType.firstName, 'Stephen');
        System.assertEquals(curFormType.lastName, 'Maturin');
        System.assertEquals(curFormType.address, '43 Magnolia');
        //FormToFlow_MapCreateContact.Result = FormToFlow_MapCreateContact.process(testRequest);

    }
}
