//
//  Recipient.m
//  ImportingThree20
//
//  Created by Maijid Moujaled on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Recipient.h"

@implementation Recipient

@synthesize name, email, recipientImage;
@synthesize contactID;


-(id)initWithname:(NSString *)rname email:(NSString *)remail image:(UIImage *)image{
    self = [super init];
    
    if (self) {
        self.name = rname;
        self.email = remail;
        self.recipientImage = image;
    }
    return self;
}


@end
