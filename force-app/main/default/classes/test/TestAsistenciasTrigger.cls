@IsTest
public class TestAsistenciasTrigger {
    static private Map<String, Asistencia__c> asistencias;

        public static Map<String, Asistencia__c> getAsistencias(){
            return getAsistencias(true);
        }

        public static Map<String, Asistencia__c> getAsistencias( Boolean insertValues){
        if ( asistencias == null ) {
            Boletin__c boletin = TestBoletinTrigger.getBoletines().get('Juan 1A');
            asistencias = new Map<String, Asistencia__c>();            
            asistencias.put( 'Juan 1A S1', new Asistencia__c( Boletin__c =boletin.Id, Semana__c = 1, Lunes__c = 'Asistio', Martes__c = 'Asistio', Miercoles__c = 'Asistio', Jueves__c = 'Asistio', Viernes__c = 'Asistio') );
            asistencias.put( 'Juan 1A S2', new Asistencia__c( Boletin__c =boletin.Id, Semana__c = 2, Lunes__c = 'Tarde', Martes__c = 'Asistio', Miercoles__c = 'Asistio', Jueves__c = 'Asistio', Viernes__c = 'Asistio') );
            if( insertValues ) {
                insert asistencias.values();
                system.debug(asistencias.values().size());
            } 
        }
        return asistencias;
    }
}