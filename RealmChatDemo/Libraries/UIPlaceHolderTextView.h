//
//  UIPlaceHolderTextView.h
//  Fabcurat
//
//  Created by Brijesh on 13/05/19.
//  Copyright © 2019 NextGen IT Devs. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE

@interface UIPlaceHolderTextView : UITextView
@property (nonatomic, retain) IBInspectable NSString *placeholder;
@property (nonatomic, retain) IBInspectable UIColor *placeholderColor;
@property (nonatomic, retain) UILabel *placeHolderLabel;

-(void)textChanged:(NSNotification*)notification;
@end
