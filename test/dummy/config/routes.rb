Rails.application.routes.draw do
  mount Reporter::Engine => "/reporter"
end
