import { LightningElement , api, wire } from 'lwc';
import getAsistencias from '@salesforce/apex/AsistenciasController.getByBoletin';
import saveBoletines from '@salesforce/apex/AsistenciasController.saveByBoletin';
import { refreshApex } from '@salesforce/apex';
import { showSuccess, showError } from 'c/utils';
import { diasOptions, rangoNotas, camposDias  } from 'c/constants';

export default class AsistenciasBoletin extends LightningElement {
    @api recordId;
    data = [];
    draftValues = [];
    isLoading = true;
    hasErrors = false;

    get columns() {
        const firstColumn = [{ label: 'Semana', fieldName: 'linkToAsistencia', type: 'url', typeAttributes: {label: { fieldName: 'Semana' } }}];
        
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

    @wire(getAsistencias, { boletinId: '$recordId'} ) getData(result) {
        this.result = result;
        if ( result.data ) {
            this.data = result.data.asistencias.map(asistencia => {               
                return { 
                    ...asistencia,
                    linkToAsistencia:  '/' + asistencia.Id,
                    Semana: '#' + asistencia.Semana__c ,
                    diasOptions: diasOptions
                };
            });

            this.isLoading = false;
        }
        if ( result.error ) {
            this.hasErrors = true;
            this.dispatchEvent( showError('Error', result.error ) );
        }
    }

    async handleSave(event) {
        this.draftValues = event.detail.draftValues;

        try {
            await saveBoletines( { boletinId: this.recordId, draftValues: this.draftValues} );            
                                    
            await refreshApex(this.result);

            this.dispatchEvent( showSuccess('Exito', 'Se actualizaron las asistencias!') );
            
            this.draftValues = [];
        } catch (error) {
            this.dispatchEvent( showError('Error', error ) );
        }
    }


}