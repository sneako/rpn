defmodule Rpn do
  @moduledoc """
  This module is a Reverse Polish Notation Calculator
  https://en.wikipedia.org/wiki/Reverse_Polish_notation
  """

  def start do
    Agent.start(fn -> [] end)
  end

  def peek(pid) do
    Agent.get(pid, &calculate/1)
  end

  def push(pid, val) do
    Agent.update(pid, fn(current) -> current ++ [val] end)
  end

  defp calculate(stack) do
    stack
    |> Enum.reduce([], fn(val, acc) ->
      case val do
        :+ ->
          do_operation(acc, &(&1 + &2))
        :- ->
          do_operation(acc, &(&2 - &1))
        :x ->
          do_operation(acc, &(&1 * &2))
        _ ->
          [val | acc]
      end
    end)
  end

  defp do_operation(list, fun) do
    [x | tail] = list
    [y | remaining] = tail
    new_val = fun.(x, y)
    [new_val | remaining]
  end


end

