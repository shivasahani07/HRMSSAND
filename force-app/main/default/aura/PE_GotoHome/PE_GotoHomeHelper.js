({
    getIntervals : function(component, event, helper) {
        debugger;
        var action = component.get("c.getinterval");
        action.setParams({
            'intervalId' : component.get("v.intervalId")
        })
        action.setCallback(this, function(response) {
            //   console.log(response);
            var state = response.getState();
            if (state === "SUCCESS") {
                //    console.log(response.getReturnValue());
                var result = response.getReturnValue();
                //  console.log('result'+result);
                component.set("v.IntervalName", result.Name);
            }
            
        });
        $A.enqueueAction(action);
    },
    getfeedback : function(component, event, helper) {
        debugger;
        var action = component.get("c.getFeedback");
        action.setParams({
            'intervalId' : component.get("v.intervalId")
        })
        action.setCallback(this, function(response) {
            //  console.log(response);
            var state = response.getState();
            if (state === "SUCCESS") {
                // console.log(response.getReturnValue());
                var result = response.getReturnValue();
                //  console.log('result'+result);
                component.set("v.CountForFeedback", result);
            }
            
        });
        $A.enqueueAction(action);
    }
})