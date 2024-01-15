@RestResource(urlMapping='/webhooks')
global class FacebookWebHook_Service {
    @HttpGet
    global static void verification(){
        RestRequest request = RestContext.request;
        RestResponse res = RestContext.response;
        String facebookWebhookKey = Label.Facebook_Webhook_Key;
                
        Map<String,String> params= request.params ;
        if(params.containsKey('hub.verify_token') && params.get('hub.verify_token')== facebookWebhookKey){
            if(params.containsKey('hub.challenge')){
                String challenge=(String)Json.deserialize(params.get('hub.challenge'),String.class);
                System.debug(challenge);
                res.responseBody = Blob.valueof(challenge);
                
            }
        }else{
            res.statuscode =404;
        }
        
    }
    @HttpPost
    global static void feeds(){
        RestRequest request = RestContext.request;
        RestResponse res = RestContext.response;
        FacebookWebhook_Handler handler = new FacebookWebhook_Handler(request);
        handler.processRequest();
        res.statuscode=200;
    }
}