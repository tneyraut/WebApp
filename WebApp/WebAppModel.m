//
//  WebAppModel.m
//  WebApp
//
//  Created by Thomas Mac on 13/10/2015.
//  Copyright © 2015 ThomasNeyraut. All rights reserved.
//

#import "WebAppModel.h"

#import "WebApp.h"

@interface WebAppModel ()

@property(nonatomic, strong) NSMutableData* downloadedData;

@end

@implementation WebAppModel

- (void) creerWebApp:(NSString*)webApp_name url:(NSString*)url description:(NSString*)description categorie_id:(int)categorie_id
{
    NSString *urls = [NSString stringWithFormat:@"webApp_name=%@&url=%@&description=%@&categorie_id=%d", webApp_name, url, description, categorie_id];
    
    NSData *postData = [urls dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@creerWebApp", NSLocalizedString(@"URL", @"URL")]]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:postData];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) getAllWebApp
{
    NSURL *jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@getAllWebApp.php", NSLocalizedString(@"URL", @"URL")]];
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) getWebAppBySearch:(NSString *)search
{
    NSURL *jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@getWebAppBySearch.php?search=%@", NSLocalizedString(@"URL", @"URL"), [search stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) supprimerWebApp:(int)webApp_id
{
    NSString *url = [NSString stringWithFormat:@"webApp_id=%d", webApp_id];
    
    NSData *postData = [url dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@supprimerWebApp", NSLocalizedString(@"URL", @"URL")]]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:postData];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) updateWebApp:(int)webApp_id webApp_name:(NSString*)webApp_name description:(NSString*)description categorie_id:(int)categorie_id url:(NSString*)url
{
    NSString *urls = [NSString stringWithFormat:@"webApp_id=%d&webApp_name=%@&description=%@&categorie_id=%d&url=%@", webApp_id, webApp_name, description, categorie_id, url];
    
    NSData *postData = [urls dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@updateWebApp", NSLocalizedString(@"URL", @"URL")]]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:postData];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void) getWebAppByName:(NSString*)webApp_name
{
    NSURL *jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@getWebAppByName.php?webApp_name=%@", NSLocalizedString(@"URL", @"URL"), [webApp_name stringByReplacingOccurrencesOfString:@" " withString:@"%20"]]];
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) getWebAppByUrl:(NSString*)url
{
    NSURL *jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@getWebAppByUrl.php?url=%@", NSLocalizedString(@"URL", @"URL"), url]];
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) getWebAppByCategorieId:(int)categorie_id
{
    NSURL *jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@getWebAppByCategorieId.php?categorie_id=%d", NSLocalizedString(@"URL", @"URL"), categorie_id]];
    
    NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:jsonFileUrl];
    
    [NSURLConnection connectionWithRequest:urlRequest delegate:self];
}

- (void) getWebAppById:(int)webApp_id
{
    NSURL *jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@getWebAppById.php?webApp_id=%d", NSLocalizedString(@"URL", @"URL"), webApp_id]];
    
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
    NSMutableArray *webAppArray = [[NSMutableArray alloc] init];
    
    NSError *error;
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:self.downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    for (int i=0;i<jsonArray.count;i++)
    {
        NSDictionary *array = jsonArray[i];
        
        WebApp *webApp = [[WebApp alloc] init];
        
        webApp.webApp_id = [array[@"webApp_id"] intValue];
        
        webApp.note = [array[@"note"] floatValue];
        
        webApp.notee = [array[@"notee"] boolValue];
        
        webApp.descrip = array[@"description"];
        
        webApp.name = array[@"webApp_name"];
        
        webApp.categorie_name = array[@"categorie_name"];
        
        webApp.url = array[@"url"];
        
        [webAppArray addObject:webApp];
    }
    
    if (self.delegate)
    {
        [self.delegate webAppDownloaded:webAppArray];
    }
}

@end
