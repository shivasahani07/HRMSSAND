({
    addNewRow : function(component, event, helper){
       
        component.getEvent("AddRowEvent").fire();     
    },
    
    removeRow : function(component, event, helper){
    
       component.getEvent("DeleteRowEvent").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    }, 
  
})