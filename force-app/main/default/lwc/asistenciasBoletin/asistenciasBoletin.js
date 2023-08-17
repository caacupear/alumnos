import { LightningElement , api, wire, track } from 'lwc';
import getAsistencias from '@salesforce/apex/AsistenciasController.getAsistenciasBoletin';

const columns = [
    { label: 'Semana', fieldName: 'semana__c' },
    { label: 'Lunes', fieldName: 'Lunes__c' },
    { label: 'Martes', fieldName: 'Martes__c' },
    { label: 'Miercoles', fieldName: 'Miercoles__c' },
    { label: 'Jueves', fieldName: 'Jueves__c' },
    { label: 'Viernes', fieldName: 'Viernes__c' }
];

export default class AsistenciasBoletin extends LightningElement {
    @api recordId;
    data = [];
    columns = columns;

    @wire(getAsistencias, { boletinId: '$recordId'} ) getData({data, error}) {
        try {
            console.log(data);
            if ( data ) {            
                this.data = data.asistencias;
            }
        } catch( e) {
            console.log(e.message);
        }
    }
}