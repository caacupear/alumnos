public without sharing class ConstanciaTriggerHandler implements TriggerHandler{
    private boolean triggerIsExecuting;
    private integer triggerSize;

    public ConstanciaTriggerHandler(Boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<Constancia__c> newConstancias){
        ConstanciaHelper.validateContent(newConstancias);
    }
    
    public void beforeUpdate(List<sObject> newConstancias, List<sObject> oldConstancias, Map<Id,sObject> newConstanciaMap, Map<Id,sObject> oldConstanciaMap){
        ConstanciaHelper.validateContent(newConstancias);    
    }
	
    public void beforeDelete(List<sObject> oldConstancias, Map<Id,SObject> oldConstanciaMap){
    }

    public void afterInsert(List<sObject> newConstancias, Map<Id,SObject> newConstanciaMap){
    }

    public void afterUpdate(List<SObject> newConstancias, List<SObject> oldConstancias, Map<Id,SObject> newConstanciaMap, Map<Id,SObject> oldConstanciaMap){
    }

    public void afterDelete(List<sObject> oldConstancias, Map<Id,SObject> oldConstanciaMap){
    }

    public void afterUndelete(List<sObject> newConstancias, Map<Id,SObject> newConstanciaMap){
    }
}