Rails.application.routes.draw do
  mount DatabaseBackup::Engine => "/database_backup"
end
