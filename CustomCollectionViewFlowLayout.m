//
//  HorizontalCollectionViewLayout.m
//  CommandCenter-iPad
//
//  Created by Denys Telezhkin on 2/8/13.
//  Copyright (c) 2013 MLSDev. All rights reserved.
//

#import "CustomCollectionViewFlowLayout.h"
@interface CustomCollectionViewFlowLayout()
@property (nonatomic,retain) NSMutableDictionary * itemLayoutInfo;
@property (nonatomic,retain) NSMutableDictionary * supplementaryLayoutInfo;
@end

@implementation CustomCollectionViewFlowLayout

-(void)dealloc {
    self.cellKind = nil;
    self.itemLayoutInfo = nil;
    self.supplementaryLayoutInfo = nil;
    [super dealloc];
}

-(NSMutableDictionary *)itemLayoutInfo {
    if (!_itemLayoutInfo)
        _itemLayoutInfo = [[NSMutableDictionary alloc] initWithCapacity:3];
    return _itemLayoutInfo;
}

-(NSString *)cellKind {
    if (!_cellKind)
        _cellKind = [@"DefaultCellKind" copy];
    return _cellKind;
}

-(NSMutableDictionary *)supplementaryLayoutInfo {
    if (!_supplementaryLayoutInfo)
        _supplementaryLayoutInfo = [[NSMutableDictionary alloc] init];
    return _supplementaryLayoutInfo;
}

-(void)prepareItemLayout {
    NSMutableDictionary * layoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary * itemLayoutInfo = [NSMutableDictionary dictionary];
    
    NSInteger sectionCount = [self.collectionView numberOfSections];

    for (int section = 0; section < sectionCount;section ++) {
        int itemCount = [self.collectionView numberOfItemsInSection:section];
        
        for (int item = 0; item < itemCount; item++) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes * itemAttributes =
                [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            itemAttributes.frame = [self frameForItemAtIndexPath:indexPath];
            
            itemLayoutInfo[indexPath] = itemAttributes;
        }
    }
    layoutInfo[self.cellKind] = itemLayoutInfo;
    [self.itemLayoutInfo addEntriesFromDictionary:layoutInfo];
}

-(void)prepareSupplementaryViewLayout {
    NSMutableDictionary * supplementaryViewHeaderLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary * supplementaryViewFooterLayoutInfo = [NSMutableDictionary dictionary];
    
    int sectionCount = [self.collectionView numberOfSections];

    for (int section = 0; section < sectionCount; section ++) {
        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
        
        if (self.hasHeaders) {
            UICollectionViewLayoutAttributes * supplementaryAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                           withIndexPath:indexPath];
            supplementaryAttributes.frame = [self frameForSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                      atIndexPath:indexPath];
            
            supplementaryViewHeaderLayoutInfo[indexPath] = supplementaryAttributes;
        }
        if (self.hasFooters) {
            UICollectionViewLayoutAttributes * supplementaryAttributes =
            [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                           withIndexPath:indexPath];
            supplementaryAttributes.frame = [self frameForSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                      atIndexPath:indexPath];
            
            supplementaryViewFooterLayoutInfo[indexPath] = supplementaryAttributes;
        }
    }
    if (self.hasHeaders) {
        [self.supplementaryLayoutInfo setObject:[NSDictionary dictionaryWithDictionary:supplementaryViewHeaderLayoutInfo]
                                         forKey:UICollectionElementKindSectionHeader];
    }
    if (self.hasFooters) {
        [self.supplementaryLayoutInfo setObject:[NSDictionary dictionaryWithDictionary:supplementaryViewFooterLayoutInfo]
                                         forKey:UICollectionElementKindSectionFooter];
    }
    
}

-(void)prepareLayout {
    [self prepareItemLayout];
    [self prepareSupplementaryViewLayout];
}

-(CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath {
    // This method is meant to be subclassed
    return CGRectZero;
}

-(CGRect)frameForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    // This method is meant to be subclassed
    return CGRectZero;
}

-(CGSize)collectionViewContentSize {
    // this method is meant to be subclassed
    return CGSizeZero;
}

-(NSArray *)layoutAttributesForLayoutDictionary:(NSDictionary *)dictionary andRect:(CGRect)rect {

    NSMutableArray *allAttributes = [[NSMutableArray array] retain];
    
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier,
                                                         NSDictionary *elementsInfo,
                                                         BOOL *stop)
    {
        [elementsInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                          UICollectionViewLayoutAttributes *attributes,
                                                          BOOL *innerStop)
        {
            if (CGRectIntersectsRect(rect, attributes.frame)) {
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
    return [allAttributes autorelease];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray * layoutAttributes = [[NSMutableArray alloc] init];
    [layoutAttributes addObjectsFromArray:[self layoutAttributesForLayoutDictionary:self.itemLayoutInfo
                                                                            andRect:rect]];
    if (self.hasHeaders || self.hasFooters)
    {
        [layoutAttributes addObjectsFromArray:[self layoutAttributesForLayoutDictionary:self.supplementaryLayoutInfo
                                                                                andRect:rect]];
    }
    return [layoutAttributes autorelease];
}

-(UICollectionViewLayoutAttributes *) layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.itemLayoutInfo[self.cellKind][indexPath];
}

-(UICollectionViewLayoutAttributes *) layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        return self.supplementaryLayoutInfo[UICollectionElementKindSectionHeader][indexPath];
    }
    if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        return self.supplementaryLayoutInfo[UICollectionElementKindSectionFooter][indexPath];
    }
    
    return nil;
}

@end
