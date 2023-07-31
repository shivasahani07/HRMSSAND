// THIS CLASS HAS BEEN CREATED BY SHIVA FOR PROJECT CREATION HANDLER ==PROJECT MANAGEMENT DASHBOARD

public class ProjectDemoHelper {
    Public Static void AllProjectList(){
        list<Project__c> projectList = [SELECT Account__c,Active__c,CreatedById,CreatedDate,Id,IsDeleted,LastActivityDate,LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Name,Project_End_Date__c,Project_Start_Date__c,Resource_Price_Rate__c,Salesforce_Products__c,SystemModstamp,Type__c FROM Project__c];
        SYSTEM.debug('projectList::'+projectList);
    }
    
    Public Static Project__c ProjectCreation(){
        Project__c projRec = new Project__c();
        projRec.Name='';
        projRec.Account__c='';
        projRec.Active__c=TRUE;
        projRec.Project_End_Date__c=SYSTEM.today();
        projRec.Project_Start_Date__c=SYSTEM.today();
       // projRec.Resource_Price_Rate__c=;
        projRec.Salesforce_Products__c=
        projRec.Type__c='NEW';
        INSERT projRec;
        return projRec;
    }
    
}