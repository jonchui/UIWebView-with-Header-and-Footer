//
//  MyWebView.h
//  WebViewScrollTracker
//
//  Created by Joel Sanderson on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICWebViewWithHeaderView.h"

@interface MyWebView : UIViewController <UIWebViewDelegate, UIScrollViewDelegate> {

	id<UIScrollViewDelegate> oldScrollViewDelegate;
	
	IBOutlet UICWebViewWithHeaderView* webViewWithHeader;
	IBOutlet UIButton* header;
	IBOutlet UITextField *footer;
}



@property(nonatomic,retain) IBOutlet UICWebViewWithHeaderView* webViewWithHeader;
@property(nonatomic,retain) UIButton* header;
@property(nonatomic,retain) IBOutlet UITextField *footer;

@end
