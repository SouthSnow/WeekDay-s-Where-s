//
//  UIViewController+Tracking.m
//  runtime_Method SwizzlingDemo
//
//  Created by pfl on 14/12/31.
//  Copyright (c) 2014年 pfl. All rights reserved.
//

#import "UIViewController+Tracking.h"
#import <objc/runtime.h>


@implementation UIViewController (Tracking)

+ (void)load
{
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        SEL originSelector = @selector(viewWillAppear:);
        SEL swizzlingSelector = @selector(swizzling_viewWillAppear:);
        Method originMethod = class_getInstanceMethod(class, originSelector);
        Method swizzlingMethod = class_getInstanceMethod(class, swizzlingSelector);
        
        BOOL didAddMethod = class_addMethod(class, originSelector, method_getImplementation(swizzlingMethod), method_getTypeEncoding(swizzlingMethod));
        if (didAddMethod) {
            class_replaceMethod(class, swizzlingSelector,method_getImplementation(originMethod), method_getTypeEncoding(originMethod));
        }
        else
        {
            method_exchangeImplementations(originMethod, swizzlingMethod);
        }
        
        
    });
    
    
    
    
    
    
    
    
    
    
}




- (void)swizzling_viewWillAppear:(BOOL)animated
{
    [self swizzling_viewWillAppear:animated];
    
    NSLog(@"viewWillAppear: %@",self);
}
@end
