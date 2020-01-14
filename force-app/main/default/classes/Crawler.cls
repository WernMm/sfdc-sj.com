public without sharing class Crawler {
    public Crawler() {

    }

    public static void process() {
        List<Fund_Master__mdt> fundMasters = [SELECT DeveloperName, Endpoint__c FROM Fund_Master__mdt WHERE Is_Active__c = true];
        CrawlerQueueable queueable = new CrawlerQueueable(fundMasters);
        ID jobID = System.enqueueJob(queueable);
    }
}