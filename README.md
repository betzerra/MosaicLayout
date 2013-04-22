# MosaicLayout
This is a very similar UI component to [MosaicUI](https://github.com/betzerra/MosaicUI).

It's using the **Lightbox algorithm** described in @vjeux's blog and taking advantage of **UICollectionView**.  

![Landscape on iPad](http://www.betzerra.com.ar/wp-content/uploads/2013/02/Photo-Feb-17-6-29-14-PM.png)

##Instructions
- Import all the files from Libs/MosaicLayout folder.
- Add a UICollectionView view, change its layout to "Custom" and set its class to "MosaicLayout".
- Implement UICollectionView's delegates.
- Implement **MosaicLayoutDelegate** protocol.

##MosaicLayoutDelegate
```objc
-(float)collectionView:(UICollectionView *)collectionView relativeHeightForItemAtIndexPath:(NSIndexPath *)indexPath;
-(BOOL)collectionView:(UICollectionView *)collectionView isDoubleColumnAtIndexPath:(NSIndexPath *)indexPath;
-(NSUInteger)numberOfColumnsInCollectionView:(UICollectionView *)collectionView;
```

##Requirements
- iOS 6
- ARC

##License
This project is under MIT License. See LICENSE file for more information.
