//
//  WebApp.h
//  WebApp
//
//  Created by Thomas Mac on 12/10/2015.
//  Copyright © 2015 ThomasNeyraut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebApp : NSObject

@property(nonatomic) int webApp_id;

@property(nonatomic, strong) NSString *name;

@property(nonatomic, strong) NSString *url;

@property(nonatomic, strong) NSString *descrip;

@property(nonatomic) float note;

@property(nonatomic) BOOL notee;

@property(nonatomic, strong) NSString *categorie_name;

@end
