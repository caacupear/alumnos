public with sharing class AsistenciasController {

    @AuraEnabled(cacheable=true)
    public static List<Boletin__c> getAsistencias( Id divisionId, Integer semana){
        try {
            if ( semana == 0 ) {
                semana = Math.ceil(Date.Today().dayOfYear() / 7).intValue();
            }
            
            return [SELECT nombreAlumno__c, 
                    (SELECT Id, Lunes__c, Martes__c, Miercoles__c, Jueves__c, Viernes__c 
                    FROM Asistencias__r 
                    WHERE Semana__c = :semana )  
                FROM Boletin__c 
                WHERE Division__c = :divisionId];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}