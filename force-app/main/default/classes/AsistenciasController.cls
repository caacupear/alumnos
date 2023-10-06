public with sharing class AsistenciasController {
    
    @AuraEnabled(cacheable=true)
    public static AsistenciasHelper.AsistenciasCiclo getByCiclo( Id cicloId){
        return new AsistenciasHelper.AsistenciasCiclo(cicloId);
    }
    
    
    @AuraEnabled(cacheable=true)
    public static AsistenciasHelper.AsistenciasBoletin getByBoletin( Id boletinId){
        return  new AsistenciasHelper.AsistenciasBoletin(boletinId);
    }
    
    @AuraEnabled
    public static void saveByBoletin( String boletinId, List<Map<String, Object>> draftValues){
        AsistenciasHelper.AsistenciasBoletin helper = new AsistenciasHelper.AsistenciasBoletin(boletinId);
        helper.save(draftValues);
    }
    @AuraEnabled(cacheable=true)
    public static  List<WeekHelper.Semana> getSemanas( Id divisionId){
        return DivisionHelper.getSemanas(divisionId);
    }

    @AuraEnabled(cacheable=true)
    public static AsistenciasHelper.AsistenciasDivision getByDivision( Id divisionId, Integer semana){
        return  new AsistenciasHelper.AsistenciasDivision(divisionId, semana);        
    }   
    
    @AuraEnabled
    public static void saveByDivision( String divisionId, Integer semana, List<Map<String, Object>> draftValues){
        AsistenciasHelper.AsistenciasDivision helper = new AsistenciasHelper.AsistenciasDivision(divisionId, semana);
        helper.save(draftValues);
    }


}