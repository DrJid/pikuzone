//
//  PikuZoneAPIClient.h
//  PikuZone
//
//  Created by Maijid Moujaled on 8/3/12.
//
//

#import "AFHTTPClient.h"

@interface PikuZoneAPIClient : AFHTTPClient


//Make it a singleton.
+ (id)sharedInstance;

@end
