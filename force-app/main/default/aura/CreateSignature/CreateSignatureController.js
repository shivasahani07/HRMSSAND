({
    doInit : function(component, event, helper) {
        debugger;
        helper.handleInit(component, event);
    },
    saveSignatureOnClick : function(component, event, helper,data){
        debugger;
        helper.handleSaveSignature(component, event,helper,component.get("v.recordId"));
    },
    clearSignatureOnClick : function(component, event, helper){
        debugger;
        helper.clearCanvas(component, event);
    },
    IsCanvasEmpty: function(component, event, helper){
        debugger;
        return helper.checkCanvasStatus(component, event);
    }
})