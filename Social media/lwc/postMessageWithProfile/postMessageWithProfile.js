import { LightningElement,api } from 'lwc';
export default class PostMessageWithProfile extends LightningElement {
    @api postMessage='';
    @api pageName='';
    connectedCallback() {
        console.log('OUTPUT : ',this.postMessage,this.pageName);
    }
}