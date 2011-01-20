//
//  UICWebViewWithHeaderView.h
//  WebViewScrollTracker
//
//  Created by Joel Sanderson on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UICWebViewWithHeaderView : UIView<UIWebViewDelegate, UIScrollViewDelegate> {
	
	UIWebView* webView;
	UIScrollView* webScrollView;
	UIView *headerView;
	UIView *footerView;
	//@private id<UIScrollViewDelegate> oldScrollViewDelegate;
	float headerViewHeight;
	float footerViewHeight;
@private float actualContentHeight;
	
}

@property(nonatomic,retain) UIWebView* webView;
@property(nonatomic,retain) UIScrollView* webScrollView;
@property(nonatomic,retain) UIView *headerView;
@property(nonatomic,retain) UIView *footerView;
@property(nonatomic,retain) id<UIScrollViewDelegate> oldScrollViewDelegate;
@property(nonatomic,assign) float headerViewHeight;
@property(nonatomic,assign) float footerViewHeight;

@end
