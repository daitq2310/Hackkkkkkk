//
//  DetailChapViewController.h
//  Final Project
//
//  Created by Quang Dai on 6/25/16.
//  Copyright © 2016 HungVu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFHppleElement.h"

#import "Image.h"
#import "NextChap.h"
#import "PreviewChap.h"
#import "ChapReading.h"

#import "APIClient.h"
#import <SWRevealViewController/SWRevealViewController.h>
//#import <UIActivityIndicator-for-SDWebImage+UIButton/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import <UIActivityIndicator-for-SDWebImage+UIButton/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import "ChapContentViewController.h"
@interface DetailChapViewController : UIViewController
@property id dataImageName;
//
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property NSMutableArray *imageObjects;
@property NSMutableArray *nextChapObjects;
@property NSMutableArray *previewChapObjects;
@property NSMutableArray *chapReadingObjects;
-(void) loadChapContent:(NSString*)urlString chapReading:(NSString*)chapReadingXpathQueryString;
-(void) loadChapContent:(NSString*)urlString nextChap:(NSString*)nextChapXpathQueryString;
-(void) loadChapContent:(NSString*)urlString previewChap:(NSString*)previewChapXpathQueryString;
-(void) loadChapContent:(NSString*)urlString image:(NSString*)imageXpathQueryString;
@property NSString *urlString;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property NSMutableArray *arrImageName;


@property int currentPage;


@end
