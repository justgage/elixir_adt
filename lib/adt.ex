defmodule Adt do

  @doc """
  This will turn an expresison like: 

    a | b | c | ... | z 

  into a list of atoms like so:

  [:a, :b, :c, ..., :z]

  """
  def into_list(nil), do: []
  def into_list({:|, _nothing, [{a, _, _} | [b]]}) do
    [a |  into_list(b)]
  end
  def into_list({a, _, _}) do
    [a]
  end
  def into_list([]) do
    []
  end
  def into_list(other) do
    IO.puts """
    ERROR: There was an unexpected symbol in the syntax of this ADT

    These should look like: `defadt do: a | b | c` with nothing else
    """
    IO.inspect other
    nil
  end

  def convert_to_funcs(name) do
    name? = String.to_atom("#{name}?")
    name_str = String.to_atom("#{name}_str")

    quote do 
      def unquote(name)(), do: unquote(name)
      def unquote(name_str)(), do: Atom._to_string unquote(name)
      def unquote(name?)(unquote(name)), do: true
      def unquote(name?)(_), do: false
    end
  end

  defmacro defadt(option_name, options) do

    if options == [] do
      raise "I was expecting at least a few items in the list for the options"
    end

    funcs = Enum.map(options, &convert_to_funcs/1)

    option_name? = String.to_atom("#{option_name}?")

    quote do
      def unquote(option_name?)(item) do
        Enum.find(unquote(options), &(item == &1)) != nil
      end

      unquote(funcs)
    end
  end
end

