public without sharing class BoletinTriggerHandler implements TriggerHandler{
    private boolean triggerIsExecuting;
    private integer triggerSize;

    public BoletinTriggerHandler(Boolean triggerIsExecuting, integer triggerSize) {
        this.triggerIsExecuting = triggerIsExecuting;
        this.triggerSize = triggerSize;
    }

    public void beforeInsert(List<Boletin__c> newBoletines){
        BoletinTriggerHelper.setRecordNames(newBoletines);
        BoletinTriggerHelper.validateDuplicates(newBoletines);
    }
    
    public void beforeUpdate(List<sObject> newBoletines, List<sObject> oldBoletines, Map<Id,sObject> newBoletinMap, Map<Id,sObject> oldBoletinMap){
        BoletinTriggerHelper.setRecordNames(newBoletines);
        BoletinTriggerHelper.validateDuplicates(newBoletinMap, oldBoletinMap);
    }
	
    public void beforeDelete(List<sObject> oldBoletines, Map<Id,SObject> oldBoletinMap){
    }

    public void afterInsert(List<sObject> newBoletines, Map<Id,SObject> newBoletinMap){
        // Rollup de Inscriptpos: Por cada Boletin nuevo incrementar los inscriptos
        Set<Id> divisiones = BoletinTriggerHelper.getDivisiones(newBoletines);
        BoletinTriggerHelper.updateRollupDivisiones(divisiones);
        // Actualiza el ultimo boletin en el alumno
        BoletinTriggerHelper.updateLastBoletin(newBoletines);        

        // Actualiza el Estado a Inscripto
        Set<Id> alumnos = BoletinTriggerHelper.getAlumnos(newBoletines);
        BoletinTriggerHelper.setInscriptoAlumno(alumnos);        
    }

    public void afterUpdate(List<SObject> newBoletines, List<SObject> oldBoletines, Map<Id,SObject> newBoletinMap, Map<Id,SObject> oldBoletinMap){
        // Rollup de Inscriptpos: Por cada Boletin si cambia la division debe incrementar y decrementar los inscriptos
        Set<Id> divisiones =  BoletinTriggerHelper.getChangeDivisiones((Map<Id,Boletin__c>)newBoletinMap, (Map<Id,Boletin__c>)oldBoletinMap);                
        BoletinTriggerHelper.updateRollupDivisiones(divisiones);        
    }

    public void afterDelete(List<sObject> oldBoletines, Map<Id,SObject> oldBoletinMap){
        // Rollup de Inscriptpos: Por cada Boletin que se borra decrementa los inscriptos
        Set<Id> divisiones = BoletinTriggerHelper.getDivisiones(oldBoletines);
        BoletinTriggerHelper.updateRollupDivisiones(divisiones);        
    }

    public void afterUndelete(List<sObject> newBoletines, Map<Id,SObject> newBoletinMap){
        // Rollup de Inscriptpos: Por cada Boletin nuevo incrementar los inscriptos
        Set<Id> divisiones = BoletinTriggerHelper.getDivisiones(newBoletines);
        BoletinTriggerHelper.updateRollupDivisiones(divisiones);        
    }
}