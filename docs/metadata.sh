
## GENERADOR DE OBJECTS

## Si viene refresh baja la metadata
if [ $1 = "refresh" ]; then
    yarn doc object Constancia__c Contact Programa__c Materia__c ProgramaEvaluacion__c TipoEvaluacion__c TipoEvaluacionOpcion__c CicloLectivo__c Division__c Boletin__c Asistencia__c Evaluacion__c --m=intro --o
else 
    yarn doc object Constancia__c Contact Programa__c Materia__c ProgramaEvaluacion__c TipoEvaluacion__c TipoEvaluacionOpcion__c CicloLectivo__c Division__c Boletin__c Asistencia__c Evaluacion__c --m=intro --i
fi


### Configuracion
yarn doc object Constancia__c Programa__c Materia__c ProgramaEvaluacion__c TipoEvaluacion__c TipoEvaluacionOpcion__c Grilla__c GrillaHorario__c --m=configuracion/intro --i

### Inscripcion
yarn doc object CicloLectivo__c Division__c Boletin__c Contact --m=configuracion/intro --i

### Boletines
yarn doc object Boletin__c Asistencia__c Evaluacion__c --m=boletines/intro --i


## GENERADOR DE CLASSES