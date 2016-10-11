//
//  NewTableViewCell.m
//  01-QYNews
//
//  Created by qingyun on 16/9/1.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "NewTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSString+statuses.h"
#import "NSDate+String.h"
@interface NewTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end
@implementation NewTableViewCell
-(void)setResultMode:(ResultMode *)resultMode{
    _resultMode = resultMode;
    

    
    NSURL *imageUrl = [NSURL URLWithString:resultMode.thumbnail_pic_s ];
    [_image sd_setImageWithURL:imageUrl placeholderImage:nil];
    _title.text = resultMode.title;
    
     NSDate *date=[_resultMode.date statusesDateWithString];
    
     _date.text =[date stringWithNowDate];

    

}
- (void)awakeFromNib {
    
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
