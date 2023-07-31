({
	doInit: function(component, event, helper) {
        debugger;
       // alert('ff');
		var getUrlParameter = function getUrlParameter(sParam) {
			var sPageURL = decodeURIComponent(window.location.search.substring(1))
				, sURLVariables = sPageURL.split('&&')
				, sParameterName, i;
			//console.log('sPageURL');
			//console.log(sPageURL);
			for (i = 0; i < sURLVariables.length; i++) {
				sParameterName = sURLVariables[i].split('-');
                debugger;
				if (sParameterName[0] === sParam) {
					return sParameterName[1] === undefined ? true : sParameterName[1];
					//console.log( sParameterName[1]);
				}
			}
		};
		//set the userRole param value to my src attribute
		component.set("v.feedbackSFId", getUrlParameter('fid'));
		component.set("v.userRole", getUrlParameter('rid'));
		// component.set("v.keytemp", getUrlParameter('keytemp'));
		//console.log('******');
		//console.log(component.get("v.feedbackSFId"));
		//console.log('&&&&&');
		//console.log(component.get("v.userRole"));
		//console.log('#####');
		// console.log(component.get("v.keytemp"));
		helper.getFeedbackFrom(component);
	    helper.userInformation(component, event, helper);
	}
	, onSubmit: function(component, event, helper) {
		/* helper.checkValidity(component,event,helper);*/
		helper.submitFeedbackForm(component, event, helper);
	}
	, onClickDraft: function(component, event, helper) {
		/*helper.checkValidity(component,event,helper);*/
		helper.saveAsDraft(component, event, helper);
	}
	, handleChange: function(component, event, helper) {
		/* var selectedOptionsList = event.getParam("value");
	   // get the updated/changed source  
		var targetName = event.getSource().get("v.name");

		alert(selectedOptionsList+""+targetName);*/
	}
	, closeModel: function(component, event, helper) {
		component.set("v.showErrorSection", false);
	}
	, closeModel1: function(component, event, helper) {
		// for Hide/Close Model,set the "isOpen" attribute to "False"  
		component.set("v.isOpen1", false);
	}
	, likenClose1: function(component, event, helper) {
		
	},
	showSpinner: function(component, event, helper) {
		//alert("lightning");
		// make Spinner attribute true for display loading spinner 
		component.set("v.Spinner", true);
		//debugger;
	},
	// this function automatic call by aura:doneWaiting event 
	hideSpinner: function(component, event, helper) {
		// make Spinner attribute to false for hide loading spinner    
		component.set("v.Spinner", false);
	}
, })