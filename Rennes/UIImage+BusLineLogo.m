//
//  UIImage+BusLineLogo.m
//  Rennes
//
//  Created by Adrien Humilière on 30/09/2015.
//  Copyright © 2015 adhumi. All rights reserved.
//

#import "UIImage+BusLineLogo.h"

@implementation UIImage (BusLineLogo)

+ (UIImage *)busLogoForNumber:(NSInteger)number {
	NSString *text = [NSString stringWithFormat:@"%ld", number];
	
	CGRect rect = CGRectMake(0.f, 0.f, 30.f, 60.f);
	CGRect circleRect = CGRectMake(0.f, 15.f, 30.f, 30.f);
	
	UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	UIFont *font = [UIFont boldSystemFontOfSize:16.f];
	
	[[UIColor colorWithRed:0.988f green:0.227f blue:0.345f alpha:1.00f] setFill];
	CGContextFillEllipseInRect(context, circleRect);
	
	CGSize size = [text sizeWithAttributes:@{
											 NSForegroundColorAttributeName: [UIColor yellowColor],
											 NSFontAttributeName: font
											 }];
	CGPoint textOrigin = CGPointMake((rect.size.width - size.width) / 2.f, (rect.size.height - size.height) / 2.f);

	[text drawAtPoint:textOrigin withAttributes:@{
												  NSForegroundColorAttributeName: [UIColor whiteColor],
												  NSFontAttributeName: font
												  }];
	
	CGContextSaveGState(context);
	
	UIImage *generatedImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return generatedImage;
}



@end
