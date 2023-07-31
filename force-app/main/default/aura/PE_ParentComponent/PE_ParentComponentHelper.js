({
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
})