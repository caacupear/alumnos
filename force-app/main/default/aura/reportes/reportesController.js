({
    navigateToComponent : function(component, event, helper) {
        var event = $A.get("e.force:navigateToComponent");
        event.setParams({
            componentDef : "c:showReporte",
            componentAttributes: {
                recordId : component.get("v.recordId"),
                passedRecordId : component.get("v.recordId")
            }
        });
        event.fire();
    } 
})
