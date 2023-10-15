defmodule ArvoreBin do
 #criar estrutura arvore
  defstruct chave: nil, val: nil, esq: nil, dir: nil, x: nil, y: nil
  #criando arvore vazia
  def create_node(chave, val) do
     %ArvoreBin{chave: chave, val: val}
  end

  def insert_node(nil, chave, val) do
    create_node(chave, val)
  end

  def insert_node( %ArvoreBin{} = node, chave, val) do
    if val < node.val do
       %ArvoreBin{node | esq: insert_node(node.esq, chave, val)}
    else
       %ArvoreBin{node | dir: insert_node(node.dir, chave, val)}
    end
  end

  def print_tree(nil), do: nil

  def print_tree(%ArvoreBin{} = tree) do
    print_tree(tree.esq)
    IO.puts "Node - chave: #{tree.chave}, Value: #{tree.val}, Coordenada X: #{tree.x}, Coordenada Y: #{tree.y} "
    print_tree(tree.dir)
  end


  def rootX(%ArvoreBin{} = tree, leftlim, scale) do
    case {is_nil(tree.esq), is_nil(tree.dir)} do
      {false, false} ->
        {r1, rightlim} = rootX(tree.esq, leftlim, scale)
        {r2, rightlim2} = rootX(tree.dir, scale + rightlim, scale)
        r = (r1 + r2) / 2
        {r, rightlim2}

      {false, true} ->
        {r1, rightlim} = rootX(tree.esq, leftlim, scale)
        {r1, rightlim}

      {true, false} ->
        {r1, rightlim} = rootX(tree.dir, leftlim, scale)
        {r1, rightlim}

      _ ->
        r = leftlim
        rightlim = leftlim
        {r, rightlim}
      end
  end

  def buscaprofundidade2(%ArvoreBin{} = tree, level, leftlim, scale, replica) do
    case {is_nil(tree.esq), is_nil(tree.dir)} do
      {true, true} ->
        x = leftlim
        rightlim = leftlim
        y = scale * level
        {x, rightlim, %ArvoreBin{chave: tree.chave, val: tree.val, esq: nil, dir: nil, x: x, y: y}}

      {false, true} ->
        {x, rightlim} = rootX(tree, leftlim, scale)
        {_r1, _lixo, replica_left} = buscaprofundidade2(tree.esq, level + 1, leftlim, scale, replica)
        y = scale * level
        {x, rightlim, %ArvoreBin{chave: tree.chave, val: tree.val, esq: replica_left, dir: nil, x: x, y: y }}

      {true, false} ->
        {x, rightlim} = rootX(tree, leftlim, scale)
        {_r1, _lixo, replica_right} = buscaprofundidade2(tree.dir, level + 1, leftlim, scale, replica)
        y = scale * level
        {x, rightlim, %ArvoreBin{chave: tree.chave, val: tree.val, esq: nil, dir: replica_right, x: x, y: y }}

      {false, false} ->
        y = scale * level
        {r1, lrightlim, replica_left} = buscaprofundidade2(tree.esq, level + 1, leftlim, scale, replica)
        rleftlim = lrightlim + scale
        {r2, rightlim, replica_right} = buscaprofundidade2(tree.dir, level + 1, rleftlim, scale, replica)
        x = (r1 + r2)/2
        {x, rightlim, %ArvoreBin{chave: tree.chave, val: tree.val, esq: replica_left, dir: replica_right, x: x, y: y }}
    end
  end

end



#aqui a arvore de exemplo do livro
#resumimos os codigos diferentes do livro nas funcoes buscaprofundidade2 e rootX, que ja fazem todo o trabalho

tree =
 ArvoreBin.create_node("A", 111)
  |> ArvoreBin.insert_node("B" , 55)
  |> ArvoreBin.insert_node("X" , 100)
  |> ArvoreBin.insert_node("Z" , 56 )
  |> ArvoreBin.insert_node("W" , 23 )
  |> ArvoreBin.insert_node("Y" , 105)
  |> ArvoreBin.insert_node("R" , 77)
  |> ArvoreBin.insert_node("C" , 123)
  |> ArvoreBin.insert_node("D" , 119)
  |> ArvoreBin.insert_node("G" , 44 )
  |> ArvoreBin.insert_node("H" , 50 )
  |> ArvoreBin.insert_node("I" , 5 )
  |> ArvoreBin.insert_node("J" , 6 )
  |> ArvoreBin.insert_node("E" , 133 )

{_lixo1, _lixo2, replica_tree} = ArvoreBin.buscaprofundidade2(tree, 0, 1, 30, nil)

ArvoreBin.print_tree(replica_tree)
