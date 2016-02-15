//
//  NoteModel.h
//  WebApp
//
//  Created by Thomas Mac on 17/10/2015.
//  Copyright © 2015 ThomasNeyraut. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NoteModelProtocol <NSObject>

- (void) noteDownloaded:(NSArray*)items;

@end

@interface NoteModel : NSObject <NSURLConnectionDataDelegate>

@property(nonatomic, weak) id <NoteModelProtocol> delegate;

- (void) addNote:(int)note commentaire:(NSString*)commentaire webAppId:(int)webApp_id;

- (void) getAllNoteByWebAppId:(int)webApp_id;

@end
