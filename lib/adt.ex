defmodule Adt do

  
  # This will convert one name into a bunch of different functions, namely:
  # 
  # - one that returns the atom version
  # - one returns a string version
  # - one that returns a question version (checking to see if it matches the atom)
  defp convert_to_funcs(name) do
    name? = String.to_atom("#{name}?")
    name_str = String.to_atom("#{name}_str")

    quote do 
      def unquote(name)(),               do: unquote(name)
      def unquote(name_str)(),           do: Atom._to_string unquote(name)
      def unquote(name?)(unquote(name)), do: true
      def unquote(name?)(_),             do: false
    end
  end

  #@doc "A form that belongs in adt_case. It's a replacement for normal case"
  #defmacro is(type, do: body) do
  #  quote do
  #     unquote(type): fn -> unquote(body),
  #  end
  #end

  #  @doc "safe version of case?"
  #defmacro adt_case(adt, do: body) do
  #
  #  if body, do
  #    raise "Pattern matching is not exhaustive"
  #  end
  #end


  @doc """
  This will define an ADT. Basically this is an option type that
  only allow a set amount of options.
  
  # Example

  ```
  defadt :bool, [:true, :false]
  ```

  will create the following functions:
  - bool? 
  - true?
  - true (returns an atom)
  - true_str
  - false? (checks against an atom)
  - etc.....

  """
  defmacro defadt(option_name, options) do

    if options == [] do
      raise "I was expecting at least a few items in the list for the options"
    end

    funcs = Enum.map(options, &convert_to_funcs/1)

    option_name? = String.to_atom("#{option_name}?")

    quote do
      def unquote(option_name)() do
        unquote(options)
      end

      def unquote(option_name?)(item) do
        Enum.find(unquote(options), &(item == &1)) != nil
      end

      unquote(funcs)
    end
  end
end

