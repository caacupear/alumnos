public with sharing class TestContactTrigger {
    static private Map<String,Contact> alumnos;
    static private Map<String,Contact> docentes;

    static public Map<String,Contact> getAlumnos(){
        if  (alumnos == null ) {
            alumnos = new Map<String,Contact>();
            alumnos.put( 'Juan', new Contact( FirstName = 'Juan',LastName= 'Pedro', recordTypeId = ContactHelper.getRecordTypeIdForAlumno(), Documento__c = '123', TipoDeDocumento__c = 'DNI' ) );
            alumnos.put( 'Ana', new Contact( FirstName = 'Ana',LastName= 'Laura', recordTypeId = ContactHelper.getRecordTypeIdForAlumno(), Documento__c = '125', TipoDeDocumento__c = 'DNI' ) );
            insert alumnos.values();
        }
        return alumnos;
    }

    static public Map<String,Contact> getDocentes(){
        if  (docentes == null ) {
            docentes = new Map<String,Contact>();
            docentes.put( 'Pedro', new Contact( FirstName = 'Pedro',LastName= 'Alonso', recordTypeId = ContactHelper.getRecordTypeIdForDocente()) );
            docentes.put( 'Laura', new Contact( FirstName = 'Laura',LastName= 'Mora', recordTypeId = ContactHelper.getRecordTypeIdForDocente()) );
            insert docentes.values();
        }
        return docentes;
    }

}