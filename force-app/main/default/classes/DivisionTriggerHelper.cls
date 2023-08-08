public class DivisionTriggerHelper {
    static public void setRecordNames( List<Division__c> divisiones) {
        for( Division__c division : divisiones) {
            division.Name = division.nombre__c;
        }
    }
}