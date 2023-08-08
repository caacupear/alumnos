public without sharing class BoletinTriggerHandler implements TriggerHandler{
    private boolean triggerIsExecuting;
    private integer triggerSize;

    public BoletinTriggerHandler(Boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<Boletin__c> newBoletines){
        BoletinTriggerHelper.setRecordNames(newBoletines);
    }
    
    public void beforeUpdate(List<sObject> newBoletines, List<sObject> oldAccopunts, Map<Id,sObject> newBoletinMap, Map<Id,sObject> oldBoletinMap){
        BoletinTriggerHelper.setRecordNames(newBoletines);
    }
	
    public void beforeDelete(List<sObject> oldBoletines, Map<Id,SObject> oldBoletinMap){
    }

    public void afterInsert(List<sObject> newBoletines, Map<Id,SObject> newBoletinMap){
    }

    public void afterUpdate(List<sObject> newBoletines, List<sObject> oldBoletines, Map<Id,SObject> newBoletinMap, Map<Id,SObject> oldBoletinMap){
    }

    public void afterDelete(List<sObject> oldBoletines, Map<Id,SObject> oldBoletinMap){
    }

    public void afterUndelete(List<sObject> newBoletines, Map<Id,SObject> newBoletinMap){
    }
}