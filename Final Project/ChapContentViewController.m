//
//  ChapContentViewController.m
//  Final Project
//
//  Created by Hung Ga 123 on 6/21/16.
//  Copyright © 2016 HungVu. All rights reserved.
//

#import "ChapContentViewController.h"
#import "DetailChapViewController.h"
@interface ChapContentViewController ()
@property NSInteger imageViewIndex;
@end
@implementation ChapContentViewController
#pragma mark - Click home button
- (IBAction)clickHomeBtn:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    SWRevealViewController *viewController = [sb instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:viewController animated:YES completion:^{
            }];
        });
    });
}
#pragma mark - Chap reading
-(void)loadChapContent:(NSString *)urlString chapReading:(NSString *)chapReadingXpathQueryString {
    NSMutableArray *newChapReadings = [[NSMutableArray alloc] init];
    NSArray *chapReadingNodes = [[APIClient sharedInstance] loadFromUrl:urlString
                                                   withXpathQueryString:chapReadingXpathQueryString];
    for (TFHppleElement *element in chapReadingNodes) {
        ChapReading *chapReading = [[ChapReading alloc] init];
        [newChapReadings addObject:chapReading];
        chapReading.title = element.firstChild.content;
        NSLog(@"%@",chapReading.title);
    }
    self.chapReadingObjects = newChapReadings;
}
#pragma mark - Image
-(void) loadChapContent:(NSString*)urlString image:(NSString *)imageXpathQueryString {
    NSMutableArray *newImages = [[NSMutableArray alloc] init];
    NSArray *chapterNameNodes = [[APIClient sharedInstance] loadFromUrl:urlString
                                                   withXpathQueryString:imageXpathQueryString];
    for (TFHppleElement *element in chapterNameNodes) {
        Image *image = [[Image alloc] init];
        [newImages addObject:image];
        image.url = [element objectForKey:@"src"];
    }
    self.imageObjects = newImages;
}

#pragma mark - Page Curl
- (void) pageCurlForMangaPage {


    if(self.imageViewIndex <= self.imageObjects.count-1) {
    

        NSDictionary *option = [NSDictionary dictionaryWithObject:[NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin] forKey:UIPageViewControllerOptionSpineLocationKey];
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle: UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:option];
        [_pageViewController setDataSource:self];
        DetailChapViewController *initialVC = [self viewControllerAtIndex:0];
        NSArray *viewControllers  = [NSArray arrayWithObject:initialVC];
            
            [_pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        [_pageViewController.view setFrame:self.view.bounds];
        [self addChildViewController:_pageViewController];
        [self.view addSubview:_pageViewController.view];
        [_pageViewController didMoveToParentViewController:self];
    
    
    }
}

- (DetailChapViewController *) viewControllerAtIndex : (NSUInteger) index {
    if (index > _imageObjects.count - 1) {
        return nil;
    }
    DetailChapViewController *cVC = [[DetailChapViewController alloc] init];
    [cVC setDataImageName:[_imageObjects objectAtIndex:index]];
        return cVC;
}

- (NSUInteger) indexOfVC : (DetailChapViewController*) viewController {
    return [_imageObjects indexOfObject:viewController.dataImageName];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfVC:(DetailChapViewController *) viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexOfVC:(ChapContentViewController *) viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    return [self viewControllerAtIndex:index];
}

