import { LightningElement, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getPEIntervals from '@salesforce/apex/PEAssessmentPdf.getPEIntervals';
import OutlookSetupMeetingIntegration from '@salesforce/apex/OutlookSetupMeetingIntegration.GenerateEventLink';
import getChildSummaryData from '@salesforce/apex/PEAssessmentPdf.getChildSummaryData';
import generateAcessToken from '@salesforce/apex/OutlookSetupMeetingIntegration.generateAcessToken';

export default class PEShowAssessmentPdf extends NavigationMixin(LightningElement) {
    intervals = [];
    showTable = false;
    summaryData = [];
    showSetupMeetingModal = false;
    meetingUser = '';
    meetingManager = '';

    connectedCallback() {
        this.loadIntervals();
    }

    loadIntervals() {
        getPEIntervals()
            .then(result => {
                this.intervals = result;
            })
            .catch(error => {
                // Handle error
            });
    }

    handleCardClick(event) {
        const intervalId = event.currentTarget.dataset.id;
        getChildSummaryData({ intervalId })
            .then(result => {
                this.summaryData = result;
                this.showTable = true;
            })
            .catch(error => {
                // Handle error
            });
    }

    handleBackClick() {
        this.showTable = false;
    }

    handleDownloadPdf(event) {
        const summaryId = event.currentTarget.dataset.id;
        const userId = this.summaryData.find(summary => summary.Id === summaryId).User__r.Id;
        const url = `https://sales-production--hrmsdemo--c.sandbox.vf.force.com/apex/PE_Download_PDF?id=${userId}`;

        this[NavigationMixin.Navigate]({
            type: 'standard__webPage',
            attributes: {
                url: url
            }
        });
    }

    handleSetupMeeting(event) {
        const summaryId = event.currentTarget.dataset.id;
        const summary = this.summaryData.find(summary => summary.Id === summaryId);
        this.showSetupMeetingModal = true;
        this.meetingUser = summary.User__r.Name;
        this.meetingManager = summary.User__r.Manager.Name;
    }

    handleClose() {
        this.showSetupMeetingModal = false;
    }

    handleSave() {
        debugger;
        var email = 'htr88469@example.com,anjali.singh@utilitarianLab.com';
        var subject = 'Email Testing';
        var timings = '12:30:01:30'; // Example timings value
        var meetDate = '2023-07-07'; // Example meetDate value
        var timezone = 'Asia/Kolkata'; // Example timezone value

        OutlookSetupMeetingIntegration({Email : email, Subject: subject, Timings : timings, meetDate : meetDate, timezone: timezone})
            .then(result => {
                // Handle success
                console.log('Meeting link generated successfully');
                this.showToast('Success', 'Email sent successfully', 'success');
            })
            .catch(error => {
                // Handle error
                console.error('Error generating meeting link', error);
                this.showToast('Error', 'Failed to send email', 'error');
            });

        this.showSetupMeetingModal = false;
    }

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}