//
//  RecipientViewController.h
//  ImportingThree20
//
//  Created by Maijid Moujaled on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"



@protocol RecipientViewControllerDelegate;



@interface RecipientViewController : UITableViewController {
    id<RecipientViewControllerDelegate>delegate;
}

- (Contact *)getRecipientForName:(NSString *)name;

@property(nonatomic, assign) id<RecipientViewControllerDelegate>delegate;

@property(nonatomic, strong) NSMutableArray *contactArray;


- (id)initWithStyle:(UITableViewStyle)style contacts:(NSMutableArray *)contactArray;


@end

@protocol  RecipientViewControllerDelegate <NSObject>
- (void)recipientViewController:(RecipientViewController*)controller didSelectRecipient:(Contact *)recipient;
- (void)recipientViewControllerdidCancel:(RecipientViewController*)controller;
@end








