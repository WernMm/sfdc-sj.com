@isTest
private class Crawler_Test {

    @isTest
    static void testCalculateBenefit() {
        Crawler crawler = new Crawler();
        System.assertEquals(100, crawler.calculateBenefit(10, 20));
        System.assertEquals(300, crawler.calculateBenefit(10, 40));
        System.assertEquals(50, crawler.calculateBenefit(10, 15));
        System.assertEquals(-50, crawler.calculateBenefit(10, 5));
        System.assertEquals(-100, crawler.calculateBenefit(10, 0));
        System.assertEquals(-400, crawler.calculateBenefit(10, -30));
    }

    @isTest
    static void testGetExistingFund() {
        String fundName = 'BBL';
        List<Fund__c> mockFunds = new List<Fund__c>();
        Date last1Months = System.today().addMonths(-1);
        Date last3Months = System.today().addMonths(-3);
        Date last6Months = System.today().addMonths(-6);
        Date last1Years = System.today().addMonths(-12);

        mockFunds.add(Crawler_Test.createFund(fundName, System.now().addMonths(-1), 20));
        mockFunds.add(Crawler_Test.createFund(fundName, System.now().addMonths(-3), 0));
        mockFunds.add(Crawler_Test.createFund(fundName, System.now().addMonths(-6), 30));
        mockFunds.add(Crawler_Test.createFund(fundName, System.now().addYears(-1), 10));
        insert mockFunds;

        Test.startTest();
        Crawler crawler = new Crawler();
        Map<String, Map<Date, Fund__c>> existingFunds = crawler.getExistingFund();
        Test.stopTest();

        System.assertEquals(1, existingFunds.size());
        System.assertEquals(4, existingFunds.get(fundName).size());
        System.assertEquals(last1Months, existingFunds.get(fundName).get(last1Months).Retrieve_Date__c);
        System.assertEquals(mockFunds.get(0).Id, existingFunds.get(fundName).get(last1Months).Id);
        System.assertEquals(last3Months, existingFunds.get(fundName).get(last3Months).Retrieve_Date__c);
        System.assertEquals(mockFunds.get(1).Id, existingFunds.get(fundName).get(last3Months).Id);
        System.assertEquals(last6Months, existingFunds.get(fundName).get(last6Months).Retrieve_Date__c);
        System.assertEquals(mockFunds.get(2).Id, existingFunds.get(fundName).get(last6Months).Id);
        System.assertEquals(last1Years, existingFunds.get(fundName).get(last1Years).Retrieve_Date__c);
        System.assertEquals(mockFunds.get(3).Id, existingFunds.get(fundName).get(last1Years).Id);
    }

    static Fund__c createFund(String fundName, DateTime retrieveDateTime, Decimal bid) {
        Fund__c fund = new Fund__c();
        fund.Name = fundName;
        fund.Bid__c = bid;
        fund.Retrieve_Date__c =  date.newinstance(retrieveDateTime.year(), retrieveDateTime.month(), retrieveDateTime.day());
        fund.Retrieve_DateTime__c = retrieveDateTime;
        return fund;
    }
}