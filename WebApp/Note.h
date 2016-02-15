//
//  Note.h
//  WebApp
//
//  Created by Thomas Mac on 17/10/2015.
//  Copyright © 2015 ThomasNeyraut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject

@property(nonatomic) int note_id;

@property(nonatomic) int webApp_id;

@property(nonatomic) int note;

@property(nonatomic, strong) NSString *commentaire;

@end
