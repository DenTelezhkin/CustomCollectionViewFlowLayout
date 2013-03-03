//
//  CollectionViewController.m
//  CustomPositionLayoutExample
//
//  Created by Denys Telezhkin on 01.03.13.
//  Copyright (c) 2013 Denys Telezhkin. All rights reserved.
//

#import "CollectionViewController.h"
#import "ShinyCollectionViewFlowLayout.h"

#import "ShinyCollectionViewFlowLayout.h"
@interface CollectionViewController ()

// Sections array. Each section is an array of items
@property (nonatomic,retain) NSMutableArray * sections;

@end

@implementation CollectionViewController

-(void)dealloc {
    self.sections = nil;
    [_collectionView release];
    [_layout release];
    [super dealloc];
}

-(NSMutableArray *)sections {
    if (!_sections)
        _sections = [[NSMutableArray alloc] init];
    return _sections;
}

static NSString * const kCellReuseIdentifier = @"123";
static NSString * const kHeaderReuseIdentifier = @"456";
static NSString * const kFooterReuseIdentifier = @"789";

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:kCellReuseIdentifier];
    
    [self.collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:kHeaderReuseIdentifier];
    
    [self.collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:kFooterReuseIdentifier];

    // This is only done to easily switch between
    // UICollectionViewFlowLayout and ShinyCOllectionViewFlowLayout
    // Simply change layout class in IB and that's it!
    if ([self.layout respondsToSelector:@selector(hasHeaders)])
    {
        ShinyCollectionViewFlowLayout * shinyLayout = (ShinyCollectionViewFlowLayout *)self.layout;
        shinyLayout.hasFooters = YES;
        shinyLayout.hasHeaders = YES;
    }
    
    /* Interface builder fails to set these values in XCode 4.6, don't ask me why*/
    self.layout.itemSize = CGSizeMake(100, 100);
    self.layout.sectionInset = UIEdgeInsetsMake(10, 25, 10, 25);
    
    // header and footer height value is unused in this layout example
    self.layout.headerReferenceSize = CGSizeMake(50, 50);
    self.layout.footerReferenceSize = CGSizeMake(50, 50);
    self.layout.minimumInteritemSpacing = 25;
    self.layout.minimumLineSpacing = 25;
    
    
    [self.sections addObject:@[@"1",@"2",@"3",@"4",@"5",@"6"]];
    [self.sections addObject:@[@"1",@"2",@"3",@"4",@"5",@"6", @"7"]];
    
    [self.collectionView reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.sections count];
}

-(int)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.sections[section] count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseIdentifier
                                                                            forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor lightGrayColor];
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
          viewForSupplementaryElementOfKind:(NSString *)kind
                                atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView * view = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                  withReuseIdentifier:kHeaderReuseIdentifier
                                                         forIndexPath:indexPath];
        view.backgroundColor = [UIColor cyanColor];
    }
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                  withReuseIdentifier:kFooterReuseIdentifier
                                                         forIndexPath:indexPath];
        view.backgroundColor = [UIColor orangeColor];
    }
    return view;
}


@end
