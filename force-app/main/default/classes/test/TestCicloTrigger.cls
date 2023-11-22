@IsTest
public class TestCicloTrigger {

    @IsTest
    static void testProximoCiclo(){
        Test.startTest();

        CicloLectivo__c cicloAnterior = TestDataFactory.getCiclos().get('CA-1');

        insert new CicloLectivo__c( Name = 'ciclo2', cicloAnterior__c = cicloAnterior.Id, Inicio__c = Date.Today().addDays(-1), Fin__c = Date.Today().addDays(120) );

        try {
            insert new CicloLectivo__c( Name = 'ciclo3', cicloAnterior__c = cicloAnterior.Id, Inicio__c = Date.Today().addDays(-1), Fin__c = Date.Today().addDays(120) );
            System.assert(false, 'No valido ciclo anterior');
        } catch (DmlException ex) {
            //System.assert(ex.getMessage().contains('contiene un ciclo anterior que ya tiene su proximo ciclo'));
        }
        Test.stopTest();

    }

    @IsTest
    static void testImportarDivisiones(){
        Test.startTest();

        CicloLectivo__c cicloAnterior = TestDataFactory.getCiclos().get('CA-1');
        Integer totalDivisiones = TestDataFactory.getDivisiones().size();
        
        CicloLectivo__c newCiclo = new CicloLectivo__c( Name = 'proximo ciclo', cicloAnterior__c = cicloAnterior.Id, Inicio__c = Date.Today().addDays(-1), Fin__c = Date.Today().addDays(120) );
        insert newCiclo;
    
        List<Division__c> divisiones =  [SELECT Id FROM Division__c Where CicloLectivo__c = :newCiclo.Id];
        System.assertEquals(totalDivisiones, divisiones.size());
        Test.stopTest();
    }

}