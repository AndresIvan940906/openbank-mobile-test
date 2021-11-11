# Openbank-Mobile-Test / Marvel API Implementation
App to show Information about Marvel Characters (Character list, detail, comics Etc)
** The project has implemented the Libraries using Swift Package Manager. ensure those packages are already fetched before building the project
## Items Implemented
- Frameworks and Libraries (Eg. Alamofire)
- Error handling
- API calls concurrence
- Unit Tests
- Data caching
## Technical choices

Architecture Pattern: MVVM using RxSwift(Reactive programming) and coordinators, the reason to choose them is mainly
the good synergy that  MVVM has with RxSwift or in general with the reactive programming approach, given the reactive programming
allows an easy way to communicate between the View model and the view controller using observables, observers, subjects, etc. 
also the Rx declarative way is easy to maintain, modify and scale and is near to the new way to build UI  on IOS (Swift UI + Combine).
Related to the coordinators this approach allows easy control and modifying of the navigation flow of our application

Service Layer(API Calls): Implemented with Moya and RxSwift. moya is a  network abstraction layer that uses Alamofire
to call the requests, with the Rx implementation is easy the communication between the View model and the API Manager 
to return parsed models according to the endpoint. the API manager contains a generic request call method that returns 
the requested object if it can parse it.

Parse model: The way chosen to parse the data from the API calls was codable because is the native way to 
Decode / Encode information.

Save information on cache: Implemented using the Moya / Alamofire set up to do it because is easy to set up and handle, 
also because the saved data size is not big


