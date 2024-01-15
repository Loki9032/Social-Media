@isTest
public class socialMediaMessageController_Test {
    
  @isTest
    static void testPostCommentLikeOperations() {
        
        socialMediaMessageController.createPost('Test Post', '123', System.now());     
        
        Social_Media__c createdPost = [SELECT Id FROM Social_Media__c WHERE Post_Id__c = '123' LIMIT 1];
        
        socialMediaMessageController.creatComment('Test Comment', '123', System.now(), '456', '789'); 
        
        socialMediaMessageController.addLikes('add', '123');

        
    }

    @isTest
    static void testDeletePostWithCommentsAndLikes() {
        
        socialMediaMessageController.createPost('Test Post', '123', System.now());
       
        Social_Media__c createdPost = [SELECT Id FROM Social_Media__c WHERE Post_Id__c = '123' LIMIT 1];
       
        socialMediaMessageController.creatComment('Test Comment', '123', System.now(), '456', '789');

               socialMediaMessageController.addLikes('add', '123');
   
        Test.startTest();

        socialMediaMessageController.deletePost('123');

        Test.stopTest();
       
    }

    @isTest
    static void testDeleteComment() {
        
        socialMediaMessageController.createPost('Test Post', '123', System.now());
       
        Social_Media__c createdPost = [SELECT Id FROM Social_Media__c WHERE Post_Id__c = '123' LIMIT 1];
        
        socialMediaMessageController.creatComment('Test Comment', '123', System.now(), '456', '789');
       
        socialMediaMessageController.deleteComment('456', '123');

       
    }

    @isTest
    static void testAddRemoveLikes() {
       
        socialMediaMessageController.createPost('Test Post', '123', System.now());
       
        Social_Media__c createdPost = [SELECT Id FROM Social_Media__c WHERE Post_Id__c = '123' LIMIT 1];
        
        socialMediaMessageController.addLikes('add', '123');
               
        socialMediaMessageController.removeLikes('remove', '123');
        socialMediaMessageController.addLikes('add', '123');
        
       
    }
}