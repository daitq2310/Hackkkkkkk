//
//  ViewController.m
//  Final Project
//
//  Created by Hung Ga 123 on 6/14/16.
//  Copyright © 2016 HungVu. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"
@interface ViewController ()


@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self customNavigation];
    [self SWRevealViewControllerInit];
    [self topPageIndicator];
    [self leftType];
        Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    reach.reachableBlock = ^(Reachability*reach)
    {
        NSLog(@"REACHABLE!");
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *urlString = @"http://mangak.info/";
                NSString *categorysXpathQueryString = @"//table[@class='theloai']/tbody/tr/td";
                NSString *topStoryNameXpathQueryString = @"//div[@class='top_thang']/ul/li";
                NSString *topStoryImageXpathQueryString = @"//div[@class='top_thang']/ul/li";
                [self loadCategory:urlString categoryXpathQueryString:categorysXpathQueryString];
                [self loadCategory:urlString topStoryNameXpathQueryString:topStoryNameXpathQueryString];
                [self loadCategory:urlString topStoryImageXpathQueryString:topStoryImageXpathQueryString];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
           
                    [self.tableView reloadData];
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



#pragma mark - Top story name
-(void) loadCategory:(NSString*)urlString topStoryNameXpathQueryString:(NSString*)topStoryNameXpathQueryString {
    NSMutableArray *newTopStoryNames = [[NSMutableArray alloc] init];
    NSArray *topStoryNameNodes = [[APIClient sharedInstance] loadFromUrl:urlString
                                                    withXpathQueryString:topStoryNameXpathQueryString];
    for (TFHppleElement *element in topStoryNameNodes) {
        TopStoryName *topStoryName = [[TopStoryName alloc] init];
        [newTopStoryNames addObject:topStoryName];
        for (TFHppleElement *child in element.children) {
            if ([[child objectForKey:@"rel"] isEqualToString:@"nofollow"]) {
                topStoryName.url = [child objectForKey:@"href"];
                topStoryName.title = [child.firstChild objectForKey:@"alt"];
            }
        }
    }
    self.topStoryNameObjects = newTopStoryNames;
}



-(void) loadCategory:(NSString*)urlString topStoryImageXpathQueryString:(NSString*)topStoryImageXpathQueryString {
    NSMutableArray *newTopStoryImages = [[NSMutableArray alloc] init];
    NSArray *topStoryImageNodes = [[APIClient sharedInstance] loadFromUrl:urlString
                                                     withXpathQueryString:topStoryImageXpathQueryString];
    for (TFHppleElement *element in topStoryImageNodes) {
        TopStoryImage *topStoryImage = [[TopStoryImage alloc] init];
        [newTopStoryImages addObject:topStoryImage];
        for (TFHppleElement *child in element.children) {
            if ([[child objectForKey:@"rel"] isEqualToString:@"nofollow"]) {
                topStoryImage.url = [child.firstChild objectForKey:@"src"];
            }
        }
    }
    self.topStoryImageObjects = newTopStoryImages;
}




#pragma mark - Category list
-(void) loadCategory:(NSString*)urlString categoryXpathQueryString:(NSString*)categorysXpathQueryString {
    NSMutableArray *newCategorys = [[NSMutableArray alloc] init];
    NSArray *categoryNodes = [[APIClient sharedInstance] loadFromUrl:urlString
                                                withXpathQueryString:categorysXpathQueryString];
    for (TFHppleElement *element in categoryNodes) {
        for (TFHppleElement *child in element.children) {
            if ([child.tagName isEqualToString:@"a"]) {
                xCategory *category = [[xCategory alloc] init];
                [newCategorys addObject:category];
                category.url = [child objectForKey:@"href"];
                category.title = [child.firstChild content];
                for(TFHppleElement *subChild in child.children) {
                    if([subChild.tagName isEqualToString:@"strong"]) {
                        category.title = [subChild.firstChild content];
                    }
                }
            }
        }
    }
    self.categoryObjects = newCategorys;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.categoryObjects.count;
}




#pragma mark - cellForRowAtIndexPath
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    xCategory  *categoryOfThisCell = [self.categoryObjects objectAtIndex:indexPath.row];
    cell.lblTitle.text = categoryOfThisCell.title;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}




