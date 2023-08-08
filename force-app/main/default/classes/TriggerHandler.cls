public interface TriggerHandler {

    // ********** before methods *******************
    void beforeInsert(List<SObject> newRecords);
    void beforeUpdate(List<SObject> newRecords, List<SObject> oldRecords, 
                      Map<Id,SObject> newRecordMap,Map<Id,SObject> oldRecordMap);
    void beforeDelete(List<SObject> oldRecords, Map<Id,SObject> oldRecordMap);

    // *********** after methods ********************
    void afterInsert(List<SObject> newRecords, Map<Id,SObject> newRecordMap);
    void afterUpdate(List<SObject> newRecords, List<SObject> oldRecords, 
                     Map<Id,SObject> newRecordMap, Map<Id,SObject> oldRecordMap);
    void afterDelete(List<SObject> oldRecords, Map<Id, SObject> oldRecordMap);
    void afterUndelete(List<SObject> newRecords, Map<Id,SObject> newRecordMap);
}