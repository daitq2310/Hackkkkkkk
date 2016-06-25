//
//  ViewController2.m
//  Final Project
//
//  Created by Hung Ga 123 on 6/20/16.
//  Copyright © 2016 HungVu. All rights reserved.
//

#import "CategoryViewController.h"
#import "ViewController.h"
@interface CategoryViewController ()
@end

@implementation CategoryViewController
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
        NSLog(@"%@ \n %@", topStoryName.url, topStoryName.title);
    }
    self.topStoryNameObjects = newTopStoryNames;
}
#pragma mark - Top story name
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
        NSLog(@"%@",topStoryImage.url);
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
    cell.lblLink.text = categoryOfThisCell.url;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
#pragma mark - didSelectRowAtIndexPath
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    //ListStoryViewController *listStoryVCL = [sb instantiateViewControllerWithIdentifier:@"ListStoryViewController"];
    ListStoryViewController *listStoryVCL = [sb instantiateViewControllerWithIdentifier:@"ListStoryViewController"];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    UINavigationController *navi = [sb instantiateViewControllerWithIdentifier:@"333"];
    [app initti:navi];
    ViewController *vcl = [sb instantiateViewControllerWithIdentifier:@"ViewController"];
    [navi pushViewController:listStoryVCL animated:YES];
   // [navi pushViewController:listStoryVCL animated:YES];
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
                 [listStoryVCL.tableView reloadData];
        });
    });
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self reachabilityCheck];
    
    
}

- (void) reachabilityCheck {
    self.tableView.tableFooterView = [[UIView alloc] init];
    Reachability* reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    reach.reachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"REACHABLE!");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *urlString = @"http://mangak.info/";
                NSString *categorysXpathQueryString = @"//table[@class='theloai']/tbody/tr/td";
                NSString *topStoryNameXpathQueryString = @"//div[@class='top_thang']/ul/li";
                NSString *topStoryImageXpathQueryString = @"//div[@class='top_thang']/ul/li";
                [self loadCategory:urlString categoryXpathQueryString:categorysXpathQueryString];
                [self loadCategory:urlString topStoryNameXpathQueryString:topStoryNameXpathQueryString];
                [self loadCategory:urlString topStoryImageXpathQueryString:topStoryImageXpathQueryString];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIView transitionWithView: self.tableView
                                      duration: 0.5f
                                       options: UIViewAnimationOptionTransitionCrossDissolve
                                    animations: ^(void)
                     {
                         [self.tableView reloadData];
                     }
                                    completion: nil];
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





@end
