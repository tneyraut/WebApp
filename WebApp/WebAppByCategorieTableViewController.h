//
//  WebAppByCategorieTableViewController.h
//  WebApp
//
//  Created by Thomas Mac on 17/10/2015.
//  Copyright © 2015 ThomasNeyraut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Categorie.h"

#import "WebAppModel.h"

#import "AccueilCollectionViewController.h"

@interface WebAppByCategorieTableViewController : UITableViewController <UITableViewDataSource, WebAppModelProtocol>

@property(nonatomic, weak) Categorie *categorieSelected;

@property(nonatomic, weak) AccueilCollectionViewController *accueilCollectionViewController;

@end
