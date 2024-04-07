@IsTest
public with sharing class TestConstanciaHelper {
  @IsTest
  static void testMergeFieldsOk() {
    String contenido = 'Hola {firstName} {Lastname}';
    Contact contacto = TestDataFactory.getAlumnos().values().get(0);
    Map<String, SObject> objects = new Map<String, SObject>{
      'contacto' => contacto
    };

    Test.startTest();

    String mergeContent = ConstanciaHelper.mergeFields(contenido, objects);
    Test.stopTest();

    Assert.areEqual(
      mergeContent,
      'Hola ' + contacto.FirstName + ' ' + contacto.LastName
    );
  }

  @IsTest
  static void testMergeFieldsNotOK() {
    String contenido = 'Mi {campoNoexiste} content. {firstName} {Lastname}';
    Contact contacto = TestDataFactory.getAlumnos().values().get(0);
    Map<String, SObject> objects = new Map<String, SObject>{
      'contacto' => contacto
    };

    try {
      Test.startTest();
      String mergeContent = ConstanciaHelper.mergeFields(contenido, objects);
      Test.stopTest();
      Assert.fail('El {campoNoexiste} no existe');
    } catch (Exception ex) {
      // Add assertions here about the expected exception
    }
  }

  @IsTest
  static void testFetchConstancias() {
    TestDataFactory.getConstancias();
    Test.startTest();
    List<Constancia__c> constancias = ConstanciaHelper.fetchConstancias();
    Test.stopTest();

    Assert.areEqual(
      TestDataFactory.DEFAULT_RECORDS,
      constancias.size(),
      'Deben haber 3 constancias'
    );
  }

  @IsTest
  static void testGeneratePDF() {
    Constancia__c constancia = TestDataFactory.getConstancias().get('C-1');
    Contact contacto = TestDataFactory.getAlumnos().get('A-1');
    TestDataFactory.getBoletines();
    Test.startTest();
    ContentVersion content = ConstanciaHelper.generatePDF(
      constancia.Id,
      contacto.Id
    );
    Test.stopTest();

    Assert.areEqual('First1 Last1', content.VersionData.toString());
  }
}
