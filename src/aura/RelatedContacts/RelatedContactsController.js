({
    doInit : function(component, event, helper){
        let action = component.get("c.getContactsByAccount");
        helper.initializeComponentData(action, component);
    },
    navigateToContact: function(component, event, helper){
        let contactId = event.target.id;
        helper.navigateToRecord(contactId);
    }
});