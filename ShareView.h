//
//  ShareView.h
//  zhizhidemoLEEAlert
//
//  Created by wudezhi on 2017/5/11.
//  Copyright © 2017年 RWUIControls. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  ShareMode, ShareButton;


@interface ShareView : UIView
-(instancetype)initWithFrame:(CGRect)frame
                   InfoArray:(NSArray<ShareMode*>*)infoArray
               MaxLineNumber:(NSInteger)maxLineNumber
              MaxSingleCount:(NSInteger)maxSingleCount;
@end



@interface ShareButton : UIButton
//上下间距
@property (nonatomic , assign) CGFloat range;

+ (ShareButton*)CreateShareButton:(ShareMode*)model;
@end



typedef void (^ButtonTouchEvenBlock)(void);

@interface ShareMode : NSObject
// button文字
@property (nonatomic ,copy) NSString * title;
//文字颜色
@property (nonatomic ,strong) UIColor * titleColor;

//选中／高亮 文字
@property (nonatomic ,copy) NSString * highlightedtitle;
//选中／高亮 文字颜色
@property (nonatomic ,strong)UIColor * highlightedTitleColor;

@property (nonatomic ,strong)UIFont  * titleFont;

@property (nonatomic ,copy) NSString * image;
@property (nonatomic ,copy) NSString * highlightedImage;

//点击事件block
@property (nonatomic ,copy) ButtonTouchEvenBlock  buttonTouchEvenBlock;

-(void)setButtonTouchEvenBlock:(ButtonTouchEvenBlock)buttonTouchEvenBlock;

@end
















