import Foundation
import RxSwift

example(of: "just, of, from") {
    let one = 1
    let two = 2
    let three = 3
    
    let _ = Observable<Int>.just(one)
    let _ = Observable.of(one, two, three)
    let _ = Observable.of([one, two, three])
    let _ = Observable.from([one, two, three])
}

example(of: "subscribe") {
    let one = 1
    let two = 2
    let three = 3
    
    let observable = Observable.of(one, two, three)
    
    observable.subscribe(onNext: { element in
        print(element)
    })
}

example(of: "empty") {
    let observable = Observable<Void>.empty()
    observable.subscribe(
        onNext: { element in
            print(element)
        },
        onCompleted: {
            print("Completed")
        })
}

example(of: "never") {
    let observable = Observable<Any>.never()
    observable.subscribe(
        onNext: { element in
            print(element)
        },
        onCompleted: {
            print("Completed")
        })
}

example(of: "range") {
    let observable = Observable<Int>.range(start: 1, count: 10)
    observable
        .subscribe(onNext: { i in
            let n = Double(i)
            let fibonacci = Int(((pow(1.61803, n) - pow(0.61803, n)) / 2.23606).rounded())
            print(fibonacci)
        })
}

example(of: "dispose") {
    let observable = Observable.of("A", "B", "C")
    let subscription = observable.subscribe { event in
        print(event)
    }
    subscription.dispose()
}

example(of: "DisposeBag") {
    let disposeBag = DisposeBag()
    Observable.of("A", "B", "C")
        .subscribe {
            print($0)
        }
        .disposed(by: disposeBag)
}

example(of: "create") {
    enum MyError: Error {
        case anError
    }
    let disposeBag = DisposeBag()
    Observable<String>.create { observer in
        observer.onNext("1")
        //observer.onError(MyError.anError)
        // 2
        //observer.onCompleted()
        // 3
        observer.onNext("?")
        // 4
        return Disposables.create()
    }
    .subscribe(
        onNext: { print($0) },
        onError: { print($0) },
        onCompleted: { print("Completed") },
        onDisposed: { print("Disposed") }
    )
    .disposed(by: disposeBag)
}

example(of: "deferred") {
    let disposeBag = DisposeBag()
    var flip = false
    let factory: Observable<Int> = Observable.deferred {
        flip.toggle()
        if flip {
            return Observable.of(1, 2, 3)
        } else {
            return Observable.of(4, 5, 6)
        }
    }
    
    for _ in 0...3 {
        factory.subscribe(onNext: {
            print($0, terminator: "")
        })
        .disposed(by: disposeBag)
        print()
    }
}

example(of: "Single") {
    // 1 - Create a dispose bag to use later
    let disposeBag = DisposeBag()
    // 2 - Define an Error enum to model some possible errors that can occur in reading data from a file on disk.
    enum FileReadError: Error {
        case fileNotFound, unreadable, encodingFailed
    }
    // 3 -  Implement a function to load text from a file on disk that returns a Single.
    func loadText(from name: String) -> Single<String> {
        // 4 - Create and return a Single.
        return Single.create { single in
            // 1 - The subscribe closure of the create method must return a disposable (Option-click on create to see this for yourself ), so you create one here that you'll return at various points.
            let disposable = Disposables.create()
            
            // 2 - Get the path for the filename, or else add a file not found error onto the Single and return the disposable you created.
            guard let path = Bundle.main.path(forResource: name, ofType: "txt") else {
                single(.error(FileReadError.fileNotFound))
                return disposable
            }
            
            // 3 - Get the data from the file at that path, or add an unreadable error onto the Single and return the disposable.
            guard let data = FileManager.default.contents(atPath: path) else {
                single(.error(FileReadError.unreadable))
                return disposable
            }
            
            // 4 - Convert the data to a string; otherwise, add an encoding failed error onto the Single and return the disposable. Starting to see a pattern here?
            guard let contents = String(data: data, encoding: .utf8) else {
                single(.error(FileReadError.encodingFailed))
                return disposable
            }
            
            // 5 - Made it this far? Add the contents onto the Single as a success, and return the disposable.
            single(.success(contents))
            return disposable
        }
    }
    
    // 1 - Call loadText(from:), passing the root name of the text file.
    loadText(from: "Copyright")
        // 2 - Subscribe to the Single it returns.
        .subscribe {
            // 3 - Switch on the event, printing the string if it was successful, or printing the error if not.
            switch $0 {
            case .success(let string):
                print(string)
            case .error(let error):
                print(error)
            }
    }
    .disposed(by: disposeBag)
}




//MARK: - CHALLENGE 1

example(of: "Challenge 1: Perform side effects") {
    let observable = Observable<Any>.never()
    let disposeBag = DisposeBag()
    
    observable
        .do(onSubscribe: {
            print("Subscribed")
        })
        .subscribe(
            onNext: { element in
                print(element)
            },
            onCompleted: {
                print("Completed")
            },
            onDisposed: {
                print("Disposed")
            }
        )
        .disposed(by: disposeBag)
}


//MARK: - CHALLENGE 2

example(of: "Challenge 2: Print debug info") {
    let observable = Observable<Any>.never()
    let disposeBag = DisposeBag()
    
    observable
        .debug("observable")
        .subscribe(
            onNext: { element in
                print(element)
            },
            onCompleted: {
                print("Completed")
            },
            onDisposed: {
                print("Disposed")
            }
        )
        .disposed(by: disposeBag)
}

/*:
 Copyright (c) 2019 Razeware LLC
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 distribute, sublicense, create a derivative work, and/or sell copies of the
 Software in any work that is designed, intended, or marketed for pedagogical or
 instructional purposes related to programming, coding, application development,
 or information technology.  Permission for such use, copying, modification,
 merger, publication, distribution, sublicensing, creation of derivative works,
 or sale is expressly withheld.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */
