require "aws-sdk-s3"

module DatabaseBackup
  class BackupJob < ApplicationJob
    queue_as :backup

    def perform(
      database_url:,
      spaces_key:,
      spaces_secret:,
      domain:,
      bucket:,
      endpoint:,
      region:,
      prefix: nil
    )

      file_name =
        [prefix, "database", Time.zone.now.iso8601].compact.join("_") << ".sql"

      backup_file = File.join("/tmp", file_name)

      sql_cmd = %(/usr/bin/pg_dump -c -O "#{database_url}" > #{backup_file})
      system(sql_cmd, exception: true)

      gzip_cmd = "gzip #{backup_file}"
      system(gzip_cmd, exception: true)

      client = Aws::S3::Client.new(
        access_key_id: spaces_key,
        secret_access_key: spaces_secret,
        endpoint:,
        force_path_style: false,
        region:
      )

      client.put_object({
        bucket:,
        key: "#{domain}/#{file_name}.gz",
        body: IO.binread("#{backup_file}.gz"),
        acl: "private"
      })

      FileUtils.rm_f(backup_file)
    end
  end
end
