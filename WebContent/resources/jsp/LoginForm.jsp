<div>
    <form>
       <label>User Name : </label><input type="text" ng-model="myData.username" /><br>
        <label>Password : </label><input type="password" ng-model="myData.password" /><br>
        <button type="submit" value="Login" ng-click="myData.verify()" >Login</button>
    </form>
</div>