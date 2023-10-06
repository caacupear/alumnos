import { LightningElement , api, wire, track } from 'lwc';
import getSemanas from '@salesforce/apex/AsistenciasController.getSemanas';

export default class AsistenciasDivision extends LightningElement {
    @api recordId;
    _semana = 0;
    @track semanas = [];
    isEditing = false;

    @api 
    get semana() {
        return this._semana;
    }
    set semana( value ){
        if ( Number.isNaN(value) ){
            return;
        }
        this._semana = Number.parseInt(value);
    }

    handleSemanasChange (event) {
        this.semana = event.detail.value;
    }

    get hasSemana() {
        return this.semana !== 0;
    }

    editingStarted() {
        this.isEditing = true;
    }

    editingFinished() {
        this.isEditing = false;
    }

    @wire(getSemanas, { divisionId: '$recordId'} ) getSemanas({data, error}) {
        try {
            if ( data ) {
                this.semanas = data.map( semana => {
                    return {label: semana.label, value: semana.numero }
                });
                // Si no tiene una semana, selecciona la primera
                if ( this.semana == 0 && data.length > 0 ) {
                    this.semana = data[0].numero;
                }
            }
        } catch( e) {
            console.log(e.message);
        }
    }        
}