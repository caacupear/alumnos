({

    doInit: function(component, event, helper) {
         var action = component.get('c.fetchConstancias');
         action.setCallback(this, function(response) {
          //store state of response
          var state = response.getState();
          if (state === "SUCCESS") {
           component.set('v.constancias', response.getReturnValue());
          }
         });
         $A.enqueueAction(action);
    },
    generate : function(component, event, helper) {
        var idConstancia =   event.target.id; // event.target.closest('[data-constancia]').dataset.constancia;
        
        var idContact = component.get("v.recordId");
        var action = component.get('c.generatePDF');
        action.setParams({ idConstancia, idContact });

        action.setCallback(this, function(response) {
            //store state of response
            var state = response.getState();
            if (state === "SUCCESS") {
                try {
                    var attachment = response.getReturnValue();
                    const urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        "url": "/" + attachment.Id 
                    });
                    urlEvent.fire();
                } catch(e) {
                    console.log('Error', e, JSON.stringify(e));
                }        
            }
        });
        $A.enqueueAction(action);
    },
    view : function(component, event, helper) {
        var idConstancia =   event.target.id; // event.target.closest('[data-constancia]').dataset.constancia;
        
        var idContact = component.get("v.recordId");
        try {
            const urlEvent = $A.get("e.force:navigateToURL");
            urlEvent.setParams({
                "url": "/apex/RenderAsPDF?idContact=" + idContact + "&idConstancia=" + idConstancia  
            });
            urlEvent.fire();
        } catch(e) {
            console.log('Error', e, JSON.stringify(e));
        }
    },
})