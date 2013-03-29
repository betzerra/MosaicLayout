//
//  ViewController.m
//  MosaicCollectionView
//
//  Created by Ezequiel A Becerra on 2/16/13.
//  Copyright (c) 2013 Betzerra. All rights reserved.
//

#import "MosaicViewController.h"
#import "MosaicLayout.h"
#import "MosaicCell.h"
#import "CustomDataSource.h"

@interface MosaicViewController()
-(void)updateColumnsQuantityToInterfaceOrientation:(UIInterfaceOrientation)anOrientation;
@end

@implementation MosaicViewController

#pragma mark - Private

static UIImageView *captureSnapshotOfView(UIView *targetView){
    UIImageView *retVal = nil;
    
    UIGraphicsBeginImageContextWithOptions(targetView.bounds.size, YES, 0);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    [[targetView layer] renderInContext:currentContext];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    retVal = [[UIImageView alloc] initWithImage:image];
    retVal.frame = [targetView frame];
    
    return retVal;
}

-(void)updateColumnsQuantityToInterfaceOrientation:(UIInterfaceOrientation)anOrientation{
    //  Set the quantity of columns according of the device and interface orientation
    NSUInteger columns = 0;
    if (UIInterfaceOrientationIsLandscape(anOrientation)){
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
            columns = kColumnsiPadLandscape;
        }else{
            columns = kColumnsiPhoneLandscape;
        }
        
    }else{
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
            columns = kColumnsiPadPortrait;
        }else{
            columns = kColumnsiPhonePortrait;
        }
    }
    
    [(MosaicLayout *)self.collectionView.collectionViewLayout setColumnsQuantity:columns];
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"#DEBUG Touched %d", indexPath.row);
}

#pragma mark - Public

- (void)viewDidLoad{
    [super viewDidLoad];
    self.collectionView.delegate = self;
    [(CustomDataSource *)self.collectionView.dataSource setCollectionView:self.collectionView];
    
    [self updateColumnsQuantityToInterfaceOrientation:self.interfaceOrientation];
    [(MosaicLayout *)self.collectionView.collectionViewLayout setController:self];    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    //  Taking a snapshot of the view before rotation to make a smooth transition on rotations
    _snapshotBeforeRotation = captureSnapshotOfView(self.collectionView);
    [self.view insertSubview:_snapshotBeforeRotation aboveSubview:self.collectionView];
    
    /*  Update columns when the device change from portrait to landscape or viceversa.
     *  After setting the columns to MosaicLayout, invalidate the layout to get the new
     *  setup. */
    [self updateColumnsQuantityToInterfaceOrientation:toInterfaceOrientation];
    MosaicLayout *layout = (MosaicLayout *)self.collectionView.collectionViewLayout;
    [layout invalidateLayout];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    _snapshotBeforeRotation.alpha = 0.0;

    _snapshotAfterRotation = captureSnapshotOfView(self.collectionView);
    [self.view insertSubview:_snapshotAfterRotation belowSubview:_snapshotBeforeRotation];
    self.collectionView.alpha = YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [_snapshotBeforeRotation removeFromSuperview];
    [_snapshotAfterRotation removeFromSuperview];
    _snapshotBeforeRotation = nil;
    _snapshotAfterRotation = nil;
    self.collectionView.hidden = NO;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

@end
