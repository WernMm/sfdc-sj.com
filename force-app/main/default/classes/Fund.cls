public without sharing class Fund {
    private Fund_Master__mdt fundMaster;
    private Date last1Months = System.today().addMonths(-1);
    private Date last3Months = System.today().addMonths(-3);
    private Date last6Months = System.today().addMonths(-6);
    private Date last1Years = System.today().addYears(-1);
    private Date last2Years = System.today().addYears(-2);
    private Date last3Years = System.today().addYears(-3);

    public Fund(Fund_Master__mdt fundMaster) {
        this.fundMaster = fundMaster;
    }

    public void process() {
        Fund__c newFund = this.callout(fundMaster.DeveloperName, fundMaster.Endpoint__c);
        if(newFund != null) {
            Map<Date, Fund__c> existingFunds = this.getExistingFund();
            this.calculateBenefit(existingFunds, newFund);
            upsert newFund;
        }
    }
    
    public Map<Date, Fund__c> getExistingFund() {
        Map<Date, Fund__c> existingFunds = new Map<Date, Fund__c>();

        for(Fund__c existingFund : [SELECT Id, Fund_Name__c, Name, Bid__c, Retrieve_Date__c FROM Fund__c 
            WHERE Fund_Name__c = :fundMaster.DeveloperName AND 
            (   Retrieve_Date__c = :last1Months OR 
                Retrieve_Date__c = :last3Months OR 
                Retrieve_Date__c = :last6Months OR 
                Retrieve_Date__c = :last1Years OR 
                Retrieve_Date__c = :last2Years OR 
                Retrieve_Date__c = :last3Years)]) {
            existingFunds.put(existingFund.Retrieve_Date__c, existingFund);
        }
        return existingFunds;
    }
    
    public void calculateBenefit(Map<Date, Fund__c> existingFundsByDate, Fund__c newFund) {
        if(existingFundsByDate.containsKey(last1Months)) {
            newFund.Benefit_1Months__c = this.calculateBenefit(existingFundsByDate.get(last1Months).Bid__c, newFund.Bid__c);
        } 
        if(existingFundsByDate.containsKey(last3Months)) {
            newFund.Benefit_3Months__c = this.calculateBenefit(existingFundsByDate.get(last3Months).Bid__c, newFund.Bid__c);
        } 
        if(existingFundsByDate.containsKey(last6Months)) {
            newFund.Benefit_6Months__c = this.calculateBenefit(existingFundsByDate.get(last6Months).Bid__c, newFund.Bid__c);
        } 
        if(existingFundsByDate.containsKey(last1Years)) {
            newFund.Benefit_1Years__c = this.calculateBenefit(existingFundsByDate.get(last1Years).Bid__c, newFund.Bid__c);
        } 
        if(existingFundsByDate.containsKey(last2Years)) {
            newFund.Benefit_1Years__c = this.calculateBenefit(existingFundsByDate.get(last2Years).Bid__c, newFund.Bid__c);
        } 
        if(existingFundsByDate.containsKey(last3Years)) {
            newFund.Benefit_1Years__c = this.calculateBenefit(existingFundsByDate.get(last3Years).Bid__c, newFund.Bid__c);
        }
    }

    public Decimal calculateBenefit(Decimal existingBid, Decimal newBid) {
        if(newBid == existingBid) {
            return 0;
        } 
        return ((newBid - existingBid) / existingBid) * 100;
    }

    public Fund__c callout(String fundName, String endpoint) {
        System.debug(fundName);
        HttpRequest req = new HttpRequest();
        req.setMethod('GET');
        req.setEndpoint(endpoint);
        req.setTimeout(120000);

        Http http = new Http();
        HttpResponse res = http.send(req);
        if(res.getStatusCode() == 200) {
            String resString = res.getBody();
            resString = resString.replaceAll('\r\n', '');
            resString = resString.replaceAll('<[^>]+>',' ');
            resString = resString.replaceAll(' ','');
            // System.debug(resString);
            Integer firstBid = resString.indexOf('ราคารับซื้อคืน(Bid):');
            resString = resString.substring(firstBid);
            Integer lastBid = resString.indexOf('บาท/หน่วย');
            String bid = resString.substring(20, lastBid);

            Integer firstOffer = resString.indexOf('ราคาขาย(Offer):');
            resString = resString.substring(firstOffer);
            Integer last = resString.indexOf('บาท/หน่วย');
            String offer = resString.substring(15, last);
            System.debug(bid);
            System.debug(offer);

            Fund__c fund = new Fund__c();
            fund.Fund_Name__c = fundName;
            fund.Name = fundName + '-'+ System.now().format('yyyyMMdd-HHmm');
            fund.Offer__c = Decimal.valueOf(offer);
            fund.Bid__c = Decimal.valueOf(bid);
            fund.Retrieve_DateTime__c = System.now();
            fund.Retrieve_Date__c = System.today();
            fund.External__c = fundName + System.now().format('yyyyMMddHHmm');
            return fund;
        } else {
            System.debug('ERROR ' + fundName + ' ' + res.getStatusCode());
        }
        return null;
    }
}