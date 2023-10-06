import { LightningElement , api, wire, track } from 'lwc';
import getGrilla from '@salesforce/apex/EvaluacionesController.getGrilla';
import {showError} from 'c/utils';

export default class EvaluacionesDivision extends LightningElement {
    @api recordId;
    @track data = [];
    _materia = '';
    isEditing = false;
    hasErrors = false;

    @track materias = [];


    get hasMateria() {
        return this.materia !== '';
    }

    @api 
    get materia() {
        return this._materia;
    }
    set materia( value ){
        this._materia = value;
    }

    editingStarted() {
        this.isEditing = true;
    }

    editingFinished() {
        this.isEditing = false;
    }
    
    handleMateriasChange (event) {
        this.materia = event.detail.value;
    }

    @wire(getGrilla,{ divisionId: '$recordId'} ) getGrilla(result) {
        if ( result.data ) {            
            try {        
                this.materias =  result.data.map( item => {
                    return {
                        label: item.Materia__r.Name, value: item.Id
                    }
                });
                // Si no tiene una semana, selecciona la primera
                if ( this.materia == 0 && this.materias.length > 0 ) {
                    this.materia = this.materias[0].value;
                }
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