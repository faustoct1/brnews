#!/usr/bin/env rackup
# encoding: utf-8

# This file can be used to start Padrino,
# just execute it from the command line.
require File.expand_path("../config/boot.rb", __FILE__)

run Padrino.application

require 'rack/session/moneta'
uri = URI.parse(ENV["REDISTOGO_URL"].nil? ? "" : ENV["REDISTOGO_URL"])
use Rack::Session::Moneta, key: 'rack.session', store: Moneta.new(:Redis, host: uri.host, port: uri.port, password: uri.password, expires: false)
#expire_after: 0
