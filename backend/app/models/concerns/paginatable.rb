module Paginatable
    extend ActiveSupport::Concern

    included do
         scope :paginate, ->(page,per_page) {
        page = page.to_i >= 1? page.to_i : 1
        per_page = per_page.to_i >= 1 ? per_page.to_i : 20 
        
        offset((page-1)*per_page).limit(per_page)
  }
    end
end