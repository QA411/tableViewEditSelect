//
//  KTCapListTableViewCell.m
//  Client
//
//  Created by qq on 2017/4/25.
//  Copyright © 2017年 qq. All rights reserved.
//

#import "KTCapListTableViewCell.h"

@implementation KTCapListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)clickOnDel:(id)sender {
    if (self.isClickDelBtnBlock) {
        self.isClickDelBtnBlock(self);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
