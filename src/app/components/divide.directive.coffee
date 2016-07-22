angular.module 'huffman'
  .directive 'divide', ->
    restrict: 'E'
    templateUrl: 'app/components/divide.directive.html'
    controller: ($scope) ->
      $scope.obj = {}
