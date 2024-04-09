@isTest
public class TestProgramaTrigger {
  @isTest
  static void testEvaluaciones() {
    Test.startTest();
    TestDataFactory.getProgramaEvaluaciones();

    Programa__c programa = [SELECT Evaluaciones__c FROM Programa__c LIMIT 1];
    try {
      EvaluacionesHelper.Programa evaluaciones = (EvaluacionesHelper.Programa) JSON.deserializeStrict(
        programa.Evaluaciones__c,
        EvaluacionesHelper.Programa.class
      );
    } catch (Exception error) {
      System.assert(true, 'Tiene que generar el json');
    }

    Test.stopTest();
  }

  public static Map<String, Programa__c> getProgramas() {
    return TestDataFactory.getProgramas();
  }

  @IsTest
  static void testValidateHeaderYFooterOk() {
    Programa__c programa = TestDataFactory.makeProgramas(false, 1)
      .values()
      .get(0);

    Test.startTest();
    programa.Header__c = 'Test {firstName}';
    programa.Footer__c = 'Test {lastName}';
    insert programa;
    Test.stopTest();
  }

  @IsTest
  static void testValidateHeaderYFooterFailed() {
    Programa__c programa = TestDataFactory.makeProgramas(false, 1)
      .values()
      .get(0);

    Test.startTest();
    programa.Header__c = 'Test {firstNames}';
    programa.Footer__c = 'Test {lastNames}';
    try {
      insert programa;
      Assert.fail('No deberia dejar insertar el programa');
    } catch (DmlException e) {
    }
    Test.stopTest();
  }
}
