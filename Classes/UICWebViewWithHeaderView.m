//
//  UICWebViewWithHeaderView.m
//  WebViewScrollTracker
//
//  Created by Joel Sanderson on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UICWebViewWithHeaderView.h"


@implementation UICWebViewWithHeaderView

@synthesize webView;
@synthesize webScrollView;
@synthesize oldScrollViewDelegate;



-(void) setup {
	
	// defaults
	self->headerViewHeight = 0;
	self->footerViewHeight = 0;
	
	// create webview
	self.webView = [[[UIWebView alloc] init] autorelease];
	self.webView.delegate = self;
	[self addSubview:self.webView];
	
	self.webView.frame = CGRectMake(0, 0, 320, 416);
	
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
		[self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
    if (self) {
        
		[self setup];
    }
    return self;
}

-(id)init {
	self = [super init];
    if (self) {
        
		[self setup];
    }
    return self;
}

- (void)dealloc {
	
	self.headerView = nil;
	self.footerView = nil;
	self.oldScrollViewDelegate = nil;
	self.webScrollView = nil;
	self.webView = nil;
	
    [super dealloc];
}

-(void) layoutHeaderAndFooterViews {
	
	if (self.webScrollView) {
		
		// get my frame size
		CGRect rcSelf = [self frame];
		
		// get scroll info
		CGPoint offset = self.webScrollView.contentOffset;
		CGSize contentSize = self.webScrollView.contentSize;
		
		// zoom info
		float maxZoomScale = self.webScrollView.maximumZoomScale;
		float currentZoomScale = self.webScrollView.zoomScale;
		float scaledBodyHeight = self->actualContentHeight / maxZoomScale * currentZoomScale;
		
		// set content height
		contentSize.height = scaledBodyHeight;
		self.webScrollView.contentSize = contentSize;
		
		if (self.headerView) {
			// position the header
			CGRect rcHeader = self.headerView.frame;
			rcHeader.origin.y = 0 - rcHeader.size.height;
			if (offset.x < 0)
				rcHeader.origin.x = 0;
			else if (offset.x > contentSize.width - rcSelf.size.width)
				rcHeader.origin.x = contentSize.width - rcSelf.size.width;
			else
				rcHeader.origin.x = offset.x;
			rcHeader.size.width = rcSelf.size.width;
			rcHeader.size.height = self->headerViewHeight;
			self.headerView.frame = rcHeader;
		}
		
		if (self.footerView) {
			
			// position the footer
			CGRect rcFooter = self.footerView.frame;
			//rcFooter.origin.y = contentSize.height;
			rcFooter.origin.y = scaledBodyHeight;
			if (offset.x < 0)
				rcFooter.origin.x = 0;
			else if (offset.x > contentSize.width - rcSelf.size.width)
				rcFooter.origin.x = contentSize.width - rcSelf.size.width;
			else
				rcFooter.origin.x = offset.x;
			rcFooter.size.width = rcSelf.size.width;
			rcFooter.size.height = self->footerViewHeight;
			self.footerView.frame = rcFooter;
		}
		
		
	}
}

-(void) layoutSubviews {

		
	// set content inset on scrollview
	if (self.webScrollView) {
		
		self.webView.frame = CGRectMake(0,
										0, 
										self.frame.size.width,
										self.frame.size.height);
	}
	else {
		// set frame of web control
		if (self.webView) {
			self.webView.frame = CGRectMake(0, 
											self->headerViewHeight, 
											self.frame.size.width, 
											self.frame.size.height - self->footerViewHeight);
		}
	}
	[self layoutHeaderAndFooterViews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/



-(void) setHeaderView:(UIView *)view {
	[self->headerView release];
	self->headerView = [view retain];
	
	[self.headerView removeFromSuperview]; 
	[self.webScrollView addSubview:self.headerView];
	[self setNeedsLayout];
}

-(UIView*) headerView {
	return self->headerView;
}

-(void) setFooterView:(UIView *)view {
	[self->footerView release];
	self->footerView = [view retain];
	
	[self.footerView removeFromSuperview]; 
	[self.webScrollView addSubview:self.footerView];
	[self setNeedsLayout];
}

-(UIView*) footerView {
	return self->footerView;
}

-(void) setHeaderViewHeight:(float)height {
	self->headerViewHeight = height;
	[self setNeedsLayout];
}

-(float) headerViewHeight {
	return self->headerViewHeight;
}

-(void) setFooterViewHeight:(float)height {
	self->footerViewHeight = height;
	[self setNeedsLayout];
}

-(float) footerViewHeight {
	return self->footerViewHeight;
}

#pragma mark UIWebViewDelegate 

-(void) webViewDidFinishLoad:(UIWebView *)webView {
	
	// get the scrollview from it
	for (UIView *subview in self.webView.subviews) {
		//NSLog(@"subview is type %@", [subview.class description]);
		
		if ([[subview.class description] compare:@"UIScrollView"] == NSOrderedSame) {
			//NSLog(@"%@", @"Found UIScrollView");
			
			self.webScrollView = (UIScrollView*)subview;
			
			// save reference to old delegate and assign new one
			self.oldScrollViewDelegate = self.webScrollView.delegate;
			self.webScrollView.delegate = self;
			
			if (self.headerView) {
				// readd the header control so it stays on top
				[self.headerView removeFromSuperview]; 
				[self.webScrollView addSubview:self.headerView];
			}
			
			if (self.footerView) {
				// readd the header control so it stays on top
				[self.footerView removeFromSuperview]; 
				[self.webScrollView addSubview:self.footerView];
			}
			
			// get the actual content size of the body
			self->actualContentHeight = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
			if (self->actualContentHeight < 1.0) {
				self->actualContentHeight = self.frame.size.height - self->headerViewHeight - self->footerViewHeight;
			}
			
			self.webScrollView.contentOffset = CGPointMake(0, 0-self->headerViewHeight);
			self.webScrollView.contentInset = UIEdgeInsetsMake(self->headerViewHeight, 0, self->footerViewHeight, 0);
		}
		
	}
	
	[self setNeedsLayout];
}

#pragma mark -
#pragma mark UIScrollViewDelegate

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
	//NSLog(@"scrollViewDidScroll");
	
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
		//NSLog(@"forwarding scrollViewDidScroll");
		[self->oldScrollViewDelegate scrollViewDidScroll:scrollView];
	}
	
	
	[self layoutHeaderAndFooterViews];
}

-(void) scrollViewDidZoom:(UIScrollView *)scrollView {
	//NSLog(@"scrollViewDidZoom");
	
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
		//NSLog(@"forwarding scrollViewDidZoom");
		[self->oldScrollViewDelegate scrollViewDidZoom:scrollView];
	}
	
	[self layoutHeaderAndFooterViews];
	
	//NSLog(@"zoomScale: %f", scrollView.zoomScale);
	//scrollView.zoomScale = 2.0;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
		//NSLog(@"forwarding scrollViewWillBeginDragging");
		[self->oldScrollViewDelegate scrollViewWillBeginDragging:scrollView];
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
		//NSLog(@"forwarding scrollViewDidEndDragging");
		[self->oldScrollViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
	}
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
		//NSLog(@"forwarding scrollViewWillBeginDecelerating");
		[self->oldScrollViewDelegate scrollViewWillBeginDecelerating:scrollView];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
		//NSLog(@"forwarding scrollViewDidEndDecelerating");
		[self->oldScrollViewDelegate scrollViewDidEndDecelerating:scrollView];
	}
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
		//NSLog(@"forwarding scrollViewDidEndScrollingAnimation");
		[self->oldScrollViewDelegate scrollViewDidEndScrollingAnimation:scrollView];
	}
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
		//NSLog(@"forwarding viewForZoomingInScrollView");
		return [self->oldScrollViewDelegate viewForZoomingInScrollView:scrollView];
	}
	else
		return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view  {
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
		//NSLog(@"forwarding scrollViewWillBeginZooming");
		[self->oldScrollViewDelegate scrollViewWillBeginZooming:scrollView withView:view];
	}
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
		//NSLog(@"forwarding scrollViewDidEndZooming");
		[self->oldScrollViewDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
	}
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
		//NSLog(@"forwarding scrollViewShouldScrollToTop");
		return [self->oldScrollViewDelegate scrollViewShouldScrollToTop:scrollView];
	}
	else {
		return NO;
	}
	
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
		//NSLog(@"forwarding scrollViewDidScrollToTop");
		[self->oldScrollViewDelegate scrollViewDidScrollToTop:scrollView];
	}
}

@end
