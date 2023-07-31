({
    getListOfUsers : function(component, helper, event) {
        var action = component.get("c.getListOfUsersAndLineItems");
        
        action.setCallback(this, function(data) {
             //alert(data.getState());
            if(data.getState() == "SUCCESS"){
               // alert(data.getReturnValue());
                if(data.getReturnValue() != null){
                    var result = data.getReturnValue();
                    //alert("result---->"+JSON.stringify(result));
                    component.set("v.userWithLineItemWrapperList",result);
                  //  console.log(result);

                }else{
                    //Show Error Messag saying he hasn't given feedback to this person
                }      
            }
            else if (data.getState() == "ERROR"){
                $A.log("Errors", data.getError());
            }
        });
        $A.enqueueAction(action);   
        
    },



    getfeedbackStatuspickvals : function(component, helper, event) {
        var action = component.get("c.getFeedbackStatuses");
        action.setCallback(this, function(data) {
            if(data.getState() == "SUCCESS"){
                if(data.getReturnValue() != null){
                    var result = data.getReturnValue();
                    alert(JSON.stringify(result));
                    component.set("v.feedbackStatusPicklistValuesWrapper",result);
                    
                }else{
                    
                }      
            }
            else if (data.getState() == "ERROR"){
                $A.log("Errors", data.getError());
            }
        });
        $A.enqueueAction(action);   
        
    },
    
    getFeedbackRecordTypeWrapper : function(component, feedbackLineItemList) {
        
        var action = component.get("c.getFeedbackLineItemsByRecordType");
        
        action.setParams({
            "feedbackLineItems"  : JSON.stringify(feedbackLineItemList),          
        });
        
        action.setCallback(this, function(data) {
            //alert('data.getState()---->'+data.getState());
            if(data.getState() == "SUCCESS"){
                //alert('data.getReturnValue()---->'+data.getReturnValue());
                if(data.getReturnValue() != null){
                    var result = [];
                    result = data.getReturnValue();
                    //alert('Oe lucky lucky oye===>'+JSON.stringify(result));
                    /* for(var key in result){
                        if(result.hasOwnProperty(key)) {
                            alert(JSON.stringify(result[key]));
                        }
                    }*/
                    
                    
                    var fullFormList = [];
                    var miniFormList = [];
                    var peFormList   = [];
                    var allflList    = [];
                    //alert(result.length);
                    /* for(var i = 0; i < result.length; i++){
                        alert('aiiiiii'+JSON.stringify(result));
                        if(result.recordTypeName == 'Full Form'){
                            fullFormList = result.feedBackItemList;
                        }else if(result.recordTypeName == 'Mini Form'){
                            miniFormList = result.feedBackItemList;
                        }else if(result.recordTypeName == 'PE Form'){
                            peFormList = result.peFormList;
                        }
                    }*/
                    
                    for(var key in result){
                        var flList = [];
                        flList = result[key];
                        if(key == "Full Form"){
                            fullFormList = flList;
                        }else if(key == 'Mini Form'){
                            miniFormList = flList;
                        }else if(key == 'PE Form'){
                            peFormList = flList;
                        }else if(key == 'All'){
                            allflList = flList;
                        }
                    }
                    
                    component.set("v.peFormList",peFormList);
                    component.set("v.miniFormList",miniFormList);
                    component.set("v.fullFormList",fullFormList);
                    component.set("v.allFeedbackLineItemsforUser",allflList);
                }else{
                }     
            }
            else if (data.getState() == "ERROR"){
                $A.log("Errors", data.getError());
            }
        });
        $A.enqueueAction(action);   
        
    }
    
    
})