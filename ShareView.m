//
//  ShareView.m
//  zhizhidemoLEEAlert
//
//  Created by wudezhi on 2017/5/11.
//  Copyright © 2017年 RWUIControls. All rights reserved.
//

#import "ShareView.h"
//#import "Masonry.h"
//#import "SDAutoLayout.h"
//#import "LEEAlert.h"

@interface ShareView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSArray<ShareMode*> * infoAarray;

@property (nonatomic, strong) NSMutableArray * buttonArray;

@property (nonatomic, strong) NSMutableArray * pageViewArray;

@end

@implementation ShareView
{

    NSInteger lineMaxNuber; //最大行数
    NSInteger singleMaxCount; //单行最大个数
}


-(void)dealloc{
    
    _scrollView = nil;
    _pageControl = nil;
    _infoAarray = nil;
    _buttonArray= nil;
    _pageViewArray = nil;

}

#pragma mark-  初始化

- (instancetype)initWithFrame:(CGRect)frame InfoArray:(NSMutableArray<ShareMode*> *)infoArray
                MaxLineNumber:(NSInteger)maxLineNumber MaxSingleCount:(NSInteger)maxSingleCount{
    self = [super initWithFrame:frame];
    
    if (self) {
        _infoAarray = [NSArray arrayWithArray:infoArray];
        _buttonArray = [NSMutableArray array];
        _pageViewArray = [NSMutableArray array];
        
        lineMaxNuber = maxLineNumber;
        singleMaxCount = maxSingleCount;
        
        //初始化数据
        [self initDate];
        
        // 初始化子视图
        [self initSubView];
        
        //设置自动布局
        [self configAutoLayout];
    }
    return self;
    
}


-(void)initDate{
    lineMaxNuber = lineMaxNuber > 0 ? lineMaxNuber :2;
    singleMaxCount = singleMaxCount > 0 ? singleMaxCount:3;
}



-(void)initSubView{
    //初始化子视图
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.delegate = self;
    _scrollView.bounces = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];
    
    //初始化pageControl
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    [self addSubview:_pageControl];
    
    //循环初始化分享按钮
    NSInteger index = 0;
    UIView * pageView = nil;
    
    for (ShareMode * model in _infoAarray) {
        //判断是否需要分叶
        if (index % (lineMaxNuber*singleMaxCount) == 0) {
            
            pageView = [[UIView alloc]init];
            [_scrollView addSubview:pageView];
            [_pageViewArray addObject:pageView];
        }
        
        //初始化按钮
        ShareButton * button = [ShareButton CreateShareButton:model];
        
        [pageView addSubview:button];
        [_buttonArray addObject:button];
        
        index++;
    }
    
    //设置总页数
    _pageControl.numberOfPages = _pageViewArray.count > 1? _pageViewArray.count : 0;

}

