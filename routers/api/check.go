package api

import "fmt"

// goroutine控制多线程
func GoroutineTest() {
	// 1.创建一个无缓冲的通道
	ch := make(chan int)
	// 2.创建一个匿名函数
	go func() {
		// 3.在匿名函数中，向通道中写入数据
		ch <- 1
	}()
	// 4.在主线程中，从通道中读取数据
	a := <-ch
	fmt.Println(a)
}

// channel缓存通道样例
func ChannelTest() {
	// 1.创建一个有缓冲的通道
	ch := make(chan int, 1)
	// 2.向通道中写入数据
	ch <- 1
	// 3.从通道中读取数据
	a := <-ch
	fmt.Println(a)
}

// BubbleSort 冒泡排序
func BubbleSort(arr []int) {
	for i := 0; i < len(arr)-1; i++ {
		for j := 0; j < len(arr)-1-i; j++ {
			if arr[j] > arr[j+1] {
				arr[j], arr[j+1] = arr[j+1], arr[j]
			}
		}
	}
}

// SelectSort 选择排序
func SelectSort(arr []int) {
	for i := 0; i < len(arr)-1; i++ {
		min := i
		for j := i + 1; j < len(arr); j++ {
			if arr[j] < arr[min] {
				min = j
			}
		}
		arr[i], arr[min] = arr[min], arr[i]
	}
}

// InsertSort 插入排序
func InsertSort(arr []int) {
	for i := 1; i < len(arr); i++ {
		for j := i; j > 0; j-- {
			if arr[j] < arr[j-1] {
				arr[j], arr[j-1] = arr[j-1], arr[j]
			} else {
				break
			}
		}
	}
}
