@IsTest
public class TestBoletinTrigger {
    static private Map<String, Boletin__c> boletines;

    @IsTest
    static void testInscriptos(){
        Test.startTest();
        // CUANDO se crea un boletin de un alumno en lista de espera ENTONCES el alumno pasa a Inscripto
        Boletin__c boletinJuan = TestBoletinTrigger.getBoletines().get('Juan 1A');
        Contact Juan = [Select estadoInscripcion__c FROM Contact WHERE Id =:boletinJuan.Alumno__c];
        System.assertEquals('Inscripto', Juan.estadoInscripcion__c);

        Test.stopTest();
    }


    @IsTest
    static void testRollupInscriptos(){
        Decimal inscriptos;

        Test.startTest();
        // CUANDO crea un Boletin ENTONCES debe incrementar los inscriptos en la division
        TestBoletinTrigger.getBoletines();
        Division__c division1A = TestDivisionTrigger.getDivisiones().get('1A');
        inscriptos = [Select Inscriptos__c From Division__c WHERE Id = :division1A.Id].Inscriptos__c;
        System.assertEquals(2, inscriptos);

        // CUANDO cambia la division de un boletin ENTONCES verifica que se baje el inscripto de la division vieja y se sume en la nueva
        Boletin__c boletinJose = TestBoletinTrigger.getBoletines().get('Jose 1A');
        Division__c division1B = TestDivisionTrigger.getDivisiones().get('1B');
        boletinJose.Division__c = division1B.Id;
        update boletinJose;

        inscriptos = [Select Inscriptos__c From Division__c WHERE Id = :division1A.Id].Inscriptos__c;
        System.assertEquals(1, inscriptos);

        inscriptos = [Select Inscriptos__c From Division__c WHERE Id = :division1B.Id].Inscriptos__c;
        System.assertEquals(1, inscriptos);

        // CUANDO se elimina un boletin ENTONCES verifica que se baje la cantidad de inscriptos
        delete boletinJose;
        inscriptos = [Select Inscriptos__c From Division__c WHERE Id = :division1B.Id].Inscriptos__c;
        System.assertEquals(0, inscriptos);

        Test.stopTest();
    }
        

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
            boletines.put( 'Jose 1A', new Boletin__c( Division__c = division.Id, Alumno__c = alumno.Id) );
            insert boletines.values();
        }
        return boletines;
    }
}