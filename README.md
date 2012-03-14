Moymir
===========

Provides a set of classes, methods, and helpers to ease development of Moymir applications with Rails.

Installation
------------

In order to install Moymir you should add it to your Gemfile:

    gem 'moymir'

Usage
-----

**Accessing Current User**

Current Moymir user data can be accessed using the ```current_moymir_user``` method:

    class UsersController < ApplicationController
      def profile
        @user = User.find_by_social_id(current_moymir_user.uid)
      end
    end

This method is also accessible as a view helper.

**Application Configuration**

In order to use Moymir you should set a default configuration for your application. The config file should be placed at RAILS_ROOT/config/moymir.yml

Sample config file:

    development:
      app_id: ...
      private_key: ...
      secret_key: ...
      namespace: your-app-namespace
      callback_domain: yourdomain.com

    test:
      app_id: ...
      private_key: ...
      secret_key: ...
      namespace: test
      callback_domain: callback.url
