//
//  ViewController2.h
//  Final Project
//
//  Created by Hung Ga 123 on 6/20/16.
//  Copyright © 2016 HungVu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Reachability/Reachability.h>
#import <TFHppleElement.h>
#include "AppDelegate.h"
#import "TopStoryName.h"
#import "TopStoryImage.h"
#import "CustomCell.h"
#import "xCategory.h"

#import "APIClient.h"
#import "ListStoryViewController.h"
#import "ViewController.h"
@interface CategoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *categoryObjects;
@property NSMutableArray *topStoryImageObjects;
@property NSMutableArray *topStoryNameObjects;



@end
