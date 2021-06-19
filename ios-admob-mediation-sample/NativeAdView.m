/**
 * Copyright 2021 Start.io Inc
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "NativeAdView.h"


@interface NativeAdView ()

@property (nonatomic) BOOL didSetupConstraints;

@end

@implementation NativeAdView

- (instancetype)initWithNativeAd:(GADNativeAd*)ad {
    if (self = [super init]) {
        self.backgroundColor = UIColor.cyanColor;
        self.clipsToBounds = YES;
        
        [self setupSubviewsWithNativeAd:ad];
        
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)setupSubviewsWithNativeAd:(GADNativeAd*)ad {
    self.headlineView = [self createAndAddLabelWithText:ad.headline];
    self.bodyView = [self createAndAddLabelWithText:ad.body];
    self.callToActionView = [self createAndAddLabelWithText:ad.callToAction];
    self.starRatingView = [self createAndAddLabelWithText:[NSString stringWithFormat:@"rating %.1f", ad.starRating.doubleValue]];
    self.starRatingView.hidden = ad.starRating ? NO : YES;
    self.advertiserView = [self createAndAddLabelWithText:ad.advertiser];
    
    let iconView = [[UIImageView alloc] init];
    iconView.translatesAutoresizingMaskIntoConstraints = NO;
    iconView.contentMode = UIViewContentModeScaleAspectFit;
    iconView.userInteractionEnabled = YES;
    iconView.image = ad.icon.image;
    iconView.hidden = ad.icon ? NO : YES;
    [self addSubview:iconView];
    self.iconView = iconView;
    
    let mediaView = [[GADMediaView alloc] init];
    mediaView.translatesAutoresizingMaskIntoConstraints = NO;
    mediaView.contentMode = UIViewContentModeScaleAspectFit;
    mediaView.userInteractionEnabled = YES;
    mediaView.mediaContent = ad.mediaContent;
    [self addSubview:mediaView];
    self.mediaView = mediaView;
    
    self.nativeAd = ad;
}

- (void)updateConstraints {
    if (self.didSetupConstraints == NO) {
        let views = @{
            @"title": self.headlineView,
            @"icon": self.iconView,
            @"description": self.bodyView,
            @"image": self.mediaView,
            @"call2action": self.callToActionView,
            @"sponsored": self.advertiserView,
            @"stars": self.starRatingView
        };
        
        let vfc = @[
            @"H:|-[icon(50)]-[call2action]-[stars]",
            @"H:|-[title]-|",
            @"H:|-[description]-|",
            @"H:|-[image]-|",
            @"H:|-[sponsored]-|",
            @"V:[call2action]-[title]",
            @"V:[stars]-[title]",
            @"V:[icon(50)]-[title]-[description(<=60)]-[image(100)]-[sponsored]-|"
        ];
        
        for (NSString* visualConstraints in vfc) {
            [self addConstraints:
             [NSLayoutConstraint constraintsWithVisualFormat:visualConstraints
                                                     options:0 metrics:nil views:views]];
        }
        
        [[self.heightAnchor constraintEqualToConstant:270] setActive:YES];
        
        self.didSetupConstraints = YES;
    }
    
    [super updateConstraints];
}

- (UILabel*)createAndAddLabelWithText:(nullable NSString*)text {
    UILabel* label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.text = text;
    label.userInteractionEnabled = YES;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.numberOfLines = 0;
    label.hidden = text ? NO : YES;
    [self addSubview:label];
    return label;
}

@end
