//
//  WeatherForecast.m
//  TrainSpotter
//
//  Created by Carlo Donzelli on 22/07/13.
//  Copyright (c) 2013 Carlo Donzelli. All rights reserved.
//

#import "WeatherForecast.h"
#import "CheckWeatherViewController.h"
#import "XPathQuery.h"

@implementation WeatherForecast

- (void)queryServiceWithState:(NSString *)state andCity:(NSString *)city withParent:(UIViewController *)controller {
    
    viewController = (CheckWeatherViewController *)controller;
    responseData = [NSMutableData data];
    apiKey = @"86ce99f1b384fa98";
    
    //example query http://api.wunderground.com/api/86ce99f1b384fa98/conditions/q/italy/bologna.xml
    NSString *url = [NSString stringWithFormat:@"http://api.wunderground.com/api/%@/conditions/q/%@/%@.xml", apiKey, state, city];
    theUrl = [NSURL URLWithString:url];
    
    //This builds the NSURLRequest from the URL string.
    NSURLRequest *request = [NSURLRequest requestWithURL:theUrl];
    
    //synchronous call
//    NSURLResponse *response = nil;
//    NSError *error = nil;
//    NSData *content = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    NSString *string = [[NSString alloc] initWithData:content encoding:NSUTF8StringEncoding];
//    NSLog(@"response: %@", string);
    
    //This makes the call to the Weather Underground service using an asynchronous call to NSURLConnection.
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark NSURLConnection Delegate Methods
- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse {
    @autoreleasepool {
        theUrl = [request URL];
    }
    return request;
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:
(NSError *)error {
    NSLog( @"Error = %@", error );
}

// Retrieves the content of an XML node, such as the temperature, wind, or humidity in the weather report.
- (NSString *)fetchContent:(NSArray *)nodes {
    NSString *result = @"";
    for ( NSDictionary *node in nodes ) {
        for ( id key in node ) {
            if( [key isEqualToString:@"nodeContent"] ) {
                result = [node objectForKey:key];
            }
        }
    }
    return result;
}

// For nodes that contain more than one value we are interested in, this method fills an NSMutableArray with the values it finds.
- (void) populateArray:(NSMutableArray *)array fromNodes:(NSArray*)nodes {
    
    for ( NSDictionary *node in nodes ) {
        for ( id key in node ) {
            if( [key isEqualToString:@"nodeContent"] ) {
                [array addObject:[node objectForKey:key]];
            }
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    //NSString *content = [[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding];
   // NSLog( @"Data = %@", content );
    
    //now parsini the retrieved content
    NSString *xpathQueryString;
    NSArray *nodes;
    
    xpathQueryString = @"//response/current_observation/display_location/full";
    nodes = PerformXMLXPathQuery(responseData, xpathQueryString);
    self.location = [self fetchContent:nodes];
    
    xpathQueryString = @"//response/current_observation/icon_url";
    nodes = PerformXMLXPathQuery(responseData, xpathQueryString);
    self.icon = [self fetchContent:nodes];
    
    xpathQueryString = @"//response/current_observation/weather";
    nodes = PerformXMLXPathQuery(responseData, xpathQueryString);
    self.condition = [self fetchContent:nodes];
    
    xpathQueryString = @"//response/current_observation/temp_c";
    nodes = PerformXMLXPathQuery(responseData, xpathQueryString);
    self.centigrade = [self fetchContent:nodes];
    
    xpathQueryString = @"//response/current_observation/temp_f";
    nodes = PerformXMLXPathQuery(responseData, xpathQueryString);
    self.fahrenheit = [self fetchContent:nodes];
    
    xpathQueryString = @"//response/current_observation/relative_humidity";
    nodes = PerformXMLXPathQuery(responseData, xpathQueryString);
    self.humidity = [self fetchContent:nodes];
    
    xpathQueryString = @"//response/current_observation/wind_string";
    nodes = PerformXMLXPathQuery(responseData, xpathQueryString);
    self.wind = [self fetchContent:nodes];
    
    [viewController updateView];
    NSLog(@"Connection data retrieved");
}

@end
