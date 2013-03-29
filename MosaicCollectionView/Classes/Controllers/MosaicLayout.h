//
//  MosaicLayout.h
//  MosaicCollectionView
//
//  Created by Ezequiel A Becerra on 2/16/13.
//  Copyright (c) 2013 Betzerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MosaicViewController.h"

@interface MosaicLayout : UICollectionViewLayout{
    NSMutableArray *_columns;
    NSMutableArray *_itemsAttributes;
}

@property (weak) MosaicViewController *controller;
@property (assign) NSUInteger columnsQuantity;

-(float)columnWidth;

@end
