/*
	@license sc-validation
	@author SimeonC
	@license 2015 MIT
	@version 0.0.2
	
	See README.md for requirements and use.
*/angular.module('scValidation', []).directive('scValidation', function() {
  return {
    restrict: 'A',
    require: ['ngModel', '^form'],
    link: function(scope, element, attrs, ctrls) {
      var _format, _funcs, i, len, ngForm, ngModel, ref, ref1;
      ngModel = ctrls[0], ngForm = ctrls[1];
      if ((_funcs = scope.$eval(attrs.scValidation)) != null) {
        if (_funcs.$validators) {
          angular.extend(ngModel.$validators, _funcs.$validators);
        }
        if (_funcs.$asyncValidators) {
          angular.extend(ngModel.$asyncValidators, _funcs.$asyncValidators);
        }
        if (_funcs.$validatorsWatch) {
          scope.$watch(_funcs.$validatorsWatch.key || _funcs.$validatorsWatch, ngModel.$validate, _funcs.$validatorsWatch.deep);
        }
        if (_funcs.$formatters) {
          ref = _funcs.$formatters;
          for (i = 0, len = ref.length; i < len; i++) {
            _format = ref[i];
            ngModel.$formatters.push(_format);
          }
        }
      }
      if (attrs.name) {
        ngModel.$name = attrs.name;
      } else {
        ngModel.$name = attrs.ngModel.replace(/[^a-zA-Z0-9]/g, '_');
      }
      if (!ngModel.$options) {
        ngModel.$$setOptions({
          allowInvalid: true,
          updateOnDefault: true
        });
      } else {
        ngModel.$options.allowInvalid = (ref1 = ngModel.$options.allowInvalid) != null ? ref1 : true;
      }
      scope.$watch(attrs.ngModel, ngModel.$validate, true);
      ngForm.$addControl(ngModel);
      return scope.$on('$destroy', function() {
        return ngForm.$removeControl(ngModel);
      });
    }
  };
});
