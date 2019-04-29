/**
 * Test class for CaseTriggerHandler methods.
 * Not too atomic but tests different things.
 */
@isTest
public class CaseTriggerTest {

    /**
     * Create 100 Cases for the tests.
     * Half of the Cases will have 'Check Geocoding Data' as their Subject. 
     */
    @TestSetup
    static void makeData(){
        List<Case> cases = new List<Case>();

        //Check Geocoding Data Cases
        for (Integer i = 0; i < 50; i++) {
            Case c = new Case(
                Subject = 'Check Geocoding Data'
            );
            cases.add(c);
        }

        //Other Cases
        for (Integer i = 0; i < 50; i++) {
            Case c = new Case(
                Subject = 'TestCase' + i
            );
            cases.add(c);
        }

        insert cases;
        
        Integer casesAmount = [SELECT Id FROM Case].size();
        System.assertEquals(100, casesAmount, 'Cases not inserted');
    }

    /**
     * Checks wether the UUID generation and assignation is working correctly.
     * Also checks if the UUID is 'unique enough', although not with enough Cases.
     */
    @isTest
    private static void UUIDTest() {
        Set<String> UUIDs = new Set<String>();

        for (Case currentCase : [SELECT Id, Subject, External_Id__c FROM Case]) {
            System.assertNotEquals(null, currentCase.External_Id__c, 'UUID is null');

            if (currentCase.Subject == 'Check Geocoding Data') {
                /**
                 * If the UUID is unique.
                 * This one CAN theoretically fail. 
                 * This would mean the UUID generation is not good enough for its purpose.
                 * This should ideally be tests in bulk with thousands of records.
                 */
                System.assert(UUIDs.add(currentCase.External_Id__c), 'UUID not unique');
            }
        }
    }

    /**
     * Tests whether or not the Cases with subject 'I am done' are being generated
     * after the 'Check Geocoding Data' cases are closed.
     * Does not check for UUID in order to prevent coupling between the test methods.
     */
    @isTest
    private static void doneCaseGenerationTest() {
        List<Case> cases = [SELECT Id, Status FROM Case WHERE Subject = 'Check Geocoding Data'];
        Integer caseAmount = cases.size();

        for (Case currentCase : cases) {
            currentCase.Status = 'Closed';
        }

        //Wait for Platform Event trigger to create the new cases
        Test.startTest();
            update cases;
        Test.stopTest();

        //Query again to check
        cases = [SELECT Id, isClosed FROM Case WHERE Subject = 'Check Geocoding Data'];
        System.assertEquals(caseAmount, cases.size(), 'More or less cases than initially started');
        for (Case currentCase : cases) {
            System.assert(currentCase.isClosed, 'Case didn\'t close');
        }

        cases = [SELECT Id, External_Id__c FROM Case WHERE Subject = 'I am done'];
        System.assertEquals(caseAmount, cases.size(), 
            'Some or no cases created after closing Geocoding cases');
    }

}
