({
    
    handleSelection : function(component, event, helper) {
        debugger;
        try {
            var name = event.getParam('name');
            var selectedRecord = event.getParam('selectedRecord');
            console.log('name  = >'+name);
            console.log('selectedRecord.Id ====> '+selectedRecord.Id);
        } catch (err) {
            console.log(err);
        }
    },
    
})