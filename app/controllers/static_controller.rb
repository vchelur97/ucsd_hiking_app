class StaticController < ApplicationController
  skip_before_action :no_access!, :signed_waiver!, :added_phone_number!
end
