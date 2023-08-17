public with sharing class BoletinTriggerHelper {

    
    static public void updateLastBoletin( List<Boletin__c> boletines) {
        Map<Id,Id> mapBoletinAlumno = new Map<Id,Id>();

        for( Boletin__c boletin :boletines) {
            mapBoletinAlumno.put(boletin.Alumno__c, boletin.Id );
        }
        
        List<Contact> alumnos = new List<Contact>();
        for( Id idAlumno : mapBoletinAlumno.keySet()) {
            alumnos.add( new Contact(Id= idAlumno, ultimoBoletin__c = mapBoletinAlumno.get(idAlumno)));
        }
        update alumnos;
    }

    static public void setInscriptoAlumno( Set<Id> alumnosIds) {
        List<Contact> alumnos = [SELECT estadoInscripcion__c FROM Contact WHERE Id IN :alumnosIds AND estadoInscripcion__c = 'Pendiente'];
        
        for( Contact alumno : alumnos ) {
            alumno.estadoInscripcion__c = 'Inscripto';
        }
        update alumnos;
    }

    static public void setRecordNames( List<Boletin__c> boletines) {
        for( Boletin__c boletin :boletines) {
            boletin.Name = boletin.nombreAlumno__c + ' ' + boletin.nombreDivision__c;
        }
    }

    static public void updateRollupDivisiones(Set<Id> divisionIds) {
        List<Division__c> divisiones = new List<Division__c>();
        
        for(AggregateResult res : [SELECT Division__c, count(Id) counter FROM Boletin__c WHERE Division__c IN :divisionIds group by Division__c]) {
            divisiones.add(new Division__c(Id=(Id)res.get('Division__c'), inscriptos__c =(Integer)res.get('counter')));
            divisionIds.remove((Id)res.get('Division__c'));
        }
        for( Id divisionId :divisionIds) {
            divisiones.add(new Division__c( Id = divisionId, inscriptos__c = 0));
        }
        update divisiones;
    }

    static public Set<Id> getChangeDivisiones(Map<Id, Boletin__c> boletines, Map<Id,Boletin__c> oldBoletines) {
        Set<Id> divisiones = new Set<Id>();
        for( Boletin__c boletin: boletines.values()){
            Id oldDivision = oldBoletines.get(boletin.Id).Division__c;
            if ( oldDivision != boletin.Division__c) {
                divisiones.add(boletin.Division__c);
                divisiones.add(oldDivision);
            }
        }
        return divisiones;
    }

    static public Set<Id> getAlumnos(List<Boletin__c> boletines) {
        Set<Id> alumnos = new Set<Id>();
        for( Boletin__c boletin: boletines){
            alumnos.add(boletin.Alumno__c);
        }
        return alumnos;
    }
    
    static public Set<Id> getDivisiones(List<Boletin__c> boletines) {
        Set<Id> divisiones = new Set<Id>();
        for( Boletin__c boletin: boletines){
            divisiones.add(boletin.Division__c);
        }
        return divisiones;
    }
}