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
}
