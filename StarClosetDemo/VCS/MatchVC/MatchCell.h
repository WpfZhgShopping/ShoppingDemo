//
//  MatchCell.h
//  StarClosetDemo
//
//  Created by Mac on 16/7/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MatchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *biaoqian;
@property (weak, nonatomic) IBOutlet UILabel *day;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIButton *liftBTN;
@property (weak, nonatomic) IBOutlet UIButton *zhongBTN;
@property (weak, nonatomic) IBOutlet UIButton *rightBTN;

@end
