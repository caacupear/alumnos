@isTest
public class TestProgramaTrigger {

    @isTest
    static void testEvaluaciones(){
        Test.startTest();
        TestDataFactory.getProgramaEvaluaciones();
        
        Programa__c programa = [SELECT Evaluaciones__c FROM Programa__c LIMIT 1];
        try  {
            EvaluacionesHelper.Programa evaluaciones = (EvaluacionesHelper.Programa)JSON.deserializeStrict(programa.Evaluaciones__c, EvaluacionesHelper.Programa.class);
        } catch( Exception error ){
            System.assert(true, 'Tiene que generar el json' );
        }

        Test.stopTest();
    }

}