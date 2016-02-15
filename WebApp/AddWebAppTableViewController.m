//
//  AddWebAppTableViewController.m
//  WebApp
//
//  Created by Thomas Mac on 17/10/2015.
//  Copyright © 2015 ThomasNeyraut. All rights reserved.
//

#import "AddWebAppTableViewController.h"

#import "SpecificTableViewCell.h"

#import "Categorie.h"

@interface AddWebAppTableViewController () <UIAlertViewDelegate, UIActionSheetDelegate>

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) NSString *webAppName;

@property(nonatomic, strong) NSString *webAppUrl;

@property(nonatomic, strong) NSString *descrip;

@property(nonatomic, strong) Categorie *categorie;

@property(nonatomic, strong) NSArray *titleArray;

@property(nonatomic, strong) NSArray *imageArray;

@property(nonatomic) BOOL selectionName;

@property(nonatomic) BOOL selectionUrl;

@property(nonatomic) BOOL selectionDescription;

@property(nonatomic) BOOL addAction;

@property(nonatomic, strong) WebAppModel *webAppModel;

@end

@implementation AddWebAppTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SpecificTableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.activityIndicatorView setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    
    [self.activityIndicatorView setColor:[UIColor blackColor]];
    
    [self.activityIndicatorView setHidesWhenStopped:YES];
    
    [self.tableView addSubview:self.activityIndicatorView];
    
    [self.navigationItem setTitle:@"Add Web App"];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Add Web App" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
    
    self.selectionDescription = NO;
    
    self.selectionName = NO;
    
    self.selectionUrl = NO;
    
    self.addAction = NO;
    
    self.webAppName = @"";
    
    self.webAppUrl = @"";
    
    self.descrip = @"";
    
    self.categorie = [[Categorie alloc] init];
    
    self.categorie.name = @"";
    
    self.titleArray = [[NSArray alloc] initWithObjects:@"Name : ", @"Category : ", @"URL : ", @"Description : ", nil];
    
    self.imageArray = [[NSArray alloc] initWithObjects:
                       NSLocalizedString(@"NAME_APP_ICON", @"NAME_APP_ICON"),
                       NSLocalizedString(@"CATEGORY_ICON", @"CATEGORY_ICON"),
                       NSLocalizedString(@"URL_ICON", @"URL_ICON"),
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
    if ([self.webAppName isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Veuillez saisir un nom pour l'application web" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        return;
    }
    if ([self.webAppUrl isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Veuillez saisir une url pour l'application web" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        return;
    }
    if ([self.categorie.name isEqualToString:@""])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Veuillez choisir une catégorie pour l'application web" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        return;
    }
    
    self.addAction = YES;
    
    [self addWebApp:self.webAppName url:self.webAppUrl  description:self.descrip categorie_id:self.categorie.categorie_id];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Annuler"])
    {
        self.selectionDescription = NO;
        
        self.selectionName = NO;
        
        self.selectionUrl = NO;
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Valider"])
    {
        if (self.selectionName)
        {
            self.webAppName = [alertView textFieldAtIndex:0].text;
            
            [self getWebAppByName:[alertView textFieldAtIndex:0].text];
        }
        else if (self.selectionUrl)
        {
            if (![self validateUrl:[alertView textFieldAtIndex:0].text])
            {
                UIAlertView *alertView = [[UIAlertView alloc] init];
                
                alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
                
                alertView.title = @"Web App URL";
                
                alertView.message = @"L'url rentré n'est pas une url valide. Veuillez rentrer une autre url pour l'application web";
                
                [alertView textFieldAtIndex:0].placeholder = @"Web App URL";
                
                [alertView addButtonWithTitle:@"Valider"];
                
                [alertView addButtonWithTitle:@"Annuler"];
                
                alertView.delegate = self;
                
                [alertView show];
                
                return;
            }
            
            self.webAppUrl = [alertView textFieldAtIndex:0].text;
            
            [self getWebAppByUrl:[alertView textFieldAtIndex:0].text];
        }
        else if (self.selectionDescription)
        {
            self.descrip = [alertView textFieldAtIndex:0].text;
            
            self.selectionDescription = NO;
            
            [self.tableView reloadData];
        }
    }
}

- (BOOL) validateUrl:(NSString *)candidate
{
    NSString *urlRegEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    
    return [urlTest evaluateWithObject:candidate];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    for (int i=0;i<self.categorieArray.count;i++)
    {
        Categorie *uneCategorie = self.categorieArray[i];
        
        if ([uneCategorie.name isEqualToString:[actionSheet buttonTitleAtIndex:buttonIndex]])
        {
            self.categorie = uneCategorie;
            
            break;
        }
    }
    
    [self.tableView reloadData];
}

- (void) getWebAppByName:(NSString *)name
{
    [self.activityIndicatorView startAnimating];
    
    if (!self.webAppModel)
    {
        self.webAppModel = [[WebAppModel alloc] init];
        
        self.webAppModel.delegate = self;
        
        self.tableView.dataSource = self;
    }
    
    [self.webAppModel getWebAppByName:name];
}

- (void) getWebAppByUrl:(NSString *)url
{
    [self.activityIndicatorView startAnimating];
    
    if (!self.webAppModel)
    {
        self.webAppModel = [[WebAppModel alloc] init];
        
        self.webAppModel.delegate = self;
        
        self.tableView.dataSource = self;
    }
    
    [self.webAppModel getWebAppByUrl:url];
}

- (void) addWebApp:(NSString *)name url:(NSString *)url description:(NSString *)description categorie_id:(int)categorie_id
{
    [self.activityIndicatorView startAnimating];
    
    if (!self.webAppModel)
    {
        self.webAppModel = [[WebAppModel alloc] init];
        
        self.webAppModel.delegate = self;
        
        self.tableView.dataSource = self;
    }
    
    [self.webAppModel creerWebApp:name url:url description:description categorie_id:categorie_id];
}

- (void) webAppDownloaded:(NSMutableArray *)items
{
    if (self.addAction)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:[NSString stringWithFormat:@"L'application '%@' a été ajoutée.", self.webAppName] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        [self.navigationController popToViewController:self.addAndSearchTableViewController animated:YES];
        
        [self.activityIndicatorView stopAnimating];
        
        return;
    }
    
    if (items.count !=0)
    {
        if (self.selectionName)
        {
            UIAlertView *alertView = [[UIAlertView alloc] init];
            
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            
            alertView.title = @"Web App Name";
            
            alertView.message = @"Le nom rentré existe déjà. Veuillez rentrer un autre nom pour l'application web";
            
            [alertView textFieldAtIndex:0].placeholder = @"Web App Name";
            
            [alertView addButtonWithTitle:@"Valider"];
            
            [alertView addButtonWithTitle:@"Annuler"];
            
            alertView.delegate = self;
            
            self.selectionName = YES;
            
            self.webAppName = @"";
            
            [alertView show];
        }
        else if (self.selectionUrl)
        {
            UIAlertView *alertView = [[UIAlertView alloc] init];
            
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            
            alertView.title = @"Web App URL";
            
            alertView.message = @"L'url rentré existe déjà. Veuillez rentrer une autre url pour l'application web";
            
            [alertView textFieldAtIndex:0].placeholder = @"Web App URL";
            
            [alertView addButtonWithTitle:@"Valider"];
            
            [alertView addButtonWithTitle:@"Annuler"];
            
            alertView.delegate = self;
            
            self.selectionUrl = YES;
            
            self.webAppUrl = @"";
            
            [alertView show];
        }
    }
    else
    {
        self.selectionName = NO;
        
        self.selectionUrl = NO;
        
        [self.tableView reloadData];
    }
    
    [self.activityIndicatorView stopAnimating];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3)
    {
        return 100.0f;
    }
    return 75.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpecificTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = [self.titleArray[indexPath.row] stringByAppendingString:self.webAppName];
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = [self.titleArray[indexPath.row] stringByAppendingString:self.categorie.name];
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = [self.titleArray[indexPath.row] stringByAppendingString:self.webAppUrl];
    }
    else if (indexPath.row == 3)
    {
        cell.textLabel.text = [self.titleArray[indexPath.row] stringByAppendingString:self.descrip];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell.imageView setImage:[UIImage imageNamed:self.imageArray[indexPath.row]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.activityIndicatorView isAnimating])
    {
        return;
    }
    
    if (indexPath.row == 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] init];
        
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        alertView.title = @"Web App Name";
        
        alertView.message = @"Rentrer le nom de l'application web";
        
        [alertView textFieldAtIndex:0].placeholder = @"Web App Name";
        
        [alertView addButtonWithTitle:@"Valider"];
        
        [alertView addButtonWithTitle:@"Annuler"];
        
        alertView.delegate = self;
        
        self.selectionName = YES;
        
        [alertView show];
    }
    else if (indexPath.row == 1)
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Annuler" destructiveButtonTitle:nil otherButtonTitles:nil];
        
        actionSheet.title = @"Sélectionner une catégorie";
        
        for (int i=0;i<self.categorieArray.count;i++)
        {
            Categorie *uneCategorie = self.categorieArray[i];
            
            [actionSheet addButtonWithTitle:uneCategorie.name];
        }
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            [actionSheet showFromToolbar:self.navigationController.toolbar];
        }
        else
        {
            [actionSheet showInView:self.view];
        }
    }
    else if (indexPath.row == 2)
    {
        UIAlertView *alertView = [[UIAlertView alloc] init];
        
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        alertView.title = @"Web App URL";
        
        alertView.message = @"Rentrer l'url de l'application web";
        
        [alertView textFieldAtIndex:0].placeholder = @"Web App URL";
        
        [alertView addButtonWithTitle:@"Valider"];
        
        [alertView addButtonWithTitle:@"Annuler"];
        
        alertView.delegate = self;
        
        self.selectionUrl = YES;
        
        [alertView show];
    }
    else if (indexPath.row == 3)
    {
        UIAlertView *alertView = [[UIAlertView alloc] init];
        
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        alertView.title = @"Web App Description";
        
        alertView.message = @"Rentrer une description de l'application web";
        
        [alertView textFieldAtIndex:0].placeholder = @"Web App Description";
        
        [alertView addButtonWithTitle:@"Valider"];
        
        [alertView addButtonWithTitle:@"Annuler"];
        
        alertView.delegate = self;
        
        self.selectionDescription = YES;
        
        [alertView show];
    }
}

@end
