@isTest
public class TestDivisionTrigger {
    @IsTest
    static void testRecordNames(){
        
        Test.startTest();
        // Valida el insert 
        TestDataFactory.getDivisiones();
        Division__c division = [Select Name, nombre__c From Division__c Limit 1];
        System.assertEquals(division.Name, division.nombre__c);
        // Valida el update
        division.anoEscolar__c = 2;
        division.subdivision__c = 'C';
        update division;
        Division__c divisionActualizada = [Select Name, nombre__c From Division__c Limit 1];
        System.assertEquals(divisionActualizada.Name, divisionActualizada.nombre__c);


        Test.stopTest();
        
    }

}