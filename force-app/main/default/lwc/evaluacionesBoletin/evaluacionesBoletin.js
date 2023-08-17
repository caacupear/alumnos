import { LightningElement , api, wire, track } from 'lwc';
import getEvaluaciones from '@salesforce/apex/EvaluacionesController.getEvaluacionesBoletin';

export default class EvaluacionesBoletin extends LightningElement {
    @api recordId;
    data = [];
    columns = [{ label: 'Materia', fieldName: 'Materia__c' }];

    @wire(getEvaluaciones, { boletinId: '$recordId'} ) getData({data, error}) {
        try {
            console.log(data);
            
            if ( data ) {            
                this.columns = this.columns.concat( data.programa.evaluaciones.map( item => {
                    return { label: item.nombre, fieldName: item.campo }
                } ) );
                this.data = data.evaluaciones;
            }
        } catch( e) {
            console.log(e.message);
        }
    }
}