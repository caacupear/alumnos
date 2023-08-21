public with sharing class TriggerHelper {
    static public Set<Id> getIdsFromSObjects(List<SObject> records, String fieldName) {
        Set<Id> values = new Set<Id>();
        for( SObject record: records){
            Id fieldValue = (Id)record.get(fieldName);
            if ( fieldValue != null ){
                values.add(fieldValue);
            }
        }
        return values;
    }    
}