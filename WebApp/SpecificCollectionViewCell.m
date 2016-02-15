//
//  SpecificCollectionViewCell.m
//  WebApp
//
//  Created by Thomas Mac on 12/10/2015.
//  Copyright © 2015 ThomasNeyraut. All rights reserved.
//

#import "SpecificCollectionViewCell.h"

@implementation SpecificCollectionViewCell

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.layer setBorderColor:[UIColor colorWithRed:213.0/255.0f green:210.0/255.0f blue:199.0/255.0f alpha:1.0f].CGColor];
    
    [self.layer setBorderWidth:2.5f];
    
    [self.layer setCornerRadius:7.5f];
    
    [self.layer setShadowOffset:CGSizeMake(0, 1)];
    
    [self.layer setShadowColor:[[UIColor lightGrayColor] CGColor]];
    
    [self.layer setShadowRadius:8.0];
    
    [self.layer setShadowOpacity:0.8];
    
    [self.layer setMasksToBounds:NO];
}

@end
