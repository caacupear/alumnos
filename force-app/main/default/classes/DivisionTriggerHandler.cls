public without sharing class DivisionTriggerHandler implements TriggerHandler{
    private boolean triggerIsExecuting;
    private integer triggerSize;

    public DivisionTriggerHandler(Boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<Division__c> newDivisions){
        DivisionTriggerHelper.setRecordNames(newDivisions);
    }
    
    public void beforeUpdate(List<sObject> newDivisions, List<sObject> oldAccopunts, Map<Id,sObject> newDivisionMap, Map<Id,sObject> oldDivisionMap){
        DivisionTriggerHelper.setRecordNames(newDivisions);
    }
	
    public void beforeDelete(List<sObject> oldDivisions, Map<Id,SObject> oldDivisionMap){
    }

    public void afterInsert(List<sObject> newDivisions, Map<Id,SObject> newDivisionMap){
    }

    public void afterUpdate(List<sObject> newDivisions, List<sObject> oldDivisions, Map<Id,SObject> newDivisionMap, Map<Id,SObject> oldDivisionMap){
    }

    public void afterDelete(List<sObject> oldDivisions, Map<Id,SObject> oldDivisionMap){
    }

    public void afterUndelete(List<sObject> newDivisions, Map<Id,SObject> newDivisionMap){
    }
}