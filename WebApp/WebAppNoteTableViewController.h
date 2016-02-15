//
//  WebAppNoteTableViewController.h
//  WebApp
//
//  Created by Thomas Mac on 18/10/2015.
//  Copyright © 2015 ThomasNeyraut. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WebApp.h"

#import "NoteModel.h"

@interface WebAppNoteTableViewController : UITableViewController <UITableViewDataSource, NoteModelProtocol>

@property(nonatomic, weak) WebApp *webAppSelected;

@end
