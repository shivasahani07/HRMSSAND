({
    doInit : function(component, event, helper) {
        //helper.getFeedBackLineItemsAccRecType(component);
       // var  fbLineItems = []; 
        //fbLineItems = component.get("v.fblineitemList");
        helper.getSectionWiseFeedbackLineItems(component, event, helper);

    }
})