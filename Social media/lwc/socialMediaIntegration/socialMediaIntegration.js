import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import sendMessageToSocialMedia from '@salesforce/apex/SocialMediaTextIntegration.SocialMediaTextPost';
//import getMessages from '@salesforce/apex/socialMediaMessageController.getMessages'
export default class socialMediaIntegration extends LightningElement {

    @track message = '';
    modalIsOpen = false;
    @track showMessages = false;
    @api postToFacebook;
    @api postToLinkedin;


    handleMessageChange(event) { //getting input text to  message Variable  
        this.message = event.target.value;
    }

    showToast(title, message, variant) { // creating a custom toast event
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }

    // Function to open the modal
    openModal() {
        this.modalIsOpen = true;
    }

    // Function to handle the Cancel button click
    handleCancelClick() {
        this.message = '';
        this.modalIsOpen = false;
    }

    // Function to handle the Send Message 
    sendMessageToApex() {
        if (this.message.trim() !== '') {   //Null check if input in empty

            if (!this.postToFacebook && !this.postToLinkedin) {
                sendMessageToSocialMedia({ Message: this.message.replace(/<[^>]*>/g, ''), postToFacebook: true, postToLinkedin: true })  // cacheable method for sending message
                    .then(result => {
                        this.message = '';
                        console.log('message send to Both');

                        this.showToast('Success', 'Message sent to Both Facebook & Linkedin successfully', 'success');
                    })
                    .catch(cacheableError => {
                        this.showToast('Error', 'Error executing' + cacheableError, 'error');
                    });
            }else if (this.postToFacebook && this.postToLinkedin) {
                    sendMessageToSocialMedia({ Message: this.message.replace(/<[^>]*>/g, ''), postToFacebook: true, postToLinkedin: true })  // cacheable method for sending message
                        .then(result => {
                            this.message = '';
                            console.log('message send to Both');

                            this.showToast('Success', 'Message sent to Both Facebook & Linkedin successfully', 'success');
                        })
                        .catch(cacheableError => {
                            this.showToast('Error', 'Error executing' + cacheableError, 'error');
                        });
                } else if (this.postToFacebook) {
                    sendMessageToSocialMedia({ Message: this.message.replace(/<[^>]*>/g, ''), postToFacebook: true, postToLinkedin: false })  // cacheable method for sending message
                        .then(result => {
                            this.message = '';
                            console.log('message send to Facebook');
                            this.showToast('Success', 'Message sent to Facebook successfully', 'success');
                        })
                        .catch(cacheableError => {
                            this.showToast('Error', 'Error executing' + cacheableError, 'error');
                        });
                } else if (this.postToLinkedin) {
                    sendMessageToSocialMedia({ Message: this.message.replace(/<[^>]*>/g, ''), postToFacebook: false, postToLinkedin: true })  // cacheable method for sending message
                        .then(result => {
                            this.message = '';
                            console.log('message send to Linkedin');

                            this.showToast('Success', 'Message sent to Linkedin successfully', 'success');
                        })
                        .catch(cacheableError => {
                            this.showToast('Error', 'Error executing' + cacheableError, 'error');
                        });
                }
            } else {
                this.showToast('Error', 'Message is empty', 'error');
            }
            this.modalIsOpen = false;
        }

        // Getting Messages from the apex and storing into Previous Messages
        fetchMessages() {
            getMessages()
                .then(result => {
                    this.previousMessages = result.map(item => ({
                        timestamp: item.timestamp,
                        message: item.message,

                    }));

                    console.log('Fetched Messages:', this.previousMessages);
                })
                .catch(error => {
                    console.error('Error fetching messages:', error);
                });
        }

    }