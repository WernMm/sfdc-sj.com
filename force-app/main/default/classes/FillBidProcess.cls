public without sharing class FillBidProcess {
    public FillBidProcess() {

    }

    public static void fill() {
        Fund__c previousFund;
        List<Fund__c> newFunds = new List<Fund__c>();
        for(Fund__c eachFund : [SELECT ID, Fund_Name__c, Bid__c, Retrieve_Date__c FROM Fund__c WHERE Fund_Name__c = 'KFLTFDIV' ORDER BY Retrieve_Date__c ASC]) {
            if(previousFund == null) {
                previousFund = eachFund;
            }
            previousFund.Retrieve_Date__c = previousFund.Retrieve_Date__c.addDays(1);
            while(previousFund.Retrieve_Date__c < eachFund.Retrieve_Date__c) {
                Fund__c newFund = new Fund__c();
                newFund.Fund_Name__c = previousFund.Fund_Name__c;
                newFund.Retrieve_Date__c = previousFund.Retrieve_Date__c;
                newFund.Bid__c = previousFund.Bid__c;
                newFunds.add(newFund);
                previousFund.Retrieve_Date__c = previousFund.Retrieve_Date__c.addDays(1);
            }
            previousFund = eachFund;
        }
        if(!newFunds.isEmpty()) {
            System.debug(newFunds.size());
            for(Fund__c newFund : newFunds) {
                System.debug(newFund.Retrieve_Date__c + ' ' + newFund.Bid__c);
            }
            insert newFunds;
        }
    }
}