trigger FundTrigger on Fund__c (before insert) {
    for(Fund__c newFund : Trigger.new) {
        if(newFund.Retrieve_DateTime__c == null) {
            newFund.Retrieve_DateTime__c = newFund.Retrieve_Date__c;
        }

        if(String.isBlank(newFund.Name)) {
            newFund.Name = newFund.Fund_Name__c + '-'+ newFund.Retrieve_DateTime__c.format('yyyyMMdd-HHmm');
        }

        if(String.isBlank(newFund.External__c)) {
            newFund.External__c = newFund.Name + newFund.Retrieve_DateTime__c.format('yyyyMMddHHmm');
        }
    }
}