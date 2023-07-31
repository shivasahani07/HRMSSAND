public class PE_ResponseFormController {
    @AuraEnabled
    public static String getUser(String feedbackId){
        String key = System.Label.FeedbackKey;
        integer  mid = key.length() / 2;
        List<String> SplitedString =  new List<String>();
        SplitedString.add(key.substring(0, mid));
        SplitedString.add(key.substring(mid));
        System.debug('@@@@'+SplitedString);
        String reversedkey= SplitedString[0].reverse() + '1996' +SplitedString[1].reverse();
        
        System.debug('reversedkey'+reversedkey);
        
        Blob cryptoKey = Blob.valueOf(reversedkey);
        Blob dataFid = EncodingUtil.base64Decode(feedbackId); 
        Blob dataToDecryptFid = Crypto.decryptWithManagedIV('AES128', cryptoKey, dataFid);             
        String decryptedDataFid = dataToDecryptFid.toString(); 
        String feedback = [select id ,User__c from PE_Feedback_New__c where id=:decryptedDataFid].User__c;
        String userName = [select id,name from user where id=:feedback].Name;
        
        System.debug('aaaa'+userName);
        return userName;
    }
    
    
    @AuraEnabled
    public static PE_ModelClass.PELineItemWrapper getPEFeedItemQuestions(String feedbackId,String roleid){
        System.debug(feedbackId);
        System.debug(roleid);
        PE_Question__c peQun = new PE_Question__c();                    
        List<PE_Question_Item__c> peQunLineItems    = new List<PE_Question_Item__c>();  
        List<PE_ModelClass.PEQunWrapper> peQunWrapperList         = new List<PE_ModelClass.PEQunWrapper>(); 
        List<PE_ModelClass.PEResponseWrapper> peResWrapperList    = new List<PE_ModelClass.PEResponseWrapper>(); 
        List<PE_Feedback_Item__c> feedbackLineItemList = new List<PE_Feedback_Item__c>();
        String decryptedDataFid;  
        String decryptedDataRid; 
        String statusOfpe = '';
        Date CloseDateOfPE;
        try{
            String key = System.Label.FeedbackKey;
            integer  mid = key.length() / 2;
            List<String> SplitedString =  new List<String>();
            SplitedString.add(key.substring(0, mid));
            SplitedString.add(key.substring(mid));
            //  System.debug('@@@@'+SplitedString);
            String reversedkey= SplitedString[0].reverse() + '1996' +SplitedString[1].reverse();
            
            //     System.debug('reversedkey'+reversedkey);
            
            Blob cryptoKey = Blob.valueOf(reversedkey);
            Blob dataFid = EncodingUtil.base64Decode(feedbackId); 
            Blob dataToDecryptFid = Crypto.decryptWithManagedIV('AES128', cryptoKey, dataFid);             
            decryptedDataFid = dataToDecryptFid.toString(); 
            //      System.debug('decryptedDataFid:::'+decryptedDataFid);
            
            Blob dataRid = EncodingUtil.base64Decode(roleid);        
            Blob dataToDecryptRid = Crypto.decryptWithManagedIV('AES128', cryptoKey, dataRid);             
            decryptedDataRid = dataToDecryptRid.toString();
            //  System.debug('decryptedDataRid::::'+decryptedDataRid);
            //  System.debug('decryptedDataFid===>'+decryptedDataFid);
            
            PE_Feedback_New__c feedbackRecord = [SELECT id,Status__c,PE_Closed_Date__c,(SELECT Id,Name,Answer__c,PE_Feedback__r.RecordType.Id,PE_Feedback__c,PE_Question_Item__r.Field_Type__c,PE_Question_Item__r.Mandatory__c,PE_Question_Item__r.PE_Question__c,PE_Question_Item__r.Pick_List_Type__c,
                                                                                        PE_Question_Item__r.Pick_List_Values__c,PE_Question_Item__r.Question__c,PE_Question_Item__r.Question_Type__c,PE_Question_Item__c
                                                                                        FROM PE_Feedback_Item__r) FROM PE_Feedback_New__c
                                                 WHERE Id =:decryptedDataFid LIMIT 1
                                                ];
            
            if(feedbackRecord.Status__c != null){
                statusOfpe   = feedbackRecord.Status__c;
                feedbackLineItemList = feedbackRecord.PE_Feedback_Item__r;
                CloseDateOfPE = feedbackRecord.PE_Closed_Date__c;
                System.debug('feedbackLineItemList====>'+feedbackRecord);
            }
            
            
            //  System.debug('feedbackLineItemList===>'+feedbackLineItemList);
            //  System.debug('statusOfpe===>'+statusOfpe);
            
            peQunLineItems = [SELECT Id,Name,Question_Type__c,Mandatory__c,PE_Question__r.Role_Name__c,Field_Type__c,Question__c,Pick_List_Type__c,PE_Question__r.Status__c,PE_Question__r.Name,Pick_List_Values__c
                              From PE_Question_Item__c
                              WHERE PE_Question__r.Status__c = 'Active'
                              AND PE_Question__r.Role_Id__c =: decryptedDataRid
                              ORDER BY Name ASC];
            
            if(feedbackLineItemList.size() == 0 && statusOfpe == 'Open' && !peQunLineItems.isEmpty() ){
                /*System.debug('Hello:::::');*/
                for(PE_Question_Item__c peQunLineItem : peQunLineItems){
                    String[] allPickVals = new List<String>();
                    if(peQunLineItem.Pick_List_Values__c != null){
                        allPickVals=(peQunLineItem.Pick_List_Values__c).split(',', 0);
                    }
                    //   System.debug('allPickVals:::'+allPickVals);
                    PE_ModelClass.PEQunWrapper peWrapper = new PE_ModelClass.PEQunWrapper(peQunLineItem.Id,peQunLineItem.Field_Type__c,peQunLineItem.Pick_List_Type__c,allPickVals,peQunLineItem.Question__c,peQunLineItem.Mandatory__c,peQunLineItem.Question_Type__c);
                    peQunWrapperList.add(peWrapper); 
                    
                }
                
            }else if(feedbackLineItemList.size() > 0 && (statusOfpe == 'In Draft' || statusOfpe == 'Submitted')){
                
                for(PE_Feedback_Item__c feedbackItem : feedbackLineItemList){ 
                    List<String> allPickVals = new List<String>();
                    List<String> selectedMulpickVals = new List<String>();
                    if(feedbackItem.PE_Question_Item__r.Pick_List_Values__c != null ){
                        allPickVals=(feedbackItem.PE_Question_Item__r.Pick_List_Values__c).split(',', 0);
                    }
                    if(feedbackItem.PE_Question_Item__r.Pick_List_Type__c == 'Multi-Select' && feedbackItem.PE_Question_Item__r.Field_Type__c == 'Select List'){
                        selectedMulpickVals = (feedbackItem.Answer__c).split(',', 0);
                    }
                    System.debug('TTTT'+feedbackItem.PE_Question_Item__r.Question_Type__c);
                    PE_ModelClass.peResponseWrapper peResWrapper = new PE_ModelClass.peResponseWrapper(feedbackItem.id,feedbackItem.PE_Question_Item__r.Id,feedbackItem.PE_Question_Item__r.Field_Type__c,feedbackItem.PE_Question_Item__r.Pick_List_Type__c,allPickVals,selectedMulpickVals,feedbackItem.PE_Question_Item__r.Question__c,feedbackItem.PE_Question_Item__r.Mandatory__c,feedbackItem.PE_Question_Item__r.Question_Type__c,feedbackItem.Answer__c,statusOfpe,CloseDateOfPE);
                    peResWrapperList.add(peResWrapper);
                    
                }
            } else{
                //  System.debug('Hello:::::');
                return null;
            }
            
            //     System.debug('peQunWrapperList==>'+peQunWrapperList);
            //     System.debug('peResWrapperList===>'+peResWrapperList);
            
            
            PE_ModelClass.PELineItemWrapper pelineItemWrapper  = new PE_ModelClass.PELineItemWrapper();
            pelineItemWrapper.pequnListWrapper   = peQunWrapperList.clone();
            pelineItemWrapper.responseWrapper    = peResWrapperList.clone();
            pelineItemWrapper.feedbackStatus     = statusOfpe;
            pelineItemWrapper.CloseDate =CloseDateOfPE;
            //System.debug('pelineItemWrapper===>'+pelineItemWrapper);
            return pelineItemWrapper;
            
        }catch(Exception e){
            //return null;
            //throw new excException(e.getMessage());
            return null;
        }
        
    }
    
    @AuraEnabled
    public static string submitResponse(String responseItems,String feedbackId){
        
        //System.debug('responseItems=====$$$$$$$'+responseItems);
        List<PE_ModelClass.PEResponseWrapper> responseLineItems  = (List<PE_ModelClass.PEResponseWrapper>)JSON.deserialize(responseItems, List<PE_ModelClass.PEResponseWrapper>.class);
        
        //   System.debug('responseLineItems===>'+responseLineItems);
        List<PE_Feedback_Item__c> feedbackLineItemList = new List<PE_Feedback_Item__c>();
        try{
            String decryptedDataFid;  
            String decryptedDataRid; 
            String key = System.Label.FeedbackKey;
            integer  mid = key.length() / 2;
            List<String> SplitedString =  new List<String>();
            SplitedString.add(key.substring(0, mid));
            SplitedString.add(key.substring(mid));
            //System.debug('@@@@'+SplitedString);
            String reversedkey= SplitedString[0].reverse() + '1996' +SplitedString[1].reverse();
            
            System.debug('reversedkey'+reversedkey);
            
            Blob cryptoKey = Blob.valueOf(reversedkey);
            Blob dataFid = EncodingUtil.base64Decode(feedbackId); 
            Blob dataToDecryptFid = Crypto.decryptWithManagedIV('AES128', cryptoKey, dataFid);             
            decryptedDataFid = dataToDecryptFid.toString(); 
            //  System.debug('decryptedDataFid:::'+decryptedDataFid);
            
            /*  Blob dataRid = EncodingUtil.base64Decode(roleid);        
Blob dataToDecryptRid = Crypto.decryptWithManagedIV('AES128', cryptoKey, dataRid);             
decryptedDataRid = dataToDecryptRid.toString();
System.debug('decryptedDataRid::::'+decryptedDataRid);
System.debug('decryptedDataFid===>'+decryptedDataFid);*/
            
            
            String feedbackStatus = '';
            PE_Feedback_New__c feedbackRec = [SELECT Id,Name,Users_Role_Id__c,Users_Role__c,User__c,Status__c,PE_Closed_Date__c
                                              FROM PE_Feedback_New__c 
                                              WHERE ID =:decryptedDataFid 
                                              LIMIT 1];
            if(feedbackRec != null){
                feedbackStatus = feedbackRec.Status__c;
            }else{
                return null;
            }
            
            //  System.debug('feedbackStatus==>'+feedbackStatus);
            
            for(PE_ModelClass.PEResponseWrapper peQuns : responseLineItems){
                //    System.debug('QWERTY'+peQuns.response);
                if(peQuns.response !=null && peQuns.response !='' && peQuns.response !=' ' ){
                    
                    PE_Feedback_Item__c feedbackLineItem =  new PE_Feedback_Item__c();
                    feedbackLineItem.PE_Question_Item__c = peQuns.qunLineItemId;
                    if(peQuns.response == '--None--' && peQuns.fieldTyp == 'picklist'){
                        feedbackLineItem.Answer__c      = '';
                    }else if(peQuns.fieldTyp == 'multipicklist'){
                        String str = '';
                        for(Integer i= 0 ; i < peQuns.picklistVal.size() ; i++ ){
                            str += peQuns.picklistVal[i];
                            if(i != peQuns.picklistVal.size() -1){
                                str += ',';
                            }
                            feedbackLineItem.Answer__c  = str;
                        }
                    }else{
                        feedbackLineItem.Answer__c      = peQuns.response;
                    }
                    feedbackLineItem.PE_Feedback__c = decryptedDataFid;
                    
                    if(feedbackStatus == 'In Draft'){
                        feedbackLineItem.Id = peQuns.feedbackLineItemId;
                    }
                    feedbackLineItemList.add(feedbackLineItem);
                }
                
            }
            if(!feedbackLineItemList.isEmpty()){
                if(feedbackStatus == 'In Draft'){
                    upsert feedbackLineItemList;
                } else{
                    insert feedbackLineItemList;  
                }
            }
            
            if(feedbackRec!=null){
                feedbackRec.Status__c = 'Submitted';
                update feedbackRec;
                
            }
            // }
            return 'Success';
        }catch(exception e){
            //return null;
            //             System.debug('eeee'+e.getLineNumber());
            //           System.debug('eeee'+e.getMessage());
            //  throw new excException(e.getMessage());
            return null;
        }  
        
    }
    
    
    @AuraEnabled
    public static string saveAsDraft(String responseItems,String feedbackId){
        
        List<PE_ModelClass.PEResponseWrapper> responseLineItems          = (List<PE_ModelClass.PEResponseWrapper>)JSON.deserialize(responseItems, List<PE_ModelClass.PEResponseWrapper>.class);
        //    System.debug('responseLineItems===>'+responseLineItems);
        List<PE_Feedback_Item__c> feedbackLineItemList = new List<PE_Feedback_Item__c>();
        //String decryptedDataFid;
        String feedbackStatus = '';
        try{
            
            String decryptedDataFid;  
            String decryptedDataRid; 
            String key = System.Label.FeedbackKey;
            integer  mid = key.length() / 2;
            List<String> SplitedString =  new List<String>();
            SplitedString.add(key.substring(0, mid));
            SplitedString.add(key.substring(mid));
            //      System.debug('@@@@'+SplitedString);
            String reversedkey= SplitedString[0].reverse() + '1996' +SplitedString[1].reverse();
            
            //    System.debug('reversedkey'+reversedkey);
            
            Blob cryptoKey = Blob.valueOf(reversedkey);
            Blob dataFid = EncodingUtil.base64Decode(feedbackId); 
            Blob dataToDecryptFid = Crypto.decryptWithManagedIV('AES128', cryptoKey, dataFid);             
            decryptedDataFid = dataToDecryptFid.toString(); 
            //   System.debug('decryptedDataFid:::'+decryptedDataFid);
            
            /*  Blob dataRid = EncodingUtil.base64Decode(roleid);        
Blob dataToDecryptRid = Crypto.decryptWithManagedIV('AES128', cryptoKey, dataRid);             
decryptedDataRid = dataToDecryptRid.toString();
System.debug('decryptedDataRid::::'+decryptedDataRid);
System.debug('decryptedDataFid===>'+decryptedDataFid);*/
            
            
            
            PE_Feedback_New__c feedbackRec = [SELECT Id,Name,Users_Role_Id__c,Users_Role__c,User__c,Status__c,PE_Closed_Date__c
                                              FROM PE_Feedback_New__c 
                                              WHERE ID =:decryptedDataFid 
                                              LIMIT 1];
            if(feedbackRec != null){
                feedbackStatus = feedbackRec.Status__c;
            }else{
                return null;
            }
            
            //System.debug('feedbackStatus==>'+feedbackStatus);
            
            for(PE_ModelClass.PEResponseWrapper peQuns : responseLineItems){
                PE_Feedback_Item__c feedbackLineItem =  new PE_Feedback_Item__c();
                feedbackLineItem.PE_Question_Item__c = peQuns.qunLineItemId;
                if(peQuns.response == '--None--' && peQuns.fieldTyp == 'picklist'){
                    feedbackLineItem.Answer__c      = '';
                }else if(peQuns.fieldTyp == 'multipicklist'){
                    String str = '';
                    for(Integer i= 0 ; i < peQuns.picklistVal.size() ; i++ ){
                        str += peQuns.picklistVal[i];
                        if(i != peQuns.picklistVal.size() -1){
                            str += ',';
                        }
                        feedbackLineItem.Answer__c  = str;
                    }
                }else{
                    feedbackLineItem.Answer__c      = peQuns.response;
                }
                feedbackLineItem.PE_Feedback__c = decryptedDataFid;
                if(feedbackStatus == 'In Draft'){
                    feedbackLineItem.Id = peQuns.feedbackLineItemId;
                }
                feedbackLineItemList.add(feedbackLineItem);
            }
            
            
            if(!feedbackLineItemList.isEmpty()){
                if(feedbackStatus == 'In Draft'){
                    upsert feedbackLineItemList;
                } else{
                    insert feedbackLineItemList;  
                }
            }
            
            if(feedbackRec!=null){
                feedbackRec.Status__c = 'In Draft';
                update feedbackRec;
                
            }
            return 'Success';
        }catch(exception e){
            //return null;
            //      System.debug('eeee'+e.getLineNumber());
            //     System.debug('eeee'+e.getMessage());
            // throw new exception(e.getMessage());
            return null;
        }  
    }
    
    
    
}