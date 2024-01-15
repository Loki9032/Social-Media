import { LightningElement, track, api } from 'lwc';
import getPosts from "@salesforce/apex/SocailMediaFeedsFetch.getPosts";
import { subscribe } from 'lightning/empApi';
export default class SocialMediaFeeds extends LightningElement {
    @track data = [];

    platformEvent = "/event/NotifyLWC__e";
    subscription = {};

    constructor() {
        super();


    }
    connectedCallback() {
        this.getData();
        if (!this.subscribe) {
            this.handleSubscribe();
            this.subscribe = true;
        }
    }

    getData() {
        getPosts().then((result) => {
            console.log(result);
            this.data = result;
        }).catch((error) => {

        });
    }
    handleSubscribe() {

        const messageCallbackForPost = (response) => {
            this.handlePlatFormEvent(response);
            console.log(response);
        };
        subscribe(this.platformEvent, -1, messageCallbackForPost).then(response => {
            // Response contains the subscription information on subscribe call
            console.log('Subscription request sent to: ', JSON.stringify(response.channel));
            this.subscription = response;
        });

    }
    handlePlatFormEvent(response) {
        console.log('OUTPUT : ', response);
        if (!response) {
            return;
        }
        let value = JSON.parse(response?.data?.payload?.PayLoad__c ?? {});
        switch (value.type) {
            case 'POST':
                console.log('OUTPUT : ', this.data);
                this.handleMessageForPost(value);
                break;
            case 'LIKES':
                this.handleMessageForLike(value);
                break;
            case 'COMMENTS':
                this.handleMessageForComment(value);
                break;
        }
    }
    handleMessageForLike(response) {
        if (response) {
            if (response.eventType) {
                let updatedPost = [];
                let postIDs = response.data.map(({ postId }) => postId);
                response.data.forEach((e) => {
                    let tempPost = Object.assign({}, this.data.find((ev) => ev.Post_Id__c == e.postId));



                    tempPost.socialMediaReactions__r = [{
                        "Social_Media__c": e.postId,
                        "Id": e.id,
                        "Total__c": e.value
                    }];
                    console.log(tempPost);
                    updatedPost.push(tempPost);
                });
                let tempdata = this.data.filter((e) => !(postIDs.includes(e.Post_Id__c)));
                this.data = [...updatedPost, ...tempdata];

            }
        }
    }

    handleMessageForComment(response) {
        if (response) {
            if (response.eventType) {
                if (response.eventType == 'ADD') {
                   let updatedPost = [];
                    let postIDs = response.data.map(({ postId }) => postId);
                    response.data.forEach((e) => {
                        let newComment=this.createComment(e.id,e.message,e.postId,e.commentId,e.createdAt,e.createdBy);
                        let tempPost = Object.assign({}, this.data.find((ev) => ev.Post_Id__c == e.postId));
                        if(tempPost?.socialMediaComments__r?.length>0){
                            let copyOfarr=[...tempPost.socialMediaComments__r];
                            copyOfarr.push(newComment);
                            tempPost.socialMediaComments__r=copyOfarr;
                        }else{
                            tempPost.socialMediaComments__r=[newComment];
                        }
                        updatedPost.push(tempPost);
                    });
                    let tempdata = this.data.filter((e) => !(postIDs.includes(e.Post_Id__c)));
                    this.data = [...updatedPost, ...tempdata];
                } else if (response.eventType == 'REMOVE') {
                    let updatedPost = [];
                    let postIDs = response.data.map(({ postId }) => postId);
                    response.data.forEach((e) => {
                        let tempPost = Object.assign({}, this.data.find((ev) => ev.Post_Id__c == e.postId));
                        let copyOfarr=[...tempPost.socialMediaComments__r];
                        if(copyOfarr.length>0){
                            let filiterdComments=copyOfarr.filter((ev)=>ev.comment_Id__c!=e.commentId);
                            tempPost.socialMediaComments__r=filiterdComments;
                        }
                        updatedPost.push(tempPost);
                    });
                    let tempdata = this.data.filter((e) => !(postIDs.includes(e.Post_Id__c)));
                    this.data = [...updatedPost, ...tempdata];
                }
            }
        }
    }

    handleMessageForPost(response) {
        if (response) {
            if (response.eventType) {
                if (response.eventType == 'ADD') {
                    let newData = [];
                    response.data.forEach((e) => {
                        newData.push(this.createnewPost(e.id, e.postId, e.message, e.createdBy));
                    });
                    this.data = [...newData, ...this.data];
                } else if (response.eventType == 'REMOVE') {
                    let ids = response.data.map(({ id }) => id);
                    let filterData = this.data.filter((data) => {
                        console.log('OUTPUT : ', data.Id);
                        if (ids.includes(data.Id)) {
                            return false;
                        }
                        return true;
                    });
                    this.data = [...filterData];
                }
            }
        }
    }
    createnewPost(id, Post_Id__c, Post_Message__c, Name) {
        return {
            Id: id,
            Post_Id__c: Post_Id__c,
            Post_Message__c: Post_Message__c,
            Name: Name
        }
    }
    createComment(id, message,postID,commentID,createDate,createdBy) {
        return {
            Id:id,
            Reacted_Id__c:postID, 
            comment_Message__c:message, 
            comment_Id__c:commentID,
            CreatedDate:createDate,
            CreatedBy:createdBy
        }
    }

}