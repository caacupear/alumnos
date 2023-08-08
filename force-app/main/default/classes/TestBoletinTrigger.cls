@IsTest
public class TestBoletinTrigger {
    static private Map<String, Boletin__c> boletines;

    @IsTest
    static void testRecordNames(){
        

        Test.startTest();
        TestBoletinTrigger.getBoletines();
        Division__c division = [Select Name, nombre__c From Division__c Limit 1];
        System.assertEquals(division.Name, division.nombre__c);
        Test.stopTest();
        
    }
    public static Map<String, Boletin__c> getBoletines(){
        if ( boletines == null ) {
            Division__c division = TestDivisionTrigger.getDivisiones().get('1A');
            Contact alumno = TestContactTrigger.getAlumnos().get('Juan');
            boletines = new Map<String, Boletin__c>();
            boletines.put( 'Juan 1A', new Boletin__c( Division__c = division.Id, Alumno__c = alumno.Id) );
            insert boletines.values();
        }
        return boletines;
    }
}