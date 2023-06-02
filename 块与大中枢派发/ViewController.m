//
//  ViewController.m
//  块与大中枢派发
//
//  Created by zzy on 2023/6/2.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma mark --像函数一样使用块
    int (^myBlock)(int i, int j) = ^int(int i, int j) {
        return i + j;
    };
    int a = myBlock(2,7);
    NSLog(@"%d ", a);
    NSLog(@"%d", myBlock(9, 8));
    //像函数一样使用块
#pragma mark --修改为块所捕获的变量
    NSArray *array = @[@0, @1, @2, @3, @4, @5];
    __block NSInteger count = 0;
    //块作为方法的参数
    [array enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL *stop) {
            if ([number compare:@2] == NSOrderedAscending) {
                count++;
            }
        NSLog(@"%ld====%@",(unsigned long)idx, number);
    }];
    NSLog(@"%ld", (long)count);
    //内联块的用法，传给“numberateObjectsUsingBlock:"方法的块并未先赋给局部变量，而是直接在内联函数中调用了，如果块所捕获的变量类型是对象类型的话，那么就会自动保留它，系统在释放这个块的时候，也会将其一并释放。这就引出了一个与块有关的重要问题，块本身可以视为对象，在其他oc对象能响应的选择子中，很多块也可以响应，最重要的是，块本身也会像其他对象一样，有引用计数，为0时，块就回收了，同时也会释放块所捕获的变量，以便平衡捕获时所执行的保留操作
    //如果块定义在oc类的实例方法中，那么除了可以访问类的所有实例变量之外，还可以使用self变量，块总能修改实例变量，那么除了声明时无需添加__block。不过，如果通过读取或写入操作捕获了实例变量，那么也会自动把self给捕获了，因为实例变量是与self所指代的实例关联在一起的。
    // 需要注意的是(self也是一个对象，也会被保留），如果在块内部使用了实例变量，块会自动对self进行保留操作，以确保在块执行期间保持对象的有效性。但是，如果在块内部直接使用了self，并对其进行读取或写入操作，那么self也会被捕获，从而导致循环引用的问题。为了避免循环引用，可以在块内部使用__weak修饰符来避免对self进行保留操作。

}


@end
