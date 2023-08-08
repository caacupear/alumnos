public with sharing class TestCicloTrigger {
    static private List<CicloLectivo__c> ciclos; 

    static public List<CicloLectivo__c> getCiclos(){
        if ( ciclos == null) {
            ciclos = new List<CicloLectivo__c>();
            ciclos.add( new CicloLectivo__c( Name = 'Test', Inicio__c = Date.Today().addDays(-1), Fin__c = Date.Today().addDays(120) ) );
            insert ciclos;
        }
        return ciclos;
    }
}