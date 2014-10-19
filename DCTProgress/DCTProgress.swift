//
//  DCTProgress.swift
//  DCTProgress
//
//  Created by Daniel Tull on 08/09/2014.
//  Copyright (c) 2014 Daniel Tull. All rights reserved.
//

import Foundation


enum DCTProgressPriority {
	case VeryLow
	case Low
	case Medium
	case High
	case VeryHigh
}


class DCTProgress: NSProgress {

	var priorityChangeHandler: () -> Void = {}

	var priority: DCTProgressPriority = .Medium {
		didSet {
			priorityChangeHandler()
		}
	}

	let priorityString = "priority"
	let observingContext = UnsafeMutablePointer<()>()
	var parent: NSProgress? {
		willSet {
			parent?.removeObserver(self, forKeyPath:priorityString, context:observingContext)
		}
		didSet {
			parent?.addObserver(self, forKeyPath:priorityString, options:NSKeyValueObservingOptions.New, context:observingContext)
		}
	}

	// MARK - NSObject
//	UnsafeMutableBufferPointer pointer = UnsafeMutableBufferPointer()
	override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<Void>) {
		switch (context, keyPath) {
			case(observingContext, priorityString):
				println("Priority changed: \(priority)")

			default:
				super.observeValueForKeyPath(keyPath, ofObject:object, change:change, context:context)
		}
	}

	override init(parent: NSProgress?, userInfo: [NSObject : AnyObject]?) {
		super.init(parent:parent, userInfo:userInfo)
		self.parent = parent

		if let progress = parent as? DCTProgress {
			self.priority = progress.priority
		}
	}

	deinit {
		parent = nil
	}

}


//
//  BNDProgress.h
//  BBCNewsData
//
//  Created by Daniel Tull on 16.06.2014.
//  Copyright (c) 2014 BBC. All rights reserved.
//

//@import Foundation;
//
//typedef NS_ENUM(NSInteger, BNDProgressPriority) {
//	BNDProgressPriorityVeryLow,
//	BNDProgressPriorityLow,
//	BNDProgressPriorityMedium,
//	BNDProgressPriorityHigh,
//	BNDProgressPriorityVeryHigh,
//
//	BNDProgressPriorityPrefetchImage,
//	BNDProgressPriorityPrefetchContent,
//
//	BNDProgressPriorityOffscreenImage,
//	BNDProgressPriorityOffscreenContent,
//
//	BNDProgressPriorityOnscreenImage,
//	BNDProgressPriorityOnscreenContent,
//
//	BNDProgressPriorityPolicy
//};
//
//@interface BNDProgress : NSProgress
//
//+ (BNDProgress *)progressWithTotalUnitCount:(int64_t)unitCount;
//
//@property (nonatomic) BNDProgressPriority priority;
//
//@property (copy) void (^priorityChangeHandler)(BNDProgressPriority priorty);
//
//@end
//
//
//
////
////  BNDProgress.m
//  BBCNewsData
//
//  Created by Daniel Tull on 16.06.2014.
//  Copyright (c) 2014 BBC. All rights reserved.
//

//#import "BNDProgress.h"
//
//static void *BNDProgressPriorityContext = &BNDProgressPriorityContext;
//static NSString *const BNDProgressPriorityKey = @"priority";
//static NSString *const BNDProgressDeallocatedKey = @"deallocated";
//
//@interface BNDProgress ()
//@property (nonatomic) BOOL deallocated;
//@property (nonatomic, assign) BNDProgress *parentProgress;
//@end
//
//@implementation BNDProgress
//
//+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
//	if ([key isEqualToString:BNDProgressPriorityKey]) return YES;
//	if ([key isEqualToString:BNDProgressDeallocatedKey]) return YES;
//
//	return [super automaticallyNotifiesObserversForKey:key];
//	}
//
//	- (void)dealloc {
//		NSLog(@"%@:%@", self, NSStringFromSelector(_cmd));
//		self.deallocated = YES;
//		self.parentProgress = nil;
//		}
//
//		+ (BNDProgress *)progressWithTotalUnitCount:(int64_t)unitCount {
//			return (BNDProgress *)[super progressWithTotalUnitCount:unitCount];
//			}
//
//			- (instancetype)initWithParent:(NSProgress *)parentProgress userInfo:(NSDictionary *)userInfo {
//
//				self = [super initWithParent:parentProgress userInfo:userInfo];
//				if (!self) return nil;
//
//				if ([parentProgress isKindOfClass:[BNDProgress class]]) {
//					self.parentProgress = (BNDProgress *)parentProgress;
//					_priority = self.parentProgress.priority;
//				} else {
//					_priority = BNDProgressPriorityMedium;
//				}
//
//				return self;
//				}
//
//				- (void)setParentProgress:(BNDProgress *)parentProgress {
//					[_parentProgress removeObserver:self forKeyPath:BNDProgressPriorityKey context:BNDProgressPriorityContext];
//					[_parentProgress removeObserver:self forKeyPath:BNDProgressDeallocatedKey context:BNDProgressPriorityContext];
//					_parentProgress = parentProgress;
//					[_parentProgress addObserver:self forKeyPath:BNDProgressPriorityKey options:NSKeyValueObservingOptionNew context:BNDProgressPriorityContext];
//					[_parentProgress addObserver:self forKeyPath:BNDProgressDeallocatedKey options:NSKeyValueObservingOptionNew context:BNDProgressPriorityContext];
//					}
//
//					- (void)setPriority:(BNDProgressPriority)priority {
//
//						if (_priority == priority) return;
//
//						_priority = priority;
//						if (self.priorityChangeHandler) self.priorityChangeHandler(_priority);
//						}
//
//						- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
//
//							if (context != BNDProgressPriorityContext) {
//								[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//								return;
//							}
//
//							if ([keyPath isEqualToString:BNDProgressPriorityKey]) {
//								self.priority = self.parentProgress.priority;
//								return;
//							}
//
//							if ([keyPath isEqualToString:BNDProgressDeallocatedKey] && self.parentProgress.deallocated) {
//								self.parentProgress = nil;
//							}
//							}
//							
//							- (NSString *)description {
//								return [NSString stringWithFormat:@"<%@: %p; %@ = %@>",
//								NSStringFromClass([self class]),
//								self,
//								NSStringFromSelector(@selector(fractionCompleted)), @(self.fractionCompleted)];
//							}
//							
//@end
