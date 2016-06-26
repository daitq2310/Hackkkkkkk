//
//  ViewController3.m
//  Final Project
//
//  Created by Hung Ga 123 on 6/20/16.
//  Copyright © 2016 HungVu. All rights reserved.
//

#import "ListStoryViewController.h"
@interface ListStoryViewController ()

@end

@implementation ListStoryViewController
#pragma mark - Story name
-(void) loadListStorys:(NSString*)urlString storyName:(NSString*)storyNameXpathQueryString {
    
    NSMutableArray *newStoryNames = [[NSMutableArray alloc] init];
    NSArray *storyNameNodes = [[APIClient sharedInstance] loadFromUrl:urlString
                                                 withXpathQueryString:storyNameXpathQueryString];
    for (TFHppleElement *element in storyNameNodes) {
        StoryName *storyName = [[StoryName alloc] init];
        storyName.title = [element.firstChild content];
        storyName.url = [element objectForKey:@"href"];
        [newStoryNames addObject:storyName];
    }
    self.storyNameObjects = newStoryNames;
}
#pragma mark - Total view
-(void) loadListStorys:(NSString*)urlString totalView:(NSString*)totalViewXpathQueryString {
    NSMutableArray *newTotalViews = [[NSMutableArray alloc] init];
    NSArray *totalViewNodes = [[APIClient sharedInstance] loadFromUrl:urlString
                                                 withXpathQueryString:totalViewXpathQueryString];
    for (TFHppleElement *element in totalViewNodes) {
        TotalView *totalView = [[TotalView alloc] init];
        [newTotalViews addObject:totalView];
        totalView.title = [element.firstChild content];
    }
    self.totalViewObjects = newTotalViews;
}
#pragma mark - Cover image
-(void) loadListStorys:(NSString*)urlString cover:(NSString*)coverXpathQueryString {
    NSMutableArray *newCovers = [[NSMutableArray alloc] init];
    NSArray *coverNodes = [[APIClient sharedInstance] loadFromUrl:urlString
                                             withXpathQueryString:coverXpathQueryString];
    for (TFHppleElement *element in coverNodes) {
        if([[element objectForKey:@"rel"] isEqualToString:@"nofollow"]) {
            Cover *cover = [[Cover alloc] init];
            [newCovers addObject:cover];
            cover.url = [element.firstChild objectForKey:@"src"];
        }
    }
    self.coverObjects = newCovers;
}
#pragma mark - CurrentChap
-(void) loadListStorys:(NSString*)urlString currentChap:(NSString*)currentChapXpathQueryString {
    NSMutableArray *newCurrentChaps = [[NSMutableArray alloc] init];
    NSArray *currentChapNodes = [[APIClient sharedInstance] loadFromUrl:urlString
                                                   withXpathQueryString:currentChapXpathQueryString];
    for (TFHppleElement *element in currentChapNodes) {
        if([[element objectForKey:@"class"] isEqualToString:@"chapter"]) {
            CurrentChap *currentChap = [[CurrentChap alloc] init];
            [newCurrentChaps addObject:currentChap];
            currentChap.title = [element.firstChild content];
        }
    }
    self.currentChapObjects = newCurrentChaps;
}
#pragma mark - Categorys
-(void) loadListStorys:(NSString*)urlString categorys:(NSString*)categorysXpathQueryString {
    NSMutableArray *newCategoryss = [[NSMutableArray alloc] init];
    NSArray *categorysNodes = [[APIClient sharedInstance] loadFromUrl:urlString
                                                 withXpathQueryString:categorysXpathQueryString];
    for (TFHppleElement *element in categorysNodes) {
        Categorys *categorys = [[Categorys alloc] init];
        [newCategoryss addObject:categorys];
        categorys.title = @"";
        for(TFHppleElement *child in element.children) {
            if(child.firstChild.content != nil) {
                categorys.title = [categorys.title stringByAppendingString:[NSString stringWithFormat:@"%@ ",child.firstChild.content]];
            }
        }
    }
    self.categorysObjects = newCategoryss;
}
#pragma mark - Current page
-(void) loadListStorys:(NSString*)urlString currentPage:(NSString*)currentPageXpathQueryString {
    NSMutableArray *newCurrentPages = [[NSMutableArray alloc] init];
    NSArray *currentPageNodes = [[APIClient sharedInstance] loadFromUrl:urlString
                                                   withXpathQueryString:currentPageXpathQueryString];
    for (TFHppleElement *element in currentPageNodes) {
        CurrentPage *currentPage = [[CurrentPage alloc] init];
        [newCurrentPages addObject:currentPage];
        currentPage.title = [element.firstChild content];
        NSLog(@"%@",currentPage.title);
    }
    self.currentPageObjects = newCurrentPages;
}
#pragma mark - Preview page
-(void) loadListStorys:(NSString*)urlString previewPage:(NSString*)previewPageXpathQueryString {
    NSMutableArray *newPreviewPages = [[NSMutableArray alloc] init];
    NSArray *previewPageNodes = [[APIClient sharedInstance] loadFromUrl:urlString
                                                   withXpathQueryString:previewPageXpathQueryString];
    for (TFHppleElement *element in previewPageNodes) {
        PreviewPage *previewPage = [[PreviewPage alloc] init];
        [newPreviewPages addObject:previewPage];
        previewPage.url = [element objectForKey:@"href"];
    }
    self.previewPageObjects = newPreviewPages;
}
#pragma mark - Next page
-(void) loadListStorys:(NSString*)urlString nextPage:(NSString*)nextPageXpathQueryString {
    NSMutableArray *newNextPages = [[NSMutableArray alloc] init];
    NSArray *nextPageNodes = [[APIClient sharedInstance] loadFromUrl:urlString
                                                withXpathQueryString:nextPageXpathQueryString];
    for (TFHppleElement *element in nextPageNodes) {
        NextPage *nextPage = [[NextPage alloc] init];
        [newNextPages addObject:nextPage];
        nextPage.url = [element objectForKey:@"href"];
    }
    self.nextPageObjects = newNextPages;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.storyNameObjects.count;
}
#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell2 *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.coverImgView.image = nil;
    StoryName  *storyNameOfThisCell = [self.storyNameObjects objectAtIndex:indexPath.row];
    TotalView *totalViewOfThisCell = [self.totalViewObjects objectAtIndex:indexPath.row];
    Cover *coverOfThisCell = [self.coverObjects objectAtIndex:indexPath.row];
    CurrentChap *currentChapOfThisCell = [self.currentChapObjects objectAtIndex:indexPath.row];
    Categorys *categorysOfThisCell = [self.categorysObjects objectAtIndex:indexPath.row];
    [cell.coverImgView setImageWithURL:[NSURL URLWithString:coverOfThisCell.url] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIImage *img = cell.coverImgView.image;
    if(cell.indexPath.row == indexPath.row) {
        cell.coverImgView.image = img;
        cell.lblStoryName.text = storyNameOfThisCell.title;
        cell.lblTotalView.text = totalViewOfThisCell.title;
        cell.lblCurrentChap.text = currentChapOfThisCell.title;
        cell.lblLink.text = storyNameOfThisCell.url;
        cell.lblCategorys.text = categorysOfThisCell.title;
    }
    return cell;
}
#pragma mark - didSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ListChapViewController *listChapVCL = [sb instantiateViewControllerWithIdentifier:@"ListChapViewController"];
    [self presentViewController:listChapVCL animated:YES completion:^{
    }];
    
    ///
    
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    reach.reachableBlock = ^(Reachability*reach)
    {
        NSLog(@"REACHABLE!");
        dispatch_async(dispatch_get_main_queue(), ^{
            // Merse di nhe !!!! Day nay
            Cover *coverOfThisCell = [self.coverObjects objectAtIndex:indexPath.row];
            [listChapVCL.imvManga setImageWithURL:[NSURL URLWithString:coverOfThisCell.url] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            ///
            MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:listChapVCL.view animated:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                StoryName  *storyNameOfThisCell = [self.storyNameObjects objectAtIndex:indexPath.row];
                NSString *urlString = storyNameOfThisCell.url;
                NSString *summaryContentXpathQueryString = @"//div[@class='entry-content']";
                NSString *chapterNameXpathQueryString = @"//div[@class='row']";
                listChapVCL.urlString = urlString;
                [listChapVCL loadListChap:urlString chapterName:chapterNameXpathQueryString];
                [listChapVCL loadListChap:urlString dateUpdate:chapterNameXpathQueryString];
                [listChapVCL loadListChap:urlString summaryContent:summaryContentXpathQueryString];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hide:YES];
                    [listChapVCL.tableView reloadData];
                    [listChapVCL viewDidLoad];
                    
                });
            });
        });
    };
    reach.unreachableBlock = ^(Reachability*reach){
        NSLog(@"UNREACHABLE!");
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"FBI Warning"
                                     message:@"Please checking for your network !"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Yes"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"No, thanks"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                   }];
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    };
    listChapVCL.imvMangaString = [self.coverObjects objectAtIndex:indexPath.row];
    [reach startNotifier];
}
#pragma mark - Click Preview page
- (IBAction)clickPreviewPage:(id)sender {
    if(self.previewPageObjects.count > 0) {
        PreviewPage *previewPage = [[PreviewPage alloc] init];
        previewPage = [self.previewPageObjects objectAtIndex:0];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ListStoryViewController *listStoryVCL = [sb instantiateViewControllerWithIdentifier:@"ListStoryViewController"];
        [self presentViewController:listStoryVCL animated:YES completion:^{
        }];
        
        Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
        reach.reachableBlock = ^(Reachability*reach)
        {
            NSLog(@"REACHABLE!");
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:listStoryVCL.view animated:YES];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString *urlString = previewPage.url;
                    NSString *storyNameXpathQueryString = @"//h3[@class='nowrap']/a";
                    NSString *totalViewXpathQueryString = @"//div[@class='wrap_update tab_anh_dep danh_sach']/div/span";
                    NSString *coverXpathQueryString = @"//div[@class='wrap_update tab_anh_dep danh_sach']/div/a";
                    NSString *currentChapXpathQueryString = @"//div[@class='wrap_update tab_anh_dep danh_sach']/div/a";
                    NSString *categorysXpathQueryString = @"//div[@class='item2_theloai']";
                    NSString *currentPageXpathQueryString = @"//span[@class='current']";
                    NSString *previewPageXpathQueryString = @"//a[@class='previouspostslink']";
                    NSString *nextPageXpathQueryString = @"//a[@class='nextpostslink']";
                    listStoryVCL.urlString = urlString;
                    [listStoryVCL loadListStorys:(NSString*)urlString storyName:(NSString*)storyNameXpathQueryString];
                    [listStoryVCL loadListStorys:(NSString*)urlString currentChap:(NSString*)currentChapXpathQueryString];
                    [listStoryVCL loadListStorys:(NSString*)urlString categorys:(NSString*)categorysXpathQueryString];
                    [listStoryVCL loadListStorys:(NSString*)urlString cover:(NSString*)coverXpathQueryString];
                    [listStoryVCL loadListStorys:(NSString*)urlString currentPage:(NSString*)currentPageXpathQueryString];
                    [listStoryVCL loadListStorys:(NSString*)urlString previewPage:(NSString*)previewPageXpathQueryString];
                    [listStoryVCL loadListStorys:(NSString*)urlString nextPage:(NSString*)nextPageXpathQueryString];
                    [listStoryVCL loadListStorys:(NSString*)urlString totalView:(NSString*)totalViewXpathQueryString];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hide:YES];
                        [listStoryVCL.tableView reloadData];
                    });
                });
            });
        };
        reach.unreachableBlock = ^(Reachability*reach)
        {
            NSLog(@"UNREACHABLE!");
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"FBI Warning"
                                         message:@"Please checking for your network !"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Yes"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                        }];
            
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"No, thanks"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                       }];
            [alert addAction:yesButton];
            [alert addAction:noButton];
            
            [self presentViewController:alert animated:YES completion:nil];
        };
        [reach startNotifier];
    }
}
#pragma mark - Click Next page
- (IBAction)clickNextPage:(id)sender {
    if(self.nextPageObjects.count > 0) {
        NextPage *nextPage = [[NextPage alloc] init];
        nextPage = [self.nextPageObjects objectAtIndex:0];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ListStoryViewController *listStoryVCL = [sb instantiateViewControllerWithIdentifier:@"ListStoryViewController"];
        [self presentViewController:listStoryVCL animated:YES completion:^{
        }];
        Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
        reach.reachableBlock = ^(Reachability*reach)
        {
            NSLog(@"REACHABLE!");
            dispatch_async(dispatch_get_main_queue(), ^{
                MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:listStoryVCL.view animated:YES];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString *urlString = nextPage.url;
                    NSString *storyNameXpathQueryString = @"//h3[@class='nowrap']/a";
                    NSString *totalViewXpathQueryString = @"//div[@class='wrap_update tab_anh_dep danh_sach']/div/span";
                    NSString *coverXpathQueryString = @"//div[@class='wrap_update tab_anh_dep danh_sach']/div/a";
                    NSString *currentChapXpathQueryString = @"//div[@class='wrap_update tab_anh_dep danh_sach']/div/a";
                    NSString *categorysXpathQueryString = @"//div[@class='item2_theloai']";
                    NSString *currentPageXpathQueryString = @"//span[@class='current']";
                    NSString *previewPageXpathQueryString = @"//a[@class='previouspostslink']";
                    NSString *nextPageXpathQueryString = @"//a[@class='nextpostslink']";
                    listStoryVCL.urlString = urlString;
                    [listStoryVCL loadListStorys:(NSString*)urlString storyName:(NSString*)storyNameXpathQueryString];
                    [listStoryVCL loadListStorys:(NSString*)urlString currentChap:(NSString*)currentChapXpathQueryString];
                    [listStoryVCL loadListStorys:(NSString*)urlString categorys:(NSString*)categorysXpathQueryString];
                    [listStoryVCL loadListStorys:(NSString*)urlString cover:(NSString*)coverXpathQueryString];
                    [listStoryVCL loadListStorys:(NSString*)urlString currentPage:(NSString*)currentPageXpathQueryString];
                    [listStoryVCL loadListStorys:(NSString*)urlString previewPage:(NSString*)previewPageXpathQueryString];
                    [listStoryVCL loadListStorys:(NSString*)urlString nextPage:(NSString*)nextPageXpathQueryString];
                    [listStoryVCL loadListStorys:(NSString*)urlString totalView:(NSString*)totalViewXpathQueryString];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hide:YES];
                        [listStoryVCL.tableView reloadData];
                    });
                });
            });
        };
        reach.unreachableBlock = ^(Reachability*reach)
        {
            NSLog(@"UNREACHABLE!");
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"FBI Warning"
                                         message:@"Please checking for your network !"
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"Yes"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                        }];
            
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:@"No, thanks"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                       }];
            [alert addAction:yesButton];
            [alert addAction:noButton];
            
            [self presentViewController:alert animated:YES completion:nil];
        };
        [reach startNotifier];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [[UIView alloc] init];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
@end
