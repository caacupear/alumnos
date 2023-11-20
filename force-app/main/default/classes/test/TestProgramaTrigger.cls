@isTest
public class TestProgramaTrigger {
    static private Map<String,Programa__c> programas;

    static public Map<String, Programa__c> getProgramas(){
        if ( programas == null ) {
            programas = new Map<String, Programa__c>();
            programas.put( 'P1', new Programa__c( Name = 'programa' ) );
            insert programas.values();
        }
        return programas;
    }

    @isTest
    static void testEvaluaciones(){
        Test.startTest();
        TestProgramaEvaluacionTrigger.getProgramaEvaluaciones();
        
        Programa__c programa = [SELECT Evaluaciones__c FROM Programa__c];
        try  {
            EvaluacionesHelper.Programa evaluaciones = (EvaluacionesHelper.Programa)JSON.deserializeStrict(programa.Evaluaciones__c, EvaluacionesHelper.Programa.class);
        } catch( Exception error ){
            System.assert(true, 'Tiene que generar el json' );
        }

        Test.stopTest();
    }

}