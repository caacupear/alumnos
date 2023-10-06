@isTest
public class TestProgramaTrigger {
    static private Map<String,Programa__c> programas;

    static public Map<String, Programa__c> getProgramas(){
        if ( programas == null ) {
            programas = new Map<String, Programa__c>();
            programas.put( 'programa1', new Programa__c( Name = 'programa' ) );
            insert programas.values();
        }
        return programas;
    }
}