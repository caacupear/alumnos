@IsTest
public class TestProgramaEvaluacionTrigger {

    static private Map<String, ProgramaEvaluacion__c> programaEvaluaciones;

        public static Map<String, ProgramaEvaluacion__c> getProgramaEvaluaciones(){
            return getProgramaEvaluaciones(true);
        }

        public static Map<String, ProgramaEvaluacion__c> getProgramaEvaluaciones( Boolean insertValues){
        if ( programaEvaluaciones == null ) {
            programaEvaluaciones = new Map<String, ProgramaEvaluacion__c>(); 
            Programa__c programa = TestProgramaTrigger.getProgramas().get('P1');

            programaEvaluaciones.put( 'P1', new ProgramaEvaluacion__c( Programa__c = programa.Id,  Tipo__c = 'Nota', Campo__c = 'Nota1__c'));
            programaEvaluaciones.put( 'P1', new ProgramaEvaluacion__c( Programa__c = programa.Id,  Tipo__c = 'Nota', Campo__c = 'Nota2__c'));

            if( insertValues ) {
                insert programaEvaluaciones.values();
            } 
        }
        return programaEvaluaciones;
    }    

}