({
    doInit : function(component, event, helper){
        let action = component.get("c.getContactsByAccount");
        action.setParams({
            accId: component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            let contacts = response.getReturnValue();
            component.set("v.relatedContacts", contacts);
        });
        $A.enqueueAction(action);
    },
    navigateToContact: function(component, event, helper){
        let contactId = event.target.id;
        let navEvent = $A.get("e.force:navigateToSObject");
        navEvent.setParams({
            recordId: contactId,
        });
        navEvent.fire();
    }
});