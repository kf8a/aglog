require 'dhaka'

class AreaGrammar < Dhaka::Grammar
  
  for_symbol(Dhaka::START_SYMBOL_NAME) do
    start ['Area']
  end

  for_symbol('Area') do
    treatments ['T']
    replicate ['R']
  en
end