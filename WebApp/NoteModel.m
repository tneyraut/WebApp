//
//  NoteModel.m
//  WebApp
//
//  Created by Thomas Mac on 17/10/2015.
//  Copyright © 2015 ThomasNeyraut. All rights reserved.
//

#import "NoteModel.h"

#import "Note.h"

@interface NoteModel ()

@property(nonatomic, strong) NSMutableData* downloadedData;

@end

@implementation NoteModel

- (void) addNote:(int)note commentaire:(NSString *)commentaire webAppId:(int)webApp_id
{
    NSString *url = [NSString stringWithFormat:@"note=%d&commentaire=%@&webApp_id=%d",note, commentaire, webApp_id];
    
    NSData *postData = [url dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", (int)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@addNote", NSLocalizedString(@"URL", @"URL")]]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:postData];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)getAllNoteByWebAppId:(int)webApp_id
{
    NSURL *jsonFileUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@getAllNoteByWebAppId.php?webApp_id=%d",NSLocalizedString(@"URL", @"URL"), webApp_id]];
    
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
    NSMutableArray *noteArray = [[NSMutableArray alloc] init];
    
    NSError *error;
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:self.downloadedData options:NSJSONReadingAllowFragments error:&error];
    
    for (int i=0;i<jsonArray.count;i++)
    {
        NSDictionary *array = jsonArray[i];
        
        Note *note = [[Note alloc] init];
        
        note.note_id = [array[@"note_id"] intValue];
        
        note.note = [array[@"note"] intValue];
        
        note.webApp_id = [array[@"webApp_id"] intValue];
        
        note.commentaire = array[@"commentaire"];
        
        [noteArray addObject:note];
    }
    
    if (self.delegate)
    {
        [self.delegate noteDownloaded:noteArray];
    }
}

@end
