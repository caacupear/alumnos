@IsTest
public class TestGrillaTrigger {
    static private Map<String, Grilla__c> grilla;

    public static Map<String, Grilla__c> getGrilla(){
        if ( grilla == null ) {
            grilla = new Map<String, Grilla__c>();
            Division__c division = TestDivisionTrigger.getDivisiones().get('1A');
            Materia__c lengua = TestMateriaTrigger.getMaterias().get('lengua');
            Contact docente = TestContactTrigger.getDocentes().get('Pedro');
            grilla.put( 'lengua', new Grilla__c( Materia__c = lengua.Id, Docente__c = docente.Id, Division__c = division.Id ) );
            insert grilla.values();

            List<GrillaHorario__c> horario = new List<GrillaHorario__c>{ new GrillaHorario__c( Grilla__c = grilla.get('lengua').Id, dia__c = 'Lunes', desde__c = Time.newInstance(10, 0,0,0), hasta__c =Time.newInstance(11, 0,0,0)) };
            insert horario;
        }
        System.debug(grilla);            
        return grilla;
    }
}