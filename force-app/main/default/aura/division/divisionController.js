({
    doInit: function(component, event, helper) {   
        helper.getPicklistValues(component, event);
        helper.newRecord(component, event);
    },

	onSave : function(component, event, helper) {

	    // Ask Lightning Data Service to save the record
        component.find("recordLoader").saveRecord($A.getCallback(function(saveResult) {
            if (saveResult.state === "SUCCESS") {

                // Display popup confirmation to the user
                var resultsToast = $A.get("e.force:showToast");
                resultsToast.setParams({
                    "title": "Resultado exitoso!",
                    "message": "La division fue guardada"});
                resultsToast.fire();

                if( saveResult.recordId ) {
                    component.set('v.recordId', saveResult.recordId)
                }
                // Navigate back to the record view
                var navigateEvent = $A.get("e.force:navigateToSObject");
                navigateEvent.setParams({ "recordId": component.get('v.recordId') });
                navigateEvent.fire();
            }
            else {
                // Basic error handling
                component.set('v.recordError', 
                    'Error: ' + saveResult.state + ', message: ' + JSON.stringify(saveResult.error));
            }
        }));
	},   
    onCancel : function(component, event, helper) {
        // Navigate back to the record view
        var navigateEvent = $A.get("e.force:navigateToSObject");
        navigateEvent.setParams({ "recordId": component.get('v.recordId') });
        navigateEvent.fire();
    }
})