/**
 * A class representing Google's Geocoding Api Response.
 * The request response can be directly deserialized into this class.
 * Created with Json2Apex, by Superfell & Metadaddy.
 */
public class GoogleGeocodingContainer {

	public class Address_components {
		public String long_name;
		public String short_name;
		public List<String> types;
	}

	public class Geometry {
		public Location location;
		public String location_type;
		public Viewport viewport;
	}

	public class Results {
		public List<Address_components> address_components;
		public String formatted_address;
		public Geometry geometry;
		public String place_id;
		public List<String> types;
	}

	public class Viewport {
		public Location northeast;
		public Location southwest;
	}

	public List<Results> results;
	public String status;

	public class Location {
		public Double lat;
		public Double lng;
	}

	/**
	 * Deserializes the Google's Geocoding API in JSON format.
	 * @param  json The JSON to deserialize into the class.
	 * @return      A GoogleGeocodingContainer object which comes from the deserialized JSON. 
	 */
	public static GoogleGeocodingContainer parse(String json) {
		return (GoogleGeocodingContainer) System.JSON.deserialize(json, GoogleGeocodingContainer.class);
	}
}