-(void)configAutoLayout{
    
    //使用SDAutoLayout
    NSInteger lineNumber = ceilf((double)_infoAarray.count/singleMaxCount);//所需行数 小树向上取整
    NSInteger SingleCount = ceilf((double)_infoAarray.count/lineNumber); //单行个数
    SingleCount = SingleCount >= _infoAarray.count ? SingleCount :singleMaxCount; //处理单行个数 最终结果的单行个数
    
    CGFloat buttonWith = self.width/SingleCount;
    CGFloat buttonHeight = 100.0f;
    NSInteger index = 0;
    NSInteger currentPageCounr= 0;
    UIView *pageView = nil;
    
    for (ShareButton * button in  _buttonArray) {
        //判断是否分叶
        
        if (index % (lineMaxNuber*singleMaxCount) == 0) {
            pageView = _pageViewArray[currentPageCounr];
            
            //布局页视图
            if (currentPageCounr == 0) {
                pageView.sd_layout
                .leftSpaceToView(_scrollView,0)
                .topSpaceToView(_scrollView,0)
                .widthIs(self.width)
                .heightIs((lineNumber > lineMaxNuber ? lineMaxNuber:lineNumber)*buttonHeight);
                
//                [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(_scrollView.mas_left);
//                    make.top.equalTo(_scrollView.mas_top);
//                    make.width.equalTo(self.mas_width);
//                    make.height.equalTo(@((lineNumber > lineMaxNuber ? lineMaxNuber:lineNumber)*buttonHeight));
//                }];
                
                
            }else{
                
                pageView.sd_layout
                .leftSpaceToView(_pageViewArray[currentPageCounr-1],0)
                .topSpaceToView(_scrollView,0)
                .widthRatioToView(_pageViewArray[currentPageCounr-1],1)
                .heightRatioToView(_pageViewArray[currentPageCounr-1],1);
                
//                [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(((UIView*)(_pageViewArray[currentPageCounr-1])).mas_left);
//                    make.top.equalTo(_scrollView.mas_top);
//                    make.width.equalTo(self.mas_width);
//                    make.height.equalTo(@((lineNumber > lineMaxNuber ? lineMaxNuber:lineNumber)*buttonHeight));
//                }];
                
                
            }
            currentPageCounr++;
        }
        
        //布局按钮
        if (index == 0) {
//            
            button.sd_layout
            .leftSpaceToView(pageView,0)
            .topSpaceToView(pageView,0)
            .widthIs(buttonWith)
            .heightIs(buttonHeight);
            
//            [button mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(pageView.mas_left);
//                make.top.equalTo(pageView.mas_top);
//                make.width.equalTo(@(buttonWith));
//                make.height.equalTo(@(buttonHeight));
//            }];
            
            
        }else{
            
            if (index % SingleCount == 0) {
                
                //判断是否分叶 如果分叶 重新调整按钮布局参照
                if (index % (lineMaxNuber*singleMaxCount) == 0) {
                    button.sd_layout
                    .leftSpaceToView(pageView,0)
                    .topSpaceToView(pageView,0)
                    .widthIs(buttonWith)
                    .heightIs(buttonHeight);
                    
//                    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.left.equalTo(pageView.mas_left);
//                        make.top.equalTo(pageView.mas_top);
//                        make.width.equalTo(@(buttonWith));
//                        make.height.equalTo(@(buttonHeight));
//                    }];
                    
                }else{
                    button.sd_layout
                    .leftSpaceToView(pageView,0)
                    .topSpaceToView(_buttonArray[index -SingleCount],0)
                    .widthIs(buttonWith)
                    .heightIs(buttonHeight);
                    
//                    [button mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.left.equalTo(pageView.mas_left);
//                        make.top.equalTo(((UIView*)_buttonArray[index- SingleCount]).mas_top);
//                        make.width.equalTo(@(buttonWith));
//                        make.height.equalTo(@(buttonHeight));
//                    }];
                }
                
            }else{
                button.sd_layout
                .leftSpaceToView(_buttonArray[index-1],0)
                .topEqualToView(_buttonArray[index-1])
                .widthIs(buttonWith)
                .heightIs(buttonHeight);
//
//                [button mas_makeConstraints:^(MASConstraintMaker *make) {
//                    make.left.equalTo(((ShareButton*)(_buttonArray[index-1])).mas_left);
//                    make.top.equalTo(((ShareButton*)(_buttonArray[index-1])).mas_top);
//                    make.width.equalTo(@(buttonWith));
//                    make.height.equalTo(@(buttonHeight));
//                }];
                
            }
            
        }
        index ++;
        
    }
    
    //滑动视图
    _scrollView.sd_layout
    .xIs(0)
    .yIs(0)
    .widthRatioToView(self,1)
    .heightRatioToView(_pageViewArray.firstObject,1);
    
    
//    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top);
//        make.left.equalTo(self.mas_left);
//        make.width.equalTo(self.mas_width);
//        make.height.equalTo(((UIView*)(_pageViewArray.lastObject)).mas_height);

//        make.right.equalTo(_pageViewArray.lastObject).offset(0.0f);
//        make.bottom.equalTo(_pageViewArray.lastObject).offset(0.0f);
//    }];

    
    [_scrollView setupAutoContentSizeWithRightView:_pageViewArray.lastObject rightMargin:0.0f];
    [_scrollView setupAutoContentSizeWithBottomView:_pageViewArray.lastObject bottomMargin:0.0f];
    
    
    _pageControl.sd_layout
    .leftEqualToView(self)
    .rightEqualToView(self)
    .topSpaceToView(_scrollView,5.0f)
    .heightIs(10.f);
    
//    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self);
//        make.right.equalTo(self);
//        make.top.equalTo(_scrollView).offset(5.0f);
//        make.height.mas_equalTo(10.f);
//    }];
    
    
    [self setupAutoHeightWithBottomView:_scrollView bottomMargin:0.0f];
    
//    [self mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(_scrollView.mas_bottom);
//        
//    }];
}


