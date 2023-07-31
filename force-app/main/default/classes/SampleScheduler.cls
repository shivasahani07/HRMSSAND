global class SampleScheduler implements Schedulable{
    global void execute(SchedulableContext SC){ 
        batchClassToextendjiraTaskdate b = new batchClassToextendjiraTaskdate();
		database.executeBatch(b,20);
    }
}