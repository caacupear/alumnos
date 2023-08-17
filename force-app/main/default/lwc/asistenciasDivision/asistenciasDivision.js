import { LightningElement , api, wire, track } from 'lwc';
import getAsistencias from '@salesforce/apex/AsistenciasController.getAsistenciasDivision';

const columns = [
    { label: 'Alumno', fieldName: 'nombreAlumno__c' },
    { label: 'Lunes', fieldName: 'Asistencias__r.Lunes__c' },
    { label: 'Martes', fieldName: 'Asistencias__r.Martes__c' },
    { label: 'Miercoles', fieldName: 'Asistencias__r.Miercoles__c' },
    { label: 'Jueves', fieldName: 'Asistencias__r.Jueves__c' },
    { label: 'Viernes', fieldName: 'Asistencias__r.Viernes__c' }
];

export default class AsistenciasDivision extends LightningElement {
    @api recordId;
    @track semana = 0;
    data = [];
    columns = columns;

    @wire(getAsistencias, { divisionId: '$recordId', semana: '$semana'} ) getData({data, error}) {
        try {
            if ( data ) {     
                console.log(data.asistencias, this.recordId);
                this.data = data.asistencias.map(boletin => {
                    let asistencia = { ...boletin};
                    if ( boletin.Asistencias__r && boletin.Asistencias__r.length > 0 ) {
                        asistencia.Asistencias__r = boletin.Asistencias__r[0];
                    } else {
                        asistencia.Asistencias__r = { Lunes__c: '', Martes__c: '', Miercoles__c: '', Jueves__c: '', Viernes__c: ''}
                    }
                    console.log(asistencia.Asistencias__r);
                    return asistencia;
                })
            }
        } catch( e) {
            console.log(e.message);
        }
    }

}