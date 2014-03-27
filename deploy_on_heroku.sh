RAILS_ENV=production
# Pre-Compile assets for production
bundle exec rake assets:precompile
# Commit Assets to GITHUB
git add public/assets
git commit -m "Adding compiled assets for heroku deployment"
# push to GITHUB
git push
# push to HEROKU
git push heroku master
# Reset database
heroku run rake db:reset
heroku restart
