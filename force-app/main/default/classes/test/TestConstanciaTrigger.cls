@IsTest
public with sharing class TestConstanciaTrigger {
    
    @IsTest
    static void testValidateContentOk() {

        List<Constancia__c> constanciasPrevias = [SELECT Id FROM Constancia__c];
        
        Test.startTest();
        List<Constancia__c> constancias = new List<Constancia__c>();
        constancias.add( new Constancia__c( Name='Test', Contenido__c = 'Test {firstName}') );

        insert constancias;
        Test.stopTest();
        List<Constancia__c> constanciasPost = [SELECT Id FROM Constancia__c];

        Assert.areEqual(constanciasPrevias.size() + 1 , constanciasPost.size(), 'Espero que haya creado la constancia' );
        
    }

    @IsTest
    static void testValidateContentFailed() {

        List<Constancia__c> constanciasPrevias = [SELECT Id FROM Constancia__c];
        
        Test.startTest();
        List<Constancia__c> constancias = new List<Constancia__c>();
        constancias.add( new Constancia__c( Name='Test', Contenido__c = 'Test {firstNames}') );
        try {
            insert constancias;
            
        } catch (DmlException e ){

        }

        Test.stopTest();
        List<Constancia__c> constanciasPost = [SELECT Id FROM Constancia__c];

        Assert.areEqual(constanciasPrevias.size()  , constanciasPost.size(), 'Espero que haya creado la constancia' );
        
    }

}