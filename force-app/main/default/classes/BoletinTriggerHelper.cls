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
        if ( boletinesConCambio.size() > 0 ) {
            Map<Id,Division__c> divisionesExistentes = new Map<Id,Division__c> ([SELECT CicloLectivo__c, Name FROM Division__c WHERE Id in: divisiones]);            
            List<Boletin__c> boletinesExistentes = [SELECT Division__r.CicloLectivo__c, Alumno__c FROM Boletin__c WHERE Division__c in: divisiones AND Alumno__c IN :alumnos];
            Map<Id, Set<Id>> existentesMap = getCiclosAlumnos(boletinesExistentes);

            // Verifca si el alumno y division ya existen (y los agrega por si se repiten dentro de boletines tambien)
            for ( Id boletinId :boletinesConCambio) {
                Boletin__c nuevo = (Boletin__c)newBoletinMap.get(boletinId);
                Boletin__c viejo = (Boletin__c)oldBoletinMap.get(boletinId);
                Id key = divisionesExistentes.get(nuevo.Division__c).CicloLectivo__c;
                Id value = nuevo.Alumno__c;
                Id oldKey = divisionesExistentes.get(viejo.Division__c).CicloLectivo__c;

                if ( existentesMap.containsKey(key) ) {
                    if ( existentesMap.get(key).contains(value) ) {
                        nuevo.addError('Ya existe un boletin para la division ' + nuevo.Division__c + ' y alumno ' + nuevo.Alumno__c );
                    }
                    existentesMap.get(key).add(value);
                } else {
                    existentesMap.put(key, new Set<Id>{ value });            
                }
                // Quita el viejo
                if ( existentesMap.containsKey(oldKey) ) {
                    existentesMap.get(oldKey).remove(viejo.Alumno__c);
                }
            }
        }
    }

    static public void validateDuplicates( List<Boletin__c> boletines) {
        Set<Id> divisiones = getDivisiones(boletines);        
        Set<Id> alumnos = getAlumnos(boletines);

        Map<Id,Division__c> divisionesExistentes = new Map<Id,Division__c> ([SELECT CicloLectivo__c, Name FROM Division__c WHERE Id in: divisiones]);
        Set<Id> ciclos = getCiclos(divisionesExistentes.values());

        List<Boletin__c> boletinesExistentes = [SELECT Division__r.CicloLectivo__c, Alumno__c FROM Boletin__c WHERE Division__r.CicloLectivo__c in: ciclos AND Alumno__c IN :alumnos];
        Map<Id, Set<Id>> existentesMap = getCiclosAlumnos(boletinesExistentes);
        
        // Verifca si el alumno y division ya existen (y los agrega por si se repiten dentro de boletines tambien)
        for( Boletin__c boletin :boletines) {
            Id key = divisionesExistentes.get(boletin.Division__c).CicloLectivo__c;
            Id value = boletin.Alumno__c;
            if ( existentesMap.containsKey(key) ) {
                if ( existentesMap.get(key).contains(value) ) {
                    boletin.addError('Ya existe un boletin para el alumno ' + boletin.Name + ' dentro del mismo ciclo en la siguiente division' + divisionesExistentes.get(boletin.Division__c).Name );
                }
                existentesMap.get(key).add(value);
            } else {
                existentesMap.put(key, new Set<Id>{ value });            
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

    static public Set<Id> getCiclos(List<Division__c> divisiones) {
        return TriggerHelper.getIdsFromSObjects(divisiones, 'CicloLectivo__c');
    }

    // static public Map<Id, Set<Id>> getDivisionesAlumnos(List<Boletin__c> boletines) {
    //     Map<Id, Set<Id>>  divisionesMap = new Map<Id, Set<Id>>();
    //     for ( Boletin__c boletin: boletines) {
    //         if ( !String.isBlank(boletin.Division__c) && !String.isBlank(boletin.Alumno__c) )  {
    //             if ( divisionesMap.containsKey(boletin.Division__c) ) {
    //                 divisionesMap.get(boletin.Division__c).add(boletin.Alumno__c);
    //             } else {
    //                 divisionesMap.put(boletin.Division__c, new Set<Id>{ boletin.Alumno__c });
    //             }
    //         }
    //     }
    //     return divisionesMap;
    // }    

    static public Map<Id, Set<Id>> getCiclosAlumnos(List<Boletin__c> boletines) {
        Map<Id, Set<Id>>  ciclosMap = new Map<Id, Set<Id>>();
        for ( Boletin__c boletin: boletines) {
            Id key = boletin.Division__r.CicloLectivo__c;
            Id value = boletin.Alumno__c;
            if ( !String.isBlank(key) && !String.isBlank(value) )  {
                if ( ciclosMap.containsKey(key) ) {
                    ciclosMap.get(key).add(value);
                } else {
                    ciclosMap.put(key, new Set<Id>{ value });
                }
            }
        }
        return ciclosMap;
    }    
}