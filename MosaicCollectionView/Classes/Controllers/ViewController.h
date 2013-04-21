//
//  ViewController.h
//  MosaicCollectionView
//
//  Created by Ezequiel A Becerra on 4/21/13.
//  Copyright (c) 2013 Betzerra. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController{
    __weak IBOutlet UICollectionView *_collectionView;
}

- (IBAction)addButtonPressed:(id)sender;

@end
