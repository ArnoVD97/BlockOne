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
    int (^myBlock)(int, int) = ^int(int i, int j) {
        return i + j;
    };
    
    int a = myBlock(2,7);
    NSLog(@"%d ", a);
    NSLog(@"%d", myBlock(9, 8));
    //像函数一样使用块
    //表达式中，return 语句使用的是 count + 1 语句的返回类型。如果表达式中有多个 return 语句，则所有 return 语句的返回值类型必须一致。
//    如果表达式中没有 return 语句，则可以用 void 表示，或者也省略不写。代码如
    ^ void (int count)  { printf("%d\n", count); };    // 返回值类型使用 void
    ^ (int count) { printf("%d\n", count); };    // 省略返回值类型
#pragma mark --修改为块所捕获的变量
    NSArray *array = @[@0, @1, @2, @3, @4, @5];
    __block NSInteger count = 0;
    //块作为方法的参数
    [array enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL *stop) {
            if ([number compare:@2] == NSOrderedAscending) {
                count++;
            }
        NSLog(@"%ld====%@",(unsigned long)idx, number);
        NSLog(@"作为方法的参数");
    }];
    NSLog(@"%ld", (long)count);
    [self useblockAsMethodparameter];
    //内联块的用法，传给“numberateObjectsUsingBlock:"方法的块并未先赋给局部变量，而是直接在内联函数中调用了，如果块所捕获的变量类型是对象类型的话，那么就会自动保留它，系统在释放这个块的时候，也会将其一并释放。这就引出了一个与块有关的重要问题，块本身可以视为对象，在其他oc对象能响应的选择子中，很多块也可以响应，最重要的是，块本身也会像其他对象一样，有引用计数，为0时，块就回收了，同时也会释放块所捕获的变量，以便平衡捕获时所执行的保留操作
    //如果块定义在oc类的实例方法中，那么除了可以访问类的所有实例变量之外，还可以使用self变量，块总能修改实例变量，那么除了声明时无需添加__block。不过，如果通过读取或写入操作捕获了实例变量，那么也会自动把self给捕获了，因为实例变量是与self所指代的实例关联在一起的。
    // 需要注意的是(self也是一个对象，也会被保留），如果在块内部使用了实例变量，块会自动对self进行保留操作，以确保在块执行期间保持对象的有效性。但是，如果在块内部直接使用了self，并对其进行读取或写入操作，那么self也会被捕获，从而导致循环引用的问题。为了避免循环引用，可以在块内部使用__weak修饰符来避免对self进行保留操作。
    
    //把block变量作为局部变量，在一定范围内使用
    

}

// Blocks 变量作为本地变量
- (void)useBlockAsLocalVariable {
    void (^myLocalBlock)(void) = ^{
        NSLog(@"useBlockAsLocalVariable");
    };
    myLocalBlock();
}
//作为带有 property声明的成员变量，（nonatomic， copy）返回值类型（^变量名）（参数列表）
//类似于delegate实现block回调

- (void)useBlockAsProperty {
    self.myProBlock = ^{
        NSLog(@"useBlockAsProperty");
    };
    self.myProBlock();
}
// Blocks 变量作为 OC 方法参数
- (void)someMethodThatTakesABlock:(void (^)(NSString *)) block {
    
    block(@"someMethodThatTakesABlock:");
}
//调用含有block参数的方法
- (void)useblockAsMethodparameter {
    [self someMethodThatTakesABlock:^(NSString *str) {
        NSLog(@"%@", str);
    }];
    NSLog(@"after");
}
//block变量的循环引用，以及如何避免
//从上文中我们知道 Block 会对引用的局部变量进行持有。同样，如果 Block 也会对引用的对象进行持有，从而会导致相互持有，引起循环引用。
//person *person = [[person alloc] init];
//person.blk = ^{
//NSLog(@"%@", person);
//
//}
//在ARC下，通过__weak修饰符来消除循环引用
/*
 在 ARC 下，可声明附有 __weak 修饰符的变量，并将对象赋值使用。
 int main() {
     Person *person = [[Person alloc] init];
     __weak typeof(person) weakPerson = person;
     person.blk = ^{
         NSLog(@"%@",weakPerson);
     };
     return 0;
 }
 这样，通过 __weak，person 持有成员变量 myBlock blk，而 blk 对 person 进行弱引用，从而就消除了循环引用。
 MRC 下，是不支持 weak 修饰符的。但是我们可以通过 block 来消除循环引用。
 int main() {
     Person *person = [[Person alloc] init];
     __block typeof(person) blockPerson = person;
     person.blk = ^{
         NSLog(@"%@", blockPerson);
     };
     return 0;
 }
 通过 __block 引用的 blockPerson，是通过指针的方式来访问 person，而没有对 person 进行强引用，所以不会造成循环引用。

 */
@end
