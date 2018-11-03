//
//  UIViewController.m
//  Objectivec-Swift-UntitTesting
//
//  Created by Abuzeid Ibrahim on 11/3/18.
//  Copyright © 2018 abuzeid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@implementation UIViewController (Logging)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //Init
        SEL init_originalSelector =  @selector (initWithFrame:);
        SEL init_swizzledSelector =  @selector(my_alloc);
        [UIViewController replaceSelector:init_originalSelector :init_swizzledSelector];
        
        //ViewDidLoad
        
        SEL didLoad_originalSelector = @selector(viewDidLoad);
        SEL didLoad_swizzledSelector = @selector(xxx_viewDidLoad);
        [UIViewController replaceSelector:didLoad_originalSelector :didLoad_swizzledSelector];
        
        //ViewWillAppear
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(xxx_viewWillAppear:);
        [UIViewController replaceSelector:originalSelector :swizzledSelector];
        //ViewDidAppear
        SEL didAppear_originalSelector = @selector(viewDidAppear:);
        SEL didAppear_swizzledSelector = @selector(xxx_viewDidAppear:);
        [UIViewController replaceSelector:didAppear_originalSelector :didAppear_swizzledSelector];
        
        //ViewWillDisAppear
        SEL willDisAppear_originalSelector = @selector(viewWillDisappear:);
        SEL willDisAppear_swizzledSelector = @selector(xxx_viewWillDisappear:);
        [UIViewController replaceSelector:willDisAppear_originalSelector :willDisAppear_swizzledSelector];
        //ViewDidDisAppear
        SEL didDisAppear_originalSelector = @selector(viewDidDisappear:);
        SEL didDisAppear_swizzledSelector = @selector(xxx_viewDidDisappear:);
        [UIViewController replaceSelector:didDisAppear_originalSelector :didDisAppear_swizzledSelector];
        
        //DeInit
        Method origMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
        Method newMethod = class_getInstanceMethod([self class], @selector(my_dealloc));
        method_exchangeImplementations(origMethod, newMethod);
        
        
        
        
        
    });
}
+(void)replaceSelector:(SEL)originalSelector :(SEL)swizzledSelector{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    // ...
    // Method originalMethod = class_getClassMethod(class, originalSelector);
    // Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
#pragma mark - Method Swizzling
- (void)xxx_viewDidLoad{
    [self xxx_viewDidLoad];
    
    NSString* methodName =  NSStringFromSelector(_cmd);
    NSLog(@"%@ -> %@",  [self getClassName],methodName);
}

- (void)xxx_viewWillAppear:(BOOL)animated {
    [self xxx_viewWillAppear:animated];
    
    NSString* methodName =  NSStringFromSelector(_cmd);
    NSLog(@"%@ -> %@",  [self getClassName],methodName);
}
- (void)xxx_viewDidAppear:(BOOL)animated {
    [self xxx_viewDidAppear:animated];
    
    NSString* methodName =  NSStringFromSelector(_cmd);
    NSLog(@"%@ -> %@",  [self getClassName],methodName);
}
- (void)xxx_viewWillDisappear:(BOOL)animated {
    [self xxx_viewWillDisappear:animated];
    
    NSString* methodName =  NSStringFromSelector(_cmd);
    NSLog(@"%@ -> %@",  [self getClassName],methodName);
}

- (void)xxx_viewDidDisappear:(BOOL)animated {
    [self xxx_viewDidDisappear:animated];
    
    NSString* methodName =  NSStringFromSelector(_cmd);
    NSLog(@"%@ -> %@",  [self getClassName],methodName);
}


-(NSString*)getClassName{
    NSString* className = NSStringFromClass([self class]);
    NSString *theFileName = [className lastPathComponent];
    
    return theFileName;
}
- (void)my_dealloc
{
    NSString* methodName =  NSStringFromSelector(_cmd);
    NSLog(@"%@ -> %@", [self getClassName] ,methodName);
}

- (void)my_alloc
{
    NSString* methodName =  NSStringFromSelector(_cmd);
    NSLog(@"%@ -> %@",  [self getClassName],methodName);
    
}


@end
