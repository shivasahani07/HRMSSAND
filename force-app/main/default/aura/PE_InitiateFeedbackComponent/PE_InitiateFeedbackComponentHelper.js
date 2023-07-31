({
	selectedUserInformation: function(component, event, helper) {
    var action=component.get("c.selecteduserList");
    action.setCallback(this, function(response) {
               
    var userDetail = response.getReturnValue();
                  component.set("v.SelectedUserNames",userDetail);
              //  console.log('###'+userDetail);
                  
            });
             $A.enqueueAction(action); 
}
    
})