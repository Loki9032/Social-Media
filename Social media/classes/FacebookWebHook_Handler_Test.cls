@isTest
private class FacebookWebHook_Handler_Test {
	@testSetup
    static void initData(){
        String currentUserName = UserInfo.getName();
            Social_Media__c socialMediaRecord = new Social_Media__c(
                Post_Message__c = 'Test post',
                Time_Posted__c = System.now(),
                Post_Id__c='123',
                Name = currentUserName
            );
            
            insert socialMediaRecord;
        
        socialMediaComments__c socialMediaComment = new socialMediaComments__c(
                comment_Message__c = 'message',
                comment_Id__c = '456',
                Reacted_Id__c = 'reactedid',
                Social_Media__c=socialMediaRecord.id
            );
            insert socialMediaComment;
    }
    @isTest
    static void testProcessRequestStatusAdd() {
        // Simulate a status addition
        RestRequest mockRequest = new RestRequest();
        mockRequest.requestBody = Blob.valueOf('{"entry":[{"changes":[{"value":{"item":"status","verb":"add","message":"Test Message","post_id":"1234","created_time":1683493200}}]}]}');
        
        Test.startTest();
        FacebookWebHook_Handler handler = new FacebookWebHook_Handler(mockRequest);
        handler.processRequest();
        Test.stopTest();

        
    }

   
    
    // Test post removal
    @isTest
    static void testProcessRequestPostRemove() {
        RestRequest mockRequest = new RestRequest();
        mockRequest.requestBody = Blob.valueOf('{"entry":[{"changes":[{"value":{"item":"post","verb":"remove","post_id":"123"}}]}]}');
        
        Test.startTest();
        FacebookWebHook_Handler handler = new FacebookWebHook_Handler(mockRequest);
        handler.processRequest();
        Test.stopTest();

     
    }

    // Test comment addition
    @isTest
    static void testProcessRequestCommentAdd() {
        RestRequest mockRequest = new RestRequest();
        mockRequest.requestBody = Blob.valueOf('{"entry":[{"changes":[{"value":{"item":"comment","verb":"add","message":"Test Comment","post_id":"123","created_time":1683493200,"comment_id":"456","parent_id":"789"}}]}]}');
        
        Test.startTest();
        FacebookWebHook_Handler handler = new FacebookWebHook_Handler(mockRequest);
        handler.processRequest();
        Test.stopTest();

       
    }

     @isTest
    static void testProcessRequestCommentRemove() {
        RestRequest mockRequest = new RestRequest();
        mockRequest.requestBody = Blob.valueOf('{"entry":[{"changes":[{"value":{"item":"comment","verb":"remove","comment_id":"456","post_id":"123"}}]}]}');
        
        Test.startTest();
        FacebookWebHook_Handler handler = new FacebookWebHook_Handler(mockRequest);
        handler.processRequest();
        Test.stopTest();

       
    }

    // Test reaction addition
    @isTest
    static void testProcessRequestReactionAdd() {
        RestRequest mockRequest = new RestRequest();
        mockRequest.requestBody = Blob.valueOf('{"entry":[{"changes":[{"value":{"item":"reaction","verb":"add","post_id":"123"}}]}]}');
        
        Test.startTest();
        FacebookWebHook_Handler handler = new FacebookWebHook_Handler(mockRequest);
        handler.processRequest();
        Test.stopTest();

       
    }

    // Test reaction removal
    @isTest
    static void testProcessRequestReactionRemove() {
        RestRequest mockRequest = new RestRequest();
        mockRequest.requestBody = Blob.valueOf('{"entry":[{"changes":[{"value":{"item":"reaction","verb":"remove","post_id":"123"}}]}]}');
        
        Test.startTest();
        FacebookWebHook_Handler handler = new FacebookWebHook_Handler(mockRequest);
        handler.processRequest();
        Test.stopTest();
      
    }

}