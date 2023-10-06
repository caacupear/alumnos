import { LightningElement, wire , track, api} from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';


export default class ReservaVacante extends LightningElement {
    @api recordId;
    _alumno;
    @track hasData = false;

    get fecha() { 
        const hoy = new Date();

        return hoy.getFullYear(); 
    }

    get titulo () { return 'CONSTANCIA DE RESERVA DE VACANTE'}
    get nombre() { 
        return this._alumno?.Name?.value;
    }
    get documento() { return this._alumno?.Documento__c?.value;}
    get tipoDocumento() {  return this._alumno?.TipoDeDocumento__c?.value;}

    @wire(getRecord, { recordId: '$recordId', fields: ['Contact.Name', 'Contact.Documento__c', 'Contact.TipoDeDocumento__c']}) getRecord( {data, error}) {
        if(data){
            this._alumno = data.fields;
            this.hasData = true;
        }
        console.log(this.hasData,);
    };
}