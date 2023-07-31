({
    handleCreateHoliday: function(component, event) {
        debugger;
        var saveContactAction = component.get("c.createHoliday");
        saveContactAction.setParams({
            "calendarEvent": component.get("v.newHoliday")
        });
        
        // Configure the response handler for the action
        saveContactAction.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                component.set("v.message", "Holiday created successfully");
            }
            else if (state === "ERROR") {
                console.log('Problem saving Holiday, response state: ' + state);
            }
                else {
                    console.log('Unknown problem, response state: ' + state);
                }
        });
        $A.enqueueAction(saveContactAction);
    },
})