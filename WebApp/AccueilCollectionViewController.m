//
//  AccueilCollectionViewController.m
//  WebApp
//
//  Created by Thomas Mac on 12/10/2015.
//  Copyright © 2015 ThomasNeyraut. All rights reserved.
//

#import "AccueilCollectionViewController.h"
#import "AddAndSearchTableViewController.h"

#import "SpecificCollectionViewCell.h"
#import "WebApp.h"

@interface AccueilCollectionViewController () <UIAlertViewDelegate>

@property(nonatomic, strong) NSMutableArray *sectionArray;

@property(nonatomic, strong) NSMutableArray *labelTitleCellArray;

@property(nonatomic, strong) NSMutableArray *labelDetailCellArray;

@property(nonatomic) int indiceCellSelected;

@end

@implementation AccueilCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    [self.collectionView registerClass:[SpecificCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    
    self.sauvegarde = [NSUserDefaults standardUserDefaults];
    
    self.sectionArray = [[NSMutableArray alloc] init];
    
    if (![self.sauvegarde integerForKey:@"numberSections"])
    {
        [self.sauvegarde setInteger:1 forKey:@"numberSections"];
        
        [self.sauvegarde setInteger:1 forKey:@"numberElementsInSection0"];
        
        [self.sauvegarde synchronize];
    }
    
    [self.navigationItem setTitle:@"Accueil"];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    
    shadow.shadowColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
    
    shadow.shadowOffset = CGSizeMake(0, 1);
    
    UIBarButtonItem *buttonPrevious = [[UIBarButtonItem alloc] initWithTitle:@"Accueil" style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [buttonPrevious setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    self.navigationItem.backBarButtonItem = buttonPrevious;
    
    UIBarButtonItem *buttonAdd = [[UIBarButtonItem alloc] initWithTitle:@"Add/Search" style:UIBarButtonItemStyleDone target:self action:@selector(actionListenerButtonAdd)];
    
    [buttonAdd setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName, shadow, NSShadowAttributeName,[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:21.0], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    [self.navigationItem setRightBarButtonItem:buttonAdd];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    
    lpgr.minimumPressDuration = 0.5;
    
    lpgr.delegate = self;
    
    lpgr.delaysTouchesBegan = YES;
    
    [self.collectionView addGestureRecognizer:lpgr];
    
    self.labelTitleCellArray = [[NSMutableArray alloc] init];
    
    self.labelDetailCellArray = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self initSectionArray];
    
    [super viewDidAppear:animated];
}

- (void) initSectionArray
{
    [self.sectionArray removeAllObjects];
    
    int numberSections = (int)[self.sauvegarde integerForKey:@"numberSections"];
    
    for (int i=0;i<numberSections;i++)
    {
        int numberElementsInSection = (int)[self.sauvegarde integerForKey:[NSString stringWithFormat:@"numberElementsInSection%d", i]];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for (int j=0;j<numberElementsInSection-1;j++)
        {
            NSString *name = [self.sauvegarde objectForKey:[NSString stringWithFormat:@"element%dInSection%dName", j, i]];
            
            NSString *url = [self.sauvegarde objectForKey:[NSString stringWithFormat:@"element%dInSection%dUrl", j, i]];
            
            WebApp *webApp = [[WebApp alloc] init];
            
            webApp.name = name;
            
            webApp.url = url;
            
            [array addObject:webApp];
        }
        
        [self.sectionArray addObject:array];
    }
    
    [self.collectionView reloadData];
}

- (void) actionListenerButtonAdd
{
    AddAndSearchTableViewController *addAndSearchTableViewController = [[AddAndSearchTableViewController alloc] initWithStyle:UITableViewStylePlain];
    
    addAndSearchTableViewController.accueilCollectionViewController = self;
    
    [self.navigationController pushViewController:addAndSearchTableViewController animated:YES];
}

- (void) handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
    {
        return;
    }
    CGPoint p = [gestureRecognizer locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    
    if (indexPath)
    {
        self.indiceCellSelected = (int)indexPath.row;
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirmation" message:[NSString stringWithFormat:@"Êtes-vous sûr de vouloir supprimer l'application '%@' ?", [self.sauvegarde objectForKey:[NSString stringWithFormat:@"element%dInSection0Name", self.indiceCellSelected]]] delegate:self cancelButtonTitle:@"Oui" otherButtonTitles:@"Non", nil];
        
        [alertView show];
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Oui"])
    {
        [self supprimerWebAppAtIndice:self.indiceCellSelected];
    }
}

- (void) supprimerWebAppAtIndice:(int)indice
{
    int numberElements = (int)[self.sauvegarde integerForKey:@"numberElementsInSection0"];
    
    for (int i=(indice + 1);i<numberElements;i++)
    {
        NSString *name = [self.sauvegarde objectForKey:[NSString stringWithFormat:@"element%dInSection0Name", i]];
        
        NSString *url = [self.sauvegarde objectForKey:[NSString stringWithFormat:@"element%dInSection0Url", i]];
        
        [self.sauvegarde setObject:name forKey:[NSString stringWithFormat:@"element%dInSection0Name", (i - 1)]];
        
        [self.sauvegarde setObject:url forKey:[NSString stringWithFormat:@"element%dInSection0Url", (i - 1)]];
    }
    numberElements--;
    
    [self.sauvegarde setInteger:numberElements forKey:@"numberElementsInSection0"];
    
    [self.sauvegarde removeObjectForKey:[NSString stringWithFormat:@"element%dInSection0Name", numberElements]];
    
    [self.sauvegarde removeObjectForKey:[NSString stringWithFormat:@"element%dInSection0Url", numberElements]];
    
    [self.sauvegarde synchronize];
    
    [self initSectionArray];
}

#pragma mark <UICollectionViewDataSource>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.sectionArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *array = self.sectionArray[section];
    
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SpecificCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    [cell setBackgroundColor:[UIColor blackColor]];
    
    NSArray *array = self.sectionArray[indexPath.section];
    
    WebApp *webApp = array[indexPath.row];
    
    if (indexPath.row < self.labelTitleCellArray.count)
    {
        UILabel *labelTitle = self.labelTitleCellArray[indexPath.row];
        
        [labelTitle setText:[[webApp.name substringToIndex:1] uppercaseString]];
        
        UILabel *labelDetail = self.labelDetailCellArray[indexPath.row];
        
        [labelDetail setText:webApp.name];
    }
    else
    {
        UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, cell.frame.size.width, 2 * cell.frame.size.height / 3)];
        
        [labelTitle setTextAlignment:NSTextAlignmentCenter];
        
        [labelTitle setTextColor:[UIColor whiteColor]];
        
        [labelTitle setShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]];
        
        [labelTitle setShadowOffset:CGSizeMake(0, 1)];
        
        [labelTitle setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:75.0]];
        
        [labelTitle setText:[[webApp.name substringToIndex:1] uppercaseString]];
        
        [cell addSubview:labelTitle];
        
        [self.labelTitleCellArray addObject:labelTitle];
        
        UILabel *labelDetail = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 2 * cell.frame.size.height / 3, cell.frame.size.width, cell.frame.size.height / 3)];
        
        [labelDetail setTextAlignment:NSTextAlignmentCenter];
        
        [labelDetail setTextColor:[UIColor whiteColor]];
        
        [labelDetail setShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8]];
        
        [labelDetail setShadowOffset:CGSizeMake(0, 1)];
        
        [labelDetail setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:15.0]];
        
        [labelDetail setText:webApp.name];
        
        [cell addSubview:labelDetail];
        
        [self.labelDetailCellArray addObject:labelDetail];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = self.sectionArray[indexPath.section];
    
    WebApp *webApp = array[indexPath.row];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webApp.url]];
}



#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
