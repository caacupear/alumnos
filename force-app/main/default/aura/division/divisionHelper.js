({
    newRecord: function(component, event) {
        var recordId = component.get("v.recordId");
        if( !recordId ) {
            component.find("recordLoader").getNewRecord(
                "Division__c", null, false,
                $A.getCallback(function() {
                    var rec = component.get("v.record");
                    var error = component.get("v.recordError");
                    if(error || (rec === null)) {
                        console.log("Error initializing record template: " + error);
                        return;
                    }
                    console.log("Record template initialized: " + rec);
                })
            );
        } 
    },
    getPicklistValues: function(component, event) {
        var action = component.get("c.getCiclosVigentes");

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                var fieldMap = [];
                for(const ciclo of result){
                    fieldMap.push({key: ciclo.Id, value: ciclo.Name});
                }
                component.set("v.ciclosVigentes", fieldMap);
            }
        });
        $A.enqueueAction(action);        
    },
})
