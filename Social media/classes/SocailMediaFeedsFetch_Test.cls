@isTest
private class SocailMediaFeedsFetch_Test {
    
    @Testsetup
    static void testGetPosts() {
            Social_Media__c post = new Social_Media__c(
                Post_Id__c = 'TestPost',
                Name = 'Test Post ',
                Post_Message__c = 'Test Message ',
                Time_Posted__c = System.now()
            );
        
        insert post;
        
        socialMediaComments__c testComment = new socialMediaComments__c(comment_Message__c = 'Test' ,Social_Media__c = post.id);
        
        socialMediaReaction__c testLikes = new socialMediaReaction__c(Total__c = 1,Social_Media__c = post.id );
        
        Test.startTest();
        List<Social_Media__c> result = SocailMediaFeedsFetch.getPosts();
        Test.stopTest();
        
        Social_Media__c Fetchpost = [select Id,Post_Id__c,Name, Post_Message__c, Time_Posted__c,(select  comment_Message__c, comment_Id__c from socialMediaComments__r),(select id,Total__c from socialMediaReactions__r ) from Social_Media__c ];
      	
        System.assertNotEquals(null, result.size(), 'posts retrieved');
       
    }
}