public with sharing class EvaluacionesController {

    @AuraEnabled(cacheable=true)
    public static EvaluacionesHelper.EvaluacionesGrilla getByGrilla( Id grillaId){
        return new EvaluacionesHelper.EvaluacionesGrilla(grillaId);
    }

    @AuraEnabled(cacheable=true)
    public static EvaluacionesHelper.EvaluacionesDivision getByDivision( Id divisionId,  Id grillaId){
        return  new EvaluacionesHelper.EvaluacionesDivision(divisionId, grillaId);        
    }   
    
    @AuraEnabled
    public static void saveByDivision( String divisionId, String grillaId, List<Map<String, Object>> draftValues){
        EvaluacionesHelper.EvaluacionesDivision helper = new EvaluacionesHelper.EvaluacionesDivision(divisionId, grillaId);
        helper.save(draftValues);
    }
    
    @AuraEnabled(cacheable=true)
    public static EvaluacionesHelper.EvaluacionesBoletin getByBoletin( Id boletinId){
        return  new EvaluacionesHelper.EvaluacionesBoletin(boletinId);
    }

    @AuraEnabled
    public static void saveByBoletin( String boletinId, List<Map<String, Object>> draftValues){
        EvaluacionesHelper.EvaluacionesBoletin helper = new EvaluacionesHelper.EvaluacionesBoletin(boletinId);
        helper.save(draftValues);
    }

    @AuraEnabled(cacheable=true)
    public static List<Grilla__c>  getGrilla( Id divisionId){
        return DivisionHelper.getGrilla(divisionId);
    }

    @AuraEnabled(cacheable=true)
    public static EvaluacionesHelper.Programa  getPrograma( Id divisionId){
        return EvaluacionesHelper.getPrograma(divisionId);
    }


    @AuraEnabled(cacheable=false)
    public static void saveEvaluaciones( List<Evaluacion__c> evaluaciones){
    }

}