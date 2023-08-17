@IsTest
public with sharing class TestMateriaTrigger {
    static private Map<String, Materia__c> materias;
    public static Map<String, Materia__c> getMaterias(){
        if ( materias == null ) {            
            materias = new Map<String, Materia__c>();
            materias.put( 'matematica', new Materia__c( Name = 'Matematica', anoEscolar__c=1) );
            materias.put( 'lengua', new Materia__c( Name = 'Lengua', anoEscolar__c=1) );
            materias.put( 'fisica', new Materia__c( Name = 'Fisica', anoEscolar__c=1) );
            insert materias.values();
        }
        return materias;
    }

}