//
//  User.h
//  PikuZone
//
//  Created by Maijid Moujaled on 8/3/12.
//
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, copy) NSString *emailAddress;
@property (nonatomic, copy) NSString *name;
@property int userID;
@property (nonatomic, copy) NSString *sessionToken;

@end
