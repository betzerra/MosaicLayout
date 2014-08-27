//
//  CustomDelegate.h
//  MosaicCollectionView
//
//  Created by Ezequiel A Becerra on 2/16/13.
//  Copyright (c) 2013 Betzerra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomDataSource : NSObject <UICollectionViewDataSource>{
}

@property (readonly) NSMutableArray *elements;

@end