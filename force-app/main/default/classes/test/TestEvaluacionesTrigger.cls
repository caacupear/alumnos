@isTest
public class TestEvaluacionesTrigger {
    static private Map<String, Evaluacion__c> evaluaciones;

        public static Map<String, Evaluacion__c> getEvaluaciones(){
            return getEvaluaciones(true);
        }

        public static Map<String, Evaluacion__c> getEvaluaciones( Boolean insertValues){
        if ( evaluaciones == null ) {
            Boletin__c boletin = TestBoletinTrigger.getBoletines().get('Juan 1A');
            Grilla__c grilla = TestGrillaTrigger.getGrilla().get('lengua');

            evaluaciones = new Map<String, Evaluacion__c>();            
            evaluaciones.put( 'Juan 1A Lengua', new Evaluacion__c( Boletin__c =boletin.Id, Grilla__c = grilla.id, Nota1__c = 10) );
            if( insertValues ) {
                insert evaluaciones.values();
                system.debug(evaluaciones.values().size());
            } 
        }
        return evaluaciones;
    }
}