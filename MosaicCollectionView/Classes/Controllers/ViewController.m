//
//  ViewController.m
//  MosaicCollectionView
//
//  Created by Ezequiel A Becerra on 4/21/13.
//  Copyright (c) 2013 Betzerra. All rights reserved.
//

#import "ViewController.h"
#import "MosaicLayout.h"
#import "MosaicData.h"
#import "CustomDataSource.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [(MosaicLayout *)_collectionView.collectionViewLayout setColumnsQuantity:3];
    
    /*  This is not very cool. We first set the UICollectionView's dataSource and then
     *  we do the other way around. Doesn't make any sense to set the UICollectionView for the
     *  datasource */
    [(CustomDataSource *)_collectionView.dataSource setCollectionView:_collectionView];
}

- (IBAction)addButtonPressed:(id)sender {
    //  Create MosaicData instance
    MosaicData *aMosaicModule = [[MosaicData alloc] init];
    aMosaicModule.imageFilename = @"http://distilleryimage2.s3.amazonaws.com/655566424edd11e28e7522000a1fbe50_7.jpg";
    aMosaicModule.title = @"Apple";
    
    //  Add that instance to the datasource set
    NSMutableArray *elements = [(CustomDataSource *)_collectionView.dataSource elements];
    [elements addObject:aMosaicModule];
    
    //  After adding it to the datasource, add it to the collection view
    NSIndexPath* newIndexPath = [NSIndexPath indexPathForItem:[elements count] - 1
                                                    inSection:0];
    [_collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]];
    
    NSLog(@"#DEBUG %@", NSStringFromSelector(_cmd));
}

@end
