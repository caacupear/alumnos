public without sharing class AsistenciaTriggerHandler implements TriggerHandler{
    private boolean triggerIsExecuting;
    private integer triggerSize;

    public AsistenciaTriggerHandler(Boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<Asistencia__c> newAsistencias){
        AsistenciaTriggerHelper.setCalculatedValues(newAsistencias); 
        AsistenciaTriggerHelper.validateFields(newAsistencias);                
    }
    
    public void beforeUpdate(List<sObject> newAsistencias, List<sObject> oldAsistencias, Map<Id,sObject> newAsistenciaMap, Map<Id,sObject> oldAsistenciaMap){
        AsistenciaTriggerHelper.setCalculatedValues(newAsistencias);
        AsistenciaTriggerHelper.validateFields(newAsistencias); 
    }
	
    public void beforeDelete(List<sObject> oldAsistencias, Map<Id,SObject> oldAsistenciaMap){
    }

    public void afterInsert(List<sObject> newAsistencias, Map<Id,SObject> newAsistenciaMap){
    }

    public void afterUpdate(List<SObject> newAsistencias, List<SObject> oldAsistencias, Map<Id,SObject> newAsistenciaMap, Map<Id,SObject> oldAsistenciaMap){
    }

    public void afterDelete(List<sObject> oldAsistencias, Map<Id,SObject> oldAsistenciaMap){
    }

    public void afterUndelete(List<sObject> newAsistencias, Map<Id,SObject> newAsistenciaMap){
    }
}