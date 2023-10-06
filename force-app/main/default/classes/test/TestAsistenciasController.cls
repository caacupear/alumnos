@IsTest
public class TestAsistenciasController {

    @IsTest
    static void testGetAsistencias(){
        
        Test.startTest();
        Division__c division = TestDivisionTrigger.getDivisiones().get('1A');
        TestAsistenciasTrigger.getAsistencias();

        Integer semanaActual = WeekHelper.getWeekOfDate();
        
        AsistenciasHelper.AsistenciasDivision result =  AsistenciasController.getByDivision(division.Id, semanaActual);
        System.assertEquals(2, result.asistencias.size());
        Test.stopTest();   
    }

}