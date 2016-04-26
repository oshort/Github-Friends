//
//  RepoTableViewCell.m
//  githubFriends
//
//  Created by Oliver Short on 4/26/16.
//  Copyright © 2016 Oliver Short. All rights reserved.
//

#import "RepoTableViewCell.h"

@implementation RepoTableViewCell


//awake from nib and view did load are kinda the same thing
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor =  [UIColor orangeColor];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor =  [UIColor orangeColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.contentView.backgroundColor = [UIColor blueColor];
    }
    else{self.contentView.backgroundColor =  [UIColor orangeColor];
    }

    // Configure the view for the selected state
}

@end
