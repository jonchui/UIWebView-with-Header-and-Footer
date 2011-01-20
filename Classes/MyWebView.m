//
//  MyWebView.m
//  WebViewScrollTracker
//
//  Created by Joel Sanderson on 1/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyWebView.h"


@implementation MyWebView

@synthesize webViewWithHeader;
@synthesize header;
@synthesize footer;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	[webViewWithHeader.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://lab.protectedtrust.com"]]];
	webViewWithHeader.webView.scalesPageToFit = YES;
	webViewWithHeader.headerView = header;
	webViewWithHeader.headerViewHeight = 80;
	
	webViewWithHeader.footerView = footer;
	webViewWithHeader.footerViewHeight = 40;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

/*-(void) webViewDidFinishLoad:(UIWebView *)webView {

	// get scroll view
	for (UIView *subview in self.webView.subviews) {
		NSLog(@"subview is type %@", [subview.class description]);
		
		if ([[subview.class description] compare:@"UIScrollView"] == NSOrderedSame) {
			NSLog(@"%@", @"Found UIScrollView");
			
			UIScrollView *scrollView = (UIScrollView*)subview;
			
			self->oldScrollViewDelegate = scrollView.delegate;
			scrollView.delegate = self;
		}
		
		for (UIView *subview2 in subview.subviews) {
			NSLog(@"-%@", [subview2.class description]);
		}
	}
	
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
	NSLog(@"scrollViewDidScroll");
	
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
		NSLog(@"forwarding scrollViewDidScroll");
		[self->oldScrollViewDelegate scrollViewDidScroll:scrollView];
	}
	
	NSLog(@"contentSize: %fx%f", [scrollView contentSize].width, [scrollView contentSize].height);
	NSLog(@"contentOffset: %f, %f", [scrollView contentOffset].x, [scrollView contentOffset].y);
}

-(void) scrollViewDidZoom:(UIScrollView *)scrollView {
	NSLog(@"scrollViewDidZoom");
	
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
		NSLog(@"forwarding scrollViewDidZoom");
		[self->oldScrollViewDelegate scrollViewDidZoom:scrollView];
	}
	
	NSLog(@"zoomScale: %f", scrollView.zoomScale);
	//scrollView.zoomScale = 2.0;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
		NSLog(@"forwarding scrollViewWillBeginDragging");
		[self->oldScrollViewDelegate scrollViewWillBeginDragging:scrollView];
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
		NSLog(@"forwarding scrollViewDidEndDragging");
		[self->oldScrollViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
	}
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
		NSLog(@"forwarding scrollViewWillBeginDecelerating");
		[self->oldScrollViewDelegate scrollViewWillBeginDecelerating:scrollView];
	}
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
		NSLog(@"forwarding scrollViewDidEndDecelerating");
		[self->oldScrollViewDelegate scrollViewDidEndDecelerating:scrollView];
	}
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
		NSLog(@"forwarding scrollViewDidEndScrollingAnimation");
		[self->oldScrollViewDelegate scrollViewDidEndScrollingAnimation:scrollView];
	}
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
		NSLog(@"forwarding viewForZoomingInScrollView");
		return [self->oldScrollViewDelegate viewForZoomingInScrollView:scrollView];
	}
	else
		return nil;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view  {
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
		NSLog(@"forwarding scrollViewWillBeginZooming");
		[self->oldScrollViewDelegate scrollViewWillBeginZooming:scrollView withView:view];
	}
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale {
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
		NSLog(@"forwarding scrollViewDidEndZooming");
		[self->oldScrollViewDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
	}
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
		NSLog(@"forwarding scrollViewShouldScrollToTop");
		return [self->oldScrollViewDelegate scrollViewShouldScrollToTop:scrollView];
	}
	else {
		return NO;
	}

}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
	if ([self->oldScrollViewDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
		NSLog(@"forwarding scrollViewDidScrollToTop");
		[self->oldScrollViewDelegate scrollViewDidScrollToTop:scrollView];
	}
}*/

@end
