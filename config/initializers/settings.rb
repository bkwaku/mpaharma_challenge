# frozen_string_literal: true

require 'configatron'

configatron.api.versions = %w[v1.0]
configatron.api.latest_version = -> { configatron.api.versions.last }
configatron.api.exposed_versions_for = ->(version) { configatron.api.versions.drop_while { |el| el != version } }