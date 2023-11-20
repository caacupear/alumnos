public with sharing class AsistenciaTriggerHelper {

    static public void setCalculatedValues( List<Asistencia__c> asistencias) {
        for( Asistencia__c asistencia :asistencias) {
            if ( asistencia.UniqueKey__c == null  ) {
                asistencia.UniqueKey__c = AsistenciasHelper.getUniqueKey(asistencia);
            }
            if ( asistencia.Desde__c == null && asistencia.ano__c > 0 && asistencia.Semana__c > 0 ) {
                asistencia.Desde__c = WeekHelper.getFirsDateOfWeek((Integer) asistencia.Semana__c, (Integer) asistencia.ano__c);
            }
            asistencia.SemanaText__c = String.valueOf(asistencia.Semana__c);
        }
    }
    
    static public void validateFields( List<Asistencia__c> asistencias) {
        for( Asistencia__c asistencia :asistencias) {
            if ( asistencia.Semana__c > 54 ||  asistencia.Semana__c < 1 ) {                
                asistencia.addError('El campo semana debe ser entre 1 y 54. Por ejemplo esta semana es la ' + WeekHelper.getWeekOfDate(Date.today()));
            }
            if ( asistencia.Ano__c > Date.Today().year() ) {
                asistencia.addError('El año no puede ser futuro cuando se cargan asistencias');
            }
        }
    
    }
}