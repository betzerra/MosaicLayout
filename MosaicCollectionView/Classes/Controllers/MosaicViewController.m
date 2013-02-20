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
    
    // load photo images in the background
    __weak MosaicViewController *weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        MosaicData *data = [self.mosaicDelegate mosaicDataForIndexPath:indexPath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // then set them via the main queue if the cell is still visible.
            if ([weakSelf.collectionView.indexPathsForVisibleItems containsObject:indexPath]) {
                MosaicCell *mosaicCell = (MosaicCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
                mosaicCell.mosaicData = data;
            }
        });
    }];
    
    [self.thumbnailQueue addOperation:operation];
    
    float randomWhite = (arc4random() % 40 + 10) / 255.0;
    cell.backgroundColor = [UIColor colorWithWhite:randomWhite alpha:1];
    return cell;
}

#pragma mark - UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"#DEBUG Touched %d", indexPath.row);
}

#pragma mark - Public



- (void)viewDidLoad{
    [super viewDidLoad];
    self.collectionView.delegate = self;
    
    [self updateColumnsQuantityToInterfaceOrientation:self.interfaceOrientation];
    [(MosaicLayout *)self.collectionView.collectionViewLayout setController:self];    

    self.thumbnailQueue = [[NSOperationQueue alloc] init];
    self.thumbnailQueue.maxConcurrentOperationCount = 3;
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
