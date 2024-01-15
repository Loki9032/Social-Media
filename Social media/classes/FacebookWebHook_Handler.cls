public class FacebookWebHook_Handler {
    final RestRequest request;
    public FacebookWebHook_Handler(RestRequest request){   
        this.request=request;
    }
    
    public void processRequest(){
        if(String.isNotBlank(this.request.requestBody.toString())){
            FaceBookJsonConverter result=FaceBookJsonConverter.parse(request.requestBody.toString());
            if(result.entry.size()>0){
                system.debug(request.requestBody.toString());
                for(FaceBookJsonConverter.Entry entry : result.entry){
                    if(entry.changes.size()>0){
                        for(FaceBookJsonConverter.Changes changes:entry.changes){
                            if(changes.value.item=='status' && changes.value.verb=='add'){
                                socialMediaMessageController.createPost(changes.value.message,changes.value.post_id,DateTime.newInstance(changes.value.created_time));    
                            }else if(changes.value.item=='post' && changes.value.verb=='remove'){
                                socialMediaMessageController.deletePost(changes.value.post_id);	
                            }else if(changes.value.item=='comment' && changes.value.verb=='add'){
                                socialMediaMessageController.creatComment(changes.value.message,changes.value.post_id,DateTime.newInstance(changes.value.created_time),changes.value.comment_id,changes.value.parent_id);
                            }else if(changes.value.item=='comment' && changes.value.verb=='remove'){
                                socialMediaMessageController.deleteComment(changes.value.comment_id, changes.value.post_id);
                            }else if(changes.value.item=='reaction' && changes.value.verb=='add'){
                                socialMediaMessageController.addLikes(changes.value.verb,changes.value.post_id);
                            }else if(changes.value.item=='reaction' && changes.value.verb=='remove'){
                                socialMediaMessageController.removeLikes(changes.value.verb,changes.value.post_id);
                            }
                        }
                    }
                }
                insertLog(request.requestBody.toString());
            }
        }
    }
    
    @future
    public static void insertLog(String request){
        Log__c log=new Log__c();
        log.request__c=request;
        insert log;
        system.debug('My logs'+ log);
    }
}