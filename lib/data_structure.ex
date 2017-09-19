defmodule DataStructure do 

  #fold left 
  def foldl(_, acc, []), do: acc
  def foldl(f, acc, [h|t]) do 
    foldl(f, f.(acc, h), t)
  end
  
  # fold right
  def foldr(_, acc, []), do: acc
  def foldr(f, acc, [h|t]) do
    f.(h, foldr(f, acc, t))
  end

  # drop n first character of list
  def drop([], _), do: []
  def drop(l, 0), do: l
  def drop([_ | t], n), do: drop(t, n-1)

  # dropwhile . while match, drop it
  def dropWhile([], _), do: []
  def dropWhile([h | t], f) do 
    if f.(h) do
      dropWhile(t, f)
    else 
      [h | dropWhile(t,f)]
    end
  end

  # reverse
  def reverse([]), do: []
  def reverse([h | t]), do: reverse(t) ++ [h]
  
  # reverse using fold 
  def reverseWithFold(l), do: foldl(fn(acc, x) -> [x | acc] end, [], l)
end
