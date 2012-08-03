//
//  RecipientViewController.h
//  ImportingThree20
//
//  Created by Maijid Moujaled on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipient.h"


@protocol RecipientViewControllerDelegate;



@interface RecipientViewController : UITableViewController {
    id<RecipientViewControllerDelegate>delegate;
}

- (Recipient *)getRecipientForName:(NSString *)name;

@property(nonatomic, assign) id<RecipientViewControllerDelegate>delegate;

@property(nonatomic, strong) NSMutableArray *recipientArray;

@end

@protocol  RecipientViewControllerDelegate <NSObject>
- (void)recipientViewController:(RecipientViewController*)controller didSelectRecipient:(Recipient *)recipient;
- (void)recipientViewControllerdidCancel:(RecipientViewController*)controller;
@end








