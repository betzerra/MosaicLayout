//
//  MosaicDataView.m
//  MosaicCollectionView
//
//  Created by Ezequiel A Becerra on 2/16/13.
//  Copyright (c) 2013 Betzerra. All rights reserved.
//

#import "MosaicCell.h"

@implementation MosaicCell

#pragma mark - Private

-(void)setup{    
    float randomRed = arc4random() % 255 / 255.0;
    float randomGreen = arc4random() % 255 / 255.0;
    float randomBlue = arc4random() % 255 / 255.0;
    
    self.backgroundColor = [UIColor colorWithRed:randomRed
                                           green:randomGreen
                                            blue:randomBlue
                                           alpha:1.0];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
