({
    doInit: function(component, event, helper) {
        debugger;
        var action = component.get("c.fetchUserRoleDetails");
        helper.selectedUserInformation(component, event, helper);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var allValues = response.getReturnValue();
                var opts = [];
                var usrs = [];
                var usrsList = [];
                var roleNames = allValues.roleNames;
                for (var i = 0; i < roleNames.length; i++) {
                    opts.push(roleNames[i]);
                }
                var usr = allValues.allUsers;
                for (var i = 0; i < usr.length; i++) {
                    usrs.push(usr[i]);
                    var options = {
                        value: usr[i].Id
                        , label: usr[i].Name
                    };
                    usrsList.push(options);
                }
                component.set("v.listOptions", usrsList);
                component.set("v.users", usrs);
                component.set("v.currentUsersList", usrs);
                component.set("v.roles", opts);
                component.set("v.allUsersData", allValues);
            } else if (state === "INCOMPLETE") {
                // do something
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        //     console.log("Error message: " + errors[0].message);
                    }
                } else {
                    //     console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
    , scriptsLoaded: function(component, event, helper) {
        // active/call select2 plugin function after load jQuery and select2 plugin successfully    
        $(".select2Class").select2({
            placeholder: "Select Multiple Users"
            , style: "width: 140px;!important"
        });
    }
    /* ,onChangeFunction : function(component, event, helper) {        
                    
                    var allValues = component.get("v.allUsersData");        
                    var usrs = [];
                    var usrsNames = [];
                    var usrsList  = [];
                    var allUsers = [];
                    allUsers =  allValues[0].allUsers;
                    var usrs = allValues[0].roleUserWrapList;
                   
                   // component.set("v.users",usrsNames);       
                    var roleSelected = component.find("roleSelected").get("v.value");
                    
                    if(roleSelected == "All Roles"){            
                                     
                         for (var i = 0; i < allUsers.length; i++) {                 
                             usrsNames.push(allUsers[i]);   
                             
                             var options = { value: allUsers[i].Id, label: allUsers[i].Name };
                             usrsList.push(options);      
                        }   
                    }else{
                        for (var i = 0; i < usrs.length; i++) {                
                            if(usrs[i].roleNAme == roleSelected){
                                var roleUsers = usrs[i].userList;                    
                                for (var j = 0; j < roleUsers.length; j++) {                  
                                   usrsNames.push(roleUsers[j]);
                                    
                                   var options = { value: roleUsers[j].Id, label: roleUsers[j].Name };
                             	   usrsList.push(options);      
                                } 
                            }                    
                        }  
                        
                        var usrsSelected = [];
                        usrsSelected = component.get("v.selectedOptions"); 
                        
                        for(var i = 0; i < usrsSelected.length; i++){
                            var userPresent = false;
                            for(var j = 0; j < usrsNames.length; j++){
                            	if(usrsNames[j].Id == usrsSelected[i]){
                                	userPresent = true;
                                }
                        	}
                            
                            if(userPresent == false){
                                for(var j = 0; j < allUsers.length; j++){
                                    if(allUsers[j].Id == usrsSelected[i]){
                                        var options = { value: allUsers[j].Id, label: allUsers[j].Name };
                             	   		usrsList.push(options); 
                                    }
                                }
                            }
                        }
                    }
                    
                    component.set("v.users",usrsNames); 
                    component.set("v.currentUsersList",usrsNames);
                    component.set("v.listOptions",usrsList)
                } */
    , RemindUsers: function(component, event, helper) {
        debugger;
        var action = component.get("c.reminderEmail");
        action.setCallback(this, function(response) {
            var state = response.getState();
            var userDetail = response.getReturnValue();
            if (state === "SUCCESS") {
                if (userDetail > 0) {
                    component.set("v.errorMessage", "Reminder Sent Successfully!.");
                    component.set("v.onCreationOfFeedback", true);
                } else {
                    component.set("v.errorMessage", "You don't have any pending feedback");
                    component.set("v.isOpen", true);
                }
            }
        });
        $A.enqueueAction(action);
    },

    addUsersToList: function(component, event, helper) {
        debugger;
        var selectedUsersList = [];
        var currentListusers = [];
        selectedUsersList = $('[id$=picklist]').select2("val");
        //	console.log(existingSelectedUser);
        if (selectedUsersList != null) {
            var usrsSelected = [];
            var existingSelectedUser = [];
            var validUsers = true;
            currentListusers = component.get("v.currentUsersList");
            usrsSelected = component.get("v.selectedOptions");
            existingSelectedUser = component.get("v.selectedOptions");
            //  	console.log(selectedUsersList);
            //    	console.log(existingSelectedUser);
            var existingVarCheck = false;
            for (var i = 0; i < selectedUsersList.length; i++) {
                var existingVar = false;
                for (var j = 0; j < existingSelectedUser.length; j++) {
                    if (selectedUsersList[i] == existingSelectedUser[j]) {
                        existingVarCheck = true;
                        existingVar = true;
                        validUsers = false;
                        component.set("v.errorMessage", "User is already exist.");
                        component.set("v.isOpen", true);
                    } else {}
                }
                if (existingVarCheck == false) {
                    usrsSelected.push(selectedUsersList[i]);
                }
            }
            if (validUsers == true) {
                var emptyArr = [];
                component.set("v.users", emptyArr);
                component.set("v.users", currentListusers);
                console.log('@@@@');
                console.log(usrsSelected);
                component.set("v.selectedOptions", usrsSelected);
            }
        } else {
            component.set("v.errorMessage", "Select the users to add");
            component.set("v.isOpen", true);
        }
    }
    , createFeedback: function(component, event, helper) {
        var usrIds = [];
        usrIds = component.get("v.selectedOptions");
        //     console.log('usrIds' + usrIds);
        if (usrIds.length > 0) {
            var action = component.get("c.createPEFeedbackRecord");
            action.setParams({
                "userIds": usrIds
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    component.set("v.errorMessage", "PE request is placed successfully.");
                    component.set("v.onCreationOfFeedback", true);
                } else {
                    component.set("v.errorMessage", "Please Select less than 10 users  at a time.");
                    component.set("v.isOpen", true);
                    console.log(state);
                }
            });
            $A.enqueueAction(action);
        } else {
            component.set("v.errorMessage", "Please select the users before you Request Feedback.");
            component.set("v.isOpen", true);
        }
    }
    , closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
    }
    , closeCreationModal: function(component, event, helper) {
        component.set("v.onCreationOfFeedback", false);
        var appEvent = $A.get("e.c:PE_InitiateEvent");
        appEvent.setParams({
            "message": "RedirectToHomepage"
        });
        appEvent.fire();
    }
    , showSpinner: function(component, event, helper) {
        //alert("lightning");
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true);
        debugger;
    }, // this function automatic call by aura:doneWaiting event 
    hideSpinner: function(component, event, helper) {
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    }
})