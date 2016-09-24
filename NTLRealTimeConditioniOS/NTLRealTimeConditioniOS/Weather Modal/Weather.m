//
//  Weather.m
//  AppForLiminology View
//
//  Created by Junjie on 16/1/2.
//  Copyright © 2016年 Junjie. All rights reserved.
//

#import "Weather.h"
#import <Foundation/Foundation.h>
#import <objc/objc.h>

@implementation Weather

/*
// Insert code here to add functionality to your managed object subclass
-(NSString*) description{
    NSMutableString* description = [NSMutableString stringWithString:@""];
    
    unsigned int numberOfProperties = 0;
    objc_property_t *propertyArray = class_copyPropertyList([Weather class], &numberOfProperties);
    
    for (NSUInteger i =0 ; i < numberOfProperties; i++){
        objc_property_t property = propertyArray[i];
        NSString *name = [[NSString alloc] initWithUTF8String:property_getName(property)];
        NSString *attributesString = [[NSString alloc] initWithUTF8String:property_getAttributes(property)];
        
        NSString* attribute =[ NSString stringWithFormat: @"%@ : %@", name, attributesString ];
        
        [description appendString:attribute];
    }
    
    return description;
}*/

@end
