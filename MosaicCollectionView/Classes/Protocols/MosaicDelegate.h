//
//  MosaicDelegate.h
//  MosaicCollectionView
//
//  Created by Ezequiel A Becerra on 2/17/13.
//  Copyright (c) 2013 Betzerra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MosaicData.h"
@protocol MosaicDelegate <NSObject>

-(MosaicData *)mosaicDataForIndexPath:(NSIndexPath *)anIndexPath;
-(UIImage *)imageForIndexPath:(NSIndexPath *)anIndexPath;
-(NSUInteger)mosaicElementsCount;
@end
