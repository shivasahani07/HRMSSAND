({
    doInit : function(component, event, helper) {
       debugger;
        var action = component.get("c.getSelfAssessmentFeedbackRecord");
        action.setCallback(this, function(data) {
            if(data.getState() == "SUCCESS"){
                var result = data.getReturnValue();
                if(result.Id != null){
                    component.set("v.peFeedback",result);
                }     
            }
            else if (data.getState() == "ERROR"){
                $A.log("Errors", data.getError());
            }
        });
        $A.enqueueAction(action); 
    },
    
    handleNewFeedback:function(component,event,helper){
        debugger;
        var action = component.get("c.createSelfFeedbackRecord");
        action.setCallback(this, function(data) {
            if(data.getState() == "SUCCESS"){
                var result = data.getReturnValue();
                if(result != null){
                    window.open(result);
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
    
     handleDraftFeedback:function(component,event,helper){
        debugger;
        var action = component.get("c.returnURL");
        action.setCallback(this, function(data) {
            if(data.getState() == "SUCCESS"){
                var result = data.getReturnValue();
                if(result != null){
                    window.open(result);
                }else{
                    //Show Error Messag saying he hasn't given feedback to this person
                }      
            }
            else if (data.getState() == "ERROR"){
                $A.log("Errors", data.getError());
            }
        });
        $A.enqueueAction(action);         
    }
    
})