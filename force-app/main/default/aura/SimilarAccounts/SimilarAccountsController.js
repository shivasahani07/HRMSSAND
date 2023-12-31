({
    doInit : function(component, event, helper) {
        debugger;
        var action = component.get("c.getAccounts");
        
        action.setParams({
            "recordId" : component.get('v.recordId')
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var result= response.getReturnValue();
                if(result != null && result != undefined){
                    component.set("v.AccountsWithSimilarCIN", result);
                }
                else{
                    component.set("v.showImage", true);
                }
            }
            
        });      
        $A.enqueueAction(action);
    }
})