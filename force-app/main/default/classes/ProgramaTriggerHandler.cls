public with sharing class ProgramaTriggerHandler implements TriggerHandler {
  private boolean triggerIsExecuting;
  private integer triggerSize;

  public ProgramaTriggerHandler(
    Boolean triggerIsExecuting,
    integer triggerSize
  ) {
    this.triggerIsExecuting = triggerIsExecuting;
    this.triggerSize = triggerSize;
  }

  public void beforeInsert(List<Programa__c> newProgramas) {
    ProgramaHelper.validateContent(newProgramas);
  }

  public void beforeUpdate(
    List<sObject> newProgramas,
    List<sObject> oldProgramas,
    Map<Id, sObject> newProgramaMap,
    Map<Id, sObject> oldProgramaMap
  ) {
    ProgramaHelper.validateContent(newProgramas);
  }

  public void beforeDelete(
    List<sObject> oldProgramas,
    Map<Id, SObject> oldProgramaMap
  ) {
  }

  public void afterInsert(
    List<sObject> newProgramas,
    Map<Id, SObject> newProgramaMap
  ) {
  }

  public void afterUpdate(
    List<sObject> newProgramas,
    List<sObject> oldProgramas,
    Map<Id, SObject> newProgramaMap,
    Map<Id, SObject> oldProgramaMap
  ) {
  }

  public void afterDelete(
    List<sObject> oldProgramas,
    Map<Id, SObject> oldProgramaMap
  ) {
  }

  public void afterUndelete(
    List<sObject> newProgramas,
    Map<Id, SObject> newProgramaMap
  ) {
  }
}
