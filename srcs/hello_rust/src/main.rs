fn main() {
	// let a: () = {};
	// fn return_tuple() {}
	// let b: () = return_tuple();
	// assert_eq!(a, b);
	// match std::fs::File::open("foo.txt") {
	// 	Ok(file) => println!("file: {:?}", file),
	// 	Err(err) => panic!("open failed: {:?}", err),
	// }
	let s: String = "hello world".to_string();

	// 字符串分片(slice) - 另一个字符串的不可变视图
	// 基本上就是指向一个字符串的不可变指针，它不包含字符串里任何内容，只是一个指向某个东西的指针
	// 比如这里就是 `s`
	let s_slice: &str = &s;

	println!("{} {}", s, s_slice);

	// 变长数组 (vector)
	let mut vector: Vec<i32> = vec![1, 2, 3, 4];
	vector.push(5);

	// 分片 - 某个数组(vector/array)的不可变视图
	// 和字符串分片基本一样，只不过是针对数组的
	let slice: &[i32] = &vector;

	// 使用 `{:?}` 按调试样式输出
	println!("{:?} {:?}", vector, slice); // [1, 2, 3, 4, 5] [1, 2, 3, 4, 5]

	let numbers = vec![1, 2, 3, 4, 5];

	// 使用切片引用获取部分元素
	let slice: &[i32] = &numbers[1..4];
	println!("切片: {:?}", slice);

	struct Point {
		x: i32,
		y: i32,
	}

	let _origin: Point = Point { x: 0, y: 0 };

	// 泛型 (Generics) //
	struct Foo<T> {
		bar: T,
	}

	impl<T> Foo<T> {
		// 方法需要一个显式的 `self` 参数
		fn get_bar(self) -> T {
			self.bar
		}
	}

	let a_foo = Foo { bar: 1 };
	println!("{}", a_foo.get_bar()); // 1
}
