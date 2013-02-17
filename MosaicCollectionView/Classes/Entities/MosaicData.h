//
//  MosaicData.h
//  MosaicCollectionView
//
//  Created by Ezequiel A Becerra on 2/17/13.
//  Copyright (c) 2013 Betzerra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MosaicData : NSObject

-(id)initWithDictionary:(NSDictionary *)aDict;

@property (strong) NSString *imageFilename;
@property (strong) NSString *title;
@end
