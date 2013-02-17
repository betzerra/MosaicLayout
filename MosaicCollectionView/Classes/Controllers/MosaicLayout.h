//
//  MosaicLayout.h
//  MosaicCollectionView
//
//  Created by Ezequiel A Becerra on 2/16/13.
//  Copyright (c) 2013 Betzerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MosaicViewController.h"

#define kColumnsQuantity 3

@interface MosaicLayout : UICollectionViewLayout{
    NSMutableArray *columns;
    NSMutableArray *itemsAttributes;
}

@property (weak) MosaicViewController *controller;

-(float)columnWidth;

@end
