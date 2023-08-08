public with sharing class BoletinTriggerHelper {
    static public void setRecordNames( List<Boletin__c> boletines) {
        for( Boletin__c boletin :boletines) {
            boletin.Name = boletin.nombreAlumno__c + ' ' + boletin.nombreDivision__c;
        }
    }
}