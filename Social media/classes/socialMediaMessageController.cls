public class socialMediaMessageController {

    
    public static void createPost(String message,String id ,DateTime createdAt){
        
        try {
            String currentUserName = UserInfo.getName();
            Social_Media__c socialMediaRecord = new Social_Media__c(
                Post_Message__c = message,
                Time_Posted__c = createdAt,
                Post_Id__c=id,
                Name = currentUserName
            );
            
            insert socialMediaRecord;
            system.debug('Record Saved Successfully');
            
        } catch (Exception ex) {
            throw ex;
        }
        
    }
    public static void deletePost(String id){
        try{
            List<Sobject> temps=new List<Sobject>();
            
            Social_media__c sm= [select id ,(select id from socialMediaComments__r ),(select id from socialMediaReactions__r ) from Social_Media__c  where post_id__c =: id];
            
            List<socialMediaComments__c> comments= (List<socialMediaComments__c>) sm.getSObjects('socialMediaComments__r');
            
            List<socialMediaReaction__c> likes= (List<socialMediaReaction__c>) sm.getSObjects('socialMediaReactions__r');
            
            if(comments !=null && !comments.isEmpty()){
                temps.addAll(comments);    
            }
            if(likes !=null && !likes.isEmpty()){
                temps.addAll(likes);    
            }
            if(sm!=null){
                temps.add(sm);    
            }
            if(!temps.isEmpty()){
                
                delete temps;
            }
            
        }catch(Exception ex){
            throw ex;
        }
    }
    
    // create Commentrequest
    public static void creatComment(String message,String postId ,DateTime createdAt, string commentId, string reactedid ){
        try{
            Social_Media__c sm =[select id from Social_Media__c where post_id__c =:postId ];
            socialMediaComments__c socialMediaComment = new socialMediaComments__c(
                comment_Message__c = message,
                comment_Id__c = commentId,
                Reacted_Id__c = reactedid,
                Social_Media__c=sm.id
            );
            insert socialMediaComment;
            system.debug('Comment saved Successfully');
            
        }catch(Exception ex){
            throw ex;
        }
        
    }
    
    // Delete Commentrequest
    public static void deleteComment(String commentId,String postId ){
        try{
            socialMediaComments__c comments = [Select id,comment_Id__c From socialMediaComments__c WHERE comment_Id__c =: commentId and Social_Media__r.post_id__c=:postId];
            if(comments != null){
                delete comments;
            }
        }catch(Exception ex){
            throw ex;
        }
        
    }
    
    // Add like request
    public static void addLikes(string verb, string postId ){
        try{
            Social_Media__c sm =[select id from Social_Media__c where post_id__c =:postId ];
            if(sm!=null){
            List<socialMediaReaction__c> reaction = [Select Id,verb__c, Social_Media__c from socialMediaReaction__c Where Social_Media__c =: sm.id];
            socialMediaReaction__c socialMediaLikes = new socialMediaReaction__c(
                Verb__c = verb,
                Social_Media__c=sm.id
            );
            if(reaction.size()>0){
                socialMediaLikes.id=reaction[0].id;
            }
            upsert socialMediaLikes;
            system.debug('Comment saved Successfully');
            }
            
            
        }catch(Exception ex){
            throw ex;
        }
        
    }
    
     // Remove like request
    public static void removeLikes(string verb, string postId ){
        try{
            List<socialMediaReaction__c> Likes = [Select Id,verb__c, Social_Media__c from socialMediaReaction__c Where Social_Media__r.post_id__c =:postId];
            if(Likes != null){
                for(socialMediaReaction__c reaction :Likes){
                    reaction.verb__c=verb;
                }
                update Likes;
            }
          
        }catch(Exception ex){
            throw ex;
        }
    }
    

}