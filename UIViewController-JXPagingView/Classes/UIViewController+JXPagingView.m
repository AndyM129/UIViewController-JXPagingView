//
//  UIViewController+JXPagingView.m
//  AMKCategories
//
//  Created by 孟昕欣 on 2019/11/26.
//

#import "UIViewController+JXPagingView.h"
#import <AMKCategories/NSObject+AMKMethodSwizzling.h>
#import <JXPagingView/JXPagerView.h>

@implementation UIViewController (JXPagingView)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [UIViewController amk_swizzleInstanceMethod:@selector(viewDidAppear:) withMethod:@selector(JXPagingView_UIViewController_viewDidAppear:)];
        [UIViewController amk_swizzleInstanceMethod:@selector(viewDidDisappear:) withMethod:@selector(JXPagingView_UIViewController_viewDidDisappear:)];
    });
}

#pragma mark - Life Circle

// 若需 hook，则调用一下 代理方法
- (void)JXPagingView_UIViewController_viewDidAppear:(BOOL)animated {
    [self JXPagingView_UIViewController_viewDidAppear:animated];
    
    if (!self.JXPagingView_UIViewController_shouldHook) return;
    if (![self respondsToSelector:@selector(listDidAppear)]) return;
    [(id<JXPagerViewListViewDelegate>)self listDidAppear];
}

// 若需 hook，则调用一下 代理方法
- (void)JXPagingView_UIViewController_viewDidDisappear:(BOOL)animated {
    [self JXPagingView_UIViewController_viewDidDisappear:animated];
    
    if (!self.JXPagingView_UIViewController_shouldHook) return;
    if (![self respondsToSelector:@selector(listDidDisappear)]) return;
    [(id<JXPagerViewListViewDelegate>)self listDidDisappear];
}

#pragma mark - Properties

#pragma mark - Data & Networking

#pragma mark - Layout Subviews

#pragma mark - Public Methods

#pragma mark - Private Methods

/// 判断当前对象是否应该被 Hook。要求：实现协议，并且是 子页面
- (BOOL)JXPagingView_UIViewController_shouldHook {
    // 若没有实现协议，则直接返回
    if (![self conformsToProtocol:@protocol(JXPagerViewListViewDelegate)]) {
        return NO;
    }
    
    // 若是 JXPagerListContainerView 的子页面，则直接返回
    if ([self JXPagingView_UIViewController_nextResponderWithClass:JXPagerListContainerView.class]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Notifications

#pragma mark - KVO

#pragma mark - Delegate

#pragma mark - Override

#pragma mark - Helper Methods

/// 通过响应者链查找指定类的实例
- (UIResponder *)JXPagingView_UIViewController_nextResponderWithClass:(Class)Class {
    UIResponder *nextResponder = self;
    while (nextResponder && ![nextResponder isKindOfClass:Class]) {
        nextResponder = nextResponder.nextResponder;
    }
    return nextResponder;
}

@end
