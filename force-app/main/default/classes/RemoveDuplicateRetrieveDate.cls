public without sharing class RemoveDuplicateRetrieveDate {
    public RemoveDuplicateRetrieveDate() {

    }

    public static void remove() {
        List<Fund__c> fundsToRemove = new List<Fund__c>();
        Fund__c previousFund;
        for(Fund__c eachFund : [SELECT ID, Fund_Name__c, Retrieve_Date__c  FROM Fund__c WHERE Fund_Name__c = 'K20SLTF' ORDER BY Retrieve_Date__c ASC, Retrieve_DateTime__c ASC]) {
            if(previousFund == null) {
                previousFund = eachFund;
                continue;
            }
            if(previousFund.Retrieve_Date__c == eachFund.Retrieve_Date__c) {
                fundsToRemove.add(previousFund);
            }
            previousFund = eachFund;
        }

        if(!fundsToRemove.isEmpty()) {
            System.debug(fundsToRemove.size());
            delete fundsToRemove;
            // for(Fund__c eachFund : fundsToRemove) {
            //     System.debug(eachFund);
            // }
        }
    }
}