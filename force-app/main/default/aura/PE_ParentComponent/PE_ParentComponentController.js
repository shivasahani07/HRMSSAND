({
    
    doInit: function(component, event, helper) {
        debugger;
        helper.getIntervalDetailsfromSF(component);
        var action = component.get("c.getCurrentUserSummary");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if ( result.Id != null) {
                    component.set("v.showExistingScreen", true);
                    if(result.ApprovalStatus__c === 'Approved'){
                        component.set("v.disable", false);
                    }
                    else{
                        component.set("v.disable", true);
                    }
                }
                else{
                    component.set("v.showExistingScreen", false);
                }
            } 
            else {
                var errors = response.getError();
                if(errors){
                    if (errors[0] && errors[0].message) {
                       console.log("Error message: " + errors[0].message);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    handleInitiatePE : function(component, event, helper) {
        debugger;
        var action = component.get("c.initiateSummary");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if ( result != null) {
                    var url = 'https://sales-production--hrmsdemo.sandbox.lightning.force.com/lightning/r/Summary__c/' + result + '/view';;
                    var payload = { eventType: 'MyEvent', data: url }; 
                    window.postMessage(payload, '*');
                }
            } 
            else {
                var errors = response.getError();
                if(errors){
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
            }
        });
        $A.enqueueAction(action);
        
    }
})