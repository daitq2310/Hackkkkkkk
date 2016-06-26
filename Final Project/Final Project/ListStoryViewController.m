//
//  ViewController3.m
//  Final Project
//
//  Created by Hung Ga 123 on 6/20/16.
//  Copyright © 2016 HungVu. All rights reserved.
//

#import "ListStoryViewController.h"
#import "ConstantValues.h"
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
    cell.coverImgView.layer.cornerRadius = 10.0f;
    cell.coverImgView.layer.masksToBounds = YES;
    cell.coverImgView.layer.borderColor = [UIColor blackColor].CGColor;
    cell.coverImgView.layer.borderWidth = 3.0f;
    cell.coverImgView.backgroundColor = [UIColor clearColor];
    cell.lblTotalView.backgroundColor = [UIColor clearColor];
    cell.lblCurrentChap.backgroundColor = [UIColor clearColor];
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
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ListChapViewController *listChapVCL = [sb instantiateViewControllerWithIdentifier:@"ListChapViewController"];
    
    [self.navigationController pushViewController:listChapVCL animated:YES];
    ///
    
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    reach.reachableBlock = ^(Reachability*reach)
    {
        NSLog(@"REACHABLE!");
        dispatch_async(dispatch_get_main_queue(), ^{
            // Merse di nhe !!!! Day nay
            Cover *coverOfThisCell = [self.coverObjects objectAtIndex:indexPath.row];
            [listChapVCL.imvManga setImageWithURL:[NSURL URLWithString:coverOfThisCell.url] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            listChapVCL.imvManga .layer.cornerRadius = 10.0f;
            listChapVCL.imvManga .layer.masksToBounds = YES;
            
            listChapVCL.imvManga .layer.borderColor = [UIColor blackColor].CGColor;
            listChapVCL.imvManga .layer.borderWidth = 3.0f;

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
        [self.navigationController pushViewController:listStoryVCL animated:YES];
         [self customNavigation];
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
                    [self postionNextAndBack];
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
    [self customNavigation];
    
    if(self.nextPageObjects.count > 0) {
        NextPage *nextPage = [[NextPage alloc] init];
        nextPage = [self.nextPageObjects objectAtIndex:0];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ListStoryViewController *listStoryVCL = [sb instantiateViewControllerWithIdentifier:@"ListStoryViewController"];
        [self.navigationController pushViewController:listStoryVCL animated:YES];
     
         [self customNavigation];
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
    self.view.backgroundColor = [UIColor colorWithRed:189.0f/255.0f green:189.0f/255.0f blue:189.0f/255.0f alpha:1.0f];
    [self customNavigation];
    _tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self postionNextAndBack];
    
}


#define nextPosX self.view.frame.size.width - 60
#define nextPosY self.navigationController.navigationBar.frame.size.height + 20
#define nextWidth 60
#define nextHeight 60
#define backPosX self.view.frame.size.width - 120
#define backPosY self.navigationController.navigationBar.frame.size.height + 20
#define backWidth 60
#define backHeight 60
- (void) postionNextAndBack {
    _btnNext.translatesAutoresizingMaskIntoConstraints = YES;
    _btnPre.translatesAutoresizingMaskIntoConstraints = YES;
    _btnNext.frame = CGRectMake(nextPosX, nextPosY, nextWidth, nextHeight);
    _btnPre.frame = CGRectMake(backPosX, backPosY, backWidth, backHeight);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}


#pragma mark - Custom Navigation
- (void) customNavigation {
    //---------------------------------------------------------
    //set color for navigation bar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.f/255.0f green:10.f/255.0f blue:0.f/255.0f alpha:1.0f];
    
    //---------------------------------------------------------
    //set title for back button
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //---------------------------------------------------------
    //set first title
    self.navigationItem.title = @"Cho Title vao day nhe";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"ChalkboardSE-Bold" size:23], NSFontAttributeName, nil]];
    
    //---------------------------------------------------------
    //change style of StatusBar
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    //---------------------------------------------------------
    //change back button icon
    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:BUTTON_BACK];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:BUTTON_BACK];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    //---------------------------------------------------------
    //change back button icon
    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"back"];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"back"];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
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
