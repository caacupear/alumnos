public with sharing class AsistenciasHelper {
    static List<String> camposDias = new List<String>{ 'Lunes__c', 'Martes__c', 'Miercoles__c', 'Jueves__c', 'Viernes__c'};

    public static String getUniqueKey(Asistencia__c asistencia) {
        return asistencia.Boletin__c + '-' + String.valueOf(asistencia.Semana__c);
    }

    public class AsistenciasCiclo {
        Id cicloId;
        @AuraEnabled public List<AggregateResult> asistencias;

        public AsistenciasCiclo( Id cicloId){
            this.cicloId = cicloId;
            retrieve();
        }
        void retrieve() {
            asistencias = [SELECT  Boletin__r.Division__c, Boletin__r.Division__r.Name,  SemanaText__c, Sum(Asistencia__c) Faltas
                FROM Asistencia__c 
                WHERE Boletin__r.Division__r.CicloLectivo__c = :this.cicloId
                GROUP BY Boletin__r.Division__c, Boletin__r.Division__r.Name, SemanaText__c];
        }
    }

    public class AsistenciasBoletin {
        Id boletinId;
        @AuraEnabled public List<Asistencia__c> asistencias;

        public AsistenciasBoletin( Id boletinId){
            this.boletinId = boletinId;
            retrieve();
        }

        public void save(List<Map<String, Object>> draftValues) {
            try {
                List<Asistencia__c> asistencias = new List<Asistencia__c>();

                for ( Map<String, Object> draft :draftValues ){
                    Asistencia__c asistencia = new Asistencia__c( Boletin__c = this.boletinId, Semana__c =  Decimal.valueOf((String)draft.get('Semana__c')) );
                    asistencia.UniqueKey__c = getUniqueKey(asistencia);
                    for ( String campoDia : AsistenciasHelper.camposDias ){
                        if ( draft.containsKey(campoDia) ) {
                            asistencia.put( campoDia, draft.get(campoDia));
                        }
                    }
                    asistencias.add(asistencia);
                }    
                System.debug(asistencias);
                upsert asistencias UniqueKey__c;
            } catch ( Exception e ){
                System.debug(e.getMessage());
            }
        }


        void retrieve() {
            asistencias = [SELECT Id, Semana__c, Lunes__c, Martes__c, Miercoles__c, Jueves__c, Viernes__c, Asistencia__c 
                    FROM Asistencia__c 
                    WHERE Boletin__c = :this.boletinId ORDER BY Ano__c DESC, Semana__c DESC];
        }
    }

    public class AsistenciasDivision {
        public Id divisionId;
        @AuraEnabled public Integer semana;
        public Integer ano;
        @AuraEnabled public List<Boletin__c> boletines;
        @AuraEnabled public Map<Id, Asistencia__c> asistencias;
        
        public AsistenciasDivision( Id divisionId, Integer semana ){
            this.divisionId = divisionId;
            if ( semana == 0) {
                semana = WeekHelper.getWeekOfDate(Date.today());
                ano = Date.today().year();
            }
            this.semana = semana;

            retrieve();            
        }
        
        public void save(List<Map<String, Object>> draftValues) {
            try {
                List<Asistencia__c> asistencias = new List<Asistencia__c>();

                for ( Map<String, Object> draft :draftValues ){
                    Asistencia__c asistencia = new Asistencia__c( Boletin__c = (String)draft.get('id'), Semana__c = this.semana);
                    asistencia.UniqueKey__c = getUniqueKey(asistencia);
                    for ( String campoDia : AsistenciasHelper.camposDias ){
                        if ( draft.containsKey(campoDia) ) {
                            asistencia.put( campoDia, draft.get(campoDia));
                        }
                    }
                    asistencias.add(asistencia);
                }    
                System.debug(asistencias);
                upsert asistencias UniqueKey__c;
            } catch ( Exception e ){
                System.debug(e.getMessage());
            }
        }

        void retrieve() {
            List<Boletin__c> boletines = [SELECT nombreAlumno__c, 
                (SELECT Id, Lunes__c, Martes__c, Miercoles__c, Jueves__c, Viernes__c , Asistencia__c
                FROM Asistencias__r 
                WHERE Semana__c = :this.semana )  
                FROM Boletin__c 
                WHERE Division__c = :this.divisionId];            
            
            this.boletines = new List<Boletin__c>();
            this.asistencias = new Map<Id, Asistencia__c>();

            for( Boletin__c boletin: boletines){
                this.boletines.add(boletin);
                if ( boletin.Asistencias__r.size() > 0 ) {
                    this.asistencias.put(boletin.Id, boletin.Asistencias__r.get(0));
                }
            }
        }
    }

}