defmodule LanguageList do
  def new() do
    []
  end

  def add(list, language) do
    [language | list]
  end

  def remove(list) do
    case list do
      [] -> []
      [_ | rest] -> rest
    end
  end

  def first(list) do
    case list do
      [first | _] -> first
    end
  end

  def count(list) do
    do_count(list, 0)
  end
  def do_count(list, res) do
    case list do
      [] -> res
      [_ | rest] -> do_count(rest, res + 1)
    end
  end

  def functional_list?(list) do
    case list do
      [] -> false
      ["Elixir" | rest] -> true
      [_ | rest] -> functional_list?(rest)
    end
  end
end
