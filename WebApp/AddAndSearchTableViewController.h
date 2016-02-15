//
//  AddAndSearchTableViewController.h
//  WebApp
//
//  Created by Thomas Mac on 12/10/2015.
//  Copyright © 2015 ThomasNeyraut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AccueilCollectionViewController.h"

#import "WebAppModel.h"
#import "CategorieModel.h"

@interface AddAndSearchTableViewController : UITableViewController <UITableViewDataSource, WebAppModelProtocol, CategorieModelProtocol>

@property(nonatomic, weak) AccueilCollectionViewController *accueilCollectionViewController;

@end
