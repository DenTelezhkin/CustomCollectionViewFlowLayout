//
//  HorizontalCollectionViewLayout.h
//  CommandCenter-iPad
//
//  Created by Denys Telezhkin on 2/8/13.
//  Copyright (c) 2013 MLSDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic,copy) NSString * cellKind;

@property (nonatomic,assign) BOOL hasHeaders;
@property (nonatomic,assign) BOOL hasFooters;

// This method need to be subclassed for layout to work
-(CGRect)frameForItemAtIndexPath:(NSIndexPath *)indexPath;

// This method need to be subclassed for layout to work
// This will be called only if hasHeaders or hasFooters value will be set to YES
-(CGRect)frameForSupplementaryViewOfKind:(NSString *)kind
                             atIndexPath:(NSIndexPath *)indexPath;

// This method need to be subclassed for layout to work
-(CGSize)collectionViewContentSize;
@end
