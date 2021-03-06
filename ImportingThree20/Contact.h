//
//  Recipient.h
//  ImportingThree20
//
//  Created by Maijid Moujaled on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Contact : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email; 
@property (nonatomic, copy) NSString *photoFilePath;
@property (nonatomic, strong) UIImage *recipientImage;
@property (nonatomic, strong) UIImage *contactImage;

@property (nonatomic) int contactID;


-(id)initWithname:(NSString *)rname email:(NSString *)remail image:(UIImage *)image;
-(id)initWithContactDictionary:(NSDictionary *)contactDictionary;

@end
