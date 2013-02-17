//
//  ViewController.m
//  MosaicCollectionView
//
//  Created by Ezequiel A Becerra on 2/16/13.
//  Copyright (c) 2013 Betzerra. All rights reserved.
//

#import "MosaicViewController.h"
#import "MosaicLayout.h"

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

#pragma mark - Public

-(float)heightForIndexPath:(NSIndexPath *)indexPath{
    float columnWidth = [(MosaicLayout *)self.collectionView.collectionViewLayout columnWidth];
    MosaicData *element = [self.mosaicDelegate mosaicDataForIndexPath:indexPath];
    CGSize imageSize = [[UIImage imageNamed:element.imageFilename] size];
    
    float scale = imageSize.width / columnWidth;
    float retVal = imageSize.height / scale;
    return retVal;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [(MosaicLayout *)self.collectionView.collectionViewLayout setController:self];    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    snapshotBeforeRotation = captureSnapshotOfView(self.collectionView);
    [self.view insertSubview:snapshotBeforeRotation aboveSubview:self.collectionView];
    
    MosaicLayout *layout = (MosaicLayout *)self.collectionView.collectionViewLayout;
    [layout invalidateLayout];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    snapshotAfterRotation = captureSnapshotOfView(self.collectionView);
    
    snapshotBeforeRotation.alpha = 0.0;
    [self.view insertSubview:snapshotAfterRotation belowSubview:snapshotBeforeRotation];
    self.collectionView.hidden = YES;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [snapshotBeforeRotation removeFromSuperview];
    [snapshotAfterRotation removeFromSuperview];
    snapshotBeforeRotation = nil;
    snapshotAfterRotation = nil;
    self.collectionView.hidden = NO;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return YES;
}

@end
