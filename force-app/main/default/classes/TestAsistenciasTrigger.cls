@IsTest
public class TestAsistenciasTrigger {
    static private Map<String, Asistencia__c> asistencias;

    public static Map<String, Asistencia__c> getAsistencias(){
        if ( asistencias == null ) {

            Boletin__c boletin = TestBoletinTrigger.getBoletines().get('Juan 1A');

            asistencias = new Map<String, Asistencia__c>();
            asistencias.put( 'Juan 1A', new Asistencia__c( Boletin__c =boletin.Id, Semana__c = 1) );
            insert asistencias.values();
        }
        return asistencias;
    }
}