//
//  ViewController.m
//  SSO_FG
//
//  Created by April Lee on 2015/10/8.
//  Copyright © 2015年 april. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleOpenSource/GoogleOpenSource.h>

static NSString * const googlePlusClientId = @"Your google client ID";
static NSString * const googleAPIKey =@"Your google API Key";

@interface ViewController ()
@property (strong, nonatomic) IBOutlet FBSDKLoginButton *FBLoginButton;
@property (retain, nonatomic) IBOutlet GPPSignInButton *GoogleLoginButton;
@property (strong, nonatomic) IBOutlet UIButton *GoogleLoginOut;
@property (strong, nonatomic) IBOutlet UIButton *customGoogleLoginOutButton;
@property (strong, nonatomic) IBOutlet UIButton *customFBLoginButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    
    //google
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.clientID = googlePlusClientId;
    signIn.scopes = @[kGTLAuthScopePlusLogin];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.delegate = self;
    
    [signIn trySilentAuthentication];
    
    self.GoogleLoginOut.hidden = YES;
    
    //FB
    [self checkFBAccount];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma FBLogin

- (IBAction)FBLoginButtonPressed:(id)sender {
        [self loginToFB];
}

- (void)loginToFB
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    if ([self.customFBLoginButton.titleLabel.text isEqualToString:@"FB Login"]) {

        [login logInWithReadPermissions:@[@"public_profile"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
            if (error) {
                NSLog(@"error :%@",error.localizedDescription);
            } else if (result.isCancelled) {
                NSLog(@"Cancelled");
            } else {
                NSLog(@"Logged in");
                NSLog(@"currentAccessToken :%@",[FBSDKAccessToken currentAccessToken].tokenString);
                [self refreshFBLoginButton];
            }
        }];
        
    } else {
        [login logOut];
        [self refreshFBLoginButton];
    }
    
}

- (void)checkFBAccount
{
    if ([FBSDKAccessToken currentAccessToken]) {
        [self refreshFBLoginButton];
    }
}

- (void)refreshFBLoginButton
{
    if ([self.customFBLoginButton.titleLabel.text isEqualToString:@"FB LogOut"]) {
        [self.customFBLoginButton setTitle:@"FB Login" forState:UIControlStateNormal];
    } else {
        [self.customFBLoginButton setTitle:@"FB LogOut" forState:UIControlStateNormal];
    }

}

#pragma GooglePlus

- (IBAction)googleLoginOutButtonPressed:(id)sender
{
    [self signOut];
    [self disconnect];
}


- (IBAction)customGooglePlusLoginButtonPressed:(id)sender {
    
    if ([self.customGoogleLoginOutButton.titleLabel.text isEqualToString:@"Google+ LogOut"]) {
        [self signOut];
        [self disconnect];
    } else {
        [self loginToGooglePlus];
    }
}

- (void)refreshInterfaceBasedOnSignIn
{
    BOOL isAuthentcation = false;
    
    if ([[GPPSignIn sharedInstance] authentication])
    {
        isAuthentcation = true;
    }
    self.GoogleLoginOut.hidden = !isAuthentcation;
    self.GoogleLoginButton.hidden = isAuthentcation;
    
    if ([self.customGoogleLoginOutButton.titleLabel.text isEqualToString:@"Google+ LogOut"]) {
        [self.customGoogleLoginOutButton setTitle:@"Google+ Login" forState:UIControlStateNormal];
    } else {
        [self.customGoogleLoginOutButton setTitle:@"Google+ LogOut" forState:UIControlStateNormal];
    }
}

- (void)loginToGooglePlus
{
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.delegate = self;
    
    [signIn authenticate];
}

- (void)signOut {
    [[GPPSignIn sharedInstance] signOut];
}

- (void)disconnect {
    [[GPPSignIn sharedInstance] disconnect];
}

#pragma GoogleSignIn Delegate

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error
{
    if (error) {
        NSLog(@"error message:%@",error.debugDescription);
    } else {
        [self refreshInterfaceBasedOnSignIn];
        
        NSString *authToken = auth.accessToken;
        NSLog(@"Google Access Token :%@",authToken);
    }
}

- (void)didDisconnectWithError:(NSError *)error
{
    if (error) {
        NSLog(@"Received error%@",error);
    } else {
        //Clean up user data.
         [self refreshInterfaceBasedOnSignIn];
    }
}

@end
