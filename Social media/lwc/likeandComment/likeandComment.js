import { LightningElement,api } from 'lwc';
export default class LikeandComment extends LightningElement {
    
    @api myData='';

    get likeData(){
        return this.myData.socialMediaReactions__r?this.myData.socialMediaReactions__r:[];
    }
    get comments(){
        return this.myData.socialMediaComments__r?this.myData.socialMediaComments__r:[];
    }
    get like(){
        let value=this.likeData.length>0 ? this.likeData[0].Total__c : 0; 
        return value;
    }
    connectedCallback() {
        
    }
    openComments = false;

    showComments() {
        this.openComments = true;
    }
    closeComment() {
        this.openComments = false;
    }
}