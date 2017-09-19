defmodule DataStructureTest do 
  use ExUnit.Case 

  alias DataStructure, as: Ds
  
  # test fold left
  test "sum foldLeft" do
    assert Ds.foldl(&(&1 + &2), 0 , [1, 2, 3]) == 6
  end
  
  # test fold right
  test "sum foldright" do 
    assert Ds.foldr(fn(x, y) -> x + y end, 0, [1, 2, 3]) == 6
  end

  # test drop empty list 
  test "test drop empty list" do 
    assert Ds.drop([], 2) == []
  end

  test "drop 0 elmt" do 
    assert Ds.drop([1, 2], 0) == [1, 2]
  end

  test "drop 2 elmt" do
    assert Ds.drop([1, 2, 3], 2) == [3]
  end

  test "drop 3 elmt" do
    assert Ds.drop([1, 2], 3) == []
  end

  # test drop while
  test "drop while" do 
    assert Ds.dropWhile([1, 2, 3, 4, 2], &(&1 == 2)) == [1, 3, 4]
  end

  test "reverse" do 
    assert Ds.reverse([1, 2, 3, 4, 5]) == [5, 4, 3, 2, 1]
  end

  test "reverse with fold" do 
    assert Ds.reverseWithFold([1, 2, 3, 4, 5]) == [5, 4, 3, 2, 1]
  end
end
