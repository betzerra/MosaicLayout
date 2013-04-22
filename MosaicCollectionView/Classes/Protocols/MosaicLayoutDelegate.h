//
//  MosaicLayoutDelegate.h
//  MosaicCollectionView
//
//  Created by Ezequiel A Becerra on 4/21/13.
//  Copyright (c) 2013 Betzerra. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MosaicLayoutDelegate <NSObject>

-(float)collectionView:(UICollectionView *)collectionView relativeHeightForItemAtIndexPath:(NSIndexPath*)indexPath doubleColumn:(BOOL)isDoubleColumn;
-(BOOL)collectionView:(UICollectionView *)collectionView isDoubleColumnAtIndexPath:(NSIndexPath *)indexPath;

@optional
//  Actually this won't be optional but I don't want to refactor now
-(NSUInteger)numberOfColumnsInCollectionView:(UICollectionView *)collectionView;

@end
