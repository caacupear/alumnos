public with sharing class AsistenciasHelper {

    public class AsistenciasCiclo {
        Id cicloId;
        @AuraEnabled public List<Asistencia__c> asistencias;

        public AsistenciasCiclo( Id cicloId){
            this.cicloId = cicloId;
            retrieve();
        }
        void retrieve() {
            asistencias = [SELECT Id, Lunes__c, Martes__c, Miercoles__c, Jueves__c, Viernes__c 
                    FROM Asistencia__c 
                    WHERE Boletin__r.Division__r.CicloLectivo__c = :this.cicloId];

        }
    }

    public class AsistenciasBoletin {
        Id boletinId;
        @AuraEnabled public List<Asistencia__c> asistencias;

        public AsistenciasBoletin( Id boletinId){
            this.boletinId = boletinId;
            retrieve();
        }

        void retrieve() {
            asistencias = [SELECT Id, semana__c, Lunes__c, Martes__c, Miercoles__c, Jueves__c, Viernes__c 
                    FROM Asistencia__c 
                    WHERE Boletin__c = :this.boletinId];
        }
    }

    public class AsistenciasDivision {
        public Id divisionId;
        public Integer semana;
        public Integer ano;
        public String semanaLabel;
        @AuraEnabled public List<Boletin__c> asistencias;

        public AsistenciasDivision( Id divisionId, Integer semana ){
            this.divisionId = divisionId;
            if ( semana == 0) {
                semana = WeekHelper.getWeekOfDate(Date.today());
                ano = Date.today().year();
            }
            this.semana = semana;
            retrieve();            
        }

        public void save(List<Asistencia__c> asistencias) {
            upsert asistencias;
        }

        void retrieve() {
            asistencias = [SELECT nombreAlumno__c, 
                    (SELECT Id, Lunes__c, Martes__c, Miercoles__c, Jueves__c, Viernes__c 
                    FROM Asistencias__r 
                    WHERE Semana__c = :this.semana )  
                FROM Boletin__c 
                WHERE Division__c = :this.divisionId];
        }
    }

}