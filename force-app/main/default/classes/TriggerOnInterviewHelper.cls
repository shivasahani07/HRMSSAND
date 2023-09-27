public class TriggerOnInterviewHelper {
    Public static void updateAverageRattingOnContact(List<Interview__c> interviewList){
        List<contact> candidatesTobeUpdate= new  List<contact>();
        set<id> candidateIds = new set<id>();
        for(Interview__c intv: interviewList){
            if( intv.Candidate__c !=null){
                candidateIds.add(intv.Candidate__c);
            }
            
        }
        
        List<contact> candidatesTobeUpdateRatings=[SELECT Id,Name,Average_Rating__c,(SELECT id,Name,Start_Date_Time__c,End_Date_Time__c,Type__c,Round__c,Candidate__c,Interview__c.Ratings__c FROM Interviews1__r) FROM contact where id In:candidateIds];
        for(contact cn:candidatesTobeUpdateRatings){
            //cn.Average_Rating__c 
            
            DECIMAL averageRatin;
            integer totalInterview;
            if( cn.Average_Rating__c != null){
                
	            cn.Average_Rating__c=(5*totalInterview/averageRatin*totalInterview);
                
            }
            
            for(Interview__c intv: cn.Interviews1__r){
                if( intv.Ratings__c !=null){
                    totalInterview +=1;
                    averageRatin+=intv.Ratings__c;
                }
                
            }
            if( cn.Average_Rating__c != null){
                candidatesTobeUpdate.add(cn);
                
            }
            
        }
        if(candidatesTobeUpdate !=null){
            update candidatesTobeUpdate ;
        }
        
    }
    
}