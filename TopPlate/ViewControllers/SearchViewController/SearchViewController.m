//
//  SearchViewController.m
//  TopPlate
//
//  Created by Viacheslav Pryimachenko on 4/12/18.
//  Copyright © 2018 Enke. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchTableViewCell.h"

#import "PlateInfoViewController.h"

@interface SearchViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet TPTextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic, strong) NSArray *searchPlateResults;
@property (nonatomic, strong) PlateModelHelper *plateModelHelper;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewButtomOffset;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.plateModelHelper = [modelsManager getModel:HelperTypePlates];
    
    UIButton *searchTextFieldButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.searchTextField.height, self.searchTextField.height)];
    [searchTextFieldButton setImage:[UIImage imageNamed:@"SearchIcon"] forState:UIControlStateNormal];
    self.searchTextField.type = TextFieldTypeLeftViewImage;
    self.searchTextField.leftView = searchTextFieldButton;
    [searchTextFieldButton addTarget:self action:@selector(searchPlates) forControlEvents:UIControlEventTouchUpInside];
    
    self.searchTextField.delegate = self;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    
    [self setNavigationTitleViewImage];

    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource -

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.searchPlateResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlateModel *model = self.searchPlateResults[indexPath.row];
    
    SearchTableViewCell *searchTableViewCell = [tableView dequeueReusableCellWithIdentifier:@"SearchTableViewCell" forIndexPath:indexPath];
    [searchTableViewCell setupCellWithModel:model];
    [searchTableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return searchTableViewCell;
}

#pragma mark - UITableViewDelegate -

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlateModel *model = self.searchPlateResults[indexPath.row];
    [self loadPlateWithId:model.plateId];
}

#pragma mark - UITextFieldDelegate -

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self searchPlates];
    
    return NO;
}

#pragma mark - API Requests -

-(void)searchPlates {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.plateModelHelper searchPlatesWithSearchString:self.searchTextField.text completion:^(NSArray *searchResults, NSString *errorString) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if (errorString) {
            [Helper showErrorMessage:errorString forViewController:self];
        } else {
            self.searchPlateResults = [NSArray arrayWithArray:searchResults];
            [self.tableview reloadData];
        }
        
        [self.searchTextField resignFirstResponder];
    }];
}

-(void)loadPlateWithId:(NSString *)plateId {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.plateModelHelper getPlateWithId:plateId
           completionBlock:^(PlateModel *plate, NSString *errorString) {
               [MBProgressHUD hideHUDForView:self.view animated:YES];
               
               if (plate && !errorString) {
                   
                   UIStoryboard *plateStoryboard = [UIStoryboard storyboardWithName:@"Plates" bundle:nil];
                   PlateInfoViewController *plateInfoViewController = [plateStoryboard instantiateViewControllerWithIdentifier:@"PlateInfoViewController"];
                   plateInfoViewController.selectedPlate = plate;
                   [self.navigationController pushViewController:plateInfoViewController animated:YES];
               }
           }];
}

#pragma mark - Keyboard Notification -

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)unregisterFromKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWasShown:(NSNotification *)notification {
    
    NSDictionary* info = [notification userInfo];
    
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    
    self.tableViewButtomOffset.constant -= (keyboardRect.size.height);
}

- (void)keyboardWillBeHidden:(NSNotification*)notification {
    
    NSDictionary* info = [notification userInfo];
    
    CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    
    self.tableViewButtomOffset.constant += (keyboardRect.size.height + window.safeAreaInsets.bottom / 2);
}

@end
