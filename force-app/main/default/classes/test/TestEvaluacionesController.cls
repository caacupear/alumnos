@IsTest
public class TestEvaluacionesController {

    @IsTest
    static void testGetEvaluaciones(){
        
        Test.startTest();
        Division__c division = TestDataFactory.getDivisiones().get('D-1');
        Grilla__c grilla = TestDataFactory.getGrilla().get('G-1');
        TestDataFactory.getEvaluaciones();
        Boletin__c boletin = TestDataFactory.getBoletines().get('B-1');

        // asistencias del programa
        EvaluacionesController.getPrograma(division.Id);

        // asistencias de la grilla
        EvaluacionesHelper.EvaluacionesGrilla result1 =  EvaluacionesController.getByGrilla(grilla.Id);
        System.assertEquals(1, result1.evaluaciones.size());
        
        // asistencias del la division
        EvaluacionesHelper.EvaluacionesDivision result2 =  EvaluacionesController.getByDivision(division.Id, grilla.Id);
        System.assertEquals(1, result2.evaluaciones.size());

        // asistencias del boletin
        EvaluacionesHelper.EvaluacionesBoletin result3 =  EvaluacionesController.getByBoletin(boletin.Id);
        System.assertEquals(1, result3.evaluaciones.size());

        Test.stopTest();   
    }

    @IsTest
    static void testSaveByBoletin(){
        Grilla__c grilla = TestDataFactory.getGrilla().get('M-1');
        Boletin__c boletin = TestDataFactory.getBoletines().get('B-1');        
        
        List<Map<String, Object>>  draftValues = new List<Map<String, Object>>();
        draftValues.add( new Map<String,Object>{ 'Nota1__c' => 10, 'Grilla__c' => grilla.Id } );

        Test.startTest();

        EvaluacionesController.saveByBoletin(boletin.Id, draftValues);

        Test.stopTest();   
    }
 
    @IsTest
    static void testSaveByDivision(){        
        Division__c division = TestDataFactory.getDivisiones().get('D-1');
        Grilla__c grilla = TestDataFactory.getGrilla().get('M-1');
        Boletin__c boletin = TestDataFactory.getBoletines().get('B-1');        
        List<Map<String, Object>>  draftValues = new List<Map<String, Object>>();
        draftValues.add( new Map<String,Object>{ 'Nota1__c' => 10, 'id' => boletin.Id } );
        
        Test.startTest();
        
        EvaluacionesController.saveByDivision(division.Id, grilla.Id, draftValues);
    
        Test.stopTest();   
    }

    
    //
    //EvaluacionesController.saveEvaluaciones(evaluaciones)
    
}