({
    doInit : function(component, event, helper) {
        debugger;       
        var action = component.get("c.getDataDemo");
        action.setParams({
            "recordId": component.get("v.recordId")
        });
        
        action.setCallback(this, function(response){
            var State = response.getState();
            if(State === "SUCCESS"){
                var result = response.getReturnValue();
                component.set("v.DemoTaskWrapperRecord", result);
                let subj = result.tsk.Subject;
                if(subj.includes("Internal")){
                    component.set("v.Internal_Subject", true);
                    component.set("v.Internal_Date", result.dmo.Internal_Demo_Date_Time__c);
                }
                else if(subj.includes("Dry Run")){
                    component.set("v.Dry_Run_Subject", true);
                    component.set("v.Dry_Date", result.dmo.Dry_Run_Date_Time__c);
                }
                else if (subj.includes("Client Demo")){
                        component.set("v.Client_Demo_Subject", true);
                        component.set("v.Client_Date", result.dmo.Demo_Date_Time__c);
                }
            }
        });
        $A.enqueueAction(action);	
    },
    
    doSave : function(component,event,helper){
        debugger;
        var demoTskWrapper = component.get("v.DemoTaskWrapperRecord");
        var demoRec = component.get("v.DemoTaskWrapperRecord").dmo;
        let subj = demoTskWrapper.tsk.Subject;
        var Internal_Date = component.get("v.Internal_Date");
        var Dry_Date = component.get("v.Dry_Date");
        var Client_Date = component.get("v.Client_Date");
        
        if( (subj.includes("Internal") && (Date.parse(demoRec.Internal_Demo_Date_Time__c) <= Date.parse(Internal_Date) || demoRec.Internal_Demo_Feedback__c == null)) || (subj.includes("Dry Run") && (Date.parse(demoRec.Dry_Run_Date_Time__c) <= Date.parse(Dry_Date) || demoRec.Dry_run_feedback__c == null)) || (subj.includes("Client Demo") && (Date.parse(demoRec.Demo_Date_Time__c) <= Date.parse(Client_Date) || demoRec.Client_Demo_Feedback__c == null)) ){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Warning',
                message: 'Date should be future date and Feedback should be filled!',
                duration:' 5000',
                key: 'info_alt',
                type: 'warning',
                mode: 'pester'
            });
            toastEvent.fire();
        }
        else{
            var action = component.get("c.updateDemo");
            action.setParams({
                "demo": demoRec,
                "recid" : component.get("v.recordId")
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                if(state === "SUCCESS"){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Success',
                        message: 'Need Amendment Done Successfully!',
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'success',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    var dismissActionPanel = $A.get("e.force:closeQuickAction");
                    dismissActionPanel.fire();
                } 
                else{
                    var errors= response.getError();
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message:errors[0].message,
                        duration:' 5000',
                        key: 'info_alt',
                        type: 'error',
                        mode: 'pester'
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    doCancel : function(component, helper, event){
        debugger;        
        $A.get("e.force:closeQuickAction").fire();   
    } 
})