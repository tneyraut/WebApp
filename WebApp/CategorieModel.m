//
//  CategorieModel.m
//  WebApp
//
//  Created by Thomas Mac on 17/10/2015.
//  Copyright © 2015 ThomasNeyraut. All rights reserved.
//

#import "CategorieModel.h"

#import "Categorie.h"

@interface CategorieModel ()

@property(nonatomic, strong) NSMutableData* downloadedData;

@end

@implementation CategorieModel

- (void)getAllCategorie
{
    NSURL *jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@getAllCategorie.php",NSLocalizedString(@"URL", @"URL")]];
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.downloadedData = [[NSMutableData alloc] init];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.downloadedData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSMutableArray *categorieArray = [[NSMutableArray alloc] init];
    
    NSError *error;
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:self.downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    for (int i=0;i<jsonArray.count;i++)
    {
        NSDictionary *array = jsonArray[i];
        
        Categorie *categorie = [[Categorie alloc] init];
        
        categorie.categorie_id = [array[@"categorie_id"] intValue];
        
        categorie.name = array[@"categorie_name"];
        
        [categorieArray addObject:categorie];
    }
    
    if (self.delegate)
    {
        [self.delegate categorieDownloaded:categorieArray];
    }
}

@end
