public with sharing class DivisionController {
    
    @AuraEnabled(cacheable=true)
    public static List<CicloLectivo__c> getCiclosVigentes(){
        return [SELECT Id, Name
            FROM CicloLectivo__c ];
    }
}