#pragma mark - didSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ListStoryViewController *listStoryVCL = [sb instantiateViewControllerWithIdentifier:@"ListStoryViewController"];
    [self.navigationController pushViewController:listStoryVCL animated:YES];
    
    
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    reach.reachableBlock = ^(Reachability*reach)
    {
        NSLog(@"REACHABLE!");
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showHUDAddedTo:listStoryVCL.view animated:YES];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                xCategory  *categoryOfThisCell = [self.categoryObjects objectAtIndex:indexPath.row];
                NSString *urlString = categoryOfThisCell.url;
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
                    [MBProgressHUD hideHUDForView:listStoryVCL.view animated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) SWRevealViewControllerInit {
    SWRevealViewController *revealViewController = self.revealViewController;
    if (revealViewController != nil)
    {
        [self.barBtnItem setTarget: self.revealViewController];
        [self.barBtnItem setAction: @selector(revealToggle:)];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    revealViewController.rearViewRevealWidth = 320;
}



#define TABLE_POSITION_X self.view.frame.size.width - 150
#define TABLE_POSITION_Y self.navigationController.navigationBar.frame.size.height-40+self.pageViewController.view.frame.size.height
#define TABLE_WIDTH 150
#define TABLE_HEIGHT self.view.frame.size.height-self.navigationController.navigationBar.frame.size.height+40-self.pageViewController.view.frame.size.height
#pragma mark - Type
- (void) leftType {
    _tableView.translatesAutoresizingMaskIntoConstraints = YES;
    _tableView.frame = CGRectMake(TABLE_POSITION_X, TABLE_POSITION_Y, TABLE_WIDTH, TABLE_HEIGHT);
}


#pragma mark - Page indicator
- (void) topPageIndicator {
    UIPageControl *pp = [UIPageControl appearance];
    pp.pageIndicatorTintColor = [UIColor lightGrayColor];
    pp.currentPageIndicatorTintColor = [UIColor
                                        blackColor];
    pp.backgroundColor = [UIColor whiteColor];
    _pageImages = @[PAGE_INDICATOR_IMG_01, PAGE_INDICATOR_IMG_02, PAGE_INDICATOR_IMG_03, PAGE_INDICATOR_IMG_04, PAGE_INDICATOR_IMG_05, PAGE_INDICATOR_IMG_06, PAGE_INDICATOR_IMG_07, PAGE_INDICATOR_IMG_08, PAGE_INDICATOR_IMG_09, PAGE_INDICATOR_IMG_10];
    
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:PAGE_VIEW_CONTROLLER_ID];
    self.pageViewController.dataSource = self;
    
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    pp.backgroundColor = [UIColor yellowColor];
    self.pageViewController.view.frame = CGRectMake(0,self.navigationController.navigationBar.frame.size.height+20,self.navigationController.navigationBar.frame.size.width, 150);
    
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
}
#pragma mark = Page View Controller Data Source
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    
    NSInteger index = ((PageContentViewController*) viewController).pageIndex;
    if((index ==0) || (index==NSNotFound)){
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}


-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index = ((PageContentViewController*) viewController).pageIndex;
    if(index==NSNotFound){
        return nil;
    }
    
    
    index++;
    if(index==[_pageImages count]){
        return [self viewControllerAtIndex:0];
    }
    return [self viewControllerAtIndex:index];
}
-(PageContentViewController *)viewControllerAtIndex:(NSUInteger)index{
    if (([_pageImages count] == 0) || (index >=[_pageImages count])) {
        return nil;
    }
    PageContentViewController *pageContentViewController = [[PageContentViewController alloc] initWithNibName:PAGE_CONTENT_VIEW_CONTROLLER_ID bundle:nil];
    pageContentViewController.imageFile = self.pageImages[index];
    
    pageContentViewController.pageIndex = index;
    return pageContentViewController;
}
-(NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController{
    return [_pageImages count];
}
-(NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController{
    return 0;
}
- (IBAction)startWalthrough:(id)sender {
    PageContentViewController *start = [self viewControllerAtIndex:0];
    NSArray *view = @[start];
    [self.pageViewController setViewControllers:view direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
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
    self.navigationItem.title = APP_NAME_HEADER;
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"ChalkboardSE-Bold" size:23], NSFontAttributeName, nil]];
    
    //---------------------------------------------------------
    //change style of StatusBar
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    //---------------------------------------------------------
    //Right button
    UIButton *btnMore = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backBtnImage = [UIImage imageNamed:BUTTON_MORE];
    [btnMore setBackgroundImage:backBtnImage forState:UIControlStateNormal];
    [btnMore addTarget:self action:@selector(btnMoreTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    btnMore.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem *buttonMore = [[UIBarButtonItem alloc] initWithCustomView:btnMore] ;
    self.navigationItem.rightBarButtonItem = buttonMore;
    //---------------------------------------------------------
    //change back button icon
    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:BUTTON_BACK];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:BUTTON_BACK];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

- (void) btnMoreTouchUpInside : (id) sender {
    
}

@end
