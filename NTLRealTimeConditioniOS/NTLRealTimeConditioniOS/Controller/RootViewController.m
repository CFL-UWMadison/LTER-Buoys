//
//  RootViewController.m
//  app for limnology Version 0
//  Refacting the code. I'm thinking of enhancing the role of the root view controller. To let it
//  respond to the change of the user setting and network environment.
//  This root view controller will talk to db to do things. and assign db to the model controller.
//  Basically, it's the highest level for the weatherDB
//
//  Created by Junjie on 15/12/8.
//  Copyright © 2015年 Junjie. All rights reserved.
//

#import "RootViewController.h"
#import "WeatherModelController.h"
#import "JJWeatherViewController.h"
#import "Weather.h"
#import "UpdateModel.h"
#import "UpdateInfoViewController.h"

@interface RootViewController ()

@property (readonly, strong, nonatomic) WeatherModelController *modelController;
@property (nonatomic) UIAlertController* ac;
@property (nonatomic, strong) UpdateModel* um;
@property (nonatomic) BOOL firstLaunch;
@property (nonatomic) BOOL justUpdated;
@property (nonatomic, strong) WeatherInfoDB* weatherInfoDB;
@property (nonatomic) BOOL isConnectedToNetwork;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNetworkStatusNotification];
    // initialize settings
    UserSetting* us = [UserSetting sharedSetting];
    self.firstLaunch = us.isFirstOpen;
    self.justUpdated = us.justUpdated;

    // Set Up database
    self.weatherInfoDB = [WeatherInfoDB sharedDB];
    
    // I need to take care of the app relaunch
    //[self.weatherInfoDB setAppRelaunch:YES];
    self.weatherInfoDB.delegate = self;
    [self updateWeatherData:self.weatherInfoDB];
    [self.weatherInfoDB homepageToTheFirst];
    [self startWeatherDBTimer];
    
    // Set up model controller
    _modelController = [[WeatherModelController alloc] initWithDatabase:self.weatherInfoDB];
    
    // Set Up Model View Controller
    self.lakePageViewController = [self setUpPVCWithModel:self.modelController];
    [self addChildViewController:self.lakePageViewController];
    [self.view addSubview:self.lakePageViewController.view];
    
    CGRect pageViewRect = self.view.bounds;
    self.lakePageViewController.view.frame = pageViewRect;
    [self.lakePageViewController didMoveToParentViewController:self];

    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.

    
    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    
    self.view.gestureRecognizers = self.lakePageViewController.gestureRecognizers;
}

// I have to the
-(void) addNetworkStatusNotification{
    [[NSNotificationCenter defaultCenter] addObserverForName:@"NetworkDidCheckNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self reachabilityChanged:note];
    }];
}

-(void)reachabilityChanged:(NSNotification*) note{
    NSDictionary* userInfo = note.userInfo;
    self.isConnectedToNetwork = [[userInfo objectForKey:@"isNetworkOn"] boolValue];
    JJWeatherViewController* curWVC =(JJWeatherViewController*)[self getCurrentPageInPageViewController:self.lakePageViewController];
    [curWVC displayNetworkConnection:self.isConnectedToNetwork];
}

- (void)updateWeatherData:(WeatherInfoDB*) db{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataNeedsUpdateNotification" object:nil];
}

-(UIPageViewController*) setUpPVCWithModel:(WeatherModelController*) modelController {
    //Basic info for pageViewController
    UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageViewController.delegate = self;
    pageViewController.dataSource = modelController;
    
    //Set the starting view controller
    //I need to rewrite the initializatio nof the starting view controller
    JJWeatherViewController *startingViewController = [modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray *viewControllers = @[startingViewController];
    [pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    return pageViewController;
}

-(void)displayFavouriteAsFirstPage{
    
    if([[WeatherInfoDB sharedDB] homepageToTheFirst]){
        JJWeatherViewController *favouriteVC = [self.modelController viewControllerAtIndex:0
                                                                            storyboard:self.storyboard];
        NSArray* vControllers = @[favouriteVC];
        [self.lakePageViewController setViewControllers:vControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}

// You can the time by changing the 60. Be aware that 60 is in seconds
-(void) startWeatherDBTimer{
    [self.weatherInfoDB startTimer: 60];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // Decide whether to present the update information for user
    if(_justUpdated || _firstLaunch){
        [self presentUpdate];
    }
}

- (void) presentUpdate{
    
    _um = [UpdateModel sharedUpdateModel];
    UpdateInfoViewController* uivc = [_um viewControllerAtIndex:0];
    self.updatePageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    NSArray* updateViewControllers = @[uivc];
    [self.updatePageViewController setViewControllers:updateViewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.updatePageViewController.delegate = self;
    self.updatePageViewController.dataSource = _um;
    self.updatePageViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:self.updatePageViewController animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - WeatherInfo DB delegate methods
// This will update the data.
- (void)weatherInfoDBAfterDataUpdated:(WeatherInfoDB *)db{
    JJWeatherViewController* currVC = (JJWeatherViewController*) [self getCurrentPageInPageViewController:self.lakePageViewController];
    NSString* lakeName;
    lakeName = currVC.lake.lakeName;
    [currVC displayData];
}

-(UIViewController*) getCurrentPageInPageViewController:(UIPageViewController*) pvc{
    return (UIViewController*)[self.lakePageViewController.viewControllers lastObject];
}


#pragma mark - UIPageViewController delegate methods

// Use IVC to change the current view controller. The view controller itself shouldn't be responsible
// for holding and responding to the setting change.
// This method will be used to set some universal setting.
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers{
    
    //This method will be called when update page view controller also gets called. Thus, we need
    // to differentiate the two behaviors between these two
    if (pageViewController == self.updatePageViewController){
        return;
    }
    
    for (UIViewController* dummyViewController in pendingViewControllers) {
        JJWeatherViewController* viewController = (JJWeatherViewController*) dummyViewController;
        [viewController displayNetworkConnection:self.isConnectedToNetwork];
    }
}


- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    if (UIInterfaceOrientationIsPortrait(orientation) || ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)) {
        // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
        
        UIViewController *currentViewController = self.lakePageViewController.viewControllers[0];
        NSArray *viewControllers = @[currentViewController];
        [self.lakePageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        
        self.lakePageViewController.doubleSided = NO;
        return UIPageViewControllerSpineLocationMin;
    }

    // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
    JJWeatherViewController *currentViewController = self.lakePageViewController.viewControllers[0];
    NSArray *viewControllers = nil;

    NSUInteger indexOfCurrentViewController = [self.modelController indexOfViewController:currentViewController];
    if (indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0) {
        UIViewController *nextViewController = [self.modelController pageViewController:self.lakePageViewController viewControllerAfterViewController:currentViewController];
        viewControllers = @[currentViewController, nextViewController];
    } else {
        UIViewController *previousViewController = [self.modelController pageViewController:self.lakePageViewController viewControllerBeforeViewController:currentViewController];
        viewControllers = @[previousViewController, currentViewController];
    }
    [self.lakePageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];


    return UIPageViewControllerSpineLocationMid;
}

@end
