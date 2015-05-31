#import "UIFont+SnapAdditions.h"
#import "HostViewController.h"
#import "JoinViewController.h"
#import "GameViewController.h"
#import "IntroduceViewController.h"

@interface MainViewController : UIViewController <HostViewControllerDelegate, JoinViewControllerDelegate, GameViewControllerDelegate, IntroduceViewControllerDelegate>

@end
