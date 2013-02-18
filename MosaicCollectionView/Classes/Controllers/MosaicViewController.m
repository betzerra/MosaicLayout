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

#define kHeightModule 40

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

#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.mosaicDelegate mosaicElementsCount];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    MosaicCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.mosaicData = [self.mosaicDelegate mosaicDataForIndexPath:indexPath];
    
    float randomWhite = (arc4random() % 40 + 10) / 255.0;
    cell.backgroundColor = [UIColor colorWithWhite:randomWhite alpha:1];
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"#DEBUG Touched %d", indexPath.row);
}

#pragma mark - Public

-(float)heightForIndexPath:(NSIndexPath *)indexPath withWidth:(float)width{
    int halfWidth = width/2;
    float retVal = width + (arc4random() % halfWidth);
    retVal = retVal - ((int)retVal % kHeightModule);
    return retVal;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self updateColumnsQuantityToInterfaceOrientation:self.interfaceOrientation];
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
    
    [self updateColumnsQuantityToInterfaceOrientation:toInterfaceOrientation];
    MosaicLayout *layout = (MosaicLayout *)self.collectionView.collectionViewLayout;
    [layout invalidateLayout];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    snapshotBeforeRotation.alpha = 0.0;

    snapshotAfterRotation = captureSnapshotOfView(self.collectionView);
    [self.view insertSubview:snapshotAfterRotation belowSubview:snapshotBeforeRotation];
    self.collectionView.alpha = YES;
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
