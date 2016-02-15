//
//  WebAppByCategorieTableViewController.m
//  WebApp
//
//  Created by Thomas Mac on 17/10/2015.
//  Copyright © 2015 ThomasNeyraut. All rights reserved.
//

#import "WebAppByCategorieTableViewController.h"

#import "WebAppDetailsTableViewController.h"

#import "WebApp.h"
#import "SpecificTableViewCellWithoutImage.h"

@interface WebAppByCategorieTableViewController () <UISearchBarDelegate>

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) NSArray *webAppArray;

@property(nonatomic, strong) NSMutableArray *afficherWebApp;

@property(nonatomic, strong) WebAppModel *webAppModel;

@property(nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic) UITapGestureRecognizer *singleFingerTap;

@end

@implementation WebAppByCategorieTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SpecificTableViewCellWithoutImage class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView registerClass:[SpecificTableViewCellWithoutImage class] forCellReuseIdentifier:@"cellSearch"];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.activityIndicatorView setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    
    [self.activityIndicatorView setColor:[UIColor blackColor]];
    
    [self.activityIndicatorView setHidesWhenStopped:YES];
    
    [self.tableView addSubview:self.activityIndicatorView];
    
    [self.navigationItem setTitle:self.categorieSelected.name];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:self.categorieSelected.name style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
    
    self.searchBar = [[UISearchBar alloc] init];
    
    self.searchBar.barTintColor = [UIColor whiteColor];
    
    self.searchBar.delegate = self;
    
    self.singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toucheDone)];
    
    [self getWebAppByCategorieId:self.categorieSelected.categorie_id];
    
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
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [super viewDidAppear:animated];
}

- (void) getWebAppByCategorieId:(int)categorie_id
{
    [self.activityIndicatorView startAnimating];
    
    if (!self.webAppModel)
    {
        self.webAppModel = [[WebAppModel alloc] init];
        
        self.webAppModel.delegate = self;
        
        self.tableView.dataSource = self;
    }
    
    [self.webAppModel getWebAppByCategorieId:categorie_id];
}

- (void) webAppDownloaded:(NSMutableArray *)items
{
    if (items.count == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:[NSString stringWithFormat:@"La catégorie ('%@') ne comporte aucune application web", self.categorieSelected.name] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        [self.activityIndicatorView stopAnimating];
        
        return;
    }
    
    self.webAppArray = items;
    
    self.afficherWebApp = [[NSMutableArray alloc] init];
    
    for (int i=0;i<self.webAppArray.count;i++)
    {
        [self.afficherWebApp addObject:@"1"];
    }
    
    [self.tableView reloadData];
    
    [self.activityIndicatorView stopAnimating];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.view addGestureRecognizer:self.singleFingerTap];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view removeGestureRecognizer:self.singleFingerTap];
    
    [self.view endEditing:YES];
    
    [self getWebAppBySearch:self.searchBar.text];
}

- (void) toucheDone
{
    [self.view removeGestureRecognizer:self.singleFingerTap];
    
    [self.view endEditing:YES];
    
    [self.afficherWebApp removeAllObjects];
    
    for (int i=0;i<self.webAppArray.count;i++)
    {
        [self.afficherWebApp addObject:@"1"];
    }
    
    [self.tableView reloadData];
}

- (void) getWebAppBySearch:(NSString *)search
{
    [self.activityIndicatorView startAnimating];
    
    [self.afficherWebApp removeAllObjects];
    
    for (int i=0;i<self.webAppArray.count;i++)
    {
        WebApp *webApp = self.webAppArray[i];
        
        if ([webApp.name rangeOfString:search].location != NSNotFound)
        {
            [self.afficherWebApp addObject:@"1"];
        }
        else
        {
            [self.afficherWebApp addObject:@"0"];
        }
    }
    
    [self.tableView reloadData];
    
    [self.activityIndicatorView stopAnimating];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int taille = 1;
    
    for (int i=0;i<self.afficherWebApp.count;i++)
    {
        if ([self.afficherWebApp[i] isEqualToString:@"1"])
        {
            taille++;
        }
    }
    
    return taille;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 40.0f;
    }
    return 75.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        SpecificTableViewCellWithoutImage *cell = [tableView dequeueReusableCellWithIdentifier:@"cellSearch" forIndexPath:indexPath];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self.searchBar setFrame:CGRectMake(15.0f, (cell.frame.size.height - 30.0f) / 2, cell.frame.size.width - 30.0f, 30.0f)];
        
        [cell addSubview:self.searchBar];
        
        return cell;
    }
    
    SpecificTableViewCellWithoutImage *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    int indice = (int)indexPath.row - 1;
    
    while ([self.afficherWebApp[indice] isEqualToString:@"0"])
    {
        indice++;
    }
    
    WebApp *webApp = self.webAppArray[indice];
    
    cell.textLabel.text = webApp.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.activityIndicatorView isAnimating])
    {
        return;
    }
    
    WebAppDetailsTableViewController *webAppDetailsTableViewController = [[WebAppDetailsTableViewController alloc] init];
    
    int indice = (int)indexPath.row - 1;
    
    while ([self.afficherWebApp[indice] isEqualToString:@"0"])
    {
        indice++;
    }
    
    webAppDetailsTableViewController.webAppSelected = self.webAppArray[indice];
    
    webAppDetailsTableViewController.accueilCollectionViewController = self.accueilCollectionViewController;
    
    [self.navigationController pushViewController:webAppDetailsTableViewController animated:YES];
}

@end
