//
//  CategorieModel.h
//  WebApp
//
//  Created by Thomas Mac on 17/10/2015.
//  Copyright © 2015 ThomasNeyraut. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CategorieModelProtocol <NSObject>

- (void) categorieDownloaded:(NSArray*)items;

@end

@interface CategorieModel : NSObject <NSURLConnectionDataDelegate>

@property(nonatomic, weak) id <CategorieModelProtocol> delegate;

- (void) getAllCategorie;

@end
