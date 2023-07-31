public class InfoRequiredPropSubmissClas {
    
    public Lead ledRec {get;set;}
    public String leadRecordString{get;set;}
    Public InfoRequiredPropSubmissClas() {
        String recordId = Apexpages.currentPage().getParameters().get('id'); 
        ledRec = [SELECT Id,Name,FirstName,LastName,Address,Legal_Name__c,GST__c,POC_Email_Id__c,POC_Mobile_Number__c,POC_Position__c,Authorities_Email__c,Signing_Authority_Name__c,/*Followup_Date__c,*/Singing_Authority_Position__c,POC_Name__c FROM Lead WHERE ID =:recordId];
        System.debug('ledRec ::'+ledRec);
        leadRecordString=JSON.serialize(ledRec);
    }
    
    @RemoteAction
    public Static lead updateLeadData(String leadId, Lead led){
        led.Id = leadId;
        update led;
        System.debug('Updated Record ::'+led);
        return led;
    }
    
     @RemoteAction
    public Static string getUpdatedLeadData(String leadId, String legalName,string cityvalue, string statevalue, string streetvalue,String gst,String pocemail, String pcophone, String position,String authname, String authpos,String pocName,String authoEmail ){ //String leadrecId, Lead LedRecord, 
        system.debug('cityvalue====> ' + cityvalue);
        system.debug('statevalue====> ' + statevalue);
         system.debug('leadId====> ' + leadId);
        Lead led = new Lead();
        led.Id = leadId;
        if(legalName !=null){
            led.Legal_Name__c = legalName;
        }
        /*
        if(fname !=null){
            led.FirstName = fname;
        }if(lname !=null){
            led.LastName = lname;
        }
        */
        if(cityvalue !=null){
            led.City = cityvalue;
        }if(statevalue !=null){
            led.State = statevalue;
        }if(streetvalue !=null){
            led.Street = streetvalue;
        }if(gst !=null){
            led.GST__c = gst;
        }if(pocemail !=null){
            led.POC_Email_Id__c = pocemail;
        }if(pcophone !=null){
            led.POC_Mobile_Number__c = pcophone;
        }if(position !=null){
            led.POC_Position__c = position;
        }if(authname !=null){
            led.Signing_Authority_Name__c = authname;
        }if(authpos !=null){
            led.Singing_Authority_Position__c = authpos;
        } if(pocName !=null){
            led.POC_Name__c = pocName;
        }
        if(authoEmail !=null){
            led.Authorities_Email__c = authoEmail;
        }
        upsert led;
       System.debug('Updated Lead Record ::'+led);
       return 'SUCCESS';
    }
    
    @RemoteAction
    public Static lead updateLeadDate(String leadId, integer day, integer month, integer year ){
        lead led = new lead();
        led.Id = leadId;
        if(day==0 && month==0 && year==0){
        }else{
            //led.Followup_Date__c = Date.newInstance(year, month, day);
        }
        // led.Followup_Date__c = leddate;
        update led;
        return led;
    }
    
    
}