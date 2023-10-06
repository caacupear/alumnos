public with sharing class DivisionHelper {

    public static List<WeekHelper.Semana> getSemanas(Id divisionId) {
        Division__c division = [SELECT CicloLectivo__r.inicio__c, CicloLectivo__r.fin__c FROM Division__c WHERE ID = :divisionId];
        return WeekHelper.getWeeksRange(division.CicloLectivo__r.inicio__c, division.CicloLectivo__r.fin__c);
    }

    public static List<Grilla__c> getGrilla( Id divisionId){
        List<Grilla__c>  materias = [Select Id, Materia__c, Materia__r.Name, Docente__c, Docente__r.Name  FROM Grilla__c WHERE Division__c = :divisionId];
        return materias;
    }

}