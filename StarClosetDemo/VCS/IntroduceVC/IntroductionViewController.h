//
//  IntroductionViewController.h
//  StarClosetDemo
//
//  Created by Mac on 16/7/3.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockTypeDefault.h"
@interface IntroductionViewController : UIViewController
@property (nonatomic,copy) DidSelectedEnter block;
- (void)enterRootVC:(DidSelectedEnter)newBlock;
@end
