@isTest
public class TestDivisionTrigger {
    static private Map<String,Division__c> divisiones;

    @IsTest
    static void testRecordNames(){
        
        Test.startTest();
        // Valida el insert 
        TestDivisionTrigger.getDivisiones();
        Division__c division = [Select Name, nombre__c From Division__c Limit 1];
        System.assertEquals(division.Name, division.nombre__c);
        // Valida el update
        division.anoEscolar__c = 2;
        division.subdivision__c = 'C';
        update division;
        Division__c divisionActualizada = [Select Name, nombre__c From Division__c Limit 1];
        System.assertEquals(divisionActualizada.Name, divisionActualizada.nombre__c);


        Test.stopTest();
        
    }

    static public Map<String, Division__c> getDivisiones(){
        if ( divisiones == null ) {
            CicloLectivo__c ciclo = TestCicloTrigger.getCiclos().get(0);    
            divisiones = new Map<String, Division__c>();
            divisiones.put( '1A', new Division__c( CicloLectivo__c = ciclo.Id, anoEscolar__c = 1, subdivision__c = 'A' ) );
            divisiones.put( '1B', new Division__c( CicloLectivo__c = ciclo.Id, anoEscolar__c = 1, subdivision__c = 'B' ) );
            insert divisiones.values();
        }
        return divisiones;
    }
}