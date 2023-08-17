public with sharing class CicloLectivoTriggerHelper {

    static public Set<Id> getCiclosAnteriores(List<CicloLectivo__c> ciclos) {
        Set<Id> ciclosPrevios = new Set<Id>();
        for ( CicloLectivo__c ciclo: ciclos) {
            if ( !String.isBlank(ciclo.cicloAnterior__c) )  {
                ciclosPrevios.add(ciclo.cicloAnterior__c);
            }
        }
        return ciclosPrevios;
    }
    
    static public void verificarCicloAnterior(List<CicloLectivo__c> newCicloLectivos) {
        Set<Id> ciclosPrevios = getCiclosAnteriores(newCicloLectivos) ;

        List<CicloLectivo__c> cicloAnteriorDuplicado =  [SELECT Id, cicloAnterior__c FROM CicloLectivo__c WHERE cicloAnterior__c IN :ciclosPrevios];

        if ( cicloAnteriorDuplicado.size() > 0 ) {
            Set<Id> ciclosDuplicados = getCiclosAnteriores(cicloAnteriorDuplicado);

            for ( CicloLectivo__c ciclo :newCicloLectivos) {
                if( ciclosDuplicados.contains(ciclo.cicloAnterior__c ) ) {
                    ciclo.addError('El ciclo ' + ciclo.name + ' contiene un ciclo anterior que ya tiene su proximo ciclo ' );
                }
            }
        }
    }

    static public void importDivisiones(List<CicloLectivo__c> newCicloLectivos) {
        Map<Id,Id> mapCiclosPrevios = new Map<Id,Id>();
        for ( CicloLectivo__c ciclo: newCicloLectivos) {
            if ( !String.isBlank(ciclo.cicloAnterior__c) )  {
                mapCiclosPrevios.put(ciclo.cicloAnterior__c, ciclo.Id);
            }
        }
        if ( mapCiclosPrevios.size() > 0 ) {
            List<Division__c> divisiones = [Select Id, anoEscolar__c, subDivision__c, capacidad__c, CicloLectivo__c FROM Division__c WHERE CicloLectivo__c IN :mapCiclosPrevios.keySet()];
            List<Division__c> newDivisiones = new List<Division__c>();

            for( Division__c division: divisiones){
                Division__c newDivision = division.clone(false);                
                newDivision.CicloLectivo__c = mapCiclosPrevios.get(division.CicloLectivo__c);
                newDivisiones.add( newDivision);
            }
            insert newDivisiones;
        }
    }
}