public with sharing class GrillaController {
    
    
    @AuraEnabled(cacheable=true)
    public static List<Grilla__c> getHorariosDivision( Id divisionId){
        try {            
            return [SELECT Materia__c, Materia__r.Name,
            (SELECT dia__c, desde__c, hasta__c
            FROM GrillaHorarios__r )  
            FROM Grilla__c 
            WHERE Division__c = :divisionId];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Grilla__c> getHorariosDocente( Id docenteId){
        try {            
            return [SELECT  Materia__c, Materia__r.Name,
            (SELECT dia__c, desde__c, hasta__c
            FROM GrillaHorarios__r )  
            FROM Grilla__c 
            WHERE Docente__c = :docenteId OR Auxiliar__c = :docenteId];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

    }

}