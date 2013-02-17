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
    
    //  Set all column heights to 0
    columns = [NSMutableArray arrayWithCapacity:kColumnsQuantity];
    for (NSInteger i = 0; i < kColumnsQuantity; i++) {
        [columns addObject:@(0)];
    }
    
    //  Get all the items available for the section
    NSUInteger itemsCount = [[self collectionView] numberOfItemsInSection:0];
    itemsAttributes = [NSMutableArray arrayWithCapacity:itemsCount];
    
    for (NSUInteger i = 0; i < itemsCount; i++){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        //  Get x, y, width and height for indexPath
        NSUInteger columnIndex = [self shortestColumnIndex];
        NSUInteger xOffset = columnIndex * [self columnWidth];
        NSUInteger yOffset = [[columns objectAtIndex:columnIndex] integerValue];
        NSUInteger itemHeight = kItemHeight;
        
        /*  Assign all those values to an UICollectionViewLayoutAttributes instance
         *  and save it on an array */
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(xOffset, yOffset, [self columnWidth], itemHeight);
        [itemsAttributes addObject:attributes];
        
        //  Set column height
        columns[columnIndex] = @(yOffset + itemHeight);
    }
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{    
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
