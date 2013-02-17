//
//  MosaicDataView.h
//  MosaicCollectionView
//
//  Created by Ezequiel A Becerra on 2/16/13.
//  Copyright (c) 2013 Betzerra. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MosaicData.h"

@interface MosaicCell : UICollectionViewCell{
    UIImageView *imageView;
    MosaicData *mosaicData;
    UILabel *titleLabel;
}

@property (strong) UIImage *image;
@property (strong) MosaicData *mosaicData;

@end
