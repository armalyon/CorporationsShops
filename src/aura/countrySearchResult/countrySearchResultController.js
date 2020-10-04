({
    handleSearchCompleteEvent: function (component, event, helper){
        let countries = event.getParam("countries");
        component.set("v.result", countries);
    }
});