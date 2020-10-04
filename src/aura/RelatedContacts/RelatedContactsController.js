({
    doInit : function(component, event, helper){
        helper.initializeComponentData(component);
    },
    navigateToContact: function(component, event, helper){
        let contactId = event.target.id;
        helper.navigateToRecord(contactId);
    }
});