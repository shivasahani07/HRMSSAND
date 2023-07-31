({
    doInitAPP: function(component, event, helper) {
        debugger;
        helper.userInformation(component, event, helper);
        helper.getIntervalDetailsfromSF(component);
    },
    
    initiatePE: function(component, event, helper) {
        component.set("v.gotoHome",false);
        var currentPEStatus = component.get("v.userSummary");
        if (currentPEStatus == 'Requested') {
            var action = component.get("c.updateSummaryStatus");
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.gotoHome",false);
                    component.set("v.userSummary", 'Submitted for Approval');
                    component.set("v.showCurrentStatus", true);
                    component.set("v.showFROMPeerButton", false);
                    component.set("v.showTOPeerButton", false);
                    component.set("v.showInitiateButton", false);
                    component.set("v.showAddPeersButton", false);
                    component.set("v.fromPeersFeedback", false);
                    component.set("v.renderProvideFeedback", false);
                    component.set("v.renderInitiateFeedback", true);
                    component.set("v.toOthersFeedback", false);
                    component.set("v.selfAssessment", false);
                } else if (state === "INCOMPLETE") {
                    // do something
                } else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            //  console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        //    console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        } else {
            component.set("v.showCurrentStatus", true);
            component.set("v.showFROMPeerButton", false);
            component.set("v.showTOPeerButton", false);
            component.set("v.showInitiateButton", false);
            component.set("v.showAddPeersButton", false);
            component.set("v.fromPeersFeedback", false);
            component.set("v.renderProvideFeedback", false);
            component.set("v.renderInitiateFeedback", true);
            component.set("v.toOthersFeedback", false);
            component.set("v.selfAssessment", false);
        }
    },
    
    showHomePage: function(component, event, helper) {
        var currentPEStatus = component.get("v.userSummary");
        if (currentPEStatus == 'Requested') {
            
            component.set("v.showInitiateButton", true);
            component.set("v.showAddPeersButton", false);
            component.set("v.fromPeersFeedback", false);
        } else if (currentPEStatus == 'Closed') {
            component.set("v.showInitiateButton", fasle);
            component.set("v.fromPeersFeedback", false);
            component.set("v.showAddPeersButton", fasle);
        } else {
            component.set("v.showInitiateButton", false);
            component.set("v.fromPeersFeedback", false);
            component.set("v.showAddPeersButton", true);
        }
        component.set("v.gotoHome",true);
        component.set("v.showCurrentStatus", true);
        component.set("v.showFROMPeerButton", true);
        component.set("v.showTOPeerButton", true);
        component.set("v.renderInitiateFeedback", false);
        component.set("v.renderProvideFeedback", false);
        component.set("v.fromPeersFeedback", false);
        component.set("v.toOthersFeedback", false);
        component.set("v.selfAssessment", false);
        var cmpTarget1 = component.find('list-default-1__item');
        var cmpTarget2 = component.find('list-default-2__item');
        var cmpTarget3 = component.find('list-default-3__item');
        var cmpTarget4 = component.find('list-default-4__item');
        $A.util.addClass(cmpTarget1, 'slds-tabs_default__item slds-is-active slds-has-focus');
        $A.util.removeClass(cmpTarget2, ' slds-is-active slds-has-focus');
        $A.util.removeClass(cmpTarget3, ' slds-is-active slds-has-focus');
        $A.util.removeClass(cmpTarget4, ' slds-is-active slds-has-focus');
    },
    
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    
    provideFeedback: function(component, event, helper) {
        component.set("v.renderInitiateFeedback", false);
        component.set("v.fromPeersFeedback", false);
        component.set("v.gotoHome",false);
        component.set("v.renderProvideFeedback", true);
        component.set("v.toOthersFeedback", false);
        component.set("v.selfAssessment", false);
    },
    
    showFromPeers: function(component, event, helper) {
        // var cmpTarget = component.find('list-default-3__item');
        var cmpTarget1 = component.find('list-default-1__item');
        var cmpTarget2 = component.find('list-default-2__item');
        var cmpTarget3 = component.find('list-default-3__item');
        var cmpTarget4 = component.find('list-default-4__item');
        $A.util.addClass(cmpTarget3, 'slds-tabs_default__item slds-is-active slds-has-focus');
        $A.util.removeClass(cmpTarget1, ' slds-is-active slds-has-focus');
        $A.util.removeClass(cmpTarget2, ' slds-is-active slds-has-focus');
        $A.util.removeClass(cmpTarget4, ' slds-is-active slds-has-focus');
        component.set("v.gotoHome",false);
        component.set("v.renderInitiateFeedback", false);
        component.set("v.renderProvideFeedback", false);
        component.set("v.fromPeersFeedback", true);
        component.set("v.toOthersFeedback", false);
        component.set("v.selfAssessment", false);
    },
    
    showFeedbackToOthers: function(component, event, helper) {
        var cmpTarget1 = component.find('list-default-1__item');
        var cmpTarget2 = component.find('list-default-2__item');
        var cmpTarget3 = component.find('list-default-3__item');
        var cmpTarget4 = component.find('list-default-4__item');
        $A.util.addClass(cmpTarget4, 'slds-tabs_default__item slds-is-active slds-has-focus');
        $A.util.removeClass(cmpTarget1, ' slds-is-active slds-has-focus');
        $A.util.removeClass(cmpTarget2, ' slds-is-active slds-has-focus');
        $A.util.removeClass(cmpTarget3, ' slds-is-active slds-has-focus');
        component.set("v.gotoHome",false);
        component.set("v.renderInitiateFeedback", false);
        component.set("v.renderProvideFeedback", false);
        component.set("v.fromPeersFeedback", false);
        component.set("v.toOthersFeedback", true);
        component.set("v.selfAssessment", false);
    },
    
    selfAssessment: function(component, event, helper) {
        var cmpTarget1 = component.find('list-default-1__item');
        var cmpTarget2 = component.find('list-default-2__item');
        var cmpTarget3 = component.find('list-default-3__item');
        var cmpTarget4 = component.find('list-default-4__item');
        $A.util.addClass(cmpTarget4, 'slds-tabs_default__item slds-is-active slds-has-focus');
        $A.util.removeClass(cmpTarget1, ' slds-is-active slds-has-focus');
        $A.util.removeClass(cmpTarget2, ' slds-is-active slds-has-focus');
        $A.util.removeClass(cmpTarget3, ' slds-is-active slds-has-focus');
        component.set("v.gotoHome",false);
        component.set("v.renderInitiateFeedback", false);
        component.set("v.renderProvideFeedback", false);
        component.set("v.fromPeersFeedback", false);
        component.set("v.toOthersFeedback", false);
        component.set("v.selfAssessment", true);
    },
    
    UserDetails: function(component, event, helper) {
    },
    
    handleInitiatePE : function(component, event, helper) {
        debugger;
        var action = component.get("c.initiateSummary");
        action.setParams({
            'intervalId' : component.get("v.intervalId")
        });
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
        
    },

    handleIntervalSelection : function(component, event, helper){
        debugger;
        component.set("v.intervalSelected", true);
        component.set("v.gotoHome", true);
        var ctarget = event.currentTarget;
        var interval_ID = ctarget.dataset.value;
        component.set("v.intervalId",interval_ID);
        
        //helper.getUserDetails(component, event, helper);

        var action = component.get("c.getCurrentUserSummary");
        action.setParams({
            'intervalId' : interval_ID
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                if (result.Id != null) {

                    var allValues = response.getReturnValue();
                    component.set("v.userSummary", allValues.Status__c);
                    if (allValues.Status__c == 'Requested') {
                        component.set("v.showInitiateButton", true);
                    } else if (allValues.Status__c == 'Closed') {
                        component.set("v.showInitiateButton", false);
                        component.set("v.showAddPeersButton", false);
                    } else {
                        component.set("v.showAddPeersButton", true);
                    }

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
            else{
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    }
})