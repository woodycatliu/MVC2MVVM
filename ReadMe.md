## MVC To MVVM In Swift (Swift5.3 UIKit)
就我所認識的 iOS 開發者中，絕大多數第一次接觸的是 MVC 架構。  
在轉換過程中，時常會陷入" 這樣寫有沒有符合 MVVM " 的困惑，有幸的是在這個過程中，我有一群一起學習的夥伴能一起討論一起找解答。

> 開始之前，建議先閱讀維基百科[**MVVM**](https://zh.wikipedia.org/wiki/MVVM) 的介紹    
> 此篇將專注於 UIKit 框架下 MVVM 的討論

**優點：**  

- 資料轉換與畫面分離，解決MVC不利於 ***`View`*** 與 ***`Model`*** 耦合問題。
- ***`ViewController`*** 專注於繁重的Event與其互動
- 資料轉換的解耦， ***`ViewController`*** 更易於 Reuse
- 學習成本低  
 
**缺點：**

- 更多的物件與數據傳遞，代價也更大。
- 設計成本大  
  
  
--
### 概念
MVVM 其實並不難，它是一種概念，簡單點就是把與View顯示沒有直接關係的邏輯移出 ViewController，一股腦全丟進 ViewModel也不算錯 ，當然也能找個適合的設計模式打包，剩下的就是傳值那檔事情。而每個人對 MVVM的解讀都不一樣，分離的程度也不盡相同。  

**目的**  
1. 建立一個管道/獨立接口 ***`ViewModel`*** 將資料從 ***`Model`*** 傳遞給 ***`View`*** 。  
2. 將事件所要做的資料轉型從 ***`ViewController`*** 中分離出來，一定程度的減少其所承擔的責任。

**圖片來源: objc.io App 架構**  
<img src="https://github.com/woodycatliu/MVC2MVVM/blob/main/Resource/MVVM%E9%97%9C%E8%81%AF%E5%9C%96.png" width="300" height="300" />  


> ***開始之前*** 可以先下載 [**範例**](https://github.com/woodycatliu/MVC2MVVM)  
> 使用 git 檢查 comit 點


***Point:***  

```    
  - 範例紀錄一個簡單的 VC 從 MVC 到 MVVM 。 
  - 畫面是不存在的，範例忽略了UI 的刻畫邏輯。 
  - 為了降低學習曲線，Binding 部分將為以 delegate 與 didSet 做為替代

```

--------
### 開始著手改造
```  
class MVCViewController: UIViewController {
    private var list: [DataModel] = []
    private lazy var tableView: UITableView = {...}()
}
```
MVCViewController 帶有一個 UITableView ，與少量的數據顯示邏輯。
對於開發與重構的開始，我一般建議從 Model 與其接口開始。  
而該專案的 API Model 已經建立好獨立的接口，所以我們只要處理 ViewModel 與 Model 的溝通。

#### 第一步： 建立ViewModel (Tag: Step-1)  

  - 暫存 ***`View`*** 所需的資料  
  - 從 ***`Model`*** 存取所需的資料  
  - 修改/移除 ***`MVCViewController`*** 對應的代碼  

```
class ViewModel {
      var list: [DataModel] = []
      
      func fetchData() {
        APIEngine.shared.fetchFoo(req: Request<[DataModel]>()) {
         [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                self.list = result.value ?? []
            case .failure(let error):
                // do something
                print(error)
            }
        }
    }
}
```

#### 第二步： tableView 與 ViewModel 的溝通 (Tag: Step-2) 

與 UITableView 的互動，我習慣仿照 TableViewDataSource 的 API 建立較為 Reuse 的 interface。  

- 建立 TableViewModelProtocol  
- ***`ViewModel`*** 遵循 TableViewModelProtocol  
- 修改 MVCViewController  

```
protocol TableViewModelProtocol {
    associatedtype DataModelForCell
    var numbersOfSection: Int { get }
    func numberOfRowsInSection(_ section: Int)-> Int
    func dataModelFoRowAt(_ indexPath: IndexPath)-> DataModelForCell
}
```  
  
#### 第三步： View 與 數據的 Binding (Tag: Step-3) 
MVVM 與 MVP 差異點主要在於 ViewModel 與 View 之間的操作是連動的，
而會用 "Binding" 的技術讓 View與數據榜定，已達到想應式的資料的傳遞。  
但是 Swift 在 iOS 13 以前沒有原生的響應式框架，所以 list 的傳遞將會以代理模式與didSet 達成類似的效果。  

- 建立 delegate Protocol
- ***`ViewModel`*** 與 ViewController 實現 delegate 的聯繫。

```
protocol DataModelsUpdateProtocol: AnyObject {
    func updatedDataModels()
    func updateDataModel(_ index: Int)
}
extension DataModelsUpdateProtocol {
    func updateDataModel(_ index: Int) {}
}
```

#### 第四步： 處理Error (Tag: Step-4)   
現實生活中難免會產生一些錯誤問題，程式設計自然也需要顧慮到這一塊。  

-   建立處理 APIError 的 Protocol
-   調整一下 delegate

```
protocol APIErrorHandleProtocol: AnyObject {
    func handleHandle(_ error: APIError)
}
typealias ViewModelDelegateProtocol = DataModelsUpdateProtocol&APIErrorHandleProtocol

class ViewModel {
    weak var delegate: ViewModelDelegateProtocol?
```

#### 第五步：Cell ViewModel (Tag: Step-5)   
還有些不完美，Cell 所需的 image 需要額外取得。  
因為 image 的取得與 VC 與 TableView 沒有直接關係，所以理想上我會為 Cell 再建立一層 ViewModel 。  

- 建立 fetchImageProtocol
- 建立 CellViewModel
- 榜定

```
protocol ImageViewFetchViewModelProtocol: AnyObject {
    typealias ConfigureImageView = (UIImage?)->()
    var imageUrlString: String? { get set }
    var configureImageView: ConfigureImageView? { get set }
    func fetchImage(_ urlString: String?, defaultImg: UIImage?)
}

extension ImageViewFetchViewModelProtocol {  
    func fetchImage(_ urlString: String?, defaultImg: UIImage?) {
        guard let urlString = urlString else {
            return
        }
        APIEngine.shared.fetchImg(urlString: urlString, defaultImg: defaultImg) {
            [weak self] img in
            guard self?.imageUrlString == urlString else { return }
            self?.configureImageView?(img)
        }
    }

```



##### 對於 ***`UIKit`*** 與 ***`Combine`*** 結合的 MVVM有興趣的話可以參考我另一個範例專案[***MVVM_SampleCode***](https://github.com/woodycatliu/MVVM_SampleCode)

