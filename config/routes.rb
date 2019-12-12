Rails.application.routes.draw do
  put 'remove-backup' => 'backups#remove_backup'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
