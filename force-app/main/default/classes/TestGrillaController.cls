@IsTest
public with sharing class TestGrillaController {
    @IsTest
    static void testGetHorarioDivision(){
        
        Test.startTest();
        Division__c division = TestDivisionTrigger.getDivisiones().get('1A');
        TestGrillaTrigger.getGrilla();
        
        List<Grilla__c> grilla =  GrillaController.getHorariosDivision(division.Id);
        System.assertEquals(grilla.size(),1);
        Test.stopTest();
        
    }

    @IsTest
    static void testGetHorarioDocente(){
        
        Test.startTest();
        TestGrillaTrigger.getGrilla();
        Contact docente = TestContactTrigger.getDocentes().get('Pedro');

        List<Grilla__c> grilla =  GrillaController.getHorariosDocente(docente.Id);
        System.assertEquals(grilla.size(),1);
        Test.stopTest();
        
    }

}