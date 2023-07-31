({
    getIntervalDetails: function(component, event, helper) {
        debugger;
        helper.getIntervalDetailsfromSF(component);
    },
    getFeedbackitems: function(component, event, helper) {
        debugger;
        //    console.log('Called');
        component.set("v.showFeedbackType", false);
        var ctarget = event.currentTarget;
        //     console.log('ctarget' + ctarget);
        var interval_ID = ctarget.dataset.value;
        component.set("v.intervalID", interval_ID);
        //    console.log(interval_ID);
        var ListofIntervals = component.get("v.ListofIntervals");
        var i;
        for (i in ListofIntervals) {
            if (ListofIntervals[i].Id == interval_ID) {
                component.set("v.CurrentIntervalName", ListofIntervals[i].Name);
                //     console.log('&&&&');
                //    console.log(ListofIntervals[i]);
                break;
            }
        }
        helper.getSummaryDetailsfromSF(component, interval_ID);
        helper.userInformation(component, event, helper);
    },
    back: function(component, event, helper) {
        debugger;
        component.set("v.showFeedbackType", true);
    },
    backButton: function(component, event, helper) { 
        debugger;
        component.set("v.showFeedbackType", false);
        component.set("v.showFeedbacks", false)
        component.set("v.intervalID",null);
    },
    getFeedbackLineitems: function(component, event, helper) {
        debugger;
        var ctarget = event.currentTarget;
        var feddbackType = ctarget.dataset.value;
        //  console.log(feddbackType);
    },
    getMiniFeedback: function(component, event, helper) {
        debugger;
        var interval_id = component.get("v.intervalID");
        var summary_Id = component.get("v.feedbackSummaryID.Id");
        var recordType = "Mini Form";
        helper.getPEFeedBackfromSF(component, interval_id, summary_Id, recordType);
        component.set("v.showFeedbackType", true);
        component.set("v.showFeedbacks", true);
        component.set("v.chosenRDType", recordType);
    },
    getPEFeedback: function(component, event, helper) {
        debugger;
        var interval_id = component.get("v.intervalID");
        var summary_Id = component.get("v.feedbackSummaryID.Id");
        var recordType = "PE Form";
        helper.getPEFeedBackfromSF(component, interval_id, summary_Id, recordType);
        component.set("v.showFeedbackType", true);
        component.set("v.showFeedbacks", true);
        component.set("v.chosenRDType", recordType);
    },
    getNonPEFeedback: function(component, event, helper) {
        debugger;
        var interval_id = component.get("v.intervalID");
        var summary_Id = component.get("v.feedbackSummaryID.Id");
        var recordType = "Full Form";
        helper.getPEFeedBackfromSF(component, interval_id, summary_Id, recordType);
        component.set("v.showFeedbackType", true);
        component.set("v.showFeedbacks", true);
        component.set("v.chosenRDType", recordType);
    },
    getAllPEFeedback: function(component, event, helper) {
        debugger;
        var interval_id = component.get("v.intervalID");
        var summary_Id = component.get("v.feedbackSummaryID.Id");
        var recordType = "None";
        helper.getPEFeedBackfromSF(component, interval_id, summary_Id, recordType);
        
        component.set("v.showFeedbackType", true);
        component.set("v.showFeedbacks", true);
        component.set("v.chosenRDType", recordType);
    },
    downloadPdf1:function(component, event, helper){
        debugger;
        var userId = $A.get("$SObjectType.CurrentUser.Id");
        console.log(userId);
        window.open("/apex/PE_Download_PDF?id=" + userId, '_blank');
    },
    /*  downloadDocument: function(component, event, helper) {
        		  var interval_id = component.get("v.intervalID");
        		  var summary_Id = component.get("v.feedbackSummaryID.Id");
        		  var recordType = component.get("v.chosenRDType");
        		  var sendDataProc = component.get("v.sendData");
        		  var dataToSend = {
        				  "label": "This is test"
        		  }; //this is data you want to send for PDF generation
        		  //invoke vf page js method
        		  sendDataProc(dataToSend, function() {
        				  //handle callback
        		  });
          },*/
    // ## function call on Click on the "Download As CSV" Button. 
    /*    downloadCsv: function(component, event, helper) {
                // get the Records [contact] list from 'ListOfContact' attribute 
                var stockData = component.get("v.ListofPEFeddbacks");
                // call the helper function which "return" the CSV data as a String   
                var csv = helper.convertArrayOfObjectsToCSV(component, stockData);
                if (csv == null) {
                        return;
                }
                // ####--code for create a temp. <a> html tag [link tag] for download the CSV file--####     
                var hiddenElement = document.createElement('a');
                hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csv);
                //hiddenElement.href = 'http://gutfullofbeer.net/mozilla.pdf';
                hiddenElement.target = '_self'; // 
                hiddenElement.download = 'ExportData.csv'; // CSV file Name* you can change it.[only name not .csv] 
                document.body.appendChild(hiddenElement); // Required for FireFox browser
                hiddenElement.click(); // using click() js function to download csv file
        },
        downloadJs: function(component, event, helper) {
                var feedbackdata = component.get("v.ListofPEFeddbacks");
                var pdf = new jsPDF();
                var canvas = pdf.canvas;
                canvas.height = 72 * 11;
                canvas.width = 72 * 8.5;;
                console.log(document.getElementById('tableId'));
                // can also be document.body
                var text = document.getElementById('tableId');
                pdf.text(20, 20, feedbackdata);
                pdf.save('Test.pdf');
                var pdf = new jsPDF('p', 'px', 'a4');
                // source can be HTML-formatted string, or a reference
                // to an actual DOM element from which the text will be scraped.
                var source = $('#customers')[0];
                console.log(source);
                console.log( JSON.stringify(source));
            	var myJSON = JSON.stringify(source);
                // we support special element handlers. Register them with jQuery-style 
                // ID selector for either ID or node name. ("#iAmID", "div", "span" etc.)
                // There is no support for any other type of selectors 
                // (class, of compound) at this time.
                specialElementHandlers = {
                        // element with id of "bypass" - jQuery style selector
                        '#customers': function(element, renderer) {
                                // true = "handled elsewhere, bypass text extraction"
                                return true
                        }
                };
                border ={
                	    border-style: solid,
                }
                margins = {
                        top: 50,
                        bottom: 50,
                        left: 50,
                        width: 460
                };
                borders = {
                 border:1px solid black	
                };
                // all coords and widths are in jsPDF instance's declared units
                // 'inches' in this case
                //pdf.setFont('courier');
				//pdf.setFontType('normal');
                pdf.fromHTML(source, // HTML string or DOM elem ref.
                        margins.left, // x coord
                        margins.top, { // y coord
                                'width': margins.width, // max width of content on PDF
                                'elementHandlers': specialElementHandlers
                        },
                        function(dispose) {
                                // dispose: object with X, Y of the last line add to the PDF
                                var pageCount = pdf.internal.getNumberOfPages();
                                for (var i = 0; i < pageCount; i++) {
                                        pdf.setPage(i);
                                        pdf.setFontSize(10);
                                        pdf.text(210, 620, pdf.internal.getCurrentPageInfo().pageNumber + "/" + pageCount);
                                }
                                //          this allow the insertion of new lines after html
                                pdf.save('PE Feedback.pdf');
                        }, margins);
        },
        Ashik Download PDF button*/
    
    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        debugger;
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true);
    },
    // this function automatic call by aura:doneWaiting event 
    hideSpinner: function(component, event, helper) {
        debugger;
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    }
})