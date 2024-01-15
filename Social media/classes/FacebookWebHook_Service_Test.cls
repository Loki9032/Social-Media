@isTest
private class FacebookWebHook_Service_Test {

    @isTest
    static void testVerificationEndpointWithValidToken() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/webhooks';
        req.httpMethod = 'GET';
        req.params.put('hub.verify_token', Label.Facebook_Webhook_Key);
        req.params.put('hub.challenge', '1158201444');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        FacebookWebHook_Service.verification();
        Test.stopTest();

        System.assertEquals('1158201444', RestContext.response.responseBody.toString());
    }

    @isTest
    static void testVerificationEndpointWithInvalidToken() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/webhooks';
        req.httpMethod = 'GET';
        req.addParameter('hub.verify_token', 'InvalidToken');
        req.addParameter('hub.challenge', 'TestChallenge123');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        FacebookWebHook_Service.verification();
        Test.stopTest();

        System.assertEquals(404, RestContext.response.statusCode);
    }

    @isTest
    static void testFeedsEndpoint() {
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/webhooks';
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf('{"entry":[{"changes":[{"value":{"item":"status","verb":"add","message":"Test Message","post_id":"123","created_time":1683493200}}]}]}');
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        FacebookWebHook_Service.feeds();
        Test.stopTest();
		List<Social_Media__c> sms = [select id from Social_Media__c];
        System.assert(sms.size()>0);
    }
}