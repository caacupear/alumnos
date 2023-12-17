public with sharing class ProgramaHelper {
  public static void validateContent(List<Programa__c> programas) {
    for (Programa__c programa : programas) {
      String errorMessage = ConstanciaHelper.checkContentVariables(
        programa.Header__c
      );
      if (String.isNotEmpty(errorMessage)) {
        programa.Header__c.addError(errorMessage);
      }
      errorMessage = ConstanciaHelper.checkContentVariables(programa.Footer__c);
      if (String.isNotEmpty(errorMessage)) {
        programa.Footer__c.addError(errorMessage);
      }
    }
  }
}
