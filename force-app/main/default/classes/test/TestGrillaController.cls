@IsTest
public class TestGrillaController {
    @IsTest
    static void testGetHorarioDivision(){
        
        // DADA una Division CUANDO se llama al api getHorariosDivision ENTONCES trae la grilla de la Division
        Test.startTest();
        Division__c division = TestDataFactory.getDivisiones().get('D-1');
        TestDataFactory.getGrilla();
        
        List<Grilla__c> grilla =  GrillaController.getHorariosDivision(division.Id);
        System.assertEquals(1, grilla.size());
        Test.stopTest();
        
    }

    @IsTest
    static void testGetHorarioDocente(){
        
        // DADO un docente CUANDO se llama al api getHorariosDocente ENTONCES trae la grilla del docente
        Test.startTest();
        TestDataFactory.getGrilla();
        Contact docente = TestDataFactory.getDocentes().get('D-1');

        List<Grilla__c> grilla =  GrillaController.getHorariosDocente(docente.Id);
        System.assertEquals(1, grilla.size());
        Test.stopTest();
        
    }

}