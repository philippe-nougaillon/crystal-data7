class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def a_propos
  end
end
