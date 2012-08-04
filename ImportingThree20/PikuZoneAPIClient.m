//
//  PikuZoneAPIClient.m
//  PikuZone
//
//  Created by Maijid Moujaled on 8/3/12.
//
//

#import "PikuZoneAPIClient.h"

#define PikuZoneAPIBaseURLString @"http://dm1.catchwind.com/pikuzone/ws/"
#define PikuZoneAPIToken @"1234bcde"

@implementation PikuZoneAPIClient

+ (id)sharedInstance {
    static PikuZoneAPIClient *__sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[PikuZoneAPIClient alloc] initWithBaseURL:[NSURL URLWithString:PikuZoneAPIBaseURLString]];
    });
    
    return __sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    
    if (self) {
        //custom settings
        [self setDefaultHeader:@"Accept" value:@"application/json"];
        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    }
    return self;
}

@end
