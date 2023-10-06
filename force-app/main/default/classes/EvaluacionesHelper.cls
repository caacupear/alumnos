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
    
    static private Set<String> getFieldsEvaluaciones() {
        Set<String> fields = new Set<String>();
		Schema.DescribeFieldResult fieldResult = ProgramaEvaluacion__c.Campo__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			fields.add(pickListVal.getValue());
		}     
		return fields;        
    }

    public static Programa  getPrograma( Id divisionId){
        Programa programa;
        Division__c division = [Select CicloLectivo__r.Programa__r.Evaluaciones__c FROM Division__c WHERE Id = :divisionId];
        if ( !String.isBlank(division.CicloLectivo__r.Programa__r.Evaluaciones__c) ) {
            programa = (Programa)JSON.deserializeStrict(division.CicloLectivo__r.Programa__r.Evaluaciones__c, Programa.class);
        }
        return programa;
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

        public void save(List<Map<String, Object>> draftValues) {
            
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
        public Id grillaId;
        @AuraEnabled public List<Boletin__c> evaluaciones;

        public EvaluacionesDivision( Id divisionId, Id grillaId){
            this.divisionId = divisionId;
            this.grillaId = grillaId;
            retrieve();            
        }

        public void save(List<Map<String, Object>> draftValues) {
            try {
                Set<String> fieldsEvaluaciones= EvaluacionesHelper.getFieldsEvaluaciones();
                List<Evaluacion__c> evaluaciones = new List<Evaluacion__c>();
                for ( Map<String, Object> draft :draftValues ) {
                    Evaluacion__c evaluacion = new Evaluacion__c( Boletin__c = (String)draft.get('id'), Grilla__c = this.grillaId);
                    evaluacion.UniqueKey__c = evaluacion.Boletin__c + '-' + evaluacion.Grilla__c;
                    for ( String columnName : draft.keySet() ){
                        
                        if ( fieldsEvaluaciones.contains(columnName) ) {
                            evaluacion.put( columnName, draft.get(columnName));
                        }
                    }
                    evaluaciones.add(evaluacion);
                }    
                upsert evaluaciones UniqueKey__c;
            } catch ( Exception e ){
                System.debug(e.getMessage());
                throw new AuraHandledException('Se produjo un error al guardar' + e.getMessage());    
            }
        }            

        void retrieve() {
            evaluaciones = [SELECT Id, Alumno__c, nombreAlumno__c,
                ( SELECT Conceptual1__c, Conceptual2__c, Conceptual3__c, Conceptual4__c, Conceptual5__c , Nota1__c, Nota2__c, Nota3__c, Nota4__c, Nota5__c 
                FROM Evaluaciones__r 
                WHERE Grilla__c = :grillaId )
            FROM Boletin__c
            WHERE Division__c = :this.divisionId];
        }
    }

}