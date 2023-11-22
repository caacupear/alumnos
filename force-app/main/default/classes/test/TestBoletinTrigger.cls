@IsTest
public class TestBoletinTrigger {

    @IsTest
    static void testDuplicates(){
        Test.startTest();
        Division__c division1A = TestDataFactory.getDivisiones().get('D-1');
        Division__c division1B = TestDataFactory.getDivisiones().get('D-2');
        Contact alumnoJuan = TestDataFactory.getAlumnos().get('A-1');
        Contact alumnoAna = TestDataFactory.getAlumnos().get('A-2');

        Boletin__c boletinJuan1A = new Boletin__c( Division__c = division1A.Id, Alumno__c = alumnoJuan.Id);
        insert boletinJuan1A;

        // DADO un alumno que ya existe en un curso CUANDO se crea otro boletin para ese alumno ENTONCES debe dar un error por Duplicado
        try {
            insert new Boletin__c( Division__c = division1A.Id, Alumno__c = alumnoJuan.Id) ;
            System.assert(false, 'No valido duplicados');
        } catch (DmlException ex) {
            System.debug(ex.getMessage());
            //System.assert(ex.getMessage().contains('duplicado'));
        }

        // CUANDO se quiere crear dos boletines para un alumno en la misma division ENTONCES debe dar un error por Duplicado
        List<Boletin__c> duplicados = new List<Boletin__c>();

        duplicados.add( new Boletin__c( Division__c = division1A.Id, Alumno__c = alumnoJuan.Id) );
        duplicados.add( new Boletin__c( Division__c = division1A.Id, Alumno__c = alumnoJuan.Id) );

        try {
            insert duplicados;
            System.assert(false, 'No valido duplicados');
        } catch (DmlException ex) {
            System.debug(ex.getMessage());
            //System.assert(ex.getMessage().contains('duplicado'));
        }

        // DADO un alumno que ya este en el ciclo CUANDO se quiere crear otro boletin en cualquier division ENTONCES no es valido
        Boletin__c boletinJuan1B =  new Boletin__c( Division__c = division1B.Id, Alumno__c = alumnoJuan.Id);
        
        try {
            insert boletinJuan1B;
            System.assert(false, 'No valido duplicados');
        } catch (DmlException ex) {
            System.debug(ex.getMessage());
            //System.assert(ex.getMessage().contains('duplicado'));
        }

        // CUANDO se quiere cambiar la division o el alumno de un boletin que ya existe ENTONCES debe dar un error por Duplicado
        Boletin__c boletinAna1A =  new Boletin__c( Division__c = division1A.Id, Alumno__c = alumnoAna.Id);
        insert boletinAna1A;
    
        try {
            boletinAna1A.Alumno__c = alumnoJuan.Id;
            update boletinAna1A;
            System.assert(false, 'No valido duplicado de Juan en 1A');
        } catch (DmlException ex) {
            System.debug(ex.getMessage());
            //System.assert(ex.getMessage().contains('duplicado'));
        }

        // DADO dos boletines CUANDO se intercambian Divisiones ENTONCES es valido

        // DADO dos boletines CUANDO se intercambian Alumnos ENTONCES es valido

        

        Test.stopTest();
    }

    @IsTest
    static void testInscriptos(){
        Test.startTest();
        // CUANDO se crea un boletin de un alumno en lista de espera ENTONCES el alumno pasa a Inscripto
        Boletin__c boletinJuan = TestDataFactory.getBoletines().get('B-1');
        Contact Juan = [Select estadoInscripcion__c FROM Contact WHERE Id =:boletinJuan.Alumno__c];
        System.assertEquals('Inscripto', Juan.estadoInscripcion__c);

        Test.stopTest();
    }


    @IsTest
    static void testRollupInscriptos(){
        Decimal inscriptos;

        Test.startTest();
        // CUANDO crea un Boletin ENTONCES debe incrementar los inscriptos en la division
        TestDataFactory.getBoletines();
        Division__c division1A = TestDataFactory.getDivisiones().get('D-1');
        inscriptos = [Select Inscriptos__c From Division__c WHERE Id = :division1A.Id].Inscriptos__c;
        System.assertEquals(1, inscriptos);

        // CUANDO cambia la division de un boletin ENTONCES verifica que se baje el inscripto de la division vieja y se sume en la nueva
        Boletin__c boletinJose = TestDataFactory.getBoletines().get('B-1');
        Division__c division1B = TestDataFactory.getDivisiones().get('D-2');
        boletinJose.Division__c = division1B.Id;
        update boletinJose;

        inscriptos = [Select Inscriptos__c From Division__c WHERE Id = :division1A.Id].Inscriptos__c;
        System.assertEquals(0, inscriptos);

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
        TestDataFactory.getBoletines();
        Division__c division = [Select Name, nombre__c From Division__c Limit 1];
        System.assertEquals(division.Name, division.nombre__c);
        Test.stopTest();
        
    }
}