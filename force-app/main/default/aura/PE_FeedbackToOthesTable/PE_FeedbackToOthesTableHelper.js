({
    getSectionWiseFeedbackLineItems : function(component,event,helper) {
        //alert("here");
        var feedbackLineItemList = component.get("v.fblineitemList");
        var action = component.get("c.getfbLineItemSectionWiseWrapperList");
        action.setParams({
            "flItems"  : JSON.stringify(feedbackLineItemList),
            
        });
       /* alert("here");*/
        action.setCallback(this, function(data) {
            if(data.getState() == "SUCCESS"){
                //alert(data.getState()+"Status")
                if(data.getReturnValue() != null){
                    var result = data.getReturnValue();
                    component.set("v.sectionWiseWrapper",result);
                    /*console.log("Sectionwise wrapper======>"+JSON.stringify(result));*/
                    //alert("helllo"+JSON.stringify(component.get("v.sectionWiseWrapper")));

                }else{
                    
                }   
                
                
            }
            else if (data.getState() == "ERROR"){
                $A.log("Errors", data.getError());
            }
        });
        $A.enqueueAction(action);   
        
    },
 
})