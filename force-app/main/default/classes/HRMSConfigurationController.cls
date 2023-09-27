public class HRMSConfigurationController {
public List<HRMS_Setup_Configuration__mdt> creditConfigs {get;set;}
    public List<HRMS_Setup_Configuration__mdt> productConfigs {get;set;}
    public List<HRMS_Setup_Configuration__mdt> miscConfigs {get;set;}
    public HRMSConfigurationController() {
        creditConfigs = new List<HRMS_Setup_Configuration__mdt>();
        productConfigs = new List<HRMS_Setup_Configuration__mdt>();
        miscConfigs = new List<HRMS_Setup_Configuration__mdt>();

        for(HRMS_Setup_Configuration__mdt config : [SELECT Id, MasterLabel, Configuration_type__c, Navigation_API__c FROM HRMS_Setup_Configuration__mdt]) {
            if(config.Configuration_type__c == 'USER CONFIGURATION')
                creditConfigs.add(config);
            if(config.Configuration_type__c == 'PRODUCT CONFIGURATION')
                productConfigs.add(config);
            if(config.Configuration_type__c == 'MISC')
                miscConfigs.add(config);
        }
    }

    public Pagereference redirectTo() {
        String keyPrefix = Apexpages.currentPage().getParameters().get('keyPrefix');
        System.debug('--- keyPrefix'+keyPrefix);
        if(!String.isBlank(keyPrefix))
            return new PageReference(keyPrefix);
            //return new PageReference('/' + Schema.getGlobalDescribe().get(keyPrefix).getDescribe().getKeyPrefix() + '/o');
        return null;
    }
}