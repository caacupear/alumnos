public with sharing class BoletinTriggerHelper {
    
    static public void validateDuplicates( Map<Id,sObject> newBoletinMap, Map<Id,sObject> oldBoletinMap) {
        Set<Id> divisiones = new Set<Id> ();
        Set<Id> alumnos = new Set<Id> ();
        Set<Id> boletinesConCambio = new Set<Id> ();
        // Filtra los que cambiaron
        for ( Id boletinId :newBoletinMap.keySet()) {
            Boletin__c nuevo = (Boletin__c)newBoletinMap.get(boletinId);
            Boletin__c viejo = (Boletin__c)oldBoletinMap.get(boletinId);
            if ( nuevo.Division__c != viejo.Division__c || nuevo.Alumno__c != viejo.Alumno__c) {
                divisiones.add(nuevo.Division__c );
                divisiones.add(viejo.Division__c );
                alumnos.add(nuevo.Alumno__c );
                alumnos.add(viejo.Alumno__c);
                boletinesConCambio.add(boletinId);
            }
        }
        System.debug(divisiones);
        System.debug(alumnos);
        System.debug(boletinesConCambio);

        if ( boletinesConCambio.size() > 0 ) {
            List<Boletin__c> boletinesExistentes = [SELECT Division__c, Alumno__c FROM Boletin__c WHERE Division__c in: divisiones AND Alumno__c IN :alumnos];
            System.debug(boletinesExistentes);
            Map<Id, Set<Id>> existentesMap = getDivisionesAlumnos(boletinesExistentes);
            // Verifca si el alumno y division ya existen (y los agrega por si se repiten dentro de boletines tambien)
            for ( Id boletinId :boletinesConCambio) {
                Boletin__c nuevo = (Boletin__c)newBoletinMap.get(boletinId);
                Boletin__c viejo = (Boletin__c)oldBoletinMap.get(boletinId);
                System.debug(existentesMap);
                System.debug(nuevo);
                System.debug(viejo);
    
                if ( existentesMap.containsKey(nuevo.Division__c) ) {
                    if ( existentesMap.get(nuevo.Division__c).contains(nuevo.Alumno__c) ) {
                        nuevo.addError('Ya existe un boletin para la division ' + nuevo.Division__c + ' y alumno ' + nuevo.Alumno__c );
                    }
                    existentesMap.get(nuevo.Division__c).add(nuevo.Alumno__c);
                } else {
                    existentesMap.put(nuevo.Division__c, new Set<Id>{ nuevo.Alumno__c });            
                }
                // Quita el viejo
                if ( existentesMap.containsKey(viejo.Division__c) ) {
                    existentesMap.get(viejo.Division__c).remove(viejo.Alumno__c);
                } else {
                    System.debug('Por que no esta ' + viejo.Division__c);
                }
            }
        }
    }

    static public void validateDuplicates( List<Boletin__c> boletines) {
        Set<Id> divisiones = getDivisiones(boletines);        
        Set<Id> alumnos = getAlumnos(boletines);

        List<Boletin__c> boletinesExistentes = [SELECT Division__c, Alumno__c FROM Boletin__c WHERE Division__c in: divisiones AND Alumno__c IN :alumnos];
        Map<Id, Set<Id>> existentesMap = getDivisionesAlumnos(boletinesExistentes);
        
        // Verifca si el alumno y division ya existen (y los agrega por si se repiten dentro de boletines tambien)
        for( Boletin__c boletin :boletines) {
            if ( existentesMap.containsKey(boletin.Division__c) ) {
                if ( existentesMap.get(boletin.Division__c).contains(boletin.Alumno__c) ) {
                    boletin.addError('Ya existe un boletin para la division ' + boletin.Division__c + ' y alumno ' + boletin.Alumno__c );
                }
                existentesMap.get(boletin.Division__c).add(boletin.Alumno__c);
            } else {
                existentesMap.put(boletin.Division__c, new Set<Id>{ boletin.Alumno__c });            
            }
        }
    }

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
        return TriggerHelper.getIdsFromSObjects(boletines, 'Alumno__c');
    }
    
    static public Set<Id> getDivisiones(List<Boletin__c> boletines) {
        return TriggerHelper.getIdsFromSObjects(boletines, 'Division__c');
    }

    static public Map<Id, Set<Id>> getDivisionesAlumnos(List<Boletin__c> boletines) {
        Map<Id, Set<Id>>  divisionesMap = new Map<Id, Set<Id>>();
        for ( Boletin__c boletin: boletines) {
            if ( !String.isBlank(boletin.Division__c) && !String.isBlank(boletin.Alumno__c) )  {
                if ( divisionesMap.containsKey(boletin.Division__c) ) {
                    divisionesMap.get(boletin.Division__c).add(boletin.Alumno__c);
                } else {
                    divisionesMap.put(boletin.Division__c, new Set<Id>{ boletin.Alumno__c });
                }
            }
        }
        return divisionesMap;
    }    
}