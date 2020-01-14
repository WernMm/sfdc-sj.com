global class CrawlerSchedulable implements Schedulable, Database.AllowsCallouts {
   global void execute(SchedulableContext sc) {
      Crawler.process();
   }
}