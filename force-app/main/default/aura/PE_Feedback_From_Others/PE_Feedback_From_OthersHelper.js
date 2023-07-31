({
		getIntervalDetailsfromSF: function(component) {
		   	//	debugger;
			//	console.log('*****');
				var action = component.get("c.getIntervalDetailsSFDC");
				action.setCallback(this, function(response) {
					//	console.log(response);
						var state = response.getState();
						if (state === "SUCCESS") {
							//	console.log(response.getReturnValue());
								component.set("v.ListofIntervals", response.getReturnValue());
								if (component.get("v.ListofIntervals.length") % 2 != 0) {
										//console.log('*****!!!1');
										var lengthnew = component.get("v.ListofIntervals.length") - 1;
										//var  indexValue =parseInt(lengthnew);
										component.set("v.lastElement", lengthnew);
										var tempArray = [];
										tempArray = component.get("v.ListofIntervals");
										var lastIndex = component.get("v.lastElement");
										//alert("tempArray:::"+JSON.stringify(tempArray));
										var lastValue = [];
										var lastValue = tempArray[lastIndex];
										component.set("v.lastArray", lastValue);
								}
						} else if (state === "INCOMPLETE") {} else if (state === "ERROR") {}
				});
				$A.enqueueAction(action);
		},
    userInformation: function(component, event, helper) {
    var action=component.get("c.getUser");
    action.setCallback(this, function(response) {
               
    var userDetail = response.getReturnValue();
                  component.set("v.UserName",userDetail);
			//	console.log(userDetail);
                  
			});
             $A.enqueueAction(action); 
},
		getSummaryDetailsfromSF: function(component, interval_ID) {
				var action = component.get("c.getSummaryDetailsSFDC");
				action.setParams({
						"intervalID": interval_ID,
				});
				action.setCallback(this, function(response) {
						//console.log(response);
						var state = response.getState();
						if (state === "SUCCESS") {
							//	console.log(response.getReturnValue());
								component.set("v.feedbackSummaryID", response.getReturnValue());
						} else if (state === "INCOMPLETE") {} else if (state === "ERROR") {}
				});
				$A.enqueueAction(action);
		},
		getPEFeedBackfromSF: function(component, interval_id, summary_Id, recordType) {
            debugger;
			  //console.log('interval_id'+interval_id);
				var action = component.get("c.getPEFeedBackfromSF");
				action.setParams({
						"intervalID": interval_id,
						"SummaryId": summary_Id,
						"peRecordtypeName": recordType,
				});
				action.setCallback(this, function(response) {
					  
					//	console.log(response);
						var state = response.getState();
						if (state === "SUCCESS") {
								//console.log(response.getReturnValue());
								//=======================================
								var custs = [];
								var conts = response.getReturnValue();
								for (var key in conts) {
										custs.push({
												value: conts[key],
												key: key
										});
								}
								component.set("v.ListofPEFeddbacks", custs);
								////=====================================
								//component.set("v.ListofPEFeddbacks", response.getReturnValue());
								var listofItems = component.get("v.ListofPEFeddbacks");
							//	console.log('listofItems.length' + listofItems.length);
								if (listofItems.length > 0) {
										component.set("v.showDownload", false);
								} else {
										component.set("v.showDownload", true);
								}
						} else if (state === "INCOMPLETE") {} else if (state === "ERROR") {}
				});
				$A.enqueueAction(action);
		},
     /*   downloadPdf: function(component, interval_id, summary_Id,recordType) {
                debugger;
                // var feedbackdata = component.get("v.ListofPEFeddbacks");
                //helper.downloadpdfData(component,feedbackdata);
                var sendDataProc = component.get("v.sendData");
                //var dataToSend = {interval_id, summary_Id, recordType }; //this is data you want to send for PDF generation
            	//console.log(component.get("v.ListofPEFeddbacks"));
                //invoke vf page js method
                sendDataProc(interval_id, summary_Id, recordType, function() {
                        //handle callback
                });
        },
	downloadpdfData: function(component,feedbackdata){
		console.log('*******'+feedbackdata);
		 var action = component.get("c.getAllDownloadData");
				action.setParams({
						"datalist": feedbackdata,
					  
				});
		$A.enqueueAction(action);
	},
		convertArrayOfObjectsToCSV: function(component, objectRecords) {
				console.log(objectRecords);
				// declare variables
				var csvStringResult, counter, keys, columnDivider, lineDivider;
				// check if "objectRecords" parameter is null, then return from function
				if (objectRecords == null || !objectRecords.length) {
						return null;
				}
				// store ,[comma] in columnDivider variabel for sparate CSV values and 
				// for start next line use '\n' [new line] in lineDivider varaible  
				columnDivider = ',';
				lineDivider = '\n';
				// in the keys valirable store fields API Names as a key 
				// this labels use in CSV file header  
				keys = ['PE_Question_Item__r.Question__c', 'Answer__c'];
				csvStringResult = '';
				csvStringResult += keys.join(columnDivider);
				csvStringResult += lineDivider;
				for (var i = 0; i < objectRecords.length; i++) {
						counter = 0;
						//for (var sTempkey in keys) {
						//var skey = keys[sTempkey];
						// add , [comma] after every String value,. [except first]
						if (counter > 0) {
								//csvStringResult += columnDivider;
						}
						csvStringResult += '"' + objectRecords[i]['PE_Question_Item__r'].Question__c + '"';
						csvStringResult += columnDivider;
						csvStringResult += '"' + objectRecords[i]['Answer__c'] + '"';
						counter++;
						// } // inner for loop close 
						csvStringResult += lineDivider;
				} // outer main for loop close 
				// return the CSV formate String 
				return csvStringResult;
		}*/
})