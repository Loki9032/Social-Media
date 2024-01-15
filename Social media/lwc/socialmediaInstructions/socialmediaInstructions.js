import { LightningElement } from 'lwc';
import socialMediaCreds from "@salesforce/resourceUrl/socialMediaCreds";
export default class SocialmediaInstructions extends LightningElement {

    linkedin = socialMediaCreds+'/socialMedia_creds/linkedin_cred.png';
    linkedin_token =socialMediaCreds+'/socialMedia_creds/linkedin-token.png';
    fb = socialMediaCreds+'/socialMedia_creds/fb_cred.png';
    meta_obj = socialMediaCreds+'/socialMedia_creds/Meta-data_1.png';
    meta_record = socialMediaCreds+'/socialMedia_creds/meta-data_2.png';
    webhook = socialMediaCreds+'/socialMedia_creds/fb-webhook_cred.png';


}