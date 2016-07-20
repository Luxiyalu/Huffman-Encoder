angular.module 'huffman'
  .controller 'MainController', ($scope) ->
    
    constructDataObj = (cha, fre) -> cha: cha, fre: fre
    mergeIntoTreeBranch = (lObj, rObj) ->
      return {
        cha: lObj.cha+rObj.cha
        fre: lObj.fre+rObj.fre
        children: [lObj, rObj]
      }
    
    $scope.encode = (text = $scope.text) ->
      arr = text.split('')
      frequency = _.countBy(arr)
      frequencyArr = _.map frequency, (fre, cha) -> constructDataObj(cha, fre)
      tree = constructTreeObj(frequencyArr)
      
      $scope.codeToChar = {}
      $scope.charToCode = {}
      mapCodeFromTree(tree)
      
      codeArr = _.map arr, (cha) -> $scope.charToCode[cha]
      $scope.code = codeArr.join('')
      
    constructTreeObj = (arr) ->
      if arr.length == 1 then return arr[0] # the end result should be an object
      sorted = _.sortBy(arr, 'fre') # sort array from low to high
      # combine the lowest/first 2
      a = sorted.shift()
      b = sorted.shift()
      newElement = mergeIntoTreeBranch(a, b)
      sorted.push(newElement)
      return constructTreeObj(sorted)
    
    mapCodeFromTree = (tree) ->
      walkTheTree = (tree, code) ->
        if !tree.children?
          cha = tree.cha
          $scope.charToCode[cha] = code
          $scope.codeToChar[code] = cha
        else
          walkTheTree(tree.children[0], code+'0')
          walkTheTree(tree.children[1], code+'1')
          
      walkTheTree(tree, '')
      
    # upon entering decoder:
    $scope.pushPairToDict = (char = "", code = "") ->
      $scope.dictArr.push(char: char, code: code)
      
    $scope.dictArr = []
    $scope.pushPairToDict()
    
    $scope.decode = ->
      
      recDecode = (textToDecode, textDecoded) ->
        if textToDecode.length == 0
          return textDecoded
        
        match = _.find $scope.dictArr, (pair) ->
          text = textToDecode.slice(0, pair.code.length)
          return text == pair.code
        
        if !match
          return console.log 'Values error'
        
        textToDecode = textToDecode.slice(match.code.length)
        textDecoded = textDecoded + match.char
        return recDecode(textToDecode, textDecoded)
        
      $scope.textDecoded = recDecode($scope.encodedText, "")
      
    $scope.removePair = (i) ->
      $scope.dictArr.splice(i, 1)
      
    ## testing:
    # encode:
    # 
    # $scope.encode('bbac  cc')
    # console.log $scope
    # 
    # decode:
    # $scope.encodedText = "0011"
    # $scope.pushPairToDict('a', '00')
    # $scope.pushPairToDict('b', '11')
    # $scope.decode()
    
    return
