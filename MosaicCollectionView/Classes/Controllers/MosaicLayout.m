//
//  MosaicLayout.m
//  MosaicCollectionView
//
//  Created by Ezequiel A Becerra on 2/16/13.
//  Copyright (c) 2013 Betzerra. All rights reserved.
//

#import "MosaicLayout.h"

#define kDoubleColumnProbability 40
#define kHeightModule 40

@interface MosaicLayout()
-(NSUInteger)shortestColumnIndex;
-(NSUInteger)longestColumnIndex;
-(BOOL)canUseDoubleColumnOnIndex:(NSUInteger)columnIndex;
-(float)heightForIndexPath:(NSIndexPath *)indexPath withWidth:(float)width;
@end

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

-(BOOL)canUseDoubleColumnOnIndex:(NSUInteger)columnIndex{
    BOOL retVal = NO;

    if (columnIndex < self.columnsQuantity-1){
        float firstColumnHeight = [columns[columnIndex] floatValue];
        float secondColumnHeight = [columns[columnIndex+1] floatValue];
        
        if (firstColumnHeight == secondColumnHeight){
            NSUInteger random = arc4random() % 100;
            if (random < kDoubleColumnProbability){
                retVal = YES;
            }
        }
    }
    
    return retVal;
}

-(float)heightForIndexPath:(NSIndexPath *)indexPath withWidth:(float)width{
    int halfWidth = width/2;
    float retVal = width + (arc4random() % halfWidth);
    retVal = retVal - ((int)retVal % kHeightModule);
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
    columns = [NSMutableArray arrayWithCapacity:self.columnsQuantity];
    for (NSInteger i = 0; i < self.columnsQuantity; i++) {
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

        NSUInteger itemWidth = 0;
        NSUInteger itemHeight = 0;
        if ([self canUseDoubleColumnOnIndex:columnIndex]){
            itemWidth = [self columnWidth] * 2;
            itemHeight = [self heightForIndexPath:indexPath withWidth:itemWidth*0.75];
            
            //  Set column height
            columns[columnIndex] = @(yOffset + itemHeight);
            columns[columnIndex+1] = @(yOffset + itemHeight);

        }else{
            itemWidth = [self columnWidth];
            itemHeight = [self heightForIndexPath:indexPath withWidth:itemWidth];
            
            //  Set column height
            columns[columnIndex] = @(yOffset + itemHeight);
        }
        
        /*  Assign all those values to an UICollectionViewLayoutAttributes instance
         *  and save it on an array */
        UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attributes.frame = CGRectMake(xOffset, yOffset, itemWidth, itemHeight);
        [itemsAttributes addObject:attributes];
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
