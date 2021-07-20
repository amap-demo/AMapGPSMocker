//
//  AGMMockFileListViewController.m
//  AMapGPSMocker
//
//  Created by lly on 2021/7/19.
//

#import "AGMMockFileListViewController.h"

@interface AGMMockFileListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (unsafe_unretained, nonatomic) IBOutlet UITableView *fileListTableView;
@property (nonatomic,copy) NSString *selectedFilePath;

@end

@implementation AGMMockFileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fileListTableView.delegate = self;
    self.fileListTableView.dataSource = self;
}

- (void)setFilePath:(NSArray<NSString *> *)filePath {
    if (_filePath == filePath) {
        return;
    }
    _filePath = [filePath copy];
    [self.fileListTableView reloadData];
}


//MARK: UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filePath.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"fileTableViewCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSString *fileName = self.filePath[indexPath.row].lastPathComponent;
    cell.textLabel.text = fileName;
    return cell;
}

//MARK: UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *filePath = self.filePath[indexPath.row];
    self.selectedFilePath = filePath;
}

- (IBAction)closeBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ensureBtnClicked:(id)sender {
    if (self.selectedFilePath.length > 0) {
        NSLog(@"选中文件：%@",self.selectedFilePath);
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectFileWithPath:)]) {
            [self.delegate selectFileWithPath:self.selectedFilePath];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSLog(@"还没有选中文件");
    }
}

@end
