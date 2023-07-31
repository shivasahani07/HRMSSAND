({
	fethUsers : function(component, event, helper) {
		
		var action = component.get("c.fetchUserRoleDetails");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
             	var allValues = response.getReturnValue();	

             //   console.log('&&&&&----'+JSON.stringify(allValues));			
                var usrs = [];
                var usrsList = [];
               
                var usr = allValues.allUsers;               
				for (var i = 0; i < usr.length; i++) {
                    usrs.push(usr[i]);
                    
                    var options = { value: usr[i].Id, label: usr[i].Name };
                    usrsList.push(options);                    
                }
                
                component.set("v.listOptions", usrsList);
                component.set("v.users",usrs);  
                component.set("v.allDetails",allValues);             
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set("v.errorMessage","Please try again");
                     	component.set("v.isOpen",true);  
                    }
                } else {
                    component.set("v.errorMessage","Please try again");
                     component.set("v.isOpen",true);  
                }
            }
        });      
        $A.enqueueAction(action);
	},closeModel :  function(component, event, helper) {
		component.set("v.isOpen",false);
	},scriptsLoaded1 : function(component, event, helper) {
		
       // active/call select2 plugin function after load jQuery and select2 plugin successfully    
       $(".select2ClassNew").select2({
           placeholder: "Select Multiple values"
       });
    },giveFeedback : function(component, event, helper) {
    	 var formSelected =  component.find("formType").get("v.value");
    	

         var selectedUser = $('[id$=picklist]').select2("val");
        //  console.log("***--"+selectedUser);  
         var allDetails = component.get("v.allDetails");
       //  console.log('******'+allDetails[0].loggedInUSerId);
         var prvdUsr = allDetails[0].loggedInUSerId;

         var users = component.get("v.allDetails");
       /* for (var i = 0; i < users.length; i++) {
            if(selectedUser = users[i].Id){

            }                
        }  */
                

        if(formSelected == 'Mini Form'){
    	 	
    	 	var urlString = "https://extentor--eleavemod--c.cs72.visual.force.com/apex/PE_MiniFormPage?" + selectedUser +"&"+ prvdUsr;
    	 	window.open(urlString);
    	 }else if(formSelected == 'Full Form'){
    	 	window.open('https://extentor--eleavemod--c.cs72.visual.force.com/apex/PE_ResponseFormPage');
  
    	}else if (formSelected == ''){
    		component.set("v.errorMessage","Select the form type");
            component.set("v.isOpen",true);  
    	} 
    }, 
})