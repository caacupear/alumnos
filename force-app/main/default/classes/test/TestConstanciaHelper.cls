@IsTest
public with sharing class TestConstanciaHelper {
    @IsTest
    static void testMergeFields() {
        String contenido = 'Mi {Titulo} content. {firstName} {Lastname}';
        Contact contacto = new Contact( FirstName = 'Juan', LastName = 'Pedro');
        Map<String, Object> fields = new Map<String, Object>{'titulo' => 'Test', 'hoy' => Date.today() };

        String mergeContent = ConstanciaHelper.mergeFields( contenido, contacto, fields);

        Assert.areEqual( mergeContent, 'Mi Test content. Juan Pedro' );
    }
}