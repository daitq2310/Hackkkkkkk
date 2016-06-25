//
//  APIClient.m
//  Final Project
//
//  Created by Hung Ga 123 on 6/20/16.
//  Copyright © 2016 HungVu. All rights reserved.
//

#import "APIClient.h"

@implementation APIClient
+ (instancetype)sharedInstance
{
    static APIClient *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}
-(NSArray*) loadFromUrl:(NSString *)yourUrlString withXpathQueryString:(NSString *)yourXpathQueryString {
    NSURL *url = [NSURL URLWithString:yourUrlString];
    NSData *htmlData = [NSData dataWithContentsOfURL:url];
    TFHpple *parser = [TFHpple hppleWithHTMLData:htmlData];
    NSString *xpathQueryString = yourXpathQueryString;
    NSArray *nodesArray = [parser searchWithXPathQuery:xpathQueryString];
    return nodesArray;
}
@end
