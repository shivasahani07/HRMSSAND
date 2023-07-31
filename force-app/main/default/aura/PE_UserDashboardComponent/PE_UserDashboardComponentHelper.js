({
    userInformation: function(component, event, helper) {
        var action=component.get("c.getUser");
        action.setCallback(this, function(response) {
            
            var userDetail = response.getReturnValue();
            component.set("v.UserName",userDetail);
            //console.log(userDetail);
            
        });
        $A.enqueueAction(action); 
    },
    getIntervalDetailsfromSF: function(component) {
        debugger;
        var action = component.get("c.getIntervalDetailsSFDC");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.ListofIntervals", response.getReturnValue());
                if (component.get("v.ListofIntervals.length") % 2 != 0) {
                    //console.log('*****!!!1');
                    var lengthnew = component.get("v.ListofIntervals.length") - 1;
                    //var  indexValue =parseInt(lengthnew);
                    component.set("v.lastElement", lengthnew);
                    var tempArray = [];
                    tempArray = component.get("v.ListofIntervals");
                    var lastIndex = component.get("v.lastElement");
                    //alert("tempArray:::"+JSON.stringify(tempArray));
                    var lastValue = [];
                    var lastValue = tempArray[lastIndex];
                    component.set("v.lastArray", lastValue);
                }
            } else if (state === "INCOMPLETE") {} else if (state === "ERROR") {}
        });
        $A.enqueueAction(action);
    },

    // getUserDetails: function(component, event, helper) {
    //     debugger;
    //     var action = component.get("c.getUserSummaryStatus");
    //     action.setParams({
    //         'intervalId' : component.get("v.intervalId")
    //     })
    //     action.setCallback(this, function(response) {
    //         var state = response.getState();
    //         if (state === "SUCCESS") {
    //             if (response.getReturnValue() != null) {
    //                 var allValues = response.getReturnValue();
    //                 component.set("v.userSummary", allValues.Status__c);
    //                 if (allValues.Status__c == 'Requested') {
    //                     component.set("v.showInitiateButton", true);
    //                 } else if (allValues.Status__c == 'Closed') {
    //                     component.set("v.showInitiateButton", false);
    //                     component.set("v.showAddPeersButton", false);
    //                 } else {
    //                     component.set("v.showAddPeersButton", true);
    //                 }
    //             }
    //         } else if (state === "INCOMPLETE") {
    //             // do something
    //         } else if (state === "ERROR") {
    //             var errors = response.getError();
    //             if (errors) {
    //                 if (errors[0] && errors[0].message) {
    //                     //   console.log("Error message: " + errors[0].message);
    //                 }
    //             } else {
    //                 //  console.log("Unknown error");
    //             }
    //         }
    //     });
    //     $A.enqueueAction(action);
    // },    
})