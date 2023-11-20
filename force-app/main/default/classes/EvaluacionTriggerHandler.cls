public without sharing class EvaluacionTriggerHandler implements TriggerHandler{
    private boolean triggerIsExecuting;
    private integer triggerSize;

    public EvaluacionTriggerHandler(Boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<Evaluacion__c> newEvaluaciones){
        EvaluacionTriggerHelper.setUniqueKey(newEvaluaciones); 
    }
    
    public void beforeUpdate(List<sObject> newEvaluaciones, List<sObject> oldEvaluaciones, Map<Id,sObject> newEvaluacionMap, Map<Id,sObject> oldEvaluacionMap){
        EvaluacionTriggerHelper.setUniqueKey(newEvaluaciones); 
    }
	
    public void beforeDelete(List<sObject> oldEvaluaciones, Map<Id,SObject> oldEvaluacionMap){
    }

    public void afterInsert(List<sObject> newEvaluaciones, Map<Id,SObject> newEvaluacionMap){
    }

    public void afterUpdate(List<SObject> newEvaluaciones, List<SObject> oldEvaluaciones, Map<Id,SObject> newEvaluacionMap, Map<Id,SObject> oldEvaluacionMap){
    }

    public void afterDelete(List<sObject> oldEvaluaciones, Map<Id,SObject> oldEvaluacionMap){
    }

    public void afterUndelete(List<sObject> newEvaluaciones, Map<Id,SObject> newEvaluacionMap){
    }
}