public with sharing class ContactHelper {
    
    static public Id getRecordTypeIdForAlumno() {
        return  Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Alumno').getRecordTypeId();
    }

    static public Id getRecordTypeIdForDocente() {
        return  Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Docente').getRecordTypeId();
    }
    
}