#pragma mark - Click next
- (IBAction)clickNextBtn:(id)sender {
    NSLog(@"%ld", [_imageObjects count]);
#pragma mark - next ImageView
    self.imageViewIndex ++;
    if(self.imageViewIndex <= self.imageObjects.count-1) {
        Image *image = [[Image alloc] init];
        image = [self.imageObjects objectAtIndex:self.imageViewIndex];
        [self.imageView setImageWithURL:[NSURL URLWithString:image.url] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    } else self.imageViewIndex = self.imageObjects.count - 1;
#pragma mark - next Chap
//    if(self.nextChapObjects.count > 0) {
//        NextChap *nextChap = [[NextChap alloc] init];
//        nextChap = [self.nextChapObjects objectAtIndex:0];
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//        ChapContentViewController *chapContentVCL = [sb instantiateViewControllerWithIdentifier:@"ChapContentViewController"];
//        [self presentViewController:chapContentVCL animated:YES completion:^{
//        }];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            NSString *urlString = nextChap.url;
//            NSString *chapReadingXpathQueryString = @"//h1[@class='name_chapter entry-title']";
//            NSString *imageXpathQueryString = @"//div[@class='vung_doc']/img";
//            NSString *previewChapXpathQueryString = @"//a[@rel='nofollow']";
//            chapContentVCL.urlString = urlString;
//            [chapContentVCL loadChapContent:urlString image:imageXpathQueryString];
//            [chapContentVCL loadChapContent:urlString nextChap:previewChapXpathQueryString];
//            [chapContentVCL loadChapContent:urlString previewChap:previewChapXpathQueryString];
//            [chapContentVCL loadChapContent:urlString chapReading:chapReadingXpathQueryString];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [chapContentVCL viewDidLoad];
//            });
//        });
//    }
}
#pragma mark - Click preview
- (IBAction)clickPreviewBtn:(id)sender {
#pragma mark - preview ImageView
//    self.imageViewIndex --;
//    if(self.imageViewIndex >= 0) {
//        Image *image = [[Image alloc] init];
//        image = [self.imageObjects objectAtIndex:self.imageViewIndex];
//        [self.imageView setImageWithURL:[NSURL URLWithString:image.url] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    } else self.imageViewIndex = 0;
#pragma mark - preview Chap
    if(self.previewChapObjects.count > 0) {
        PreviewChap *previewChap = [[PreviewChap alloc] init];
        previewChap = [self.previewChapObjects objectAtIndex:0];
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ChapContentViewController *chapContentVCL = [sb instantiateViewControllerWithIdentifier:@"ChapContentViewController"];
        [self presentViewController:chapContentVCL animated:YES completion:^{
        }];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *urlString = previewChap.url;
            NSString *chapReadingXpathQueryString = @"//h1[@class='name_chapter entry-title']";
            NSString *imageXpathQueryString = @"//div[@class='vung_doc']/img";
            NSString *previewChapXpathQueryString = @"//a[@rel='nofollow']";
            chapContentVCL.urlString = urlString;
            [chapContentVCL loadChapContent:urlString image:imageXpathQueryString];
            [chapContentVCL loadChapContent:urlString nextChap:previewChapXpathQueryString];
            [chapContentVCL loadChapContent:urlString previewChap:previewChapXpathQueryString];
            [chapContentVCL loadChapContent:urlString chapReading:chapReadingXpathQueryString];
            dispatch_async(dispatch_get_main_queue(), ^{
                [chapContentVCL viewDidLoad];
            });
        });
    }
}
#pragma mark - Preview chap
-(void) loadChapContent:(NSString *)urlString previewChap:(NSString *)previewChapXpathQueryString {
    NSMutableArray *newPreviewChaps = [[NSMutableArray alloc] init];
    NSArray *previewChapNodes = [[APIClient sharedInstance] loadFromUrl:urlString
                                               withXpathQueryString:previewChapXpathQueryString];
    for (TFHppleElement *element in previewChapNodes) {
        if([element.firstChild.content isEqualToString:@"Chap trước"]) {
            PreviewChap *previewChap = [[PreviewChap alloc] init];
            [newPreviewChaps addObject:previewChap];
            previewChap.url = [element objectForKey:@"href"];
        }
    }
    self.previewChapObjects = newPreviewChaps;
}
#pragma mark - Next chap
-(void) loadChapContent:(NSString*)urlString nextChap:(NSString*)nextChapXpathQueryString {
    NSMutableArray *newNextChaps = [[NSMutableArray alloc] init];
    NSArray *nextChapNodes = [[APIClient sharedInstance] loadFromUrl:urlString
                                            withXpathQueryString:nextChapXpathQueryString];
    for (TFHppleElement *element in nextChapNodes) {
        if([element.firstChild.content isEqualToString:@"Chap tiếp theo"]) {
            NextChap *nextChap = [[NextChap alloc] init];
            [newNextChaps addObject:nextChap];
            nextChap.url = [element objectForKey:@"href"];
        }
    }
    self.nextChapObjects = newNextChaps;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageViewIndex = 0;
    if(self.imageObjects.count > 0) {
    Image *image = [[Image alloc] init];
    image = [self.imageObjects objectAtIndex:self.imageViewIndex];
    [self.imageView setImageWithURL:[NSURL URLWithString:image.url] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self pageCurlForMangaPage];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
