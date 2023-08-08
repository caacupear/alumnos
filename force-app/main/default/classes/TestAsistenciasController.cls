@IsTest
public class TestAsistenciasController {

    @IsTest
    static void testGetAsistencias(){
        
        Test.startTest();
        Division__c division = TestDivisionTrigger.getDivisiones().get('1A');
        TestAsistenciasTrigger.getAsistencias();
        
        List<Boletin__c> asistencias =  AsistenciasController.getAsistencias(division.Id, 1);
        System.assertEquals(asistencias.size(),1);
        Test.stopTest();
        
    }

}