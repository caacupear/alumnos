public with sharing class EvaluacionesController {

    @AuraEnabled(cacheable=true)
    public static EvaluacionesHelper.EvaluacionesGrilla getEvaluacionesGrilla( Id grillaId){
        return new EvaluacionesHelper.EvaluacionesGrilla(grillaId);
    }

    @AuraEnabled(cacheable=true)
    public static EvaluacionesHelper.EvaluacionesDivision getEvaluacionesDivision( Id divisionId){
        return  new EvaluacionesHelper.EvaluacionesDivision(divisionId);        
    }   
    
    @AuraEnabled(cacheable=true)
    public static EvaluacionesHelper.EvaluacionesBoletin getEvaluacionesBoletin( Id boletinId){
        return  new EvaluacionesHelper.EvaluacionesBoletin(boletinId);
    }

    // @AuraEnabled(cacheable=false)
    // public static void saveEvaluaciones( List<Evaluacion__c> evaluaciones){
    // }

}