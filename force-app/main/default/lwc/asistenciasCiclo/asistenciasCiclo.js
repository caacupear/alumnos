import { LightningElement , api, wire, track } from 'lwc';
import getAsistencias from '@salesforce/apex/AsistenciasController.getByCiclo';
 

export default class AsistenciasCiclo extends LightningElement {
    @api recordId;
    @track data = [];
    _columns = [];

    get columns() {
        return this._columns;
    }

    @wire(getAsistencias, { cicloId: '$recordId'} ) getData(result) {
        if ( result.data ) { 
            const weekMap = {};      
            const divisiones = {};      
            for( const item of result.data.asistencias ) {
                if ( item.Division__c && item.Name) {
                    divisiones[item.Division__c] = item.Name;
                } 
                if ( weekMap[item.SemanaText__c] ) {
                    weekMap[item.SemanaText__c].push(item);
                } else {
                    weekMap[item.SemanaText__c] = [item];
                }
            }
            
            this.data = [];
            for( const SemanaText in weekMap ) {
                const items = weekMap[SemanaText]
                const row = { SemanaText__c: SemanaText }
                for( const item of items ) {
                    row[item.Division__c] = item.Faltas;
                    row['linkTo' + item.Division__c] = '/' + item.Division__c + '?'; // deberia ir la semana                    
                }
                this.data.push(row);
            }

            this._columns = [{ label: 'Semana', fieldName: 'SemanaText__c'}];            
            for( const divisionId in divisiones ) {
                this._columns.push ( { 
                    label: divisiones[divisionId], 
                    fieldName: `linkTo${divisionId}`, 
                    type: 'url', 
                    typeAttributes: {label: { fieldName: divisionId }}                                 
                });
            }                
        }
    }

}