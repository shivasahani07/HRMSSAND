({
    getDetails : function(component, event, helper) {
        debugger;
        helper.getIntervals(component, event, helper);
        helper.getfeedback(component, event, helper);	
    },
    showSpinner: function(component, event, helper) {
        //alert("lightning");
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true);
        //	debugger;
    },
    // this function automatic call by aura:doneWaiting event 
    hideSpinner: function(component, event, helper) {
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    }
})