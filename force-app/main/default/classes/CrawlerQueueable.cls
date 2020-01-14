public class CrawlerQueueable implements Queueable, Database.AllowsCallouts {
    List<Fund_Master__mdt> fundMasters;
    public CrawlerQueueable(List<Fund_Master__mdt> fundMasters) {
        this.fundMasters = fundMasters;
        
    }
    public void execute(QueueableContext context) {
        Fund fund = new Fund(this.fundMasters.remove(0));
        fund.process();
        this.finish();
    }

    public void finish() {
        if(!this.fundMasters.isEmpty()) {
            CrawlerQueueable queueable = new CrawlerQueueable(fundMasters);
            ID jobID = System.enqueueJob(queueable);
        } else {
            RemoveOldFundRecord.remove();
        }
    }
}