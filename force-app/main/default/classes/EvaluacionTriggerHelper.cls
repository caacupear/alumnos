public with sharing class EvaluacionTriggerHelper {
    
    static public void setUniqueKey( List<Evaluacion__c> evaluaciones) {
        for( Evaluacion__c evaluacion :evaluaciones) {
            if ( evaluacion.UniqueKey__c == null  ) {
                evaluacion.UniqueKey__c = EvaluacionesHelper.getUniqueKey(evaluacion);
            }
        }
    }

}