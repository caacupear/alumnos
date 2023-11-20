@IsTest
public class TestEvaluacionesController {

    @IsTest
    static void testGetEvaluaciones(){
        
        Test.startTest();
        Programa__c programa = TestProgramaTrigger.getProgramas().get('P1');
        Division__c division = TestDivisionTrigger.getDivisiones().get('1A');
        Grilla__c grilla = TestGrillaTrigger.getGrilla().get('lengua');
        TestEvaluacionesTrigger.getEvaluaciones();
        Boletin__c boletin = TestBoletinTrigger.getBoletines().get('Juan 1A');

        // asistencias del programa
        EvaluacionesController.getPrograma(programa.Id);

        // asistencias de la grilla
        EvaluacionesHelper.EvaluacionesGrilla result1 =  EvaluacionesController.getByGrilla(grilla.Id);
        System.assertEquals(1, result1.evaluaciones.size());
        
        // asistencias del la division
        EvaluacionesHelper.EvaluacionesDivision result2 =  EvaluacionesController.getByDivision(division.Id, grilla.Id);
        System.assertEquals(2, result2.evaluaciones.size());

        // asistencias del boletin
        EvaluacionesHelper.EvaluacionesBoletin result3 =  EvaluacionesController.getByBoletin(boletin.Id);
        System.assertEquals(1, result3.evaluaciones.size());

        Test.stopTest();   
    }

    @IsTest
    static void testSaveByBoletin(){
        Grilla__c grilla = TestGrillaTrigger.getGrilla().get('lengua');
        Boletin__c boletin = TestBoletinTrigger.getBoletines().get('Juan 1A');        
        
        List<Map<String, Object>>  draftValues = new List<Map<String, Object>>();
        draftValues.add( new Map<String,Object>{ 'Nota1__c' => 10, 'Grilla__c' => grilla.Id } );

        Test.startTest();

        EvaluacionesController.saveByBoletin(boletin.Id, draftValues);

        Test.stopTest();   
    }
 
    @IsTest
    static void testSaveByDivision(){        
        Division__c division = TestDivisionTrigger.getDivisiones().get('1A');
        Grilla__c grilla = TestGrillaTrigger.getGrilla().get('lengua');
        Boletin__c boletin = TestBoletinTrigger.getBoletines().get('Juan 1A');        
        List<Map<String, Object>>  draftValues = new List<Map<String, Object>>();
        draftValues.add( new Map<String,Object>{ 'Nota1__c' => 10, 'id' => boletin.Id } );
        
        Test.startTest();
        
        EvaluacionesController.saveByDivision(division.Id, grilla.Id, draftValues);
    
        Test.stopTest();   
    }

    
    //
    //EvaluacionesController.saveEvaluaciones(evaluaciones)
    
}