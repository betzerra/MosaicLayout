//
//  CustomDelegate.m
//  MosaicCollectionView
//
//  Created by Ezequiel A Becerra on 2/16/13.
//  Copyright (c) 2013 Betzerra. All rights reserved.
//

#import "CustomDelegate.h"
#import "MosaicData.h"
#import "MosaicCell.h"

@implementation CustomDelegate

#pragma mark - Private
-(void)loadFromDisk{
    elements = [[NSMutableArray alloc] init];
    
    NSString *pathString = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSData *elementsData = [NSData dataWithContentsOfFile:pathString];
    
    NSError *anError = nil;
    NSArray *parsedElements = [NSJSONSerialization JSONObjectWithData:elementsData
                                                              options:NSJSONReadingAllowFragments
                                                                error:&anError];
    
    for (NSDictionary *aModuleDict in parsedElements){
        MosaicData *aMosaicModule = [[MosaicData alloc] initWithDictionary:aModuleDict];
        [elements addObject:aMosaicModule];
    }
}

#pragma mark - Public

-(id)init{
    self = [super init];
    if (self){
        [self loadFromDisk];
    }
    return self;
}

#pragma mark MosaicDelegate

-(MosaicData *)mosaicDataForIndexPath:(NSIndexPath *)anIndexPath{
    return elements[anIndexPath.row];
}

-(NSUInteger)mosaicElementsCount{
    return [elements count];
}

@end
