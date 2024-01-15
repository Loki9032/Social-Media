@isTest 
public class SocialMediaTextIntegration_Test {

    @isTest
    static void testSocialMediaTextPost_Both() {
       
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
     
        String message = 'Test Message';

        Test.startTest();
        SocialMediaTextIntegration.SocialMediaTextPost(message, true, true);
        Test.stopTest();

       
        List<Social_Media__c> socialMediaRecords = [SELECT Id FROM Social_Media__c];
        System.assertEquals(1, socialMediaRecords.size());

       
        SocialMediaTextIntegration.loginToLinkedin();

        SocialMediaTextIntegration.postMessageToLinkedin('testLoginId', 'Test Post Message');
        
    }
    @isTest
    static void testSocialMediaTextPost_facebook() {
       
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
     
        String message = 'Test Message';

        Test.startTest();
        SocialMediaTextIntegration.SocialMediaTextPost(message, true, false);
        Test.stopTest();

       
        List<Social_Media__c> socialMediaRecords = [SELECT Id FROM Social_Media__c];
        System.assertEquals(1, socialMediaRecords.size());

       
        SocialMediaTextIntegration.loginToLinkedin();

        SocialMediaTextIntegration.postMessageToLinkedin('testLoginId', 'Test Post Message');
        
    }

    @isTest
    static void testSocialMediaTextPost_linkedin() {
       
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
     
        String message = 'Test Message';

        Test.startTest();
        SocialMediaTextIntegration.SocialMediaTextPost(message, false, true);
        Test.stopTest();

       
       // List<Social_Media__c> socialMediaRecords = [SELECT Id FROM Social_Media__c];
       // System.assertEquals(1, socialMediaRecords.size());

       
        SocialMediaTextIntegration.loginToLinkedin();

        SocialMediaTextIntegration.postMessageToLinkedin('testLoginId', 'Test Post Message');
        
    }


    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setBody('{"id": "12345"}');
            res.setStatusCode(200);
            return res;
        }
    }
}