#pragma mark- UIScrollViewDeleGate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    self.pageControl.currentPage = scrollView.contentOffset.x /scrollView.width;
}


@end



#pragma mark- -----------分享按钮---------------

@implementation ShareButton

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        _range = 10.0f;
    }
    return self;
}

- (void)setRange:(CGFloat)range{
    _range = range;
    [self layoutSubviews];
}

-(void)layoutSubviews{

    [super layoutSubviews];
    //图片
    CGPoint center  = self.imageView.center;
    center.x = self.frame.size.width/2;
    center.y = self.imageView.frame.size.height/2;
    self.imageView.center = center;
    
    //修正位置
    CGRect imageFrame = [self imageView].frame;
    imageFrame.origin.y = (self.frame.size.height - imageFrame.size.height - self.titleLabel.frame.size.height - _range)/2;
    self.imageView.frame = imageFrame;
    
    //标题
    CGRect titleFrame  = [self titleLabel].frame;
    titleFrame.origin.x =0;
    titleFrame.origin.y = self.imageView.frame.origin.y + self.imageView.frame.size.height+ _range;
    titleFrame.size.width = self.frame.size.width;
    self.titleLabel.frame = titleFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}


+ (ShareButton*)CreateShareButton:(ShareMode*)sharemodel{
    
    ShareButton * button = [ShareButton buttonWithType:UIButtonTypeCustom];
    
    button.titleLabel.font = sharemodel.titleFont;
    
    [button setTitle:sharemodel.title forState:UIControlStateNormal];
    [button setTitleColor:sharemodel.titleColor forState:UIControlStateNormal];
    
    [button setTitle:sharemodel.highlightedtitle forState:UIControlStateHighlighted];
    [button setTitleColor:sharemodel.highlightedTitleColor forState:UIControlStateHighlighted];
    
    [button setImage:[UIImage imageNamed:sharemodel.image] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:sharemodel.highlightedImage] forState:UIControlStateHighlighted];
    
    [button bk_addEventHandler:^(id sender) {
        
        if (sharemodel.buttonTouchEvenBlock) {
            sharemodel.buttonTouchEvenBlock();
        }

    } forControlEvents:UIControlEventTouchUpInside];
    
    
    return button;
    
}
@end


@implementation ShareMode

//初始化设置
-(instancetype)init{
    
    _title = @"";
    _titleColor = [UIColor blackColor];
    
    _highlightedtitle = @"";
    _highlightedTitleColor = [UIColor grayColor];
    
    _image = nil;
    _highlightedImage = nil;
    
    _titleFont = [UIFont systemFontOfSize:14];
    
    _buttonTouchEvenBlock = nil;
    
    return self;
}


-(void)setButtonTouchEvenBlock:(ButtonTouchEvenBlock)buttonTouchEvenBlock{
    _buttonTouchEvenBlock = buttonTouchEvenBlock;
}

@end





























