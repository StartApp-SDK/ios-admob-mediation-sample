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

@import GoogleMobileAds;
#import "ViewController.h"
#import "NativeAdView.h"

static let kInterstitialId = @"ca-app-pub-4237896427435354/5928825703";
static let kTestInterstitialId = @"ca-app-pub-3940256099942544/4411468910";
static let kBannerId = @"ca-app-pub-4237896427435354/6205826178";
static let kMrecId = @"ca-app-pub-4237896427435354/4075143390";
static let kTestBannerId = @"ca-app-pub-3940256099942544/2934735716";
static let kRewardedId = @"ca-app-pub-4237896427435354/5805359160";
static let kTestRewardedId = @"ca-app-pub-3940256099942544/1712485313";
static let kNativeId = @"ca-app-pub-4237896427435354/8762162164";
static let kTestNativeId = @"ca-app-pub-3940256099942544/3986624511";

@interface ViewController () <GADFullScreenContentDelegate, GADBannerViewDelegate, GADNativeAdLoaderDelegate>

@property (weak, nonatomic) IBOutlet UITextView* messageTextView;
@property (weak, nonatomic) IBOutlet UIButton* showInterstitialButton;
@property (weak, nonatomic) IBOutlet UIButton* showRewardedButton;
@property (weak, nonatomic) IBOutlet UIButton* showNativeButton;

@property (nonatomic, nullable) GADInterstitialAd* interstitial;
@property (nonatomic, nullable) GADRewardedAd* rewarded;
@property (nonatomic, nullable) GADBannerView* bannerView;
@property (nonatomic, nullable) GADAdLoader* nativeLoader;
@property (nonatomic, nullable) GADNativeAd* nativeAd;
@property (nonatomic, nullable) NativeAdView* nativeView;

@property (nonatomic) BOOL needToStrechInlineView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Interstitial

- (IBAction)loadInterstitial:(UIButton*)sender {
    let adRequest = [GADRequest request];
    [GADInterstitialAd loadWithAdUnitID:kInterstitialId
                                request:adRequest
                      completionHandler:^(GADInterstitialAd* _Nullable ad, NSError* _Nullable error) {
        if (error) {
            [self logMessage:[NSString stringWithFormat:@"Failed to load full screen ad: %@", error.localizedDescription]];
            self.showInterstitialButton.enabled = NO;
            return;
        }
        self.interstitial = ad;
        self.interstitial.fullScreenContentDelegate = self;
        self.showInterstitialButton.enabled = YES;
        [self logMessage:@"Full screen ad is loaded."];
    }];
}

- (IBAction)showInterstitial:(UIButton*)sender {
    if (self.interstitial) {
        [self.interstitial presentFromRootViewController:self];
    } else {
        NSLog(@"Ad wasn't ready");
    }
}

#pragma mark - Rewarded

- (IBAction)loadRewarded:(UIButton*)sender {
    let request = [GADRequest request];
    [GADRewardedAd loadWithAdUnitID:kRewardedId
                            request:request
                  completionHandler:^(GADRewardedAd* _Nullable rewardedAd, NSError* _Nullable error) {
        if (error) {
            [self logMessage:[NSString stringWithFormat:@"Failed to load rewarded ad: %@", error.localizedDescription]];
            self.showRewardedButton.enabled = NO;
            return;
        }
        self.rewarded = rewardedAd;
        self.rewarded.fullScreenContentDelegate = self;
        self.showRewardedButton.enabled = YES;
        [self logMessage:@"Rewarded ad is loaded."];
    }];
}

- (IBAction)showRewarded:(UIButton*)sender {
    if (self.rewarded) {
        [self.rewarded presentFromRootViewController:self userDidEarnRewardHandler:^{
            let reward = self.rewarded.adReward;
            [self logMessage:[NSString stringWithFormat:@"Rewarded with %.1f %@", reward.amount.doubleValue, reward.type]];
        }];
    } else {
        NSLog(@"Ad wasn't ready");
    }
}

#pragma mark - Native

- (IBAction)loadNative:(UIButton*)sender {
    self.nativeLoader = [[GADAdLoader alloc]
                initWithAdUnitID:kNativeId
              rootViewController:self
                         adTypes:@[GADAdLoaderAdTypeNative]
                         options:@[]];
    self.nativeLoader.delegate = self;
    
    let request = [GADRequest request];
    [self.nativeLoader loadRequest:request];
}

- (IBAction)showNative:(UIButton*)sender {
    [self cleanBottomEdge];
    
    self.nativeView = [[NativeAdView alloc] initWithNativeAd:self.nativeAd];
    [self addViewStretchedOnBottomEdge:self.nativeView height:270];
    self.showNativeButton.enabled = NO;
}

#pragma mark - Native Loader Delegate

- (void)adLoader:(nonnull GADAdLoader*)adLoader didFailToReceiveAdWithError:(nonnull NSError*)error {
    [self logMessage:[NSStringFromSelector(_cmd) stringByAppendingString:error.localizedDescription]];
    self.showNativeButton.enabled = NO;
}

- (void)adLoaderDidFinishLoading:(nonnull GADAdLoader*)adLoader {
    [self logMessage:NSStringFromSelector(_cmd)];
}

- (void)adLoader:(nonnull GADAdLoader*)adLoader didReceiveNativeAd:(nonnull GADNativeAd*)nativeAd {
    [self logMessage:@"Native ad is loaded."];
    self.showNativeButton.enabled = YES;
    self.nativeAd = nativeAd;
}

