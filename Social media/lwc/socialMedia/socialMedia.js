import { LightningElement, track } from 'lwc';
//import { NavigationMixin } from 'lightning/navigation';
import publicProfileIcons from "@salesforce/resourceUrl/publicProfileIcons";
export default class SocialMedia extends LightningElement {

    linkedin = publicProfileIcons + '/public-profile-icons/linkedin-icon.png';
    fb = publicProfileIcons + '/public-profile-icons/Fb-icon.png';
    @track isModalOpen = false;
    @track postToFacebook;
    @track postToLinkedin;



    openSetupModal() {
        this.isModalOpen = true;
        //navigation code
    //   this[NavigationMixin.Navigate]({
    //         type: 'lightning__AppPage',
    //         attributes: {
    //             url: '/lightning/cmp/c__socialmediaInstructions' // Change 'socialMediaInstructions' to your actual component name
    //         }
    //     }, true);
    }

    closeModal() {
        this.isModalOpen = false;
    }

    handleFacebookCheckbox(event) {
        this.postToFacebook = event.target.checked;
        console.log('facebook checked')
    }
    handleLinkedinCheckbox(event) {
        this.postToLinkedin = event.target.checked;
        console.log('linkedin checked');

    }

    

}