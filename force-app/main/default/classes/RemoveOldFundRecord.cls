public without sharing class RemoveOldFundRecord {
    public RemoveOldFundRecord() {

    }
    
    public static void remove() {
        Date cretiriaDate = System.today().addDays(-740);
        List<Fund__c> oldFunds = [select id from fund__c where retrieve_date__c < :cretiriaDate];
        System.debug(oldFunds.size());
        if(!oldFunds.isEmpty()) {
            delete oldFunds;
        }
    }
}