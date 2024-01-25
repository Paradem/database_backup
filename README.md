# DatabaseBackup
This is a simple plugin that will give your application some jobs that will
backup a postgres database.

## Requirements 
You must have the `postgresql-client` installed on the machine that is going to
run the jobs. A job runner is also needed that can support scheduling tasks.
GoodJob works so the usage uses that as an example.

## Usage

Currently most of our applications only need to have one application server
running. So I setup a Procfile with good_job running monitoring either a queue
that is low resource intensive or a queue that will not execute any jobs.  Then
I check to only enable the cron scheduler on the app group in fly.io.  An
alternate way would be to run another process in your fly instance with a small
server that just runs the scheduler.

On the application server I'm using overmind to run the rails server as well as
the good_job process.

This example is also using digital ocean spaces. 

The jobs that are configured in this plugin run on the backup queue.  The
system that is going to run the queue needs to have enough memory to run the
good_job process as well as have the database in memory as the `BackupJob`
reads the full gziped version of the database into memory and then sends it to
the bucket.

### Environment variables that you need

SPACES_KEY
SPACES_SECRET
DOMAIN
REGION
BACKUP_BUCKET

```ruby
  config.good_job.enable_cron = (ENV["FLY_PROCESS_GROUP"] == "app")
  config.good_job.cron = {
    database_prune: {
      cron: "0 0 * * *",
      kwargs: {
        spaces_key: ENV["SPACES_KEY"],
        spaces_secret: ENV["SPACES_SECRET"],
        domain: ENV["DOMAIN"],
        region: ENV["REGION"],
        bucket: ENV["BACKUP_BUCKET"],
        endpoint: "https://#{ENV["REGION"]}.digitaloceanspaces.com"
      },
      class: "DatabaseBackup::PruneJob",
      description: "Clear out backups over 30 days old"
    },
    database_backup: {
      cron: "0 * * * *",
      kwargs: {
        database_url: ENV.fetch("DATABASE_URL", nil),
        database_backup_path: ENV.fetch("DATABASE_BACKUP_PATH", "tmp/"),
        spaces_key: ENV["SPACES_KEY"],
        spaces_secret: ENV["SPACES_SECRET"],
        domain: ENV["DOMAIN"],
        endpoint: "https://#{ENV["REGION"]}.digitaloceanspaces.com",
        region: ENV["REGION"],
        bucket: ENV["BACKUP_BUCKET"]
      },
      class: "DatabaseBackup::BackupJob",
      description: "This job runs the backup of the database"
    }
  }
```

## Installation
Add this line to your application's Gemfile:

```ruby
gem "database_backup"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install database_backup
```

## Production config
If you are going to use overmind to run the cron server you can install it in
the Dockerfile with this command.
```dockerfile
RUN wget -q -O - https://github.com/DarthSim/overmind/releases/download/v2.4.0/overmind-v2.4.0-linux-amd64.gz | gunzip > /bin/overmind && \
    chmod +x /bin/overmind
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
