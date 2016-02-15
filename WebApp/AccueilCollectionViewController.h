//
//  AccueilCollectionViewController.h
//  WebApp
//
//  Created by Thomas Mac on 12/10/2015.
//  Copyright © 2015 ThomasNeyraut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccueilCollectionViewController : UICollectionViewController <UIGestureRecognizerDelegate>

@property(nonatomic, strong) NSUserDefaults *sauvegarde;

@end
