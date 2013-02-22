//
//  MosaicDataView.m
//  MosaicCollectionView
//
//  Created by Ezequiel A Becerra on 2/16/13.
//  Copyright (c) 2013 Betzerra. All rights reserved.
//

#import "MosaicCell.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"

#define kLabelHeight 20
#define kLabelMargin 10

@implementation MosaicCell

@synthesize image;

#pragma mark - Private

-(void)setup{
    //  Set image view
    imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:imageView];
    
    //  Added black stroke
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.clipsToBounds = YES;
    
    //  UILabel for title    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.shadowColor = [UIColor blackColor];
    titleLabel.shadowOffset = CGSizeMake(0, 1);
    titleLabel.numberOfLines = 1;
    [self addSubview:titleLabel];
}

-(void)cropImage{
    UIImage *anImage = imageView.image;
    
    if (anImage){
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
}

#pragma mark - Properties

-(UIImage *)image{
    return imageView.image;
}

-(void)setImage:(UIImage *)newImage{
    imageView.image = newImage;
    
    [self cropImage];
    
    if (mosaicData.firstTimeShown){
        mosaicData.firstTimeShown = NO;
        
        imageView.alpha = 0.0;
        
        //  Random delay to avoid all animations happen at once
        float millisecondsDelay = (arc4random() % 700) / 1000.0f;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, millisecondsDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                imageView.alpha = 1.0;
            }];
        });        
    }
}

-(MosaicData *)mosaicData{
    return mosaicData;
}

-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
    imageView.alpha = 0.0;
    [UIView animateWithDuration:0.3 animations:^{
        imageView.alpha = 1.0;
    }];
}

-(void)setMosaicData:(MosaicData *)newMosaicData{

    mosaicData = newMosaicData;
    
    
    //  Image set
    if ([mosaicData.imageFilename hasPrefix:@"http://"] ||
        [mosaicData.imageFilename hasPrefix:@"https://"]){
        //  Download image from the web
        void (^imageSuccess)(UIImage *downloadedImage) = ^(UIImage *downloadedImage){
            
            //  This check is to avoid wrong images on reused cells
            if ([newMosaicData.title isEqualToString:mosaicData.title]){
                self.image = downloadedImage;
            }
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
    
    
    //  Title set
    titleLabel.text = mosaicData.title;
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

-(void)layoutSubviews{
    [super layoutSubviews];
    
    titleLabel.frame = CGRectMake(kLabelMargin,
                                  self.bounds.size.height - kLabelHeight - kLabelMargin,
                                  self.bounds.size.width - kLabelMargin * 2,
                                  kLabelHeight);
    
    [self cropImage];
}

-(void)prepareForReuse{
    [super prepareForReuse];
    self.image = nil;
}

@end
