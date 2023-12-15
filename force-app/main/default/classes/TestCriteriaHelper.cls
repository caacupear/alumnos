@IsTest
public with sharing class TestCriteriaHelper {
  @IsTest
  public static void testAllSimpleOK() {
    Contact contact = new Contact(FirstName = 'Nombre', LastName = 'Apellido');
    insert contact;

    // Prueba case insensitive en lastname field y en FirstName value
    String criterias = '{ "terms": [ {"field": "FirstName", "value": "nombre"}, {"field": "lastname", "value": "Apellido"} ]}';

    Test.startTest();
    Boolean valido = CriteriaHelper.validateCriteria(criterias, contact.Id);
    Test.stopTest();

    Assert.isTrue(valido, 'la expresion ' + criterias + ' deberia ser valida');
  }

  @IsTest
  public static void testAllSimpleNotOK() {
    Contact contact = new Contact(FirstName = 'Nombre', LastName = 'Apellido');
    insert contact;

    // criterio de Apellido esta mal
    String criterias = '{ "terms": [ {"field": "FirstName", "value": "Nombre"}, {"field": "lastname", "value": "OTRO-APELLIDO"} ]}';

    Test.startTest();
    Boolean valido = CriteriaHelper.validateCriteria(criterias, contact.Id);
    Test.stopTest();

    Assert.isFalse(
      valido,
      'la expresion ' + criterias + ' no deberia ser valida'
    );
  }

  @IsTest
  public static void testAnySimpleOk() {
    Contact contact = new Contact(FirstName = 'Nombre', LastName = 'Apellido');
    insert contact;

    // criterio de Apellido esta mal, pero como esta any deberia dar true
    String criterias = '{ "terms": [ {"field": "FirstName", "value": "Nombre"}, {"field": "lastname", "value": "OTRO-APELLIDO"} ], "operator": "any" }';

    Test.startTest();
    Boolean valido = CriteriaHelper.validateCriteria(criterias, contact.Id);
    Test.stopTest();

    Assert.isTrue(valido, 'la expresion ' + criterias + ' deberia ser valida');
  }

  @IsTest
  public static void testAnySimpleNotOK() {
    Contact contact = new Contact(FirstName = 'Nombre', LastName = 'Apellido');
    insert contact;

    // ambos criterios estan mal, asi que deberia dar false
    String criterias = '{ "terms": [ {"field": "FirstName", "value": "OTRO-NOMBRE"}, {"field": "lastname", "value": "OTRO-APELLIDO"} ], "operator": "any" }';

    Test.startTest();
    Boolean valido = CriteriaHelper.validateCriteria(criterias, contact.Id);
    Test.stopTest();

    Assert.isFalse(
      valido,
      'la expresion ' + criterias + ' no deberia ser valida'
    );
  }

  @IsTest
  public static void testCustomOK() {
    Contact contact = new Contact(
      FirstName = 'Nombre',
      LastName = 'Apellido',
      MailingLongitude = 33,
      MailingLatitude = 33,
      Birthdate = Date.newInstance(1993, 1, 1)
    );
    insert contact;

    // ambos criterios estan mal, asi que deberia dar false
    String criterias = '{ "terms": [ { "terms": [ {"field": "FirstName", "value": "OTRO-NOMBRE"}, {"field": "lastname", "value": "Apellido"} ], "operator": "any" }, { "field": "MailingLatitude", "value": 33 } ] }';

    Test.startTest();
    Boolean valido = CriteriaHelper.validateCriteria(criterias, contact.Id);
    Test.stopTest();

    Assert.isTrue(valido, 'la expresion ' + criterias + ' deberia ser valida');
  }
}
