public with sharing class EvaluacionesHelper {
    public class ProgramaEvaluacion {
        @AuraEnabled public String tipo;
        @AuraEnabled public String nombre;
        @AuraEnabled public String campo;
        @AuraEnabled public List<String> opciones;
    }

    public class Programa {
        @AuraEnabled public List<ProgramaEvaluacion> evaluaciones;
    }

    public class EvaluacionesGrilla {
        Id grillaId;
        @AuraEnabled public Programa programa;
        @AuraEnabled public List<Evaluacion__c> evaluaciones;

        public EvaluacionesGrilla( Id grillaId){
            this.grillaId = grillaId;
            retrieve();
        }
        void retrieve() {
            Grilla__c grilla = [Select Division__r.CicloLectivo__r.Programa__r.Evaluaciones__c FROM Grilla__c WHERE Id = :this.grillaId];
            if ( !String.isBlank(grilla.Division__r.CicloLectivo__r.Programa__r.Evaluaciones__c) ) {
                programa = (Programa)JSON.deserializeStrict(grilla.Division__r.CicloLectivo__r.Programa__r.Evaluaciones__c, Programa.class);
            }
            evaluaciones = [SELECT Id, Alumno__c, Materia__c, Conceptual1__c, Conceptual2__c, Conceptual3__c, Conceptual4__c, Conceptual5__c,  Nota1__c, Nota2__c, Nota3__c, Nota4__c, Nota5__c 
                    FROM Evaluacion__c 
                    WHERE Grilla__c = :this.grillaId];

        }
    }

    public class EvaluacionesBoletin {
        Id boletinId;
        @AuraEnabled public Programa programa;
        @AuraEnabled public List<Evaluacion__c> evaluaciones;

        public EvaluacionesBoletin( Id boletinId){
            this.boletinId = boletinId;
            retrieve();
        }

        void retrieve() {
            Boletin__c boletin = [Select Division__r.CicloLectivo__r.Programa__r.Evaluaciones__c FROM Boletin__c WHERE Id = :this.boletinId];
            if ( !String.isBlank(boletin.Division__r.CicloLectivo__r.Programa__r.Evaluaciones__c) ) {
                programa = (Programa) JSON.deserializeStrict(boletin.Division__r.CicloLectivo__r.Programa__r.Evaluaciones__c, Programa.class);
            }

            evaluaciones = [SELECT Id, Materia__c, Conceptual1__c, Conceptual2__c, Conceptual3__c, Conceptual4__c, Conceptual5__c , Nota1__c, Nota2__c, Nota3__c, Nota4__c, Nota5__c
                    FROM Evaluacion__c 
                    WHERE Boletin__c = :this.boletinId];
        }
    }

    public class EvaluacionesDivision {
        public Id divisionId;
        @AuraEnabled public List<Evaluacion__c> evaluaciones;
        @AuraEnabled public Programa programa;

        public EvaluacionesDivision( Id divisionId){
            this.divisionId = divisionId;
            retrieve();            
        }

        public void save(List<Evaluacion__c> evaluaciones) {
        }

        void retrieve() {
            Division__c division = [Select CicloLectivo__r.Programa__r.Evaluaciones__c FROM Division__c WHERE Id = :this.divisionId];
            if ( !String.isBlank(division.CicloLectivo__r.Programa__r.Evaluaciones__c) ) {
                programa = (Programa)JSON.deserializeStrict(division.CicloLectivo__r.Programa__r.Evaluaciones__c, Programa.class);
            }
            evaluaciones = [SELECT Id, Alumno__c, Materia__c, Conceptual1__c, Conceptual2__c, Conceptual3__c, Conceptual4__c, Conceptual5__c , Nota1__c, Nota2__c, Nota3__c, Nota4__c, Nota5__c
            FROM Evaluacion__c 
            WHERE Grilla__r.Division__c = :this.divisionId];
        }
    }

}