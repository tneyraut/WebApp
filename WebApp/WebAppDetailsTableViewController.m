//
//  WebAppDetailsTableViewController.m
//  WebApp
//
//  Created by Thomas Mac on 17/10/2015.
//  Copyright © 2015 ThomasNeyraut. All rights reserved.
//

#import "WebAppDetailsTableViewController.h"
#import "WebAppNoteTableViewController.h"

#import "SpecificTableViewCell.h"

@interface WebAppDetailsTableViewController ()

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) NSArray *elementArray;

@property(nonatomic, strong) NSArray *imageArray;

@end

@implementation WebAppDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.activityIndicatorView setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    
    [self.activityIndicatorView setColor:[UIColor blackColor]];
    
    [self.activityIndicatorView setHidesWhenStopped:YES];
    
    [self.tableView addSubview:self.activityIndicatorView];
    
    [self.navigationItem setTitle:self.webAppSelected.name];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:self.webAppSelected.name style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
    
    self.elementArray = [[NSArray alloc] initWithObjects:@"Name : ", @"Category  : ", @"Description : ", @"Mark : ", nil];
    
    self.imageArray = [[NSArray alloc] initWithObjects:
                       NSLocalizedString(@"NAME_APP_ICON", @"NAME_APP_ICON"),
                       NSLocalizedString(@"CATEGORY_ICON", @"CATEGORY_ICON"),
                       NSLocalizedString(@"DESCRIPTION_ICON", @"DESCRIPTION_ICON"),
                       NSLocalizedString(@"NOTE_ICON", @"NOTE_ICON"), nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    [self.navigationController.toolbar setBarTintColor:[UIColor grayColor]];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    UIBarButtonItem *buttonAdd = [[UIBarButtonItem alloc] initWithTitle:@"Add Web App"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(buttonAddActionListener)];
    
    [buttonAdd setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil
                                      action:nil];
    
    [self.navigationController.toolbar setItems:@[ flexibleSpace, buttonAdd, flexibleSpace ]];
    
    [super viewDidAppear:animated];
}

- (void) buttonAddActionListener
{
    [self saveInFavorisWebApp:self.webAppSelected];
}

- (void) saveInFavorisWebApp:(WebApp *)webApp
{
    int numberSections = (int)[self.accueilCollectionViewController.sauvegarde integerForKey:@"numberSections"];
    
    for (int i=0;i<numberSections;i++)
    {
        int numberElementsInSection = (int)[self.accueilCollectionViewController.sauvegarde integerForKey:[NSString stringWithFormat:@"numberElementsInSection%d", i]];
        
        for (int j=0;j<numberElementsInSection-1;j++)
        {
            NSString *name = [self.accueilCollectionViewController.sauvegarde objectForKey:[NSString stringWithFormat:@"element%dInSection%dName", j, i]];
            
            NSString *url = [self.accueilCollectionViewController.sauvegarde objectForKey:[NSString stringWithFormat:@"element%dInSection%dUrl", j, i]];
            
            if ([name isEqualToString:webApp.name] && [url isEqualToString:webApp.url])
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:[NSString stringWithFormat:@"L'application '%@' est déjà enregistrée dans vos favoris", webApp.name] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alertView show];
                
                return;
            }
        }
    }
    
    int numberElementsInSection = (int)[self.accueilCollectionViewController.sauvegarde integerForKey:@"numberElementsInSection0"];
    
    [self.accueilCollectionViewController.sauvegarde setInteger:(numberElementsInSection + 1) forKey:@"numberElementsInSection0"];
    
    [self.accueilCollectionViewController.sauvegarde setObject:webApp.name forKey:[NSString stringWithFormat:@"element%dInSection0Name", (numberElementsInSection - 1)]];
    
    [self.accueilCollectionViewController.sauvegarde setObject:webApp.url forKey:[NSString stringWithFormat:@"element%dInSection0Url", (numberElementsInSection - 1)]];
    
    [self.accueilCollectionViewController.sauvegarde synchronize];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:[NSString stringWithFormat:@"L'application '%@' a été ajoutée à l'écran d'accueil", webApp.name] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alertView show];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.elementArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    [cell.imageView setImage:[UIImage imageNamed:self.imageArray[indexPath.row]]];
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = [self.elementArray[indexPath.row] stringByAppendingString:self.webAppSelected.name];
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = [self.elementArray[indexPath.row] stringByAppendingString:self.webAppSelected.categorie_name];
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = [self.elementArray[indexPath.row] stringByAppendingString:self.webAppSelected.descrip];
    }
    else if (indexPath.row == 3)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if (self.webAppSelected.notee)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@%f/5", self.elementArray[indexPath.row], self.webAppSelected.note];
        }
        else
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%@Non notée", self.elementArray[indexPath.row]];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 3 || [self.activityIndicatorView isAnimating])
    {
        return;
    }
    
    WebAppNoteTableViewController *webAppNoteTableViewController = [[WebAppNoteTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    webAppNoteTableViewController.webAppSelected = self.webAppSelected;
    
    [self.navigationController pushViewController:webAppNoteTableViewController animated:YES];
}

@end
