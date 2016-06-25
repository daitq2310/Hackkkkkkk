//
//  ChapContentViewController.h
//  Final Project
//
//  Created by Hung Ga 123 on 6/21/16.
//  Copyright © 2016 HungVu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TFHppleElement.h>

#import "Image.h"
#import "NextChap.h"
#import "PreviewChap.h"
#import "ChapReading.h"

#import "APIClient.h"

#import <SWRevealViewController/SWRevealViewController.h>
#import <UIActivityIndicator-for-SDWebImage+UIButton/UIImageView+UIActivityIndicatorForSDWebImage.h>
@interface ChapContentViewController : UIViewController <UIPageViewControllerDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)clickHomeBtn:(id)sender;
- (IBAction)clickNextBtn:(id)sender;
- (IBAction)clickPreviewBtn:(id)sender;

@property NSMutableArray *nextChapObjects;
@property NSMutableArray *previewChapObjects;
@property NSMutableArray *chapReadingObjects;
-(void) loadChapContent:(NSString*)urlString chapReading:(NSString*)chapReadingXpathQueryString;
-(void) loadChapContent:(NSString*)urlString nextChap:(NSString*)nextChapXpathQueryString;
-(void) loadChapContent:(NSString*)urlString previewChap:(NSString*)previewChapXpathQueryString;
-(void) loadChapContent:(NSString*)urlString image:(NSString*)imageXpathQueryString;
@property NSString *urlString;






@property (strong, nonatomic) UIPageViewController *pageViewController;
@property NSMutableArray *imageObjects;
@property NSMutableArray *imagesName;

@end
