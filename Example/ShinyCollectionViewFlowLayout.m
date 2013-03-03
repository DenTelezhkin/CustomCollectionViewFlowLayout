//
//  ShinyCollectionViewFlowLayout.m
//  CustomPositionLayoutExample
//
//  Created by Denys Telezhkin on 01.03.13.
//  Copyright (c) 2013 Denys Telezhkin. All rights reserved.
//

#import "ShinyCollectionViewFlowLayout.h"

@implementation ShinyCollectionViewFlowLayout

-(id)init {
    if (self=[super init]) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setup];
    }
    
    return self;
}

// UICollectionViewLayout is often copied, so we need to have setup method called
// from both init and initWithCoder methods.
- (void)setup
{
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
}

-(int)itemsPerRow
{
    CGFloat insets = self.sectionInset.left +
                     self.sectionInset.right +
                     self.minimumInteritemSpacing+
    self.headerReferenceSize.width +
    self.footerReferenceSize.width;
    
    return (self.collectionView.frame.size.width - insets)/
                        (self.itemSize.width + self.minimumInteritemSpacing);
}


-(int)rowsInSection:(int)section
{
    int itemsInSectionCount = [self.collectionView numberOfItemsInSection:section];

    return ceil(itemsInSectionCount /floor([self itemsPerRow]));
}

-(CGFloat)sectionHeight:(int)section
{
    int rows = [self rowsInSection:section];
    
    CGFloat insets = self.sectionInset.top + self.sectionInset.bottom;
    
    // row height + sections insets top and bottom + spacing between rows
    return (rows * self.itemSize.height)+ insets + (rows-1)*self.minimumLineSpacing;
}

-(CGFloat)collectionViewHeight {
    // All sections
    return [self sectionOriginHeight:([self.collectionView numberOfSections])] +
    [self sectionHeight:[self.collectionView numberOfSections] -1]; // last section
}

-(CGFloat)sectionOriginHeight:(int)sectionNum
{
    CGFloat height = 0;
    for (int section = 0; section<sectionNum;section++)
    {
        height += [self sectionHeight:section];
    }
    return height;
}

-(CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, [self collectionViewHeight]);
}

-(CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Dancing with 0-start numeration,
    // we need row number starting with 1 to correctly calculate rowNumber
    int rowNumber = indexPath.row / floor([self itemsPerRow]);
    
    CGFloat rowOriginHeight = [self sectionOriginHeight:indexPath.section] +
                              self.sectionInset.top +
                              rowNumber * (self.minimumLineSpacing+self.itemSize.height);
    
    int itemNumberInRow = indexPath.row - (rowNumber * [self itemsPerRow]);
    
    CGFloat itemOriginWidth = self.headerReferenceSize.width +
                              self.sectionInset.left +
        itemNumberInRow * (self.itemSize.width + self.minimumInteritemSpacing);
    
    
    CGRect frame = CGRectMake(itemOriginWidth, rowOriginHeight,
                              self.itemSize.width, self.itemSize.height);
    return frame;
}

#define kSectionSeparatotHeight 5

-(CGRect)frameForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightOrigin = [self sectionOriginHeight:indexPath.section];
    CGFloat widthOrigin;
    CGFloat viewWidth;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        widthOrigin = 0;
        viewWidth = self.headerReferenceSize.width;
    }
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        widthOrigin = self.collectionView.frame.size.width
                                                - self.footerReferenceSize.width;
        viewWidth = self.footerReferenceSize.width;
    }
    
    CGRect frame = CGRectMake(widthOrigin,
                              heightOrigin + self.sectionInset.top,
                              viewWidth,
                              [self sectionHeight:indexPath.section]- kSectionSeparatotHeight);
    return frame;
}

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
