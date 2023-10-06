public with sharing class ProgramaEvaluacionTriggerHandler implements TriggerHandler{
        private boolean triggerIsExecuting;
        private integer triggerSize;
    
        public ProgramaEvaluacionTriggerHandler(Boolean triggerIsExecuting, integer triggerSize) {
            this.triggerIsExecuting = triggerIsExecuting;
            this.triggerSize = triggerSize;
        }
    
        public void beforeInsert(List<ProgramaEvaluacion__c> newEvaluaciones){
        }
        
        public void beforeUpdate(List<sObject> newEvaluaciones, List<sObject> oldEvaluaciones, Map<Id,sObject> newProgramaEvaluacionMap, Map<Id,sObject> oldProgramaEvaluacionMap){
        }
        
        public void beforeDelete(List<sObject> oldEvaluaciones, Map<Id,SObject> oldProgramaEvaluacionMap){
        }
    
        public void afterInsert(List<sObject> newEvaluaciones, Map<Id,SObject> newProgramaEvaluacionMap){
            ProgramaEvaluacionTriggerHelper.updatePrograma(newEvaluaciones);
        }
    
        public void afterUpdate(List<sObject> newEvaluaciones, List<sObject> oldEvaluaciones, Map<Id,SObject> newProgramaEvaluacionMap, Map<Id,SObject> oldProgramaEvaluacionMap){
            // Como es master detail new y old son los mismos programas
            ProgramaEvaluacionTriggerHelper.updatePrograma(newEvaluaciones);
        }
    
        public void afterDelete(List<sObject> oldEvaluaciones, Map<Id,SObject> oldProgramaEvaluacionMap){
            ProgramaEvaluacionTriggerHelper.updatePrograma(oldEvaluaciones);
        }
    
        public void afterUndelete(List<sObject> newEvaluaciones, Map<Id,SObject> newProgramaEvaluacionMap){
            ProgramaEvaluacionTriggerHelper.updatePrograma(newEvaluaciones);
        }
    }