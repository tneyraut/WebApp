//
//  AddWebAppTableViewController.h
//  WebApp
//
//  Created by Thomas Mac on 17/10/2015.
//  Copyright © 2015 ThomasNeyraut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WebAppModel.h"

#import "AddAndSearchTableViewController.h"

@interface AddWebAppTableViewController : UITableViewController <UITableViewDataSource, WebAppModelProtocol>

@property(nonatomic, weak) NSArray *categorieArray;

@property(nonatomic, weak) AddAndSearchTableViewController *addAndSearchTableViewController;

@end
