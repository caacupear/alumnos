import { LightningElement, api, track, wire } from 'lwc';
import getEvaluaciones from '@salesforce/apex/EvaluacionesController.getByDivision';
import getPrograma from '@salesforce/apex/EvaluacionesController.getPrograma';
import {arrayToPicklist, showSuccess, showError} from 'c/utils';
import { refreshApex } from '@salesforce/apex';
import saveEvaluaciones from '@salesforce/apex/EvaluacionesController.saveByDivision';

export default class EvaluacionesTabla extends LightningElement {
    @api divisionId;
    @api grillaId;
    _isLoadingPrograma = true;
    _isLoadingEvaluaciones = true;
    hasErrors = false;
    draftValues = [];

    @track boletines = [];

    get isLoading() {
        return this._isLoadingPrograma && this._isLoadingEvaluaciones;
    }

    @track opciones = {};
    columns = [{ label: 'Alumno', fieldName: 'linkToAlumno', type: 'url', typeAttributes: {label: { fieldName: 'nombreAlumno__c' } }}];

    get data () {
        const evaluaciones =  this.boletines.map(boletin => {
            const evaluacionAlumno = ( boletin.Evaluaciones__r && boletin.Evaluaciones__r.length > 0 ) ? boletin.Evaluaciones__r[0]: {};

            return { id: boletin.Id, 
                linkToAlumno:  '/' + boletin.Id,
                nombreAlumno__c: boletin.nombreAlumno__c,
                ...this.opciones,                
                ...evaluacionAlumno
            };
        });
        return evaluaciones;
    }

    handleCellChange() {
        this.dispatchEvent( new CustomEvent("editstarted") );
    }
    
    handleCancel(event) {
        this.finishEditMode();
    }

    finishEditMode() {
        this.draftValues = [];
        this.dispatchEvent( new CustomEvent("editfinished") );
    }


    async handleSave(event) {
        this.draftValues = event.detail.draftValues;
        try {
            await saveEvaluaciones( { divisionId: this.divisionId, grillaId: this.grillaId, draftValues: this.draftValues} );            

            await refreshApex(this.result);

            this.dispatchEvent( showSuccess('Exito', 'Se actualizaron las evaluaciones!') );
            
            this.finishEditMode();
        } catch (error) {
            this.dispatchEvent( showError('Error', error ) );
        }
    }

    @wire(getPrograma, { divisionId: '$divisionId' } ) getPrograma(result) {
        if ( result.data ) {
            try {
                
                this.columns = this.columns.concat( result.data.evaluaciones.map( item => {
                    if (item.tipo == 'Conceptual')  {
                        this.opciones['opciones_' + item.campo] = arrayToPicklist(item.opciones);                        
                        return { label: item.nombre, fieldName: item.campo, type: 'colorPicklistColumn', editable: true, typeAttributes: {
                                    placeholder: 'Seleccione', options: { fieldName: 'opciones_' + item.campo}, 
                                    value: { fieldName: item.campo }, 
                                    context: { fieldName: 'Id' } 
                                }
                            }
                    } else if (item.tipo == 'Opcion')  {
                        this.opciones['opciones_' + item.campo] = arrayToPicklist(item.opciones);                        
                        return { label: item.nombre, fieldName: item.campo, type: 'colorPicklistColumn', editable: true, typeAttributes: {
                                    placeholder: 'Seleccione', options: { fieldName: 'opciones_' + item.campo}, 
                                    value: { fieldName: item.campo }, 
                                    context: { fieldName: 'Id' } 
                                }
                            }
                    } else if (item.tipo == 'Formula')  {
                        return { label: item.nombre, fieldName: item.campo, editable: false}
                    } else {
                        return { label: item.nombre, fieldName: item.campo, type: 'number', editable: true}
                    }
                } ) );
                this._isLoadingPrograma = false;
            } catch (error) { 
                this.dispatchEvent( showError('Error', error ) );
            }
        }
        if ( result.error ) {
            this.hasErrors = true;
            this.dispatchEvent( showError('Error', result.error ) );
        }
    }

    @wire(getEvaluaciones, { divisionId: '$divisionId', grillaId: '$grillaId'} ) getEvaluaciones(result) {
        if ( result.data ) {
            this.boletines = result.data.evaluaciones;
            this._isLoadingEvaluaciones = false;
        }
        if ( result.error ) {
            this.hasErrors = true;
            this.dispatchEvent( showError('Error', result.error ) );
        }
    }
}