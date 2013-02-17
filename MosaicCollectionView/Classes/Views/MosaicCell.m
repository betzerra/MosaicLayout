//
//  MosaicDataView.m
//  MosaicCollectionView
//
//  Created by Ezequiel A Becerra on 2/16/13.
//  Copyright (c) 2013 Betzerra. All rights reserved.
//

#import "MosaicCell.h"
#import "AFNetworking.h"

@implementation MosaicCell

@synthesize image;

#pragma mark - Private

-(void)setup{    
    imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:imageView];
}

-(void)cropImage{
    UIImage *anImage = imageView.image;
    
    //  Cropping algorithm
    CGSize imgFinalSize = CGSizeZero;
    if (anImage.size.width < anImage.size.height){
        imgFinalSize.width = self.bounds.size.width;
        imgFinalSize.height = self.bounds.size.width * anImage.size.height / anImage.size.width;
        
        //  This is to avoid black bars on the bottom and top of the image
        //  Happens when images have its height lesser than its bounds
        if (imgFinalSize.height < self.bounds.size.height){
            imgFinalSize.width = self.bounds.size.height * self.bounds.size.width / imgFinalSize.height;
            imgFinalSize.height = self.bounds.size.height;
        }
    }else{
        imgFinalSize.height = self.bounds.size.height;
        imgFinalSize.width = self.bounds.size.height * anImage.size.width / anImage.size.height;
        
        //  This is to avoid black bars on the left and right of the image
        //  Happens when images have its width lesser than its bounds
        if (imgFinalSize.width < self.bounds.size.width){
            imgFinalSize.height = self.bounds.size.height * self.bounds.size.width / imgFinalSize.height;
            imgFinalSize.width = self.bounds.size.width;
        }
    }
    imageView.frame = CGRectMake(0, 0, imgFinalSize.width, imgFinalSize.height);
    imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}

#pragma mark - Properties

-(UIImage *)image{
    return imageView.image;
}

-(void)setImage:(UIImage *)newImage{
    imageView.image = newImage;
    [self cropImage];
}

-(MosaicData *)mosaicData{
    return mosaicData;
}

-(void)setMosaicData:(MosaicData *)newMosaicData{

    mosaicData = newMosaicData;
    
    if ([mosaicData.imageFilename hasPrefix:@"http://"] ||
        [mosaicData.imageFilename hasPrefix:@"https://"]){
        //  Download image from the web
        void (^imageSuccess)(UIImage *downloadedImage) = ^(UIImage *downloadedImage){
            self.image = downloadedImage;
        };
        
        NSURL *anURL = [NSURL URLWithString:mosaicData.imageFilename];
        NSURLRequest *anURLRequest = [NSURLRequest requestWithURL:anURL];
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:anURLRequest
                                                                                               success:imageSuccess];
        [operation start];
    }else{
        //  Load image from bundle
        self.image = [UIImage imageNamed:mosaicData.imageFilename];
    }
}

#pragma mark - Public

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self setup];
    }
    return self;
}

@end