#pragma mark - Native Ad Delegate

- (void)nativeAdDidRecordImpression:(GADNativeAd*)nativeAd {
    [self logMessage:NSStringFromSelector(_cmd)];
}

- (void)nativeAdDidRecordClick:(GADNativeAd*)nativeAd {
    [self logMessage:NSStringFromSelector(_cmd)];
}

- (void)nativeAdWillPresentScreen:(GADNativeAd*)nativeAd {
    [self logMessage:NSStringFromSelector(_cmd)];
}

- (void)nativeAdWillDismissScreen:(GADNativeAd*)nativeAd {
    [self logMessage:NSStringFromSelector(_cmd)];
}

- (void)nativeAdDidDismissScreen:(GADNativeAd*)nativeAd {
    [self logMessage:NSStringFromSelector(_cmd)];
}

- (void)nativeAdWillLeaveApplication:(GADNativeAd*)nativeAd {
    [self logMessage:NSStringFromSelector(_cmd)];
}


#pragma mark - Banner

- (IBAction)loadBanner:(UIButton*)sender {
    [self cleanBottomEdge];
    
    self.bannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeFluid];
    self.bannerView.adUnitID = kBannerId;
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
    
    let adRequest = [GADRequest request];
    [self.bannerView loadRequest:adRequest];
    
    self.needToStrechInlineView = YES;
}

#pragma mark - MREC

- (IBAction)loadMREC:(UIButton*)sender {
    [self cleanBottomEdge];
    
    self.bannerView = [[GADBannerView alloc] initWithAdSize:GADAdSizeMediumRectangle];
    self.bannerView.adUnitID = kBannerId;
    self.bannerView.rootViewController = self;
    self.bannerView.delegate = self;
    
    let adRequest = [GADRequest request];
    [self.bannerView loadRequest:adRequest];
    
    self.needToStrechInlineView = NO;
}

#pragma mark - FullScreen Delegate

- (void)adDidRecordImpression:(nonnull id<GADFullScreenPresentingAd>)ad {
    [self logMessage:NSStringFromSelector(_cmd)];
    [self enable:NO showButtonForAd:ad];
}

- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError:(nonnull NSError*)error {
    [self logMessage:NSStringFromSelector(_cmd)];
    [self enable:NO showButtonForAd:ad];
}

- (void)adWillPresentFullScreenContent:(id<GADFullScreenPresentingAd>)ad {
    [self logMessage:NSStringFromSelector(_cmd)];
    [self enable:NO showButtonForAd:ad];
}

- (void)adWillDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    [self logMessage:NSStringFromSelector(_cmd)];
    [self enable:NO showButtonForAd:ad];
}

- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    [self logMessage:NSStringFromSelector(_cmd)];
    [self enable:NO showButtonForAd:ad];
}

#pragma mark - Banner Delegate

- (void)bannerViewDidReceiveAd:(nonnull GADBannerView*)view {
    [self logMessage:NSStringFromSelector(_cmd)];
    if (self.needToStrechInlineView) {
        [self addViewStretchedOnBottomEdge:view height:50];
    } else {
        [self addViewCenteredOnBottomEdge:view];
    }
}

- (void)bannerView:(nonnull GADBannerView*)bannerView didFailToReceiveAdWithError:(nonnull NSError*)error {
    [self logMessage:NSStringFromSelector(_cmd)];
}

- (void)bannerViewDidRecordImpression:(nonnull GADBannerView*)bannerView {
    [self logMessage:NSStringFromSelector(_cmd)];
}

- (void)bannerViewWillPresentScreen:(nonnull GADBannerView*)bannerView {
    [self logMessage:NSStringFromSelector(_cmd)];
}

- (void)bannerViewWillDismissScreen:(nonnull GADBannerView*)bannerView {
    [self logMessage:NSStringFromSelector(_cmd)];
}

- (void)bannerViewDidDismissScreen:(nonnull GADBannerView*)bannerView {
    [self logMessage:NSStringFromSelector(_cmd)];
}

#pragma mark - Utils

- (void)addViewCenteredOnBottomEdge:(UIView*)view {
    [self addViewAnimated:view];
    [NSLayoutConstraint activateConstraints:@[
        [view.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        [view.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor]
    ]];
}

- (void)addViewStretchedOnBottomEdge:(UIView*)view height:(CGFloat)height {
    [self addViewAnimated:view];
    [NSLayoutConstraint activateConstraints:@[
        [view.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [view.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
        [view.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        [view.heightAnchor constraintEqualToConstant:height]
    ]];
}

- (void)addViewAnimated:(UIView*)view {
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:view];
    
    view.alpha = 0;
    [UIView animateWithDuration:1.0 animations:^{
        view.alpha = 1;
    }];
}

- (void)cleanBottomEdge {
    [self.bannerView removeFromSuperview];
    [self.nativeView removeFromSuperview];
}

- (void)logMessage:(nonnull NSString*)message {
    [self.messageTextView insertText:[@"\n" stringByAppendingString:message]];
    let bottom = NSMakeRange(self.messageTextView.text.length - 1, 1);
    [self.messageTextView scrollRangeToVisible:bottom];
    
    NSLog(@"%@", message);
}

- (void)enable:(BOOL)enable showButtonForAd:(nonnull id<GADFullScreenPresentingAd>)ad {
    if (ad == self.interstitial) {
        self.showInterstitialButton.enabled = enable;
    } else if (ad == self.rewarded) {
        self.showRewardedButton.enabled = enable;
    }
}

@end
