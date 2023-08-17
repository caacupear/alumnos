import { LightningElement , api, wire, track } from 'lwc';
import getGrilla from '@salesforce/apex/GrillaController.getHorariosDivision';

const columns = [
    { label: 'Horario', fieldName: 'Horario' },
    { label: 'Lunes', fieldName: 'Lunes' },
    { label: 'Martes', fieldName: 'Martes' },
    { label: 'Miercoles', fieldName: 'Miercoles' },
    { label: 'Jueves', fieldName: 'Jueves' },
    { label: 'Viernes', fieldName: 'Viernes' }
];

export default class Grilla extends LightningElement {
    @api recordId;
    data = [];
    columns = columns;

    @wire(getGrilla, { divisionId: '$recordId'} ) getData({data, error}) {
        try {
            if ( data ) {     
                this.data = data;
            }
        } catch( e) {
            console.log(e.message);
        }
    }

}