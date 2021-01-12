### Travel Tracker ###
This gem hosts a web application that allows users to keep track of past vacations and their favorite moments. It allows users to sign-up or login with a unique email before choosing to add a new vacation, view/edit/delete an existing vacation or to logout. A new vacation will consist of at least a title and date but can also include a location and description. The application has full error functionality for incorrect inputs and encrypts all user passwords before storing data.

## Installation ##
Add these lines to your application's Gemfile:

gem 'sinatra'
gem 'activerecord', '~> 4.2', '>= 4.2.6', :require => 'active_record'
gem 'sinatra-activerecord', :require => 'sinatra/activerecord'
gem 'rake'
gem 'require_all'
gem 'sqlite3', '~> 1.3.6'
gem 'thin'
gem 'shotgun'
gem 'pry'
gem 'bcrypt'
gem 'tux'
And then execute:

$ bundle install
## Usage ##
Launch with:

shotgun

Access via:

Browser: http://localhost:9393/


## Development ##
Add these additional lines to gemfile:

group :test do
  gem 'rspec'
  gem 'capybara'
  gem 'rack-test'
  gem 'database_cleaner', git: 'https://github.com/bmabey/database_cleaner.git'
end

Enter 'tux' into console to interact with databases and experiment with functionality.

## Contributing ##
Bug reports and pull requests are welcome on GitHub at https://github.com/Hunter-Kolasa/TravelTracker. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the code of conduct.

License
The gem is available as open source under the terms of the MIT License.

Code of Conduct
Everyone interacting in the Exoplanets project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the code of conduct.
