({
    getSearchResults: function (selector, searchInput, component) {
        let action = component.get("c.getCountriesBySelectorAndValue");
        action.setParams({
            searchSelector: selector,
            searchValue: searchInput
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            let searchCompleteEvent = $A.get("e.c:countriesSearchCompleteEvent");
            if (state === "SUCCESS") {
                let countries = response.getReturnValue();
                searchCompleteEvent.setParams({
                    "countries": countries
                });
            } else {
                searchCompleteEvent.setParams({
                    "countries": []
                });
            }
            searchCompleteEvent.fire();
        });
        $A.enqueueAction(action);

    }
});