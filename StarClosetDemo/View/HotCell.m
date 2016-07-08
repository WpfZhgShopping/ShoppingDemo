//
//  HotCell.m
//  StarClosetDemo
//
//  Created by Mac on 16/7/7.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "HotCell.h"

@interface HotCell ()
{

    UIView *_bgView;
    UIView *_topView;
    UIImageView *_headImage;
    UIScrollView *_scrollView;
    UILabel *_userLabel;
    UILabel *_tagLabel;
    UIView *_picView;
    UILabel *_nameLabel;
    UILabel *_timeLabel;
    UIView *_shareView;
    UIView *_commentView;
    UILabel *_textLabel;
    float Height;
}
@end

@implementation HotCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createView];
    }
    return self;
}

- (void)createView {
    UIView *bgView =[[UIView alloc]initWithFrame:self.frame];
    [self.contentView addSubview:bgView];
    _bgView =bgView;

    UIView *topView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainBoundsW, 60)];
    [bgView addSubview:topView];
    _topView =topView;
    
    UIImageView*headImage =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
    headImage.layer.cornerRadius=20;
    headImage.layer.masksToBounds=YES;
    [topView addSubview:headImage];
    _headImage=headImage;
    
    UILabel *nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+5, CGRectGetMinY(headImage.frame), 100, 20)];
    nameLabel.font =[UIFont systemFontOfSize:12];
    [topView addSubview:nameLabel];
    _nameLabel=nameLabel;
    
    UILabel *timeLabel =[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(headImage.frame)+5, CGRectGetMaxY(nameLabel.frame), 100, 20)];
    timeLabel.font =[UIFont systemFontOfSize:12];
    [topView addSubview:timeLabel];
    _timeLabel =timeLabel;
    
    UIScrollView *scrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(topView.frame), kMainBoundsW, 300)];
    [bgView addSubview:scrollView];
    _scrollView =scrollView;
    
    UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(scrollView.frame)+5, kMainBoundsW-10, 100)];
    userLabel.numberOfLines=0;
    userLabel.font =[UIFont systemFontOfSize:13];
    [bgView addSubview:userLabel];
    _userLabel=userLabel;
    
    UILabel *tagLabel =[[UILabel alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(userLabel.frame), kMainBoundsW-10, 20)];
    tagLabel.font =[UIFont systemFontOfSize:13];
    [bgView addSubview:tagLabel];
    _tagLabel =tagLabel;
    
    UIView *picView =[[UIView alloc]initWithFrame:CGRectMake(5, CGRectGetMaxY(tagLabel.frame), kMainBoundsW-10, 30)];
    [bgView addSubview:picView];
    _picView =picView;
    
    UIView *commentView =[UIView new];
    [bgView addSubview:commentView];
    _commentView=commentView;
    UILabel *textLabel =[[UILabel alloc]initWithFrame:commentView.frame];
     textLabel.font =[UIFont systemFontOfSize:13];
    [_commentView addSubview:textLabel];
    
    UIView *shareView =[UIView new];
    [bgView addSubview:shareView];
      _shareView =shareView;
    for (int j=0; j<2; j++) {
        UIButton *shareBtn =[UIButton buttonWithType:UIButtonTypeSystem];
        shareBtn.frame =CGRectMake(j*kMainBoundsW/2, 0, kMainBoundsW/2, _shareView.frame.size.height);
        shareBtn.tag=j+1;
        [_shareView addSubview:shareBtn];
    }
    
    }

- (void)setObj:(WHotContentModel *)obj {
    if (_obj !=obj) {
        _obj=obj;
        [self setNeedsLayout];
    }
}


- (void)layoutSubviews {
    static float a=0;
        if (_obj.content) {
        _userLabel.text =_obj.content;
        if (_obj.contentHeight<100) {
            _userLabel.frame =CGRectMake(5, CGRectGetMaxY(_scrollView.frame)+5, kMainBoundsW-10, _obj.contentHeight);
        }
    }
    
    if (_obj.pics.count!=0) {
        for (int i=0; i<_obj.pics.count; i++) {
            UIImageView *imageView =[[UIImageView alloc]initWithFrame:CGRectMake(i*kMainBoundsW, 0, kMainBoundsW, _scrollView.frame.size.height)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:_obj.pics[i]]];
            [_scrollView addSubview:imageView];
        }
        _scrollView.contentSize =CGSizeMake(_obj.pics.count*kMainBoundsW, 0);
    }

    if (_obj.tags.count) {

        if (_obj.tags.count==1) {
            _tagLabel.text =[NSString stringWithFormat:@"标签 #%@",_obj.tags[0]];
        }
        if (_obj.tags.count==2) {
            _tagLabel.text = [NSString stringWithFormat:@"标签 #%@   #%@",_obj.tags[0],_obj.tags[1]];
        }
        if (_obj.tags.count==3) {
            _tagLabel.text = [NSString stringWithFormat:@"标签 #%@   #%@   #%@",_obj.tags[0],_obj.tags[1],_obj.tags[2]];
        }
    }
    
    if (_obj.user) {
        [_headImage sd_setImageWithURL:[NSURL URLWithString:_obj.user.userAvatar] placeholderImage:[UIImage imageNamed:@"icon_information_ok"]];
        _timeLabel.text = _obj.user.datatime;
        _nameLabel.text = _obj.user.username;
    }
    
    if (_obj.users) {

        for (int i=0; i<_obj.users.count; i++) {
            UIImageView *usesImage =[[UIImageView alloc]initWithFrame:CGRectMake(35*i, 0, 30, 30)];
            [usesImage sd_setImageWithURL:[NSURL URLWithString:[_obj.users[i] userAvatar]] placeholderImage:[UIImage imageNamed:@"icon_information_ok"]];
            usesImage.layer.cornerRadius=15;
            usesImage.layer.masksToBounds=YES;
            [_picView addSubview:usesImage];
        }
        
        if (_obj.comments) {
            NSInteger num;
            num = _obj.comments.count>3?3:_obj.comments.count;
            for (int i=0; i<num; i++) {
                a +=[_obj.comments[i] contactHeight];
                _commentView.frame=CGRectMake(5, CGRectGetMaxY(_picView.frame)+5, kMainBoundsW-10, a);
                if (_obj.comments.count==1) {
                    _textLabel.text =[_obj.comments[0]contact];
                }
                if (_obj.comments.count==2) {
                    _textLabel.text =[NSString stringWithFormat:@"%@ %@",[_obj.comments[0]contact],[_obj.comments[1]contact]];
                }
                if (_obj.comments.count==3) {
                    _textLabel.text =[NSString stringWithFormat:@"%@ %@ %@",[_obj.comments[0]contact],[_obj.comments[1]contact],[_obj.comments[2]contact]];
                }

                _shareView.frame = CGRectMake(0, CGRectGetMaxY(_commentView.frame), kMainBoundsW, 40);
              
          }
      }

}
    

    
//    UIButton *shareBtn =[_shareView viewWithTag:1];
//    UIButton *shareBtn2 =[_shareView viewWithTag:2];
//
//    if (_obj.commentCount) {
//        [shareBtn setTitle:_obj.commentCount forState:UIControlStateNormal];
//        [shareBtn2 setTitle:@"分享" forState:UIControlStateNormal];
//    }
  
    
    
    
    
}



- (void)setAllDefault {
    [_bgView removeFromSuperview];
    _bgView=nil;
    [self createView];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
