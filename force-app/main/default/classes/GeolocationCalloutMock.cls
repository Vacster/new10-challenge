/**
 * Mock HttpCallout for the Geolocation API.
 * returns a good or bad response based on the parameter passed on the constructor.
 */
@isTest
global class GeolocationCalloutMock implements HttpCalloutMock {

    private Boolean isPositive;

    global GeolocationCalloutMock(Boolean isPositive) {
        this.isPositive = isPositive;
    }

    /**
     * The overriden respond Method from HttpCallout Mock.
     * It's called when the test class attempts an Http Callout.
     * @param  req The incoming request from the Http Callout
     * @return     The response which can have a status code of 200 or 500 depending
     *             on the constructor parameter
     */
    global HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('GET', req.getMethod());

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');

        /**
         * We reutilize the same container class to easily create the response.
         * The alternative is too complex for this challenge (feel free to ask how I would do it).
         */
        GoogleGeocodingContainer container = new GoogleGeocodingContainer();
        container.results = new List<GoogleGeocodingContainer.Results>();
        GoogleGeocodingContainer.Location location = new GoogleGeocodingContainer.Location();
        location.lat = 10.00;
        location.lng = 5.00;
        GoogleGeocodingContainer.Geometry geometry = new GoogleGeocodingContainer.Geometry();
        geometry.location = location;
        GoogleGeocodingContainer.Results results = new GoogleGeocodingContainer.Results();
        results.geometry = geometry;
        container.results.add(results);
        String body = JSON.serialize(container);

        res.setBody(body);

        if (this.isPositive) {
            res.setStatusCode(200);
        } else {
            res.setStatusCode(500);
        }
        return res;
    }

}
