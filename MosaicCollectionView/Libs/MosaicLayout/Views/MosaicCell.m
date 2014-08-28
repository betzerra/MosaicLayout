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
#define kImageViewMargin 10

@interface MosaicCell()
-(void)setupContentView;
-(void)setupImageView;
-(void)setup;
@end

@implementation MosaicCell

@synthesize image;

#pragma mark - Private

-(void)setupContentView{
    //  Set image view
    _contentView = [[UIView alloc] initWithFrame:CGRectZero];
    [_contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    //  Border
    _contentView.layer.borderColor = [UIColor blackColor].CGColor;
    _contentView.layer.borderWidth = 2.0;
    
    //  Shadow
    _contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    _contentView.layer.shadowRadius = 4.0;
    _contentView.layer.shadowOpacity = 0.5;
    _contentView.layer.shadowOffset = CGSizeMake(2, 2);

    [self addSubview:_contentView];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:_contentView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1
                                                                       constant:kImageViewMargin];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:_contentView
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1
                                                                        constant:-kImageViewMargin];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1
                                                                      constant:kImageViewMargin];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:_contentView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1
                                                                         constant:-kImageViewMargin];
    
    NSArray *constraints = @[leftConstraint, rightConstraint, topConstraint, bottomConstraint];
    [self addConstraints:constraints];
}

-(void)setupImageView{
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    
    [_contentView addSubview:_imageView];
    
    NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:_imageView
                                                                      attribute:NSLayoutAttributeLeft
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:_contentView
                                                                      attribute:NSLayoutAttributeLeft
                                                                     multiplier:1
                                                                       constant:0];
    
    NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:_imageView
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:_contentView
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:1
                                                                        constant:0];
    
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_imageView
                                                                     attribute:NSLayoutAttributeTop
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:_contentView
                                                                     attribute:NSLayoutAttributeTop
                                                                    multiplier:1
                                                                      constant:0];
    
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:_imageView
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:_contentView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1
                                                                         constant:0];
    
    NSArray *constraints = @[leftConstraint, rightConstraint, topConstraint, bottomConstraint];
    [_contentView addConstraints:constraints];
}

-(void)setup{
    
    [self setupContentView];
    [self setupImageView];
    
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

#pragma mark - Properties

-(UIImage *)image{
    return _imageView.image;
}

-(void)setImage:(UIImage *)newImage{
    _imageView.image = newImage;
    
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
    
    _imageView.layer.shadowOffset = CGSizeMake(8, 8);
    _imageView.layer.shadowColor = [UIColor redColor].CGColor;
    _imageView.layer.shadowOpacity = 1;
}

-(void)prepareForReuse{
    [super prepareForReuse];
    self.image = nil;
}

@end
