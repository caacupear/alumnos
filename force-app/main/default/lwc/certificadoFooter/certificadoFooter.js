import { LightningElement } from 'lwc';

export default class CertificadoFooter extends LightningElement {
    get fecha() { 
        const hoy = new Date();

        return hoy.getFullYear(); 
    }

}