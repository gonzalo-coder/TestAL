//
//  ViewControllerWithScrollView.m
//  TestAL
//
//  Created by Castro, Gonzalo on 5/27/15.
//  Copyright (c) 2015 Castro, Gonzalo. All rights reserved.
//

#import "ViewControllerWithScrollView.h"

@interface ViewControllerWithScrollView ()
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *scrollViewBottomConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *contentViewHeightConstraint;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@end

@implementation ViewControllerWithScrollView

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setAutomaticallyAdjustsScrollViewInsets:NO];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
  
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
  [[self view] addGestureRecognizer:tap];
}

- (void)viewDidLayoutSubviews
{
  id topLayoutGuide = [self topLayoutGuide];
  id bottomLayoutGuide = [self bottomLayoutGuide];
  
  CGFloat topLayoutGuideHeight = CGRectGetHeight([topLayoutGuide frame]);
  CGFloat bottomLayoutGuideHeight = CGRectGetHeight([bottomLayoutGuide frame]);
  CGFloat viewHeight = CGRectGetHeight([[self view] bounds]);

  CGFloat contentViewHeight = viewHeight - topLayoutGuideHeight - bottomLayoutGuideHeight;
  [[self contentViewHeightConstraint] setConstant:contentViewHeight];
}

#pragma mark - Actions

- (IBAction)doneAction:(id)sender
{
  [self.view endEditing:YES];
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissKeyboard:(UITapGestureRecognizer *)recognizer
{
  [[self view] endEditing:YES];
}

#pragma mark - Keyboard Event Handlers

-(void)keyboardWillShow:(NSNotification *)notification
{
  NSDictionary *userInfo = [notification userInfo];
  CGRect keyboardEndFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
  NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
  
  UIView *view = [self view];
  [view layoutIfNeeded];
  
  
  // We go old school so we can use the animation curve provided
  // by the keyboard information.
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:duration];
  [UIView setAnimationCurve:curve];
  [UIView setAnimationBeginsFromCurrentState:YES];
  
  [[self scrollViewBottomConstraint] setConstant:CGRectGetHeight(keyboardEndFrame)];
  
  [view layoutIfNeeded];
  
  [UIView commitAnimations];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
  NSDictionary *userInfo = [notification userInfo];
  NSTimeInterval duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
  UIViewAnimationCurve curve = [userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];

  UIView *view = [self view];
  [view layoutIfNeeded];
  
  
  // We go old school so we can use the animation curve provided
  // by the keyboard information.
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationDuration:duration];
  [UIView setAnimationCurve:curve];
  [UIView setAnimationBeginsFromCurrentState:YES];
  
  [[self scrollViewBottomConstraint] setConstant:0];
  
  [view layoutIfNeeded];
  
  [UIView commitAnimations];
}

@end
