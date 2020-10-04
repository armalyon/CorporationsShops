({
    navigateToRecord: function (id){
        let navEvent = $A.get("e.force:navigateToSObject");
        navEvent.setParams({
            recordId: id,
        });
        navEvent.fire();
    },
    initializeComponentData: function (component){
        let action = component.get("c.getContactsByAccount");
        action.setParams({
            accId: component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            if (state === "SUCCESS") {
                let contacts = response.getReturnValue();
                component.set("v.relatedContacts", contacts);
            }
        });
        $A.enqueueAction(action);
    }
});