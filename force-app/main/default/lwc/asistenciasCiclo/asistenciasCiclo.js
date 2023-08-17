import { LightningElement , api, wire, track } from 'lwc';
import getAsistencias from '@salesforce/apex/AsistenciasController.getAsistenciasCiclo';

export default class AsistenciasCiclo extends LightningElement {
    @api recordId;
    data = [];
    columns = [
        { label: 'Division', fieldName: 'Division__r.Name' },
    ];

    @wire(getAsistencias, { cicloId: '$recordId'} ) getData({data, error}) {
        try {
            columns
            if ( data ) { 
                console.log(data);
            }
        } catch( e) {
            console.log(e.message);
        }
    }

}