angular.module 'scValidation', []
.directive 'scValidation', ->
	restrict: 'A'
	require: ['ngModel', '^form']
	link: (scope, element, attrs, ctrls) ->
		[ngModel, ngForm] = ctrls
		
		if (_funcs = scope.$eval attrs.scValidation)?
			if _funcs.$validators then angular.extend ngModel.$validators, _funcs.$validators
			if _funcs.$asyncValidators then angular.extend ngModel.$asyncValidators, _funcs.$asyncValidators
			if _funcs.$validatorsWatch then scope.$watch _funcs.$validatorsWatch.key or _funcs.$validatorsWatch, ngModel.$validate, _funcs.$validatorsWatch.deep
			if _funcs.$formatters then ngModel.$formatters.push _format for _format in _funcs.$formatters
		
		if attrs.name then ngModel.$name = attrs.name
		else ngModel.$name = attrs.ngModel.replace /[^a-zA-Z0-9]/g, '_'
		
		if not ngModel.$options then ngModel.$$setOptions
			allowInvalid: true
			updateOnDefault: true
		else ngModel.$options.allowInvalid = ngModel.$options.allowInvalid ? true
		
		scope.$watch attrs.ngModel, ngModel.$validate, true
		
		ngForm.$addControl ngModel
		
		scope.$on '$destroy', -> ngForm.$removeControl ngModel