//
//  MKOAirdropActivityViewController.m
//
// Copyright (c) 2015 Mathias Koehnke (http://www.mathiaskoehnke.com)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "MKOAirdropActivityViewController.h"

static CGFloat MKODefaultAirdropCellHeight = 125.0;

@interface MKOAirdropActivityViewControllerProxyDatasource : NSObject <UICollectionViewDataSource>
@property (nonatomic, strong) id<UICollectionViewDataSource> originalDataSource;
@end

@implementation MKOAirdropActivityViewControllerProxyDatasource

+ (instancetype)proxyWithDatasource:(id<UICollectionViewDataSource>)datasource {
    MKOAirdropActivityViewControllerProxyDatasource *instance = [MKOAirdropActivityViewControllerProxyDatasource new];
    instance.originalDataSource = datasource;
    return instance;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.originalDataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        return [self.originalDataSource collectionView:collectionView numberOfItemsInSection:section];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.originalDataSource respondsToSelector:@selector(collectionView:cellForItemAtIndexPath:)]) {
        return [self.originalDataSource collectionView:collectionView cellForItemAtIndexPath:indexPath];
    }
    return nil;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    #pragma unused(collectionView)
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([self.originalDataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)]) {
        return [self.originalDataSource collectionView:collectionView viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    }
    return nil;
}
@end


@interface MKOAirdropActivityViewController ()
@property (nonatomic, weak) UICollectionView *__collectionView;
@property (nonatomic, strong) id<UICollectionViewDataSource> __proxyDatasource;
@end

@implementation MKOAirdropActivityViewController

- (instancetype)initWithActivityItems:(NSArray *)activityItems applicationActivities:(NSArray<__kindof UIActivity *> *)applicationActivities {
    self = [super initWithActivityItems:activityItems applicationActivities:applicationActivities];
    if (self) {
        if ([self operatingSystemIsSupported]) {
            [self __identifyMainCollectionView:self.view];
            [self set__proxyDatasource:[MKOAirdropActivityViewControllerProxyDatasource proxyWithDatasource:self.__collectionView.dataSource]];
            [self.__collectionView setDataSource:self.__proxyDatasource];
            [self __hideActivityCollectionViews:self.view];
            
            UIViewController *containerViewController = self.childViewControllers.firstObject.childViewControllers.firstObject;
            CGSize preferredContentSize = containerViewController.preferredContentSize;
            containerViewController.preferredContentSize = CGSizeMake(preferredContentSize.width, MKODefaultAirdropCellHeight);
            
            // Alternative
            //SEL selector = NSSelectorFromString(@"_updatePreferredContentSizes");
            //((void (*)(id, SEL))[self methodForSelector:selector])(self, selector);
        }
    }
    return self;
}

- (void)__hideActivityCollectionViews:(UIView *)currentView {
    for (UIView *subview in currentView.subviews) {
        if ([subview isKindOfClass:[UICollectionView class]] && [subview isEqual:self.__collectionView] == NO) {
            subview.hidden = YES;
        }
        [self __hideActivityCollectionViews:subview];
    }
}

- (void)__identifyMainCollectionView:(UIView *)currentView {
    if (self.__collectionView) return;
    for (UIView *subview in currentView.subviews) {
        if ([self __isMainCollectionView:subview]) {
            self.__collectionView = (UICollectionView *)subview;
            return;
        }
        [self __identifyMainCollectionView:subview];
    }
}

- (BOOL)__isMainCollectionView:(UIView *)view {
    if ([view isKindOfClass:[UICollectionView class]]) {
        return ((UICollectionView *)view).numberOfSections >= 2;
    }
    return NO;
}


- (void)setExcludedActivityTypes:(NSArray *)excludedActivityTypes {
    #pragma unused(excludedActivityTypes)
    // In order to have a consistent number of sections, we ignore excluded activity types here.
}


- (BOOL)operatingSystemIsSupported {
    NSOperatingSystemVersion version = {9, 0 ,0};
    return [[NSProcessInfo processInfo] respondsToSelector:@selector(isOperatingSystemAtLeastVersion:)] &&
           [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:version];
}

@end
