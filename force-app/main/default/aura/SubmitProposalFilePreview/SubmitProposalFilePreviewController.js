({
    doInit : function(component, event, helper) {
        
        debugger;   
        var action=component.get("c.getLead_ContentDocWrapper");
        action.setParams({
            "leadId" : component.get("v.recordId")
        })
        action.setCallback(this,function(e){
            if(e.getState()=='SUCCESS'){
                var result=e.getReturnValue();
                component.set("v.fileId", result.contentDoc.Id);
                component.set("v.fileTitle", result.contentDoc.Title);
                component.set("v.defaultEmail", result.leadEmailId);
                component.set("v.cc", result.ccMailIds);
                component.set("v.content", result.emailMsg);
            }
            else{
                alert(JSON.stringify(e.getError()));
            }
        });
        $A.enqueueAction(action);        
    },
    
    handleNext : function(component, event, helper){
        component.set("v.showTemp", true);
    },
    
    handleSend : function(component, event, helper){
        var email=helper._e('txtEmail').value;
        var Subject=helper._e('txtSubject').value;
        var Message=component.get("v.content");        
        var regExpEmailformat = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/; 
        
        if(email==''){
            alert('Email-Id is required');
        }
        else if(Subject==''){
            alert('Subject is required');
        }
        else if(Message==''){
                alert('Message is required');
        }
        else{
             /*if(!email.match(regExpEmailformat)){
                   alert("Invalid Email Id");
             }
             else{*/
                   helper.SendEmail(component);
             //}
        }
    },
    
    handleCancel : function(component, event, helper){
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})