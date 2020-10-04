
public class CountriesParser {
    public static List<Country> parse(String json) {
        return (List<Country>) System.JSON.deserialize(json, List<Country>.class);
    }
}