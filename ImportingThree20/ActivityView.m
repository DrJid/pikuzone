//
//  ActivityView.m
//  PikuZone
//
//  Created by Maijid Moujaled on 8/3/12.
//
//

#import "ActivityView.h"

static CGFloat const kPAWActivityViewActivityIndicatorPadding = 10.f;


@implementation ActivityView


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


@synthesize label;
@synthesize activityIndicator;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
        
		activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
		self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.7f];
        
		[self addSubview:self.label];
		[self addSubview:activityIndicator];
    }
    return self;
}

- (void)setLabel:(UILabel *)aLabel {
	[label removeFromSuperview];
	[self addSubview:aLabel];
}

- (void)layoutSubviews {
	// center the label and activity indicator.
	[label sizeToFit];
	label.center = CGPointMake(self.frame.size.width / 2 + 10.f, self.frame.size.height / 2);
	label.frame = CGRectIntegral(label.frame);
    
	activityIndicator.center = CGPointMake(label.frame.origin.x - (activityIndicator.frame.size.width / 2) - kPAWActivityViewActivityIndicatorPadding, label.frame.origin.y + (label.frame.size.height / 2));
}

@end
