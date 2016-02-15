//
//  WebAppNoteTableViewController.m
//  WebApp
//
//  Created by Thomas Mac on 18/10/2015.
//  Copyright © 2015 ThomasNeyraut. All rights reserved.
//

#import "WebAppNoteTableViewController.h"

#import "SpecificTableViewCellWithoutImage.h"

#import "Note.h"

@interface WebAppNoteTableViewController () <UIAlertViewDelegate>

@property(nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property(nonatomic, strong) NoteModel *noteModel;

@property(nonatomic, strong) NSArray *elementArray;

@property(nonatomic) BOOL addNoteMode;

@property(nonatomic) int note;

@end

@implementation WebAppNoteTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableView registerClass:[SpecificTableViewCellWithoutImage class] forCellReuseIdentifier:@"cell"];
    
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
    
    self.addNoteMode = NO;
    
    [self getAllNoteByWebAppId:self.webAppSelected.webApp_id];
    
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
    
    UIBarButtonItem *buttonNoter = [[UIBarButtonItem alloc] initWithTitle:@"Noter l'application"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(buttonNoterActionListener)];
    
    [buttonNoter setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName, [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                      target:nil
                                      action:nil];
    
    [self.navigationController.toolbar setItems:@[ flexibleSpace, buttonNoter, flexibleSpace ]];
    
    [super viewDidAppear:animated];
}

- (void) buttonNoterActionListener
{
    self.addNoteMode = YES;
    
    UIAlertView *alertView = [[UIAlertView alloc] init];
    
    alertView.alertViewStyle = UIAlertViewStyleDefault;
    
    alertView.title = @"Ajout d'une note";
    
    alertView.message = [NSString stringWithFormat:@"Veuillez sélectionner votre note pour l'application : '%@'", self.webAppSelected.name];
    
    [alertView addButtonWithTitle:@"0"];
    [alertView addButtonWithTitle:@"1"];
    [alertView addButtonWithTitle:@"2"];
    [alertView addButtonWithTitle:@"3"];
    [alertView addButtonWithTitle:@"4"];
    [alertView addButtonWithTitle:@"5"];
    
    [alertView addButtonWithTitle:@"Annuler"];
    
    alertView.delegate = self;
    
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Annuler"] || [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"OK"])
    {
        self.addNoteMode = NO;
        
        return;
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Valider"])
    {
        if ([[alertView textFieldAtIndex:0].text isEqualToString:@""])
        {
            [alertView show];
            
            return;
        }
        
        [self.activityIndicatorView startAnimating];
        
        [self.noteModel addNote:self.note commentaire:[alertView textFieldAtIndex:0].text webAppId:self.webAppSelected.webApp_id];
        
        return;
    }
    self.note = [[alertView buttonTitleAtIndex:buttonIndex] intValue];
    
    UIAlertView *alert = [[UIAlertView alloc] init];
    
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    alert.title = @"Ajout d'un commentaire";
    
    alert.message = [NSString stringWithFormat:@"Veuillez rentrer un commentaire à votre note (%d) pour l'application : '%@'", self.note, self.webAppSelected.name];
    
    [alert textFieldAtIndex:0].placeholder = @"Votre commentaire";
    
    [alert addButtonWithTitle:@"Valider"];
    
    [alert addButtonWithTitle:@"Annuler"];
    
    alert.delegate = self;
    
    [alert show];
}

- (void) getAllNoteByWebAppId:(int)webApp_id
{
    [self.activityIndicatorView startAnimating];
    
    if (!self.noteModel)
    {
        self.noteModel = [[NoteModel alloc] init];
        
        self.noteModel.delegate = self;
        
        self.tableView.dataSource = self;
    }
    
    [self.noteModel getAllNoteByWebAppId:webApp_id];
}

- (void) noteDownloaded:(NSArray *)items
{
    if (self.addNoteMode)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Information" message:@"Votre note et commentaire ont été pris en compte" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
        self.addNoteMode = NO;
        
        [self.activityIndicatorView stopAnimating];
        
        [self getAllNoteByWebAppId:self.webAppSelected.webApp_id];
        
        return;
    }
    
    self.elementArray = items;
    
    [self.tableView reloadData];
    
    [self.activityIndicatorView stopAnimating];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.elementArray.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Note Globale";
    }
    Note *note = self.elementArray[section - 1];
    
    return [NSString stringWithFormat:@"Note : %d/5", note.note];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SpecificTableViewCellWithoutImage *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section == 0)
    {
        [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"NOTE_ICON", @"NOTE_ICON")]];
        
        if (self.webAppSelected.notee)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"Note Globale : %f/5", self.webAppSelected.note];
        }
        else
        {
            cell.textLabel.text = @"Note Globale : Non notée";
        }
    }
    else
    {
        Note *note = self.elementArray[indexPath.section - 1];
        
        cell.textLabel.text = note.commentaire;
        
        [cell.imageView setImage:[UIImage imageNamed:NSLocalizedString(@"COMMENT_ICON", @"COMMENT_ICON")]];
    }
    
    return cell;
}

@end
