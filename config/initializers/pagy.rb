Pagy::DEFAULT[:items] = 3 # items per page
Pagy::DEFAULT[:size]  = [1, 1, 1, 1] # nav bar links
# Better user experience handled automatically
require 'pagy/extras/overflow'
Pagy::DEFAULT[:overflow] = :last_page
