//
//  MosaicLayout.m
//  MosaicCollectionView
//
//  Created by Ezequiel A Becerra on 2/16/13.
//  Copyright (c) 2013 Betzerra. All rights reserved.
//

#import "MosaicLayout.h"

#define kHeightModule 40

@interface MosaicLayout()
-(NSUInteger)shortestColumnIndex;
-(NSUInteger)longestColumnIndex;
-(BOOL)canUseDoubleColumnOnIndex:(NSUInteger)columnIndex;
@end

@implementation MosaicLayout

#pragma mark - Private

-(NSUInteger)shortestColumnIndex{
    NSUInteger retVal = 0;
    CGFloat shortestValue = MAXFLOAT;
    
    NSUInteger i=0;
    for (NSNumber *heightValue in _columns){
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
    for (NSNumber *heightValue in _columns){
        if ([heightValue floatValue] > longestValue){
            longestValue = [heightValue floatValue];
            retVal = i;
        }
        i++;
    }
    return retVal;
}

-(BOOL)canUseDoubleColumnOnIndex:(NSUInteger)columnIndex{
    BOOL retVal = NO;

    if (columnIndex < self.columnsQuantity-1){
        float firstColumnHeight = [_columns[columnIndex] floatValue];
        float secondColumnHeight = [_columns[columnIndex+1] floatValue];

        retVal = firstColumnHeight == secondColumnHeight;
    }
    
    return retVal;
}

#pragma mark - Properties

-(NSUInteger) columnsQuantity{
    NSUInteger retVal = [self.delegate numberOfColumnsInCollectionView:self.collectionView];
    return retVal;
}

#pragma mark - Public

-(float)columnWidth{
    float retVal = self.collectionView.bounds.size.width / self.columnsQuantity;
    retVal = roundf(retVal);
    return retVal;
}

#pragma mark UICollectionViewLayout

-(void)prepareLayout{
    
    //  Set all column heights to 0
    _columns = [NSMutableArray arrayWithCapacity:self.columnsQuantity];
    for (NSInteger i = 0; i < self.columnsQuantity; i++) {
        [_columns addObject:@(0)];
    }
    
    //  Get all the items available for the section
    NSUInteger itemsCount = [[self collectionView] numberOfItemsInSection:0];
    _itemsAttributes = [NSMutableArray arrayWithCapacity:itemsCount];
    
    for (NSUInteger i = 0; i < itemsCount; i++){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        
        //  Get x, y, width and height for indexPath
        NSUInteger columnIndex = [self shortestColumnIndex];
        NSUInteger xOffset = columnIndex * [self columnWidth];
        NSUInteger yOffset = [[_columns objectAtIndex:columnIndex] integerValue];

        NSUInteger itemWidth = 0;
        NSUInteger itemHeight = 0;
        float itemRelativeHeight = [self.delegate collectionView:self.collectionView relativeHeightForItemAtIndexPath:indexPath];
        
        if ([self canUseDoubleColumnOnIndex:columnIndex] &&
            [self.delegate collectionView:self.collectionView isDoubleColumnAtIndexPath:indexPath]){
            
            itemWidth = [self columnWidth] * 2;
            itemHeight = itemRelativeHeight * itemWidth;
            itemHeight = itemHeight - (itemHeight % kHeightModule);            
            
            //  Set column height
            _columns[columnIndex] = @(yOffset + itemHeight);
            _columns[columnIndex+1] = @(yOffset + itemHeight);

        }else{
            itemWidth = [self columnWidth];
            itemHeight = itemRelativeHeight * itemWidth;
            itemHeight = itemHeight - (itemHeight % kHeightModule);            
            
            //  Set column height
            _columns[columnIndex] = @(yOffset + itemHeight);
        }
        
        /*  Assign all those values to an UICollectionViewLayoutAttributes instance
         *  and save it on an array */
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(xOffset, yOffset, itemWidth, itemHeight);
        [_itemsAttributes addObject:attributes];
    }
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{    
    NSPredicate *filterPredicate = [NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes * evaluatedObject, NSDictionary *bindings) {
        BOOL predicateRetVal = CGRectIntersectsRect(rect, [evaluatedObject frame]);
        return predicateRetVal;
    }];
    
    NSArray *retVal = [_itemsAttributes filteredArrayUsingPredicate:filterPredicate];
    return retVal;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *retVal = [_itemsAttributes objectAtIndex:indexPath.row];
    return retVal;
}

-(CGSize)collectionViewContentSize{
    CGSize retVal = self.collectionView.bounds.size;
    
    NSUInteger columnIndex = [self longestColumnIndex];
    float columnHeight = [_columns[columnIndex] floatValue];
    retVal.height = columnHeight;
    
    return retVal;
}

@end
