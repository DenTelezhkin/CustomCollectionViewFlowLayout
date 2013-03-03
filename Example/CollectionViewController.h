//
//  CollectionViewController.h
//  CustomPositionLayoutExample
//
//  Created by Denys Telezhkin on 01.03.13.
//  Copyright (c) 2013 Denys Telezhkin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewController : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate>
@property (retain, nonatomic) IBOutlet UICollectionView *collectionView;
@property (retain, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;

@end
