//
//  AddAndSearchTableViewController.m
//  WebApp
//
//  Created by Thomas Mac on 12/10/2015.
//  Copyright © 2015 ThomasNeyraut. All rights reserved.
//

#import "AddAndSearchTableViewController.h"

#import "SpecificTableViewCellWithoutImage.h"
#import "SpecificTableViewCell.h"
#import "WebApp.h"
#import "Categorie.h"

#import "AddWebAppTableViewController.h"
#import "WebAppByCategorieTableViewController.h"
#import "WebAppDetailsTableViewController.h"

@interface AddAndSearchTableViewController () <UISearchBarDelegate, UIAlertViewDelegate>

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) NSMutableArray *elementArray;

@property(nonatomic, strong) NSArray *categorieArray;

@property(nonatomic, strong) UISearchBar *searchBar;

@property(nonatomic) UITapGestureRecognizer *singleFingerTap;

@property(nonatomic, strong) WebAppModel *webAppModel;

@property(nonatomic, strong) CategorieModel *categorieModel;

@end

@implementation AddAndSearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.tableView registerClass:[SpecificTableViewCellWithoutImage class] forCellReuseIdentifier:@"cellWithoutImage"];
    
    [self.tableView registerClass:[SpecificTableViewCellWithoutImage class] forCellReuseIdentifier:@"cellSearch"];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.activityIndicatorView setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    
    [self.activityIndicatorView setColor:[UIColor blackColor]];
    
    [self.activityIndicatorView setHidesWhenStopped:YES];
    
    [self.tableView addSubview:self.activityIndicatorView];
    
    [self.navigationItem setTitle:@"Add/Search"];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Add/Search" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
    
    UIBarButtonItem *buttonAdd = [[UIBarButtonItem alloc] initWithTitle:@"+" style:UIBarButtonItemStyleDone target:self action:@selector(actionListenerButtonAdd)];
    
    [buttonAdd setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    [self.navigationItem setRightBarButtonItem:buttonAdd];
    
    self.searchBar = [[UISearchBar alloc] init];
    
    self.searchBar.barTintColor = [UIColor whiteColor];
    
    self.searchBar.delegate = self;
    
    self.singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toucheDone)];
    
    self.elementArray = [[NSMutableArray alloc] init];
    
    [self getAllCategorie];
    
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

- (void) actionListenerButtonAdd
{
    AddWebAppTableViewController *addWebAppTableViewController = [[AddWebAppTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    addWebAppTableViewController.categorieArray = self.categorieArray;
    
    addWebAppTableViewController.addAndSearchTableViewController = self;
    
    [self.navigationController pushViewController:addWebAppTableViewController animated:YES];
}

- (void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.view addGestureRecognizer:self.singleFingerTap];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view removeGestureRecognizer:self.singleFingerTap];
    
    [self.view endEditing:YES];
    
    [self getWebAppBySearch];
}

- (void) toucheDone
{
    [self.view removeGestureRecognizer:self.singleFingerTap];
    
    [self.elementArray removeAllObjects];
    
    [self.tableView reloadData];
    
    [self.view endEditing:YES];
}

- (void) getWebAppBySearch
{
    [self.activityIndicatorView startAnimating];
    
    if (!self.webAppModel)
    {
        self.webAppModel = [[WebAppModel alloc] init];
        
        self.webAppModel.delegate = self;
        
        self.tableView.dataSource = self;
    }
    
    [self.webAppModel getWebAppBySearch:self.searchBar.text];
}

- (void) webAppDownloaded:(NSMutableArray *)items
{
    [self.elementArray removeAllObjects];
    
    if (items.count == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] init];
        
        alertView.alertViewStyle = UIAlertViewStyleDefault;
        
        alertView.title = @"Information";
        
        alertView.message = @"Aucune application enregistrée ne correspond à votre recherche";
        
        [alertView addButtonWithTitle:@"Faire une recherche google"];
        
        [alertView addButtonWithTitle:@"Ajouter l'application"];
        
        [alertView addButtonWithTitle:@"Annuler"];
        
        alertView.delegate = self;
        
        [alertView show];
        
        [self.activityIndicatorView stopAnimating];
        
        return;
    }
    
    self.elementArray = items;
    
    [self.tableView reloadData];
    
    [self.activityIndicatorView stopAnimating];
}

- (void) getAllCategorie
{
    [self.activityIndicatorView startAnimating];
    
    if (!self.categorieModel)
    {
        self.categorieModel = [[CategorieModel alloc] init];
        
        self.categorieModel.delegate = self;
        
        self.tableView.dataSource = self;
    }
    
    [self.categorieModel getAllCategorie];
}

