//
//  IphoneModelSizeIdentifier.h
//  This class can't identify the actual model for this app, because it only uses the screen to
//  distinguish. 4 and 4s have the same size, so you can't decide. However, it's good enough to
//  decide the screen size. It's good enough for us here
//
//  NTLRealTimeConditioniOS
//
//  Created by Junjie on 9/2/16.
//  Copyright © 2016 Junjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface IphoneModelSizeIdentifier : NSObject

//4 and 4s have the same height, will use iPhone4 property to decide
@property (readonly, atomic) int iPhone4Height;

//5 and 5s have the same height, will use iPhone5 property to decide
@property (readonly, atomic) int iPhone5Height;

//6 and 6s have the same height
@property (readonly, atomic) int iPhone6Height;

//6Plus and 6sPlus have the same height.
@property (readonly, atomic) int iPhone6PlusHeight;

-(NSString*) identifyModel:(UIScreen*) mainScreen;


@end
