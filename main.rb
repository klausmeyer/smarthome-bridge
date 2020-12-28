require_relative 'config/environment'

$stdout.sync = true
App.logger = Logger.new($stdout)

app = App.new
app.run(loop: true)

RubyHome.run
