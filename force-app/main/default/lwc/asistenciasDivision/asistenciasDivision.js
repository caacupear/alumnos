import { LightningElement , api, wire, track } from 'lwc';
import getAsistencias from '@salesforce/apex/AsistenciasController.getAsistenciasDivision';

const columns = [
    { label: 'Alumno', fieldName: 'linkToAlumno', type: 'url', typeAttributes: {label: { fieldName: 'nombreAlumno__c' } }},
    { label: 'Lunes', fieldName: 'Asistencias__r.Lunes__c', editable: true },
    { label: 'Martes', fieldName: 'Asistencias__r.Martes__c' , editable: true},
    { label: 'Miercoles', fieldName: 'Asistencias__r.Miercoles__c' , editable: true},
    { label: 'Jueves', fieldName: 'Asistencias__r.Jueves__c' , editable: true},
    { label: 'Viernes', fieldName: 'Asistencias__r.Viernes__c', editable: true }
];

export default class AsistenciasDivision extends LightningElement {
    @api recordId;
    @track semana = 0;
    data = [];
    columns = columns;
    isEdit = false;
    @track semanas = [];

    handleSemanasChange (event) {
        this.semana = Number.parseInt(event.detail.value);
    }

    handleSave(event) {
        console.log(event.detail.value);
    }

    @wire(getAsistencias, { divisionId: '$recordId', semana: '$semana'} ) getData({data, error}) {
        try {
            if ( data ) {     
                this.semanas = data.semanas.map( semana => {
                    return {label: semana.label, value: semana.numero }
                });

                this.data = data.asistencias.map(boletin => {
                    let asistencia = { ...boletin};
                    asistencia.linkToAlumno =  '/' + boletin.Id; 
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