class SpreeSolrSearchHooks < Spree::ThemeSupport::HookListener
  
  insert_after :sidebar, 'products/facets'
  insert_before :search_results, 'products/suggestion'
  
end
