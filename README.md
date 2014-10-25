## Basic Yelp client

This is a Yelp app displaying businesses using the [Yelp Search API](http://www.yelp.com/developers/documentation/v2/search_api).

Time spent: 15 hours (I mistakenly spent very long time implementing all filter options in the real Yelp app)

### Features

#### Required

# Search results page
- [x] Table rows should be dynamic height according to the content height
- [x] Custom cells should have the proper Auto Layout constraints
- [x] Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).

# Filter page. 
- [x] The filters you should actually have are: category, sort (best match, distance, highest rated), radius (meters), deals (on/off).
- [x] The filters table should be organized into sections as in the mock.
- [x] You can use the default UISwitch for on/off states.
- [x] Radius filter should expand as in the real Yelp app
- [x] Categories should show a subset of the full list with a "See All" row to expand.
- [x] Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.

#### Optional

# Search results page
- [ ] Infinite scroll for restaurant results
- [ ] Implement map view of restaurant results

# Filter page. 
- [ ] Implement a custom switch
- [ ] Implement the restaurant detail page.

### Walkthrough
![Video Walkthrough](walkthrough.gif)

Credits
---------
* [Yelp Search API](http://www.yelp.com/developers/documentation/v2/search_api). 
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
