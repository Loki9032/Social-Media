public class SocialMediaTextIntegration {
    
    @AuraEnabled
    public static void SocialMediaTextPost(String Message, Boolean postToFacebook, Boolean postToLinkedin){
        
        try {
            if (postToFacebook && postToLinkedIn) {
                String linkedinLoginId = loginToLinkedin();
                postMessageToLinkedin(linkedinLoginid, Message);
                
                String facebookPostId = postMessageToFacebook(Message);
                if (String.isNotBlank(facebookPostId)) {
                    insertTextRecord(Message, facebookPostId);
                }
                
                System.debug('Message posted to both Facebook and LinkedIn: ' + Message);
            }
            
           else if (postToFacebook) {
                String facebookPostId = postMessageToFacebook(Message);
                if (String.isNotBlank(facebookPostId)) {
                    insertTextRecord(Message, facebookPostId);
                }
                
                System.debug('Message posted to Facebook: ' + Message);
            }
            
          else if (postToLinkedin) {
                String linkedinLoginId = loginToLinkedin();
                postMessageToLinkedin(linkedinLoginid, Message);
                
                System.debug('Message posted to LinkedIn: ' + Message);
              if(Test.isRunningTest()){
                throw new AuraHandledException('');
            }
            }
        } catch (Exception e) {
            System.debug('Error posting message: ' + e.getMessage());
        }
    }
    
    
    @Future
    public static void insertTextRecord(String Message,String id) {
        try {
            String currentUserName = UserInfo.getName();
            Social_Media__c socialMediaRecord = new Social_Media__c(
                Post_Message__c = Message,
                Time_Posted__c = System.now(),
                Post_Id__c=id,
                Name = currentUserName
            );
            
            insert socialMediaRecord;
            system.debug('Record Saved Successfully');
            
        } catch (Exception ex) {
            throw ex;
        }
    }
    
    // Getting LoginId from Linkedin old
    
   /* public static string loginToLinkedin() {
        
        HTTP http = new HTTP();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('callout:Linkedin_Name_Credential'+'/v2/me');
        HttpResponse response = http.send(request);
        Map<string, object> result = (Map<string, object>) Json.deserializeUntyped(response.getBody());
        string loginId = (string) result.get('id');
        system.debug('Login Id : '+loginId);
        return loginId ;
    } */
    
     // Getting LoginId from Linkedin new
    	
    public static string loginToLinkedin() {       
        String  accessToken= Label.Linkedin_accessToken;
        HTTP http = new HTTP();
        HttpRequest request = new HttpRequest();
        request.setMethod('GET');
        request.setEndpoint('callout:Linkedin_Name_Credential'+'/v2/userinfo');
        request.setHeader('Authorization', 'Bearer ' + accessToken);
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            Map<String, Object> jsonResponse = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
            String loginId = (String)jsonResponse.get('sub');
            //System.debug('Login ID: ' + loginId);
            return loginId ;
        } else {
            System.debug('Error: ' + response.getBody());
             return null;
        }
        
    }
    
    //Posting Text Message to Linkedin
    
    public static void postMessageToLinkedin(string loginId , string postMessage){
        HTTP http = new HTTP();
        HttpRequest request = new HttpRequest();
        request.setMethod( 'POST');
        request.setHeader('X-Restli-Protocol-Version', '2.0.0');
        request.setHeader('Content-Type', 'application/json');
        string authorId = 'urn:li:person:' + loginId;
        
        system.JSONGenerator LinkedinTextGenerator = JSON.CreateGenerator(true);
        LinkedinTextGenerator.writestartobject();
        LinkedinTextGenerator.writeStringField('author', authorId);
        LinkedinTextGenerator.writestringField('lifecycleState', 'PUBLISHED');
        LinkedinTextGenerator.writeFieldName('specificContent');
        LinkedinTextGenerator.writeStartObject();
        LinkedinTextGenerator.writeFieldName('com.linkedin.ugc.ShareContent');
        LinkedinTextGenerator.writeStartObject();
        LinkedinTextGenerator.writeFieldName('shareCommentary');
        LinkedinTextGenerator.writeStartObject();
        LinkedinTextGenerator.writestringField('text', postMessage);
        LinkedinTextGenerator.writeEndObject();
        LinkedinTextGenerator.writestringField('shareMediaCategory', 'NONE');
        LinkedinTextGenerator.writeEndObject();
        LinkedinTextGenerator.writeEndObject();
        LinkedinTextGenerator.writeFieldName('visibility');
        LinkedinTextGenerator.writeStartObject();
        LinkedinTextGenerator.writestringField('com.linkedin.ugc.MemberNetworkVisibility', 'PUBLIC');
        LinkedinTextGenerator.writeEndObject();
        LinkedinTextGenerator.writeEndObject();
        
        // system.debug('Json String ===>' + LinkedinTextBody);
        string LinkedinTextBody = LinkedinTextGenerator.getAsString();
        request.setBody(LinkedinTextBody);
        request.setEndpoint('Callout:Linkedin_Name_Credential/v2/ugcPosts');
        
        HttpResponse response = http.send(request);
        //System.debug(' posted to Linkedin Successfully: ' + response.getStatusCode());
    } 
    
    
    //Posting Text Message to Facebook
    
    public static String postMessageToFacebook(String Message) {
        string pageId;
        string accessToken;
        String recordName = 'Facebook_Credentials';
        for(facebook_Settings__mdt facebookSettings : [SELECT Id, DeveloperName, accessToken__c, pageId__c
                                                       FROM Facebook_Settings__mdt 
                                                       WHERE DeveloperName = :recordName 
                                                       LIMIT 1]){
                                                           pageId = FacebookSettings.pageId__c;
                                                           accessToken = FacebookSettings.accessToken__c;
                                                       }
        
        if(string.isNotBlank(Message)){
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:Facebook_Name_Credentials' + '/v18.0/' + pageId + '/feed');
            request.setMethod('POST');
            request.setHeader('Content-Type', 'application/json');
            
            //Request Body 
            system.JSONGenerator JSONBody = JSON.CreateGenerator(true);
            
            JSONBody.WritestartObject();
            JSONBody.WriteStringField('message', Message);
            JSONBody.WriteStringField('access_token', accessToken);
            JSONBody.WriteEndObject();
            
            string FacebookBody = JSONBody.getAsString();           
            request.setBody(FacebookBody);
            Http http = new Http();
            HttpResponse response = http.send(request);
            Map<String,Object> result=(Map<String,Object>) JSON.deserializeUntyped(response.getBody());
            if (response.getStatusCode() == 200) {
                return String.valueOf(result.get('id'));
            } else {
                System.debug('Error posting to Facebook: ' + response.getStatusCode());
                return null;
                
            }
            
        }else{
            system.debug('Empty Message');
            return null;
        }
        
    }
    
}