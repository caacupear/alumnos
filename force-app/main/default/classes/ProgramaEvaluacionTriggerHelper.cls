public with sharing class ProgramaEvaluacionTriggerHelper {

    static public void updatePrograma(List<ProgramaEvaluacion__c> evaluaciones) {
        Set<Id> idProgramas = getProgramas(evaluaciones);
        List<Programa__c> programas = [Select Id, (SELECT Id, Name, Campo__c, Opciones__c , Tipo__c FROM ProgramaEvaluaciones__r ORDER BY Orden__c) 
            FROM Programa__c 
            WHERE Id IN :idProgramas];

        for( Programa__c programa :programas){
            programa.Evaluaciones__c = getEvaluacionesJSON(programa.ProgramaEvaluaciones__r).getAsString();
        }
        update programas;
    }

    static System.JSONGenerator getEvaluacionesJSON( List<ProgramaEvaluacion__c> evaluaciones){
        System.JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
            gen.writeFieldName('evaluaciones');
                gen.writeStartArray();
                    for ( ProgramaEvaluacion__c evaluacion :evaluaciones){
                        gen.writeStartObject();
                        gen.writeStringField('nombre', evaluacion.Name);
                        gen.writeStringField('campo', evaluacion.Campo__c);
                        gen.writeStringField('tipo', evaluacion.Tipo__c);
                        if ( evaluacion.Tipo__c == 'Conceptual') {
                            gen.writeFieldName('opciones');
                            gen.writeStartArray();
                            for ( String opcion: evaluacion.Opciones__c.split(',') ) {
                                gen.writeString(opcion);
                            }
                            gen.writeEndArray();
                        }
                        gen.writeEndObject();
                    }
                gen.writeEndArray();
        gen.writeEndObject();
        return gen;
    }

    static public Set<Id> getProgramas(List<ProgramaEvaluacion__c> evaluaciones) {        
        return TriggerHelper.getIdsFromSObjects(evaluaciones, 'Programa__c');
    }

    
}