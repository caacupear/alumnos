import { LightningElement , api, wire, track } from 'lwc';
import getEvaluaciones from '@salesforce/apex/EvaluacionesController.getByBoletin';
import {showError} from 'c/utils';

export default class EvaluacionesBoletin extends LightningElement {
    @api recordId;
    data = [];
    columns = [{ label: 'Materia', fieldName: 'Materia__c' }];
    hasErrors = false;

    @wire(getEvaluaciones, { boletinId: '$recordId'} ) getData(result) {
        if ( result.data ) {            
            try {        
                this.columns = this.columns.concat( result.data.programa.evaluaciones.map( item => {
                    return { label: item.nombre, fieldName: item.campo }
                } ) );
                this.data = result.data.evaluaciones;
            } catch(error) {
                this.hasErrors = true;
                this.dispatchEvent( showError('Error', error ) );
            }
        }
        if ( result.error ) {
            this.hasErrors = true;
            this.dispatchEvent( showError('Error', result.error ) );
        }
    }
}