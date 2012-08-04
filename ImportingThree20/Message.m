//
//  Email.m
//  PikuZone
//
//  Created by Maijid Moujaled on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize senderName, messageBody, read, subject, messageID;
@synthesize contacts, senderID;

-(id)initWithMessageDictionary:(NSDictionary *)messageDictionary
{
    
    if ((self = [super init]))
    {
        self.messageID = [[messageDictionary objectForKey:@"MessageId"] intValue];
        self.contacts = [messageDictionary objectForKey:@"Contacts"];
        self.senderName = [messageDictionary objectForKey:@"SenderName"];
        self.senderID = [[messageDictionary objectForKey:@"SenderId"] intValue];
        self.subject = [messageDictionary objectForKey:@"Subject"];
        self.messageBody = [messageDictionary objectForKey:@"MessageBody"];
    }
    return self;

}




@end
