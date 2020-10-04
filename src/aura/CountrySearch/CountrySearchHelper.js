({
    getSearchResults: function (selector, searchInput, component) {
        let action = component.get("c.getCountriesBySelectorAndValue");
        action.setParams({
            searchSelector: selector,
            searchValue: searchInput
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let countries = response.getReturnValue();
                let searchCompleteEvent = $A.get("e.c:countriesSearchCompleteEvent");
                searchCompleteEvent.setParams({
                    "countries": countries
                });
                searchCompleteEvent.fire();
            }
        });
        $A.enqueueAction(action);

    }
});