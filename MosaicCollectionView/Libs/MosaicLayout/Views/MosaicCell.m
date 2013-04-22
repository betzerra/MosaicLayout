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

@interface MosaicCell()
-(void)setup;
-(void)cropImage;
@end

@implementation MosaicCell

@synthesize image;

#pragma mark - Private

-(void)setup{
    //  Set image view
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_imageView];
    
    //  Added black stroke
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.clipsToBounds = YES;
    
    //  UILabel for title    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.textAlignment = NSTextAlignmentRight;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.shadowColor = [UIColor blackColor];
    _titleLabel.shadowOffset = CGSizeMake(0, 1);
    _titleLabel.numberOfLines = 1;
    [self addSubview:_titleLabel];
}

-(void)cropImage {
    
    UIImage *anImage = _imageView.image;
    
    if (anImage) {
        
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        _imageView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        _imageView.clipsToBounds = YES;
        
    }
    
}

#pragma mark - Properties

-(UIImage *)image{
    return _imageView.image;
}

-(void)setImage:(UIImage *)newImage{
    _imageView.image = newImage;
    
    [self cropImage];
    
    if (_mosaicData.firstTimeShown){
        _mosaicData.firstTimeShown = NO;
        
        _imageView.alpha = 0.0;
        
        //  Random delay to avoid all animations happen at once
        float millisecondsDelay = (arc4random() % 700) / 1000.0f;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, millisecondsDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                _imageView.alpha = 1.0;
            }];
        });        
    }
}

-(MosaicData *)mosaicData{
    return _mosaicData;
}

-(void)setHighlighted:(BOOL)highlighted{
    
    //  This avoids the animation runs every time the cell is reused
    if (self.isHighlighted != highlighted){
        _imageView.alpha = 0.0;
        [UIView animateWithDuration:0.3 animations:^{
            _imageView.alpha = 1.0;
        }];        
    }
    
    [super setHighlighted:highlighted];    
}

-(void)setMosaicData:(MosaicData *)newMosaicData{

    _mosaicData = newMosaicData;
    
    
    //  Image set
    if ([_mosaicData.imageFilename hasPrefix:@"http://"] ||
        [_mosaicData.imageFilename hasPrefix:@"https://"]){
        //  Download image from the web
        void (^imageSuccess)(UIImage *downloadedImage) = ^(UIImage *downloadedImage){
            
            //  This check is to avoid wrong images on reused cells
            if ([newMosaicData.title isEqualToString:_mosaicData.title]){
                self.image = downloadedImage;
            }
        };
        
        NSURL *anURL = [NSURL URLWithString:_mosaicData.imageFilename];
        NSURLRequest *anURLRequest = [NSURLRequest requestWithURL:anURL];
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:anURLRequest
                                                                                               success:imageSuccess];
        [operation start];
    }else{
        //  Load image from bundle
        self.image = [UIImage imageNamed:_mosaicData.imageFilename];
    }
    
    
    //  Title set
    _titleLabel.text = _mosaicData.title;
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
    
    _titleLabel.frame = CGRectMake(kLabelMargin,
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
