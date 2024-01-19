require "test_helper"

class DatabaseBackupTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert DatabaseBackup::VERSION
  end
end
