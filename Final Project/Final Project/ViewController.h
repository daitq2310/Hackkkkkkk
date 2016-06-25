//
//  ViewController.h
//  Final Project
//
//  Created by Hung Ga 123 on 6/14/16.
//  Copyright © 2016 HungVu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SWRevealViewController/SWRevealViewController.h>
#import "ConstantValues.h"
#import "PageContentViewController.h"


#import <Reachability/Reachability.h>
#import <TFHppleElement.h>

#import "TopStoryName.h"
#import "TopStoryImage.h"
#import "CustomCell.h"
#import "xCategory.h"

#import "APIClient.h"
#import "ListStoryViewController.h"
@interface ViewController : UIViewController <UIPageViewControllerDataSource,UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barBtnItem;




@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *categoryObjects;
@property NSMutableArray *topStoryImageObjects;
@property NSMutableArray *topStoryNameObjects;
@end

