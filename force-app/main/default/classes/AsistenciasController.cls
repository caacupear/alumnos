public with sharing class AsistenciasController {

    @AuraEnabled(cacheable=true)
    public static AsistenciasHelper.AsistenciasCiclo getAsistenciasCiclo( Id cicloId){
        return new AsistenciasHelper.AsistenciasCiclo(cicloId);
    }

    @AuraEnabled(cacheable=true)
    public static AsistenciasHelper.AsistenciasDivision getAsistenciasDivision( Id divisionId, Integer semana){
        return  new AsistenciasHelper.AsistenciasDivision(divisionId, semana);        
    }   
    
    @AuraEnabled(cacheable=true)
    public static AsistenciasHelper.AsistenciasBoletin getAsistenciasBoletin( Id boletinId){
        return  new AsistenciasHelper.AsistenciasBoletin(boletinId);
    }

    @AuraEnabled(cacheable=false)
    public static void saveAsistencias( Id divisionId, Integer semana, List<Asistencia__c> asistencias){
        AsistenciasHelper.AsistenciasDivision helper = new AsistenciasHelper.AsistenciasDivision(divisionId, semana);        
        helper.save(asistencias);
    }

}