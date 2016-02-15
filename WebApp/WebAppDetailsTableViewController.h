//
//  WebAppDetailsTableViewController.h
//  WebApp
//
//  Created by Thomas Mac on 17/10/2015.
//  Copyright © 2015 ThomasNeyraut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AccueilCollectionViewController.h"

#import "WebApp.h"

@interface WebAppDetailsTableViewController : UITableViewController

@property(nonatomic, weak) WebApp *webAppSelected;

@property(nonatomic, weak) AccueilCollectionViewController *accueilCollectionViewController;

@end
