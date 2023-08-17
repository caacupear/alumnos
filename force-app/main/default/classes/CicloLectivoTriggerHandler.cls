public with sharing class CicloLectivoTriggerHandler implements TriggerHandler{
    private boolean triggerIsExecuting;
    private integer triggerSize;

    public CicloLectivoTriggerHandler(Boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<CicloLectivo__c> newCicloLectivos){
        CicloLectivoTriggerHelper.verificarCicloAnterior(newCicloLectivos);
    }
    
    public void beforeUpdate(List<sObject> newCicloLectivos, List<sObject> oldAccopunts, Map<Id,sObject> newCicloLectivoMap, Map<Id,sObject> oldCicloLectivoMap){
    }
    
    public void beforeDelete(List<sObject> oldCicloLectivos, Map<Id,SObject> oldCicloLectivoMap){
    }

    public void afterInsert(List<sObject> newCicloLectivos, Map<Id,SObject> newCicloLectivoMap){
        CicloLectivoTriggerHelper.importDivisiones(newCicloLectivos);
    }

    public void afterUpdate(List<sObject> newCicloLectivos, List<sObject> oldCicloLectivos, Map<Id,SObject> newCicloLectivoMap, Map<Id,SObject> oldCicloLectivoMap){
    }

    public void afterDelete(List<sObject> oldCicloLectivos, Map<Id,SObject> oldCicloLectivoMap){
    }

    public void afterUndelete(List<sObject> newCicloLectivos, Map<Id,SObject> newCicloLectivoMap){
    }
}