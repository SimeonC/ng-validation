scValidation
===========

This directive is a easy way to add very complex custom validations to a form via ng-model without having to create a custom directive for each.

## Requirements

1. `AngularJS` ≥ `1.3.x`


### Where to get it

**Via Bower:**

Run `bower install sc-validation` from the command line.
Include script tags similar to the following:
```html
<script src='/bower_components/sc-validation/dist/sc-validation.js'></script>
```

**Via Github**

Download the code from [https://github.com/simeonc/sc-validation/releases/latest](https://github.com/simeonc/sc-validation/releases/latest), unzip the files then add script tags similar to the following:
```html
<link rel='stylesheet' href='/path/to/unzipped/files/sc-validation/dist/sc-validation.css'>
<script src='/path/to/unzipped/files/sc-validation/dist/sc-validation.js'></script>
```

### Usage

1. Include `sc-validation.js`
2. Add a dependency to `scValidation` in your app module, for example: ```angular.module('myModule', ['scValidation'])```.
3. Add the `sc-validation` attribute alongside a `ng-model` and within an `ng-form`

### sc-validation options

The `sc-validation` attribute requires an object reference on the current scope. This object can contain any of the following keys:

* **$validators** *{object}* An object of validators that are used to extend the `ngModel.$validators` object. See [$validators](https://docs.angularjs.org/api/ng/type/ngModel.NgModelController#$validators).
* **$asyncValidators** *{object}* An object of asyncValidators that are used to extend the `ngModel.$asyncValidators` object. See [$asyncValidators](https://docs.angularjs.org/api/ng/type/ngModel.NgModelController#$asyncValidators).
* **$formatters** *[formatters]* An array of formatters that are transferred by reference onto the `ngModel.$formatters` array. See [$formatters](https://docs.angularjs.org/api/ng/type/ngModel.NgModelController#$formatters).
* **$validatorsWatch** *"key" or {key: "key", deep: boolean}* This is used to force the validation to run when the key value on the scope changes. `scope.$watch($validatorsWatch.key || $validatorsWatch, ngModel.$validate, $validatorsWatch.deep)`

### Examples

Some example uses are (assume all of these are in a form and will set the form invalid/valid):

#### 1. Make an array in an ng-repeat require at least two elements.

```html
	<div ng-show="form.$errors.listlen">The List Requires at least 2 values</div>
	<div ng-repeat="row in rows" ng-model="rows" sc-validation="rowValidator">...</div>
```
```js
$scope.rowValidator = {
	$validators: {
		listlen: function(value){ return value && value.length > 2; }
	}
};
```

#### 2. Matching Password Inputs

```html
	<div ng-show="form.$errors.passwordmatch">The passwords must match</div>
	<input ng-model="newpassword" sc-validation="newvalidator">
	<input ng-model="confirmpassword" sc-validation="confirmvalidator">
```
```js
$scope.newvalidator = {
	$validatorsWatch: 'confirmpassword', // Update this validation whenever the other field updates
	$validators: {
		passwordmatch: function(value){
			return (!value && !$scope.confirmpassword) || value === $scope.confirmpassword;
		}
	}
};
$scope.confirmvalidator = {
	$validatorsWatch: 'newpassword', // Update this validation whenever the other field updates
	$validators: {
		passwordmatch: function(value){
			return (!value && !$scope.newpassword) || value === $scope.newpassword;
		}
	}
};
```

### Issues?

It has been tested to work on Chrome, Safari, Opera, Firefox and Internet Explorer 8+.
If you find something, please let me know - throw me a message, or submit a issue request!

## Developer Notes

When checking out, you need a node.js installation, running `npm install` will get you setup with everything to run the compile and unit tests tasks (Coming Soon!).
All changes should be done in the lib folder, running `gulp compile` to compile the app or use `gulp watch` to compile the files as you save them.
Read the CONTRIBUTING.md file before starting a PR.

## License

This project is licensed under the [MIT license](http://opensource.org/licenses/MIT).


## Contributers

Special thanks to all the contributions thus far! 

For a full list see: https://github.com/simeonc/sc-validation/graphs/contributors
