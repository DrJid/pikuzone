//
//  Email.h
//  PikuZone
//
//  Created by Maijid Moujaled on 6/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (nonatomic, copy) NSString *senderName;
@property int senderID;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *messageBody;
@property (nonatomic) int messageID;
@property (nonatomic, strong) NSArray *contacts;
@property BOOL read;


-(id)initWithMessageDictionary:(NSDictionary *)messageDictionary;

@end
