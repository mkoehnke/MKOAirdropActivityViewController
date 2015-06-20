//
//  MKOAirdropViewController.m
//  MKOAirdropViewControllerSample
//
//  Created by Mathias Köhnke on 19/06/15.
//  Copyright (c) 2015 Mathias Koehnke. All rights reserved.
//

#import "MKOAirdropActivityViewController.h"

static NSUInteger MKONumberOfActivitySections = 3;


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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self __modifyCollectionViews:self.view];
    [self set__proxyDatasource:[MKOAirdropActivityViewControllerProxyDatasource proxyWithDatasource:self.__collectionView.dataSource]];
    [self.__collectionView setDataSource:self.__proxyDatasource];
}

- (void)__modifyCollectionViews:(UIView *)currentView {
    for (UIView *subview in currentView.subviews) {
        if ([self __isMainCollectionView:subview]) {
            self.__collectionView = (UICollectionView *)subview;
            BOOL isAirdropShown = subview.subviews.count == MKONumberOfActivitySections;
            for (NSUInteger i = 0; i < subview.subviews.count; i++) {
                [subview.subviews[i] setHidden:!(i == 0 && isAirdropShown)];
            }
            break;
        }
        [self __modifyCollectionViews:subview];
    }
}

- (BOOL)__isMainCollectionView:(UIView *)view {
    if ([view isKindOfClass:[UICollectionView class]]) {
        return ((UICollectionView *)view).numberOfSections >= 2;
    }
    return NO;
}


- (void)setExcludedActivityTypes:(NSArray *)excludedActivityTypes {
    // 
}

@end
