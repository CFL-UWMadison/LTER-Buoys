//
//  UpdateModel.m
//  UpdatedViewController
//
//  Created by Junjie on 6/11/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import "UpdateModel.h"


@interface UpdateModel ()

@property(nonatomic,strong) NSArray* updatedText;
@property (nonatomic,strong) NSArray* picture;

@end


@implementation UpdateModel

+(UpdateModel*) sharedUpdateModel{
    static UpdateModel* singleton = nil;
    if (!singleton){
        singleton = [[UpdateModel alloc] initPrivate];
    }

    return singleton;
}

-(instancetype) initPrivate{
    self = [super init];
    if(self){
        NSString* updateText1 = @"- A new interface has been adopted to help you see the data better. \n- Wind Gust has been online to help you make a better decision when sailoring \n - Click the new setting";
        
        NSString* updateText2 = @"- A new interactive setting menu. \n - Use the setting to change between the Metric Unit and British Unit.";
        
        
        _updatedText = @[updateText1,updateText2 ,@"Let's start"];
        _picture = @[@"New_interface_1.jpg",@"New_interface_2.jpg"];
        self.numOfPage = _updatedText.count;

    }
    
    return self;
}




-(UIViewController*) viewControllerAtIndex : (int) index{
    
    
    if(index >= self.numOfPage || index < 0){
        return  nil;
    }
    
    if(index == self.numOfPage-1){
        LetsStartViewController* lvc = [[LetsStartViewController alloc] init];
        lvc.pageNum = index;
        return lvc;
    }
    
    UpdateInfoViewController* uvc = [[UpdateInfoViewController alloc] init];
    uvc.updatedInfo = _updatedText[index];
    uvc.updatedImage = _picture[index];
    uvc.pageNum = index;
    
    return uvc;
    
}

/*
- (NSUInteger)indexOfViewController:(UpdateInfoViewController *)viewController {
    
    if(!viewController){
        return -1;
    }
    
    NSString* identityString = viewController.updatedImage ;
    for (int i=0; i<_picture.count; i++) {
        NSString* string = _picture[i];
        if([string isEqualToString:identityString]){
            return i;
            
        }
    }
    return -1;
    
}*/

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    
    NSUInteger currentIndex = 0;
    if([viewController isKindOfClass:[UpdateInfoViewController class]]){
        UpdateInfoViewController* uvc = (UpdateInfoViewController*) viewController;
       currentIndex = uvc.pageNum;
    } else if([viewController isKindOfClass:[LetsStartViewController class]]){
        LetsStartViewController* lvc = (LetsStartViewController*) viewController;
        currentIndex = lvc.pageNum;
        
    }
    
    int index =(int) ++currentIndex;
    
    if(index >= _numOfPage){
        return nil;
    }
    return (UIViewController*)[self viewControllerAtIndex:index];
    
}



- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
   
    NSUInteger currentIndex = 0;
    if([viewController isKindOfClass:[UpdateInfoViewController class]]){
        UpdateInfoViewController* uvc = (UpdateInfoViewController*) viewController;
        currentIndex = uvc.pageNum;
    } else if([viewController isKindOfClass:[LetsStartViewController class]]){
        LetsStartViewController* lvc = (LetsStartViewController*) viewController;
        currentIndex = lvc.pageNum;
        
    }
    int index = (int)(--currentIndex);
    
    if(index < 0){
        return  nil;
    }
    return (UIViewController*)[self viewControllerAtIndex:index];
}



@end
