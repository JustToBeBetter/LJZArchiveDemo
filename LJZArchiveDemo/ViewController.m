//
//  ViewController.m
//  LJZArchiveDemo
//
//  Created by DBOX on 2017/1/16.
//  Copyright © 2017年 DBOX. All rights reserved.
//

#import "ViewController.h"
#import "LJZUnArchive.h"
#import "LZMAExtractor.h"
#import "SSZipArchive.h"
#import "Unrar4iOS.h"
#import "WebViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initNavbar];
    [self initTable];
}
- (void)initNavbar{
    UIButton *unRarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    unRarBtn.frame = CGRectMake(0, 0, 80, 30);
    [unRarBtn addTarget:self action:@selector(unRarEvent:) forControlEvents:UIControlEventTouchUpInside];
    [unRarBtn setTitle:@"解压rar" forState:UIControlStateNormal];
    [unRarBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    UIButton *unzipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    unzipBtn.frame = CGRectMake(0, 0, 80, 30);
    [unzipBtn addTarget:self action:@selector(unzipPressed:) forControlEvents:UIControlEventTouchUpInside];
    [unzipBtn setTitle:@"解压zip" forState:UIControlStateNormal];
    [unzipBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem1 = [[UIBarButtonItem alloc]initWithCustomView:unRarBtn];
    UIBarButtonItem *rightItem2 = [[UIBarButtonItem alloc]initWithCustomView:unzipBtn];
    self.navigationItem.rightBarButtonItems = @[rightItem1,rightItem2];
    
}
- (void)unRarEvent:(UIButton *)sender{
    [self unRar];
}
- (void)unzipPressed:(UIButton *)sender{
    [self unZip];
}
- (void)initTable{
    _dataArray = [[NSMutableArray alloc]init];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)unArchive: (NSString *)filePath andPassword:(NSString*)password destinationPath:(NSString *)destPath{
    NSAssert(filePath, @"can't find filePath");
    LJZUnArchive *unarchive = [[LJZUnArchive alloc]initWithPath:filePath];
    if (password != nil && password.length > 0) {
        unarchive.password = password;
    }
    
    if (destPath != nil)
        unarchive.destinationPath = destPath;//(Optional). If it is not given, then the file is unarchived in the same location of its archive/file.
    unarchive.completionBlock = ^(NSArray *filePaths){
        NSLog(@"For Archive : %@",filePath);
        
        
        for (NSString *filename in filePaths) {
            NSLog(@"File: %@", filename);
        }
    };
    unarchive.failureBlock = ^(){
        //        NSLog(@"Cannot be unarchived");
    };
    [unarchive decompress];
}

- (void)unZip{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"归档" ofType:@"zip"];
    NSString *destPath = [self tempPath];
    [self unArchiveZip:filePath andPassword:nil destinationPath:destPath];
}

- (void)unRar{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"eclipse" ofType:@"rar"];
    NSString *destPath = [self tempPath];
    [self unArchiveRar:filePath andPassword:nil destinationPath:destPath];
}

- (void)unZip_pwd{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Zip_Example_pwd" ofType:@"zip"];
    NSString *destPath = [self applicationDocumentsDirectory];
    [self unArchive:filePath andPassword:@"LJZUnArchive_ZIP" destinationPath:destPath];
}

- (void)unRar_pwd{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"example_pwd" ofType:@"rar"];
    NSString *destPath = [self applicationDocumentsDirectory];
    [self unArchive:filePath andPassword:@"LJZUnArchive_RAR" destinationPath:destPath];
}

- (void)Unzip7z{
    NSString *archiveFilename = @"example.7z";
    NSString *archiveResPath = [[NSBundle mainBundle] pathForResource:archiveFilename ofType:nil];
    NSAssert(archiveResPath, @"can't find .7z file");
    NSString *destPath = [self applicationDocumentsDirectory];
    [self unArchive:archiveResPath andPassword:nil destinationPath:destPath];
}

- (void)handleFileFromURL:(NSString *)filePath{
    NSLog(@"*********       FILES FROM THE OTHER APPS       *********");
    [self unArchive:filePath andPassword:nil destinationPath:nil];
}
- (NSString *)tempPath {
    NSString *path = [NSString stringWithFormat:@"%@/\%@",
                      NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0],
                      @"123"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtURL:url
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:&error];
    if (error) {
        return nil;
    }
    return url.path;
}
- (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma
#pragma  mark =================tableViewDataSource=================

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *path = [NSString stringWithFormat:@"%@/%@",[self tempPath],_dataArray[indexPath.row]];
    
    WebViewController *zipVc = [[WebViewController alloc]init];
    zipVc.path = path;
    [self.navigationController pushViewController:zipVc animated:YES];

    
}

#pragma
#pragma  mark =================unArchive=================
- (void)unArchiveRar: (NSString *)filePath andPassword:(NSString*)password destinationPath:(NSString *)destPath{
    
    Unrar4iOS *unrar = [[Unrar4iOS alloc] init];
    
    BOOL ok;
    if (password != nil && password.length > 0) {
        @try {
            ok = [unrar unrarOpenFile:filePath withPassword:password];
        }
        @catch(NSException *exception) {
            NSLog(@"exception: %@", exception);
        }
    }
    else{
        ok = [unrar unrarOpenFile:filePath];
    }
    
    if (ok) {
        BOOL extracted = [unrar unrarFileTo:destPath overWrite:YES];
        NSLog(@"extracted : %d",extracted);
        
        NSError *error = nil;
        NSMutableArray<NSString *> *items = [[[NSFileManager defaultManager]
                                              contentsOfDirectoryAtPath:destPath
                                              error:&error] mutableCopy];
        if (error) {
            return;
        }
        NSLog(@"destPath=%@",destPath);
        
        [items enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"obj === %@",obj);
            if (![_dataArray containsObject:obj]) {
                [_dataArray addObject:obj];
            }
            
        }];

//        
//        NSArray *files = [unrar unrarListFiles];
//        for (NSString *filePath in files){
//            if (![_dataArray containsObject:filePath]) {
//                [_dataArray addObject:filePath];
//            }
//        }
        
        //        [self moveFilesToDestinationPathFromCompletePaths:filePathsArray withFilePaths:files];
        [unrar unrarCloseFile];
    }
    else{
       
        [unrar unrarCloseFile];
    }
    [_tableView reloadData];
}
- (void)unArchiveZip: (NSString *)filePath andPassword:(NSString*)password destinationPath:(NSString *)destPath{
    BOOL success = [SSZipArchive unzipFileAtPath:filePath
                                   toDestination:destPath];
    if (!success) {
        return;
    }
    NSError *error = nil;
    NSMutableArray<NSString *> *items = [[[NSFileManager defaultManager]
                                          contentsOfDirectoryAtPath:destPath
                                          error:&error] mutableCopy];
    if (error) {
        return;
    }
    NSLog(@"destPath=%@",destPath);
    
    [items enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"obj === %@",obj);
        if (![_dataArray containsObject:obj]) {
            [_dataArray addObject:obj];
        }
        
    }];
    [_tableView reloadData];

}
@end
