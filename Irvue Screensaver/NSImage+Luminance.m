//
//  NSImage+Luminance.m
//  Unsplash Wallpaper
//
//  Created by Игорь Савельев on 06/06/15.
//  Copyright (c) 2015 Leonspok. All rights reserved.
//

#import "NSImage+Luminance.h"
#import "NSImage+Effects.h"
#import <objc/runtime.h>

static NSString *const kCalculatedLuminanceKey = @"CALCULATED LUMINANCE";

@implementation NSImage (Luminance) 

- (CGFloat)luminanceInRect:(NSRect)rect {
	NSNumber *lum = objc_getAssociatedObject(self, &kCalculatedLuminanceKey);
	if (lum) {
		return [lum doubleValue];
	}
	
	CGFloat averageLuminance = 0.5f;
	@autoreleasepool {
		NSBitmapImageRep *rep = [self bitmapImageRepresentation];
		
		int width = [self size].width;
		int height = [self size].height;
		
		CGFloat totalLuminance = 0;
		CGFloat r;
		CGFloat g;
		CGFloat b;
		NSColor *color;
		NSInteger n = 0;
		for (NSInteger i = MIN(MAX(0, rect.origin.y), height); i < MIN(rect.origin.y+rect.size.height, height); i+=10) {
			for (NSInteger j = MIN(MAX(0, rect.origin.x), width); j < MIN(rect.origin.x+rect.size.width, width); j+=10) {
				color = [rep colorAtX:j y:i];
				[color getRed:&r green:&g blue:&b alpha:NULL];
				CGFloat luminance = (0.299*r + 0.587*g + 0.114*b);
				totalLuminance += luminance;
				n++;
			}
		}
		averageLuminance = totalLuminance/n;
	}
	
	objc_setAssociatedObject(self, &kCalculatedLuminanceKey, @(averageLuminance), OBJC_ASSOCIATION_RETAIN);
	return averageLuminance;
}

- (CGFloat)luminance {
	return [self luminanceInRect:NSMakeRect(0, 0, self.size.width, self.size.height)];
}

@end
