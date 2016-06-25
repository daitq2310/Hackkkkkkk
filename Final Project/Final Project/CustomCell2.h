//
//  CustomCell2.h
//  Final Project
//
//  Created by Hung Ga 123 on 6/20/16.
//  Copyright © 2016 HungVu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell2 : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTotalView;
@property (weak, nonatomic) IBOutlet UILabel *lblStoryName;
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentChap;
@property (weak, nonatomic) IBOutlet UILabel *lblLink;
@property (weak, nonatomic) IBOutlet UIImageView *coverImgView;
@property (weak, nonatomic) IBOutlet UILabel *lblCategorys;
@property NSIndexPath *indexPath;
@end
