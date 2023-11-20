@IsTest
public class TestDivisionController {
    @IsTest
    static void testController(){
        
        Test.startTest();
        Division__c division = TestDivisionTrigger.getDivisiones().get('1A');

        DivisionController.getCiclosVigentes() ;

        Test.stopTest();   
    }

}