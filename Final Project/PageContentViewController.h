//
//  PageContentViewController.h
//  Final Project
//
//  Created by Quang Dai on 6/24/16.
//  Copyright © 2016 HungVu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConstantValues.h"
@interface PageContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imvRandomManga;
@property NSUInteger pageIndex;
@property NSString *imageFile;
@property int currentPage;
@end
