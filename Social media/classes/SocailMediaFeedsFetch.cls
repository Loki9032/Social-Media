public class SocailMediaFeedsFetch {

    @AuraEnabled(cacheable=true)
    public static List<Social_Media__c> getPosts(){
        List<Social_Media__c> posts=[select Id,Post_Id__c,Name, Post_Message__c, Time_Posted__c,(select CreatedDate, CreatedBy.Name, Reacted_Id__c, comment_Message__c, comment_Id__c from socialMediaComments__r),(select id,Total__c from socialMediaReactions__r ) from Social_Media__c order by LastModifiedDate desc];
        return posts;
    }
}