@IsTest
public class TestAsistenciasController {

    @IsTest
    static void testGetAsistencias(){
        
        Test.startTest();
        Division__c division = TestDataFactory.getDivisiones().get('D-1');
        TestDataFactory.getAsistencias();

        // getSemanas de una division        
        AsistenciasController.getSemanas(division.Id);
        
        // asistencias de la division
        AsistenciasHelper.AsistenciasDivision result1 =  AsistenciasController.getByDivision(division.Id, 1);
        System.assertEquals(1, result1.asistencias.size());

        // asistencias del ciclo
        AsistenciasHelper.AsistenciasCiclo result2 =  AsistenciasController.getByCiclo(division.CicloLectivo__c);
        System.assertEquals(2, result2.asistencias.size());

        // asistencias del boletin
        Boletin__c boletin = TestDataFactory.getBoletines().get('B-1');        
        AsistenciasHelper.AsistenciasBoletin result3 =  AsistenciasController.getByBoletin(boletin.Id);
        System.assertEquals(2, result3.asistencias.size());

        Test.stopTest();   
    }

    @IsTest
    static void testSaveByBoletin(){
        
        List<Map<String, Object>>  draftValues = new List<Map<String, Object>>();
        draftValues.add( new Map<String,Object>{ 'Martes__c' => 'Asistio', 'Semana__c' => 1 } );

        Test.startTest();
        Boletin__c boletin = TestDataFactory.getBoletines().get('B-1');        

        AsistenciasController.saveByBoletin(boletin.Id, draftValues);

        Test.stopTest();   
    }
 
    @IsTest
    static void testSaveByDivision(){        
        Boletin__c boletin = TestDataFactory.getBoletines().get('B-1');        
        List<Map<String, Object>>  draftValues = new List<Map<String, Object>>();
        draftValues.add( new Map<String,Object>{ 'Martes__c' => 'Asistio', 'id' => boletin.Id } );
        
        Test.startTest();
        Division__c division = TestDataFactory.getDivisiones().get('D-1');
        
        AsistenciasController.saveByDivision(division.Id, 1, draftValues);
    
        Test.stopTest();   
    }
 
}