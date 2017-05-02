//
//  KTCapListTableViewCell.h
//  Client
//
//  Created by qq on 2017/4/25.
//  Copyright © 2017年 qq. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^KTCapListTableViewCellBlock)(UITableViewCell *cell);

@interface KTCapListTableViewCell : UITableViewCell
@property (nonatomic , copy) KTCapListTableViewCellBlock isClickDelBtnBlock;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *capLabel;
@property (weak, nonatomic) IBOutlet UILabel *timesLabel;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UIButton *delButton;

@end
