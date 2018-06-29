
<!DOCTYPE html>
<html ng-app="myApp">
<head lang="en">
    <meta charset="UTF-8">
    <title>Login Page</title>
	<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.3/angular.min.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.3/angular-route.js"></script>
    <script>
    var myData;
        var myApp=angular.module("myApp",['ngRoute']);
        
        myApp.controller("myController",function ($scope,$http,$location)
        {
        	
            $scope.myData={};
            $scope.myData.username="";
            $scope.myData.password="";
            //$scope.myData.personName="naveen";
            //$scope.myData.status="false";
        
            $scope.myData.verify=function (){
                var response=$http.post("/LoginTask/verify",$scope.myData);
                response.success(function (data,status,header,config) {
                	
                    $scope.myData.personName = data.personName;
                    $scope.myData.status = data.status;
                    myData = $scope.myData;
                    
                   	if(data.status)
                    $location.path('/success');
                   	else
                   	$location.path('/')
                   
                    
                });
                response.error(function (data,status,header,config) {
                    alert("AJAX Failed");
                });
            }
        });
       
        myApp.controller("successController",function ($scope) {
        	
       		$scope.myData=myData;
      
        	
        });
        
		myApp.controller("failureController",function ($scope) {
        	
       		$scope.myData=myData;
      
        	
        });
        
        
        myApp.config(function($routeProvider) {
            alert("inside");
 			$routeProvider.when('/',{
            	
            	templateUrl: 'resources/jsp/LoginForm.jsp',
            	controller: 'myController'
            })
            .when('/success', {

                templateUrl: 'resources/jsp/LoginSuccess.jsp',
                controller: 'successController'

            })
 			.when('/failure', {
 				templateUrl: 'LoginFailure.jsp',
 				controller: 'failureController'
 				
 			});
           
        });
    </script>
</head>
<body>
<div ng-view>
</div>

 
</body>
</html>