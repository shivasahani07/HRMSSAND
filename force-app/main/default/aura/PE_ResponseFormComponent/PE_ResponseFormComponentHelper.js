({
        userInformation: function(component, event, helper) {
                var action = component.get("c.getUser");
                action.setParams({
                        "feedbackId": component.get("v.feedbackSFId")
                });
                action.setCallback(this, function(response) {
                        var userDetail = response.getReturnValue();
                        component.set("v.UserName", userDetail);
                        //	console.log(userDetail);
                });
                $A.enqueueAction(action);
        }
        , saveAsDraft: function(component, event, helper) {
                //	debugger;
                var responseItems = component.get("v.peQunLineItems");
                component.set("v.showErrorSection", false);
                for (var i = 0; i < responseItems.length; i++) {
                        if (responseItems[i].fieldTyp == 'multipicklist') {
                                var opts = [];
                                for (var j = 0; j < responseItems[i].selectedMulPickVals.length; j++) {
                                        opts.push(responseItems[i].selectedMulPickVals[j]);
                                }
                                responseItems[i].picklistVal = opts;
                        }
                }
                //var validCheck = helper.checkValidity(component, event, helper);
                //var validCheck = component.find('OverallComment').reduce(function (validSoFar, inputCmp) {inputCmp.showHelpMessageIfInvalid();						return validSoFar && !inputCmp.get('v.validity').valueMissing;}, true);
                //console.log(validCheck);
                var alertCheck = confirm("Feedback will be shared only after Submit. To Edit, click on same link !!");
                if (alertCheck) { // true becuase on draft you can fill null
                        var action = component.get("c.saveAsDraft");
                        action.setParams({
                                "responseItems": JSON.stringify(responseItems)
                                , "feedbackId": component.get("v.feedbackSFId")
                        });
                        action.setCallback(this, function(response) {
                                if (response.getState() == "SUCCESS") {
                                        if (response.getReturnValue() == "Success") {
                                                //this.generalSuccessActions(component,event, helper,"Feedback Form is saved as Draft","Please use the same link from the mail to complete the form, Thank you.");
                                                component.set("v.showForm", false);
                                                component.set("v.showErrorSection", false);
                                                component.set("v.showGeneralMsg", true);
                                                component.set("v.msgHeading", "Feedback Form is saved as Draft");
                                                component.set("v.msgDetail", "Please use the same link from the mail to complete the form, Thank you.");
                                        } else {}
                                } else if (response.getState() == "ERROR") {
                                        $A.log("Errors", response.getError());
                                }
                        });
                        $A.enqueueAction(action);
                }
        }
        , checkValidity: function(component, event, helper) {
                debugger;
                var isValidd = true;
                var field = "";
                var validity = null;
                var checkVal = 'no value';
                field = component.find("OverallComment");
                if(field) {
                    var output = component.find("OverallComment").get("v.value");
                 	//console.log('@@@' + output);
                    if (!field.get("v.validity").valid) {
                            //   console.log('sueeeeeeggistion');
                            isValidd = false;
                            field.showHelpMessageIfInvalid();
                    } else if (/^\s+$/.test(output)) {
                            isValidd = false;
                            alert('Only spaces are not allowed');
                    } else if (/\S/.test(output)) {
                            isValidd = true;
                    } else {
                            isValidd = true;
                    }
                }
                
               
                return isValidd;
        }
        , checkblank: function(component, event, helper) {
                var outputValue = component.find("OverallComment").get("v.value");
                var field1 = component.find("OverallComment");
                if (outputValue.trim().length == 0) {
                        field1.set("v.errors", [{
                                message: "Input not a number: "
                        }]);
                }
        }
        , getFeedbackFrom: function(component, event, helper) {
                var feedbackid = component.get("v.feedbackSFId");
                var roleid = component.get("v.userRole");
            	debugger;
                //	console.log("roleid----->" + roleid);
                //	console.log("feedbackid----->" + feedbackid);
                var action = component.get("c.getPEFeedItemQuestions");
                action.setParams({
                        "feedbackId": feedbackid
                        , "roleid": roleid
                });
                action.setCallback(this, function(data) {
                        if (data.getState() == "SUCCESS") {
                           		var today = new Date();
                                if (data.getReturnValue() != null) {
                                   console.log(data.getReturnValue());
                                        var result = data.getReturnValue();
                                    console.log('@@@@'+today);
                                    var otherDay = new Date(result.CloseDate);
                                    console.log(result.CloseDate);
                                    console.log('otherDay'+otherDay);
                                       if (otherDay< today) {
                                           component.set("v.showForm", false);
                                                component.set("v.peQunLineItems", []);
                                                component.set("v.showErrorSection", false);
                                                component.set("v.showGeneralMsg", true);
                                                component.set("v.msgHeading", "PE link has been expired");
                                                component.set("v.msgDetail", "PE feedback for this interval has been closed");
                                                component.set("v.msgIcon", "standard:resource_absence");
                                       }else{
                                        var controllerRes = [];
                                        if (result.feedbackStatus == 'In Draft') {
                                                controllerRes = result.responseWrapper;
                                                //	console.log("result.responseWrapper===>" + JSON.stringify(result.responseWrapper));
                                        } else if (result.feedbackStatus == 'Open') {
                                                controllerRes = result.pequnListWrapper;
                                                //	console.log("result.pequnListWrapper===>" + JSON.stringify(result.pequnListWrapper));
                                        } else if (result.feedbackStatus == 'Submitted') {
                                                component.set("v.showForm", false);
                                                component.set("v.peQunLineItems", []);
                                                component.set("v.showErrorSection", false);
                                                component.set("v.showGeneralMsg", true);
                                                component.set("v.msgHeading", "Feedback Already Submitted");
                                                component.set("v.msgDetail", "Once feedback is submitted you can't change it");
                                                component.set("v.msgIcon", "action:update_status");
                                        }
                                        //alert(JSON.stringify(controllerRes));
                                        //component.set("v.peQunLineItems",controllerRes);
                                       
                                        if (controllerRes.length == 0) {
                                                component.set("v.showForm", false);
                                        } else {
                                                component.set("v.showErrorSection", false);
                                                component.set("v.showForm", true);
                                        }
                                        for (var i = 0; i < controllerRes.length; i++) {
                                          //  console.log(controllerRes[i].qunType);
                                                if ((controllerRes[i].qunType == 'techSkill'  || controllerRes[i].qunType == 'Competency/ Technical Skills')&& component.get("v.techQunsExists") == false) {
                                                        component.set("v.techQunsExists", true);
                                                }
                                                if ((controllerRes[i].qunType == 'sSkills' || controllerRes[i].qunType == 'Soft Skills') && component.get("v.sSkillsQunExists") == false) {
                                                        component.set("v.sSkillsQunExists", true);
                                                }
                                                if ((controllerRes[i].qunType == 'projectCon' || controllerRes[i].qunType == 'Project Contribution') && component.get("v.projQunsExists") == false) {
                                                        component.set("v.projQunsExists", true);
                                                }
                                                if (controllerRes[i].qunType == 'General' && component.get("v.generalQunExists") == false) {
                                                        component.set("v.generalQunExists", true);
                                                }
                                        }
                                        for (var i = 0; i < controllerRes.length; i++) {
                                                if (controllerRes[i].fieldTyp == 'multipicklist') {
                                                        var opts = [];
                                                        for (var j = 0; j < controllerRes[i].picklistVal.length; j++) {
                                                                opts.push({
                                                                        label: controllerRes[i].picklistVal[j]
                                                                        , value: controllerRes[i].picklistVal[j]
                                                                })
                                                        }
                                                        controllerRes[i].picklistVal = opts;
                                                }
                                        }
                                        //console.log('opts---->'+JSON.stringify(opts));
                                        //console.log('controllerRes---->'+JSON.stringify(controllerRes));
                                        component.set("v.peQunLineItems", controllerRes);
                                       }
                                } else {
                                        //this.generalErrorActions(component,event, helper,"Oops!!... Looks like link is invalid","Sorry for inconvenience","standard:resource_absence");
                                        component.set("v.showForm", false);
                                        component.set("v.peQunLineItems", []);
                                        component.set("v.showErrorSection", false);
                                        component.set("v.showGeneralMsg", true);
                                        component.set("v.msgHeading", "Oops!!... Looks like link is invalid");
                                        component.set("v.msgDetail", "Sorry for inconvenience");
                                        component.set("v.msgIcon", "standard:resource_absence");
                                }
                        } else if (data.getState() == "ERROR") {
                                $A.log("Errors", data.getError());
                        }
                        
                });
                $A.enqueueAction(action);
        }
        , submitFeedbackForm: function(component, event, helper) {
                var validCheck = helper.checkValidity(component, event, helper);
                //  var checkblank  = helper.checkblank(component, event, helper);
                var alertCheck;
                if (validCheck) {
                        alertCheck = confirm("Are you sure !!");
                }
                if (validCheck && alertCheck) {
                        if (this.validateInputFields(component) == true) {
                                component.set("v.showErrorSection", false);
                                var responseItems = component.get("v.peQunLineItems");
                                //	console.log(responseItems);
                                //	console.log('response======@@@@@'+JSON.stringify(responseItems));
                                var action = component.get("c.submitResponse");
                                var feedbackid = component.get("v.feedbackSFId");
                                for (var i = 0; i < responseItems.length; i++) {
                                        var notBlank = [];
                                        if (responseItems[i].response != null || responseItems[i].response != '' || responseItems[i].response != ' ') {
                                                notBlank.push(responseItems[i]);
                                                if (responseItems[i].fieldTyp == 'multipicklist') {
                                                        var opts = [];
                                                        for (var j = 0; j < responseItems[i].selectedMulPickVals.length; j++) {
                                                                opts.push(responseItems[i].selectedMulPickVals[j]);
                                                        }
                                                        responseItems[i].picklistVal = opts;
                                                        responseItems[i] = notBlank;
                                                }
                                        }
                                }
                                //console.log('*******');
                                //	console.log(responseItems);
                                action.setParams({
                                        "responseItems": JSON.stringify(responseItems)
                                        , "feedbackId": feedbackid
                                });
                                action.setCallback(this, function(data) {
                                        if (data.getState() == "SUCCESS") {
                                                if (data.getReturnValue() == "Success") {
                                                        //this.generalSuccessActions(component,event, helper,"Feedback Form sumbitted","Thank you for your feedback, have a nice day");
                                                        component.set("v.showForm", false);
                                                        component.set("v.showErrorSection", false);
                                                        component.set("v.showGeneralMsg", true);
                                                        //component.set("v.isOpen1", true);
                                                        component.set("v.msgHeading", "Feedback Form submitted");
                                                        component.set("v.msgDetail", "Thank you for your feedback, have a nice day");
                                                        // alert('Are you sure you want to submit?');
                                                } else {}
                                        } else if (data.getState() == "ERROR") {
                                                $A.log("Errors", data.getError());
                                        }
                                });
                                $A.enqueueAction(action);
                        } else {
                                component.set("v.showErrorSection", true);
                        }
                }
        }
        , validateInputFields: function(component, event, helper) {
                var responseItems = component.get("v.peQunLineItems");
                var data = component.get("v.feedbackId");
                var undefinedFields = [];
                for (var respLineItem = 0; respLineItem < responseItems.length; respLineItem++) {
                        //console.log('responseItems[respLineItem].response:::'+responseItems[respLineItem].response);
                        if ((responseItems[respLineItem].response == '--None--' && responseItems[respLineItem].fieldTyp == 'picklist' && responseItems[respLineItem].isMandatory == true) || ((responseItems[respLineItem].response == undefined || responseItems[respLineItem].response == '') && responseItems[respLineItem].isMandatory == true && responseItems[respLineItem].fieldTyp != 'multipicklist') || (responseItems[respLineItem].fieldTyp == 'multipicklist' && (responseItems[respLineItem].selectedMulPickVals == '' || responseItems[respLineItem].selectedMulPickVals == undefined) && responseItems[respLineItem].isMandatory == true)) {
                                undefinedFields.push(responseItems[respLineItem].fieldName);
                                //console.log("undefinedFields:::===>"+undefinedFields);
                        }
                }
                if (undefinedFields.length > 0) {
                        var msg = "Please fill required fields :";
                        for (var undefinedItem = 0; undefinedItem < undefinedFields.length; undefinedItem++) {
                                msg += undefinedFields[undefinedItem] + "\n";
                        }
                        component.set("v.isValid", false);
                        component.set("v.showErrorSection", true);
                        component.set("v.errorMsg", msg);
                } else {
                        component.set("v.isValid", true);
                }
                return component.get("v.isValid");
        }
        , generalSuccessActions: function(component, event, helper, msgHeading, msg) {
                component.set("v.showForm", false);
                component.set("v.showErrorSection", false);
                component.set("v.showGeneralMsg", true);
                component.set("v.msgHeading", msgHeading);
                component.set("v.msgDetail", msg);
        }
        , generalErrorActions: function(component, event, helper, msgHeading, msg, msgIcon) {
                component.set("v.showForm", false);
                component.set("v.peQunLineItems", []);
                component.set("v.showErrorSection", false);
                component.set("v.showGeneralMsg", true);
                component.set("v.msgHeading", msgHeading);
                component.set("v.msgDetail", msg);
                component.set("v.msgIcon", msgIcon);
        }
, })