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

#define kDoubleColumnProbability 40

@interface ViewController ()
@end

@implementation ViewController

#pragma mark - Public

- (void)viewDidLoad{
    [super viewDidLoad];
    [(MosaicLayout *)_collectionView.collectionViewLayout setDelegate:self];
    
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

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

    MosaicLayout *layout = (MosaicLayout *)_collectionView.collectionViewLayout;
    [layout invalidateLayout];
}

#pragma mark - MosaicLayoutDelegate

-(float)collectionView:(UICollectionView *)collectionView relativeHeightForItemAtIndexPath:(NSIndexPath *)indexPath doubleColumn:(BOOL)isDoubleColumn{
    
    float retVal = 1.0;
    
    if (isDoubleColumn){
        retVal = 0.75;
    }
    
    return retVal;
}

-(BOOL)collectionView:(UICollectionView *)collectionView isDoubleColumnAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *elements = [(CustomDataSource *)_collectionView.dataSource elements];
    MosaicData *aMosaicModule = [elements objectAtIndex:indexPath.row];
    
    if (aMosaicModule.layoutType == kMosaicLayoutTypeUndefined){
        
        /*  First layout. We have to decide if the MosaicData should be
         *  double column (if possible) or not. */
        
        NSUInteger random = arc4random() % 100;
        if (random < kDoubleColumnProbability){
            aMosaicModule.layoutType = kMosaicLayoutTypeDouble;
        }else{
            aMosaicModule.layoutType = kMosaicLayoutTypeSingle;
        }
    }
    
    BOOL retVal = aMosaicModule.layoutType == kMosaicLayoutTypeDouble;
    
    return retVal;
    
}

-(NSUInteger)numberOfColumnsInCollectionView:(UICollectionView *)collectionView{
    
    UIDeviceOrientation anOrientation = [UIDevice currentDevice].orientation;
    
    //  Set the quantity of columns according of the device and interface orientation
    NSUInteger retVal = 0;
    if (UIInterfaceOrientationIsLandscape(anOrientation)){
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
            retVal = kColumnsiPadLandscape;
        }else{
            retVal = kColumnsiPhoneLandscape;
        }
        
    }else{
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
            retVal = kColumnsiPadPortrait;
        }else{
            retVal = kColumnsiPhonePortrait;
        }
    }
    
    return retVal;
}

@end
