//
//  APIClient.h
//  Final Project
//
//  Created by Hung Ga 123 on 6/20/16.
//  Copyright © 2016 HungVu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHpple.h"
#import "TFHppleElement.h"
@interface APIClient : NSObject
+ (instancetype)sharedInstance;
-(NSArray*) loadFromUrl:(NSString*)urlString withXpathQueryString:(NSString*)xpathQueryString;
@end
