//
//  ViewControllerWithScrollView.m
//  TestAL
//
//  Created by Castro, Gonzalo on 5/27/15.
//  Copyright (c) 2015 Castro, Gonzalo. All rights reserved.
//

#import "ViewControllerWithScrollView.h"

@interface ViewControllerWithScrollView ()
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentViewBottomConstraint;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)doneAction:(id)sender;
@end

@implementation ViewControllerWithScrollView

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneAction:(id)sender
{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary * info = [notification userInfo];
    double duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect kbFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    kbFrame = [self.view convertRect:kbFrame fromView:nil];
    
    //    CGRect adjustedTextFieldFrame = [self.view convertRect:self.homeownerSignup.frame fromView:self.contentView];
    
    [UIView animateWithDuration:duration
                     animations:^{
                         self.contentViewBottomConstraint.constant = kbFrame.size.height;
                     }
                     completion:^(BOOL finished) {
                         CGRect bottom = CGRectMake(0, self.scrollView.contentSize.height - 80, self.scrollView.contentSize.width, 80);
                         [self.scrollView scrollRectToVisible:bottom animated:YES];
                     }];
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary * info = [notification userInfo];
    double duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                     animations:^{
                         self.contentViewBottomConstraint.constant = 0.0;
                     }
                     completion:^(BOOL finished) {
                     }];
}

@end
