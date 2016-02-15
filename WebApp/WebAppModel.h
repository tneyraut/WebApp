//
//  WebAppModel.h
//  WebApp
//
//  Created by Thomas Mac on 13/10/2015.
//  Copyright © 2015 ThomasNeyraut. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WebAppModelProtocol <NSObject>

- (void) webAppDownloaded:(NSMutableArray*)items;

@end

@interface WebAppModel : NSObject <NSURLConnectionDataDelegate>

@property(nonatomic, weak) id <WebAppModelProtocol> delegate;

- (void) creerWebApp:(NSString*)webApp_name url:(NSString*)url description:(NSString*)description categorie_id:(int)categorie_id;

- (void) getAllWebApp;

- (void) getWebAppBySearch:(NSString*)search;

- (void) supprimerWebApp:(int)webApp_id;

- (void) updateWebApp:(int)webApp_id webApp_name:(NSString*)webApp_name description:(NSString*)description categorie_id:(int)categorie_id url:(NSString*)url;

- (void) getWebAppByName:(NSString*)webApp_name;

- (void) getWebAppByUrl:(NSString*)url;

- (void) getWebAppByCategorieId:(int)categorie_id;

- (void) getWebAppById:(int)webApp_id;

@end