- (void) categorieDownloaded:(NSArray *)items
{
    self.categorieArray = items;
    
    [self.tableView reloadData];
    
    [self.activityIndicatorView stopAnimating];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Faire une recherche google"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.google.com/search?q=%@", [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"]]]];
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Ajouter l'application"])
    {
        AddWebAppTableViewController *addWebAppTableViewController = [[AddWebAppTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        addWebAppTableViewController.categorieArray = self.categorieArray;
        
        addWebAppTableViewController.addAndSearchTableViewController = self;
        
        [self.navigationController pushViewController:addWebAppTableViewController animated:YES];
    }
}

- (NSString *) getCellImageWithIndice:(int)indice
{
    NSArray *array = [[NSArray alloc] initWithObjects:
                      NSLocalizedString(@"NEWS_ICON", @"NEWS_ICON"),
                      NSLocalizedString(@"CATALOGUE_ICON", @"CATALOGUE_ICON"),
                      NSLocalizedString(@"FOOD_ICON", @"FOOD_ICON"),
                      NSLocalizedString(@"DIVERTISSEMENT_ICON", @"DIVERTISSEMENT_ICON"),
                      NSLocalizedString(@"BUSINESS_ICON", @"BUSINESS_ICON"),
                      NSLocalizedString(@"EDUCATION_ICON", @"EDUCATION_ICON"),
                      NSLocalizedString(@"CHILDREN_ICON", @"CHILDREN_ICON"),
                      NSLocalizedString(@"FINANCE_ICON", @"FINANCE_ICON"),
                      NSLocalizedString(@"SANTE_ICON", @"SANTE_ICON"),
                      NSLocalizedString(@"GAME_ICON", @"GAME_ICON"),
                      NSLocalizedString(@"NEWS_ICON", @"NEWS_ICON"),
                      NSLocalizedString(@"BOOK_ICON", @"BOOK_ICON"),
                      NSLocalizedString(@"SANTE_ICON", @"SANTE_ICON"),
                      NSLocalizedString(@"WEATHER_ICON", @"WEATHER_ICON"),
                      NSLocalizedString(@"MUSIC_ICON", @"MUSIC_ICON"),
                      NSLocalizedString(@"NAVIGATION_ICON", @"NAVIGATION_ICON"),
                      NSLocalizedString(@"MOVIE_ICON", @"MOVIE_ICON"),
                      NSLocalizedString(@"PRODUCTIVITY_ICON", @"PRODUCTIVITY_ICON"),
                      NSLocalizedString(@"REFERENCE_ICON", @"REFERENCE_ICON"),
                      NSLocalizedString(@"SOCIAL_NETWORK_ICON", @"SOCIAL_NETWORK_ICON"),
                      NSLocalizedString(@"SPORT_ICON", @"SPORT_ICON"),
                      NSLocalizedString(@"STYLE_DE_VIE_ICON", @"STYLE_DE_VIE_ICON"),
                      NSLocalizedString(@"UTILITAIRE_ICON", @"UTILITAIRE_ICON"),
                      NSLocalizedString(@"VOYAGE_ICON", @"VOYAGE_ICON"), nil];
    
    for (int i=0;i<self.categorieArray.count;i++)
    {
        if (indice == i)
        {
            return array[i];
        }
    }
    
    return @"";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.elementArray.count == 0)
    {
        return self.categorieArray.count + 1;
    }
    return self.elementArray.count + 1;
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
    
    if (self.elementArray.count == 0)
    {
        SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        Categorie *categorie = self.categorieArray[indexPath.row - 1];
        
        cell.textLabel.text = categorie.name;
        
        [cell.imageView setImage:[UIImage imageNamed:[self getCellImageWithIndice:(int)(indexPath.row - 1)]]];
        
        return cell;
    }
    else
    {
        SpecificTableViewCellWithoutImage *cell = [tableView dequeueReusableCellWithIdentifier:@"cellWithoutImage" forIndexPath:indexPath];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        WebApp *webApp = self.elementArray[indexPath.row - 1];
        
        cell.textLabel.text = webApp.name;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || [self.activityIndicatorView isAnimating])
    {
        return;
    }
    
    if (self.elementArray.count == 0)
    {
        WebAppByCategorieTableViewController *webAppByCategorieTableViewController = [[WebAppByCategorieTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        webAppByCategorieTableViewController.categorieSelected = self.categorieArray[indexPath.row - 1];
        
        webAppByCategorieTableViewController.accueilCollectionViewController = self.accueilCollectionViewController;
        
        [self.navigationController pushViewController:webAppByCategorieTableViewController animated:YES];
    }
    else
    {
        WebAppDetailsTableViewController *webAppDetailsTableViewController = [[WebAppDetailsTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        webAppDetailsTableViewController.webAppSelected = self.elementArray[indexPath.row - 1];
        
        webAppDetailsTableViewController.accueilCollectionViewController = self.accueilCollectionViewController;
        
        [self.navigationController pushViewController:webAppDetailsTableViewController animated:YES];
    }
}

@end
