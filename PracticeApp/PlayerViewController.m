//
//  PlayerViewController.m
//  PracticeApp
//
//  Created by Justin Camerer on 9/3/12.
//  Copyright (c) 2012 Justin Camerer. All rights reserved.
//

#import "PlayerViewController.h"

@implementation PlayerViewController

@synthesize playPauseButton;
@synthesize progress;
@synthesize song;
@synthesize audioPlayback;
@synthesize scrollView;
@synthesize pageControl;

- (void)loadAudio:(Tempo *)tempo
{
  self.audioPlayback = [[AudioPlayback alloc] initWithAudioData:tempo.audioData];
  self.audioPlayback.delegate = self;
  
  isLoading = false;
  [self.audioPlayback playPause];
}

- (void)loadAudioInBackground:(Tempo *)tempo
{
  [self performSelectorInBackground:@selector(loadAudio:) withObject:tempo];
  isLoading = true;
  
  //[self updatePlayhead];
}

- (Tempo *)tempo
{
  return [song.sortedTempos objectAtIndex:pageControl.currentPage];
}

- (void)loadScrollViewWithPage:(int)page
{
  if (page < 0)
    return;
  if (page >= song.tempos.count)
    return;
  
  // replace the placeholder if necessary
  TempoViewController *controller = [tempoViewControllers objectAtIndex:page];
  if ((NSNull *)controller == [NSNull null])
  {
    controller = [[TempoViewController alloc] initWithTempo:[song.sortedTempos objectAtIndex:page]];
    [tempoViewControllers replaceObjectAtIndex:page withObject:controller];
  }
  
  UIView *v1 = [controller view];
  UIView *v2 = v1.superview;
  
  // add the controller's view to the scroll view
  if (v2 == nil)
  {
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    controller.view.frame = frame;
    [self.scrollView addSubview:controller.view];
  }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
  [self loadAudioInBackground:self.tempo];
  
  // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
  // which a scroll event generated from the user hitting the page control triggers updates from
  // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
  if (pageControlUsed)
  {
    // do nothing - the scroll was initiated from the page control, not the user dragging
    return;
  }
	
  // Switch the indicator when more than 50% of the previous/next page is visible
  CGFloat pageWidth = self.scrollView.frame.size.width;
  int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
  self.pageControl.currentPage = page;
  
  self.tempo = [song.sortedTempos objectAtIndex:page];
  
  // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
  [self loadScrollViewWithPage:page - 1];
  [self loadScrollViewWithPage:page];
  [self loadScrollViewWithPage:page + 1];
  
  // A possible optimization would be to unload the views+controllers which are no longer visible
}


- (IBAction)changePage:(id)sender
{
  int page = self.pageControl.currentPage;
	
  // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
  [self loadScrollViewWithPage:page - 1];
  [self loadScrollViewWithPage:page];
  [self loadScrollViewWithPage:page + 1];
  
	// update the scroll view to the appropriate page
  CGRect frame = scrollView.frame;
  frame.origin.x = frame.size.width * page;
  frame.origin.y = 0;
  [scrollView scrollRectToVisible:frame animated:YES];
  
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
  pageControlUsed = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
  pageControlUsed = NO;
}

- (void)viewDidLoad
{
  self.navigationItem.title = song.name;
  
  // view controllers are created lazily
  // in the meantime, load the array with placeholders which will be replaced on demand
  NSMutableArray *controllers = [[NSMutableArray alloc] init];
  for (unsigned i = 0; i < song.tempos.count; i++)
  {
		[controllers addObject:[NSNull null]];
  }
  tempoViewControllers = controllers;
  
  CGFloat f = self.scrollView.frame.size.width;
  
  // a page is the width of the scroll view
  //self.scrollView.pagingEnabled = YES;
  self.scrollView.contentSize = CGSizeMake(f * song.tempos.count, self.scrollView.frame.size.height);
  //self.scrollView.showsHorizontalScrollIndicator = NO;
  //self.scrollView.showsVerticalScrollIndicator = NO;
  //self.scrollView.scrollsToTop = NO;
  //self.scrollView.delegate = self;
  
  
  self.pageControl.numberOfPages = song.tempos.count;
  self.pageControl.currentPage = 0;

  
  // pages are created on demand
  // load the visible page
  // load the page on either side to avoid flashes when the user starts scrolling
  //
  [self loadScrollViewWithPage:0];
  [self loadScrollViewWithPage:1];
  
  
  [self loadAudioInBackground:self.tempo];
}


- (void)updatePlayhead
{
  float percentage = self.audioPlayback.currentTime/(float)self.audioPlayback.duration;
  [self.progress setProgress:percentage];
  
  if (isLoading || [self.audioPlayback isPlaying]) {
    [self performSelector:@selector(updatePlayhead) withObject:nil afterDelay: 0.5f];
  }
}

- (void)playPause
{
  if (!self.audioPlayback) { return; }
  
  [self.audioPlayback playPause];
    
  if (isLoading || [self.audioPlayback isPlaying]) {
    [self updatePlayhead];
  }
}


- (IBAction)playPausePressed:(UIButton*)sender {
  if (self.audioPlayback) {
    [self playPause];
  }
}

- (void)playPauseChanged:(id)sender
{
  if (!self.audioPlayback) {
    return;
  }
  
  if ([self.audioPlayback isPlaying]) {
    [self.playPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
  } else {
    [self.playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
  }
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  if (self.audioPlayback) {
    [self.audioPlayback stop];
  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
