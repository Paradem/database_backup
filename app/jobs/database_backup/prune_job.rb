require "aws-sdk-s3"

module DatabaseBackup
  class PruneJob < ApplicationJob
    queue_as :backup

    def perform(
      spaces_key:,
      spaces_secret:,
      domain:,
      region:,
      bucket:,
      endpoint:
    )
      client = Aws::S3::Client.new(
        access_key_id: spaces_key,
        secret_access_key: spaces_secret,
        endpoint:,
        force_path_style: false,
        region:
      )

      threshold_date = Time.now - 30.days

      objects = client.list_objects(bucket:, prefix: domain).contents

      objects.each do |obj|
        last_modified = obj.last_modified
        if last_modified < threshold_date
          client.delete_object(bucket: space_name, key: obj.key)
        end
      end
    end
  end
end
