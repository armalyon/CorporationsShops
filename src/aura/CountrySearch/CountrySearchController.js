({
    searchOnClick: function (component, event, helper) {
        let input = component.find("SearchInput").get("v.value");
        let selector = component.find("searchBySelector").get("v.value");
        if (input !== '') {
            helper.getSearchResults(selector, input, component);
        }
    }
});