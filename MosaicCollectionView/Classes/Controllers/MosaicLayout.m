//
//  MosaicLayout.m
//  MosaicCollectionView
//
//  Created by Ezequiel A Becerra on 2/16/13.
//  Copyright (c) 2013 Betzerra. All rights reserved.
//

#import "MosaicLayout.h"

#define kColumnsQuantity 3

//  #TEMP
#define kItemHeight arc4random() % 200 + 100

@implementation MosaicLayout

#pragma mark - Private

-(NSUInteger)shortestColumnIndex{
    NSUInteger retVal = 0;
    CGFloat shortestValue = MAXFLOAT;
    
    NSUInteger i=0;
    for (NSNumber *heightValue in columns){
        if ([heightValue floatValue] < shortestValue){
            shortestValue = [heightValue floatValue];
            retVal = i;
        }
        i++;
    }
    return retVal;
}

-(NSUInteger)longestColumnIndex{
    NSUInteger retVal = 0;
    CGFloat longestValue = 0;
    
    NSUInteger i=0;
    for (NSNumber *heightValue in columns){
        if ([heightValue floatValue] > longestValue){
            longestValue = [heightValue floatValue];
            retVal = i;
        }
        i++;
    }
    return retVal;
}

-(float)columnWidth{
    float retVal = self.collectionView.bounds.size.width / kColumnsQuantity;
    retVal = roundf(retVal);
    return retVal;
}

#pragma mark - Public
#pragma mark UICollectionViewLayout

-(void)prepareLayout{
//    [super prepareLayout];
    
    //  Set all column heights to 0
    columns = [NSMutableArray arrayWithCapacity:kColumnsQuantity];
    for (NSInteger i = 0; i < kColumnsQuantity; i++) {
        [columns addObject:@(0)];
    }
    
    NSUInteger itemsCount = [[self collectionView] numberOfItemsInSection:0];
    itemsAttributes = [NSMutableArray arrayWithCapacity:itemsCount];
    
    for (NSUInteger i = 0; i < itemsCount; i++){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];

        NSUInteger columnIndex = [self shortestColumnIndex];
        NSUInteger xOffset = columnIndex * [self columnWidth];
        NSUInteger yOffset = [[columns objectAtIndex:columnIndex] integerValue];
        NSUInteger itemHeight = kItemHeight;
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(xOffset, yOffset, [self columnWidth], itemHeight);
        
        [itemsAttributes addObject:attributes];
        columns[columnIndex] = @(yOffset + itemHeight);
    }
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
//    NSArray *retVal = [super layoutAttributesForElementsInRect:rect];
    
    NSPredicate *filterPredicate = [NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes * evaluatedObject, NSDictionary *bindings) {
        BOOL predicateRetVal = CGRectIntersectsRect(rect, [evaluatedObject frame]);
        return predicateRetVal;
    }];
    
    NSArray *retVal = [itemsAttributes filteredArrayUsingPredicate:filterPredicate];
    return retVal;
}

-(CGSize)collectionViewContentSize{
    CGSize retVal = self.collectionView.bounds.size;
    
    NSUInteger columnIndex = [self longestColumnIndex];
    float columnHeight = [columns[columnIndex] floatValue];
    retVal.height = columnHeight;
    
    return retVal;
}

@end
