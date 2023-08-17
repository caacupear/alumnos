import { LightningElement , api, wire, track } from 'lwc';
import getEvaluaciones from '@salesforce/apex/EvaluacionesController.getEvaluacionesDivision';

export default class EvaluacionesDivision extends LightningElement {
    @api recordId;
    data = [];
    columns = [{ label: 'Alumno', fieldName: 'Alumno__c' }];

    @wire(getEvaluaciones, { divisionId: '$recordId'} ) getData({data, error}) {
        try {        
            console.log(data, error, this.recordId);
            if ( data ) {            
                this.columns = this.columns.concat( data.programa.evaluaciones.map( item => {
                    console.log(item);
                    return { label: item.nombre, fieldName: item.campo }
                } ) );
console.log(this.columns);
                this.data = data.evaluaciones;
            }
        } catch( e) {
            console.log(e.message);
        }
    }
}