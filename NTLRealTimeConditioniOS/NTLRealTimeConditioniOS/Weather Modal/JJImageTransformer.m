//
//  JJImageTransfromer.m
//  The class for transforming a image to the NSData for 
//
//  Created by Junjie on 16/1/4.
//  Copyright © 2016年 Junjie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface JJImageTransformer: NSValueTransformer


@end

@implementation JJImageTransformer

+(Class) transformedValueClass{
    return  [NSData class];
}

-(id) transformedValue:(id)value{
    if(!value){
        return nil;
    }
    
    if([value isKindOfClass:[NSData class]]){
        return value;
    }
    
    return UIImageJPEGRepresentation(value, 1.0);
}


-(id) reverseTransformedValue:(id)value{
    return [UIImage imageWithData:value];
}
@end