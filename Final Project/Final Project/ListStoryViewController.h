//
//  ViewController3.h
//  Final Project
//
//  Created by Hung Ga 123 on 6/20/16.
//  Copyright © 2016 HungVu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TotalView.h"
#import "CurrentPage.h"
#import "Cover.h"
#import "StoryName.h"
#import "NextPage.h"
#import "PreviewPage.h"
#import "CurrentChap.h"
#import "Categorys.h"
#import <Reachability/Reachability.h>
#import "TFHppleElement.h"
#import "CustomCell2.h"
#import "APIClient.h"
#import "ListChapViewController.h"
#import <UIActivityIndicator-for-SDWebImage+UIButton/UIImageView+UIActivityIndicatorForSDWebImage.h>
#import <Reachability/Reachability.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface ListStoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnPre;

- (IBAction)clickPreviewPage:(id)sender;
- (IBAction)clickNextPage:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property NSString *urlString;
@property NSMutableArray *currentPageObjects;
@property NSMutableArray *categorysObjects;
@property NSMutableArray *storyNameObjects;
@property NSMutableArray *coverObjects;
@property NSMutableArray *nextPageObjects;
@property NSMutableArray *previewPageObjects;
@property NSMutableArray *currentChapObjects;
@property NSMutableArray *totalViewObjects;

-(void) loadListStorys:(NSString*)urlString storyName:(NSString*)storyNameXpathQueryString;
-(void) loadListStorys:(NSString*)urlString currentChap:(NSString*)currentChapXpathQueryString;
-(void) loadListStorys:(NSString*)urlString categorys:(NSString*)categorysXpathQueryString;
-(void) loadListStorys:(NSString*)urlString cover:(NSString*)coverXpathQueryString;
-(void) loadListStorys:(NSString*)urlString currentPage:(NSString*)currentPageXpathQueryString;
-(void) loadListStorys:(NSString*)urlString previewPage:(NSString*)previewPageXpathQueryString;
-(void) loadListStorys:(NSString*)urlString nextPage:(NSString*)nextPageXpathQueryString;
-(void) loadListStorys:(NSString*)urlString totalView:(NSString*)totalViewXpathQueryString;
@end

