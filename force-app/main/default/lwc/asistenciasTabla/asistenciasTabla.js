import { LightningElement , api, wire, track } from 'lwc';
import getAsistencias from '@salesforce/apex/AsistenciasController.getByDivision';
import saveAsistencias from '@salesforce/apex/AsistenciasController.saveByDivision';
import { refreshApex } from '@salesforce/apex';
import { showSuccess, showError } from 'c/utils';
import { diasOptions, rangoNotas, camposDias  } from 'c/constants';

export default class AsistenciaTabla extends LightningElement {
    @api divisionId;
    @api semana;
    @track data = [];
    isLoading = true;
    hasErrors = false;
    draftValues = [];
    result;
    
    get columns() {
        const firstColumn = [{ label: 'Alumno', fieldName: 'linkToAlumno', type: 'url', typeAttributes: {label: { fieldName: 'nombreAlumno__c' } }}];
        
        const columns = camposDias.map( campo => {
            return { label: campo.replace('__c', ''), fieldName: campo, type: 'colorPicklistColumn', editable: true , 
                    typeAttributes: {
                        placeholder: 'Seleccione', options: { fieldName: 'diasOptions' }, 
                        value: { fieldName: campo }, 
                        context: { fieldName: 'Id' } 
                    }
                }
        })
        columns.push({ label: 'Faltas', fieldName: 'Asistencia__c', type: 'colorColumn',
            typeAttributes: {
                ranges: rangoNotas
            }
        });

        return firstColumn.concat(columns);
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
            await saveAsistencias( { divisionId: this.divisionId, semana: this.semana, draftValues: this.draftValues} );            

            await refreshApex(this.result);

            this.dispatchEvent( showSuccess('Exito', 'Se actualizaron las asistencias!') );
            
            this.finishEditMode();
        } catch (error) {
            this.dispatchEvent( showError('Error', error ) );
        }
    }

    @wire(getAsistencias, { divisionId: '$divisionId', semana: '$semana'} ) getAsistencias(result) {            
        this.result = result;
        if ( result.data ) {
            this.data = result.data.boletines.map(boletin => {
                const asistenciaAlumno =  ( boletin.Asistencias__r && boletin.Asistencias__r.length > 0 ) ? boletin.Asistencias__r[0]: {Lunes__c: '', Martes__c: '', Miercoles__c: '', Jueves__c: '', Viernes__c: '', Asistencia__c: 0};
                
                return { id: boletin.Id, 
                    diasOptions: diasOptions, 
                    linkToAlumno:  '/' + boletin.Id,
                    nombreAlumno__c: boletin.nombreAlumno__c,
                    ...asistenciaAlumno
                };
            });

            this.isLoading = false;
        }
        if ( result.error ) {
            this.hasErrors = true;
            this.dispatchEvent( showError('Error', result.error ) );
        }        
    }

}