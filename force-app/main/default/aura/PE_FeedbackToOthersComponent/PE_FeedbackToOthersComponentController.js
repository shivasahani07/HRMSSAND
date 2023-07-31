({
    doInit : function(component, event, helper) {
        helper.getListOfUsers(component, event, helper);
        //helper.getfeedbackStatuspickvals(component, event, helper);
    },


    getUsersForFeedbackStatus:function(component, event, helper){
            var target = event.target;
            var dataIndex = target.getAttribute("data-selected-Index");

           // alert("dataEle:::"+dataIndex);

    },
    
    changeShowLineItemStatus:function(component,event,helper){
        // var target = event.target;
        //var rowIndex = target.getAttribute("data-selected-Index");
       // alert('dataIndex'+rowIndex);
       debugger;

        var rowIndex            =  event.getSource().get("v.name");
        var wrapperList 		=  component.get("v.userWithLineItemWrapperList");
        //alert('indexItems======>'+JSON.stringify(wrapperList[rowIndex].feedbackLineItemList));

       
        if(wrapperList[rowIndex].feedbackStatus != "Submitted"){
            component.set("v.showOptions",false);
            component.set("v.showLineItems",false);
            var redirectURL =  wrapperList[rowIndex].redirectUrl;
            window.open(redirectURL);
             /* var urlEvent = $A.get("e.force:navigateToURL");
              alert(JSON.stringify(urlEvent));
              alert( wrapperList[rowIndex].redirectUrl);
              var redirectURL =  wrapperList[rowIndex].redirectUrl;
             urlEvent.setParams({
                "url": redirectURL
            });
            urlEvent.fire();*/
        }else{
        component.set("v.showBoxes",false);
        component.set("v.feedbackLineItemList",wrapperList[rowIndex].feedbackLineItemList);
        component.set("v.showOptions",true);   
        component.set("v.showLineItems",false);

        
        //component.set("v.showLineItems",true);
        //alert('section&&&&&&'+component.get("v.feedbackLineItemList"));
        helper.getFeedbackRecordTypeWrapper(component,component.get("v.feedbackLineItemList"));
       }
    },
    
    /*hideLineItems : function(component, event, helper){
        var feedbackliList = [];
        feedbackliList = component.get("v.feedbackLineItemList");
        alert(JSON.stringify(feedbackliList));
        if(feedbackliList.length > 0){
            component.set("v.showLineItems",true);
        }else{
           component.set("v.showLineItems",false);
           }
    },*/
    
    
    back: function(component, event, helper) {
        component.set("v.showBoxes", true);
        component.set("v.showOptions",false);
        component.set("v.showLineItems",false);
    },
    
    getMiniFeedback: function(component, event, helper) {
        var recordType = "Mini Form";
        component.set("v.feedbackLineItemList",component.get("v.miniFormList"));
        /*hideLineItems(component, event, helper);*/
        var feedbackliList = [];
        feedbackliList = component.get("v.feedbackLineItemList");
        //alert(JSON.stringify(feedbackliList));
        if(feedbackliList.length > 0){
            component.set("v.showLineItems",true);
        }else{
            component.set("v.showLineItems",false);
        }
        /* component.set("v.showFeedbackType", true);
        component.set("v.showFeedbacks", true);
        component.set("v.chosenRDType", recordType);*/
        
        
    },
    
    getPEFeedback: function(component, event, helper) {
        var recordType = "PE Form";
        component.set("v.feedbackLineItemList",component.get("v.peFormList"));
        /*hideLineItems(component, event, helper);*/
        var feedbackliList = [];
        feedbackliList = component.get("v.feedbackLineItemList");
        //alert(JSON.stringify(feedbackliList));
        if(feedbackliList.length > 0){
            component.set("v.showLineItems",true);
        }else{
            component.set("v.showLineItems",false);
        }
        //component.set("v.showLineItems",true);   
        /* component.set("v.showFeedbackType", true);
        component.set("v.showFeedbacks", true);
        component.set("v.chosenRDType", recordType);*/
    },
    getNonPEFeedback: function(component, event, helper) {
        var recordType = "Full Form";
        component.set("v.feedbackLineItemList",component.get("v.fullFormList"));
        /*this.hideLineItems(component, event, helper);*/
        var feedbackliList = [];
        feedbackliList = component.get("v.feedbackLineItemList");
        //alert(JSON.stringify(feedbackliList));
        if(feedbackliList.length > 0){
            component.set("v.showLineItems",true);
        }else{
            component.set("v.showLineItems",false);
        }
        /*component.set("v.showFeedbackType", true);
        component.set("v.showFeedbacks", true);
        component.set("v.chosenRDType", recordType);*/
    },
    getAllPEFeedback: function(component, event, helper) {
        var recordType = "All";
        /*this.hideLineItems(component, event, helper);*/
        var feedbackliList = [];
        
        component.set("v.feedbackLineItemList",component.get("v.allFeedbackLineItemsforUser"));
        
        feedbackliList = component.get("v.feedbackLineItemList");
        //alert(JSON.stringify(feedbackliList));
        //alert(JSON.stringify(feedbackliList));
        if(feedbackliList.length > 0){
            component.set("v.showLineItems",true);
        }else{
            //alert("Yo mann, it is breaking here!!!!");
            component.set("v.showLineItems",false);
        }
        //component.set("v.genericList",component.get("v.feedbackLineItemList"));  
        /*component.set("v.showFeedbackType", true);
        component.set("v.showFeedbacks", true);
        component.set("v.chosenRDType", recordType);*/
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