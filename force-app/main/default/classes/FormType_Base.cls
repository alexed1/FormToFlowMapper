public  abstract class FormType_Base {

        public FormType_Base() {

        }
    
         public Object getValue(String param_name)  {
                String json_instance = Json.serialize(this);
                Map<String, Object> untyped_instance;
                untyped_instance= (Map<String, Object>)JSON.deserializeUntyped(json_instance);
                return untyped_instance.get(param_name);
        }

        public void setValue(String param_name, String param_value)  {
            String json_instance = Json.serialize(this);
            Map<String, Object> untyped_instance;
            System.debug('json_instance: ' + json_instance);
            untyped_instance= (Map<String, Object>)JSON.deserializeUntyped(json_instance);
            System.debug('untyped_instance: ' + untyped_instance);
            System.debug('param name is: ' + param_name);
            System.debug('param value is: ' + param_value);
            untyped_instance.put(param_name,param_value);
            System.debug('untyped_instance after putting paramname ' +  untyped_instance);
           
            //TO DO
            // need to deserialize here, updating the current instance data to reflect the field that has just been set
            
             
        }
 
    

}
