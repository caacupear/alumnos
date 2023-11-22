@IsTest
public class TestDivisionController {
    @IsTest
    static void testController(){
        
        Test.startTest();
        Division__c division = TestDataFactory.getDivisiones().get('D-1');

        DivisionController.getCiclosVigentes() ;

        Test.stopTest();   
    }

}