public with sharing class PESummaryHrApproval {
    @AuraEnabled
    public static void submitForApproval(Id summaryId) {
                        System.debug('summaryId-------->'+ summaryId);

        Summary__c peSummaryRecord = [SELECT Id, OwnerId FROM Summary__c WHERE Id = :summaryId LIMIT 1];
                        System.debug('peSummaryRecord-------->'+ peSummaryRecord);

        if (peSummaryRecord != null && peSummaryRecord.OwnerId != null) {
            User hrProfile = [SELECT Id FROM User WHERE Profile.Name = 'HR' LIMIT 1];
                        System.debug('hrProfile-------->'+ hrProfile);

            if (hrProfile != null) {
                Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                approvalRequest.setComments('Submitting for Manager Approval post Payment is done');
                approvalRequest.setObjectId(summaryId);
                approvalRequest.setProcessDefinitionNameOrId('PESummmaryHrApproval');
                System.debug('hrProfile.Id-------->'+ hrProfile.Id);
                approvalRequest.setNextApproverIds(new List<Id> { hrProfile.Id });

                Approval.ProcessResult[] results = Approval.process(new List<Approval.ProcessSubmitRequest>{approvalRequest});
                        System.debug('results-------->'+ results);

                if (results != null && results[0].isSuccess()) {
                    // Approval request submitted successfully
                } else {
                    throw new AuraHandledException('Failed to submit approval: ' + results[0].getErrors()[0].getMessage());
                }
            } else {
                throw new AuraHandledException('HR profile not found');
            }
        } else {
            throw new AuraHandledException('PE Summary record not found');
        }
    }
}