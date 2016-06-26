//
//  ListChapViewController.m
//  Final Project
//
//  Created by Hung Ga 123 on 6/20/16.
//  Copyright © 2016 HungVu. All rights reserved.
//

#import "ListChapViewController.h"
#import "ConstantValues.h"
@interface ListChapViewController ()

@end

@implementation ListChapViewController
#pragma mark - Chapter Name
-(void) loadListChap:(NSString*)urlString chapterName:(NSString *)chapterNameXpathQueryString {
    NSMutableArray *newChapterNames = [[NSMutableArray alloc] init];
    NSArray *chapterNameNodes = [[APIClient sharedInstance] loadFromUrl:urlString
                                                   withXpathQueryString:chapterNameXpathQueryString];
    for (TFHppleElement *element in chapterNameNodes) {
        ChapterName *chapterName = [[ChapterName alloc] init];
        [newChapterNames addObject:chapterName];
        for (TFHppleElement *child in element.children) {
            if([[child.firstChild objectForKey:@"target"] isEqualToString:@"_blank"]) {
                chapterName.url = [child.firstChild objectForKey:@"href"];
                chapterName.title = child.firstChild.firstChild.content;
            }
        }
    }
    self.chapterNameObjects = newChapterNames;
}
#pragma mark - Date Update
-(void) loadListChap:(NSString*)urlString dateUpdate:(NSString *)dateUpdateXpathQueryString {
    NSMutableArray *newDateUpdates = [[NSMutableArray alloc] init];
    NSArray *dateUpdateNodes = [[APIClient sharedInstance] loadFromUrl:urlString
                                                  withXpathQueryString:dateUpdateXpathQueryString];
    for (TFHppleElement *element in dateUpdateNodes) {
        DateUpdate *dateUpdate = [[DateUpdate alloc] init];
        [newDateUpdates addObject:dateUpdate];
        for (TFHppleElement *child in element.children) {
            if(child.firstChild.content != nil) {
                dateUpdate.title = child.firstChild.content;
            }
        }
    }
    self.dateUpdateObjects = newDateUpdates;
}
#pragma mark - Summary Content
-(void) loadListChap:(NSString*)urlString summaryContent:(NSString *)summaryContentXpathQueryString {
    NSMutableArray *newSummaryContents = [[NSMutableArray alloc] init];
    NSArray *summaryContentNodes = [[APIClient sharedInstance] loadFromUrl:urlString
                                                      withXpathQueryString:summaryContentXpathQueryString];
    for (TFHppleElement *element in summaryContentNodes) {
        SummaryContent *summaryContent = [[SummaryContent alloc] init];
        [newSummaryContents addObject:summaryContent];
        summaryContent.textContent = @"";
        for(TFHppleElement *child in element.children) {
            if(child.content != nil) {
                summaryContent.textContent = [summaryContent.textContent stringByAppendingString:child.content];
            } else {
                if([child.tagName isEqualToString:@"p"] || [child.tagName isEqualToString:@"ul"] || [child.tagName isEqualToString:@"h2"]) {
                    for (TFHppleElement *subChild in child.children) {
                        if(subChild.content != nil) {
                            summaryContent.textContent = [summaryContent.textContent stringByAppendingString:subChild.content];
                        } else {
                            if([subChild.tagName isEqualToString:@"li"] || [subChild.tagName isEqualToString:@"a"] || [subChild.tagName isEqualToString:@"strong"]){
                                for (TFHppleElement *superSubChild in subChild.children) {
                                    if(superSubChild.content != nil) {
                                        summaryContent.textContent = [summaryContent.textContent stringByAppendingString:superSubChild.content];
                                    } else {
                                        if([superSubChild.tagName isEqualToString:@"a"]) {
                                            if(superSubChild.firstChild.content != nil) {
                                                summaryContent.textContent = [summaryContent.textContent stringByAppendingString:superSubChild.firstChild.content];
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    self.summaryContentObjects = newSummaryContents;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chapterNameObjects.count;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell3 *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell3" forIndexPath:indexPath];
    ChapterName *chapterNameOfThisCell = [self.chapterNameObjects objectAtIndex:indexPath.row];
    DateUpdate *dateUpdateOfThisCell = [self.dateUpdateObjects objectAtIndex:indexPath.row];
    cell.lblLink.text = chapterNameOfThisCell.url;
    cell.lblChapterName.text = chapterNameOfThisCell.title;
    cell.lblDateUpdate.text = dateUpdateOfThisCell.title;
    
    cell.lblChapterName.backgroundColor = [UIColor clearColor];
    cell.lblDateUpdate.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row % 2 == 0) {
        cell.contentView.backgroundColor = [UIColor colorWithRed:207.0f/255.0f green:216.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    } else {
        cell.contentView.backgroundColor = [UIColor colorWithRed:236.0f/255.0f green:239.0f/255.0f blue:241.0f/255.0f alpha:1.0f];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
#pragma mark - didSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailChapViewController *detailChapVCL = [[DetailChapViewController alloc] initWithNibName:@"DetailChapViewController" bundle:nil];
    [self presentViewController:detailChapVCL animated:YES completion:^{
    }];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ChapterName *chapterNameOfThisCell = [self.chapterNameObjects objectAtIndex:indexPath.row];
        NSString *urlString = chapterNameOfThisCell.url;
        NSString *imageXpathQueryString = @"//div[@class='vung_doc']/img";
        NSString *previewChapXpathQueryString = @"//a[@rel='nofollow']";
        NSString *chapReadingXpathQueryString = @"//h1[@class='name_chapter entry-title']";
        detailChapVCL.urlString = urlString;
        [detailChapVCL loadChapContent:urlString chapReading:chapReadingXpathQueryString];
        [detailChapVCL loadChapContent:urlString image:imageXpathQueryString];
        [detailChapVCL loadChapContent:urlString nextChap:previewChapXpathQueryString];
        [detailChapVCL loadChapContent:urlString previewChap:previewChapXpathQueryString];
        dispatch_async(dispatch_get_main_queue(), ^{
            [detailChapVCL viewDidLoad];
        });
    });
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigation];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:189.0f/255.0f green:189.0f/255.0f blue:189.0f/255.0f alpha:1.0f];
    self.tableView.tableFooterView = [[UIView alloc] init];
    _txtDescription.backgroundColor = [UIColor clearColor];
    if(self.summaryContentObjects.count > 0) {
        SummaryContent *summaryContent = [[SummaryContent alloc] init];
        summaryContent = [self.summaryContentObjects objectAtIndex:0];
//        self.lblSummaryContent.text = summaryContent.textContent;
        _txtDescription.text =summaryContent.textContent;
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Custom Navigation
- (void) customNavigation {
    //---------------------------------------------------------
    //set first title
    self.navigationItem.title = self.titleNavigation;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"ChalkboardSE-Bold" size:23], NSFontAttributeName, nil]];
    
    //---------------------------------------------------------
    //change style of StatusBar
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    //---------------------------------------------------------
    //Right button
    UIButton *btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:@"more"]  ;
    [btnMore setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [btnMore addTarget:self action:@selector(btnMoreTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    btnMore.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem *buttonMore = [[UIBarButtonItem alloc] initWithCustomView:btnMore] ;
    self.navigationItem.rightBarButtonItem = buttonMore;
    
    
}

- (void) btnMoreTouchUpInside : (id) sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _actionSheetVC = [storyboard instantiateViewControllerWithIdentifier:@"Action"];
    UIView* myView = _actionSheetVC.view;
    UIWindow* currentWindow = [UIApplication sharedApplication].keyWindow;
    [currentWindow addSubview:myView];
}





@end
