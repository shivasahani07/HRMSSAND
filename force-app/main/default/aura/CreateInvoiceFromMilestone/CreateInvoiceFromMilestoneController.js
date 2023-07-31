({
    doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.getMilestoneData");
        action.setParams({
            recordId : component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var milestoneRec = response.getReturnValue();
                const date = new Date();
                
                var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
                
                var invoiceRec = component.get("v.invoiceRec");
                invoiceRec.Due_Date__c = response.getReturnValue().Tentative_Date_of_Payment__c;
                invoiceRec.Genration_Date__c = today;
                invoiceRec.Description__c = response.getReturnValue().Name__c;
                invoiceRec.Project_Cost__c = response.getReturnValue().Milestone_Weightage_Rs__c;
                invoiceRec.GST__c = 0.18;
                invoiceRec.Account__c = response.getReturnValue().Account__c;
                
                component.set("v.invoiceRec", invoiceRec);
            }
        });
        $A.enqueueAction(action);
    },
    onStatusChange: function (cmp, evt, helper) {
        var statusValue = cmp.find('select').get('v.value');
        var invoiceRec = component.get("v.invoiceRec");
        invoiceRec.Status__c = cmp.find('select').get('v.value');
        component.set("v.invoiceRec", invoiceRec);
    },
    onCheckBoxChange : function (cmp, evt, helper) {
        var statusValue = cmp.find('select').get('v.value');
        var invoiceRec = component.get("v.invoiceRec");
        invoiceRec.is_Hours_Applicable__c = cmp.find('select').get('v.value');
        component.set("v.invoiceRec", invoiceRec);
    }, 
    handleSave : function(component, event, helper) {
        debugger;
        var action = component.get("c.saveInvoiceRecord");
        action.setParams({
            invoiceRecord : component.get("v.invoiceRec")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
            }
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();
        });
        $A.enqueueAction(action);
    },
    handleCancel : function(component, event, helper) {
        debugger;
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    },
})