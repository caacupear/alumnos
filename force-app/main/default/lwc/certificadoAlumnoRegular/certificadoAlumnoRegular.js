import { LightningElement, wire , api} from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Contact.Name';
import DOCUMENTO_FIELD from '@salesforce/schema/Contact.Documento__c';
import TIPODOCUMENTO_FIELD from '@salesforce/schema/Contact.TipoDeDocumento__c';

const FIELDS = [NAME_FIELD, TIPODOCUMENTO_FIELD, DOCUMENTO_FIELD];

export default class CertificadoAlumnoRegular extends LightningElement {
    @api recordId;
    get fecha() { 
        const hoy = new Date();

        return hoy.getFullYear(); 
    }
    
    get nombre() { 
        return this.alumno[NAME_FIELD];
    }
    get documento() { return this.alumno[DOCUMENTO_FIELD]}
    get tipoDocumento() { return this.alumno[TIPODOCUMENTO_FIELD]}

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS}) alumno;
}