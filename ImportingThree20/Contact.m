//
//  Recipient.m
//  ImportingThree20
//
//  Created by Maijid Moujaled on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Contact.h"
#import "PikuZoneAPIClient.h"

@implementation Contact

@synthesize name, recipientImage, photoFilePath;
@synthesize contactID, contactImage;


-(id)initWithname:(NSString *)rname email:(NSString *)remail image:(UIImage *)image{
    self = [super init];
    
    if (self) {
        self.name = rname;
        self.email = remail;
        self.recipientImage = image;
    }
    return self;
}

-(id)initWithContactDictionary:(NSDictionary *)contactDictionary
{
    if ((self = [super init])) {
        self.name = [contactDictionary objectForKey:@"Name"];
        self.contactID = [[contactDictionary objectForKey:@"ContactId"] intValue];
        self.photoFilePath = [contactDictionary objectForKey:@"PhotoFilePath"];
    }
    return self;
}


@end
